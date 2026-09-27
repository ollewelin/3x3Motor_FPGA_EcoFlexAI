// =============================================================================
// eth_2_soc_bridge.sv : Ethernet RGMII to SoC APB3 Bridge
// =============================================================================
// Efinix T120F324 FPGA with RISC_mini SoC
// 
// Architecture:
//   - Bridging module between RISC_mini APB3 bus and RTL8211F RGMII PHY
//   - RGMII RX interface: Clock + Control + Data (4-bit)
//   - RGMII TX interface: Clock + Control + Data (4-bit)
//   - APB3 slave interface for SoC register access
//   - Data path for UDP packet handling
//   - Future: Video data routing switch controlled via APB3
//
// Register Map (APB3 word-addressable):
//   0x00: CONTROL        - Enable/mode selection (UDP, video, loopback)
//   0x04: STATUS         - RX/TX status, link status, errors
//   0x08: TX_DATA        - TX packet data FIFO (write-only)
//   0x0C: RX_DATA        - RX packet data FIFO (read-only)
//   0x10: TX_LEN         - TX packet length
//   0x14: RX_LEN         - RX packet length
//   0x18: CONFIG         - Configuration (frame length, CRC enable, etc.)
//   0x1C: INTERRUPT      - Interrupt mask and status
//
// =============================================================================

`timescale 1ns / 1ps
`default_nettype none

module eth_2_soc_bridge #(
    parameter int SYS_CLK_HZ = 50_000_000,   // System clock (APB3)
    parameter int RGMII_CLK_HZ = 125_000_000, // RGMII clock (RX/TX)
    parameter int TX_FIFO_DEPTH = 2048,       // TX FIFO size in bytes
    parameter int RX_FIFO_DEPTH = 2048        // RX FIFO size in bytes
) (
    // =========================================================================
    // System Clock and Reset
    // =========================================================================
    input  wire         sys_clk,              // System clock (50 MHz for APB3)
    input  wire         sys_rst_n,            // System reset (active low)
    
    // =========================================================================
    // APB3 Slave Interface (from RISC_mini)
    // =========================================================================
    input  wire [11:0]  apb_paddr,            // APB address (4KB space)
    input  wire         apb_psel,             // Peripheral select
    input  wire         apb_penable,          // APB enable
    input  wire         apb_pwrite,           // APB write
    input  wire [31:0]  apb_pwdata,           // APB write data
    output logic [31:0] apb_prdata,           // APB read data
    output logic        apb_pready,           // APB ready
    output logic        apb_pslverr,          // APB error
    
    // =========================================================================
    // RGMII RX Interface (from PHY)
    // =========================================================================
    input  wire         rgmii_rxc,            // RX clock (125 MHz)
    input  wire         rgmii_rxctl,          // RX control (valid + error)
    input  wire [3:0]   rgmii_rxd,            // RX data [3:0]
    
    // =========================================================================
    // RGMII TX Interface (to PHY)
    // =========================================================================
    output logic        rgmii_txc,            // TX clock (125 MHz)
    output logic        rgmii_txctl,          // TX control (valid + error)
    output logic [3:0]  rgmii_txd,            // TX data [3:0]
    
    // =========================================================================
    // PHY Status Signals
    // =========================================================================
    input  wire         phy_link_up,          // Link status from MDIO
    input  wire         phy_speed_1g,         // 1G speed (vs 10/100M)
    input  wire         phy_full_duplex,      // Full duplex mode
    
    // =========================================================================
    // Interrupt
    // =========================================================================
    output logic        irq                   // Interrupt to SoC
);

// =============================================================================
// Register Definitions
// =============================================================================
localparam logic [11:0] ADDR_CONTROL    = 12'h000;
localparam logic [11:0] ADDR_STATUS     = 12'h004;
localparam logic [11:0] ADDR_TX_DATA    = 12'h008;
localparam logic [11:0] ADDR_RX_DATA    = 12'h00C;
localparam logic [11:0] ADDR_TX_LEN     = 12'h010;
localparam logic [11:0] ADDR_RX_LEN     = 12'h014;
localparam logic [11:0] ADDR_CONFIG     = 12'h018;
localparam logic [11:0] ADDR_INTERRUPT  = 12'h01C;

