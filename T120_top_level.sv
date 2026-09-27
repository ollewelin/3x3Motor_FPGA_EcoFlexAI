// =============================================================================
// top_level.sv : Main System Integration - RISC-V SoC + 1Gbit Ethernet + LED
// =============================================================================
// Efinix T120F324 FPGA with RISC_mini RISC-V SoC + 1Gbit Ethernet Bridge
// 
// Architecture:
//   1. RISC_mini SoC (RV32I processor + APB3 peripherals + UART)
//   2. 1Gbit Ethernet Bridge (APB3 slave, RGMII DDR interface)
//   3. MDIO Master (APB3 slave, PHY register access)
//   4. GPIO output for LED blink (CAM3_SDA_OUT - LED #2)
//   5. UART Bridge (debug console via USB-UART)
//
// Clock Domains:
//   - sys_clk: 50 MHz (from T120_GCLK external oscillator)
//   - rgmii_clk: 125 MHz (from PHY CLKOUT via F2_EXT_CLK)
//
// Ethernet (1Gbit):
//   - PHY: RTL8211F-CG (1000Mbps)
//   - Interface: RGMII DDR (data on both clock edges)
//   - TX Clock: 125 MHz from PHY CLKOUT
//   - RX Clock: 125 MHz from PHY RXC
//   - Clock Domain Crossing: Async FIFOs with gray-code pointers
//
// UART: 115200 baud @ 50 MHz system clock
//
// =============================================================================

