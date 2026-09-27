
// synopsys translate_off
`timescale 1 ns / 1 ps													
// synopsys translate_on

module TI180_MIPI_csi_tb ();
	
localparam NUM_DATA_LANE = 4;
localparam PACK_BIT = 48; 
localparam PACK_TYPE = 4'b1111;      
localparam DPHY_CLOCK_MODE = "Continuous";  //Continuous  //Discontinuous
localparam DATARATE_MPBS = 2500;  //2500, 1500, 1000, 500, 250, 160
real PIX_CLK_MHZ      = ((DATARATE_MPBS * NUM_DATA_LANE) / PACK_BIT);  // /2 is because HS_DATA_WIDTH is 16bit
real PIX_CLK_NS       = 1000/PIX_CLK_MHZ;   // RAW8  (500Mbpsx1lane)/64bit = 7.8Mhz (128ns)
                                                         //(500Mbpsx2lane)/64bit = 15.62Mhz (64ns)
                                                         //(500Mbpsx4lane)/64bit = 32.25Mhz (32ns)
                                                         //(500Mbpsx8lane)/64bit = 62.5Mhz (16ns)
localparam AREGISTER = 6; // minimum 2; maximum 6 (for low data rate) 
localparam FRAME_MODE = "GENERIC"; //ACCURATE
localparam DATATYPE = 6'h24;
localparam HS_DATA_WIDTH = 16;
//common
logic reset_n, start_transfer_n;
//logic led;
logic clk; 
logic clk_pixel;
logic rx__cfgclk_in;
logic rx__refclk_in;
logic rx__txclkesc_lan0;
logic rxbyteclkhs;

logic tx__m_txclkesc;
logic tx__refclk_in;
logic tx_byteclk_hs_phy;
logic reset_byte_HS_n;

//RX
logic [4:0]     RXDP_b0;                 // new 
logic [4:0]     RXDN_b0;                 // new
logic [4:0]     RXDP_b1;                 // new 
logic [4:0]     RXDN_b1;                 // new
logic [4:0]     RXDP_b2;                 // new 
logic [4:0]     RXDN_b2;                 // new
                       
//TX                   
wire [4:0]      TXDP_b0;                 //For Harden 2.5G phy
wire [4:0]      TXDN_b0;                 //new For Harden 2.5G phy
wire [4:0]      TXDP_b1;                 //For Harden 2.5G phy
wire [4:0]      TXDN_b1;                 //new For Harden 2.5G phy
wire [4:0]      TXDP_b2;                 //For Harden 2.5G phy
wire [4:0]      TXDN_b2;                 //new For Harden 2.5G phy



initial begin
reset_n = 1'b0;
start_transfer_n = 1'b1;
reset_byte_HS_n = 1'b0;
#400ns;
reset_n = 1'b1;
reset_byte_HS_n = 1'b1;
#300000
start_transfer_n = 1'b0;
#20
start_transfer_n = 1'b1;
#10000000
if (DUT.r_pass && ~DUT.r_fail) begin
    $display("TEST PASSED");
end
else begin
    $display("TEST FAILED");
end

$finish(1);
end

initial begin 
	$dumpfile("TI180_MIPI_csi_tb.vcd");
    $dumpvars(0, TI180_MIPI_csi_tb);
    //$shm_open("csi2.shm");
    //$shm_probe(TI180_MIPI_csi_tb,"ACMTF");
    end

initial begin   //100Mhz
	clk = 0;
	forever #(10ns/2) clk = ~clk;
end

initial begin   //100Mhz
	clk_pixel = 0;
	forever #(PIX_CLK_NS/2) clk_pixel = ~clk_pixel;
end

initial begin   //25Mhz
	tx__refclk_in = 0;
	forever #(40ns/2) tx__refclk_in = ~tx__refclk_in;
end

initial begin   //25Mhz
	rx__refclk_in = 0;
	forever #(40ns/2) rx__refclk_in = ~rx__refclk_in;
end

initial begin   //100Mhz
	rx__cfgclk_in = 0;
	forever #(8.33ns/2) rx__cfgclk_in = ~rx__cfgclk_in;
end

initial begin   //19.2Mhz
	rx__txclkesc_lan0 = 0;
	forever #(52.083ns/2) rx__txclkesc_lan0 = ~rx__txclkesc_lan0;
end

initial begin   //19.2Mhz
	tx__m_txclkesc = 0;
	forever #(52.083ns/2) tx__m_txclkesc = ~tx__m_txclkesc;
end

// Force all the PCR bit for M31 Harden MIPI PHY
    initial begin
        // TX -- 2.5Gbps setting  
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_PLL_SSC_DELTA = 18'b0 ;
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_PLL_SSC_DELTA_INIT = 18'b0 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_PLL_SSC_PRD = 10'b0; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_PLL_SSC_EN = 1'b0;	
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_PLL_FBK_INT = 9'hC8 ; //9'h78 ; 9'hC8 ;
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_PLL_FBK_FRA = 24'b0 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_PLL_PRE_DIV = 2'h1 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_PLL_FM_EN = 1'b0 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_PLL_LDO_STB_X2_EN = 1'b0 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_L0P_HSTX_RES = 5'b10000 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_L0N_HSTX_RES = 5'b10000 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_L1P_HSTX_RES = 5'b10000 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_L1N_HSTX_RES = 5'b10000 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_L2P_HSTX_RES = 5'b10000 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_L2N_HSTX_RES = 5'b10000 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_L3P_HSTX_RES = 5'b10000 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_L3N_HSTX_RES = 5'b10000 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_L4P_HSTX_RES = 5'b10000 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CDTX_L4N_HSTX_RES = 5'b10000 ; 
        force TI180_MIPI_csi_tb.DPHY_TX.RG_EXTD_CYCLE_SEL = 3'h0 ; //3'h1 ;
        force TI180_MIPI_csi_tb.DPHY_TX.RG_DLANE_HS_PRE_TIME = 8'hE ; //8'hb ;
        force TI180_MIPI_csi_tb.DPHY_TX.RG_DLANE_HS_ZERO_TIME = 8'h21 ; //8'h1c ;
        force TI180_MIPI_csi_tb.DPHY_TX.RG_DLANE_HS_TRAIL_TIME = 8'h16 ; //8'h13 ;
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CLANE_HS_PRE_TIME = 8'hB ; //8'h9 ;     
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CLANE_HS_ZERO_TIME = 8'h53 ; //8'h42 ;
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CLANE_HS_TRAIL_TIME = 8'h16 ; //8'h12 ;
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CLANE_HS_CLK_PRE_TIME = 8'h0 ; //8'h1 ;
        force TI180_MIPI_csi_tb.DPHY_TX.RG_CLANE_HS_CLK_POST_TIME = 8'h18 ; //8'h1b ;
        force TI180_MIPI_csi_tb.DPHY_TX.VCONTROL = 5'b0 ;
        force TI180_MIPI_csi_tb.DPHY_TX.XCFGI_DW00 = 32'h87654321 ;
        force TI180_MIPI_csi_tb.DPHY_TX.XCFGI_DW01 = 32'h0fedcba9 ;
        force TI180_MIPI_csi_tb.DPHY_TX.XCFGI_DW02 = 32'h00000000 ;
        force TI180_MIPI_csi_tb.DPHY_TX.XCFGI_DW03 = 32'h00000000 ;
        force TI180_MIPI_csi_tb.DPHY_TX.XCFGI_DW04 = 32'h00000000 ;
        force TI180_MIPI_csi_tb.DPHY_TX.XCFGI_DW05 = 32'h00000000 ;
        force TI180_MIPI_csi_tb.DPHY_TX.XCFGI_DW06 = 32'h00000000 ;
        force TI180_MIPI_csi_tb.DPHY_TX.XCFGI_DW07 = 32'h10842108 ;
        force TI180_MIPI_csi_tb.DPHY_TX.XCFGI_DW08 = 32'h00042108 ;
        force TI180_MIPI_csi_tb.DPHY_TX.XCFGI_DW09 = 32'h00000000 ;
        force TI180_MIPI_csi_tb.DPHY_TX.XCFGI_DW0A = 32'h00000000 ;
        force TI180_MIPI_csi_tb.DPHY_TX.XCFGI_DW0B = 32'h00000000 ;
        force TI180_MIPI_csi_tb.DPHY_TX.CFG_DATABUS16_SEL = 1'b1 ; // 16-bit
        force TI180_MIPI_csi_tb.DPHY_TX.CFG_CKLANE_SET = 5'b10000 ;
        force TI180_MIPI_csi_tb.DPHY_TX.CFG_L0_SWAP_SEL = 3'b000 ;
        force TI180_MIPI_csi_tb.DPHY_TX.CFG_L1_SWAP_SEL = 3'b001 ;
        force TI180_MIPI_csi_tb.DPHY_TX.CFG_L2_SWAP_SEL = 3'b010 ;
        force TI180_MIPI_csi_tb.DPHY_TX.CFG_L3_SWAP_SEL = 3'b011 ;
        force TI180_MIPI_csi_tb.DPHY_TX.CFG_L4_SWAP_SEL = 3'b100 ;
        force TI180_MIPI_csi_tb.DPHY_TX.CFG_DPDN_SWAP = 5'b00000 ;
        force TI180_MIPI_csi_tb.DPHY_TX.refclk_in_sel = 3'b011 ;  // 25Mhz 
        force TI180_MIPI_csi_tb.DPHY_TX.ppi_enable_clk0 = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_TX.ppi_enable_lan0 = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_TX.ppi_enable_lan1 = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_TX.ppi_enable_lan2 = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_TX.ppi_enable_lan3 = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_TX.ppi_turndisable_lan0 = 1'b1;
        //force TI180_MIPI_csi_tb.DPHY_TX.refclk_inmux_sel[1] = 1'b0;   // using core clkout refclk
        //force TI180_MIPI_csi_tb.DPHY_TX.refclk_inmux_sel[0] = 1'b0;
        // MISC
        force TI180_MIPI_csi_tb.DPHY_TX.tx_pwrdn_n = 1'd1;
        force TI180_MIPI_csi_tb.DPHY_TX.tx_usrctrl_rst = 1'd1;
        force TI180_MIPI_csi_tb.DPHY_TX.tx_pwrup_mode = 1'b0;
        // DEBUG     
        force TI180_MIPI_csi_tb.DPHY_TX.debug_en_tx = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_TX.scan_en_tx = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_TX.seldftdbg_tx = 1'b0;
    end
    
    initial begin
        force TI180_MIPI_csi_tb.DPHY_RX.RG_CDRX_L012_SUBLVDS_EN = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.RG_CDRX_L345_SUBLVDS_EN = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.RG_CDRX_L012_HSRT_CTRL = 6'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.RG_CDRX_L345_HSRT_CTRL = 6'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.RG_CFGCLK_1US_CNT = 8'd100;   //cfgclk ~100Mhz
        force TI180_MIPI_csi_tb.DPHY_RX.RG_HSRX_CLK_PRE_TIME_GRP0 = 8'h8;
        force TI180_MIPI_csi_tb.DPHY_RX.RG_HSRX_CLK_PRE_TIME_GRP1 = 8'h8 ;
        force TI180_MIPI_csi_tb.DPHY_RX.RG_HSRX_DATA_PRE_TIME_GRP0 = 8'h7;
        force TI180_MIPI_csi_tb.DPHY_RX.RG_HSRX_DATA_PRE_TIME_GRP1 = 8'h7;
        force TI180_MIPI_csi_tb.DPHY_RX.RG_CDRX_BISTHS_PLL_EN = 1'b0 ;
        force TI180_MIPI_csi_tb.DPHY_RX.RG_CDRX_BISTHS_PLL_FBK_INT = 9'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.RG_CDRX_BISTHS_PLL_PRE_DIV2 = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.RG_CDRX_DSIRX_EN = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.VCONTROL = 5'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW00 = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW01 = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW02 = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW03 = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW04 = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW05 = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW06 = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW07 = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW08 = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW09 = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW0A = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW0B = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.XCFGI_DW0C = 32'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_2D1C = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_DATABUS16_SEL = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_D0_SWAP_SEL = 3'b000;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_D1_SWAP_SEL = 3'b001;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_D2_SWAP_SEL = 3'b010;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_D3_SWAP_SEL = 3'b011;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_C0_SWAP_SEL = 3'b100;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_C1_SWAP_SEL = 3'b101;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_DPDN_SWAP = 6'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_ALGN_THR = 3'b100;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_STOP_IND = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_FIFO_BYP = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_STOP_BYP = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_CTRL_RSV = 4'b0 ;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_RSYNC_FIFO_BYP = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.CFG_RSYNC_STOP_BYP = 1'b0; 
        force TI180_MIPI_csi_tb.DPHY_RX.ppi_enable_clk0 = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_RX.ppi_enable_clk1 = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.ppi_enable_lan0 = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_RX.ppi_enable_lan1 = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_RX.ppi_enable_lan2 = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_RX.ppi_enable_lan3 = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_RX.ppi_turndisable_lan0 = 1'b1; 
        // MISC
        force TI180_MIPI_csi_tb.DPHY_RX.rx_pwrdn_n = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_RX.rx_usrctrl_rst = 1'b1;
        force TI180_MIPI_csi_tb.DPHY_RX.rx_pwrup_mode = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.debug_en_rx = 1'b0;
        force TI180_MIPI_csi_tb.DPHY_RX.scan_en_rx = 1'b0;
    end
///////////////////// start of dphy_2p5g_rx////////////////
logic [15:0] RxDataHS_0, RxDataHS_1, RxDataHS_2, RxDataHS_3, RxDataHS_4, RxDataHS_5, RxDataHS_6, RxDataHS_7;
logic [NUM_DATA_LANE-1:0][15:0] RxDataHS;
logic [NUM_DATA_LANE-1:0] RxValidHS, RxSyncHS;
logic RxUlpsClkNot, RxUlpsActiveClkNot;
logic [NUM_DATA_LANE-1:0] RxErrEsc, RxErrControl, RxErrSotSyncHS;
logic [NUM_DATA_LANE-1:0] RxUlpsEsc, RxUlpsActiveNot, RxSkewCalHS, RxActiveHS, RxStopState;
logic [NUM_DATA_LANE-1:0] RxClkEsc;
generate
if (NUM_DATA_LANE == 1) begin
assign RxDataHS[0] = RxDataHS_0;
end             
else if (NUM_DATA_LANE == 2) begin
assign RxDataHS[0] = RxDataHS_0;
assign RxDataHS[1] = RxDataHS_1;
end
else if (NUM_DATA_LANE == 4) begin
assign RxDataHS[0] = RxDataHS_0;
assign RxDataHS[1] = RxDataHS_1;
assign RxDataHS[2] = RxDataHS_2;
assign RxDataHS[3] = RxDataHS_3;
end
else if (NUM_DATA_LANE == 8) begin
assign RxDataHS[0] = RxDataHS_0;
assign RxDataHS[1] = RxDataHS_1;
assign RxDataHS[2] = RxDataHS_2;
assign RxDataHS[3] = RxDataHS_3;
assign RxDataHS[4] = RxDataHS_4;
assign RxDataHS[5] = RxDataHS_5;
assign RxDataHS[6] = RxDataHS_6;
assign RxDataHS[7] = RxDataHS_7;
end
endgenerate

wire [7:0]	        nc_rxdatahs_lan0;
wire [7:0]	        nc_rxdatahs_lan1;
wire [7:0]	        nc_rxdatahs_lan2;
wire [7:0]	        nc_rxdatahs_lan3;
wire                rxbyteclkhs_phy;

assign #(2) rxbyteclkhs =  rxbyteclkhs_phy; // assume 2ns core feeback latency

    // DPHY - RX
    dphy_2p5g_rx DPHY_RX (
		.test_mode			        ( 1'b0 ),                           // DFT
		.test_se			        ( 1'b0 ),                           // DFT
		.test_rst_n			        ( 1'b1 ),                           // DFT
		.test_clk			        ( 1'b0 ),                           // DFT
		.testDebug_i			    ( 25'b0 ),                          // DFT
		.testDebug_o			    (  ),                               // DFT
        `ifndef M31_NO_PG_PORT
		.VCC18A_CDRX			    ( 1'b1 ),                           // POWER
		.VCC08D_CDRX			    ( 1'b1 ),                           // POWER
		.GND08D			            ( 1'b0 ),                           // POWER
        `endif
		.PAD_CDRX_L0P			    ( {TXDP_b2[0], TXDP_b1[0], TXDP_b0[0]} ),  // PAD 3-bit
		.PAD_CDRX_L0N			    ( {TXDN_b2[0], TXDN_b1[0], TXDN_b0[0]} ),  // PAD 3-bit
		.PAD_CDRX_L1P			    ( {TXDP_b2[1], TXDP_b1[1], TXDP_b0[1]} ),  // PAD 3-bit
		.PAD_CDRX_L1N			    ( {TXDN_b2[1], TXDN_b1[1], TXDN_b0[1]} ),  // PAD 3-bit
		.PAD_CDRX_L2P			    ( {TXDP_b2[2], TXDP_b1[2], TXDP_b0[2]} ),  // PAD 3-bit
		.PAD_CDRX_L2N			    ( {TXDN_b2[2], TXDN_b1[2], TXDN_b0[2]} ),  // PAD 3-bit
		.PAD_CDRX_L3P			    ( {TXDP_b2[3], TXDP_b1[3], TXDP_b0[3]} ),  // PAD 3-bit
		.PAD_CDRX_L3N			    ( {TXDN_b2[3], TXDN_b1[3], TXDN_b0[3]} ),  // PAD 3-bit
		.PAD_CDRX_L4P			    ( {TXDP_b2[4], TXDP_b1[4], TXDP_b0[4]} ),  // PAD 3-bit
		.PAD_CDRX_L4N			    ( {TXDN_b2[4], TXDN_b1[4], TXDN_b0[4]} ),  // PAD 3-bit
		.PAD_CDRX_L5P			    ( ),                                     // PAD (unused)
		.PAD_CDRX_L5N			    ( ),                                     // PAD (unused)
		.AON_POWER_READY_N			( 1'b0 ),                           // Manual route to external for Level Shifter As we does not have POR. Tied OFF ?
		.rx_resetb			        ( reset_n ),
		.rx_rst0_n			        ( reset_byte_HS_n ),                // Core controller reset from core_rxbyteclkhs_clk0
		.rx_rst1_n			        ( reset_byte_HS_n ),                // Core controller reset from core_rxbyteclkhs_clk1
		.cfgclk_in			        ( rx__cfgclk_in ),
		.ppi_txclkesc_all			( rx__txclkesc_lan0 ),
		.refclk_in                  ( rx__refclk_in ),
		.ppi_rxclkactivehs_clk0		( ),
		.ppi_rxulpsclknot_clk0		( RxUlpsClkNot ),
		.ppi_stopstate_clk0			( ),              
		.ppi_ulpsactivenot_clk0		( RxUlpsActiveClkNot ),
		.ppi_rxbyteclkhs_clk0		( rxbyteclkhs_phy ),        // high speed clock output
		.core_rxbyteclkhs_clk0		( rxbyteclkhs ),            // Core feednacl byteclk ***
		.rxclkstate_clk0			( ),
		.ppi_rxclkactivehs_clk1		( ),
		.ppi_rxulpsclknot_clk1		( ),
		.ppi_stopstate_clk1			( ),              
		.ppi_ulpsactivenot_clk1		( ),
		.ppi_rxbyteclkhs_clk1		( ),       // high speed clock output
		.core_rxbyteclkhs_clk1		( 1'b0 ),      // Core feednacl byteclk
		.rxclkstate_clk1			( ),
		// Lane0
		.ppi_turnrequest_lan0		( 1'b0 ),            
		.ppi_forcerxmode_lan0		( 1'b1 ),            
		.ppi_rxclkesc_lan0			( RxClkEsc[0] ),               
		.ppi_rxlpdtesc_lan0			( ),              
		.ppi_rxulpsesc_lan0			( RxUlpsEsc[0] ),              
		.ppi_rxtriggeresc_lan0		( ),           
		.ppi_rxdataesc_lan0			( ),              
		.ppi_rxvalidesc_lan0		( ),             
		.ppi_ulpsactivenot_lan0		( RxUlpsActiveNot[0] ),              
		.ppi_direction_lan0			( ),              
		.ppi_erresc_lan0			( RxErrEsc[0] ),                 
		.ppi_errsyncesc_lan0		( ),             
		.ppi_errcontrol_lan0		( RxErrControl[0] ),             
		.ppi_errcontentionlp0_lan0	( ),       
		.ppi_errcontentionlp1_lan0	( ),
		.ppi_rxactivehs_lan0		( RxActiveHS[0] ),
		.ppi_rxvalidhs_lan0			( RxValidHS[0] ),
		.ppi_rxsynchs_lan0			( RxSyncHS[0] ),
		.ppi_rxskewcalhs_lan0		( RxSkewCalHS[0] ),
		.ppi_rxdatahs_lan0			( RxDataHS_0 ),
		.ppi_errsoths_lan0			( ),
		.ppi_errsotsynchs_lan0		( RxErrSotSyncHS[0] ),
		.ppi_stopstate_lan0			( RxStopState[0] ),              
		// Lane1
		.ppi_rxclkesc_lan1			( RxClkEsc[1] ),               
		.ppi_rxulpsesc_lan1			( RxUlpsEsc[1] ),              
		.ppi_ulpsactivenot_lan1		( RxUlpsActiveNot[1] ),              
		.ppi_erresc_lan1			( RxErrEsc[1] ),                 
		.ppi_errcontrol_lan1		( RxErrControl[1] ),             
		.ppi_rxactivehs_lan1		( RxActiveHS[1] ),
		.ppi_rxvalidhs_lan1			( RxValidHS[1] ),
		.ppi_rxsynchs_lan1			( RxSyncHS[1] ),
		.ppi_rxskewcalhs_lan1		( RxSkewCalHS[1] ),
		.ppi_rxdatahs_lan1			( RxDataHS_1 ),
		.ppi_errsoths_lan1			( ),
		.ppi_errsotsynchs_lan1		( RxErrSotSyncHS[1] ),
		.ppi_stopstate_lan1			( RxStopState[1] ),              
		// Lane2
		.ppi_rxclkesc_lan2			( RxClkEsc[2] ),               
		.ppi_rxulpsesc_lan2			( RxUlpsEsc[2] ),              
		.ppi_ulpsactivenot_lan2		( RxUlpsActiveNot[2] ),              
		.ppi_erresc_lan2			( RxErrEsc[2] ),                 
		.ppi_errcontrol_lan2		( RxErrControl[2] ),             
		.ppi_rxactivehs_lan2		( RxActiveHS[2] ),
		.ppi_rxvalidhs_lan2			( RxValidHS[2] ),
		.ppi_rxsynchs_lan2			( RxSyncHS[2] ),
		.ppi_rxskewcalhs_lan2		( RxSkewCalHS[2] ),
		.ppi_rxdatahs_lan2			( RxDataHS_2 ),
		.ppi_errsoths_lan2			( ),
		.ppi_errsotsynchs_lan2		( RxErrSotSyncHS[2] ),
		.ppi_stopstate_lan2			( RxStopState[2] ),              
		// Lane3
		.ppi_rxclkesc_lan3			( RxClkEsc[3]),               
		.ppi_rxulpsesc_lan3			( RxUlpsEsc[3] ),              
		.ppi_ulpsactivenot_lan3		( RxUlpsActiveNot[3] ),              
		.ppi_erresc_lan3			( RxErrEsc[3]),                 
		.ppi_errcontrol_lan3		( RxErrControl[3] ),             
		.ppi_rxactivehs_lan3		( RxActiveHS[3] ),
		.ppi_rxvalidhs_lan3			( RxValidHS[3] ),
		.ppi_rxsynchs_lan3			( RxSyncHS[3] ),
		.ppi_rxskewcalhs_lan3		( RxSkewCalHS[3] ),
		.ppi_rxdatahs_lan3			( RxDataHS_3 ),
		.ppi_errsoths_lan3			( ),
		.ppi_errsotsynchs_lan3		( RxErrSotSyncHS[3] ),
		.ppi_stopstate_lan3			( RxStopState[3] ),              
		// Lane0 - turn around
        .ppi_txrequestesc_lan0		( 1'b0 ),           
		.ppi_txlpdtesc_lan0			( 1'b0 ),              
		.ppi_txulpsexit_lan0		( 1'b0 ),             
		.ppi_txulpsesc_lan0			( 1'b0 ),              
		.ppi_txtriggeresc_lan0		( 4'b0 ),           
		.ppi_txdataesc_lan0			( 8'b0 ),              
		.ppi_txvalidesc_lan0		( 1'b0 ),             
		.ppi_txreadyesc_lan0		( ),
		.rx_pcr_clk			        ( 1'b0 ),
		.rx_pcr_clk_o			    ( ),
		.rx_pcr_en			        ( 1'b0 ),
		.rx_pcr0_in			        ( 1'b0 ),
		.rx_pcr0_out			    ( ),
		.pcr_ready			        ( 1'b1 ),
		.in_user			        ( 1'b1 ),
		.frzreg			            ( 1'b0 )); 
		
///////////////////// end of dphy_2p5g_rx////////////////

///////////////////// start of dphy_2p5g_tx////////////////
logic TxStopStateC;
logic TxUlpsClk, TxUlpsExitClk, TxUlpsActiveClkNot, TxRequestHS_int, TxReadyHS_int, TxRequestHSc;
logic [NUM_DATA_LANE-1:0] TxSkewCalHS, TxRequestEsc, TxUlpsExit, TxUlpsEsc, TxStopStateD, TxUlpsActiveNot;
logic [NUM_DATA_LANE-1:0] TxRequestHS, TxReadyHS;
logic [HS_DATA_WIDTH-1:0] TxDataHS_0, TxDataHS_1, TxDataHS_2, TxDataHS_3, TxDataHS_4, TxDataHS_5, TxDataHS_6, TxDataHS_7;
logic TxReqValidHS0, TxReqValidHS1, TxReqValidHS2, TxReqValidHS3;

// M31 2.5G harden phy 
wire   tx_byteclk_hs_phy_o;
logic  tx_byteclk_hs_phy_int;
// delay 2ns for soft controller
assign #2 tx_byteclk_hs_phy_int = tx_byteclk_hs_phy_o; 
assign tx_byteclk_hs_phy     = tx_byteclk_hs_phy_int;

dphy_2p5g_tx DPHY_TX (  
	.test_mode(1'b0),
	.test_se(1'b0),
	.test_rst_n(1'b1),
	.test_clk(1'b0),
    .testDebug_i(27'b0),
    .testDebug_o(),
	.sel_dft_debug_tx(),
    `ifndef M31_NO_PG_PORT
	.VCC08D_CDTX(1'b1),
	.GND08D(1'b0),
	.VCC18A_CDTX(1'b1),
    `endif
	.PAD_CDTX_L0P({TXDP_b2[0], TXDP_b1[0], TXDP_b0[0]}),
	.PAD_CDTX_L0N({TXDN_b2[0], TXDN_b1[0], TXDN_b0[0]}),
	.PAD_CDTX_L1P({TXDP_b2[1], TXDP_b1[1], TXDP_b0[1]}),
	.PAD_CDTX_L1N({TXDN_b2[1], TXDN_b1[1], TXDN_b0[1]}),
	.PAD_CDTX_L2P({TXDP_b2[2], TXDP_b1[2], TXDP_b0[2]}),
	.PAD_CDTX_L2N({TXDN_b2[2], TXDN_b1[2], TXDN_b0[2]}),
	.PAD_CDTX_L3P({TXDP_b2[3], TXDP_b1[3], TXDP_b0[3]}),
	.PAD_CDTX_L3N({TXDN_b2[3], TXDN_b1[3], TXDN_b0[3]}),
	.PAD_CDTX_L4P({TXDP_b2[4], TXDP_b1[4], TXDP_b0[4]}),
	.PAD_CDTX_L4N({TXDN_b2[4], TXDN_b1[4], TXDN_b0[4]}),
    .AON_POWER_READY_N(1'b0),
	.tx_resetb(reset_n),    
    .refclk_in(tx__refclk_in), // 25Mhz
	.ppi_txclkesc_all(tx__m_txclkesc),
	.ref_txbyteclkhs(tx_byteclk_hs_phy_o),
	.ppi_txrequesths_clk0(TxRequestHSc),
	.ppi_txulpsexit_clk0(TxUlpsExitClk),
	.ppi_txulpsclk_clk0(TxUlpsClk),
	.ppi_txbyteclkhs_clk0(tx_byteclk_hs_phy_int),
	.ppi_stopstate_clk0(TxStopStateC),
	.ppi_ulpsactivenot_clk0(TxUlpsActiveClkNot),
	.ppi_txrequesths_lan0(TxRequestHS[0]),
	.ppi_txskewcalhs_lan0(TxSkewCalHS[0]),            //Calibration
	.ppi_txreq_high_valid_lan0(TxReqValidHS0),       //for x16
	.ppi_txdatahs_lan0(TxDataHS_0),
	.ppi_txrequestesc_lan0(TxRequestEsc[0]),
	.ppi_txlpdtesc_lan0(1'b0),
	.ppi_txulpsexit_lan0(TxUlpsExit[0]),
	.ppi_txulpsesc_lan0(TxUlpsEsc[0]),
	.ppi_txtriggeresc_lan0(4'h0),
	.ppi_txdataesc_lan0(8'h0),
	.ppi_txvalidesc_lan0(1'h0),
	.ppi_txreadyhs_lan0(TxReadyHS[0]),
	.ppi_txreadyesc_lan0(),
	.ppi_stopstate_lan0(TxStopStateD[0]),
	.ppi_ulpsactivenot_lan0(TxUlpsActiveNot[0]),
	.ppi_txrequesths_lan1(TxRequestHS[1]),
	.ppi_txskewcalhs_lan1(TxSkewCalHS[1]),            //Calibration
	.ppi_txreq_high_valid_lan1(TxReqValidHS1),       //for x16
	.ppi_txdatahs_lan1(TxDataHS_1),
	.ppi_txrequestesc_lan1(TxRequestEsc[1]),
	.ppi_txulpsexit_lan1(TxUlpsExit[1]),
	.ppi_txulpsesc_lan1(TxUlpsEsc[1]),
	.ppi_txreadyhs_lan1(TxReadyHS[1]),
	.ppi_stopstate_lan1(TxStopStateD[1]),
	.ppi_ulpsactivenot_lan1(TxUlpsActiveNot[1]),
	.ppi_txrequesths_lan2(TxRequestHS[2]),
	.ppi_txskewcalhs_lan2(TxSkewCalHS[2]),            //Calibration
	.ppi_txreq_high_valid_lan2(TxReqValidHS2),       //for x16
	.ppi_txdatahs_lan2(TxDataHS_2),
	.ppi_txrequestesc_lan2(TxRequestEsc[2]),
	.ppi_txulpsexit_lan2(TxUlpsExit[2]),
	.ppi_txulpsesc_lan2(TxUlpsEsc[2]),
	.ppi_txreadyhs_lan2(TxReadyHS[2]),
	.ppi_stopstate_lan2(TxStopStateD[2]),
	.ppi_ulpsactivenot_lan2(TxUlpsActiveNot[2]),
	.ppi_txrequesths_lan3(TxRequestHS[3]),
	.ppi_txskewcalhs_lan3(TxSkewCalHS[3]),            //Calibration
	.ppi_txreq_high_valid_lan3(TxReqValidHS3),       //for x16
	.ppi_txdatahs_lan3(TxDataHS_3),
	.ppi_txrequestesc_lan3(TxRequestEsc[3]),
	.ppi_txulpsexit_lan3(TxUlpsExit[3]),
	.ppi_txulpsesc_lan3(TxUlpsEsc[3]),
	.ppi_txreadyhs_lan3(TxReadyHS[3]),
	.ppi_stopstate_lan3(TxStopStateD[3]),
	.ppi_ulpsactivenot_lan3(TxUlpsActiveNot[3]),
	.ppi_turnrequest_lan0(1'b0),
	.ppi_forcerxmode_lan0(1'b0),
	.ppi_rxclkesc_lan0(),
	.ppi_rxlpdtesc_lan0(),
	.ppi_rxulpsesc_lan0(),
	.ppi_rxtriggeresc_lan0(),
	.ppi_rxdataesc_lan0(),
	.ppi_rxvalidesc_lan0(),
	.ppi_direction_lan0(),
	.ppi_erresc_lan0(),
	.ppi_errsyncesc_lan0(),
	.ppi_errcontrol_lan0(),
	.ppi_errcontentionlp0_lan0(),
   	.ppi_errcontentionlp1_lan0(),
    .tx_pcr_clk(1'b0),
	.tx_pcr_clk_o(),
	.tx_pcr_en(1'b0),
	.tx_pcr0_in(1'b0),
	.tx_pcr0_out(),
    .RG_CDTX_PLL_SSC_EN(1'b0),
    .RGS_CDTX_PLL_UNLOCK( ),
	.pcr_ready(1'b1),
	.in_user(1'b1),
    .frzreg(1'b0));
    
///////////////////// end of dphy_2p5g_tx////////////////   

top #(
    .NUM_DATA_LANE     (NUM_DATA_LANE), 
    .PIXEL_BIT         (24),
    .PACK_BIT          (48),
    .HSA               (5),
    .HBP               (5),
    .HFP               (1024),
    .HACT_CNT (1920),
    .VSA (1),
    .VBP (1),
    .VFP (100),
    .VACT_CNT (1080),
    .DATATYPE (DATATYPE)
) DUT (
    .reset_n (reset_n),
    .led (),
    .mipi_clk (clk),
    .start_transfer_n (start_transfer_n),
    .pixel_clk (clk_pixel),
    .cfg_clk (rx__cfgclk_in),
    .esc_clk (rx__txclkesc_lan0),
    
	.mipi_dphy_tx_SLOWCLK (tx_byteclk_hs_phy),      //312.5MHz from PLL for HS Byte c
	.mipi_dphy_tx_inst1_ESC_CLK (), //out
	.mipi_dphy_tx_inst1_RESET (), //out
	.mipi_dphy_tx_inst1_STOPSTATE_CLK (TxStopStateC),
	.mipi_dphy_tx_inst1_HS_CLK_REQUEST (TxRequestHSc), //out
	.mipi_dphy_tx_inst1_ULPS_CLK_ENTER (TxUlpsClk), //out
	.mipi_dphy_tx_inst1_ULPS_CLK_EXIT (TxUlpsExitClk), //out
	.mipi_dphy_tx_inst1_ULPS_CLK_ACTIVEN (TxUlpsActiveClkNot), 
	
	.mipi_dphy_tx_inst1_ULPS_LAN0_ENTER (TxUlpsEsc[0]), //out
	.mipi_dphy_tx_inst1_ULPS_LAN1_ENTER (TxUlpsEsc[1]), //out
	.mipi_dphy_tx_inst1_ULPS_LAN2_ENTER (TxUlpsEsc[2]), //out
	.mipi_dphy_tx_inst1_ULPS_LAN3_ENTER (TxUlpsEsc[3]), //out
	.mipi_dphy_tx_inst1_ULPS_LAN0_EXIT (TxUlpsExit[0]), //out
	.mipi_dphy_tx_inst1_ULPS_LAN1_EXIT (TxUlpsExit[1]), //out
	.mipi_dphy_tx_inst1_ULPS_LAN2_EXIT (TxUlpsExit[2]), //out
	.mipi_dphy_tx_inst1_ULPS_LAN3_EXIT (TxUlpsExit[3]), //out
	
	.mipi_dphy_tx_inst1_REQUESTESC_LAN0 (TxRequestEsc[0]), //out
	.mipi_dphy_tx_inst1_REQUESTESC_LAN1 (TxRequestEsc[1]), //out
	.mipi_dphy_tx_inst1_REQUESTESC_LAN2 (TxRequestEsc[2]), //out
	.mipi_dphy_tx_inst1_REQUESTESC_LAN3 (TxRequestEsc[3]), //out
	.mipi_dphy_tx_inst1_HS_LAN0_SKEWCAL (TxSkewCalHS[0]), //out
	.mipi_dphy_tx_inst1_HS_LAN1_SKEWCAL (TxSkewCalHS[1]), //out
	.mipi_dphy_tx_inst1_HS_LAN2_SKEWCAL (TxSkewCalHS[2]), //out
	.mipi_dphy_tx_inst1_HS_LAN3_SKEWCAL (TxSkewCalHS[3]), //out
	.mipi_dphy_tx_inst1_STOPSTATE_LAN0 (TxStopStateD[0]), 
	.mipi_dphy_tx_inst1_STOPSTATE_LAN1 (TxStopStateD[1]),
	.mipi_dphy_tx_inst1_STOPSTATE_LAN2 (TxStopStateD[2]),
	.mipi_dphy_tx_inst1_STOPSTATE_LAN3 (TxStopStateD[3]),
	.mipi_dphy_tx_inst1_ULPS_LAN0_ACTIVEN (TxUlpsActiveNot[0]),
	.mipi_dphy_tx_inst1_ULPS_LAN1_ACTIVEN (TxUlpsActiveNot[1]),
	.mipi_dphy_tx_inst1_ULPS_LAN2_ACTIVEN (TxUlpsActiveNot[2]),
	.mipi_dphy_tx_inst1_ULPS_LAN3_ACTIVEN (TxUlpsActiveNot[3]),
	.mipi_dphy_tx_inst1_HS_LAN0_READY (TxReadyHS[0]),
	.mipi_dphy_tx_inst1_HS_LAN1_READY (TxReadyHS[1]),
	.mipi_dphy_tx_inst1_HS_LAN2_READY (TxReadyHS[2]),
	.mipi_dphy_tx_inst1_HS_LAN3_READY (TxReadyHS[3]),
	.mipi_dphy_tx_inst1_HS_LAN0_REQUEST (TxRequestHS[0]),
	.mipi_dphy_tx_inst1_HS_LAN1_REQUEST (TxRequestHS[1]),
	.mipi_dphy_tx_inst1_HS_LAN2_REQUEST (TxRequestHS[2]),
	.mipi_dphy_tx_inst1_HS_LAN3_REQUEST (TxRequestHS[3]),
	.mipi_dphy_tx_inst1_HS_LAN0_DATA (TxDataHS_0),
	.mipi_dphy_tx_inst1_HS_LAN1_DATA (TxDataHS_1),
	.mipi_dphy_tx_inst1_HS_LAN2_DATA (TxDataHS_2),
	.mipi_dphy_tx_inst1_HS_LAN3_DATA (TxDataHS_3),
	.mipi_dphy_tx_inst1_HS_LAN0_HIGHVALID (TxReqValidHS0),
	.mipi_dphy_tx_inst1_HS_LAN1_HIGHVALID (TxReqValidHS1),
	.mipi_dphy_tx_inst1_HS_LAN2_HIGHVALID (TxReqValidHS2),
	.mipi_dphy_tx_inst1_HS_LAN3_HIGHVALID (TxReqValidHS3),
	
// PPI DPHY RX IF
	.mipi_dphy_rx_clk_CLKOUT (rxbyteclkhs),   //312.5MHz fr
	.mipi_dphy_rx_inst2_CAL_CLK (),
	.mipi_dphy_rx_inst2_RESET (),   //active low
	.mipi_dphy_rx_inst2_RST0_N (),  // active lo
	
	.mipi_dphy_rx_inst2_ULPS_CLK_ACTIVEN (RxUlpsActiveClkNot),
	.mipi_dphy_rx_inst2_ULPS_CLK_ENTER (RxUlpsClkNot),
	
	.mipi_dphy_rx_inst2_ESC_LAN0_CLK (RxClkEsc[0]),
	.mipi_dphy_rx_inst2_ESC_LAN1_CLK (RxClkEsc[1]),
	.mipi_dphy_rx_inst2_ESC_LAN2_CLK (RxClkEsc[2]),
	.mipi_dphy_rx_inst2_ESC_LAN3_CLK (RxClkEsc[3]),
	.mipi_dphy_rx_inst2_LINESTATE_LAN0_ERROR (RxErrEsc[0]),
	.mipi_dphy_rx_inst2_LINESTATE_LAN1_ERROR (RxErrEsc[1]),
	.mipi_dphy_rx_inst2_LINESTATE_LAN2_ERROR (RxErrEsc[2]),
	.mipi_dphy_rx_inst2_LINESTATE_LAN3_ERROR (RxErrEsc[3]),
	.mipi_dphy_rx_inst2_STOPSTATE_LAN0 (RxStopState[0]),
	.mipi_dphy_rx_inst2_STOPSTATE_LAN1 (RxStopState[1]),
	.mipi_dphy_rx_inst2_STOPSTATE_LAN2 (RxStopState[2]),
	.mipi_dphy_rx_inst2_STOPSTATE_LAN3 (RxStopState[3]),
	.mipi_dphy_rx_inst2_ESC_LAN0_ERROR (RxErrEsc[0]),
	.mipi_dphy_rx_inst2_ESC_LAN1_ERROR (RxErrEsc[1]),
	.mipi_dphy_rx_inst2_ESC_LAN2_ERROR (RxErrEsc[2]),
	.mipi_dphy_rx_inst2_ESC_LAN3_ERROR (RxErrEsc[3]),
	.mipi_dphy_rx_inst2_HS_LAN0_VALID (RxValidHS[0]),
	.mipi_dphy_rx_inst2_HS_LAN1_VALID (RxValidHS[1]),
	.mipi_dphy_rx_inst2_HS_LAN2_VALID (RxValidHS[2]),
	.mipi_dphy_rx_inst2_HS_LAN3_VALID (RxValidHS[3]),
	.mipi_dphy_rx_inst2_HS_LAN0_DATA (RxDataHS[0]),
	.mipi_dphy_rx_inst2_HS_LAN1_DATA (RxDataHS[1]),
	.mipi_dphy_rx_inst2_HS_LAN2_DATA (RxDataHS[2]),
	.mipi_dphy_rx_inst2_HS_LAN3_DATA (RxDataHS[3]),
	.mipi_dphy_rx_inst2_HS_LAN0_SKEWCAL (RxSkewCalHS[0]),
	.mipi_dphy_rx_inst2_HS_LAN1_SKEWCAL (RxSkewCalHS[1]),
	.mipi_dphy_rx_inst2_HS_LAN2_SKEWCAL (RxSkewCalHS[2]),
	.mipi_dphy_rx_inst2_HS_LAN3_SKEWCAL (RxSkewCalHS[3]),
	.mipi_dphy_rx_inst2_HS_LAN0_SYNC (RxSyncHS[0]),
	.mipi_dphy_rx_inst2_HS_LAN1_SYNC (RxSyncHS[1]),
	.mipi_dphy_rx_inst2_HS_LAN2_SYNC (RxSyncHS[2]),
	.mipi_dphy_rx_inst2_HS_LAN3_SYNC (RxSyncHS[3]),
	.mipi_dphy_rx_inst2_HS_LAN0_SOTSYNC_ERROR (RxErrSotSyncHS[0]),
	.mipi_dphy_rx_inst2_HS_LAN1_SOTSYNC_ERROR (RxErrSotSyncHS[1]),
	.mipi_dphy_rx_inst2_HS_LAN2_SOTSYNC_ERROR (RxErrSotSyncHS[2]),
	.mipi_dphy_rx_inst2_HS_LAN3_SOTSYNC_ERROR (RxErrSotSyncHS[3]),
	.mipi_dphy_rx_inst2_ULPS_LAN0_ACTIVEN (RxUlpsActiveNot[0]),
	.mipi_dphy_rx_inst2_ULPS_LAN1_ACTIVEN (RxUlpsActiveNot[1]),
	.mipi_dphy_rx_inst2_ULPS_LAN2_ACTIVEN (RxUlpsActiveNot[2]),
	.mipi_dphy_rx_inst2_ULPS_LAN3_ACTIVEN (RxUlpsActiveNot[3]),
	.mipi_dphy_rx_inst2_ULPS_LAN0_ENTER (RxUlpsEsc[0]),
	.mipi_dphy_rx_inst2_ULPS_LAN1_ENTER (RxUlpsEsc[1]),
	.mipi_dphy_rx_inst2_ULPS_LAN2_ENTER (RxUlpsEsc[2]),
	.mipi_dphy_rx_inst2_ULPS_LAN3_ENTER (RxUlpsEsc[3])
);

endmodule