`timescale 1ns / 1ps
// =============================================================================
// debug_first_line_on_frame.sv
//
// Captures the FIRST LINE of each MIPI frame into a small BRAM and
// continuously replays it byte-by-byte on debug output signals for
// logic analyser observation.
//
// Flow:
//   1. Wait for VSYNC[0] 0→1 rising edge  (new frame)
//   2. Record up to BEATS_PER_LINE valid RAW8/RAW10 beats from data64
//   3. Enter replay loop: output one byte every REPLAY_CLK_DIV clocks,
//      pulse line_byte_tick for one cycle when the byte is valid.
//      Continue until the next VSYNC[0] rising edge → re-capture.
//
// Logic-analyser connection:
//   Trigger on  : line_byte_tick (rising edge)
//   Capture     : line_debug_byte  (8-bit byte value)
//                 output_debug_pixel_cnt (linear byte index 0..191)
//                 frame_sync_out   (1-cycle pulse per new frame)
//                 capture_active   (high while recording)
//
// Add these signals to the Efinix debug probe JSON (debug_profile.mark_debug.json)
// or route them to spare GPIO output pins for an external logic analyser.
// =============================================================================

module debug_first_line_on_frame #(
    parameter int BEATS_PER_LINE = 24,    // 192 px / 8 px-per-beat  (RAW8 on 64-bit bus)
    parameter int REPLAY_CLK_DIV = 1000   // clock cycles between each replayed byte output
                                          // At 100 MHz: 1000 → 100 kHz byte rate (~1.92 ms/full replay)
) (
    input  logic        clk,
    input  logic        rst_n,

    // MIPI RX fabric signals (same as record_frame_bram_counted)
    input  logic [63:0] data64,           // 64-bit pixel bus
    input  logic        valid,            // beat valid
    input  logic [5:0]  dtype,            // data type: 0x2A=RAW8, 0x2B=RAW10
    input  logic [3:0]  hsync,            // horizontal sync flags (unused, for future use)
    input  logic [3:0]  vsync,            // vertical sync flags; vsync[0] = frame active

    // ---- Logic-analyser debug outputs ----
    output logic [7:0]  line_debug_byte,        // current replayed byte value
    output logic [7:0]  output_debug_pixel_cnt, // linear byte index: beat*8+byte_in_beat (0..191)
    output logic        line_byte_tick,          // 1-cycle HIGH when line_debug_byte is updated
    output logic        frame_sync_out,          // 1-cycle HIGH on VSYNC[0] 0→1 edge (new frame)
    output logic        capture_active           // HIGH while actively recording first line
);

    // =========================================================================
    // Local constants
    // =========================================================================
    localparam logic [5:0] DT_RAW8  = 6'h2A;
    localparam logic [5:0] DT_RAW10 = 6'h2B;

    // Bit widths – sized to hold all counter values without overflow
    localparam int BEAT_BITS = $clog2(BEATS_PER_LINE + 1); // e.g. 5 for 24 beats
    localparam int DIV_BITS  = $clog2(REPLAY_CLK_DIV + 1); // e.g. 10 for 1000 div

    // =========================================================================
    // Line BRAM  (BEATS_PER_LINE × 64 bits = 192 bytes for default parameters)
    // =========================================================================
    logic [63:0] line_bram [0:BEATS_PER_LINE-1];

    // =========================================================================
    // FSM states
    // =========================================================================
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        CAPTURE = 2'b01,
        REPLAY  = 2'b10
    } state_t;

    state_t state;

    // =========================================================================
    // VSYNC[0] rising-edge detector
    // =========================================================================
    logic vsync0_q;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) vsync0_q <= 1'b0;
        else        vsync0_q <= vsync[0];
    end
    logic vsync0_rise;
    assign vsync0_rise = vsync[0] & ~vsync0_q;  // detect 0→1

    // =========================================================================
    // Good data-type filter (accept RAW8 and RAW10 only)
    // =========================================================================
    logic good_dt;
    assign good_dt = (dtype == DT_RAW8) || (dtype == DT_RAW10);

    // =========================================================================
    // Counters
    // =========================================================================
    logic [BEAT_BITS-1:0] beat_cnt;  // capture: beat index being written  (0..BEATS_PER_LINE-1)
    logic [BEAT_BITS-1:0] rpl_beat;  // replay:  which BRAM word is being read
    logic [2:0]           rpl_byte;  // replay:  which byte inside the 64-bit word (0..7)
    logic [DIV_BITS-1:0]  rpl_div;   // replay:  clock divider (0..REPLAY_CLK_DIV-1)

    // =========================================================================
    // Combinational byte extraction
    // Synthesis-safe explicit mux instead of variable part-select.
    // =========================================================================
    logic [7:0] current_byte;
    always_comb begin
        case (rpl_byte)
            3'd0: current_byte = line_bram[rpl_beat][ 7: 0];
            3'd1: current_byte = line_bram[rpl_beat][15: 8];
            3'd2: current_byte = line_bram[rpl_beat][23:16];
            3'd3: current_byte = line_bram[rpl_beat][31:24];
            3'd4: current_byte = line_bram[rpl_beat][39:32];
            3'd5: current_byte = line_bram[rpl_beat][47:40];
            3'd6: current_byte = line_bram[rpl_beat][55:48];
            3'd7: current_byte = line_bram[rpl_beat][63:56];
            default: current_byte = 8'h00;
        endcase
    end

    // =========================================================================
    // Main FSM
    // =========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state                  <= IDLE;
            beat_cnt               <= '0;
            rpl_beat               <= '0;
            rpl_byte               <= 3'd0;
            rpl_div                <= '0;
            frame_sync_out         <= 1'b0;
            capture_active         <= 1'b0;
            line_byte_tick         <= 1'b0;
            line_debug_byte        <= 8'h00;
            output_debug_pixel_cnt <= 8'h00;
        end else begin
            // Default: deassert single-cycle pulses
            frame_sync_out <= 1'b0;
            line_byte_tick <= 1'b0;

            case (state)

                // -------------------------------------------------------------
                // IDLE: wait for first VSYNC[0] rising edge
                // -------------------------------------------------------------
                IDLE: begin
                    capture_active <= 1'b0;
                    if (vsync0_rise) begin
                        frame_sync_out <= 1'b1;
                        beat_cnt       <= '0;
                        state          <= CAPTURE;
                        capture_active <= 1'b1;
                    end
                end

                // -------------------------------------------------------------
                // CAPTURE: record up to BEATS_PER_LINE valid RAW beats
                // vsync0_rise takes priority (re-arm on unexpected new frame)
                // -------------------------------------------------------------
                CAPTURE: begin
                    capture_active <= 1'b1;
                    if (vsync0_rise) begin
                        // New frame arrived before capture finished – restart
                        frame_sync_out <= 1'b1;
                        beat_cnt       <= '0;
                    end else if (valid && good_dt) begin
                        // Store current beat in BRAM
                        line_bram[beat_cnt] <= data64;
                        if (beat_cnt == BEAT_BITS'(BEATS_PER_LINE - 1)) begin
                            // First line captured – enter replay
                            capture_active <= 1'b0;
                            rpl_beat       <= '0;
                            rpl_byte       <= 3'd0;
                            rpl_div        <= '0;
                            state          <= REPLAY;
                        end else begin
                            beat_cnt <= beat_cnt + 1;
                        end
                    end
                end

                // -------------------------------------------------------------
                // REPLAY: continuously replay captured bytes at REPLAY_CLK_DIV rate
                // On next VSYNC[0] rising edge, switch back to CAPTURE
                // -------------------------------------------------------------
                REPLAY: begin
                    capture_active <= 1'b0;
                    if (vsync0_rise) begin
                        // New frame – re-capture first line
                        frame_sync_out <= 1'b1;
                        beat_cnt       <= '0;
                        state          <= CAPTURE;
                        capture_active <= 1'b1;
                    end else begin
                        if (rpl_div == DIV_BITS'(REPLAY_CLK_DIV - 1)) begin
                            rpl_div <= '0;
                            // Present current byte to outputs
                            line_debug_byte        <= current_byte;
                            output_debug_pixel_cnt <= {rpl_beat[BEAT_BITS-1:0], rpl_byte}; // = beat*8+byte
                            line_byte_tick         <= 1'b1;
                            // Advance byte pointer, wrap at end of line
                            if (rpl_byte == 3'd7) begin
                                rpl_byte <= 3'd0;
                                if (rpl_beat == BEAT_BITS'(BEATS_PER_LINE - 1))
                                    rpl_beat <= '0;
                                else
                                    rpl_beat <= rpl_beat + 1;
                            end else begin
                                rpl_byte <= rpl_byte + 1;
                            end
                        end else begin
                            rpl_div <= rpl_div + 1;
                        end
                    end
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule
