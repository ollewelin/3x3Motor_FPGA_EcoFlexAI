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
    input  wire         PLL_25MHZ,       // PLL 25MHZ 
    input wire          pll_clk_100Mhz,       //  pll_clk_100Mhz
    
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
    // CAM2 I2C Interface
    // =========================================================================
    output wire         CAM2_SCL,            // CAM2 is used
    output wire         CAM2_SDA_OUT,        // CAM2 is used
    output wire         CAM2_SDA_OE,         // CAM2 is used
    input  wire         CAM2_SDA_IN,         // CAM2 is used
    output wire         CAM2_EN,             // CAM2 is used

    // =========================================================================
    // MIPI CSI-2 Receiver instance (CAM2)
    // NOTE: these are fabric-side signals from the RX IP.
    // =========================================================================
    input  wire [63:0]  mipi_rx_inst1_DATA,
    input  wire         mipi_rx_inst1_VALID,
    input  wire [5:0]   mipi_rx_inst1_TYPE,
    input  wire [1:0]   mipi_rx_inst1_VC,
    input  wire [3:0]   mipi_rx_inst1_CNT,
    input  wire [3:0]   mipi_rx_inst1_HSYNC,
    input  wire [3:0]   mipi_rx_inst1_VSYNC,
    input  wire [17:0]  mipi_rx_inst1_ERROR,
    input  wire         mipi_rx_inst1_ULPS_CLK,
    input  wire [3:0]   mipi_rx_inst1_ULPS,

    // Control / enables (fabric → IP)
    output wire         mipi_rx_inst1_DPHY_RSTN,  // required
    output wire         mipi_rx_inst1_RSTN,       // required
    output wire [3:0]   mipi_rx_inst1_VC_ENA,
    output wire [1:0]   mipi_rx_inst1_LANES,
    output wire         mipi_rx_inst1_CLEAR,

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
localparam int RGMII_CLK_HZ = 25_000_000;   // RGMII clock frequency (100Mbit)

// =============================================================================
// Internal Signals
// =============================================================================

// Clock and Reset
logic       sys_clk;                         // 50 MHz system clock
logic       rgmii_clk;  
logic       rgmii_clk_debug;                      // 125 MHz RGMII clock (from PHY CLKOUT)
logic       sys_rst_n;                       // System reset (active HIGH from SoC!)
logic       sys_rst_n_inv;                   // Inverted: active LOW for peripherals
logic       rgmii_rst_n;                     // RGMII domain reset (synchronized)
// Debug: 125 MHz domain debug counter (8-bit)
logic [7:0]  debug_125mhz_cnt;                // increments on `rgmii_clk`
logic [28:0] major_reset_cnt;                // major reset counter
logic [7:0]  debug_25mhz_cnt;  
// Additional debug 4-bit counters (named debug_<xxx>_cnt)
logic [3:0]  debug_f2_rxc_cnt;                // clocked by F2_RXC (input)
logic [3:0]  debug_f2_txc_cnt;                // clocked by F2_TXC (output)
logic [3:0]  debug_f2_rxctl_cnt;              // clocked by F2_RXCTL (input)
logic [3:0]  debug_f2_txctl_cnt;              // clocked by F2_TXCTL (output)

// Debug: 1 MHz counter from 100 MHz PLL (divider = 100)
logic [26:0] debug_1mhz_divider;              // 27-bit counter (counts 0-99, wraps to 0)
logic        debug_1mhz_clk;                  // 1 MHz output clock (toggled every 50 counts)

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

// I2C signals (CAM2 interface from SoC)
logic         i2c_scl_write;                 // SCL write control (0=pull low, 1=release)
logic         i2c_sda_write;                 // SDA write control (0=pull low, 1=release)
logic         i2c_scl_read;                  // SCL bus state (open-drain)
logic         i2c_sda_read;                  // SDA bus state (open-drain)

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

// Simple 100Mbit RGMII signals (no DDR - single edge)
logic         mac_tx_en;
logic [3:0]   mac_tx_data;