`timescale 1ns / 1ps

module top_level (
    // =========================================================================
    // External Clock (50 MHz)
    // =========================================================================
    input  wire         T120_GCLK,           // External 50 MHz clock
    
    // =========================================================================
    // UART Debug Interface (115200 baud)
    // =========================================================================
    output wire         fpga_uart_tx,        // UART TX (XB2, P10) → USB-UART TX
    input  wire         fpga_uart_rx,        // UART RX (XB3, N10) ← USB-UART RX
    
    // =========================================================================
    // Ethernet PHY Interface (RTL8211F-CG)
    // =========================================================================
    // MDIO: Management interface (for PHY configuration)
    output wire         F2_MDC,              // MDIO Clock (GPIOB_TXN01, T18)
    input  wire         F2_MDIO_IN,          // MDIO Input (GPIOB_TXN05, R15)
    output wire         F2_MDIO_OUT,         // MDIO Output (GPIOB_TXN05, R15)
    output wire         F2_MDIO_OE,          // MDIO Output Enable (GPIOB_TXN05, R15)
    output wire         F2_RSTB,             // PHY Reset (GPIOB_TXP00, T17)
    
    // RGMII RX: Simple inputs from PHY (soft DDR in fabric)
    input  wire         F2_RXC,              // RX Clock (GPIOR_178, 125 MHz) - normal input
    input  wire         F2_RXCTL,            // RX Control (GPIOB_TXP08)
    input  wire         F2_RXD0,             // RX Data 0 (GPIOB_TXN08)
    input  wire         F2_RXD1,             // RX Data 1 (GPIOB_TXP06)
    input  wire         F2_RXD2,             // RX Data 2 (GPIOB_TXN06)
    input  wire         F2_RXD3,             // RX Data 3 (GPIOB_TXN07)
    
    // RGMII TX: Simple outputs to PHY (soft DDR in fabric)
    output wire         F2_TXC,              // TX Clock (GPIOB_TXP07)
    output wire         F2_TXCTL,            // TX Control (GPIOB_TXN04)
    output wire         F2_TXD0,             // TX Data 0 (GPIOB_TXP04)
    output wire         F2_TXD1,             // TX Data 1 (GPIOB_TXN03)
    output wire         F2_TXD2,             // TX Data 2 (GPIOB_TXP03)
    output wire         F2_TXD3,             // TX Data 3 (GPIOB_TXP05)
    
    // Interrupt from PHY
    input  wire         F2_INTB,             // PHY Interrupt (GPIOB_TXP02)
    
    // External clock input for PHY (125 MHz CLKOUT)
    input  wire         F2_EXT_CLK,          // 125 MHz from PHY CLKOUT (GPIOR_174) - GCLK
    
    // =========================================================================
    // Debug/Status Outputs (Tri-state GPIO)
    // =========================================================================
    output wire         CAM3_SCL,            // LED #1 (Status)
    output wire         CAM3_SDA_OUT,        // LED #2 (GPIO bit 0 from RISC_mini)
    output wire         CAM3_SDA_OE,         // LED #2 output enable
    input  wire         CAM3_SDA_IN,         // LED #2 input (unused)
    output wire         CAM3_EN,             // Status output (Ethernet activity)
    
    // =========================================================================
    // JTAG Debug Interface (for debugger/OpenOCD)
    // =========================================================================
    input  wire         jtag_inst1_CAPTURE,
    input  wire         jtag_inst1_DRCK,
    input  wire         jtag_inst1_RESET,
    input  wire         jtag_inst1_RUNTEST,
    input  wire         jtag_inst1_SEL,
    input  wire         jtag_inst1_SHIFT,
    input  wire         jtag_inst1_TCK,
    input  wire         jtag_inst1_TDI,
    output wire         jtag_inst1_TDO,
    input  wire         jtag_inst1_TMS,
    input  wire         jtag_inst1_UPDATE
);

// =============================================================================
// Parameters
// =============================================================================
localparam int SYS_CLK_HZ   = 50_000_000;   // System clock frequency
localparam int RGMII_CLK_HZ = 125_000_000;  // RGMII clock frequency (1Gbit)

// =============================================================================
// Internal Signals
// =============================================================================

// Clock and Reset
logic       sys_clk;                         // 50 MHz system clock
logic       rgmii_clk;                       // 125 MHz RGMII clock (from PHY CLKOUT)
logic       sys_rst_n;                       // System reset (active HIGH from SoC!)
logic       sys_rst_n_inv;                   // Inverted: active LOW for peripherals
logic       rgmii_rst_n;                     // RGMII domain reset (synchronized)
// Debug: 125 MHz domain debug counter (8-bit)
logic [7:0]  debug_125mhz_cnt;                // increments on `rgmii_clk`
// Additional debug 4-bit counters (named debug_<xxx>_cnt)
logic [3:0]  debug_f2_rxc_cnt;                // clocked by F2_RXC (input)
logic [3:0]  debug_f2_txc_cnt;                // clocked by F2_TXC (output)
logic [3:0]  debug_f2_rxctl_cnt;              // clocked by F2_RXCTL (input)
logic [3:0]  debug_f2_txctl_cnt;              // clocked by F2_TXCTL (output)

// RISC_mini SoC APB3 Interface Signals
logic [31:0]  apb_paddr;                     // APB address
logic         apb_psel;                      // APB peripheral select
logic         apb_penable;                   // APB enable
logic         apb_pwrite;                    // APB write enable
logic [31:0]  apb_pwdata;                    // APB write data
logic [31:0]  apb_prdata;                    // APB read data
logic         apb_pready;                    // APB ready (from slave)
logic         apb_pslverr;                   // APB slave error

// UART mini APB3 signals
logic         uart_mini_apb_psel;
logic         uart_mini_apb_penable;
logic         uart_mini_apb_pwrite;
logic [31:0]  uart_mini_apb_pwdata;
logic [31:0]  uart_mini_apb_prdata;
logic         uart_mini_apb_pready;
logic         uart_mini_txd;
logic         uart_mini_rxd;
logic         uart_mini_debug_tx_activity;  // DEBUG: TX activity indicator
logic         uart_mini_debug_any_write;    // DEBUG: ANY write indicator

// UART signals
logic         sapphire_uart_txd;             // UART TX (from SoC)
logic         sapphire_uart_rxd;             // UART RX (to SoC)

// GPIO signals (from RISC_mini)
logic [3:0]   gpio_write;                    // GPIO write data
logic [3:0]   gpio_writeEnable;              // GPIO write enable
logic [3:0]   gpio_read;                     // GPIO read data

// Ethernet Bridge APB3 Interface
logic [11:0]  eth_apb_paddr;
logic         eth_apb_psel;
logic         eth_apb_penable;
logic         eth_apb_pwrite;
logic [31:0]  eth_apb_pwdata;
logic [31:0]  eth_apb_prdata;
logic         eth_apb_pready;

// MDIO Master APB3 Interface
logic [3:0]   mdio_apb_paddr;
logic         mdio_apb_psel;
logic         mdio_apb_penable;
logic         mdio_apb_pwrite;
logic [31:0]  mdio_apb_pwdata;
logic [31:0]  mdio_apb_prdata;
logic         mdio_apb_pready;

// PHY status signals (for Ethernet bridge)
logic         phy_link_up;
logic         phy_speed_1g;
logic         phy_full_duplex;

// Ethernet activity LED
logic         eth_link_activity;

// =============================================================================
// 1Gbit RGMII MAC Interface Signals
// =============================================================================
// TX control (sys_clk → MAC via bridge)
logic         mac_tx_start;
logic [15:0]  mac_tx_frame_len;
logic         mac_tx_busy;
logic         mac_tx_done;
logic         mac_tx_fifo_empty;
logic         mac_tx_fifo_rd_en;
logic [7:0]   mac_tx_fifo_data;

// RX control (MAC → sys_clk via bridge)
logic         mac_rx_frame_valid;
logic [15:0]  mac_rx_frame_len;
logic         mac_rx_frame_error;
logic         mac_rx_fifo_full;
logic         mac_rx_fifo_wr_en;
logic [7:0]   mac_rx_fifo_data;

// DDR RGMII signals (from/to MAC)
logic         mac_tx_en_hi;
logic         mac_tx_en_lo;
logic [3:0]   mac_tx_data_hi;
logic [3:0]   mac_tx_data_lo;
logic         mac_tx_clk_hi;
logic         mac_tx_clk_lo;

// =============================================================================
// Soft DDR: RX Capture (posedge + negedge of rgmii_clk in fabric)
// =============================================================================
// Since GPIOB pins don't support DDR I/O on Trion T120,
// we capture RX data on both edges of rgmii_clk in fabric.
logic         rx_dv_hi,    rx_dv_lo;
logic [3:0]   rx_data_hi,  rx_data_lo;

// Rising edge capture → HI nibble
always_ff @(posedge rgmii_clk) begin
    rx_dv_hi   <= F2_RXCTL;
    rx_data_hi <= {F2_RXD3, F2_RXD2, F2_RXD1, F2_RXD0};
end

// Falling edge capture → LO nibble
always_ff @(negedge rgmii_clk) begin
    rx_dv_lo   <= F2_RXCTL;
    rx_data_lo <= {F2_RXD3, F2_RXD2, F2_RXD1, F2_RXD0};
end

// =============================================================================
// Soft DDR: TX Output (ODDR-style using both-edge register)
// =============================================================================
// Proper DDR output without hardware DDR primitives:
// - Posedge: capture HI and LO from MAC
// - Output: HI data during clock high, LO data during clock low
//
// We use the combinational mux approach (rgmii_clk as select) but with
// registered data to minimize glitch window. The setup/hold timing at
// 125MHz provides sufficient margin since the data is stable well before
// the clock edge. The PHY samples on TXC edges, and the mux output is 
// stable except during the brief clock transition (~100ps).

// Posedge: capture both HI and LO from MAC
logic         tx_en_hi_r,   tx_en_lo_r;
logic [3:0]   tx_data_hi_r, tx_data_lo_r;

always_ff @(posedge rgmii_clk) begin
    tx_en_hi_r   <= mac_tx_en_hi;
    tx_en_lo_r   <= mac_tx_en_lo;
    tx_data_hi_r <= mac_tx_data_hi;
    tx_data_lo_r <= mac_tx_data_lo;
end

// For the falling edge, we use a negedge register to hold LO data
// These outputs are valid right after the falling edge
logic         tx_en_lo_neg;
logic [3:0]   tx_data_lo_neg;

always_ff @(negedge rgmii_clk) begin
    tx_en_lo_neg   <= tx_en_lo_r;
    tx_data_lo_neg <= tx_data_lo_r;
end

// Output mux: use the registered clock phase to select
// rgmii_clk=1: PHY just sampled on rising edge, now outputting falling-edge data
// rgmii_clk=0: PHY just sampled on falling edge, now outputting rising-edge data
// 
// RGMII spec: TXD must be valid at TXC edges.
// With TXC = rgmii_clk, PHY samples on rising and falling edges of TXC.
// We output HI data starting from posedge (stable during high phase → sampled at rising edge)
// We output LO data starting from negedge (stable during low phase → sampled at falling edge)
//
// Actually: PHY samples at TXC edges. With 0 delay, data must be set up BEFORE the edge.
// With 2ns internal delay in PHY (configured via RGMII delay registers), the PHY samples
// 2ns after the TXC edge, giving us margin.
assign F2_TXC   = rgmii_clk;  // Forward 125 MHz clock to PHY
assign F2_TXCTL = rgmii_clk ? tx_en_hi_r      : tx_en_lo_neg;
assign F2_TXD0  = rgmii_clk ? tx_data_hi_r[0] : tx_data_lo_neg[0];
assign F2_TXD1  = rgmii_clk ? tx_data_hi_r[1] : tx_data_lo_neg[1];
assign F2_TXD2  = rgmii_clk ? tx_data_hi_r[2] : tx_data_lo_neg[2];
assign F2_TXD3  = rgmii_clk ? tx_data_hi_r[3] : tx_data_lo_neg[3];

// =============================================================================
// PHY Interrupt Synchronizer (async → sys_clk)
// =============================================================================
logic         intb_meta,  intb_sync;

// =============================================================================
// Clock and Reset Generation
// =============================================================================

// Direct clock assignment (Efinix GCLK buffers)
assign sys_clk   = T120_GCLK;    // 50 MHz system clock
assign rgmii_clk = F2_EXT_CLK;   // 125 MHz from PHY CLKOUT (via GCLK buffer)

// CRITICAL: io_systemReset is ACTIVE HIGH (1=reset, 0=running)
// All peripherals need ACTIVE LOW reset (0=reset, 1=running)
assign sys_rst_n_inv = ~sys_rst_n;

// NOTE: System reset is generated internally by RISC_mini SoC via io_systemReset output
// The SoC includes built-in power-on reset logic (~5ms at 50MHz)

// =============================================================================
// RGMII Domain Reset Synchronizer (sys_clk → rgmii_clk)
// =============================================================================
// Synchronize sys_rst_n_inv into the 125 MHz rgmii_clk domain
logic rgmii_rst_meta;
always_ff @(posedge rgmii_clk or negedge sys_rst_n_inv) begin
    if (!sys_rst_n_inv) begin
        rgmii_rst_meta <= 1'b0;
        rgmii_rst_n    <= 1'b0;
    end else begin
        rgmii_rst_meta <= 1'b1;
        rgmii_rst_n    <= rgmii_rst_meta;
    end
end

// =============================================================================
// RISC_mini SoC Instantiation
// =============================================================================

// Debug Counter: 125 MHz RGMII domain
// Increments each rising edge of `rgmii_clk`. Reset is `rgmii_rst_n` (active LOW).
always_ff @(posedge rgmii_clk or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        debug_125mhz_cnt <= 8'd0;
    end else begin
        debug_125mhz_cnt <= debug_125mhz_cnt + 1;
    end
end

// Four small debug counters (4-bit) clocked by various RGMII signals
// Each counter wraps naturally (4-bit) and resets with `rgmii_rst_n`.
always_ff @(posedge F2_RXC or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        debug_f2_rxc_cnt <= 4'd0;
    end else begin
        debug_f2_rxc_cnt <= debug_f2_rxc_cnt + 1;
    end
end

always_ff @(posedge F2_TXC or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        debug_f2_txc_cnt <= 4'd0;
    end else begin
        debug_f2_txc_cnt <= debug_f2_txc_cnt + 1;
    end
end

always_ff @(posedge F2_RXCTL or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        debug_f2_rxctl_cnt <= 4'd0;
    end else begin
        debug_f2_rxctl_cnt <= debug_f2_rxctl_cnt + 1;
    end
end

always_ff @(posedge F2_TXCTL or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        debug_f2_txctl_cnt <= 4'd0;
    end else begin
        debug_f2_txctl_cnt <= debug_f2_txctl_cnt + 1;
    end
end

// Simpler RISC-V SoC without DDR3 support
// Includes:
//   - RISC-V processor (RV32I)
//   - APB peripherals (UART, I2C, GPIO)
//   - Interrupt controller (PLIC)
//   - GPIO output for LED blink

RISC_mini u_sapphire_soc (
    // Clock and Reset
    .io_systemClk               (sys_clk),
    .io_systemReset             (sys_rst_n),  // Output from SoC (ACTIVE HIGH!)
    .io_asyncReset              (1'b0),       // Async reset input (not used)
    
    // APB Slave Interface (from RISC-V master to peripherals)
    .io_apbSlave_0_PADDR        (apb_paddr[15:0]),  // Use lower 16 bits
    .io_apbSlave_0_PSEL         (apb_psel),
    .io_apbSlave_0_PENABLE      (apb_penable),
    .io_apbSlave_0_PWRITE       (apb_pwrite),
    .io_apbSlave_0_PWDATA       (apb_pwdata),
    .io_apbSlave_0_PRDATA       (apb_prdata),
    .io_apbSlave_0_PREADY       (apb_pready),
    .io_apbSlave_0_PSLVERROR    (apb_pslverr),
    
    // UART Debug Interface (115200 baud)
    .system_uart_0_io_txd       (sapphire_uart_txd),  // TX from SoC
    .system_uart_0_io_rxd       (sapphire_uart_rxd),  // RX to SoC
    
    // I2C Interface (not connected)
    .system_i2c_0_io_scl_read   (1'b1),
    .system_i2c_0_io_scl_write  (),
    .system_i2c_0_io_sda_read   (1'b1),
    .system_i2c_0_io_sda_write  (),
    
    // GPIO Interface - for LED blink output (GPIO bit 0)
    .system_gpio_0_io_writeEnable (gpio_writeEnable),
    .system_gpio_0_io_write     (gpio_write),
    .system_gpio_0_io_read      (gpio_read),
    
    // User Interrupt (not used)
    .userInterruptA             (1'b0),
    
    // JTAG Debug Interface (enabled - connected to debugger)
    .jtagCtrl_enable            (jtag_inst1_SEL),
    .jtagCtrl_tdi               (jtag_inst1_TDI),
    .jtagCtrl_capture           (jtag_inst1_CAPTURE),
    .jtagCtrl_shift             (jtag_inst1_SHIFT),
    .jtagCtrl_update            (jtag_inst1_UPDATE),
    .jtagCtrl_reset             (jtag_inst1_RESET),
    .jtagCtrl_tck               (jtag_inst1_TCK),
    .jtagCtrl_tdo               (jtag_inst1_TDO)
);

// =============================================================================
// APB3 Address Decoding and Multiplexing
// =============================================================================
// RISC_mini SoC outputs 16-bit addresses on APB3 bus
// From soc.h: IO_APB_SLAVE_0_INPUT = 0xf8100000 (64KB space, 0x10000 bytes)
// 
// Address assignments within APB Slave 0 (offset from 0xf8100000):
//   0x0000-0x0FFF : uart_mini     (CPU address 0xf8100000)
//   0x1000-0x1FFF : MDIO master   (CPU address 0xf8101000)
//   0x2000-0x2FFF : Ethernet bridge (CPU address 0xf8102000)

// Chip select logic based on APB address bits [15:12]
logic       uart_mini_selected;
logic       mdio_selected;
logic       eth_selected;

assign uart_mini_selected = (apb_paddr[15:12] == 4'h0);  // 0x0000-0x0FFF
assign mdio_selected      = (apb_paddr[15:12] == 4'h1);  // 0x1000-0x1FFF
assign eth_selected       = (apb_paddr[15:12] == 4'h2);  // 0x2000-0x2FFF

// --- uart_mini APB3 routing (zero-wait-state, accepts all transactions) ---
assign uart_mini_apb_psel    = apb_psel & uart_mini_selected;
assign uart_mini_apb_penable = apb_penable;
assign uart_mini_apb_pwrite  = apb_pwrite;
assign uart_mini_apb_pwdata  = apb_pwdata;

// --- MDIO master APB3 routing ---
// MDIO master uses word-addressed paddr[3:0] (0-3)
// SoC outputs byte addresses, so map apb_paddr[3:2] → mdio paddr[1:0]
assign mdio_apb_psel    = apb_psel & mdio_selected;
assign mdio_apb_penable = apb_penable;
assign mdio_apb_pwrite  = apb_pwrite;
assign mdio_apb_pwdata  = apb_pwdata;
assign mdio_apb_paddr   = {2'b00, apb_paddr[3:2]};  // Byte→word address (0x00→0, 0x04→1, 0x08→2, 0x0C→3)

// --- Ethernet bridge APB3 routing ---
assign eth_apb_psel    = apb_psel & eth_selected;
assign eth_apb_penable = apb_penable;
assign eth_apb_pwrite  = apb_pwrite;
assign eth_apb_pwdata  = apb_pwdata;
assign eth_apb_paddr   = apb_paddr[11:0];  // Full 4KB space

// =============================================================================
// APB3 Read Data and Ready Multiplexing
// =============================================================================
// All three slaves are zero-wait-state (PREADY always 1 for MDIO & eth)
// uart_mini has its own combinational PREADY (also zero-wait effectively)
// To avoid SoC hanging on unselected addresses, provide a default PREADY=1

always_comb begin
    if (uart_mini_selected) begin
        apb_prdata = uart_mini_apb_prdata;
        apb_pready = uart_mini_apb_pready;
    end else if (mdio_selected) begin
        apb_prdata = mdio_apb_prdata;
        apb_pready = mdio_apb_pready;
    end else if (eth_selected) begin
        apb_prdata = eth_apb_prdata;
        apb_pready = eth_apb_pready;
    end else begin
        apb_prdata = 32'h00000000;
        apb_pready = 1'b1;  // Default: don't hang on unmapped addresses
    end
end

// =============================================================================
// DEBUG: Route SoC APB3 signals to analyzer to verify what SoC is outputting
// =============================================================================
logic [15:0] debug_soc_apb_paddr;
logic        debug_soc_apb_psel;
logic        debug_soc_apb_penable;
logic        debug_soc_apb_pwrite;
logic [31:0] debug_soc_apb_pwdata;

assign debug_soc_apb_paddr = apb_paddr;
assign debug_soc_apb_psel = apb_psel;
assign debug_soc_apb_penable = apb_penable;
assign debug_soc_apb_pwrite = apb_pwrite;
assign debug_soc_apb_pwdata = apb_pwdata;

// =============================================================================
// MDIO Master Instantiation
// =============================================================================
// Handles PHY register access via IEEE 802.3 Clause-22 MDIO protocol

mdio_master #(
    .SYS_CLK_HZ(SYS_CLK_HZ),
    .MDC_HZ(1_000_000)  // 1 MHz MDC clock
) u_mdio_master (
    // System
    .clk(sys_clk),
    .rst_n(sys_rst_n_inv),
    
    // APB Slave Interface
    .psel(mdio_apb_psel),
    .penable(mdio_apb_penable),
    .pwrite(mdio_apb_pwrite),
    .paddr(mdio_apb_paddr),
    .pwdata(mdio_apb_pwdata),
    .prdata(mdio_apb_prdata),
    .pready(mdio_apb_pready),
    .pslverr(),
    
    // MDIO Pins (to PHY)
    .mdc(F2_MDC),
    .mdio_i(F2_MDIO_IN),
    .mdio_o(F2_MDIO_OUT),
    .mdio_oe(F2_MDIO_OE),
    
    // PHY Reset
    .phy_rst_n(F2_RSTB),
    
    // Interrupt (future use)
    .irq()
);

// =============================================================================
// 1Gbit RGMII MAC Instantiation (runs in rgmii_clk domain)
// =============================================================================
// DDR RGMII interface with proper clock domain separation

rgmii_mac_1g #(
    .TX_FIFO_DEPTH(2048),
    .RX_FIFO_DEPTH(2048)
) u_rgmii_mac (
    // 125 MHz Clock Domain
    .rgmii_clk      (rgmii_clk),
    .rgmii_rst_n    (rgmii_rst_n),
    
    // DDR RGMII RX Interface (from soft DDR capture in fabric)
    .rx_dv_hi       (rx_dv_hi),
    .rx_dv_lo       (rx_dv_lo),
    .rx_data_hi     (rx_data_hi),
    .rx_data_lo     (rx_data_lo),
    
    // DDR RGMII TX Interface (to Efinix DDR output registers)
    .tx_en_hi       (mac_tx_en_hi),
    .tx_en_lo       (mac_tx_en_lo),
    .tx_data_hi     (mac_tx_data_hi),
    .tx_data_lo     (mac_tx_data_lo),
    .tx_clk_hi      (mac_tx_clk_hi),
    .tx_clk_lo      (mac_tx_clk_lo),
    
    // TX Control Interface (from bridge via CDC)
    .tx_start       (mac_tx_start),
    .tx_frame_len   (mac_tx_frame_len),
    .tx_busy        (mac_tx_busy),
    .tx_done        (mac_tx_done),
    .tx_fifo_empty  (mac_tx_fifo_empty),
    .tx_fifo_rd_en  (mac_tx_fifo_rd_en),
    .tx_fifo_data   (mac_tx_fifo_data),
    
    // RX Control Interface (to bridge via CDC)
    .rx_frame_valid (mac_rx_frame_valid),
    .rx_frame_len   (mac_rx_frame_len),
    .rx_frame_error (mac_rx_frame_error),
    .rx_fifo_full   (mac_rx_fifo_full),
    .rx_fifo_wr_en  (mac_rx_fifo_wr_en),
    .rx_fifo_data   (mac_rx_fifo_data),
    
    // Status
    .link_activity  (eth_link_activity)
);

// DDR TX outputs are handled by soft DDR mux above (see "Soft DDR: TX Output" section)

// =============================================================================
// 1Gbit Ethernet Bridge Instantiation (with Async FIFOs)
// =============================================================================
// Bridges APB3 (sys_clk) to RGMII MAC (rgmii_clk) with proper CDC

eth_2_soc_bridge_1g #(
    .SYS_CLK_HZ(SYS_CLK_HZ),
    .RGMII_CLK_HZ(RGMII_CLK_HZ),
    .TX_FIFO_DEPTH(2048),
    .RX_FIFO_DEPTH(2048)
) u_eth_bridge (
    // System Clock Domain (50 MHz)
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n_inv),
    
    // RGMII Clock Domain (125 MHz)
    .rgmii_clk      (rgmii_clk),
    .rgmii_rst_n    (rgmii_rst_n),
    
    // APB3 Slave Interface (from RISC_mini)
    .apb_paddr      (eth_apb_paddr),
    .apb_psel       (eth_apb_psel),
    .apb_penable    (eth_apb_penable),
    .apb_pwrite     (eth_apb_pwrite),
    .apb_pwdata     (eth_apb_pwdata),
    .apb_prdata     (eth_apb_prdata),
    .apb_pready     (eth_apb_pready),
    .apb_pslverr    (),
    
    // MAC TX Interface
    .mac_tx_start       (mac_tx_start),
    .mac_tx_frame_len   (mac_tx_frame_len),
    .mac_tx_busy        (mac_tx_busy),
    .mac_tx_done        (mac_tx_done),
    .mac_tx_fifo_empty  (mac_tx_fifo_empty),
    .mac_tx_fifo_rd_en  (mac_tx_fifo_rd_en),
    .mac_tx_fifo_data   (mac_tx_fifo_data),
    
    // MAC RX Interface
    .mac_rx_frame_valid (mac_rx_frame_valid),
    .mac_rx_frame_len   (mac_rx_frame_len),
    .mac_rx_frame_error (mac_rx_frame_error),
    .mac_rx_fifo_full   (mac_rx_fifo_full),
    .mac_rx_fifo_wr_en  (mac_rx_fifo_wr_en),
    .mac_rx_fifo_data   (mac_rx_fifo_data),
    
    // PHY Status Signals
    .phy_link_up        (phy_link_up),
    .phy_speed_1g       (phy_speed_1g),
    .phy_full_duplex    (phy_full_duplex),
    
    // Interrupt and Status
    .irq                (),
    .link_activity      ()
);

// =============================================================================
// PHY Status Tracking (from MDIO - can be read via APB)
// =============================================================================
// These signals reflect the PHY state for use in the Ethernet bridge
// TODO: Implement proper status register read from MDIO master

assign phy_link_up = 1'b0;          // TODO: Read from MDIO PHY register 0x01 (BMSR)
assign phy_speed_1g = 1'b1;         // TODO: Read from MDIO PHY register 0x0A (1000BTSR)
assign phy_full_duplex = 1'b1;      // TODO: Read from MDIO PHY register 0x00 (BMCR)

// =============================================================================
// UART Mini APB3 Instantiation (Replacement for SoC UART)
// =============================================================================
// Standalone UART core with APB3 interface
// Base address: 0xf8100000 (IO_APB_SLAVE_0_INPUT from soc.h)
// Baud rate: 115200 @ 50 MHz system clock

uart_mini_apb3 u_uart_mini_apb3 (
    // System
    .pclk(sys_clk),
    .presetn(sys_rst_n_inv),   // ACTIVE LOW reset (inverted from SoC's active-high)
    
    // APB3 Slave Interface
    .psel(uart_mini_apb_psel),
    .penable(uart_mini_apb_penable),
    .pwrite(uart_mini_apb_pwrite),
    .paddr(apb_paddr[7:0]),  // Pass full 8-bit address for register decode
    .pwdata(uart_mini_apb_pwdata),
    .prdata(uart_mini_apb_prdata),
    .pready(uart_mini_apb_pready),
    .pslverr(),
    
    // UART Pins
    .uart_txd(uart_mini_txd),  // TX output
    .uart_rxd(uart_mini_rxd),  // RX input
    
    // DEBUG: TX activity on CAM3_EN
    .debug_tx_activity(uart_mini_debug_tx_activity),
    .debug_any_write(uart_mini_debug_any_write),
    
    // DEBUG: APB3 Protocol Analyzer Probes
    .debug_bus_state(),      // State machine: 00=IDLE, 01=SETUP, 10=ACCESS
    .debug_psel_in(),        // APB3 PSEL input
    .debug_penable_in(),     // APB3 PENABLE input
    .debug_pwrite_in(),      // APB3 PWRITE input
    .debug_act_write(),      // Write strobe
    .debug_act_read(),       // Read strobe
    .debug_slave_ready(),    // Captured strobe
    .debug_pready_out(),     // PREADY output
    .debug_reg_addr()        // Register address
);

// =============================================================================
// GPIO LED Output Control
// =============================================================================
// Connect GPIO bit 0 (from RISC_mini) to LED #2 (CAM3_SDA_OUT)
// The RISC_V firmware can toggle this GPIO bit to blink the LED

// GPIO bit 0 is the LED output when writeEnable[0] is high
assign CAM3_SDA_OUT = (gpio_writeEnable[0]) ? gpio_write[0] : 1'b0;
assign CAM3_SDA_OE  = 1'b1;  // Always drive output

// LED #1 (CAM3_SCL): APB3 Address Decoder Status
// Shows if uart_mini_selected is being asserted
assign CAM3_SCL = uart_mini_debug_any_write;  // HIGH when address in range 0x0000-0x0FFF

// LED: CAM3_EN shows Ethernet link activity (TX/RX traffic)
assign CAM3_EN = eth_link_activity;

// =============================================================================
// UART Routing (Debug Console) - Using uart_mini instead of SoC UART
// =============================================================================
// Route uart_mini to physical pins instead of SoC UART
// uart_mini_txd → fpga_uart_tx (P10, GPIOB_TXN14)
// uart_mini_rxd ← fpga_uart_rx (N10, GPIOB_TXP14)
assign fpga_uart_tx = uart_mini_txd;    // uart_mini TX → Physical pin P10
assign uart_mini_rxd = fpga_uart_rx;    // uart_mini RX ← Physical pin N10

// SoC UART (sapphire_uart_txd, sapphire_uart_rxd) is not connected to physical pins
// (internal loopback below if needed for testing)
// assign sapphire_uart_rxd = sapphire_uart_txd;  // Uncomment for SoC loopback test

endmodule