// Control register bits
localparam int CTRL_ENABLE_BIT         = 0;  // Enable bridge
localparam int CTRL_TX_START_BIT       = 1;  // Start TX
localparam int CTRL_RX_ENABLE_BIT      = 2;  // Enable RX
localparam int CTRL_LOOPBACK_BIT       = 3;  // Loopback mode
localparam int CTRL_VIDEO_ENABLE_BIT   = 4;  // Video data routing (future)
localparam int CTRL_UDP_MODE_BIT       = 5;  // UDP mode enable

// Status register bits
localparam int STAT_RX_VALID_BIT       = 0;  // RX data valid
localparam int STAT_TX_READY_BIT       = 1;  // TX FIFO ready
localparam int STAT_TX_DONE_BIT        = 2;  // TX complete
localparam int STAT_RX_ERROR_BIT       = 3;  // RX error
localparam int STAT_TX_ERROR_BIT       = 4;  // TX error
localparam int STAT_PHY_LINK_BIT       = 5;  // PHY link status
localparam int STAT_PHY_SPEED_BIT      = 6;  // PHY speed (1=1G, 0=10/100M)

// =============================================================================
// Internal Signals
// =============================================================================

// Control registers
logic [31:0]  ctrl_reg;
logic [31:0]  status_reg;
logic [31:0]  config_reg;
logic [31:0]  int_mask_reg;
logic [31:0]  int_status_reg;

// TX/RX lengths
logic [15:0]  tx_len_reg;
logic [15:0]  rx_len_reg;

// TX FIFO
logic [7:0]   tx_fifo [0:TX_FIFO_DEPTH-1];
logic [15:0]  tx_fifo_wr_ptr;
logic [15:0]  tx_fifo_rd_ptr;
logic         tx_fifo_valid;

// RX FIFO
logic [7:0]   rx_fifo [0:RX_FIFO_DEPTH-1];
logic [15:0]  rx_fifo_wr_ptr;
logic [15:0]  rx_fifo_rd_ptr;
logic         rx_fifo_valid;

// RGMII clock domain crossing
logic         rgmii_rxc_sync;
logic         rgmii_rxctl_sync;
logic [3:0]   rgmii_rxd_sync;

// RX state machine
logic [3:0]   rx_nibble_cnt;
logic [7:0]   rx_byte_current;
logic         rx_frame_active;
logic         rx_error_detected;

// TX state machine
logic [3:0]   tx_nibble_cnt;
logic         tx_active;
logic         tx_done;

// APB3 handshake
logic         apb_access_valid;
logic         apb_read_phase;
logic         apb_write_phase;

// =============================================================================
// APB3 Interface
// =============================================================================

assign apb_access_valid = apb_psel & apb_penable;
assign apb_read_phase   = apb_access_valid & ~apb_pwrite;
assign apb_write_phase  = apb_access_valid & apb_pwrite;
assign apb_pready       = 1'b1;  // No wait states
assign apb_pslverr      = 1'b0;  // No errors

