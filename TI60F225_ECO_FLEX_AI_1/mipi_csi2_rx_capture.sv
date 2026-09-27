// mipi_csi2_rx_capture.sv
// Captures one complete CSI-2 frame from csi2_rx_cam_b IP into BRAM,
// then signals the ETH TX to send the frame over UDP.
//
// Camera: IMX219, 96×96 pixels, RAW10 format, 2-lane CSI-2
//   Line payload  : 96 × 10-bit = 120 bytes
//   Frame payload : 120 × 96   = 11520 bytes = 1440 × 64-bit BRAM words
//
// Clock domains:
//   clk_pixel (PLL_100MHZ) — receives CSI-2 pixel data, writes to BRAM
//   clk_eth   (PLL_125MHZ) — drives ETH TX enable / rst signals
//
// CDC strategy:
//   pixel → eth  : toggle synchroniser (frame_done_toggle)
//   eth   → pixel: 2-stage synchroniser (sending_r)

`default_nettype none

module mipi_csi2_rx_capture (
    // ── Pixel clock domain (PLL_100MHZ) ────────────────────────────────────
    input  wire         clk_pixel,
    input  wire         rst_pixel_n,           // active-low reset

    // ── ETH clock domain (PLL_125MHZ) ──────────────────────────────────────
    input  wire         clk_eth,
    input  wire         rst_eth_n,             // active-low reset

    // ── CSI-2 pixel outputs from csi2_rx_cam_b (clk_pixel domain) ──────────
    input  wire [63:0]  pixel_data,            // 64-bit unpacked pixel data
    input  wire         pixel_data_valid,      // pixel_data valid this cycle
    input  wire         vsync,                 // high during active frame (vc0)

    // ── BRAM write port (clk_pixel domain, 64-bit words) ───────────────────
    output reg  [15:0]  bram_wr_addr,          // 64-bit word address (0-8191)
    output reg  [63:0]  bram_wr_data,          // write data
    output reg          bram_wr_en,            // write enable (1 cycle per word)

    // ── ETH TX control (clk_eth domain) ────────────────────────────────────
    output wire         sending,               // 1 = ETH TX active, 0 = idle
    output wire         eth_rst_pulse,         // 1-cycle pulse: reset ETH TX read addr

    // ── Debug (clk_pixel domain) ────────────────────────────────────────────
    output reg  [15:0]  captured_words         // number of 64-bit words written
);

    // =========================================================================
    // Pixel-domain state machine
    // =========================================================================
    localparam S_IDLE = 2'd0;   // wait for frame start (vsync rising edge)
    localparam S_CAP  = 2'd1;   // capturing frame pixels into BRAM
    localparam S_WAIT = 2'd2;   // waiting for ETH send phase to complete

    // Max BRAM address (64-bit words in 64 KB BRAM)
    localparam BRAM_MAX_ADDR = 16'd8191;

    reg [1:0] pix_state;
    reg       vsync_prev;

    // Toggle flag driven in pixel domain; synced into eth domain.
    // Flips each time a complete frame is ready for sending.
    reg       frame_done_toggle;

    // 2-stage sync of ETH-domain 'sending_r' back to pixel domain
    // Used to release S_WAIT once the send phase has finished.
    reg [1:0] sending_sync_pix;
    wire      sending_sync_pix_out = sending_sync_pix[1];

    always_ff @(posedge clk_pixel or negedge rst_pixel_n) begin
        if (!rst_pixel_n) begin
            pix_state         <= S_IDLE;
            vsync_prev        <= 1'b0;
            bram_wr_addr      <= 16'd0;
            bram_wr_data      <= 64'd0;
            bram_wr_en        <= 1'b0;
            captured_words    <= 16'd0;
            frame_done_toggle <= 1'b0;
        end else begin
            bram_wr_en <= 1'b0;      // default: no write
            vsync_prev <= vsync;

            case (pix_state)

            // ── Wait for vsync rising edge (frame start) ────────────────────
            S_IDLE: begin
                if (vsync && !vsync_prev) begin
                    pix_state      <= S_CAP;
                    bram_wr_addr   <= 16'd0;
                    captured_words <= 16'd0;
                end
            end

            // ── Capture pixels into BRAM ────────────────────────────────────
            S_CAP: begin
                // vsync falling edge = frame end (highest priority)
                if (!vsync && vsync_prev) begin
                    frame_done_toggle <= ~frame_done_toggle;
                    pix_state         <= S_WAIT;
                end else if (pixel_data_valid) begin
                    if (bram_wr_addr < BRAM_MAX_ADDR) begin
                        bram_wr_data   <= pixel_data;
                        bram_wr_en     <= 1'b1;
                        captured_words <= captured_words + 16'd1;
                        bram_wr_addr   <= bram_wr_addr + 16'd1;
                    end else begin
                        // BRAM full before frame end — stop and signal done
                        frame_done_toggle <= ~frame_done_toggle;
                        pix_state         <= S_WAIT;
                    end
                end
            end

            // ── Wait for ETH send phase to finish ───────────────────────────
            S_WAIT: begin
                // 'sending_sync_pix_out' is the CDC view of 'sending_r' from
                // the eth domain.  When it drops low the send phase is over.
                if (!sending_sync_pix_out) begin
                    pix_state <= S_IDLE;
                end
            end

            default: pix_state <= S_IDLE;
            endcase
        end
    end

    // =========================================================================
    // Pixel-domain: sync 'sending_r' (eth→pixel) for S_WAIT release
    // =========================================================================
    // 'sending_r' is a register in the eth clock domain (defined below).
    // We forward-declare it as a wire here so the always_ff can reference it.
    wire sending_r_wire;   // declared as wire, driven from eth-domain reg below

    always_ff @(posedge clk_pixel or negedge rst_pixel_n) begin
        if (!rst_pixel_n)
            sending_sync_pix <= 2'b0;
        else
            sending_sync_pix <= {sending_sync_pix[0], sending_r_wire};
    end

    // =========================================================================
    // CDC: frame_done_toggle (pixel → eth)
    // 3-stage synchroniser.  Edge detected as XOR of adjacent stages.
    // =========================================================================
    reg [2:0] frame_done_sync_eth;

    always_ff @(posedge clk_eth or negedge rst_eth_n) begin
        if (!rst_eth_n)
            frame_done_sync_eth <= 3'b0;
        else
            frame_done_sync_eth <= {frame_done_sync_eth[1:0], frame_done_toggle};
    end

    // Any toggle edge in the synced signal means a new frame is ready
    wire new_frame_eth = frame_done_sync_eth[2] ^ frame_done_sync_eth[1];

    // =========================================================================
    // ETH-domain send controller
    // =========================================================================
    // Send phase duration: 100 ms at 125 MHz.
    // This is long enough for the ETH TX module to send all UDP packets
    // (~18 packets of 1400-byte payload for a 64 KB BRAM).
    localparam SEND_TIME = 27'd12_500_000;   // 100 ms @ 125 MHz

    reg [26:0] send_timer;
    reg        sending_r;
    reg        eth_rst_r;

    always_ff @(posedge clk_eth or negedge rst_eth_n) begin
        if (!rst_eth_n) begin
            sending_r  <= 1'b0;
            send_timer <= 27'd0;
            eth_rst_r  <= 1'b0;
        end else begin
            eth_rst_r <= 1'b0;   // default: pulse cleared

            if (!sending_r) begin
                // Idle — arm on new-frame edge
                if (new_frame_eth) begin
                    sending_r  <= 1'b1;
                    send_timer <= SEND_TIME;
                    eth_rst_r  <= 1'b1;   // one-cycle pulse: resets ETH TX read addr
                end
            end else begin
                // Counting down — release at zero
                if (send_timer > 27'd0)
                    send_timer <= send_timer - 27'd1;
                else
                    sending_r <= 1'b0;
            end
        end
    end

    // Expose ETH control outputs
    assign sending         = sending_r;
    assign eth_rst_pulse   = eth_rst_r;
    assign sending_r_wire  = sending_r;   // used by pixel-domain sync above

endmodule

`default_nettype wire
