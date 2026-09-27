// =============================================================================
// rgmii_mac_1g.sv : 1Gbit RGMII MAC with DDR I/O for RTL8211F PHY
// =============================================================================
// Efinix T120F324 FPGA - Full-duplex 1Gbit Ethernet MAC
//
// Architecture:
//   - TX Path: Takes 8-bit data, generates preamble/SFD/CRC, outputs DDR RGMII
//   - RX Path: Receives DDR RGMII, strips preamble/SFD, validates CRC
//   - Clock: 125 MHz from PHY CLKOUT (F2_EXT_CLK)
//   - DDR: Data on both rising and falling edges of 125 MHz clock
//
// RGMII DDR Timing (1Gbit):
//   - TXC/RXC = 125 MHz
//   - Rising edge:  TXD[3:0] = data[3:0],  TXCTL = TX_EN
//   - Falling edge: TXD[3:0] = data[7:4],  TXCTL = TX_EN XOR TX_ERR
//
// =============================================================================

`timescale 1ns / 1ps
`default_nettype none

module rgmii_mac_1g #(
    parameter int TX_FIFO_DEPTH = 2048,     // TX FIFO depth (bytes)
    parameter int RX_FIFO_DEPTH = 2048      // RX FIFO depth (bytes)
) (
    // =========================================================================
    // 125 MHz Clock Domain (RGMII)
    // =========================================================================
    input  wire         rgmii_clk,          // 125 MHz from PHY CLKOUT
    input  wire         rgmii_rst_n,        // Reset (active low)
    
    // =========================================================================
    // DDR RGMII RX Interface (directly from Efinix DDR input registers)
    // Naming: _HI = captured on rising edge, _LO = captured on falling edge
    // =========================================================================
    input  wire         rx_dv_hi,           // RXCTL captured on rising edge (RX_DV)
    input  wire         rx_dv_lo,           // RXCTL captured on falling edge (RX_DV XOR RX_ERR)
    input  wire [3:0]   rx_data_hi,         // RXD[3:0] captured on rising edge
    input  wire [3:0]   rx_data_lo,         // RXD[3:0] captured on falling edge
    
    // =========================================================================
    // DDR RGMII TX Interface (directly to Efinix DDR output registers)
    // Naming: _HI = output on rising edge, _LO = output on falling edge
    // =========================================================================
    output logic        tx_en_hi,           // TXCTL output on rising edge (TX_EN)
    output logic        tx_en_lo,           // TXCTL output on falling edge (TX_EN XOR TX_ERR)
    output logic [3:0]  tx_data_hi,         // TXD[3:0] output on rising edge
    output logic [3:0]  tx_data_lo,         // TXD[3:0] output on falling edge
    output logic        tx_clk_hi,          // TXC output on rising edge (always 1)
    output logic        tx_clk_lo,          // TXC output on falling edge (always 0)
    
    // =========================================================================
    // TX Data Interface (from system clock domain via async FIFO)
    // =========================================================================
    input  wire         tx_start,           // Start TX frame
    input  wire [15:0]  tx_frame_len,       // Frame length (bytes, including headers)
    output logic        tx_busy,            // TX in progress
    output logic        tx_done,            // TX complete pulse
    
    // TX FIFO Interface (write side in sys_clk domain, read side here)
    input  wire         tx_fifo_empty,      // TX FIFO empty
    output logic        tx_fifo_rd_en,      // TX FIFO read enable
    input  wire [7:0]   tx_fifo_data,       // TX FIFO data
    
    // =========================================================================
    // RX Data Interface (to system clock domain via async FIFO)
    // =========================================================================
    output logic        rx_frame_valid,     // RX frame complete and valid
    output logic [15:0] rx_frame_len,       // RX frame length (bytes)
    output logic        rx_frame_error,     // RX frame had CRC error
    
    // RX FIFO Interface (write side here, read side in sys_clk domain)
    input  wire         rx_fifo_full,       // RX FIFO full
    output logic        rx_fifo_wr_en,      // RX FIFO write enable
    output logic [7:0]  rx_fifo_data,       // RX FIFO data
    
    // =========================================================================
    // Status
    // =========================================================================
    output logic        link_activity       // Blink on TX/RX activity
);

