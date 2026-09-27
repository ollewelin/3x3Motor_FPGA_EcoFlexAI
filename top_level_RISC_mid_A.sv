// =============================================================================
// top_level_RISC_mid_A.sv : RISC_mid_A SoC + DDR3 Integration
// =============================================================================
// Efinix T120F324 FPGA with RISC_mid_A RISC-V SoC + DDR3 Memory
// 
// Architecture:
//   1. RISC_mid_A SoC (RV32I processor + peripherals + AXI DDR3 interface)
//   2. GPIO output for LED test feedback
//   3. DDR3 SDRAM Controller (AXI4 master interface)
//   4. JTAG Debug Interface (OpenOCD compatible)
//
// Clock/Reset:
//   - sys_clk: 50 MHz (from T120_GCLK external oscillator)
//   - ddr_clk: 200 MHz (from PLL for DDR3)
//   - sys_rst_n: Generated internally (power-on reset)
//
// Memory Map:
//   - 0xf9000000: On-chip BRAM (32KB) - boot code and initial stack
//   - 0x80000000: External DDR3 SDRAM (via AXI master) - main code/data
//
// AXI DDR3 Interface:
//   - 128-bit data bus
//   - Full duplex AXI4 read/write channels
//   - Supports burst transactions
//
// =============================================================================

