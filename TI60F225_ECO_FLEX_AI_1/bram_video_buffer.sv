// bram_video_buffer.sv
// 64KB Block RAM dual-port: MIPI write (primary), Ethernet read
// Main data path: MIPI CSI-2 RX → BRAM → eth_tx_1gbit_udp
//
// Write port: 64-bit words from csi2_rx_cam_b (via mipi_csi2_rx_capture)
//   - clk_mipi = PLL_100MHZ (pixel clock domain)
//   - mipi_write_addr = 64-bit word address (0-8191)
//   - 8192 words × 8 bytes  = 64 KB total
//
// Read port: 8-bit byte access for sequential Ethernet TX
//   - clk_125MHz = PLL_125MHZ (ETH clock domain)
//   - read_addr  = byte address (0-65535)

module bram_video_buffer #(
    parameter BRAM_DEPTH      = 65536,  // total bytes = 64 KB
    parameter MIPI_DATA_WIDTH = 64,     // write port width (bits)
    parameter BRAM_READ_WIDTH = 8       // read port width  (bits)
)(
    // =========================================================================
    // MIPI Write Port (PLL_100MHZ / pixel clock domain)
    // =========================================================================
    input  wire                       clk_mipi,         // pixel clock (100 MHz)
    input  wire                       mipi_rst_n,       // active-low reset (unused, kept for compat)
    input  wire [MIPI_DATA_WIDTH-1:0] mipi_data,        // 64-bit data from capture module
    input  wire                       mipi_valid,       // write enable
    output wire                       mipi_ready,       // always 1 (no back-pressure)
    input  wire [15:0]                mipi_write_addr,  // 64-bit word address (0-8191)

    // =========================================================================
    // Ethernet Read Port (PLL_125MHZ / ETH clock domain)
    // =========================================================================
    input  wire                       clk_125MHz,
    input  wire [15:0]                read_addr,        // byte address (0-65535)
    output wire [BRAM_READ_WIDTH-1:0] read_data,
    input  wire                       read_en
);

    // =========================================================================
    // BRAM storage: 64-bit wide × 8192 depth = 64 KB
    // One 64-bit write covers 8 consecutive byte addresses.
    // =========================================================================
    localparam WORDS = BRAM_DEPTH / (MIPI_DATA_WIDTH / 8);   // 65536 / 8 = 8192

    reg [MIPI_DATA_WIDTH-1:0] bram_word [0:WORDS-1];

    // ── Write port (64-bit, clk_mipi) ─────────────────────────────────────
    // mipi_write_addr[12:0] naturally addresses words 0-8191 (13-bit index).
    always @(posedge clk_mipi) begin
        if (mipi_valid) begin
            bram_word[mipi_write_addr[12:0]] <= mipi_data;
        end
    end

    assign mipi_ready = 1'b1;

    // ── Read port (8-bit byte extraction, clk_125MHz) ─────────────────────
    // Byte address → 64-bit word address (÷8) + byte offset within word (mod 8)
    wire [12:0] read_word_addr   = read_addr[15:3];   // ÷8
    wire [2:0]  read_byte_offset = read_addr[2:0];    // mod 8
    wire [63:0] read_word        = bram_word[read_word_addr];

    assign read_data =
        (read_byte_offset == 3'd0) ? read_word[ 7: 0] :
        (read_byte_offset == 3'd1) ? read_word[15: 8] :
        (read_byte_offset == 3'd2) ? read_word[23:16] :
        (read_byte_offset == 3'd3) ? read_word[31:24] :
        (read_byte_offset == 3'd4) ? read_word[39:32] :
        (read_byte_offset == 3'd5) ? read_word[47:40] :
        (read_byte_offset == 3'd6) ? read_word[55:48] :
                                     read_word[63:56];  // 3'd7

endmodule