// =============================================================================
// CRC32 (Ethernet FCS)
// =============================================================================
// IEEE 802.3 CRC32 polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 +
//                              x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
// Polynomial in reversed bit order (LSB first): 0xEDB88320
localparam logic [31:0] CRC_POLY = 32'hEDB88320;

// CRC32 for 8-bit data (combinational)
function automatic logic [31:0] crc32_byte(input logic [31:0] crc, input logic [7:0] data);
    logic [31:0] c;
    c = crc;
    for (int i = 0; i < 8; i++) begin
        if ((c[0] ^ data[i]) == 1'b1)
            c = {1'b0, c[31:1]} ^ CRC_POLY;
        else
            c = {1'b0, c[31:1]};
    end
    return c;
endfunction

// =============================================================================
// TX State Machine
// =============================================================================
typedef enum logic [3:0] {
    TX_IDLE,
    TX_PREAMBLE,
    TX_SFD,
    TX_DATA,
    TX_FCS,
    TX_IFG
} tx_state_t;

tx_state_t tx_state;

// TX counters and registers
logic [3:0]   tx_preamble_cnt;       // Preamble byte counter (7 bytes)
logic [15:0]  tx_byte_cnt;           // Data byte counter
logic [15:0]  tx_len_reg;            // Latched frame length
logic [31:0]  tx_crc;                // Running CRC
logic [7:0]   tx_byte;               // Current byte to transmit
logic [1:0]   tx_fcs_cnt;            // FCS byte counter (4 bytes)
logic [3:0]   tx_ifg_cnt;            // Inter-frame gap counter

// Ethernet constants
localparam logic [7:0] ETH_PREAMBLE = 8'h55;
localparam logic [7:0] ETH_SFD      = 8'hD5;
localparam int         IFG_BYTES    = 12;    // Inter-frame gap (96 bits = 12 bytes)

// =============================================================================
// TX Clock Generation (TXC = 125 MHz, same as rgmii_clk)
// =============================================================================
// DDR output: HI=1, LO=0 generates a clock that matches rgmii_clk
assign tx_clk_hi = 1'b1;
assign tx_clk_lo = 1'b0;

// =============================================================================
// TX State Machine Logic
// =============================================================================
always_ff @(posedge rgmii_clk or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        tx_state        <= TX_IDLE;
        tx_preamble_cnt <= 4'd0;
        tx_byte_cnt     <= 16'd0;
        tx_len_reg      <= 16'd0;
        tx_crc          <= 32'hFFFFFFFF;
        tx_fcs_cnt      <= 2'd0;
        tx_ifg_cnt      <= 4'd0;
        tx_busy         <= 1'b0;
        tx_done         <= 1'b0;
        tx_fifo_rd_en   <= 1'b0;
        tx_byte         <= 8'h00;
        tx_en_hi        <= 1'b0;
        tx_en_lo        <= 1'b0;
        tx_data_hi      <= 4'h0;
        tx_data_lo      <= 4'h0;
    end else begin
        // Default: no FIFO read, no TX done pulse
        tx_fifo_rd_en <= 1'b0;
        tx_done       <= 1'b0;
        
        case (tx_state)
            TX_IDLE: begin
                tx_en_hi   <= 1'b0;
                tx_en_lo   <= 1'b0;
                tx_data_hi <= 4'h0;
                tx_data_lo <= 4'h0;
                tx_busy    <= 1'b0;
                
                if (tx_start && !tx_fifo_empty) begin
                    tx_state        <= TX_PREAMBLE;
                    tx_preamble_cnt <= 4'd0;
                    tx_len_reg      <= tx_frame_len;
                    tx_byte_cnt     <= 16'd0;
                    tx_crc          <= 32'hFFFFFFFF;
                    tx_busy         <= 1'b1;
                end
            end
            
            TX_PREAMBLE: begin
                // Output preamble byte (0x55) in DDR format
                tx_en_hi   <= 1'b1;
                tx_en_lo   <= 1'b1;  // TX_EN XOR TX_ERR, no error
                tx_data_hi <= ETH_PREAMBLE[3:0];   // Rising edge: nibble 0
                tx_data_lo <= ETH_PREAMBLE[7:4];   // Falling edge: nibble 1
                
                tx_preamble_cnt <= tx_preamble_cnt + 1'b1;
                if (tx_preamble_cnt >= 4'd6) begin  // 7 preamble bytes (0-6)
                    tx_state <= TX_SFD;
                    // Pre-fetch cycle 1 of 2: start filling the read pipeline
                    // The async FIFO has 2-cycle read latency (registered output),
                    // so we need rd_en here AND in TX_SFD for data to be ready in TX_DATA
                    tx_fifo_rd_en <= 1'b1;
                end
            end
            
            TX_SFD: begin
                // Output SFD byte (0xD5) in DDR format
                tx_en_hi   <= 1'b1;
                tx_en_lo   <= 1'b1;
                tx_data_hi <= ETH_SFD[3:0];
                tx_data_lo <= ETH_SFD[7:4];
                
                // Pre-fetch cycle 2 of 2: pipeline is now full,
                // tx_fifo_data will have byte 0 when we enter TX_DATA
                tx_fifo_rd_en <= 1'b1;
                tx_state      <= TX_DATA;
            end
            
            TX_DATA: begin
                // Output data byte in DDR format
                // tx_fifo_data has the correct byte thanks to 2-cycle pre-fetch pipeline
                tx_byte    <= tx_fifo_data;
                tx_en_hi   <= 1'b1;
                tx_en_lo   <= 1'b1;
                tx_data_hi <= tx_fifo_data[3:0];   // Rising edge: nibble 0
                tx_data_lo <= tx_fifo_data[7:4];   // Falling edge: nibble 1
                
                // Update CRC with this byte
                tx_crc <= crc32_byte(tx_crc, tx_fifo_data);
                
                tx_byte_cnt <= tx_byte_cnt + 1'b1;
                
                if (tx_byte_cnt >= tx_len_reg - 1) begin
                    // Last data byte — stop pipeline, go to FCS
                    // The 1 extra rd_en from the pipeline is absorbed by the
                    // FIFO's empty flag (prevents over-read). FIFO ends up empty.
                    tx_state   <= TX_FCS;
                    tx_fcs_cnt <= 2'd0;
                end else begin
                    // Keep pipeline flowing — advance to next byte
                    tx_fifo_rd_en <= 1'b1;
                end
            end
            
            TX_FCS: begin
                // Output FCS (CRC32, inverted, LSB first)
                // FCS is transmitted as ~CRC[7:0], ~CRC[15:8], ~CRC[23:16], ~CRC[31:24]
                logic [7:0] fcs_byte;
                
                case (tx_fcs_cnt)
                    2'd0: fcs_byte = ~tx_crc[7:0];
                    2'd1: fcs_byte = ~tx_crc[15:8];
                    2'd2: fcs_byte = ~tx_crc[23:16];
                    2'd3: fcs_byte = ~tx_crc[31:24];
                endcase
                
                tx_en_hi   <= 1'b1;
                tx_en_lo   <= 1'b1;
                tx_data_hi <= fcs_byte[3:0];
                tx_data_lo <= fcs_byte[7:4];
                
                tx_fcs_cnt <= tx_fcs_cnt + 1'b1;
                if (tx_fcs_cnt >= 2'd3) begin
                    tx_state   <= TX_IFG;
                    tx_ifg_cnt <= 4'd0;
                end
            end
            
            TX_IFG: begin
                // Inter-frame gap: TX_EN = 0
                tx_en_hi   <= 1'b0;
                tx_en_lo   <= 1'b0;
                tx_data_hi <= 4'h0;
                tx_data_lo <= 4'h0;
                
                tx_ifg_cnt <= tx_ifg_cnt + 1'b1;
                if (tx_ifg_cnt >= IFG_BYTES - 1) begin
                    tx_state <= TX_IDLE;
                    tx_done  <= 1'b1;
                end
            end
            
            default: tx_state <= TX_IDLE;
        endcase
    end
end

// =============================================================================
// RX State Machine
// =============================================================================
typedef enum logic [3:0] {
    RX_IDLE,
    RX_PREAMBLE,
    RX_DATA,
    RX_DONE
} rx_state_t;

rx_state_t rx_state;

// RX registers
logic [7:0]   rx_byte;               // Assembled byte from DDR nibbles
logic [15:0]  rx_byte_cnt;           // Byte counter
logic [31:0]  rx_crc;                // Running CRC
logic         rx_dv_d;               // Delayed RX_DV for edge detection
logic         rx_err;                // RX_ERR derived from RXCTL[lo]

// Derive RX_ERR from DDR RXCTL (RX_DV_LO = RX_DV XOR RX_ERR)
always_comb begin
    rx_err = rx_dv_hi ^ rx_dv_lo;
end

// =============================================================================
// RX State Machine Logic
// =============================================================================
always_ff @(posedge rgmii_clk or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        rx_state       <= RX_IDLE;
        rx_byte        <= 8'h00;
        rx_byte_cnt    <= 16'd0;
        rx_crc         <= 32'hFFFFFFFF;
        rx_frame_valid <= 1'b0;
        rx_frame_len   <= 16'd0;
        rx_frame_error <= 1'b0;
        rx_fifo_wr_en  <= 1'b0;
        rx_fifo_data   <= 8'h00;
        rx_dv_d        <= 1'b0;
    end else begin
        // Default: no FIFO write, no frame valid pulse
        rx_fifo_wr_en  <= 1'b0;
        rx_frame_valid <= 1'b0;
        rx_dv_d        <= rx_dv_hi;
        
        case (rx_state)
            RX_IDLE: begin
                rx_byte_cnt    <= 16'd0;
                rx_crc         <= 32'hFFFFFFFF;
                rx_frame_error <= 1'b0;
                
                // Detect start of frame (RX_DV rising edge)
                if (rx_dv_hi && !rx_dv_d) begin
                    rx_state <= RX_PREAMBLE;
                end
            end
            
            RX_PREAMBLE: begin
                // Assemble byte from DDR nibbles
                // Rising edge: low nibble [3:0], Falling edge: high nibble [7:4]
                rx_byte <= {rx_data_lo, rx_data_hi};
                
                // Wait for SFD (0xD5)
                if ({rx_data_lo, rx_data_hi} == ETH_SFD) begin
                    rx_state    <= RX_DATA;
                    rx_byte_cnt <= 16'd0;
                end else if (!rx_dv_hi) begin
                    // Frame ended prematurely
                    rx_state <= RX_IDLE;
                end
            end
            
            RX_DATA: begin
                // Assemble byte from DDR nibbles
                rx_byte <= {rx_data_lo, rx_data_hi};
                
                if (rx_dv_hi) begin
                    // Valid data byte
                    if (!rx_fifo_full) begin
                        rx_fifo_wr_en <= 1'b1;
                        rx_fifo_data  <= {rx_data_lo, rx_data_hi};
                    end
                    
                    // Update CRC
                    rx_crc <= crc32_byte(rx_crc, {rx_data_lo, rx_data_hi});
                    
                    // Check for errors
                    if (rx_err) begin
                        rx_frame_error <= 1'b1;
                    end
                    
                    rx_byte_cnt <= rx_byte_cnt + 1'b1;
                end else begin
                    // End of frame
                    rx_state <= RX_DONE;
                end
            end
            
            RX_DONE: begin
                // Frame complete - check CRC
                // Good CRC residue is 0xC704DD7B (magic constant)
                rx_frame_valid <= 1'b1;
                rx_frame_len   <= rx_byte_cnt;
                
                // CRC check: after processing all bytes including FCS,
                // the CRC register should contain the magic residue
                if (rx_crc != 32'hC704DD7B) begin
                    rx_frame_error <= 1'b1;
                end
                
                rx_state <= RX_IDLE;
            end
            
            default: rx_state <= RX_IDLE;
        endcase
    end
end

// =============================================================================
// Link Activity LED
// =============================================================================
logic [23:0] activity_cnt;

always_ff @(posedge rgmii_clk or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        activity_cnt  <= 24'd0;
        link_activity <= 1'b0;
    end else begin
        // Activity on any TX or RX
        if (tx_state != TX_IDLE || rx_state != RX_IDLE) begin
            activity_cnt  <= 24'd12_500_000;  // 100ms @ 125MHz
            link_activity <= 1'b1;
        end else if (activity_cnt > 0) begin
            activity_cnt <= activity_cnt - 1'b1;
        end else begin
            link_activity <= 1'b0;
        end
    end
end

endmodule
