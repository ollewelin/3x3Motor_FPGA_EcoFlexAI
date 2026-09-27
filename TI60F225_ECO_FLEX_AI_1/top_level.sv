// Simple top-level with two 22-bit rolling counters
// - `counter_clk` increments on the rising edge of `clk`
// - `counter_pll` increments on the rising edge of `PLL_125MHZ`
module top_level (
	input  wire clk,
	input  wire PLL_125MHZ,
    input  wire PLL_100MHZ,
    input  wire PLL_25MHZ,
    input wire PLL_125_TXC, // This is the PLL_125MHZ clock output dedicated for RGMII TX clocking. We will connect this to ETH2_TXC for proper RGMII timing.
	output wire ETH2_TXC,// This is defied as an clkout in the .peri file 
                         // so that means we must not assaign it in the code, 
                         // otherwise we get an error about multiple drivers. We can use it as an output though, so we can assign it here in this top_level file. 
                         // Just leave this clkout unassigned here is the correct way to do.
    output wire GPIOB_P_02, // GPIOB_P_02 pin Connector H1-pin4 PLL_!25MHZ clock output for debugging (optional, can be left unconnected if not needed)
    input wire GPIOB_P_07, // clock input GPIOB_P_07 pin Connector H1-pin6 hardware loopback from GPIOB_P_02 pin Connector H1-pin4
    output wire LED3,
    output wire LED4,
    output wire UART_TX,
    output wire vid_uart_tx, // UART TX for video data path (optional, can be left unconnected if not needed)
    input  wire UART_RX,

    // MDIO: Management interface (for PHY configuration)
    output wire         ETH2_MDC,              // MDIO Clock 
    input  wire         ETH2_MDIO_IN,          // MDIO Input 
    output wire         ETH2_MDIO_OUT,         // MDIO Output
    output wire         ETH2_MDIO_OE,          // MDIO Output Enable 
    output wire         ETH2_RSTB,             // PHY Reset 
    // Interrupt from PHY
    input  wire         ETH2_INTB,             // PHY Interrupt 

    // RGMII RX (received from remote device) - NOT USED YET
    input  wire         ETH2_RXC,              // RX Clock
    input  wire         ETH2_RXCTL,            // RX Valid (control)
    input  wire         ETH2_RXD0,             // RX Data[0]
    input  wire         ETH2_RXD1,             // RX Data[1]
    input  wire         ETH2_RXD2,             // RX Data[2]
    input  wire         ETH2_RXD3,             // RX Data[3]

    // RGMII TX (to transmit to remote device) - DDR interface
    // Rising edge (_HI) and falling edge (_LO) samples from 125MHz clock
    output wire         ETH2_TXCTL_HI,            // TX Valid (control) - rising edge
    output wire         ETH2_TXCTL_LO,            // TX Valid (control) - falling edge
    output wire         ETH2_TXD0_HI,             // TX Data[0] - rising edge
    output wire         ETH2_TXD1_HI,             // TX Data[1] - rising edge
    output wire         ETH2_TXD2_HI,             // TX Data[2] - rising edge
    output wire         ETH2_TXD3_HI,             // TX Data[3] - rising edge
    output wire         ETH2_TXD0_LO,             // TX Data[0] - falling edge
    output wire         ETH2_TXD1_LO,             // TX Data[1] - falling edge
    output wire         ETH2_TXD2_LO,             // TX Data[2] - falling edge
    output wire         ETH2_TXD3_LO,              // TX Data[3] - falling edge

    // JTAG Debug Interface (from .peri `jtag_inst1`)
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
    input  wire         jtag_inst1_UPDATE,

    // ===== MIPI DPHY Interfaces (Titanium hard block) =====
    // Titanium DPHY deserializes each lane into 8-bit bytes (NOT like Trion CSI-2 IP!)
    // Must implement CSI-2 protocol decoder in fabric
    
    // CAM4: Clock lane
    input  wire         CAM4_CLK_CLKOUT,   // Recovered byte clock from DPHY
    input  wire         CAM4_CLK_LP_P_IN,  // Clock lane LP+ state
    input  wire         CAM4_CLK_LP_N_IN,  // Clock lane LP- state
    output wire         CAM4_CLK_HS_ENA,   // Clock lane HS receiver enable
    output wire         CAM4_CLK_HS_TERM,  // Clock lane HS termination enable
    output wire         CAM4_CLK_RST,      // Clock lane reset
    
    // CAM4: Data lane 0
    input  wire [7:0]   CAM4_D0_HS_IN,       // 8-bit deserialized FIFO data from lane 0
    input  wire         CAM4_D0_LP_P_IN,    // Lane 0 LP+ state
    input  wire         CAM4_D0_LP_N_IN,    // Lane 0 LP- state
    output wire         CAM4_D0_HS_ENA,     // Lane 0 HS receiver enable  (driven by CSI-2 IP)
    output wire         CAM4_D0_HS_TERM,    // Lane 0 HS termination      (driven by CSI-2 IP)
    output wire         CAM4_D0_RST,        // Lane 0 reset
    input  wire         CAM4_D0_FIFO_EMPTY, // Lane 0 FIFO empty flag
    output wire         CAM4_D0_FIFO_RD,    // Lane 0 FIFO read enable    (driven by CSI-2 IP)

    // CAM4: Data lane 1
    input  wire [7:0]   CAM4_D1_HS_IN,       // 8-bit deserialized FIFO data from lane 1
    input  wire         CAM4_D1_LP_P_IN,    // Lane 1 LP+ state
    input  wire         CAM4_D1_LP_N_IN,    // Lane 1 LP- state
    output wire         CAM4_D1_HS_ENA,     // Lane 1 HS receiver enable  (driven by CSI-2 IP)
    output wire         CAM4_D1_HS_TERM,    // Lane 1 HS termination      (driven by CSI-2 IP)
    output wire         CAM4_D1_RST,        // Lane 1 reset
    input  wire         CAM4_D1_FIFO_EMPTY, // Lane 1 FIFO empty flag
    output wire         CAM4_D1_FIFO_RD,    // Lane 1 FIFO read enable    (driven by CSI-2 IP)

    // Camera I2C (direct to CAM4)
    output wire         CAM4_I2C_SCL,       // I2C SCL to CAM4 (push-pull output)
    input  wire         CAM4_I2C_SDA_IN,    // I2C SDA read from CAM4 bus
    output wire         CAM4_I2C_SDA_OUT,   // I2C SDA drive value (always 0 for open-drain)
    output wire         CAM4_I2C_SDA_OE,    // I2C SDA output enable (1 = drive pin low)

    // Camera enable pins (active-low on camera via inverter transistor on PCB)
    // FPGA 0 → inverter → HIGH → camera XCLR=1 → camera active
    // FPGA 1 → inverter → LOW  → camera XCLR=0 → camera in reset
    output wire         CAM4_ENABLE,          // Camera 4 enable (0=active, 1=reset)

    //Blue wire from T120 video stream 25Mhz data speed
    input  wire         vid_frame_sync_n, // Active-low frame sync signal for video data (optional, can be left unconnected if not needed)
    input  wire         vid_clk,            // Pixel clock for video data (optional, can be left unconnected if not needed)
    input  wire         vid_d0,
    input  wire         vid_d1, 
    input  wire         vid_d2,
    input  wire         vid_d3,
    input  wire         vid_d4,
    input  wire         vid_d5,
    input  wire         vid_d6,
    input  wire         vid_d7
    
);
    
    logic [23:0] counter_pll_125MHZ = 24'd0; // 24-bit counter for `PLL_125MHZ`
    logic [23:0] counter_pll_100MHZ = 24'd0; // 24-bit counter for `PLL_100MHZ`
    logic [23:0] counter_pll_25MHZ = 24'd0; // 24-bit counter for `PLL_25MHZ`
    logic [23:0] counter_GPIOB_P_07 = 24'd0; // 24-bit counter for 

    logic [23:0] counter_clk = 24'd0; // 24-bit counter for `clk`

    // =========================================================================
    // MIPI DPHY Control Signals — driven by csi2_rx_cam_b IP
    // =========================================================================
    // Lane resets: active-high.  Assert when system is in reset.
    assign CAM4_CLK_RST = io_systemReset;
    assign CAM4_D0_RST  = io_systemReset;
    assign CAM4_D1_RST  = io_systemReset;

    // HS enable and termination are driven by the CSI-2 IP outputs below.
    // (wires csi2_hs_enable_C, csi2_lvds_termen_C, csi2_hs_enable_D, csi2_lvds_termen_D)
    // Intermediate wires — assigned below after the CSI-2 IP instantiation.
    wire        csi2_hs_enable_C;
    wire        csi2_lvds_termen_C;
    wire [1:0]  csi2_hs_enable_D;
    wire [1:0]  csi2_lvds_termen_D;
    wire [1:0]  csi2_fifo_rd;

    // Connect IP control outputs to DPHY top-level ports
    assign CAM4_CLK_HS_ENA  = csi2_hs_enable_C;
    assign CAM4_CLK_HS_TERM = csi2_lvds_termen_C;
    assign CAM4_D0_HS_ENA   = csi2_hs_enable_D[0];
    assign CAM4_D0_HS_TERM  = csi2_lvds_termen_D[0];
    assign CAM4_D1_HS_ENA   = csi2_hs_enable_D[1];
    assign CAM4_D1_HS_TERM  = csi2_lvds_termen_D[1];
    assign CAM4_D0_FIFO_RD  = csi2_fifo_rd[0];
    assign CAM4_D1_FIFO_RD  = csi2_fifo_rd[1];

    // =========================================================================
    // Camera I2C — Direct connection to CAM4 (open-drain pattern)
    // =========================================================================
    // SCL: push-pull output (CAM4_I2C_SCL is output-only in .peri.xml)
    // scl_write=1 → pin HIGH (idle/release), scl_write=0 → pin LOW (clock pulse)
    assign CAM4_I2C_SCL = system_i2c_0_io_scl_write;

    // SDA: open-drain via inout pin (matches T20: OUT=0, OE=~write)
    // When sda_write=1 (release): OE=0 → tri-state → external pullup → SDA HIGH
    // When sda_write=0 (drive low): OE=1 → OUT=0 → SDA LOW
    assign CAM4_I2C_SDA_OUT = 1'b0;
    assign CAM4_I2C_SDA_OE  = ~system_i2c_0_io_sda_write;

    // =========================================================================
    // Camera Enable — same as T20 (CAM0_EN <= '0' = camera active)
    // PCB has inverter transistor: FPGA 0 → HIGH on camera XCLR → active
    // =========================================================================
    assign CAM4_ENABLE = 1'b0;  // Camera 4: active (out of reset)

	// 24-bit counter driven by `clk`
	always_ff @(posedge clk) begin
		counter_clk <= counter_clk + 1'b1;
	end

	// 24-bit counter driven by `PLL_125MHZ`
	always_ff @(posedge PLL_125MHZ) begin
		counter_pll_125MHZ <= counter_pll_125MHZ + 1'b1;
	end
 
    always_ff @(posedge GPIOB_P_07) begin
        counter_GPIOB_P_07 <= counter_GPIOB_P_07 + 1'b1;//   counter_GPIOB_P_07 test input clock counter
    end

    // 24-bit counter driven by `PLL_100MHZ`
    always_ff @(posedge PLL_100MHZ) begin
        counter_pll_100MHZ <= counter_pll_100MHZ + 1'b1;
    end
    // 24-bit counter driven by `PLL_25MHZ`
    always_ff @(posedge PLL_25MHZ) begin
        counter_pll_25MHZ <= counter_pll_25MHZ + 1'b1;
    end
    //assign ETH2_TXC = counter_pll_125MHZ[5]; // Drive ETH2_TXC with the LSB of counter_pll_125MHZ for a visible toggle
    // Drive LEDs from SoC GPIOs (APB-controlled) so we can blink from software.
    // `system_gpio_0_io_write` is a 4-bit GPIO write bus exported by the SoC.
    // If the SoC doesn't drive these lines yet, fall back to the counters so LEDs remain visible.
    //assign ETH2_TXC = PLL_125MHZ; // For RGMII, ETH2_TXC must be driven by the 125MHz clock. MY thoudght is this already defined as a clkout in the .peri file, so we should not assign it here in the code, otherwise we get an error about multiple drivers. We can use it as an output though, so we can assign it here in this top_level file. Just leave this clkout unassigned here is the correct way to do.
    assign LED3 = system_gpio_0_io_write[0];
    assign LED4 = counter_pll_125MHZ[23]; // Blink LED3 with the MSB of counter_pll_125MHZ for a slow visible blink
    //assign LED4 = counter_GPIOB_P_07[23];
    //assign ETH2_TXC = 1'b0; // Test: leave ETH2_TXC low for now, we will connect it to PLL_25MHZ later for RGMII TX clock

    // --- SoC / peripheral signal declarations ---
    // The SoC `io_systemClk` is connected directly in the instance below
    // as `.io_systemClk(PLL_100MHZ)`. No local alias or assign is needed.

    // Simple async reset (active-high in SoC). Tie inactive for now.
    wire io_asyncReset;
    assign io_asyncReset = 1'b0; // 0 = no async reset asserted

    // Simple SPI signals (unused for now)
    logic system_spi_0_io_data_0_read = 1'b0;
    logic system_spi_0_io_data_1_read = 1'b0;
    logic system_spi_0_io_data_2_read = 1'b0;
    logic system_spi_0_io_data_3_read = 1'b0;
    wire  system_spi_0_io_data_0_write;
    wire  system_spi_0_io_data_0_writeEnable;
    wire  system_spi_0_io_data_1_write;
    wire  system_spi_0_io_data_1_writeEnable;
    wire  system_spi_0_io_data_2_write;
    wire  system_spi_0_io_data_2_writeEnable;
    wire  system_spi_0_io_data_3_write;
    wire  system_spi_0_io_data_3_writeEnable;
    wire  system_spi_0_io_sclk_write;
    wire [0:0] system_spi_0_io_ss;

    // User interrupt
    logic userInterruptA; // connected to MDIO IRQ

    // APB3 bus signals between SoC (master) and uart_mini (slave)
    wire [15:0] io_apbSlave_0_PADDR;
    wire        io_apbSlave_0_PENABLE;
    wire [31:0] io_apbSlave_0_PRDATA;
    wire        io_apbSlave_0_PREADY;
    wire        io_apbSlave_0_PSEL;
    wire        io_apbSlave_0_PSLVERROR;
    wire [31:0] io_apbSlave_0_PWDATA;
    wire        io_apbSlave_0_PWRITE;

    // System reset output from SoC (unused here)
    wire io_systemReset;

    // SoC UART interface (we will NOT connect SoC internal UART to physical pins now)
    wire system_uart_0_io_txd;
    wire system_uart_0_io_rxd = 1'b1; // idle high on UART RX

    // I2C master control (SoC I2C_0 directly connected to CAM4)
    wire system_i2c_0_io_scl_write;
    wire system_i2c_0_io_sda_write;
    // SCL readback: loopback from write (output-only pin, no clock stretching support)
    wire system_i2c_0_io_scl_read = system_i2c_0_io_scl_write;
    // SDA readback: actual bus state from CAM4 (for ACK detection and data reception)
    wire system_i2c_0_io_sda_read = CAM4_I2C_SDA_IN;
    
    wire [3:0] system_gpio_0_io_writeEnable;
    wire [3:0] system_gpio_0_io_write;
    wire [3:0] system_gpio_0_io_read = 4'b0000;

    // UART TX internal wires for the 20-second source mux
    wire uart_mini_txd;   // output of uart_mini_apb3  (SoC/startup path)
    wire rfbc_uart_tx;    // output of record_frame_bram_counted (frame-data path)


    // --- Instantiate uart_mini_apb3 and connect to SoC APB signals ---
    uart_mini_apb3 #(
        .CLK_FREQ_HZ(100_000_000), // match PLL_100MHZ
        .BAUD_RATE(9600)
        
    ) u_uart_mini (
        .pclk      ( PLL_100MHZ ),
        .presetn   ( 1'b1 ),            // no reset (active low)
        .psel      ( uart_mini_apb_psel ),
        .penable   ( io_apbSlave_0_PENABLE ),
        .pwrite    ( io_apbSlave_0_PWRITE ),
        .paddr     ( {16'h0, io_apbSlave_0_PADDR} ),
        .pwdata    ( io_apbSlave_0_PWDATA ),
        .prdata    ( uart_mini_apb_prdata ),
        .pready    ( uart_mini_apb_pready ),
        .pslverr   ( uart_mini_apb_pslverr ),
        .uart_txd  ( uart_mini_txd ),
        .uart_rxd  ( UART_RX ),
        .debug_tx_activity(),
        .debug_any_write(),
        .debug_bus_state(),
        .debug_psel_in(),
        .debug_penable_in(),
        .debug_pwrite_in(),
        .debug_act_write(),
        .debug_act_read(),
        .debug_slave_ready(),
        .debug_pready_out(),
        .debug_reg_addr()
    );

    // --- APB decode: split io_apbSlave_0 into per-slave selects ---
    // APB base offsets (from CPU view): 0x0000 - uart, 0x1000 - mdio
    // NOTE: Block RAM now has direct MIPI write port (not APB3!)
    logic uart_mini_apb_psel;
    logic mdio_apb_psel;
    logic [31:0] uart_mini_apb_prdata;
    logic        uart_mini_apb_pready;
    logic        uart_mini_apb_pslverr;
    logic [31:0] mdio_apb_prdata;
    logic        mdio_apb_pready;
    logic        mdio_apb_pslverr;

    assign uart_mini_apb_psel = io_apbSlave_0_PSEL & (io_apbSlave_0_PADDR[15:12] == 4'h0);
    assign mdio_apb_psel      = io_apbSlave_0_PSEL & (io_apbSlave_0_PADDR[15:12] == 4'h1);

    // Return APB read data / ready / error back to SoC based on which slave is selected
    assign io_apbSlave_0_PRDATA  = uart_mini_apb_psel ? uart_mini_apb_prdata : 
                                    (mdio_apb_psel ? mdio_apb_prdata : 32'h0);
    assign io_apbSlave_0_PREADY  = uart_mini_apb_psel ? uart_mini_apb_pready : 
                                    (mdio_apb_psel ? mdio_apb_pready : 1'b1);
    assign io_apbSlave_0_PSLVERROR = uart_mini_apb_psel ? uart_mini_apb_pslverr : 
                                     (mdio_apb_psel ? mdio_apb_pslverr : 1'b0);

    // --- Instantiate MDIO master (APB slave) ---
    mdio_master #(
        .SYS_CLK_HZ(100_000_000),
        .MDC_HZ(1_000_000)
    ) u_mdio_master (
        .clk      ( PLL_100MHZ ),
        .rst_n    ( ~io_systemReset ),
        .psel     ( mdio_apb_psel ),
        .penable  ( io_apbSlave_0_PENABLE ),
        .pwrite   ( io_apbSlave_0_PWRITE ),
        .paddr    ( io_apbSlave_0_PADDR[5:2] ),  // convert byte address→word address (divide by 4)
        .pwdata   ( io_apbSlave_0_PWDATA ),
        .prdata   ( mdio_apb_prdata ),
        .pready   ( mdio_apb_pready ),
        .pslverr  ( mdio_apb_pslverr ),
        .mdc      ( ETH2_MDC ),
        .mdio_i   ( ETH2_MDIO_IN ),
        .mdio_o   ( ETH2_MDIO_OUT ),
        .mdio_oe  ( ETH2_MDIO_OE ),
        .phy_rst_n( ETH2_RSTB ),
       // .debug_ack( /* open for logic analyzer */ ),
        .irq      ( userInterruptA )
    );
    //Blue wire from T120 video stream 25Mhz
    logic [7:0]   vid_d_int;
    assign vid_d_int[0] = vid_d0;
    assign vid_d_int[1] = vid_d1;
    assign vid_d_int[2] = vid_d2;
    assign vid_d_int[3] = vid_d3;
    assign vid_d_int[4] = vid_d4;
    assign vid_d_int[5] = vid_d5;
    assign vid_d_int[6] = vid_d6;
    assign vid_d_int[7] = vid_d7;   

    // =========================================================================
    // Video-to-UDP RGMII Transmitter (1Gbps with DDR interface)
    // Block RAM: MIPI write port → eth_tx_1gbit_udp read port
    // =========================================================================
    logic video_udp_enable;
    logic [3:0] txd_hi_udp, txd_lo_udp;
    logic txctl_hi_udp, txctl_lo_udp;
    logic [15:0] bram_read_addr;
    wire  [7:0] bram_read_data_from_bram;  // 8-bit byte data from BRAM read port
    logic bram_read_en;
    logic eth_transmission_active;
    logic [15:0] eth_frame_sequence;
    
    // Enable from mipi_csi2_rx_capture: set in eth domain, drives ETH TX
    // (declared below after the capture module instantiation)
    
    // =========================================================================
    // DPHY Debug Sniffer — kept for reference; currently inactive
    // =========================================================================
    wire [7:0] dbg_debug_byte;

    dphy_debug_sniffer u_dphy_debug (
        .clk            ( PLL_125MHZ ),
        .rst_n          ( ~io_systemReset ),
        .cam_clk_clkout ( CAM4_CLK_CLKOUT ),
        .cam_clk_lp_p   ( CAM4_CLK_LP_P_IN ),
        .cam_clk_lp_n   ( CAM4_CLK_LP_N_IN ),
        .cam_d0_hs_in   ( CAM4_D0_HS_IN ),
        .cam_d0_lp_p    ( CAM4_D0_LP_P_IN ),
        .cam_d0_lp_n    ( CAM4_D0_LP_N_IN ),
        .cam_d1_hs_in   ( CAM4_D1_HS_IN ),
        .cam_d1_lp_p    ( CAM4_D1_LP_P_IN ),
        .cam_d1_lp_n    ( CAM4_D1_LP_N_IN ),
        .rd_addr        ( bram_read_addr ),
        .debug_byte     ( dbg_debug_byte )
    );

    // =========================================================================
    // Efinix CSI-2 RX IP (csi2_rx_cam_b)
    // Decodes 2-lane MIPI CSI-2 stream and outputs 64-bit pixel data.
    //
    // Clock mapping:
    //   clk / clk_pixel    = PLL_100MHZ (100 MHz fabric clock)
    //   clk_byte_HS        = CAM4_CLK_CLKOUT (recovered byte clock from DPHY)
    //
    // The IP drives HS-enable / termination / FIFO-read for both data lanes.
    // =========================================================================
    wire        csi2_pixel_valid;
    wire [63:0] csi2_pixel_data;
    wire [3:0]  csi2_pixel_per_clk;
    wire [5:0]  csi2_datatype;
    wire        csi2_vsync;
    wire        csi2_hsync;

    csi2_rx_cam_b u_csi2_rx (
        .reset_n             ( ~io_systemReset ),
        .clk                 ( PLL_100MHZ ),
        .reset_byte_HS_n     ( ~io_systemReset ),
        .clk_byte_HS         ( CAM4_CLK_CLKOUT ),
        .reset_pixel_n       ( ~io_systemReset ),
        .clk_pixel           ( PLL_100MHZ ),

        // Clock lane LP signals
        .Rx_LP_CLK_P         ( CAM4_CLK_LP_P_IN ),
        .Rx_LP_CLK_N         ( CAM4_CLK_LP_N_IN ),
        .Rx_HS_enable_C      ( csi2_hs_enable_C ),
        .LVDS_termen_C       ( csi2_lvds_termen_C ),

        // Data lane LP signals (bus: {lane1, lane0})
        .Rx_LP_D_P           ( {CAM4_D1_LP_P_IN, CAM4_D0_LP_P_IN} ),
        .Rx_LP_D_N           ( {CAM4_D1_LP_N_IN, CAM4_D0_LP_N_IN} ),

        // Data lane HS deserialized bytes from DPHY FIFO
        // Only lane 0 and 1 are used; lanes 2-7 tied to zero
        .Rx_HS_D_0           ( CAM4_D0_HS_IN ),
        .Rx_HS_D_1           ( CAM4_D1_HS_IN ),
        .Rx_HS_D_2           ( 8'b0 ),
        .Rx_HS_D_3           ( 8'b0 ),
        .Rx_HS_D_4           ( 8'b0 ),
        .Rx_HS_D_5           ( 8'b0 ),
        .Rx_HS_D_6           ( 8'b0 ),
        .Rx_HS_D_7           ( 8'b0 ),

        // Data lane enables / termination / FIFO interface
        .Rx_HS_enable_D      ( csi2_hs_enable_D ),
        .LVDS_termen_D       ( csi2_lvds_termen_D ),
        .fifo_rd_enable      ( csi2_fifo_rd ),
        .fifo_rd_empty       ( {CAM4_D1_FIFO_EMPTY, CAM4_D0_FIFO_EMPTY} ),

        // Delay calibration — outputs left open, inputs tied off
        .DLY_enable_D        ( ),
        .DLY_inc_D           ( ),
        .u_dly_enable_D      ( 2'b0 ),
        .u_dly_inc_D         ( 2'b0 ),

        // Pixel data outputs (clk_pixel domain)
        .pixel_data_valid    ( csi2_pixel_valid ),
        .pixel_data          ( csi2_pixel_data ),
        .pixel_per_clk       ( csi2_pixel_per_clk ),
        .datatype            ( csi2_datatype ),

        // Frame / line sync (VC0 only)
        .vsync_vc0           ( csi2_vsync ),
        .hsync_vc0           ( csi2_hsync ),

        // Unused VC sync outputs
        .vsync_vc1 (), .vsync_vc2 (), .vsync_vc3 (), .vsync_vc4 (),
        .vsync_vc5 (), .vsync_vc6 (), .vsync_vc7 (), .vsync_vc8 (),
        .vsync_vc9 (), .vsync_vc10(), .vsync_vc11(), .vsync_vc12(),
        .vsync_vc13(), .vsync_vc14(), .vsync_vc15(),
        .hsync_vc1 (), .hsync_vc2 (), .hsync_vc3 (), .hsync_vc4 (),
        .hsync_vc5 (), .hsync_vc6 (), .hsync_vc7 (), .hsync_vc8 (),
        .hsync_vc9 (), .hsync_vc10(), .hsync_vc11(), .hsync_vc12(),
        .hsync_vc13(), .hsync_vc14(), .hsync_vc15(),

        // Misc outputs
        .vc                  ( ),
        .vcx                 ( ),
        .word_count          ( ),
        .shortpkt_data_field ( ),
        .irq                 ( ),

        // AXI config interface — not used, tied off
        .axi_clk             ( 1'b0 ),
        .axi_reset_n         ( 1'b0 ),
        .axi_awaddr          ( 6'b0 ),
        .axi_awvalid         ( 1'b0 ),
        .axi_awready         ( ),
        .axi_wdata           ( 32'b0 ),
        .axi_wvalid          ( 1'b0 ),
        .axi_wready          ( ),
        .axi_bvalid          ( ),
        .axi_bready          ( 1'b0 ),
        .axi_araddr          ( 6'b0 ),
        .axi_arvalid         ( 1'b0 ),
        .axi_arready         ( ),
        .axi_rdata           ( ),
        .axi_rvalid          ( ),
        .axi_rready          ( 1'b0 ),

        .mipi_debug_in       ( 32'b0 ),
        .mipi_debug_out      ( )
    );

    // =========================================================================
    // MIPI CSI-2 Frame Capture → BRAM → ETH TX
    // mipi_csi2_rx_capture bridges the pixel clock (PLL_100MHZ) and the
    // Ethernet clock (PLL_125MHZ) with a toggle-synchroniser CDC.
    // =========================================================================
    wire [15:0] cap_bram_wr_addr;  // 64-bit word address
    wire [63:0] cap_bram_wr_data;  // 64-bit pixel data
    wire        cap_bram_wr_en;
    wire        capture_sending;
    wire        capture_eth_rst;
    wire [15:0] capture_words;

    mipi_csi2_rx_capture u_mipi_csi2_capture (
        // Pixel clock domain
        .clk_pixel          ( PLL_100MHZ ),
        .rst_pixel_n        ( ~io_systemReset ),
        // ETH clock domain
        .clk_eth            ( PLL_125MHZ ),
        .rst_eth_n          ( ~io_systemReset ),
        // CSI-2 pixel data (from IP, clk_pixel domain)
        .pixel_data         ( csi2_pixel_data ),
        .pixel_data_valid   ( csi2_pixel_valid ),
        .vsync              ( csi2_vsync ),
        // BRAM write port (64-bit, clk_pixel domain)
        .bram_wr_addr       ( cap_bram_wr_addr ),
        .bram_wr_data       ( cap_bram_wr_data ),
        .bram_wr_en         ( cap_bram_wr_en ),
        // ETH TX control (clk_eth domain)
        .sending            ( capture_sending ),
        .eth_rst_pulse      ( capture_eth_rst ),
        .captured_words     ( capture_words )
    );

    assign video_udp_enable = capture_sending;
    
    // =========================================================================
    // Dummy MIPI Video Source (Test Mode - COMMENTED OUT)
    // Uncomment to use test data instead of real MIPI interfaces
    // =========================================================================
    /*
    logic frame_start_debug;
    logic frame_end_debug;
    logic [15:0] frame_counter_debug;
    
    dummy_MIPI_video_source #(
        .MIPI_DATA_WIDTH(32),
        .FRAME_SIZE_BYTES(60000),      // 2 cameras: 100x100x3 bytes each
        .FRAME_RATE_Hz(200)            // 200Hz frame rate (5ms per frame)
    ) u_dummy_mipi (
        .clk_mipi       ( PLL_125MHZ ),
        .rst_n          ( 1'b1 ),
        .mipi_data      ( mipi_data ),
        .mipi_valid     ( mipi_valid ),
        .mipi_ready     ( mipi_ready ),
        .frame_start    ( frame_start_debug ),
        .frame_end      ( frame_end_debug ),
        .frame_counter  ( frame_counter_debug )
    );
    */
    
    // Auto-increment write address on each valid data word
    // NOTE: MIPI recorder now handles write address and data multiplexing
    // This logic is replaced by the record_mipi_frame_2_bram module
    // The BRAM write port is driven directly by u_mipi_recorder
    
    // =========================================================================
    // BINARY SEARCH DEBUG: Test eth_tx_1gbit_udp in Isolation (OPTIONAL)
    // Uncomment this section to test ethernet TX without real MIPI data
    // Feed it hardcoded data, bypassing BRAM entirely
    // =========================================================================
    /*
    // Simple counter-based test data generator
    reg [15:0] test_data_counter = 0;
    wire [7:0] test_data_byte = test_data_counter[7:0];
    
    always @(posedge PLL_125MHZ) begin
        if (bram_read_en) begin
            test_data_counter <= test_data_counter + 1;
        end
    end
    */
    
    // =========================================================================
    // BRAM Write and Read Control
    // Write port driven by MIPI recorder (u_mipi_recorder)
    // Read port driven by ethernet TX
    // =========================================================================
    
    // SELECT: debug sniffer mode (sends DPHY state in every packet)
    // Set to 1'b1 for DPHY debug, 1'b0 for normal BRAM readout
    localparam DEBUG_SNIFFER_MODE = 1'b0;  // Use BRAM data (raw capture mode)
    
    wire [7:0] bram_read_data_mux;
    assign bram_read_data_mux = DEBUG_SNIFFER_MODE ? dbg_debug_byte : bram_read_data_from_bram;
    
    // =========================================================================
    // Block RAM (DUAL-PORT): MIPI Write Port & Ethernet Read Port
    // Write: Driven by record_mipi_frame_2_bram module (u_mipi_recorder)
    // Read:  Driven by eth_tx_1gbit_udp module for ethernet transmission
    // =========================================================================
    bram_video_buffer #(
        .BRAM_DEPTH(9216),          // 9K words of depth (enough for 36KB frame at 64 bits/word)
        .MIPI_DATA_WIDTH(64),   // 64-bit write port (one word per pixel_data_valid)
        .BRAM_READ_WIDTH(8)
    ) u_bram_video (
        // Write port: from CSI-2 capture module (PLL_100MHZ pixel clock domain)
        .clk_mipi       ( PLL_100MHZ ),
        .mipi_rst_n     ( ~io_systemReset ),
        .mipi_data      ( cap_bram_wr_data ),
        .mipi_valid     ( cap_bram_wr_en ),
        .mipi_ready     ( ),
        .mipi_write_addr( cap_bram_wr_addr ),
        
        // Read port: for ethernet TX
        .clk_125MHz ( PLL_125MHZ ),
        .read_addr  ( bram_read_addr ),
        .read_data  ( bram_read_data_from_bram ),  // 8-bit byte data
        .read_en    ( bram_read_en )
    );
    
    // IMPORTANT: Use BRAM read data directly when not testing
    // (bram_read_data_mux already includes this via assignment above)
    
    // =========================================================================
    // Ethernet TX: UDP frame with BRAM payload
    // Sends broadcast UDP to port 5000, ~1000 frames/sec, reads from BRAM
    // =========================================================================
    eth_tx_1gbit_udp u_eth_tx_udp (
        .clk_125MHz      ( PLL_125MHZ ),
        .rst_n           ( ~(io_systemReset | capture_eth_rst) ),
        .enable          ( video_udp_enable ),
        .txd_hi          ( txd_hi_udp ),
        .txd_lo          ( txd_lo_udp ),
        .txctl_hi        ( txctl_hi_udp ),
        .txctl_lo        ( txctl_lo_udp ),

        // BRAM read interface (video payload)
        .bram_rd_addr    ( bram_read_addr ),
        .bram_rd_data    ( bram_read_data_mux ),
        .bram_rd_en      ( bram_read_en )
    );

    // =========================================================================
    // Connect eth_tx_udp TX outputs to RGMII DDR interface
    // Map 4-bit nibbles to individual RGMII TXD pins
    // =========================================================================
    assign ETH2_TXCTL_HI = txctl_hi_udp;      // TX Valid on rising edge
    assign ETH2_TXCTL_LO = txctl_lo_udp;      // TX Valid on falling edge
    
    // Rising edge TXD outputs
    assign ETH2_TXD0_HI = txd_hi_udp[0];
    assign ETH2_TXD1_HI = txd_hi_udp[1];
    assign ETH2_TXD2_HI = txd_hi_udp[2];
    assign ETH2_TXD3_HI = txd_hi_udp[3];
    
    // Falling edge TXD outputs
    assign ETH2_TXD0_LO = txd_lo_udp[0];
    assign ETH2_TXD1_LO = txd_lo_udp[1];
    assign ETH2_TXD2_LO = txd_lo_udp[2];
    assign ETH2_TXD3_LO = txd_lo_udp[3];

SoC_mini_A u_SoC_mini_A
(
    .io_systemClk ( PLL_100MHZ ),
    // Connect JTAG user-tap pins into the SoC debug controller
    .jtagCtrl_enable            ( jtag_inst1_SEL ),
    .jtagCtrl_tdi               ( jtag_inst1_TDI ),
    .jtagCtrl_capture           ( jtag_inst1_CAPTURE ),
    .jtagCtrl_shift             ( jtag_inst1_SHIFT ),
    .jtagCtrl_update            ( jtag_inst1_UPDATE ),
    .jtagCtrl_reset             ( jtag_inst1_RESET ),
    .jtagCtrl_tck               ( jtag_inst1_TCK ),
    .jtagCtrl_tdo               ( jtag_inst1_TDO ),
    .system_spi_0_io_data_0_read ( system_spi_0_io_data_0_read ),
    .system_spi_0_io_data_0_write ( system_spi_0_io_data_0_write ),
    .system_spi_0_io_data_0_writeEnable ( system_spi_0_io_data_0_writeEnable ),
    .system_spi_0_io_data_1_read ( system_spi_0_io_data_1_read ),
    .system_spi_0_io_data_1_write ( system_spi_0_io_data_1_write ),
    .system_spi_0_io_data_1_writeEnable ( system_spi_0_io_data_1_writeEnable ),
    .system_spi_0_io_data_2_read ( system_spi_0_io_data_2_read ),
    .system_spi_0_io_data_2_write ( system_spi_0_io_data_2_write ),
    .system_spi_0_io_data_2_writeEnable ( system_spi_0_io_data_2_writeEnable ),
    .system_spi_0_io_data_3_read ( system_spi_0_io_data_3_read ),
    .system_spi_0_io_data_3_write ( system_spi_0_io_data_3_write ),
    .system_spi_0_io_data_3_writeEnable ( system_spi_0_io_data_3_writeEnable ),
    .system_spi_0_io_sclk_write ( system_spi_0_io_sclk_write ),
    .userInterruptA ( userInterruptA ),
    .io_apbSlave_0_PADDR ( io_apbSlave_0_PADDR ),
    .io_apbSlave_0_PENABLE ( io_apbSlave_0_PENABLE ),
    .io_apbSlave_0_PRDATA ( io_apbSlave_0_PRDATA ),
    .io_apbSlave_0_PREADY ( io_apbSlave_0_PREADY ),
    .io_apbSlave_0_PSEL ( io_apbSlave_0_PSEL ),
    .io_apbSlave_0_PSLVERROR ( io_apbSlave_0_PSLVERROR ),
    .io_apbSlave_0_PWDATA ( io_apbSlave_0_PWDATA ),
    .io_apbSlave_0_PWRITE ( io_apbSlave_0_PWRITE ),
    .io_asyncReset ( io_asyncReset ),
    .io_systemReset ( io_systemReset ),
    .system_uart_0_io_txd ( system_uart_0_io_txd ),
    .system_uart_0_io_rxd ( system_uart_0_io_rxd ),
    .system_i2c_0_io_scl_read ( system_i2c_0_io_scl_read ),
    .system_i2c_0_io_scl_write ( system_i2c_0_io_scl_write ),
    .system_i2c_0_io_sda_read ( system_i2c_0_io_sda_read ),
    .system_i2c_0_io_sda_write ( system_i2c_0_io_sda_write ),
    .system_gpio_0_io_writeEnable ( system_gpio_0_io_writeEnable ),
    .system_gpio_0_io_write ( system_gpio_0_io_write ),
    .system_gpio_0_io_read ( system_gpio_0_io_read ),
    .system_spi_0_io_ss ( system_spi_0_io_ss )
);    

    // =========================================================================
    // UART TX source mux
    // First 20 s  → uart_mini_txd  (SoC startup messages, I2C camera config)
    // After 20 s  → rfbc_uart_tx   (record_frame_bram_counted hex frame dump)
    //
    // Timer clock: PLL_100MHZ (100 MHz)
    //   20 s = 2,000,000,000 cycles  (fits in 31 bits — max 2,147,483,647)
    // =========================================================================
    logic [30:0] uart_mux_timer   = 31'd0;
    logic        uart_rfbc_select = 1'b0;  // 0 = SoC path, 1 = frame-data path

    always_ff @(posedge PLL_100MHZ) begin
        if (!uart_rfbc_select) begin
            if (uart_mux_timer == 31'd1_999_999_999)
                uart_rfbc_select <= 1'b1;
            else
                uart_mux_timer <= uart_mux_timer + 1'b1;
        end
    end

    assign UART_TX = uart_rfbc_select ? rfbc_uart_tx : uart_mini_txd;

    // =========================================================================
    // record_frame_bram_counted  (VHDL entity — mixed-language instantiation)
    //
    // Receives the SAME CSI-2 pixel stream as u_mipi_csi2_capture (fan-out,
    // no additional load on the IP outputs).
    //
    // cnt port mapping:
    //   Trion hard-IP: mipi_rx_inst1_CNT  [3:0] = pixels per 64-bit beat
    //   Titanium soft-IP: csi2_pixel_per_clk [3:0] = pixels per 64-bit beat
    //   → functionally identical; connect csi2_pixel_per_clk to cnt.
    //   (The VHDL FSM actually counts *beats*, not the value of cnt, so the
    //    mapping is safe even if the number varies between IP generations.)
    //
    // clk mapped to PLL_100MHZ — same clock as csi2_rx_cam_b, ensuring all
    // pixel outputs and the capture FSM are in the same clock domain.
    // =========================================================================
    record_frame_bram_counted #(
        .CLOCK_HZ        (100_000_000),
        .BAUD            (115200),
        .WIDTH_PIX       (96),
        .HEIGHT_LINES    (96),
        .PIXELS_PER_BEAT (8),
        .GAP_MIN_CYCLES  (128),
        .CLEAR_CYCLES    (128),
        .AUTO_DUMP_UART  (1)            // VHDL boolean: 1 = true
    ) u_record_frame_bram (
        .clk         ( PLL_100MHZ ),
        .rst_n       ( ~io_systemReset ),
        // CSI-2 pixel stream — same wires as u_mipi_csi2_capture (fan-out)
        .data64      ( csi2_pixel_data ),
        .valid       ( csi2_pixel_valid ),
        .dtype       ( csi2_datatype ),
        .cnt         ( csi2_pixel_per_clk ),
        .hsync       ( {3'b0, csi2_hsync} ),
        .vsync       ( {3'b0, csi2_vsync} ),
        .error_bus   ( 18'b0 ),
        // Arm continuously — FSM re-arms itself on every DUMP→IDLE transition
        .arm_i       ( 1'b1 ),
        .armed_o     (  ),
        .capturing_o (  ),
        .done_o      (  ),
        .clear_o     (  ),
        .beats_line_o(  ),
        .line_idx_o  (  ),
        .words_used_o(  ),
        // UART frame-data output (switched onto UART_TX after 20 s)
        .uart_tx     ( rfbc_uart_tx )
    );

// =============================================================================
// Blue-Wire Byte Recorder (test module)
// =============================================================================
// Captures one frame from the blue-wire bus, stores it in local BRAM,
// then dumps all bytes via UART on XB7 pin (115200 baud, "S" + hex format).

blue_wire_byte_recorder #(
    .CLOCK_HZ     (100_000_000),      // 100 MHz PLL clock (must oversample 25 MHz vid_clk)
    .BAUD         (115200),
    .WIDTH_PIX    (224),
    .HEIGHT_LINES (224)
) u_blue_wire_recorder (
    .sys_clk        (PLL_100MHZ),   // 100 MHz — same domain as vid_clk source
    .rst_n          (~io_systemReset),

    // Blue-wire video bus
    .vid_frame_sync_n (vid_frame_sync_n),
    .vid_clk          (vid_clk),
    .vid_d            (vid_d_int),

    // UART TX →  pin for external monitoring (115200 baud, "S" + hex format)
    .txd            (vid_uart_tx),  // 

    // Status (unconnected for now)
    .frame_captured (),  
    .dumping        ()  
);

endmodule

