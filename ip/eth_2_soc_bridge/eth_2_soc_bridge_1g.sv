// =============================================================================
// eth_2_soc_bridge.sv : 1Gbit Ethernet RGMII Bridge with UDP Support
// =============================================================================
// Efinix T120F324 FPGA with RISC_mini SoC
// 
// Architecture:
//   - APB3 slave interface for SoC register access
//   - TX FIFO: sys_clk → rgmii_clk async FIFO for transmit
//   - RX FIFO: rgmii_clk → sys_clk async FIFO for receive
//   - RGMII MAC instance (separate module)
//   - UDP packet builder (Ethernet + IP + UDP headers)
//
// Register Map (APB3 word-addressable, offset from 0xf8102000):
//   0x00: CONTROL        - Enable/mode, TX start
//   0x04: STATUS         - Link status, FIFO levels, errors
//   0x08: TX_DATA        - Write raw bytes to TX FIFO
//   0x0C: RX_DATA        - Read raw bytes from RX FIFO
//   0x10: TX_LEN         - Set TX frame length (triggers UDP header generation)
//   0x14: RX_LEN         - Read RX frame length
//   0x18: TX_UDP_LEN     - Set UDP payload length (auto-builds headers)
//   0x1C: MAC_ADDR_LO    - Source MAC [31:0]
//   0x20: MAC_ADDR_HI    - Source MAC [47:32]
//   0x24: IP_ADDR        - Source IP address
//   0x28: DEST_MAC_LO    - Destination MAC [31:0]
//   0x2C: DEST_MAC_HI    - Destination MAC [47:32]
//   0x30: DEST_IP        - Destination IP address
//   0x34: PORTS          - {dest_port[15:0], src_port[15:0]}
//   0x38: FRAME_CNT      - TX/RX frame counters
//   0x3C: DEBUG          - Debug/status info
//
// =============================================================================

`timescale 1ns / 1ps
`default_nettype none

module eth_2_soc_bridge_1g #(
    parameter int SYS_CLK_HZ = 50_000_000,   // System clock (APB3)
    parameter int RGMII_CLK_HZ = 125_000_000, // RGMII clock
    parameter int TX_FIFO_DEPTH = 2048,       // TX FIFO size in bytes
    parameter int RX_FIFO_DEPTH = 2048        // RX FIFO size in bytes
) (
    // =========================================================================
    // System Clock Domain (50 MHz)
    // =========================================================================
    input  wire         sys_clk,              // System clock (50 MHz for APB3)
    input  wire         sys_rst_n,            // System reset (active low)
    
    // =========================================================================
    // RGMII Clock Domain (125 MHz from PHY CLKOUT)
    // =========================================================================
    input  wire         rgmii_clk,            // 125 MHz RGMII clock
    input  wire         rgmii_rst_n,          // RGMII domain reset (active low)
    
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
    // RGMII MAC Interface (directly to rgmii_mac_1g)
    // =========================================================================
    // TX to MAC
    output logic        mac_tx_start,
    output logic [15:0] mac_tx_frame_len,
    input  wire         mac_tx_busy,
    input  wire         mac_tx_done,
    output logic        mac_tx_fifo_empty,
    input  wire         mac_tx_fifo_rd_en,
    output logic [7:0]  mac_tx_fifo_data,
    
    // RX from MAC
    input  wire         mac_rx_frame_valid,
    input  wire [15:0]  mac_rx_frame_len,
    input  wire         mac_rx_frame_error,
    output logic        mac_rx_fifo_full,
    input  wire         mac_rx_fifo_wr_en,
    input  wire  [7:0]  mac_rx_fifo_data,
    
    // =========================================================================
    // PHY Status Signals
    // =========================================================================
    input  wire         phy_link_up,          // Link status from MDIO
    input  wire         phy_speed_1g,         // 1G speed indicator
    input  wire         phy_full_duplex,      // Full duplex mode
    
    // =========================================================================
    // Interrupt and Status
    // =========================================================================
    output logic        irq,                  // Interrupt to SoC
    output logic        link_activity         // Activity LED
);

// =============================================================================
// Register Definitions
// =============================================================================
localparam logic [11:0] ADDR_CONTROL     = 12'h000;
localparam logic [11:0] ADDR_STATUS      = 12'h004;
localparam logic [11:0] ADDR_TX_DATA     = 12'h008;
localparam logic [11:0] ADDR_RX_DATA     = 12'h00C;
localparam logic [11:0] ADDR_TX_LEN      = 12'h010;
localparam logic [11:0] ADDR_RX_LEN      = 12'h014;
localparam logic [11:0] ADDR_TX_UDP_LEN  = 12'h018;
localparam logic [11:0] ADDR_MAC_ADDR_LO = 12'h01C;
localparam logic [11:0] ADDR_MAC_ADDR_HI = 12'h020;
localparam logic [11:0] ADDR_IP_ADDR     = 12'h024;
localparam logic [11:0] ADDR_DEST_MAC_LO = 12'h028;
localparam logic [11:0] ADDR_DEST_MAC_HI = 12'h02C;
localparam logic [11:0] ADDR_DEST_IP     = 12'h030;
localparam logic [11:0] ADDR_PORTS       = 12'h034;
localparam logic [11:0] ADDR_FRAME_CNT   = 12'h038;
localparam logic [11:0] ADDR_DEBUG       = 12'h03C;

// Control register bits
localparam int CTRL_ENABLE_BIT     = 0;  // Enable bridge
localparam int CTRL_TX_START_BIT   = 1;  // Start TX (auto-clear)
localparam int CTRL_TX_RAW_BIT     = 2;  // TX raw mode (no header generation)
localparam int CTRL_RX_ENABLE_BIT  = 3;  // Enable RX
localparam int CTRL_LOOPBACK_BIT   = 4;  // Internal loopback

// Status register bits
localparam int STAT_TX_BUSY_BIT    = 0;  // TX in progress
localparam int STAT_TX_DONE_BIT    = 1;  // TX complete (sticky)
localparam int STAT_RX_VALID_BIT   = 2;  // RX frame available
localparam int STAT_RX_ERROR_BIT   = 3;  // RX CRC error (sticky)
localparam int STAT_TX_FIFO_FULL   = 4;  // TX FIFO full
localparam int STAT_RX_FIFO_EMPTY  = 5;  // RX FIFO empty
localparam int STAT_LINK_UP_BIT    = 6;  // PHY link status
localparam int STAT_SPEED_1G_BIT   = 7;  // 1Gbit speed

// =============================================================================
// Internal Registers
// =============================================================================
logic [31:0]  ctrl_reg;
logic [31:0]  status_reg;
logic [47:0]  src_mac_reg;
logic [31:0]  src_ip_reg;
logic [47:0]  dest_mac_reg;
logic [31:0]  dest_ip_reg;
logic [15:0]  src_port_reg;
logic [15:0]  dest_port_reg;
logic [15:0]  tx_frame_cnt;
logic [15:0]  rx_frame_cnt;

// TX/RX length registers
logic [15:0]  tx_udp_payload_len;  // UDP payload length
logic [15:0]  tx_total_frame_len;  // Total frame length (computed)
logic [15:0]  rx_frame_len_reg;

// Sticky status bits
logic         tx_done_sticky;
logic         rx_error_sticky;
logic         rx_valid_sticky;

// =============================================================================
// TX FIFO (sys_clk → rgmii_clk)
// =============================================================================
// Write side: sys_clk domain (APB3 writes)
// Read side: rgmii_clk domain (MAC reads)

logic         tx_fifo_wr_en;
logic [7:0]   tx_fifo_wr_data;
logic         tx_fifo_wr_full;
logic [10:0]  tx_fifo_wr_level;

logic         tx_fifo_rd_en;
logic [7:0]   tx_fifo_rd_data;
logic         tx_fifo_rd_empty;
logic [10:0]  tx_fifo_rd_level;

