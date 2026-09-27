// =============================================================================
// video_line_stream_bridge_apb3.sv
// =============================================================================
// Lightweight APB3 slave at 0xf8104000 to capture camera lines on demand
// for streaming over Ethernet UDP without buffering full frames.
//
// Register Map:
//   0x000 (R/W): Status & Control
//         Bit 0 (W1S): req_sample - Request capture of target_line
//         Bit 1 (R):   line_ready - Set to 1 when target_line is completely captured
//         Bit 2 (W1C): clear_ready - Reset line_ready to 0
//         Bit 31:16 (R): captured_frame_cnt
//   0x004 (R/W): Target Line Index (0 to 223)
//   0x008 (R):   Live Blue Wire Status: [31:16] = frame_cnt, [15:0] = current_line
//   0x00C (R):   Diagnostic: [15:0] = captured_line_idx, [23:16] = width (224), [31:24] = height (224)
//   0x100 - 0x1DC (R): Captured Line Data (56 x 32-bit words = 224 bytes)
//                      Word 0 = {pix[3], pix[2], pix[1], pix[0]}
// =============================================================================

`timescale 1ns / 1ps

module video_line_stream_bridge_apb3 #(
    parameter int WIDTH_PIX    = 224,
    parameter int HEIGHT_LINES = 224
) (
    input  wire         clk,
    input  wire         rst_n,

    // Tapped from record_video.sv
    input  wire         stream_val,
    input  wire [15:0]  stream_line_idx,
    input  wire [7:0]   stream_pix_idx,
    input  wire [7:0]   stream_data,
    input  wire         stream_frame_sync,

    // APB3 Slave Interface
    input  wire         apb_psel,
    input  wire         apb_penable,
    input  wire         apb_pwrite,
    input  wire [11:0]  apb_paddr,
    input  wire [31:0]  apb_pwdata,
    output logic [31:0] apb_prdata,
    output wire         apb_pready,
    output wire         apb_pslverr
);

    assign apb_pready  = 1'b1;
    assign apb_pslverr = 1'b0;

    // Registers
    logic        req_sample;
    logic        line_ready;
    logic [15:0] target_line;
    logic [15:0] captured_line;
    logic [15:0] captured_frame_cnt;
    logic [15:0] frame_counter;

    // 224-byte buffer (56 x 32-bit words)
    logic [31:0] line_words [0 : 55];

    // Frame counter: increment on rising edge of stream_frame_sync
    logic stream_sync_q;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stream_sync_q <= 1'b0;
            frame_counter <= 16'd0;
        end else begin
            stream_sync_q <= stream_frame_sync;
            if (stream_frame_sync && !stream_sync_q) begin
                frame_counter <= frame_counter + 16'd1;
            end
        end
    end

    // Line sample receiver
    wire [5:0] w_idx = stream_pix_idx[7:2]; // 0 to 55
    wire [1:0] b_idx = stream_pix_idx[1:0]; // 0 to 3

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            req_sample         <= 1'b0;
            line_ready         <= 1'b0;
            target_line        <= 16'd0;
            captured_line      <= 16'd0;
            captured_frame_cnt <= 16'd0;
        end else begin
            // Stream capture
            if (stream_val && req_sample && !line_ready) begin
                if (stream_line_idx == target_line) begin
                    case (b_idx)
                        2'd0: line_words[w_idx][7:0]   <= stream_data;
                        2'd1: line_words[w_idx][15:8]  <= stream_data;
                        2'd2: line_words[w_idx][23:16] <= stream_data;
                        2'd3: line_words[w_idx][31:24] <= stream_data;
                    endcase

                    // When last pixel of target line arrives
                    if (stream_pix_idx == 8'(WIDTH_PIX - 1)) begin
                        line_ready         <= 1'b1;
                        req_sample         <= 1'b0;
                        captured_line      <= stream_line_idx;
                        captured_frame_cnt <= frame_counter;
                    end
                end
            end

            // APB3 Write
            if (apb_psel && apb_penable && apb_pwrite) begin
                if (apb_paddr[11:0] == 12'h000) begin
                    if (apb_pwdata[0]) req_sample <= 1'b1;
                    if (apb_pwdata[2]) line_ready <= 1'b0;
                end else if (apb_paddr[11:0] == 12'h004) begin
                    target_line <= apb_pwdata[15:0];
                end
            end
        end
    end

    // APB3 Read
    wire [5:0] rd_word_idx = apb_paddr[7:2]; // 0x100..0x1DC -> 0..55

    always_comb begin
        apb_prdata = 32'h00000000;
        if (apb_psel) begin
            if (apb_paddr[11:8] == 4'h0) begin
                case (apb_paddr[7:0])
                    8'h00: apb_prdata = {captured_frame_cnt, 13'b0, 1'b0, line_ready, req_sample};
                    8'h04: apb_prdata = {16'b0, target_line};
                    8'h08: apb_prdata = {frame_counter, stream_line_idx};
                    8'h0C: apb_prdata = {8'd224, 8'd224, captured_line};
                    default: apb_prdata = 32'h00000000;
                endcase
            end else if (apb_paddr[11:8] == 4'h1) begin
                if (rd_word_idx < 6'd56) begin
                    apb_prdata = line_words[rd_word_idx];
                end
            end
        end
    end

endmodule
