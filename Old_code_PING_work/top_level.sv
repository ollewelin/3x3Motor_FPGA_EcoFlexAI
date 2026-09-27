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

`include "eth_mac_100m.sv"
`include "record_video.sv"
`include "standalone_uart_tx.sv"
`include "blue_wire_byte_recorder.sv"

module top_level (
    // =========================================================================
    // External Clock (50 MHz)
    // =========================================================================
    input  wire         T120_GCLK,           // External 50 MHz clock
    input  wire         PLL_25MHZ,       // PLL 25MHZ 
    input wire          pll_clk_100Mhz,       // To fast pll_clk_100Mhz
    input  wire         pll_clk_75Mhz,       // Reduce to pll_clk_75Mhz
    //input  wire         pll_clk_60Mhz,       // Reduce to pll_clk_60Mhz
    input  wire         pll_clk_50Mhz,       // Reduce to pll_clk_50Mhz
    //inout  wire         pll_clk_80Mhz,       // Reduce to pll_clk_80Mhz
    
    // =========================================================================
    // UART Debug Interface (115200 baud)
    // =========================================================================
    output wire         fpga_uart_tx,        // UART TX (XB2, P10) → USB-UART TX
    //input  wire         fpga_uart_rx,        // UART RX (XB3, N10) ← USB-UART RX
    output wire uart_tx_xb3_pin5,// UART TX (XB3, N10) → USB-UART TX
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
    // Blue-Wire Byte Recorder UART TX (XB7 pin)
    // =========================================================================
    output wire         XB7,                 // // U58 connector pin 6. UART TX for blue-wire recorder (GPIOB_TXP16)

    // =========================================================================
    // Blue-Wire Video Bus (50 MHz byte stream, one byte per vid_clk rising edge)
    // =========================================================================
  //  output wire         blue_vid_clk,        // 50 MHz byte clock
  //  output wire [7:0]   blue_vid_d,          // Video data byte (left-pixel first)
  //  output wire         blue_vid_overflow,   // Debug: throughput overflow flag
  //  output wire         blue_vid_idle,       // Debug: waiting for next frame
    output wire         XB9,    // U58 connector pin 7
    output wire         XB8,    // U58 connector pin 8
    output wire         XB4,    // U58 connector pin 9
    output wire         XB5,    // U58 connector pin 10
    output wire         XB10,   // U58 connector pin 11
    output wire         XB6,    // U58 connector pin 12
    output wire         XB11,   // U58 connector pin 13
    output wire         XB15,   // U58 connector pin 14
    output wire         XB13,   // U58 connector pin 15
    output wire         XB14,   // U58 connector pin 16
    output wire         XB21,   // U58 connector pin 17
    output wire         RXP19_CLK_N,   // U58 connector pin 18
    output wire         RXP19_CLK_P,   // U58 connector pin 19

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
logic        debug_2mhz_clk;                  // 2 MHz output clock (toggled every 25 counts)

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
logic         xb7_uart_txd;                // UART TX routed to XB7 pin for blue-wire recorder

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

// Analyzer debug_bits from buses.
logic         debug_hsync_bit0;
logic         debug_vsync_bit0;

always_ff @(posedge T120_GCLK) begin
    if (major_reset_cnt[28] == 1'b0) begin
        major_reset_cnt <= major_reset_cnt + 1;
    end
end

// RGMII TX Data nibble to pins (driven by eth_mac_100m)
logic [3:0] eth_txd;
assign F2_TXD0  = eth_txd[0];
assign F2_TXD1  = eth_txd[1];
assign F2_TXD2  = eth_txd[2];
assign F2_TXD3  = eth_txd[3];

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

//debug bits
assign debug_hsync_bit0 = mipi_rx_inst1_HSYNC[0];
assign debug_vsync_bit0 = mipi_rx_inst1_VSYNC[0];

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
// 1 MHz Debug Counter from 50 MHz PLL
// =============================================================================
// Divides pll_clk_50Mhz by 50 to generate 1 MHz clock
// Counter wraps every 50 cycles, toggling output at wrapping point
// Output: 50% duty cycle 1 MHz square wave for logic analyser observation
always_ff @(posedge pll_clk_50Mhz or negedge sys_rst_n_inv) begin
    if (!sys_rst_n_inv) begin
        debug_1mhz_divider <= 26'd0;
        debug_1mhz_clk     <= 1'b0;
        debug_2mhz_clk     <= 1'b0;
    end else if (debug_1mhz_divider == 26'd24) begin
        debug_2mhz_clk     <= ~debug_2mhz_clk;  // Toggle at half (2 MHz)
        debug_1mhz_divider <= debug_1mhz_divider + 1;
    end else if (debug_1mhz_divider == 26'd49) begin
        debug_1mhz_divider <= 26'd0;
        debug_1mhz_clk     <= ~debug_1mhz_clk;  // Toggle on wrap (1 MHz)
        debug_2mhz_clk     <= ~debug_2mhz_clk;  // Toggle on wrap (2 MHz)
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
// 100Mbit RGMII Ethernet MAC with APB3 Interface (0xf8102000)
// =============================================================================
eth_mac_100m u_eth_mac_100m (
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n_inv),

    .apb_paddr      (eth_apb_paddr),
    .apb_psel       (eth_apb_psel),
    .apb_penable    (eth_apb_penable),
    .apb_pwrite     (eth_apb_pwrite),
    .apb_pwdata     (eth_apb_pwdata),
    .apb_prdata     (eth_apb_prdata),
    .apb_pready     (eth_apb_pready),
    .apb_pslverr    (),

    .rgmii_tx_clk   (rgmii_clk),     // 25 MHz from PLL
    .rgmii_txc      (F2_TXC),        // 25 MHz forward clock to PHY
    .rgmii_txctl    (F2_TXCTL),      // TX control
    .rgmii_txd      (eth_txd),       // TX data nibble [3:0]

    .rgmii_rxc      (F2_RXC),        // 25 MHz RX clock from PHY
    .rgmii_rxctl    (F2_RXCTL),      // RX control
    .rgmii_rxd      ({F2_RXD3, F2_RXD2, F2_RXD1, F2_RXD0}),

    .phy_link_up    (1'b1),
    .activity_led   (eth_link_activity)
);

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
// Signals from MIPI RX IP (fabric-side, connected to record_video)
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
// mipi_cam2_clear: tied off (record_video has no separate CLEAR output)

// Record video module signals
logic         cam_capturing;
logic         cam_done;
logic [15:0]  cam_line_idx;
logic [31:0]  cam_words_used;

// Blue-wire video bus (internal, routed to output ports)
logic         vid_clk_int;
logic [7:0]   vid_d_int;
logic         vid_overflow_int;
logic         vid_frame_sync_n_int;
logic         hsync_timeout_alarm_int;
logic         vsync_frame_alarm_int;

// MIPI clear: tie off (record_video handles its own gating)
assign mipi_cam2_clear = 1'b0;

// =============================================================================
// UART Switching Logic (20-second timer)
// =============================================================================
// For first 20 seconds: use uart_mini_txd
// =============================================================================
// UART Routing (Direct — SoC uart_mini only, no MUX)
// =============================================================================
assign fpga_uart_tx  = uart_mini_txd;   // UART TX → Physical pin P10 (FTDI USB-UART)
assign XB7           = xb7_uart_txd;   // U58 connector pin 20 (blue-wire recorder)
//assign uart_mini_rxd = fpga_uart_rx;    // UART RX ← Physical pin N10


// =============================================================================
// record_video Instantiation (CAM2 MIPI Frame + Line Streaming)
// =============================================================================
// Captures 224x224 RAW8 frames from MIPI RX.
// Streams each line over the blue-wire video bus (vid_clk / vid_d[7:0]) at 20 MHz.
// Full frame is also stored in block RAM.

// Synchronize system reset into 50 MHz PLL clock domain
logic         pll_rst_n;
always_ff @(posedge pll_clk_50Mhz or negedge sys_rst_n_inv) begin
    if (!sys_rst_n_inv) pll_rst_n <= 1'b0;
    else                pll_rst_n <= 1'b1;
end

record_video #(
    .CLOCK_HZ         (50_000_000),    // MIPI PLL fabric clock (50 MHz)
    .BLUE_BYTE_SPEED  (25_000_000),    // vid_clk frequency (25 MHz)
    .WIDTH_PIX        (224),           // 224 pixels wide
    .HEIGHT_LINES     (224),           // 224 lines tall
    .PIXELS_PER_BEAT  (8),             // RAW8: 8 bytes per 64-bit bus beat
    .GAP_MIN_CYCLES   (10),           // Idle cycles to delimit a line
    .HSYNC_TIMEOUT_US (128),           // 128 us hsync timeout -> restart
    .BAUD             (115200)         // UART baud for frame dump
) u_record_video (
    .clk                      (pll_clk_50Mhz),
    .rst_n                    (pll_rst_n),

    // MIPI RX fabric signals (CAM2)
    .data64                   (mipi_cam2_data),
    .valid                    (mipi_cam2_valid),
    .dtype                    (mipi_cam2_type),
    .cnt                      (mipi_cam2_cnt),
    .hsync                    (mipi_cam2_hsync),
    .vsync                    (mipi_cam2_vsync),
    .error_bus                (mipi_cam2_error),

    // Blue-wire video bus
    .vid_clk                  (vid_clk_int),
    .vid_d                    (vid_d_int),
    .throughput_overflow_error(vid_overflow_int),
    .vid_frame_sync_n         (vid_frame_sync_n_int),

    // Debug alarms
    .hsync_bit0               (),  // already available as debug_hsync_bit0
    .vsync_bit0               (),  // already available as debug_vsync_bit0
    .hsync_timeout_alarm      (hsync_timeout_alarm_int),
    .vsync_frame_alarm        (vsync_frame_alarm_int),

    // Status
    .capturing_o              (cam_capturing),
    .done_o                   (cam_done),
    .line_idx_o               (cam_line_idx),
    .words_used_o             (cam_words_used),

    // UART frame dump
    .frame_uart_tx            (uart_tx_xb3_pin5)
);

// Route blue-wire signals to top-level output ports
assign XB9 = vid_frame_sync_n_int;  // U58 connector pin 7  (LOW=frame active, HIGH=idle)
assign XB8 = vid_overflow_int;  // U58 connector pin 8
assign XB4 = vid_clk_int;       // U58 connector pin 9
assign XB5 = vid_d_int[0];     // U58 connector pin 10
assign XB10 = vid_d_int[1];     // U58 connector pin 11
assign XB6 = vid_d_int[2];     // U58 connector pin 12
assign XB11 = vid_d_int[3];     // U58 connector pin 13
assign XB15 = vid_d_int[4];     // U58 connector pin 14
assign XB13 = vid_d_int[5];     // U58 connector pin 15
assign XB14 = vid_d_int[6];     // U58 connector pin 16
assign XB21 = vid_d_int[7];     // U58 connector pin 17 




// =============================================================================
// Blue-Wire Byte Recorder (test module)
// =============================================================================
// Captures one frame from the blue-wire bus, stores it in local BRAM,
// then dumps all bytes via UART on XB7 pin (115200 baud, "S" + hex format).

blue_wire_byte_recorder #(
    .CLOCK_HZ     (50_000_000),      // 50 MHz PLL clock (must oversample 25 MHz vid_clk)
    .BAUD         (115200),
    .WIDTH_PIX    (224),
    .HEIGHT_LINES (224)
) u_blue_wire_recorder (
    .sys_clk        (pll_clk_50Mhz),   // 50 MHz — same domain as vid_clk source
    .rst_n          (sys_rst_n_inv),

    // Blue-wire video bus
    .vid_frame_sync_n (vid_frame_sync_n_int),
    .vid_clk          (vid_clk_int),
    .vid_d            (vid_d_int),

    // UART TX → XB7 pin
    .txd            (xb7_uart_txd),  // Connect to XB7 pin for UART output

    // Status (unconnected for now)
    .frame_captured (RXP19_CLK_N),  // U58 connector pin 18
    .dumping        (RXP19_CLK_P)   // U58 connector pin 19
);

endmodule