async_fifo #(
    .DATA_WIDTH(8),
    .DEPTH_LOG2(11)   // 2048 bytes
) u_tx_fifo (
    .wr_clk     (sys_clk),
    .wr_rst_n   (sys_rst_n),
    .wr_en      (tx_fifo_wr_en),
    .wr_data    (tx_fifo_wr_data),
    .wr_full    (tx_fifo_wr_full),
    .wr_level   (tx_fifo_wr_level),
    
    .rd_clk     (rgmii_clk),
    .rd_rst_n   (rgmii_rst_n),
    .rd_en      (tx_fifo_rd_en),
    .rd_data    (tx_fifo_rd_data),
    .rd_empty   (tx_fifo_rd_empty),
    .rd_level   (tx_fifo_rd_level)
);

// Connect TX FIFO to MAC - direct connection, no extra pipeline delay!
assign mac_tx_fifo_empty = tx_fifo_rd_empty;
assign mac_tx_fifo_data  = tx_fifo_rd_data;
assign tx_fifo_rd_en     = mac_tx_fifo_rd_en;

// =============================================================================
// RX FIFO (rgmii_clk → sys_clk)
// =============================================================================
// Write side: rgmii_clk domain (MAC writes)
// Read side: sys_clk domain (APB3 reads)

logic         rx_fifo_wr_en;
logic [7:0]   rx_fifo_wr_data;
logic         rx_fifo_wr_full;
logic [10:0]  rx_fifo_wr_level;

logic         rx_fifo_rd_en;
logic [7:0]   rx_fifo_rd_data;
logic         rx_fifo_rd_empty;
logic [10:0]  rx_fifo_rd_level;

async_fifo #(
    .DATA_WIDTH(8),
    .DEPTH_LOG2(11)   // 2048 bytes
) u_rx_fifo (
    .wr_clk     (rgmii_clk),
    .wr_rst_n   (rgmii_rst_n),
    .wr_en      (rx_fifo_wr_en),
    .wr_data    (rx_fifo_wr_data),
    .wr_full    (rx_fifo_wr_full),
    .wr_level   (rx_fifo_wr_level),
    
    .rd_clk     (sys_clk),
    .rd_rst_n   (sys_rst_n),
    .rd_en      (rx_fifo_rd_en),
    .rd_data    (rx_fifo_rd_data),
    .rd_empty   (rx_fifo_rd_empty),
    .rd_level   (rx_fifo_rd_level)
);

// Connect RX FIFO from MAC
assign mac_rx_fifo_full = rx_fifo_wr_full;

