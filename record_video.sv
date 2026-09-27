// =============================================================================
// record_video.sv  v4  —  hsync-based frame sync (no dtype=0x12 dependency)
// =============================================================================
// Three structurally independent always_ff blocks:
//
//   FSM_LC  (PRIORITY) — Line capture into ping-pong buffers
//           Frame start: first valid RAW8/RAW10 beat after idle.
//           Line boundary: hsync[0] rising edge (primary) + gap counter (backup).
//           hsync timeout (128 µs default): forces restart + sets alarm.
//
//   FSM_VS  (PRIORITY) — Blue-wire video byte streamer
//           Reads completed line buffer, drives vid_clk / vid_d[7:0].
//
//   FSM_FR  (BACKGROUND) — Full-frame block RAM recorder
//           Writes 64-bit MIPI beats into frame_ram[].
//
// Debug outputs:
//   hsync_bit0            — direct pass-through of hsync[0]
//   vsync_bit0            — direct pass-through of vsync[0]
//   hsync_timeout_alarm   — set when hsync timeout fires before 224 lines
//   vsync_frame_alarm     — set when vsync[0] falls during active capture
//   throughput_overflow_error — sticky: line overrun detected
//   vid_frame_sync_n      — LOW during frame stream, HIGH during idle
// =============================================================================
`timescale 1ns / 1ps

module record_video #(
    parameter int CLOCK_HZ         = 60_000_000,
    parameter int BLUE_BYTE_SPEED  =  30_000_000,
    parameter int WIDTH_PIX        = 224,
    parameter int HEIGHT_LINES     = 224,
    parameter int PIXELS_PER_BEAT  = 8,
    parameter int GAP_MIN_CYCLES   = 10,
    parameter int HSYNC_TIMEOUT_US = 128,
    parameter int BAUD             = 115200
) (
    input  wire         clk,
    input  wire         rst_n,

    input  wire [63:0]  data64,
    input  wire         valid,
    input  wire [5:0]   dtype,
    input  wire [3:0]   cnt,
    input  wire [3:0]   hsync,
    input  wire [3:0]   vsync,
    input  wire [17:0]  error_bus,

    output logic        vid_clk,
    output logic [7:0]  vid_d,

    output logic        throughput_overflow_error,
    output logic        vid_frame_sync_n,

    // Debug
    output logic        hsync_bit0,
    output logic        vsync_bit0,
    output logic        hsync_timeout_alarm,
    output logic        vsync_frame_alarm,

    output logic        capturing_o,
    output logic        done_o,
    output logic [15:0] line_idx_o,
    output logic [31:0] words_used_o,

    // Line capture stream bus (tapped from Blue Wire line streamer)
    output logic        line_stream_val,
    output logic [15:0] line_stream_idx,
    output logic [7:0]  line_stream_pix_idx,
    output logic [7:0]  line_stream_data,
    output logic        line_stream_frame_sync,

    // UART frame dump
    output logic        frame_uart_tx
);

// =============================================================================
// Derived constants
// =============================================================================
function automatic int ceil_div_fn(int a, int b);
    return (a + b - 1) / b;
endfunction

function automatic logic [7:0] hex_to_ascii(logic [3:0] nib);
    return (nib < 4'd10) ? (8'h30 + {4'b0, nib}) : (8'h37 + {4'b0, nib});
endfunction

localparam int BEATS_PER_LINE       = ceil_div_fn(WIDTH_PIX, PIXELS_PER_BEAT);
localparam int TOTAL_BEATS          = BEATS_PER_LINE * HEIGHT_LINES;
localparam int VID_HALF             = (CLOCK_HZ + BLUE_BYTE_SPEED) / (2 * BLUE_BYTE_SPEED);
localparam int LINE_GAP_CYCLES      = 10;
localparam int FRAME_GAP_CYCLES     = 40;
localparam int HSYNC_TIMEOUT_CYCLES = (CLOCK_HZ / 1_000_000) * HSYNC_TIMEOUT_US;
localparam int UART_TICKS_PER_BIT   = (CLOCK_HZ + BAUD / 2) / BAUD;

// =============================================================================
// Memory
// =============================================================================
// logic [63:0] frame_ram  [0 : TOTAL_BEATS - 1]; // REMOVED to free Block RAM per user request
logic [7:0]  line_ram_A [0 : WIDTH_PIX - 1];
logic [7:0]  line_ram_B [0 : WIDTH_PIX - 1];

// =============================================================================
// Shared combinatorial signals
// =============================================================================
wire good_dt = (dtype == 6'h2A) | (dtype == 6'h2B);

// Debug pass-through
assign hsync_bit0 = hsync[0];
assign vsync_bit0 = vsync[0];

// hsync[0] rising-edge detector
logic hsync0_q;
wire  hsync0_rise = hsync[0] & ~hsync0_q;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) hsync0_q <= 1'b0;
    else        hsync0_q <= hsync[0];
end

// vsync[0] falling-edge detector
logic vsync0_q;
wire  vsync0_fall = ~vsync[0] & vsync0_q;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) vsync0_q <= 1'b0;
    else        vsync0_q <= vsync[0];
end

// =============================================================================
// Ping-pong handshake
// =============================================================================
logic line_sel;
logic line_wr_done;
logic frame_start;        // 1-cycle pulse when LC begins a new frame capture
wire  line_just_done_sel = ~line_sel;

// =============================================================================
// FSM_LC — Line Capture  (PRIORITY)
//
// Frame start: first valid RAW8/RAW10 data in LC_WAIT_DATA.
// Line boundary: hsync[0] rising edge OR gap >= GAP_MIN_CYCLES (after WIDTH_PIX).
// hsync timeout: if hsync[0] stays low > HSYNC_TIMEOUT_US us -> restart + alarm.
// vsync alarm: if vsync[0] falls during active capture -> set alarm.
// =============================================================================
typedef enum logic [2:0] {
    LC_IDLE,
    LC_WAIT_DATA,
    LC_CAP_LINE,
    LC_LINE_GAP,
    LC_FRAME_DONE
} lc_st_t;

lc_st_t      lc_st;
logic [15:0] lc_px;
logic [15:0] lc_wr_px;
logic [15:0] lc_gap;
logic [15:0] lc_line_idx;
logic [31:0] hsync_timeout_cnt;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lc_st               <= LC_IDLE;
        lc_px               <= '0;
        lc_wr_px            <= '0;
        lc_gap              <= '0;
        lc_line_idx         <= '0;
        line_sel            <= 1'b0;
        line_wr_done        <= 1'b0;
        frame_start         <= 1'b0;
        hsync_timeout_cnt   <= '0;
        hsync_timeout_alarm <= 1'b0;
        vsync_frame_alarm   <= 1'b0;
    end else begin
        line_wr_done <= 1'b0;   // default: pulse off
        frame_start  <= 1'b0;   // default: pulse off

        // --- hsync timeout counter ---
        // Resets on every hsync[0] rising edge, or when idle/waiting.
        // Free-runs otherwise.  If it reaches the threshold the FSM restarts.
        if (hsync0_rise || lc_st == LC_WAIT_DATA || lc_st == LC_IDLE)
            hsync_timeout_cnt <= '0;
        else if (hsync_timeout_cnt < 32'(HSYNC_TIMEOUT_CYCLES))
            hsync_timeout_cnt <= hsync_timeout_cnt + 1;

        // --- vsync[0] falling edge during active capture -> alarm ---
        if (vsync0_fall && (lc_st == LC_CAP_LINE || lc_st == LC_LINE_GAP))
            vsync_frame_alarm <= 1'b1;

        // --- clear alarms at new frame start (pre-case, synthesis-safe) ---
        // Placed here (after the set above) so last-write-wins clears
        // the alarm on the same cycle if both conditions are true.
        if (lc_st == LC_WAIT_DATA && valid && good_dt && cnt > 4'd0) begin
            hsync_timeout_alarm <= 1'b0;
            vsync_frame_alarm   <= 1'b0;
        end

        case (lc_st)

            // ------------------------------------------------------------------
            LC_IDLE: lc_st <= LC_WAIT_DATA;

            // ------------------------------------------------------------------
            // Wait for first valid RAW8/RAW10 data = new frame start.
            // Alarms are cleared in pre-case section above.
            LC_WAIT_DATA: begin //lc_st = 1
                if (valid && good_dt && cnt > 4'd0) begin

                    // Capture first beat
                    // IMPORTANT: use lc_wr_px (==0 here) instead of bare 16'(b)
                    // so synthesis generates the same write-port structure as
                    // LC_CAP_LINE.  With a constant index the Efinix tool
                    // reversed the byte lane mapping (MSB-first instead of
                    // LSB-first), causing the first 8 pixels to be mirrored.
                    for (int b = 0; b < PIXELS_PER_BEAT; b++) begin
                        if (lc_wr_px + 16'(b) < 16'(WIDTH_PIX)) begin
                            if (!line_sel)
                                line_ram_A[lc_wr_px + 16'(b)] <= data64[b*8 +: 8];
                            else
                                line_ram_B[lc_wr_px + 16'(b)] <= data64[b*8 +: 8];
                        end
                    end
                    lc_px       <= {12'b0, cnt};
                    lc_wr_px    <= 16'(PIXELS_PER_BEAT);
                    lc_gap      <= '0;
                    lc_line_idx <= '0;
                    line_sel    <= 1'b0;   // always start from buffer A
                    frame_start <= 1'b1;
                    lc_st       <= LC_CAP_LINE;
                end
            end

            // ------------------------------------------------------------------
            LC_CAP_LINE: begin //lc_st = 2
                // --- hsync timeout -> restart, set alarm ---
                if (hsync_timeout_cnt >= 32'(HSYNC_TIMEOUT_CYCLES)) begin
                    hsync_timeout_alarm <= 1'b1;
                    lc_px       <= '0;
                    lc_wr_px    <= '0;
                    lc_gap      <= '0;
                    lc_line_idx <= '0;
                    line_sel    <= 1'b0;
                    lc_st       <= LC_WAIT_DATA;
                end else begin
                    // Capture incoming RAW8 pixels
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
                        lc_gap <= '0;
                    end else begin
                        if (lc_gap < 16'(GAP_MIN_CYCLES))
                            lc_gap <= lc_gap + 1;
                    end

                    // Line complete: enough pixels AND (hsync rise or gap)
                    if (lc_px >= 16'(WIDTH_PIX) && (hsync0_rise || lc_gap >= 16'(GAP_MIN_CYCLES))) begin
                        line_wr_done <= 1'b1;
                        line_sel     <= ~line_sel;
                        lc_px        <= '0;
                        lc_wr_px     <= '0;
                        lc_gap       <= '0;
                        if (lc_line_idx + 1 >= 16'(HEIGHT_LINES))
                            lc_st <= LC_FRAME_DONE;
                        else begin
                            lc_line_idx <= lc_line_idx + 1;
                            lc_st       <= LC_LINE_GAP;
                        end
                    end
                    // Partial line: hsync arrived before enough pixels -> discard
                    else if (hsync0_rise && lc_px > 0 && lc_px < 16'(WIDTH_PIX)) begin
                        lc_px    <= '0;
                        lc_wr_px <= '0;
                        lc_gap   <= '0;
                    end
                end
            end

            // ------------------------------------------------------------------
            LC_LINE_GAP: begin //lc_st = 3
                if (hsync_timeout_cnt >= 32'(HSYNC_TIMEOUT_CYCLES)) begin
                    hsync_timeout_alarm <= 1'b1;
                    lc_px       <= '0;
                    lc_wr_px    <= '0;
                    lc_gap      <= '0;
                    lc_line_idx <= '0;
                    line_sel    <= 1'b0;
                    lc_st       <= LC_WAIT_DATA;
                end else if (hsync0_rise) begin
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
                    lc_gap <= '0;
            end

            // ------------------------------------------------------------------
            LC_FRAME_DONE: begin
                lc_line_idx <= '0;
                lc_st       <= LC_WAIT_DATA;
            end

        endcase
    end
end

// =============================================================================
// FSM_VS — Blue-wire video streamer  (PRIORITY)
// =============================================================================
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
logic [15:0] vs_px;
logic        vs_rd_sel;
logic [31:0] vs_gap_cnt;
logic        vs_clk_ph;
logic [15:0] vs_line_cnt;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        vs_st            <= VS_IDLE;
        vs_px            <= '0;
        vs_rd_sel        <= 1'b0;
        vs_gap_cnt       <= '0;
        vs_clk_ph        <= 1'b0;
        vs_line_cnt      <= '0;
        vid_frame_sync_n <= 1'b1;
        vid_clk          <= 1'b0;
        vid_d            <= 8'h00;
    end else begin
        case (vs_st)

            VS_IDLE: begin
                vid_clk          <= 1'b0;
                vid_frame_sync_n <= 1'b1;
                if (line_wr_done && lc_line_idx == 16'd1) begin
                    vs_rd_sel        <= line_just_done_sel;
                    vs_px            <= '0;
                    vs_clk_ph        <= 1'b0;
                    vs_gap_cnt       <= '0;
                    vs_line_cnt      <= 16'd1;
                    vid_frame_sync_n <= 1'b0;
                    vs_st            <= VS_STREAM;
                end
            end

            VS_STREAM: begin
                vid_frame_sync_n <= 1'b0;
                if (vs_hp_tick) begin
                    vs_clk_ph <= ~vs_clk_ph;
                    if (!vs_clk_ph) begin
                        vid_d   <= vs_rd_sel ? line_ram_B[vs_px] : line_ram_A[vs_px];
                        vid_clk <= 1'b1;
                    end else begin
                        vid_clk <= 1'b0;
                        if (vs_px + 1 >= 16'(WIDTH_PIX)) begin
                            vs_px      <= '0;
                            vs_gap_cnt <= '0;
                            if (vs_line_cnt >= 16'(HEIGHT_LINES))
                                vs_st <= VS_FRAME_GAP;
                            else
                                vs_st <= VS_LINE_GAP;
                        end else
                            vs_px <= vs_px + 1;
                    end
                end
            end

            VS_LINE_GAP: begin
                vid_clk <= 1'b0;
                if (vs_gap_cnt < 32'(LINE_GAP_CYCLES)) begin
                    vs_gap_cnt <= vs_gap_cnt + 1;
                end else begin
                    if (line_wr_done) begin
                        vs_rd_sel   <= line_just_done_sel;
                        vs_px       <= '0;
                        vs_clk_ph   <= 1'b0;
                        vs_gap_cnt  <= '0;
                        vs_line_cnt <= (lc_line_idx == 16'd1) ? 16'd1
                                                              : vs_line_cnt + 1;
                        vs_st       <= VS_STREAM;
                    end
                end
            end

            VS_FRAME_GAP: begin
                vid_clk          <= 1'b0;
                vid_frame_sync_n <= 1'b1;
                if (vs_gap_cnt < 32'(FRAME_GAP_CYCLES)) begin
                    vs_gap_cnt <= vs_gap_cnt + 1;
                end else begin
                    if (line_wr_done && lc_line_idx == 16'd1) begin
                        vs_rd_sel        <= line_just_done_sel;
                        vs_px            <= '0;
                        vs_clk_ph        <= 1'b0;
                        vs_gap_cnt       <= '0;
                        vs_line_cnt      <= 16'd1;
                        vid_frame_sync_n <= 1'b0;
                        vs_st            <= VS_STREAM;
                    end
                end
            end

        endcase
    end
end

// Overflow detector (sticky, debug only)
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        throughput_overflow_error <= 1'b0;
    else if (line_wr_done &&
             vs_st    == VS_STREAM &&
             vs_rd_sel == line_just_done_sel)
        throughput_overflow_error <= 1'b1;
end

// =============================================================================
// UART TX engine & FSM_FR full-frame recorder REMOVED per user request
// to free Block RAM resources. Line streaming over blue-wire bus is preserved.
// =============================================================================
assign frame_uart_tx = 1'b1; // Idle high

// =============================================================================
// Status outputs
// =============================================================================
assign capturing_o  = (lc_st == LC_CAP_LINE) || (lc_st == LC_LINE_GAP);
assign done_o       = (lc_st == LC_FRAME_DONE);
assign line_idx_o   = lc_line_idx;
assign words_used_o = 32'd0;

// Tap line stream from the blue wire byte streamer
assign line_stream_val        = (vs_st == VS_STREAM) && vs_hp_tick && (!vs_clk_ph);
assign line_stream_idx        = vs_line_cnt - 16'd1; // 0-based line index (0 to 223)
assign line_stream_pix_idx    = vs_px[7:0];          // 0 to 223
assign line_stream_data       = vs_rd_sel ? line_ram_B[vs_px] : line_ram_A[vs_px];
assign line_stream_frame_sync = ~vid_frame_sync_n;   // 1 when frame active

endmodule