`timescale 1ns / 1ps

module top_level_RISC_mid_A (
    // =========================================================================
    // External Clock (50 MHz)
    // =========================================================================
    input  wire         T120_GCLK,           // External 50 MHz clock
    
    // =========================================================================
    // UART Debug Interface (115200 baud) - DANGLING FOR FUTURE USE
    // =========================================================================
    // NOTE: UART ports are available but not connected in current configuration
    // RISC_mid_A does not expose UART externally; available through debug bridge
    // Ports left for future use when custom UART bridge is implemented
    output wire         fpga_uart_tx,        // UART TX (XB2, P10) → USB-UART TX (FUTURE USE)
    input  wire         fpga_uart_rx,        // UART RX (XB3, N10) ← USB-UART RX (FUTURE USE)
    // MDIO: Management interface (for PHY configuration)
    output wire         F2_MDC,              // MDIO Clock (GPIOB_TXN01, T18)
    input  wire         F2_MDIO_IN,          // MDIO Input (GPIOB_TXN05, R15)
    output wire         F2_MDIO_OUT,         // MDIO Output (GPIOB_TXN05, R15)
    output wire         F2_MDIO_OE,          // MDIO Output Enable (GPIOB_TXN05, R15)
    output wire         F2_RSTB,             // PHY Reset (GPIOB_TXP00, T17)
    
    // RGMII: Data path (receive from PHY)
    input  wire         F2_RXC,              // RX Clock (GPIOR_178)
    input  wire         F2_RXCTL,            // RX Control (GPIOB_TXP08)
    input  wire [3:0]   F2_RXD,              // RX Data[3:0]
    
    // RGMII: Data path (transmit to PHY)
    output wire         F2_TXC,              // TX Clock (GPIOB_TXP07)
    output wire         F2_TXCTL,            // TX Control (GPIOB_TXP05)
    output wire [3:0]   F2_TXD,              // TX Data[3:0]
    
    // Interrupt from PHY
    input  wire         F2_INTB,             // PHY Interrupt (GPIOB_TXP02)
    
    // External clock input for PHY
    input  wire         F2_EXT_CLK,          // External clock (GPIOR_174)
    
    // =========================================================================
    // Debug/Status Outputs (Tri-state GPIO)
    // =========================================================================
    output wire         CAM3_SCL,            // LED #1 (Status)
    output wire         CAM3_SDA_OUT,        // LED #2 (Test Output) - output data
    output wire         CAM3_SDA_OE,         // LED #2 output enable
    input  wire         CAM3_SDA_IN,         // LED #2 input (unused)
    output wire         CAM3_EN,             // Status output (unused)
    
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
    
    // =========================================================================
    // DDR3 Controller Interface (ddr_inst1 - external to FPGA)
    // =========================================================================
    // NOTE: COMMENTED OUT - Removed external memory AXI interface to simplify design
    // Will be re-added once core CPU execution is verified working
    /*
    input  wire         ddr_clk,             // 200 MHz DDR clock from PLL
    
    // DDR3 Configuration Control Signals
    output wire         ddr_inst1_CFG_RST_N,      // Configuration reset (active low)
    output wire         ddr_inst1_CFG_SEQ_RST,    // Sequencer reset
    output wire         ddr_inst1_CFG_SEQ_START,  // Sequencer start
    
    // AXI Write Address Channel
    output wire         ddr_aw_valid,
    input  wire         ddr_aw_ready,
    output wire [31:0]  ddr_aw_addr,
    output wire [7:0]   ddr_aw_id,
    output wire [7:0]   ddr_aw_len,
    output wire [2:0]   ddr_aw_size,
    output wire [1:0]   ddr_aw_burst,
    output wire         ddr_aw_lock,
    output wire [3:0]   ddr_aw_cache,
    output wire [2:0]   ddr_aw_prot,
    output wire [3:0]   ddr_aw_qos,
    output wire [3:0]   ddr_aw_region,
    
    // AXI Write Data Channel
    output wire         ddr_w_valid,
    input  wire         ddr_w_ready,
    output wire [127:0] ddr_w_data,
    output wire [15:0]  ddr_w_strb,
    output wire         ddr_w_last,
    
    // AXI Write Response Channel
    input  wire         ddr_b_valid,
    output wire         ddr_b_ready,
    input  wire [7:0]   ddr_b_id,
    input  wire [1:0]   ddr_b_resp,
    
    // AXI Read Address Channel
    output wire         ddr_ar_valid,
    input  wire         ddr_ar_ready,
    output wire [31:0]  ddr_ar_addr,
    output wire [7:0]   ddr_ar_id,
    output wire [7:0]   ddr_ar_len,
    output wire [2:0]   ddr_ar_size,
    output wire [1:0]   ddr_ar_burst,
    output wire         ddr_ar_lock,
    output wire [3:0]   ddr_ar_cache,
    output wire [2:0]   ddr_ar_prot,
    output wire [3:0]   ddr_ar_qos,
    output wire [3:0]   ddr_ar_region,
    
    // AXI Read Data Channel
    input  wire         ddr_r_valid,
    output wire         ddr_r_ready,
    input  wire [127:0] ddr_r_data,
    input  wire [7:0]   ddr_r_id,
    input  wire [1:0]   ddr_r_resp,
    input  wire         ddr_r_last
    */
);

// =============================================================================
// Internal Signal Declarations
// =============================================================================

// System clock and reset
logic         sys_clk;                      // 50 MHz system clock
logic         sys_rst_n;                    // Active-low system reset

// APB Interface (unused - RISC_mid_A has io_apbSlave_0_* internal ports)
logic [15:0]  io_apbSlave_0_PADDR;           // Address bus
logic         io_apbSlave_0_PSEL;            // Peripheral select
logic         io_apbSlave_0_PENABLE;         // Enable signal
logic         io_apbSlave_0_PWRITE;          // Write enable
logic [31:0]  io_apbSlave_0_PWDATA;          // Write data
logic [31:0]  io_apbSlave_0_PRDATA;          // Read data
logic         io_apbSlave_0_PREADY;          // Ready signal
logic         io_apbSlave_0_PSLVERROR;       // Slave error

// GPIO signals (from RISC_mid_A)
logic [3:0]   gpio_write;                   // GPIO write data
logic [3:0]   gpio_writeEnable;             // GPIO write enable
logic [3:0]   gpio_read;                    // GPIO read data

// =============================================================================
// Clock and Reset Generation
// =============================================================================

// Direct clock assignment
assign sys_clk = T120_GCLK;

// Power-on reset: Assert async reset briefly to trigger SoC's internal reset generator
// Hold reset low for ~1ms, then release
logic [19:0] pwr_on_counter;  // ~1ms at 50MHz
always @(posedge sys_clk) begin
    if (pwr_on_counter != 20'hFFFFF)
        pwr_on_counter <= pwr_on_counter + 1'b1;
end
wire async_reset = (pwr_on_counter == 20'hFFFFF) ? 1'b1 : 1'b0;  // Assert briefly, then release

// =============================================================================
// RISC_mid_A SoC Instantiation with DDR3
// =============================================================================
// Includes:
//   - RISC-V RV32I processor
//   - APB slave interface (peripherals)
//   - AXI master interface (DDR3 memory via io_ddrA_* ports)
//   - GPIO, I2C, SPI peripherals
//   - Interrupt controller (PLIC)
//   - JTAG debug interface
//
// Note: RISC_mid_A uses axiA_* naming for AXI4 bus (32-bit data)
//       and io_ddrA_* naming for DDR3 AXI interface (128-bit data)

RISC_mid_A u_sapphire_soc (
    // Clock and Reset
    .io_systemClk               (sys_clk),
    .io_systemReset             (sys_rst_n),      // Output from SoC
    .io_asyncReset              (async_reset),    // Async reset input - pulse briefly to trigger internal reset
    // NOTE: Peripheral clock/reset removed - not available without external memory interface
    // .io_peripheralClk           (sys_clk),        // Peripheral clock (same as system)
    // .io_peripheralReset         (),               // Peripheral reset output (unused)
    
    // APB Slave Interface (from RISC-V master to peripherals)
    .io_apbSlave_0_PADDR        (io_apbSlave_0_PADDR[15:0]),
    .io_apbSlave_0_PSEL         (io_apbSlave_0_PSEL),
    .io_apbSlave_0_PENABLE      (io_apbSlave_0_PENABLE),
    .io_apbSlave_0_PWRITE       (io_apbSlave_0_PWRITE),
    .io_apbSlave_0_PWDATA       (io_apbSlave_0_PWDATA),
    .io_apbSlave_0_PRDATA       (io_apbSlave_0_PRDATA),
    .io_apbSlave_0_PREADY       (io_apbSlave_0_PREADY),
    .io_apbSlave_0_PSLVERROR    (io_apbSlave_0_PSLVERROR),
    
    // AXI4 DDR Master Interface (128-bit DDR3 controller - Full AXI4)
    // NOTE: COMMENTED OUT - Removed external memory AXI interface to simplify design
    /*
    // Write Address Channel
    .io_ddrA_aw_valid           (ddr_aw_valid),
    .io_ddrA_aw_ready           (ddr_aw_ready),
    .io_ddrA_aw_payload_addr    (ddr_aw_addr),
    .io_ddrA_aw_payload_id      (ddr_aw_id),
    .io_ddrA_aw_payload_len     (ddr_aw_len),
    .io_ddrA_aw_payload_size    (ddr_aw_size),
    .io_ddrA_aw_payload_burst   (ddr_aw_burst),
    .io_ddrA_aw_payload_lock    (ddr_aw_lock),
    .io_ddrA_aw_payload_cache   (ddr_aw_cache),
    .io_ddrA_aw_payload_prot    (ddr_aw_prot),
    .io_ddrA_aw_payload_qos     (ddr_aw_qos),
    .io_ddrA_aw_payload_region  (ddr_aw_region),
    // Write Data Channel
    .io_ddrA_w_valid            (ddr_w_valid),
    .io_ddrA_w_ready            (ddr_w_ready),
    .io_ddrA_w_payload_data     (ddr_w_data),
    .io_ddrA_w_payload_strb     (ddr_w_strb),
    .io_ddrA_w_payload_last     (ddr_w_last),
    // Write Response Channel
    .io_ddrA_b_valid            (ddr_b_valid),
    .io_ddrA_b_ready            (ddr_b_ready),
    .io_ddrA_b_payload_id       (ddr_b_id),
    .io_ddrA_b_payload_resp     (ddr_b_resp),
    // Read Address Channel
    .io_ddrA_ar_valid           (ddr_ar_valid),
    .io_ddrA_ar_ready           (ddr_ar_ready),
    .io_ddrA_ar_payload_addr    (ddr_ar_addr),
    .io_ddrA_ar_payload_id      (ddr_ar_id),
    .io_ddrA_ar_payload_len     (ddr_ar_len),
    .io_ddrA_ar_payload_size    (ddr_ar_size),
    .io_ddrA_ar_payload_burst   (ddr_ar_burst),
    .io_ddrA_ar_payload_lock    (ddr_ar_lock),
    .io_ddrA_ar_payload_cache   (ddr_ar_cache),
    .io_ddrA_ar_payload_prot    (ddr_ar_prot),
    .io_ddrA_ar_payload_qos     (ddr_ar_qos),
    .io_ddrA_ar_payload_region  (ddr_ar_region),
    // Read Data Channel
    .io_ddrA_r_valid            (ddr_r_valid),
    .io_ddrA_r_ready            (ddr_r_ready),
    .io_ddrA_r_payload_data     (ddr_r_data),
    .io_ddrA_r_payload_id       (ddr_r_id),
    .io_ddrA_r_payload_resp     (ddr_r_resp),
    .io_ddrA_r_payload_last     (ddr_r_last),
    */
    
    // I2C Interface (not connected)
    .system_i2c_0_io_scl_read   (1'b1),
    .system_i2c_0_io_scl_write  (),
    .system_i2c_0_io_sda_read   (1'b1),
    .system_i2c_0_io_sda_write  (),
    
    // GPIO Interface - for LED test output (GPIO bit 0)
    .system_gpio_0_io_writeEnable (gpio_writeEnable),
    .system_gpio_0_io_write     (gpio_write),
    .system_gpio_0_io_read      (gpio_read),
    
    // SPI Interface (not connected)
    .system_spi_0_io_data_0_read    (1'b0),
    .system_spi_0_io_data_0_write   (),
    .system_spi_0_io_data_0_writeEnable (),
    .system_spi_0_io_data_1_read    (1'b0),
    .system_spi_0_io_data_1_write   (),
    .system_spi_0_io_data_1_writeEnable (),
    .system_spi_0_io_data_2_read    (1'b0),
    .system_spi_0_io_data_2_write   (),
    .system_spi_0_io_data_2_writeEnable (),
    .system_spi_0_io_data_3_read    (1'b0),
    .system_spi_0_io_data_3_write   (),
    .system_spi_0_io_data_3_writeEnable (),
    .system_spi_0_io_sclk_write     (),
    .system_spi_0_io_ss             (),
    
    // User Interrupt (not used)
    .userInterruptA             (1'b0),
    
    // AXI4 DDR Master Interface (32-bit - for optional on-chip DDR master)
    // NOTE: COMMENTED OUT - Removed external memory interface to simplify design
    /*
    // Note: This is a 32-bit AXI interface to DDR, currently not used
    .io_ddrMasters_0_clk            (sys_clk),
    .io_ddrMasters_0_reset          (),
    .io_ddrMasters_0_ar_valid       (1'b0),
    .io_ddrMasters_0_ar_ready       (),
    .io_ddrMasters_0_ar_payload_addr (32'h0),
    .io_ddrMasters_0_ar_payload_id  (4'h0),
    .io_ddrMasters_0_ar_payload_len (8'h0),
    .io_ddrMasters_0_ar_payload_size (3'h0),
    .io_ddrMasters_0_ar_payload_burst (2'h0),
    .io_ddrMasters_0_ar_payload_lock (1'b0),
    .io_ddrMasters_0_ar_payload_cache (4'h0),
    .io_ddrMasters_0_ar_payload_prot (3'h0),
    .io_ddrMasters_0_ar_payload_qos (4'h0),
    .io_ddrMasters_0_ar_payload_region (4'h0),
    .io_ddrMasters_0_r_valid        (),
    .io_ddrMasters_0_r_ready        (1'b1),
    .io_ddrMasters_0_r_payload_data (),
    .io_ddrMasters_0_r_payload_id   (),
    .io_ddrMasters_0_r_payload_resp (),
    .io_ddrMasters_0_r_payload_last (),
    .io_ddrMasters_0_aw_valid       (1'b0),
    .io_ddrMasters_0_aw_ready       (),
    .io_ddrMasters_0_aw_payload_addr (32'h0),
    .io_ddrMasters_0_aw_payload_id  (4'h0),
    .io_ddrMasters_0_aw_payload_len (8'h0),
    .io_ddrMasters_0_aw_payload_size (3'h0),
    .io_ddrMasters_0_aw_payload_burst (2'h0),
    .io_ddrMasters_0_aw_payload_lock (1'b0),
    .io_ddrMasters_0_aw_payload_cache (4'h0),
    .io_ddrMasters_0_aw_payload_prot (3'h0),
    .io_ddrMasters_0_aw_payload_qos (4'h0),
    .io_ddrMasters_0_aw_payload_region (4'h0),
    .io_ddrMasters_0_w_valid        (1'b0),
    .io_ddrMasters_0_w_ready        (),
    .io_ddrMasters_0_w_payload_data (32'h0),
    .io_ddrMasters_0_w_payload_strb (4'hF),
    .io_ddrMasters_0_w_payload_last (1'b1),
    .io_ddrMasters_0_b_valid        (),
    .io_ddrMasters_0_b_ready        (1'b1),
    .io_ddrMasters_0_b_payload_id   (),
    .io_ddrMasters_0_b_payload_resp (),
    */
    
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
// GPIO LED Output Control
// =============================================================================
// Connect GPIO bit 0 (from RISC_mid_A) to LED #2 (CAM3_SDA_OUT)
// The RISC_V firmware can toggle this GPIO bit to blink the LED during DDR3 test

assign CAM3_SDA_OUT = (gpio_writeEnable[0]) ? gpio_write[0] : 1'b0;
assign CAM3_SDA_OE  = 1'b1;  // Always drive output

// LED #1 (CAM3_SCL): Not used (pull high)
assign CAM3_SCL = 1'b1;

// Spare Output (CAM3_EN): Not used
assign CAM3_EN = 1'b0;

// =============================================================================
// UART Routing (DANGLING FOR FUTURE USE)
// =============================================================================
// NOTE: UART pins are left floating for future use
// When a custom UART bridge is implemented, connect here
// For now, leave as dangling ports - they won't affect functionality

// FUTURE: assign fpga_uart_tx = uart_tx_from_bridge;
// FUTURE: assign uart_rx_to_bridge = fpga_uart_rx;

// =============================================================================
// Unused Ethernet PHY Signals (not used in this configuration)
// =============================================================================
// For now, disable MDIO and RGMII interfaces
// These can be re-enabled later if needed

// MDIO Interface (disabled)
assign F2_MDC   = 1'b0;
assign F2_MDIO_OUT = 1'b0;
assign F2_MDIO_OE  = 1'b0;

// PHY Reset (held in reset)
assign F2_RSTB = 1'b0;

// RGMII TX Interface (disabled)
assign F2_TXC   = 1'b0;
assign F2_TXCTL = 1'b0;
assign F2_TXD   = 4'h0;

// =============================================================================
// DDR3 Controller Configuration Signals
// =============================================================================
// NOTE: COMMENTED OUT - DDR3 interface removed for simplification
// Will be re-enabled once core CPU execution is verified
/*
assign ddr_inst1_CFG_RST_N = 1'b1;         // De-assert configuration reset
assign ddr_inst1_CFG_SEQ_RST = 1'b0;       // De-assert sequencer reset
assign ddr_inst1_CFG_SEQ_START = 1'b1;     // Start DDR3 initialization sequence
*/

endmodule