always_ff @(posedge rgmii_clk or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        rx_fifo_wr_en   <= 1'b0;
        rx_fifo_wr_data <= 8'h00;
    end else begin
        rx_fifo_wr_en   <= mac_rx_fifo_wr_en;
        rx_fifo_wr_data <= mac_rx_fifo_data;
    end
end

// =============================================================================
// TX Control Synchronizer (sys_clk → rgmii_clk)
// =============================================================================
logic        tx_start_sys;           // TX start in sys_clk domain
logic        tx_start_sync1;
logic        tx_start_sync2;
logic        tx_start_pulse;
logic [15:0] tx_len_sys;
logic [15:0] tx_len_sync;

// Synchronize TX start to rgmii_clk
always_ff @(posedge rgmii_clk or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        tx_start_sync1 <= 1'b0;
        tx_start_sync2 <= 1'b0;
        tx_len_sync    <= 16'd0;
    end else begin
        tx_start_sync1 <= tx_start_sys;
        tx_start_sync2 <= tx_start_sync1;
        if (tx_start_sync1 && !tx_start_sync2)
            tx_len_sync <= tx_len_sys;
    end
end

assign tx_start_pulse = tx_start_sync1 && !tx_start_sync2;

// Drive MAC TX control
assign mac_tx_start     = tx_start_pulse;
assign mac_tx_frame_len = tx_len_sync;

// =============================================================================
// RX Status Synchronizer (rgmii_clk → sys_clk)
// =============================================================================
logic        rx_valid_sync1;
logic        rx_valid_sync2;
logic        rx_error_sync1;
logic        rx_error_sync2;
logic [15:0] rx_len_sync1;
logic [15:0] rx_len_sync2;

always_ff @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        rx_valid_sync1 <= 1'b0;
        rx_valid_sync2 <= 1'b0;
        rx_error_sync1 <= 1'b0;
        rx_error_sync2 <= 1'b0;
        rx_len_sync1   <= 16'd0;
        rx_len_sync2   <= 16'd0;
    end else begin
        rx_valid_sync1 <= mac_rx_frame_valid;
        rx_valid_sync2 <= rx_valid_sync1;
        rx_error_sync1 <= mac_rx_frame_error;
        rx_error_sync2 <= rx_error_sync1;
        rx_len_sync1   <= mac_rx_frame_len;
        rx_len_sync2   <= rx_len_sync1;
    end
end

// =============================================================================
// TX Done Synchronizer (rgmii_clk → sys_clk)
// =============================================================================
// mac_tx_done is a single-cycle pulse in rgmii_clk (125MHz).
// We need to stretch it to a toggle so it can be safely captured by sys_clk (50MHz).
logic        tx_done_toggle;    // Toggle in rgmii_clk domain
logic        tx_done_sync1;     // 2-stage synchronizer in sys_clk
logic        tx_done_sync2;

// Toggle on every mac_tx_done pulse (rgmii_clk domain)
always_ff @(posedge rgmii_clk or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n)
        tx_done_toggle <= 1'b0;
    else if (mac_tx_done)
        tx_done_toggle <= ~tx_done_toggle;
end

// Synchronize toggle into sys_clk domain, detect edges
always_ff @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tx_done_sync1 <= 1'b0;
        tx_done_sync2 <= 1'b0;
    end else begin
        tx_done_sync1 <= tx_done_toggle;
        tx_done_sync2 <= tx_done_sync1;
    end
end
// tx_done pulse in sys_clk = tx_done_sync1 XOR tx_done_sync2 (edge detect on toggle)

// =============================================================================
// APB3 Interface
// =============================================================================
logic apb_access_valid;
logic apb_read_phase;
logic apb_write_phase;

assign apb_access_valid = apb_psel & apb_penable;
assign apb_read_phase   = apb_access_valid & ~apb_pwrite;
assign apb_write_phase  = apb_access_valid & apb_pwrite;
assign apb_pready       = 1'b1;  // No wait states
assign apb_pslverr      = 1'b0;  // No errors

// APB3 Read
always_comb begin
    apb_prdata = 32'h0;
    case (apb_paddr[11:2])  // Word address
        ADDR_CONTROL[11:2]:     apb_prdata = ctrl_reg;
        ADDR_STATUS[11:2]:      apb_prdata = status_reg;
        ADDR_RX_DATA[11:2]:     apb_prdata = {24'b0, rx_fifo_rd_data};
        ADDR_TX_LEN[11:2]:      apb_prdata = {16'b0, tx_total_frame_len};
        ADDR_RX_LEN[11:2]:      apb_prdata = {16'b0, rx_frame_len_reg};
        ADDR_TX_UDP_LEN[11:2]:  apb_prdata = {16'b0, tx_udp_payload_len};
        ADDR_MAC_ADDR_LO[11:2]: apb_prdata = src_mac_reg[31:0];
        ADDR_MAC_ADDR_HI[11:2]: apb_prdata = {16'b0, src_mac_reg[47:32]};
        ADDR_IP_ADDR[11:2]:     apb_prdata = src_ip_reg;
        ADDR_DEST_MAC_LO[11:2]: apb_prdata = dest_mac_reg[31:0];
        ADDR_DEST_MAC_HI[11:2]: apb_prdata = {16'b0, dest_mac_reg[47:32]};
        ADDR_DEST_IP[11:2]:     apb_prdata = dest_ip_reg;
        ADDR_PORTS[11:2]:       apb_prdata = {dest_port_reg, src_port_reg};
        ADDR_FRAME_CNT[11:2]:   apb_prdata = {rx_frame_cnt, tx_frame_cnt};
        ADDR_DEBUG[11:2]:       apb_prdata = {tx_fifo_wr_level[10:0], 5'b0, 
                                              rx_fifo_rd_level[10:0], 5'b0};
        default:                apb_prdata = 32'h0;
    endcase
end

// RX FIFO read on APB read
assign rx_fifo_rd_en = apb_read_phase && (apb_paddr[11:2] == ADDR_RX_DATA[11:2]);

// =============================================================================
// UDP Header Constants
// =============================================================================
// Ethernet header: 14 bytes (6 dest MAC + 6 src MAC + 2 ethertype)
// IP header: 20 bytes (minimum, no options)
// UDP header: 8 bytes
// Total headers: 42 bytes
localparam int ETH_HEADER_LEN = 14;
localparam int IP_HEADER_LEN  = 20;
localparam int UDP_HEADER_LEN = 8;
localparam int TOTAL_HEADER_LEN = ETH_HEADER_LEN + IP_HEADER_LEN + UDP_HEADER_LEN;  // 42

// =============================================================================
// UDP Packet Header Builder State Machine
// =============================================================================
typedef enum logic [3:0] {
    HDR_IDLE,
    HDR_ETH_DEST_MAC,
    HDR_ETH_SRC_MAC,
    HDR_ETH_TYPE,
    HDR_IP_VER_IHL,
    HDR_IP_DSCP_ECN,
    HDR_IP_LEN,
    HDR_IP_ID,
    HDR_IP_FLAGS_FRAG,
    HDR_IP_TTL_PROTO,
    HDR_IP_CHECKSUM,
    HDR_IP_SRC,
    HDR_IP_DST,
    HDR_UDP_PORTS,
    HDR_UDP_LEN_CSUM,
    HDR_DONE
} hdr_state_t;

hdr_state_t hdr_state;
logic [5:0] hdr_byte_cnt;
logic       hdr_building;
logic [7:0] hdr_byte;
logic       hdr_wr_en;

// IP header fields
logic [15:0] ip_total_len;
logic [15:0] ip_identification;
logic [15:0] ip_header_checksum;
logic [15:0] udp_len;

// Compute IP checksum (one's complement sum of header)
function automatic logic [15:0] compute_ip_checksum(
    input logic [15:0] ip_len,
    input logic [15:0] ip_id,
    input logic [31:0] src_ip,
    input logic [31:0] dst_ip
);
    logic [31:0] sum;
    sum = 0;
    sum = sum + 16'h4500;                     // Version, IHL, DSCP, ECN
    sum = sum + ip_len;                       // Total length
    sum = sum + ip_id;                        // Identification
    sum = sum + 16'h4000;                     // Flags (Don't Fragment), Fragment offset
    sum = sum + 16'h4011;                     // TTL (64), Protocol (UDP=17)
    sum = sum + src_ip[31:16];                // Source IP high
    sum = sum + src_ip[15:0];                 // Source IP low
    sum = sum + dst_ip[31:16];                // Dest IP high
    sum = sum + dst_ip[15:0];                 // Dest IP low
    // Fold 32-bit sum to 16 bits
    sum = sum[15:0] + sum[31:16];
    sum = sum[15:0] + sum[31:16];
    return ~sum[15:0];
endfunction

// =============================================================================
// APB3 Write and Header Generation
// =============================================================================
always_ff @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        ctrl_reg          <= 32'h0;
        src_mac_reg       <= 48'h02_00_00_00_00_01;  // Default: locally administered
        src_ip_reg        <= 32'hC0A80102;           // Default: 192.168.1.2
        dest_mac_reg      <= 48'hFF_FF_FF_FF_FF_FF;  // Default: broadcast
        dest_ip_reg       <= 32'hC0A80101;           // Default: 192.168.1.1
        src_port_reg      <= 16'd5000;               // Default source port
        dest_port_reg     <= 16'd5001;               // Default dest port
        tx_udp_payload_len <= 16'd0;
        tx_total_frame_len <= 16'd0;
        rx_frame_len_reg  <= 16'd0;
        tx_frame_cnt      <= 16'd0;
        rx_frame_cnt      <= 16'd0;
        tx_done_sticky    <= 1'b0;
        rx_error_sticky   <= 1'b0;
        rx_valid_sticky   <= 1'b0;
        tx_start_sys      <= 1'b0;
        tx_len_sys        <= 16'd0;
        tx_fifo_wr_en     <= 1'b0;
        tx_fifo_wr_data   <= 8'h00;
        ip_identification <= 16'd1;
        hdr_state         <= HDR_IDLE;
        hdr_byte_cnt      <= 6'd0;
        hdr_building      <= 1'b0;
    end else begin
        // Default
        tx_fifo_wr_en <= 1'b0;
        tx_start_sys  <= 1'b0;
        
        // Update RX frame length when frame valid
        if (rx_valid_sync1 && !rx_valid_sync2) begin
            rx_frame_len_reg <= rx_len_sync2;
            rx_frame_cnt     <= rx_frame_cnt + 1'b1;
            rx_valid_sticky  <= 1'b1;
        end
        
        // Update RX error sticky
        if (rx_error_sync2) begin
            rx_error_sticky <= 1'b1;
        end
        
        // Update TX done sticky via CDC from rgmii_clk domain
        // tx_done_toggle flips on each mac_tx_done pulse; XOR detects it
        if (tx_done_sync1 != tx_done_sync2) begin
            tx_done_sticky <= 1'b1;
        end
        
        // Header building state machine
        if (hdr_building) begin
            tx_fifo_wr_en   <= 1'b1;
            tx_fifo_wr_data <= hdr_byte;
            hdr_byte_cnt    <= hdr_byte_cnt + 1'b1;
            
            case (hdr_state)
                HDR_ETH_DEST_MAC: begin
                    case (hdr_byte_cnt)
                        // byte_cnt 0 was pre-loaded when TX_UDP_LEN was written
                        6'd0: hdr_byte <= dest_mac_reg[39:32];
                        6'd1: hdr_byte <= dest_mac_reg[31:24];
                        6'd2: hdr_byte <= dest_mac_reg[23:16];
                        6'd3: hdr_byte <= dest_mac_reg[15:8];
                        6'd4: begin
                            hdr_byte <= dest_mac_reg[7:0];
                            hdr_state <= HDR_ETH_SRC_MAC;
                            hdr_byte_cnt <= 6'd0;
                        end
                        default: ; // Safety
                    endcase
                end
                
                HDR_ETH_SRC_MAC: begin
                    case (hdr_byte_cnt)
                        6'd0: hdr_byte <= src_mac_reg[47:40];
                        6'd1: hdr_byte <= src_mac_reg[39:32];
                        6'd2: hdr_byte <= src_mac_reg[31:24];
                        6'd3: hdr_byte <= src_mac_reg[23:16];
                        6'd4: hdr_byte <= src_mac_reg[15:8];
                        6'd5: begin
                            hdr_byte <= src_mac_reg[7:0];
                            hdr_state <= HDR_ETH_TYPE;
                            hdr_byte_cnt <= 6'd0;
                        end
                    endcase
                end
                
                HDR_ETH_TYPE: begin
                    case (hdr_byte_cnt)
                        6'd0: hdr_byte <= 8'h08;  // EtherType: IPv4 (0x0800)
                        6'd1: begin
                            hdr_byte <= 8'h00;
                            hdr_state <= HDR_IP_VER_IHL;
                            hdr_byte_cnt <= 6'd0;
                        end
                    endcase
                end
                
                HDR_IP_VER_IHL: begin
                    hdr_byte <= 8'h45;  // IPv4, IHL=5 (20 bytes, no options)
                    hdr_state <= HDR_IP_DSCP_ECN;
                end
                
                HDR_IP_DSCP_ECN: begin
                    hdr_byte <= 8'h00;  // DSCP=0, ECN=0
                    hdr_state <= HDR_IP_LEN;
                    hdr_byte_cnt <= 6'd0;
                end
                
                HDR_IP_LEN: begin
                    case (hdr_byte_cnt)
                        6'd0: hdr_byte <= ip_total_len[15:8];
                        6'd1: begin
                            hdr_byte <= ip_total_len[7:0];
                            hdr_state <= HDR_IP_ID;
                            hdr_byte_cnt <= 6'd0;
                        end
                    endcase
                end
                
                HDR_IP_ID: begin
                    case (hdr_byte_cnt)
                        6'd0: hdr_byte <= ip_identification[15:8];
                        6'd1: begin
                            hdr_byte <= ip_identification[7:0];
                            hdr_state <= HDR_IP_FLAGS_FRAG;
                            hdr_byte_cnt <= 6'd0;
                        end
                    endcase
                end
                
                HDR_IP_FLAGS_FRAG: begin
                    case (hdr_byte_cnt)
                        6'd0: hdr_byte <= 8'h40;  // Don't Fragment
                        6'd1: begin
                            hdr_byte <= 8'h00;    // Fragment offset = 0
                            hdr_state <= HDR_IP_TTL_PROTO;
                            hdr_byte_cnt <= 6'd0;
                        end
                    endcase
                end
                
                HDR_IP_TTL_PROTO: begin
                    case (hdr_byte_cnt)
                        6'd0: hdr_byte <= 8'h40;  // TTL = 64
                        6'd1: begin
                            hdr_byte <= 8'h11;    // Protocol = UDP (17)
                            hdr_state <= HDR_IP_CHECKSUM;
                            hdr_byte_cnt <= 6'd0;
                        end
                    endcase
                end
                
                HDR_IP_CHECKSUM: begin
                    case (hdr_byte_cnt)
                        6'd0: hdr_byte <= ip_header_checksum[15:8];
                        6'd1: begin
                            hdr_byte <= ip_header_checksum[7:0];
                            hdr_state <= HDR_IP_SRC;
                            hdr_byte_cnt <= 6'd0;
                        end
                    endcase
                end
                
                HDR_IP_SRC: begin
                    case (hdr_byte_cnt)
                        6'd0: hdr_byte <= src_ip_reg[31:24];
                        6'd1: hdr_byte <= src_ip_reg[23:16];
                        6'd2: hdr_byte <= src_ip_reg[15:8];
                        6'd3: begin
                            hdr_byte <= src_ip_reg[7:0];
                            hdr_state <= HDR_IP_DST;
                            hdr_byte_cnt <= 6'd0;
                        end
                    endcase
                end
                
                HDR_IP_DST: begin
                    case (hdr_byte_cnt)
                        6'd0: hdr_byte <= dest_ip_reg[31:24];
                        6'd1: hdr_byte <= dest_ip_reg[23:16];
                        6'd2: hdr_byte <= dest_ip_reg[15:8];
                        6'd3: begin
                            hdr_byte <= dest_ip_reg[7:0];
                            hdr_state <= HDR_UDP_PORTS;
                            hdr_byte_cnt <= 6'd0;
                        end
                    endcase
                end
                
                HDR_UDP_PORTS: begin
                    case (hdr_byte_cnt)
                        6'd0: hdr_byte <= src_port_reg[15:8];
                        6'd1: hdr_byte <= src_port_reg[7:0];
                        6'd2: hdr_byte <= dest_port_reg[15:8];
                        6'd3: begin
                            hdr_byte <= dest_port_reg[7:0];
                            hdr_state <= HDR_UDP_LEN_CSUM;
                            hdr_byte_cnt <= 6'd0;
                        end
                    endcase
                end
                
                HDR_UDP_LEN_CSUM: begin
                    case (hdr_byte_cnt)
                        6'd0: hdr_byte <= udp_len[15:8];
                        6'd1: hdr_byte <= udp_len[7:0];
                        6'd2: hdr_byte <= 8'h00;  // UDP checksum (optional, 0 = disabled)
                        6'd3: begin
                            hdr_byte <= 8'h00;
                            hdr_state <= HDR_DONE;
                            hdr_building <= 1'b0;
                        end
                    endcase
                end
                
                default: begin
                    hdr_building <= 1'b0;
                    hdr_state    <= HDR_IDLE;
                end
            endcase
        end
        
        // Handle APB writes
        if (apb_write_phase) begin
            case (apb_paddr[11:2])
                ADDR_CONTROL[11:2]: begin
                    ctrl_reg <= apb_pwdata;
                    // TX_START triggers transmission
                    if (apb_pwdata[CTRL_TX_START_BIT]) begin
                        tx_start_sys <= 1'b1;
                        tx_len_sys   <= tx_total_frame_len;
                        tx_frame_cnt <= tx_frame_cnt + 1'b1;
                        ip_identification <= ip_identification + 1'b1;
                    end
                end
                
                ADDR_STATUS[11:2]: begin
                    // Writing 1 clears sticky bits
                    if (apb_pwdata[STAT_TX_DONE_BIT])  tx_done_sticky  <= 1'b0;
                    if (apb_pwdata[STAT_RX_ERROR_BIT]) rx_error_sticky <= 1'b0;
                    if (apb_pwdata[STAT_RX_VALID_BIT]) rx_valid_sticky <= 1'b0;
                end
                
                ADDR_TX_DATA[11:2]: begin
                    // Raw write to TX FIFO
                    if (!tx_fifo_wr_full && !hdr_building) begin
                        tx_fifo_wr_en   <= 1'b1;
                        tx_fifo_wr_data <= apb_pwdata[7:0];
                    end
                end
                
                ADDR_TX_UDP_LEN[11:2]: begin
                    // Setting UDP payload length triggers header generation
                    tx_udp_payload_len <= apb_pwdata[15:0];
                    
                    // Calculate total lengths
                    udp_len <= apb_pwdata[15:0] + UDP_HEADER_LEN;
                    ip_total_len <= apb_pwdata[15:0] + UDP_HEADER_LEN + IP_HEADER_LEN;
                    tx_total_frame_len <= apb_pwdata[15:0] + TOTAL_HEADER_LEN;
                    
                    // Compute IP checksum
                    ip_header_checksum <= compute_ip_checksum(
                        apb_pwdata[15:0] + UDP_HEADER_LEN + IP_HEADER_LEN,
                        ip_identification,
                        src_ip_reg,
                        dest_ip_reg
                    );
                    
                    // Start header generation
                    hdr_building <= 1'b1;
                    hdr_state    <= HDR_ETH_DEST_MAC;
                    hdr_byte_cnt <= 6'd0;
                    hdr_byte     <= dest_mac_reg[47:40];
                end
                
                ADDR_MAC_ADDR_LO[11:2]: src_mac_reg[31:0]   <= apb_pwdata;
                ADDR_MAC_ADDR_HI[11:2]: src_mac_reg[47:32]  <= apb_pwdata[15:0];
                ADDR_IP_ADDR[11:2]:     src_ip_reg          <= apb_pwdata;
                ADDR_DEST_MAC_LO[11:2]: dest_mac_reg[31:0]  <= apb_pwdata;
                ADDR_DEST_MAC_HI[11:2]: dest_mac_reg[47:32] <= apb_pwdata[15:0];
                ADDR_DEST_IP[11:2]:     dest_ip_reg         <= apb_pwdata;
                ADDR_PORTS[11:2]: begin
                    src_port_reg  <= apb_pwdata[15:0];
                    dest_port_reg <= apb_pwdata[31:16];
                end
                
                default: ;
            endcase
        end
    end
end

// =============================================================================
// Status Register Assembly
// =============================================================================
always_comb begin
    status_reg = 32'h0;
    status_reg[STAT_TX_BUSY_BIT]   = mac_tx_busy;
    status_reg[STAT_TX_DONE_BIT]   = tx_done_sticky;
    status_reg[STAT_RX_VALID_BIT]  = rx_valid_sticky;
    status_reg[STAT_RX_ERROR_BIT]  = rx_error_sticky;
    status_reg[STAT_TX_FIFO_FULL]  = tx_fifo_wr_full;
    status_reg[STAT_RX_FIFO_EMPTY] = rx_fifo_rd_empty;
    status_reg[STAT_LINK_UP_BIT]   = phy_link_up;
    status_reg[STAT_SPEED_1G_BIT]  = phy_speed_1g;
end

// =============================================================================
// Interrupt Generation
// =============================================================================
assign irq = rx_valid_sticky | rx_error_sticky | tx_done_sticky;

// Activity LED (directly from MAC when connected)
assign link_activity = 1'b0;  // Will be connected to MAC

endmodule
