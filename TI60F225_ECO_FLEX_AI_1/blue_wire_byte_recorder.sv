// =============================================================================
// blue_wire_byte_recorder.sv
// =============================================================================
// Test module: captures one full frame from the blue-wire video bus, stores it
// in local BRAM, then dumps all bytes via standalone_uart_tx (115200 baud) in
// "S" + ASCII-hex format (same protocol as record_frame_bram_counted.vhd).
//
// Blue-wire bus protocol:
//   - vid_frame_sync_n: LOW during an entire frame stream, HIGH between frames
//   - vid_clk falling edge = sample byte on vid_d (center of data eye)
//   - A gap of <4 vid_clk cycles between bytes marks a line boundary
//     (frame boundaries are NOT timed from vid_clk — use vid_frame_sync_n)
//
// After dump finishes, the module re-arms and captures again.
// It may miss many frames — that's fine; it captures when it can.
// =============================================================================
`timescale 1ns / 1ps

module blue_wire_byte_recorder #(
    parameter int CLOCK_HZ   = 60_000_000,  // sys_clk used for UART baud
    parameter int BAUD       = 115200,
    parameter int WIDTH_PIX  = 224,          // pixels per line
    parameter int HEIGHT_LINES = 224         // lines per frame
) (
    input  wire        sys_clk,   // System clock (80 MHz) for UART + dump FSM
    input  wire        rst_n,     // Active-low reset (sys_clk domain)

    // Blue-wire video bus inputs (from record_video)
    input  wire        vid_frame_sync_n, // LOW during frame stream, HIGH when idle
    input  wire        vid_clk,   // ~20 MHz byte clock
    input  wire [7:0]  vid_d,     // Video data byte

    // UART output
    output wire        txd,       // Serial TX line (goes to XB7)

    // Status
    output logic       frame_captured,  // Pulse when frame capture completes
    output logic       dumping          // High while UART dump in progress
);

// =============================================================================
// Constants
// =============================================================================
localparam int TOTAL_BYTES = WIDTH_PIX * HEIGHT_LINES;  // 50176

// Need address bits to index TOTAL_BYTES
localparam int ADDR_W = $clog2(TOTAL_BYTES);

// Line-gap detection: count consecutive sys_clk cycles without a vid_clk rise.
// vid_clk ~20 MHz, sys_clk 80 MHz  →  1 vid_clk period ≈ 4 sys_clk cycles.
// A gap of <4 vid_clk cycles ≈ <16 sys_clk ticks — use threshold of 12.
localparam int LINE_GAP_THRESHOLD = 12;  // sys_clk cycles ≈ <4 vid_clk periods

// =============================================================================
// Clock-domain crossing: sample vid_clk RISING edge in sys_clk domain,
// delayed by 1 extra sys_clk cycle compared to vid_d / vid_fsync.
// =============================================================================
// vid_d and vid_fsync use a 2-FF synchronizer (latency = 2 sys_clk).
// vid_clk uses a 4-FF chain; we detect the rising edge between q3 and q4
// (latency = 3 sys_clk).  This guarantees vid_d_q2 has been stable for at
// least 1 sys_clk cycle when the strobe fires, regardless of sys_clk freq.
// =============================================================================
logic vid_clk_q1, vid_clk_q2, vid_clk_q3, vid_clk_q4;
logic vid_clk_strobe;

always_ff @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) begin
        vid_clk_q1 <= 1'b0;
        vid_clk_q2 <= 1'b0;
        vid_clk_q3 <= 1'b0;
        vid_clk_q4 <= 1'b0;
    end else begin
        vid_clk_q1 <= vid_clk;
        vid_clk_q2 <= vid_clk_q1;
        vid_clk_q3 <= vid_clk_q2;
        vid_clk_q4 <= vid_clk_q3;
    end
end
assign vid_clk_strobe = vid_clk_q3 & ~vid_clk_q4;  // rising edge, 1 cycle after vid_d_q2 stable

// Capture vid_d one cycle aligned to vid_clk_q2 (same 2-FF delay)
logic [7:0] vid_d_q1, vid_d_q2;
always_ff @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) begin
        vid_d_q1 <= 8'd0;
        vid_d_q2 <= 8'd0;
    end else begin
        vid_d_q1 <= vid_d;
        vid_d_q2 <= vid_d_q1;
    end
end

// =============================================================================
// Clock-domain crossing: synchronize vid_frame_sync_n into sys_clk domain
// vid_frame_sync_n is driven from pll_clk_100Mhz domain; 2-FF synchronizer.
// =============================================================================
logic vid_fsync_q1, vid_fsync_q2;
always_ff @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) begin
        vid_fsync_q1 <= 1'b1;  // default: idle (HIGH)
        vid_fsync_q2 <= 1'b1;
    end else begin
        vid_fsync_q1 <= vid_frame_sync_n;
        vid_fsync_q2 <= vid_fsync_q1;
    end
end
// vid_fsync_sync: 1 = idle (between frames), 0 = frame stream active
wire vid_fsync_sync = vid_fsync_q2;

// =============================================================================
// Frame BRAM (byte-wide)
// =============================================================================
logic [7:0]       bram [0:TOTAL_BYTES-1];
logic [ADDR_W-1:0] wr_addr;
logic [ADDR_W-1:0] rd_addr;
logic [7:0]       rd_data;
logic             wr_en;

always_ff @(posedge sys_clk) begin
    if (wr_en)
        bram[wr_addr] <= vid_d_q2;
    rd_data <= bram[rd_addr];
end

// =============================================================================
// Line-gap counter — count sys_clk cycles without a vid_clk rise
// Used only for line-boundary detection (<4 vid_clk cycles gap = new line).
// NOT used for frame detection (vid_frame_sync_n handles that).
// =============================================================================
logic [7:0] gap_cnt;
always_ff @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n)
        gap_cnt <= '0;
    else if (vid_clk_strobe)
        gap_cnt <= '0;
    else if (gap_cnt < 8'hFF)
        gap_cnt <= gap_cnt + 1;
end

// line_gap: HIGH when no vid_clk strobe for LINE_GAP_THRESHOLD sys_clk cycles
logic line_gap;
assign line_gap = (gap_cnt >= LINE_GAP_THRESHOLD[7:0]);

// =============================================================================
// UART instance
// =============================================================================
logic       tx_start;
logic       tx_send_S;
logic [7:0] tx_data;
logic       tx_busy;
logic       tx_busy_q;

standalone_uart_tx #(
    .CLOCK_HZ (CLOCK_HZ),
    .BAUD     (BAUD)
) u_uart (
    .clk       (sys_clk),
    .rst_n     (rst_n),
    .tx_start  (tx_start),
    .tx_send_S (tx_send_S),
    .tx_data   (tx_data),
    .tx_busy   (tx_busy),
    .tx_busy_q (tx_busy_q),
    .txd       (txd)
);

// =============================================================================
// Main FSM (sys_clk domain)
// =============================================================================
typedef enum logic [2:0] {
    S_WAIT_FRAME,   // Wait for idle (vid_fsync_sync=1) then frame start (=0)
    S_CAPTURE,      // Capture bytes; end when vid_fsync_sync goes HIGH
    S_DUMP_KICK,    // Start UART dump: send 'S' header
    S_DUMP_WAIT_S,  // Wait for 'S' send to complete
    S_DUMP_DATA,    // Send all captured bytes as hex pairs
    S_DUMP_DONE     // Brief idle before re-arm
} state_t;

state_t st;
logic        kick_first;
logic [ADDR_W-1:0] dump_addr;
logic        fsync_armed;  // 1 once we've seen idle (vid_fsync_sync=1)

always_ff @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) begin
        st             <= S_WAIT_FRAME;
        wr_addr        <= '0;
        wr_en          <= 1'b0;
        rd_addr        <= '0;
        dump_addr      <= '0;
        tx_start       <= 1'b0;
        tx_send_S      <= 1'b0;
        tx_data        <= 8'd0;
        kick_first     <= 1'b0;
        frame_captured <= 1'b0;
        dumping        <= 1'b0;
        fsync_armed    <= 1'b0;
    end else begin
        tx_start       <= 1'b0;        // default: single-cycle strobe
        wr_en          <= 1'b0;
        frame_captured <= 1'b0;
        kick_first     <= 1'b0;

        case (st)

            // ------------------------------------------------------------------
            // Wait until vid_frame_sync_n is HIGH (idle between frames),
            // then wait for it to go LOW (new frame starting) → S_CAPTURE.
            // ------------------------------------------------------------------
            S_WAIT_FRAME: begin
                dumping     <= 1'b0;
                wr_addr     <= '0;
                if (vid_fsync_sync)           // saw idle period → arm
                    fsync_armed <= 1'b1;
                if (fsync_armed && !vid_fsync_sync) begin  // frame started
                    fsync_armed <= 1'b0;
                    st          <= S_CAPTURE;
                end
            end

            // ------------------------------------------------------------------
            // Capture bytes.  Each vid_clk_fall = one new byte.
            // Frame ends when TOTAL_BYTES have been captured (byte count,
            // not vid_frame_sync_n — sync_n can pulse mid-camera-frame).
            // ------------------------------------------------------------------
            S_CAPTURE: begin
                if (vid_clk_strobe) begin
                    if (wr_addr < TOTAL_BYTES[ADDR_W-1:0]) begin
                        wr_en   <= 1'b1;
                        wr_addr <= wr_addr + 1;
                    end
                end

                // Frame complete when all expected bytes captured
                if (wr_addr >= TOTAL_BYTES[ADDR_W-1:0]) begin
                    frame_captured <= 1'b1;
                    st             <= S_DUMP_KICK;
                end
            end

            // ------------------------------------------------------------------
            // Kick the UART dump: send 'S' header
            // ------------------------------------------------------------------
            S_DUMP_KICK: begin
                dumping    <= 1'b1;
                tx_start   <= 1'b1;
                tx_send_S  <= 1'b1;
                kick_first <= 1'b1;
                dump_addr  <= '0;
                rd_addr    <= '0;
                st         <= S_DUMP_WAIT_S;
            end

            // ------------------------------------------------------------------
            // Wait for 'S' to finish transmitting, then kick first data byte
            // ------------------------------------------------------------------
            S_DUMP_WAIT_S: begin
                // Detect tx_busy falling edge (busy_q=1, busy=0) after the 'S'
                if (tx_busy_q && !tx_busy) begin
                    // Immediately send first data byte (bram[0] already in rd_data)
                    tx_start  <= 1'b1;
                    tx_send_S <= 1'b0;
                    tx_data   <= rd_data;
                    if (dump_addr + 1 >= wr_addr) begin
                        st <= S_DUMP_DONE;         // single-byte edge case
                    end else begin
                        dump_addr <= dump_addr + 1; // = 1
                        rd_addr   <= dump_addr + 1; // preload bram[1]
                        st        <= S_DUMP_DATA;
                    end
                end
            end

            // ------------------------------------------------------------------
            // Dump all captured bytes as hex.
            // Each byte is tx_start'd when tx_busy falls, using rd_data from
            // previous cycle's rd_addr.
            // ------------------------------------------------------------------
            S_DUMP_DATA: begin
                if (tx_busy_q && !tx_busy) begin
                    // Send byte at dump_addr
                    tx_start  <= 1'b1;
                    tx_send_S <= 1'b0;
                    tx_data   <= rd_data;

                    if (dump_addr + 1 >= wr_addr) begin
                        // Last byte
                        st <= S_DUMP_DONE;
                    end else begin
                        dump_addr <= dump_addr + 1;
                        rd_addr   <= dump_addr + 1;
                    end
                end
            end

            // ------------------------------------------------------------------
            // Wait for last UART char to finish, then re-arm
            // ------------------------------------------------------------------
            S_DUMP_DONE: begin
                if (!tx_busy) begin
                    dumping <= 1'b0;
                    st      <= S_WAIT_FRAME;
                end
            end

            default: st <= S_WAIT_FRAME;
        endcase
    end
end

endmodule