// =============================================================================
// 100Mbit RGMII Signals (25 MHz - single edge capture/output)
// =============================================================================
// Simple RX capture (posedge of rgmii_clk)
// NOTE: At 100Mbit rates, rgmii_clk (25MHz PLL) and F2_RXC should be close enough
// Capturing on rgmii_clk avoids CDC issues and timing closure problems
logic         rx_dv;
logic [3:0]   rx_data;

always_ff @(posedge rgmii_clk) begin
    rx_dv   <= F2_RXCTL;
    rx_data <= {F2_RXD3, F2_RXD2, F2_RXD1, F2_RXD0};

end

// Simple TX output (posedge only, no DDR mux)
logic         tx_en;
logic [3:0]   tx_data;

// Send Ethernet IPG (Inter-Packet Gap) or valid padding
// Most reliable: send nothing (tx_en=0) when idle
always_ff @(posedge rgmii_clk) begin
    if (mac_tx_en) begin
        tx_en   <= 1'b1;
        tx_data <= mac_tx_data;  // Only output when MAC has data
    end else begin
        tx_en   <= 1'b0;         // Idle state
        tx_data <= 4'h0;
    end
end

always_ff @(posedge T120_GCLK) begin
    if (major_reset_cnt[28] == 1'b0) begin
        major_reset_cnt <= major_reset_cnt + 1;
        
    end
end
// RX signals are in rgmii_clk domain - no CDC needed at 100Mbit
logic rx_dv_synchronized;
logic [3:0] rx_data_synchronized;

assign rx_dv_synchronized = rx_dv;
assign rx_data_synchronized = rx_data;

// Output assignments - direct, no DDR mux
//assign F2_TXC   = rgmii_clk;     // Forward 25 MHz clock to PHY
assign F2_TXC   = rgmii_clk;
assign F2_TXCTL = tx_en;
assign F2_TXD0  = tx_data[0];
assign F2_TXD1  = tx_data[1];
assign F2_TXD2  = tx_data[2];
assign F2_TXD3  = tx_data[3];

// =============================================================================
// PHY Interrupt Synchronizer (async → sys_clk)
// =============================================================================
logic         intb_meta,  intb_sync;

// =============================================================================
// Clock and Reset Generation
// =============================================================================

// Direct clock assignment (Efinix GCLK buffers)
assign sys_clk   = T120_GCLK;    // 50 MHz system clock
assign rgmii_clk = PLL_25MHZ;    // 25 MHz from PLL (100Mbit RGMII mode)
assign rgmii_clk_debug = PLL_25MHZ;
//assign rgmii_clk = 1'b0;       // test how Eth Phy react with clock low constantly
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

always_ff @(posedge rgmii_clk_debug) begin
    debug_25mhz_cnt <= debug_25mhz_cnt + 1;
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

// =============================================================================
// 1 MHz Debug Counter from 100 MHz PLL
// =============================================================================
// Divides pll_clk_100Mhz by 100 to generate 1 MHz clock
// Counter wraps every 100 cycles, toggling output at wrapping point
// Output: 50% duty cycle 1 MHz square wave for logic analyser observation
always_ff @(posedge pll_clk_100Mhz or negedge sys_rst_n_inv) begin
    if (!sys_rst_n_inv) begin
        debug_1mhz_divider <= 26'd0;
        debug_1mhz_clk     <= 1'b0;
    end else if (debug_1mhz_divider == 26'd99) begin
        debug_1mhz_divider <= 26'd0;
        debug_1mhz_clk     <= ~debug_1mhz_clk;  // Toggle on wrap
    end else begin
        debug_1mhz_divider <= debug_1mhz_divider + 1;
    end
end
// Includes:
//   - RISC-V processor (RV32I)
//   - APB peripherals (UART, I2C, GPIO)
//   - Interrupt controller (PLIC)
//   - GPIO output for LED blink

RISC_mini u_sapphire_soc (
    // Clock and Reset
    .io_systemClk               (sys_clk),
    .io_systemReset             (sys_rst_n),  // Output from SoC (ACTIVE HIGH!)
    .io_asyncReset              (~major_reset_cnt[28]),       // 
    
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
    
    // I2C Interface (CAM2 I2C control)
    .system_i2c_0_io_scl_read   (i2c_scl_read),
    .system_i2c_0_io_scl_write  (i2c_scl_write),
    .system_i2c_0_io_sda_read   (i2c_sda_read),
    .system_i2c_0_io_sda_write  (i2c_sda_write),
    
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
// GPIO and I2C Signal Declarations
// =============================================================================
// Frame capture arm signal (driven from GPIO bit 1 of RISC_mini)
logic         cam_arm;                // ARM signal from GPIO[1]
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

assign debug_soc_apb_paddr = apb_paddr[15:0];  // Truncate to 16 bits for debug display
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
// 100Mbit RGMII MAC Instantiation (Simple - no DDR, single edge only)
// =============================================================================
// For 100Mbit mode, we don't need DDR. Data is captured/output on rising edge only.

// Simple stub: Connect RX signals from the RGMII pins directly
// TX signals go directly to the output mux logic above

// RX side: Assign captured data to frame "valid" when rx_dv is high
logic [15:0]  rx_byte_cnt;
logic         rx_in_frame;

always_ff @(posedge rgmii_clk or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        rx_in_frame  <= 1'b0;
        rx_byte_cnt  <= 16'd0;
        mac_rx_frame_valid <= 1'b0;
    end else begin
        // Simple RX state: when rx_dv_synchronized goes high, start frame
        if (rx_dv_synchronized && !rx_in_frame) begin
            rx_in_frame <= 1'b1;
            rx_byte_cnt <= 16'd1;
        end else if (rx_dv_synchronized && rx_in_frame) begin
            rx_byte_cnt <= rx_byte_cnt + 16'd1;
        end else if (!rx_dv_synchronized && rx_in_frame) begin
            rx_in_frame <= 1'b0;
            mac_rx_frame_valid <= 1'b1;  // Signal valid frame at end
        end else begin
            mac_rx_frame_valid <= 1'b0;
        end
    end
end

// Assign RX data from synchronized signals
assign mac_rx_fifo_data = rx_data_synchronized;
assign mac_rx_frame_len = rx_byte_cnt;
assign mac_rx_frame_error = 1'b0;
assign mac_rx_fifo_wr_en = rx_dv_synchronized;
assign mac_rx_fifo_full = 1'b0;  // Simplified - assume always ready

// TX side: Simple passthrough
// The bridge writes to mac_tx_fifo_data, we forward it to the RGMII output
// mac_tx_en and mac_tx_data are driven by the output mux logic above

logic [15:0]  tx_byte_cnt;
logic         tx_in_progress;

always_ff @(posedge rgmii_clk or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        tx_in_progress <= 1'b0;
        tx_byte_cnt <= 16'd0;
        mac_tx_busy <= 1'b0;
        mac_tx_done <= 1'b0;
    end else begin
        mac_tx_done <= 1'b0;  // Pulse
        if (mac_tx_start && !tx_in_progress) begin
            tx_in_progress <= 1'b1;
            tx_byte_cnt <= 16'd1;
            mac_tx_busy <= 1'b1;
        end else if (tx_in_progress) begin
            if (tx_byte_cnt >= mac_tx_frame_len) begin
                tx_in_progress <= 1'b0;
                mac_tx_busy <= 1'b0;
                mac_tx_done <= 1'b1;
            end else begin
                tx_byte_cnt <= tx_byte_cnt + 16'd1;
            end
        end
    end
end

// TX output: Driven by video_to_udp_tx module (see below)
// (Removed stub logic - now using dedicated video_to_udp_tx module for UDP TX)
assign mac_tx_fifo_rd_en = 1'b0;  // No longer using internal FIFO for TX

// Ethernet activity LED
assign eth_link_activity = rx_dv_synchronized | mac_tx_en;

// =============================================================================
// Simple APB3 Ethernet Slave (100Mbit stub - no complex bridge needed)
// =============================================================================
// For 100Mbit mode, provide minimal APB3 interface for status/control

// PHY Status Tracking (fixed values for 100Mbit mode)
assign phy_link_up = 1'b1;              // Assume 100M link is up
assign phy_speed_1g = 1'b0;             // 100Mbit, not 1Gbit
assign phy_full_duplex = 1'b1;          // Full duplex

// Note: eth_apb_prdata and eth_apb_pready are now driven by video_to_udp_tx module

// For now, tie off MAC control signals (will be driven by video_to_udp_tx when integrated)
// Note: These are now driven by video_to_udp_tx module below

// =============================================================================
// Video to UDP TX Module
// =============================================================================
// Handles video frame capture and UDP packet transmission over Ethernet
// Uses dummy pattern generator by default for testing

logic         vid_tx_en;
logic [3:0]   vid_tx_data;
logic [15:0]  vid_tx_frame_cnt;
logic [7:0]   vid_tx_state;

video_to_udp_tx #(
    .RGMII_CLK_HZ(RGMII_CLK_HZ),
    .SYS_CLK_HZ(SYS_CLK_HZ)
) u_video_to_udp (
    // Clock and Reset
    .rgmii_clk          (rgmii_clk),
    .rgmii_rst_n        (rgmii_rst_n),
    .sys_clk            (sys_clk),
    .sys_rst_n          (sys_rst_n_inv),
    
    // Video Input (dummy pattern used internally for now)
    .video_data         (8'h00),         // Unused - dummy pattern used
    .video_hsync        (1'b0),          // Unused - dummy pattern used
    .video_vsync        (1'b1),          // ENABLE continuous TX
    .video_valid        (1'b1),          // ENABLE frame transmission    
    // RGMII MAC TX Interface
    .mac_tx_en          (vid_tx_en),
    .mac_tx_data        (vid_tx_data),
    .mac_tx_busy        (mac_tx_busy),
    .mac_tx_done        (mac_tx_done),
    
    // APB3 Configuration Interface (address 0xf8102100+)
    .psel               (eth_apb_psel),
    .penable            (eth_apb_penable),
    .pwrite             (eth_apb_pwrite),
    .paddr              (eth_apb_paddr[3:0]),
    .pwdata             (eth_apb_pwdata),
    .prdata             (eth_apb_prdata),
    .pready             (eth_apb_pready),
    
    // Status/Debug
    .tx_active          (),
    .tx_frame_cnt       (vid_tx_frame_cnt),
    .tx_state           (vid_tx_state)
);

// Connect video_to_udp_tx outputs to MAC TX interface
assign mac_tx_en = vid_tx_en;
assign mac_tx_data = vid_tx_data;

// Tie off old bridge signals
assign mac_tx_start = 1'b0;
assign mac_tx_frame_len = 16'd0;
assign mac_tx_fifo_empty = 1'b1;
assign mac_tx_fifo_data = 8'h00;

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
//assign CAM3_SCL = uart_mini_debug_any_write;  // HIGH when address in range 0x0000-0x0FFF
assign CAM3_SCL = major_reset_cnt[26];  // 
// DEBUG: 1 MHz clock output on CAM3_EN for logic analyser observation
// This is the 100 MHz PLL divided by 100 to create a 1 MHz reference clock
// Useful for timing and synchronization debugging on the logic analyser
assign CAM3_EN = debug_1mhz_clk;

// =============================================================================
// GPIO Signals to Camera Control
// =============================================================================
// GPIO bit 1: Camera 2 Enable/Reset (XCLR for IMX219) - ACTIVE LOW via N-channel MOSFET
assign CAM2_EN = ~major_reset_cnt[28];  // LOW = camera enabled (MOSFET gates power when LOW)
// GPIO bit 1: Frame Capture Arm signal for video capture
assign cam_arm = (gpio_writeEnable[1]) ? gpio_write[1] : 1'b0;

// =============================================================================
// CAM2 I2C Open-Drain Interface (Tri-state Logic)
// =============================================================================
// I2C uses open-drain outputs:
//  - When write=0: pull the line LOW (drive 0)
//  - When write=1: release the line (high-Z, pulled HIGH by external resistors)
// The read signal reflects the actual bus state (0=low, 1=high)
//
// CAM2_SDA_OE control:
//  - 1 = drive output (pull low when SDA_OUT=0)
//  - 0 = high-Z (release, allow pull-up)

logic cam2_sda_oe;  // SDA output enable (active high)

// Open-drain logic: drive LOW when write=0, release (high-Z) when write=1
// The external pull-ups bring the line HIGH when released
assign cam2_sda_oe = ~i2c_sda_write;  // Drive LOW when write=0 (active LOW)

// Output assignments for CAM2 I2C
// CAM2_SCL is a plain output pin (peri.xml mode=output, no tristate).
// Drive it directly from i2c_scl_write: 0=pull low, 1=release high (push-pull SCL).
// This is safe for single-master use (no clock stretching required).
assign CAM2_SCL     = i2c_scl_write;   // SCL: 0=low, 1=high driven by I2C peripheral
assign CAM2_SDA_OUT = 1'b0;            // SDA output value (always 0; OE controls direction)
assign CAM2_SDA_OE  = cam2_sda_oe;     // Output enable: 1=drive low, 0=release (high-Z via pullup)

// SCL feedback: CAM2_SCL is output-only in peri.xml (no input path).
// Feed scl_write back to scl_read so the master sees its own drive level.
// When master drives SCL low (scl_write=0), scl_read=0 (consistent).
// When master releases SCL (scl_write=1), scl_read=1 (pull-up holds HIGH).
// Without this, the master sees scl_read=1 while driving scl_write=0
// and interprets the mismatch as arbitration loss, silently dropping frames.
assign i2c_scl_read = i2c_scl_write;   // Reflect master drive (no clock stretching)
assign i2c_sda_read = CAM2_SDA_IN;     // Read actual SDA bus state from pin

// =============================================================================
// MIPI CSI-2 Camera Interface (CAM2 - IMX219)
// =============================================================================
// Signals from MIPI RX IP (fabric-side, connected to record_frame_bram_counted)
logic [63:0]  mipi_cam2_data;
logic         mipi_cam2_valid;
logic [5:0]   mipi_cam2_type;
logic [1:0]   mipi_cam2_vc;
logic [3:0]   mipi_cam2_cnt;
logic [3:0]   mipi_cam2_hsync;
logic [3:0]   mipi_cam2_vsync;
logic [17:0]  mipi_cam2_error;

// Control signals to MIPI RX IP
logic         mipi_cam2_dphy_rstn;
logic         mipi_cam2_rstn;
logic [3:0]   mipi_cam2_vc_ena;
logic [1:0]   mipi_cam2_lanes;
logic         mipi_cam2_clear;

// Connect MIPI signals from module ports to internal logic
assign mipi_cam2_data  = mipi_rx_inst1_DATA;
assign mipi_cam2_valid = mipi_rx_inst1_VALID;
assign mipi_cam2_type  = mipi_rx_inst1_TYPE;
assign mipi_cam2_vc    = mipi_rx_inst1_VC;
assign mipi_cam2_cnt   = mipi_rx_inst1_CNT;
assign mipi_cam2_hsync = mipi_rx_inst1_HSYNC;
assign mipi_cam2_vsync = mipi_rx_inst1_VSYNC;
assign mipi_cam2_error = mipi_rx_inst1_ERROR;

// Control outputs to MIPI IP
assign mipi_rx_inst1_DPHY_RSTN = mipi_cam2_dphy_rstn;
assign mipi_rx_inst1_RSTN      = mipi_cam2_rstn;
assign mipi_rx_inst1_VC_ENA    = mipi_cam2_vc_ena;
assign mipi_rx_inst1_LANES     = mipi_cam2_lanes;
assign mipi_rx_inst1_CLEAR     = mipi_cam2_clear;

// MIPI RX control: enable 1 VC with 2 lanes, hold in reset initially
assign mipi_cam2_dphy_rstn = sys_rst_n_inv;  // DPHY reset = system reset
assign mipi_cam2_rstn      = sys_rst_n_inv;  // RX reset = system reset
assign mipi_cam2_vc_ena    = 4'b0001;        // Enable VC0 only
//assign mipi_cam2_lanes     = 2'b11;          // 2 lanes
assign mipi_cam2_lanes     = 2'b01;          // 2 lanes
// mipi_cam2_clear is driven by record_frame module

// Record frame module signals
logic         cam_arm;                 // Pulse to arm for one frame capture
logic         cam_armed;
logic         cam_capturing;
logic         cam_done;
logic         cam_clear_o;
logic [15:0]  cam_beats_line;
logic [15:0]  cam_line_idx;
logic [31:0]  cam_words_used;
logic         cam_uart_tx;

// Assign clear signal from cam module back to MIPI IP
assign mipi_cam2_clear = cam_clear_o;

// =============================================================================
// UART Switching Logic (20-second timer)
// =============================================================================
// For first 20 seconds: use uart_mini_txd
// After 20 seconds: switch to record_frame camera UART output
// Timer is based on sys_clk (50 MHz)

localparam int UART_SWITCH_TIME_SEC = 20;
localparam int UART_SWITCH_TIME_CLK = UART_SWITCH_TIME_SEC * 50_000_000;  // 1 billion cycles

logic [31:0]  uart_switch_timer;
logic         uart_switching_enabled;

always_ff @(posedge sys_clk or negedge sys_rst_n_inv) begin
    if (!sys_rst_n_inv) begin
        uart_switch_timer     <= 32'd0;
        uart_switching_enabled <= 1'b0;
    end else begin
        if (uart_switch_timer < UART_SWITCH_TIME_CLK) begin
            uart_switch_timer <= uart_switch_timer + 32'd1;
        end else begin
            uart_switching_enabled <= 1'b1;
        end
    end
end

// UART MUX: switch source after 20 seconds
logic fpga_uart_tx_mux;
assign fpga_uart_tx_mux = uart_switching_enabled ? cam_uart_tx : uart_mini_txd;
//assign fpga_uart_tx_mux = uart_mini_txd;  // For testing, keep uart_mini active (camera UART can be noisy during init)

// =============================================================================
// UART Routing (Debug Console)
// =============================================================================
// Route selected UART source to physical pins
// For first 20 seconds: uart_mini_txd (SoC I2C camera setup prints)
// After 20 seconds: cam_uart_tx from record_frame (camera data dump)

assign fpga_uart_tx = fpga_uart_tx_mux;      // Switched UART TX → Physical pin P10
assign uart_mini_rxd = fpga_uart_rx;          // uart_mini RX ← Physical pin N10

// SoC UART (sapphire_uart_txd, sapphire_uart_rxd) is not connected to physical pins
// (internal loopback below if needed for testing)
// assign sapphire_uart_rxd = sapphire_uart_txd;  // Uncomment for SoC loopback test

// =============================================================================
// record_frame_bram_counted Instantiation (CAM2 MIPI Frame Capture)
// =============================================================================
// Captures 192x192 RAW8 frames from MIPI RX and dumps via UART after camera init

// Clock domain for MIPI frame capture (synchronized from MIPI RX)
logic         pll_rst_n;              // Reset synchronized to pll_clk_100Mhz

// Synchronize system reset into 100 MHz PLL clock domain
always_ff @(posedge pll_clk_100Mhz or negedge sys_rst_n_inv) begin
    if (!sys_rst_n_inv) begin
        pll_rst_n <= 1'b0;
    end else begin
        pll_rst_n <= 1'b1;
    end
end

record_frame_bram_counted #(
    .CLOCK_HZ(100_000_000),             // MIPI PLL clock frequency (100 MHz)
    .BAUD(115200),                      // UART baud rate
    .WIDTH_PIX(192),                    // 192 sensor pixels = 96 colour dots wide
    .HEIGHT_LINES(192),                 // 192 sensor pixels = 96 colour dots tall
    .PIXELS_PER_BEAT(8),                // RAW8: 8 pixels per 64-bit bus beat
    .GAP_MIN_CYCLES(128),               // Idle cycles to detect line gap
    .CLEAR_CYCLES(128),                 // Clear pulse length after frame
    .AUTO_DUMP_UART(1'b1)               // Auto-dump BRAM to UART after capture
) u_record_frame_cam2 (
    .clk              (pll_clk_100Mhz), // MIPI hardware clock (100 MHz)
    .rst_n            (pll_rst_n),
    
    // MIPI RX fabric signals (CAM2)
    .data64           (mipi_cam2_data),
    .valid            (mipi_cam2_valid),
    .dtype            (mipi_cam2_type),
    .cnt              (mipi_cam2_cnt),
    .hsync            (mipi_cam2_hsync),
    .vsync            (mipi_cam2_vsync),
    .error_bus        (mipi_cam2_error),
    
    // Control signals
    .arm_i            (cam_arm),
    .armed_o          (cam_armed),
    .capturing_o      (cam_capturing),
    .done_o           (cam_done),
    .clear_o          (cam_clear_o),
    
    // Debug outputs
    .beats_line_o     (cam_beats_line),
    .line_idx_o       (cam_line_idx),
    .words_used_o     (cam_words_used),
    
    // UART output (to host after camera init completes)
    .uart_tx          (cam_uart_tx)
);

// =============================================================================
// debug_first_line_on_frame Instantiation
// =============================================================================
// Captures the first scan line of each MIPI frame into a small BRAM then
// continuously replays it byte-by-byte on debug outputs so a logic analyser
// can observe exactly what pixels arrive in the opening line.
//
// Logic-analyser connection guide:
//   Trigger channel : dbg1l_line_byte_tick  (rising edge – one pulse per byte)
//   Data channels   : dbg1l_line_debug_byte        [7:0]  byte value
//                     dbg1l_output_debug_pixel_cnt [7:0]  byte index 0..191
//                     dbg1l_frame_sync_out                new frame marker
//                     dbg1l_capture_active                HIGH while recording
//
// To probe these signals:
//   Option A – Efinix LA: add them to debug_profile.mark_debug.json
//   Option B – external analyser: route to spare GPIO output pins in peri.xml

logic [7:0]  dbg1l_line_debug_byte;
logic [7:0]  dbg1l_output_debug_pixel_cnt;
logic        dbg1l_line_byte_tick;
logic        dbg1l_frame_sync_out;
logic        dbg1l_capture_active;

debug_first_line_on_frame #(
    .BEATS_PER_LINE (24),    // 192 px / 8 px-per-beat  (RAW8 on 64-bit bus)
    .REPLAY_CLK_DIV (1000)   // 100 kHz byte rate at 100 MHz → easy LA capture
) u_debug_first_line (
    .clk                    (pll_clk_100Mhz),
    .rst_n                  (pll_rst_n),

    // MIPI RX signals (same source as u_record_frame_cam2)
    .data64                 (mipi_cam2_data),
    .valid                  (mipi_cam2_valid),
    .dtype                  (mipi_cam2_type),
    .hsync                  (mipi_cam2_hsync),
    .vsync                  (mipi_cam2_vsync),

    // Debug outputs → connect to logic analyser
    .line_debug_byte        (dbg1l_line_debug_byte),
    .output_debug_pixel_cnt (dbg1l_output_debug_pixel_cnt),
    .line_byte_tick         (dbg1l_line_byte_tick),
    .frame_sync_out         (dbg1l_frame_sync_out),
    .capture_active         (dbg1l_capture_active)
);



endmodule