// APB3 Read
always_comb begin
    apb_prdata = 32'h0;
    case (apb_paddr[11:2])  // Word address
        ADDR_CONTROL[11:2]:   apb_prdata = ctrl_reg;
        ADDR_STATUS[11:2]:    apb_prdata = status_reg;
        ADDR_TX_LEN[11:2]:    apb_prdata = {16'b0, tx_len_reg};
        ADDR_RX_LEN[11:2]:    apb_prdata = {16'b0, rx_len_reg};
        ADDR_RX_DATA[11:2]:   apb_prdata = {24'b0, rx_fifo[rx_fifo_rd_ptr[15:0]]};
        ADDR_CONFIG[11:2]:    apb_prdata = config_reg;
        ADDR_INTERRUPT[11:2]: apb_prdata = {int_mask_reg[31:16], int_status_reg[15:0]};
        default:              apb_prdata = 32'h0;
    endcase
end

// APB3 Write
always_ff @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        ctrl_reg <= 32'h0;
        config_reg <= 32'h0;
        int_mask_reg <= 32'h0;
        tx_len_reg <= 16'h0;
        rx_len_reg <= 16'h0;
        tx_fifo_wr_ptr <= 16'h0;
        rx_fifo_rd_ptr <= 16'h0;
    end else begin
        // Handle RX FIFO read pointer advancement
        if (apb_read_phase && apb_paddr[11:2] == ADDR_RX_DATA[11:2]) begin
            // Advance read pointer when RX_DATA is read
            if (rx_fifo_rd_ptr < (RX_FIFO_DEPTH - 1)) begin
                rx_fifo_rd_ptr <= rx_fifo_rd_ptr + 1'b1;
            end else begin
                rx_fifo_rd_ptr <= 16'h0;
            end
        end
        
        // Handle APB writes
        if (apb_write_phase) begin
            case (apb_paddr[11:2])
                ADDR_CONTROL[11:2]: begin
                    ctrl_reg <= apb_pwdata;
                    // Auto-clear single-shot bits
                    if (apb_pwdata[1]) begin  // TX_START
                        tx_active <= 1'b1;
                    end
                end
                ADDR_TX_DATA[11:2]: begin
                    // Write to TX FIFO
                    tx_fifo[tx_fifo_wr_ptr[15:0]] <= apb_pwdata[7:0];
                    if (tx_fifo_wr_ptr < (TX_FIFO_DEPTH - 1)) begin
                        tx_fifo_wr_ptr <= tx_fifo_wr_ptr + 1'b1;
                    end
                end
                ADDR_TX_LEN[11:2]: begin
                    tx_len_reg <= apb_pwdata[15:0];
                end
                ADDR_CONFIG[11:2]: begin
                    config_reg <= apb_pwdata;
                end
                ADDR_INTERRUPT[11:2]: begin
                    int_mask_reg <= apb_pwdata[31:16];
                    // Writing 1 to int_status clears that bit
                    int_status_reg <= int_status_reg & ~apb_pwdata[15:0];
                end
                default: ;
            endcase
        end
        
        // Update status register continuously
        status_reg[STAT_TX_READY_BIT] <= (tx_fifo_wr_ptr < (TX_FIFO_DEPTH - 1));
        status_reg[STAT_RX_VALID_BIT] <= rx_fifo_valid;
        status_reg[STAT_TX_DONE_BIT] <= tx_done;
        status_reg[STAT_RX_ERROR_BIT] <= rx_error_detected;
        status_reg[STAT_TX_ERROR_BIT] <= 1'b0;  // TX error flag (not currently used)
        status_reg[STAT_PHY_LINK_BIT] <= phy_link_up;
        status_reg[STAT_PHY_SPEED_BIT] <= phy_speed_1g;
        status_reg[31:7] <= 25'h0;  // Clear unused bits
        
        // Handle interrupt status updates
        // APB write to INTERRUPT register clears bits (handled above in case statement)
        // Hardware events set interrupt bits when NOT doing APB interrupt write
        if (!apb_write_phase || apb_paddr[11:2] != ADDR_INTERRUPT[11:2]) begin
            // Set RX completion interrupt when frame completes
            if (rx_fifo_valid && !rx_frame_active) begin
                int_status_reg[0] <= 1'b1;
            end
            
            // Set TX completion interrupt
            if (tx_done) begin
                int_status_reg[1] <= 1'b1;
            end
            
            // Set error interrupts
            if (rx_error_detected) begin
                int_status_reg[2] <= 1'b1;
            end
            
            // Clear unused bits [31:3]
            int_status_reg[31:3] <= 29'h0;
        end
    end
end

// =============================================================================
// Interrupt Generation
// =============================================================================
assign irq = |(int_status_reg & int_mask_reg);

endmodule
