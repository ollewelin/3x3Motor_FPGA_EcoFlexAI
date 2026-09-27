// mipi_raw_capture.sv
// Simple raw DPHY byte capture to BRAM, then send via ETH TX
//
// Operation (3-state ping-pong):
//   1. WAIT:    Wait for long LP gap (inter-frame), then LP→HS = new frame
//   2. CAPTURE: Record raw HS bytes from both lanes into BRAM (interleaved D0,D1)
//              Skip LP gaps between lines, stop on long LP gap (frame end) or BRAM full
//   3. SEND:    Enable ETH TX to read BRAM and send via UDP (pulse reset to start at addr 0)
//              After timeout → back to WAIT
//
// BRAM word packing (32-bit, 2 byte-clock cycles):
//   [7:0]   = D0 from cycle 0
//   [15:8]  = D1 from cycle 0
//   [23:16] = D0 from cycle 1
//   [31:24] = D1 from cycle 1
//
// ETH TX byte order: D0_0, D1_0, D0_1, D1_1, ... (reconstructs 2-lane CSI-2 byte stream)

module mipi_raw_capture (
    input  wire        clk,              // PLL_125MHZ system clock
    input  wire        rst_n,            // Active-low reset

    // DPHY signals (directly from top-level ports)
    input  wire        cam_clk_clkout,   // Recovered byte clock from DPHY
    input  wire [7:0]  cam_d0_hs_in,     // Lane 0: 8-bit deserialized HS data
    input  wire        cam_d0_lp_p,      // Lane 0: LP+ state
    input  wire        cam_d0_lp_n,      // Lane 0: LP- state
    input  wire [7:0]  cam_d1_hs_in,     // Lane 1: 8-bit deserialized HS data
    input  wire        cam_d1_lp_p,      // Lane 1: LP+ state
    input  wire        cam_d1_lp_n,      // Lane 1: LP- state

    // BRAM write port (word-addressed, 32-bit)
    output reg  [15:0] bram_wr_addr,     // Word address (0-16383)
    output reg  [31:0] bram_wr_data,     // 32-bit packed data
    output reg         bram_wr_en,       // Write enable

    // Control outputs
    output wire        sending,          // 1 = ETH TX should read BRAM, 0 = capturing/idle
    output wire        eth_rst_pulse,    // 1-cycle pulse to reset ETH TX (resets bram_rd_addr to 0)
    output reg  [15:0] captured_words    // Number of 32-bit words captured in current frame
);

    // =========================================================================
    // 2-stage synchronizers (DPHY signals are async to PLL_125MHZ)
    // =========================================================================
    reg [2:0] clkout_sync;               // 3 stages for edge detection
    reg [1:0] d0_lp_p_sync, d0_lp_n_sync;
    reg [1:0] d1_lp_p_sync, d1_lp_n_sync;
    reg [7:0] d0_hs_s1, d0_hs_s2;
    reg [7:0] d1_hs_s1, d1_hs_s2;

    always @(posedge clk) begin
        clkout_sync  <= {clkout_sync[1:0], cam_clk_clkout};
        d0_lp_p_sync <= {d0_lp_p_sync[0], cam_d0_lp_p};
        d0_lp_n_sync <= {d0_lp_n_sync[0], cam_d0_lp_n};
        d1_lp_p_sync <= {d1_lp_p_sync[0], cam_d1_lp_p};
        d1_lp_n_sync <= {d1_lp_n_sync[0], cam_d1_lp_n};
        d0_hs_s1     <= cam_d0_hs_in;  d0_hs_s2 <= d0_hs_s1;
        d1_hs_s1     <= cam_d1_hs_in;  d1_hs_s2 <= d1_hs_s1;
    end

    // Synchronized signals
    wire byte_clk_rise = clkout_sync[1] && !clkout_sync[2];
    wire d0_in_hs = (!d0_lp_p_sync[1] && !d0_lp_n_sync[1]);
    wire d1_in_hs = (!d1_lp_p_sync[1] && !d1_lp_n_sync[1]); // available for future use
    wire [7:0] d0_hs = d0_hs_s2;
    wire [7:0] d1_hs = d1_hs_s2;

    // =========================================================================
    // State machine
    // =========================================================================
    localparam S_WAIT = 2'd0;   // Wait for frame start (long LP gap → LP→HS)
    localparam S_CAP  = 2'd1;   // Capturing HS bytes into BRAM
    localparam S_SEND = 2'd2;   // ETH TX reads and sends BRAM contents

    reg [1:0]  state;
    reg [19:0] lp_gap_cnt;             // Clocks spent in LP state
    reg [22:0] send_timer;             // Countdown for send phase
    reg        byte_phase;             // 0 = first 16 bits, 1 = second 16 bits → write
    reg [15:0] pack_lo;               // First 16 bits {D1, D0} from byte_phase=0
    reg        d0_was_in_hs;           // Previous HS state for edge detection
    reg        eth_rst_r;              // ETH TX reset pulse register
    reg [7:0]  d0_hs_prev;            // Previous D0 value for change detection

    // Long LP gap threshold: ~400µs at 125MHz → frame boundary
    // Between-line gaps are typically <10µs; between-frame gaps are >1ms
    localparam LP_GAP_FRAME = 20'd50_000;

    // Send phase duration: 50ms at 125MHz (enough for ETH TX to send ~44 packets = 64KB)
    localparam SEND_TIME = 23'd6_250_000;

    // Max BRAM word address (16384 words × 4 bytes = 64KB)
    localparam BRAM_MAX_WORDS = 16'd16383;

    assign sending = (state == S_SEND);
    assign eth_rst_pulse = eth_rst_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= S_WAIT;
            bram_wr_addr   <= 16'd0;
            bram_wr_data   <= 32'd0;
            bram_wr_en     <= 1'b0;
            captured_words <= 16'd0;
            lp_gap_cnt     <= 20'd0;
            send_timer     <= 23'd0;
            byte_phase     <= 1'b0;
            pack_lo        <= 16'd0;
            d0_was_in_hs   <= 1'b0;
            eth_rst_r      <= 1'b0;
            d0_hs_prev     <= 8'd0;
        end else begin
            bram_wr_en  <= 1'b0;    // default: no write
            eth_rst_r   <= 1'b0;    // default: no reset pulse
            d0_was_in_hs <= d0_in_hs;
            d0_hs_prev   <= d0_hs;

            case (state)

            // ---- Wait for new frame (long LP gap then fresh LP→HS) ----
            S_WAIT: begin
                if (!d0_in_hs) begin
                    // In LP mode: count gap duration
                    if (lp_gap_cnt < LP_GAP_FRAME)
                        lp_gap_cnt <= lp_gap_cnt + 1;
                end else if (!d0_was_in_hs) begin
                    // LP→HS transition detected
                    if (lp_gap_cnt >= LP_GAP_FRAME) begin
                        // Long gap preceded this → frame start!
                        state          <= S_CAP;
                        bram_wr_addr   <= 16'd0;
                        captured_words <= 16'd0;
                        byte_phase     <= 1'b0;
                        lp_gap_cnt     <= 20'd0;
                    end else begin
                        // Short gap → mid-frame burst, keep waiting
                        lp_gap_cnt <= 20'd0;
                    end
                end
            end

            // ---- Capture HS bytes into BRAM ----
            S_CAP: begin
                if (!d0_in_hs) begin
                    // LP gap during capture (between CSI-2 packets / lines)
                    lp_gap_cnt <= lp_gap_cnt + 1;

                    if (lp_gap_cnt >= LP_GAP_FRAME) begin
                        // Long LP gap = frame ended
                        // Flush partial 32-bit word if we have one
                        if (byte_phase) begin
                            bram_wr_data   <= {16'h0000, pack_lo};
                            bram_wr_en     <= 1'b1;
                            captured_words <= captured_words + 1;
                        end
                        // Transition to SEND
                        state      <= S_SEND;
                        send_timer <= SEND_TIME;
                        eth_rst_r  <= 1'b1;   // pulse: reset ETH TX read addr to 0
                    end
                end else begin
                    lp_gap_cnt <= 20'd0;   // reset gap counter while in HS

                    // In non-FIFO mode, the HS_IN data changes with the
                    // recovered byte clock. Sample on byte_clk_rise.
                    // If byte clock isn't reliable, fall back to change-detect.
                    // We capture whenever the data changes OR byte_clk_rise,
                    // whichever fires. This handles both FIFO and non-FIFO modes.
                    //if (byte_clk_rise || (d0_hs != d0_hs_prev)) begin
                    if (byte_clk_rise) begin
                        if (!byte_phase) begin
                            // First half: store {D1, D0} as lower 16 bits
                            pack_lo    <= {d1_hs, d0_hs};
                            byte_phase <= 1'b1;
                        end else begin
                            // Second half: combine and write full 32-bit word
                            bram_wr_data   <= {d1_hs, d0_hs, pack_lo};
                            bram_wr_en     <= 1'b1;
                            bram_wr_addr   <= bram_wr_addr + 1;
                            captured_words <= captured_words + 1;
                            byte_phase     <= 1'b0;

                            // BRAM full → stop capture, start sending
                            if (bram_wr_addr >= BRAM_MAX_WORDS) begin
                                state      <= S_SEND;
                                send_timer <= SEND_TIME;
                                eth_rst_r  <= 1'b1;
                            end
                        end
                    end
                end
            end

            // ---- Send phase: ETH TX reads BRAM ----
            S_SEND: begin
                if (send_timer > 0)
                    send_timer <= send_timer - 1;
                else begin
                    state      <= S_WAIT;
                    lp_gap_cnt <= 20'd0;
                end
            end

            default: state <= S_WAIT;

            endcase
        end
    end

endmodule
