// =============================================================================
// record_video.sv  v2
// =============================================================================
// Three structurally independent always_ff blocks:
//
//   FSM_LC  (PRIORITY) — Line capture into ping-pong buffers
//           Writes RAW8 pixels from MIPI RX into line_ram_A / line_ram_B.
//           Asserts line_wr_done (1-cycle pulse) when one line is fully written.
//           Toggles line_sel ATOMICALLY with line_wr_done so the streamer
//           can compute the completed buffer as ~line_sel combinatorially.
//
//   FSM_VS  (PRIORITY) — Blue-wire video byte streamer
//           Reads completed line buffer, drives vid_clk / vid_d[7:0].
//           vid_clk stays LOW for LINE_GAP_CYCLES after each line and
//           FRAME_GAP_CYCLES after the last line of a frame.
//           CANNOT be stalled by or affect FSM_FR in any way.
//
//   FSM_FR  (BACKGROUND) — Full-frame block RAM recorder
//           Writes 64-bit MIPI beats into frame_ram[].
//           Reads ONLY: data64, valid, good_dt, vsync0_rise.
//           Writes NOTHING that FSM_LC or FSM_VS read.
//           May silently miss frames when RAM is full; never blocks priority path.
//
// Debug outputs (may be left unconnected):
//   throughput_overflow_error — sticky set when writer laps reading streamer
//   vid_frame_sync_n          — LOW during entire frame stream, HIGH during idle (inter-frame)
//
// =============================================================================
`timescale 1ns / 1ps

module record_video #(
    parameter int CLOCK_HZ        = 100_000_000,  // Fabric clock frequency (Hz)
    parameter int BLUE_BYTE_SPEED =  50_000_000,  // vid_clk target frequency (Hz)
    parameter int WIDTH_PIX       = 224,           // Image width  (RAW8 = 1 byte/pixel)
    parameter int HEIGHT_LINES    = 224,           // Image height (lines)
    parameter int PIXELS_PER_BEAT = 8,             // 64-bit bus → 8 RAW8 pixels / beat
    parameter int GAP_MIN_CYCLES  = 10            // Orignal 128 trimmed down to 10 Min VALID=0 cycles to delimit a line
) (
    // -------------------------------------------------------------------------
    // System
    // -------------------------------------------------------------------------
    input  wire         clk,
    input  wire         rst_n,        // Active LOW

    // -------------------------------------------------------------------------
    // MIPI RX fabric interface (64-bit parallel, RAW8)
    // -------------------------------------------------------------------------
    input  wire [63:0]  data64,
    input  wire         valid,
    input  wire [5:0]   dtype,        // 0x2A = RAW8, 0x2B = RAW10
    input  wire [3:0]   cnt,          // pixel count for this beat
    input  wire [3:0]   hsync,
    input  wire [3:0]   vsync,
    input  wire [17:0]  error_bus,

    // -------------------------------------------------------------------------
    // Blue-wire video bus
    // -------------------------------------------------------------------------
    output logic        vid_clk,      // Byte clock (~50 MHz)
    output logic [7:0]  vid_d,        // Video byte — left pixel first in time

    // -------------------------------------------------------------------------
    // Debug / analyzer hooks (safe to leave unconnected)
    // -------------------------------------------------------------------------
    output logic        throughput_overflow_error,  // sticky: line overrun detected
    output logic        vid_frame_sync_n,            // LOW during frame stream, HIGH during idle

    // -------------------------------------------------------------------------
    // Status
    // -------------------------------------------------------------------------
    output logic        capturing_o,
    output logic        done_o,
    output logic [15:0] line_idx_o,
    output logic [31:0] words_used_o
);

// =============================================================================
// Derived constants
// =============================================================================
function automatic int ceil_div_fn(int a, int b);
    return (a + b - 1) / b;
endfunction

localparam int BEATS_PER_LINE   = ceil_div_fn(WIDTH_PIX, PIXELS_PER_BEAT);
localparam int TOTAL_BEATS      = BEATS_PER_LINE * HEIGHT_LINES;

// vid_clk half-period in clk ticks (rounded nearest)
// Example: 100 MHz clk / (2 × 50 MHz) = 1 tick → vid_clk toggles every tick
localparam int VID_HALF         = (CLOCK_HZ + BLUE_BYTE_SPEED) / (2 * BLUE_BYTE_SPEED);

localparam int LINE_GAP_CYCLES  = 4;   // vid_clk LOW hold after each line
localparam int FRAME_GAP_CYCLES = 10;  // vid_clk LOW hold after last line (minimum)

// =============================================================================
// Memory declarations
// =============================================================================
// Full-frame BRAM (background path — large, inferred as block RAM)
logic [63:0] frame_ram  [0 : TOTAL_BEATS - 1];

// Ping-pong line buffers (priority path — small, 224 bytes each)
// Multiple writes per cycle from the for-loop → synthesised as LUT-RAM or FFs
logic [7:0]  line_ram_A [0 : WIDTH_PIX - 1];
logic [7:0]  line_ram_B [0 : WIDTH_PIX - 1];

// =============================================================================
// Shared combinatorial signals (read-only by all FSMs)
// =============================================================================
wire good_dt     = (dtype == 6'h2A) | (dtype == 6'h2B);  // RAW8 or RAW10

// vsync[0] rising-edge detector
logic vsync0_q;
wire  vsync0_rise = vsync[0] & ~vsync0_q;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) vsync0_q <= 1'b0;
    else        vsync0_q <= vsync[0];
end

// hsync[0] rising-edge detector
logic hsync0_q;
wire  hsync0_rise = hsync[0] & ~hsync0_q;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) hsync0_q <= 1'b0;
    else        hsync0_q <= hsync[0];
end

// =============================================================================
// ════════════════════════════════════════════════════════════════════════════
// PRIORITY PATH — blue-wire video bus (never blocked, never misses a frame)
// ════════════════════════════════════════════════════════════════════════════
//
// Ping-pong handshake convention:
//   line_sel          — which buffer FSM_LC is CURRENTLY writing
//   line_wr_done      — 1-cycle pulse asserted when a line write finishes
//   line_just_done_sel— combinatorial: ~line_sel (the buffer just completed)
//
// Why ~line_sel works: both line_wr_done and line_sel update on the SAME clock
// edge.  At the cycle when line_wr_done is observed HIGH, line_sel has ALREADY
// been toggled to point at the NEXT buffer.  So ~line_sel = old buffer = the
// one that was just completed.
// =============================================================================

logic line_sel;           // 0 = FSM_LC writing line_ram_A, 1 = writing line_ram_B
logic line_wr_done;       // 1-cycle pulse: a line write just finished
wire  line_just_done_sel = ~line_sel;  // combinatorial: identifies finished buffer

// ---------------------------------------------------------------------------
// FSM_LC — Line Capture  (PRIORITY)
// Writes pixels into line_ram_A or line_ram_B.
// Makes NO reference to frame_ram, fr_wr_addr, or any FSM_FR signal.
// ---------------------------------------------------------------------------
typedef enum logic [2:0] {
    LC_IDLE,
    LC_WAIT_VSYNC,
    LC_WAIT_FIRST_DATA,  // After vsync: wait for dtype=0x2A before capturing
    LC_CAP_LINE,
    LC_LINE_GAP,
    LC_FRAME_DONE
} lc_st_t;

lc_st_t      lc_st;
logic [15:0] lc_px;        // pixels received in current line (saturates at WIDTH_PIX)
logic [15:0] lc_wr_px;     // byte write index within current line buffer
logic [15:0] lc_gap;       // consecutive VALID=0 cycles seen after line fills
logic [15:0] lc_line_idx;  // current line index (0 … HEIGHT_LINES-1)

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lc_st        <= LC_IDLE;
        lc_px        <= '0;
        lc_wr_px     <= '0;
        lc_gap       <= '0;
        lc_line_idx  <= '0;
        line_sel     <= 1'b0;
        line_wr_done <= 1'b0;
    end else begin
        line_wr_done <= 1'b0;  // default: pulse off; set 1 only on line complete

        case (lc_st)

            // ------------------------------------------------------------------
            LC_IDLE: lc_st <= LC_WAIT_VSYNC;

            // ------------------------------------------------------------------
            LC_WAIT_VSYNC: begin
                if (vsync0_rise) begin
                    lc_px       <= '0;
                    lc_wr_px    <= '0;
                    lc_gap      <= '0;
                    lc_line_idx <= '0;
                    line_sel    <= 1'b0;   // first line → buffer A
                    lc_st       <= LC_WAIT_FIRST_DATA;
                end
            end

            // ------------------------------------------------------------------
            // Wait for first actual pixel data (dtype=0x2A/0x2B) after vsync.
            // Embedded data lines (dtype=0x12) and short packets are ignored.
            // lc_line_idx stays 0, no line_wr_done fires during this phase.
            LC_WAIT_FIRST_DATA: begin
                if (vsync0_rise) begin
                    // Another vsync while still waiting — restart
                    lc_px       <= '0;
                    lc_wr_px    <= '0;
                    lc_line_idx <= '0;
                    line_sel    <= 1'b0;
                end else if (valid && good_dt && cnt > 4'd0) begin
                    // First RAW8 beat arrived — capture it and start line capture
                    for (int b = 0; b < PIXELS_PER_BEAT; b++) begin
                        if (16'(b) < 16'(WIDTH_PIX)) begin
                            if (!line_sel)
                                line_ram_A[16'(b)] <= data64[b*8 +: 8];
                            else
                                line_ram_B[16'(b)] <= data64[b*8 +: 8];
                        end
                    end
                    lc_px    <= {12'b0, cnt};
                    lc_wr_px <= 16'(PIXELS_PER_BEAT);
                    lc_st    <= LC_CAP_LINE;
                end
            end

            // ------------------------------------------------------------------
            LC_CAP_LINE: begin
                // --- vsync override: highest priority, resets frame ---
                if (vsync0_rise) begin
                    if (lc_px >= 16'(WIDTH_PIX)) begin
                        line_wr_done <= 1'b1;
                        line_sel     <= ~line_sel;
                    end
                    lc_px       <= '0;
                    lc_wr_px    <= '0;
                    lc_gap      <= '0;
                    lc_line_idx <= '0;
                    lc_st       <= LC_WAIT_FIRST_DATA;
                end else begin
                    // Capture incoming RAW8 pixels into the active line buffer
                    if (valid && good_dt && cnt > 4'd0) begin
                        if (lc_px < 16'(WIDTH_PIX)) begin
                            for (int b = 0; b < PIXELS_PER_BEAT; b++) begin
                                if (lc_wr_px + 16'(b) < 16'(WIDTH_PIX)) begin
                                    if (!line_sel)
                                        line_ram_A[lc_wr_px + 16'(b)] <= data64[b*8 +: 8];
                                    else
                                        line_ram_B[lc_wr_px + 16'(b)] <= data64[b*8 +: 8];
                                end
                            end
                            lc_px    <= lc_px    + {12'b0, cnt};
                            lc_wr_px <= lc_wr_px + 16'(PIXELS_PER_BEAT);
                        end
                        lc_gap <= '0;   // any valid beat resets the gap timer
                    end else begin
                        if (lc_gap < 16'(GAP_MIN_CYCLES))
                            lc_gap <= lc_gap + 1;
                    end

                    // Line complete: enough pixels AND (HSYNC or gap-based boundary)
                    if (lc_px >= 16'(WIDTH_PIX) && (hsync0_rise || lc_gap >= 16'(GAP_MIN_CYCLES))) begin
                        line_wr_done <= 1'b1;
                        line_sel     <= ~line_sel;
                        lc_px        <= '0;
                        lc_wr_px     <= '0;
                        lc_gap       <= '0;
                        if (lc_line_idx + 1 >= 16'(HEIGHT_LINES)) begin
                            lc_st <= LC_FRAME_DONE;
                        end else begin
                            lc_line_idx <= lc_line_idx + 1;
                            lc_st       <= LC_LINE_GAP;
                        end
                    end
                end
            end

            // ------------------------------------------------------------------
            LC_LINE_GAP: begin
                // Wait for inter-line idle before accepting next line.
                // vsync override: restart frame immediately.
                if (vsync0_rise) begin
                    lc_gap      <= '0;
                    lc_line_idx <= '0;
                    lc_px       <= '0;
                    lc_wr_px    <= '0;
                    lc_st       <= LC_WAIT_FIRST_DATA;
                end else if (hsync0_rise) begin
                    // HSYNC from hard IP: next line ready — go capture immediately
                    lc_gap <= '0;
                    lc_st  <= LC_CAP_LINE;
                end else if (!valid) begin
                    if (lc_gap < 16'(GAP_MIN_CYCLES))
                        lc_gap <= lc_gap + 1;
                    else begin
                        lc_gap <= '0;
                        lc_st  <= LC_CAP_LINE;
                    end
                end else if (valid && good_dt)
                    lc_gap <= '0;   // only RAW8/RAW10 data resets gap (not embedded dtype=0x12)
            end

            // ------------------------------------------------------------------
            LC_FRAME_DONE: begin
                // One cycle: reset line counter and wait for next vsync
                lc_line_idx <= '0;
                lc_st       <= LC_WAIT_VSYNC;
            end

        endcase
    end
end

// ---------------------------------------------------------------------------
// FSM_VS — Blue-wire video streamer  (PRIORITY)
//
// Structural independence guarantee:
//   Reads:  line_ram_A, line_ram_B, line_wr_done, line_just_done_sel, lc_st
//   Writes: vid_clk, vid_d, throughput_overflow_error, vid_frame_sync_n
//   NEVER writes: line_sel, line_wr_done, lc_*, fr_*, frame_ram
// ---------------------------------------------------------------------------

// Half-period tick sub-generator (one tick per VID_HALF clk cycles)
logic [31:0] vs_hp_cnt;
logic        vs_hp_tick;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        vs_hp_cnt  <= '0;
        vs_hp_tick <= 1'b0;
    end else begin
        vs_hp_tick <= 1'b0;
        if (vs_hp_cnt >= 32'(VID_HALF) - 1) begin
            vs_hp_cnt  <= '0;
            vs_hp_tick <= 1'b1;
        end else
            vs_hp_cnt <= vs_hp_cnt + 1;
    end
end

typedef enum logic [2:0] {
    VS_IDLE,
    VS_STREAM,
    VS_LINE_GAP,
    VS_FRAME_GAP
} vs_st_t;

vs_st_t      vs_st;
logic [15:0] vs_px;        // byte index being streamed
logic        vs_rd_sel;    // which buffer is being (or about to be) read
logic [31:0] vs_gap_cnt;   // gap cycle counter
logic        vs_clk_ph;    // current generated-clock phase (0=LO, 1=HI)
logic [15:0] vs_line_cnt;  // lines streamed in current frame (1-based)

// Streamer FSM
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        vs_st                <= VS_IDLE;
        vs_px                <= '0;
        vs_rd_sel            <= 1'b0;
        vs_gap_cnt           <= '0;
        vs_clk_ph            <= 1'b0;
        vs_line_cnt          <= '0;
        vid_frame_sync_n     <= 1'b1;
        vid_clk              <= 1'b0;
        vid_d                <= 8'h00;
    end else begin
        case (vs_st)

            // ------------------------------------------------------------------
            VS_IDLE: begin
                vid_clk          <= 1'b0;
                vid_frame_sync_n <= 1'b1;
                if (line_wr_done) begin
                    vs_rd_sel        <= line_just_done_sel;
                    vs_px            <= '0;
                    vs_clk_ph        <= 1'b0;
                    vs_gap_cnt       <= '0;
                    vs_line_cnt      <= 16'd1;  // first line of frame
                    vid_frame_sync_n <= 1'b0;
                    vs_st            <= VS_STREAM;
                end
            end

            // ------------------------------------------------------------------
            VS_STREAM: begin
                vid_frame_sync_n <= 1'b0;
                if (vs_hp_tick) begin
                    vs_clk_ph <= ~vs_clk_ph;
                    if (!vs_clk_ph) begin
                        // Rising edge: present byte and raise clock
                        vid_d   <= vs_rd_sel ? line_ram_B[vs_px] : line_ram_A[vs_px];
                        vid_clk <= 1'b1;
                    end else begin
                        // Falling edge: lower clock and advance byte pointer
                        vid_clk <= 1'b0;
                        if (vs_px + 1 >= 16'(WIDTH_PIX)) begin
                            vs_px      <= '0;
                            vs_gap_cnt <= '0;
                            // Decide gap type: VS counts its own lines
                            if (vs_line_cnt >= 16'(HEIGHT_LINES))
                                vs_st <= VS_FRAME_GAP;
                            else
                                vs_st <= VS_LINE_GAP;
                        end else
                            vs_px <= vs_px + 1;
                    end
                end
            end

            // ------------------------------------------------------------------
            VS_LINE_GAP: begin
                // Hold vid_clk LOW for LINE_GAP_CYCLES, then wait (every cycle)
                // for the next line_wr_done pulse.
                // Since inter-line time >> LINE_GAP_CYCLES, the 1-cycle pulse
                // will always be caught after the minimum gap has elapsed.
                vid_clk <= 1'b0;
                if (vs_gap_cnt < 32'(LINE_GAP_CYCLES)) begin
                    vs_gap_cnt <= vs_gap_cnt + 1;
                end else begin
                    // Gap done — sample every cycle for the next line
                    if (line_wr_done) begin
                        vs_rd_sel   <= line_just_done_sel;
                        vs_px       <= '0;
                        vs_clk_ph   <= 1'b0;
                        vs_gap_cnt  <= '0;
                        vs_line_cnt <= vs_line_cnt + 1;
                        vs_st       <= VS_STREAM;
                    end
                end
            end

            // ------------------------------------------------------------------
            VS_FRAME_GAP: begin
                // Hold vid_clk LOW for at least FRAME_GAP_CYCLES, then wait for
                // the first line of the next frame.
                vid_clk          <= 1'b0;
                vid_frame_sync_n <= 1'b1;
                if (vs_gap_cnt < 32'(FRAME_GAP_CYCLES)) begin
                    vs_gap_cnt <= vs_gap_cnt + 1;
                end else begin
                    if (line_wr_done) begin
                        vs_rd_sel        <= line_just_done_sel;
                        vs_px            <= '0;
                        vs_clk_ph        <= 1'b0;
                        vs_gap_cnt       <= '0;
                        vs_line_cnt      <= 16'd1;  // first line of new frame
                        vid_frame_sync_n <= 1'b0;
                        vs_st            <= VS_STREAM;
                    end
                end
            end

        endcase
    end
end

// Overflow detector (separate always_ff — single writer, sticky, debug only)
// Set when line_wr_done fires while the streamer is still reading the same buffer.
// This means the capture is outrunning the streamer (blue_byte_speed too slow).
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        throughput_overflow_error <= 1'b0;
    else if (line_wr_done &&
             vs_st    == VS_STREAM &&
             vs_rd_sel == line_just_done_sel)
        throughput_overflow_error <= 1'b1;  // sticky — never clears (debug only)
end

// =============================================================================
// ════════════════════════════════════════════════════════════════════════════
// BACKGROUND PATH — full-frame block RAM recorder  (may miss frames)
// ════════════════════════════════════════════════════════════════════════════
//
// This always_ff block is COMPLETELY INDEPENDENT of the priority path.
//
// Reads only:  clk, rst_n, data64, valid, good_dt, cnt, vsync0_rise
// Writes only: frame_ram[], fr_st, fr_wr_addr
//
// It NEVER touches: line_sel, line_wr_done, line_ram_A/B, lc_*, vs_*,
//                   vid_clk, vid_d, throughput_*
//
// Therefore it STRUCTURALLY CANNOT stall or interfere with the priority path.
// If the frame RAM fills before the frame ends, FSM_FR silently stops writing
// and waits for the next vsync.  The priority path keeps running unaffected.
// =============================================================================

typedef enum logic [1:0] {
    FR_WAIT_VSYNC,
    FR_RECORD,
    FR_DONE
} fr_st_t;

fr_st_t      fr_st;
logic [31:0] fr_wr_addr;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fr_st      <= FR_WAIT_VSYNC;
        fr_wr_addr <= '0;
    end else begin
        case (fr_st)

            // ------------------------------------------------------------------
            FR_WAIT_VSYNC: begin
                if (vsync0_rise) begin
                    fr_wr_addr <= '0;
                    fr_st      <= FR_RECORD;
                end
            end

            // ------------------------------------------------------------------
            FR_RECORD: begin
                // New vsync before RAM full: silently restart for new frame
                if (vsync0_rise) begin
                    fr_wr_addr <= '0;
                end else if (valid && good_dt && cnt > 4'd0) begin
                    if (fr_wr_addr < 32'(TOTAL_BEATS)) begin
                        frame_ram[fr_wr_addr] <= data64;
                        fr_wr_addr            <= fr_wr_addr + 1;
                    end else begin
                        fr_st <= FR_DONE;  // RAM full: frame complete
                    end
                end
            end

            // ------------------------------------------------------------------
            FR_DONE: begin
                // Wait for next vsync to start a fresh frame capture
                if (vsync0_rise) begin
                    fr_wr_addr <= '0;
                    fr_st      <= FR_RECORD;
                end
            end

        endcase
    end
end

// =============================================================================
// Status outputs
// =============================================================================
assign capturing_o  = (lc_st == LC_CAP_LINE) || (lc_st == LC_LINE_GAP) || (lc_st == LC_WAIT_FIRST_DATA);
assign done_o       = (lc_st == LC_FRAME_DONE);
assign line_idx_o   = lc_line_idx;
assign words_used_o = fr_wr_addr;

endmodule
