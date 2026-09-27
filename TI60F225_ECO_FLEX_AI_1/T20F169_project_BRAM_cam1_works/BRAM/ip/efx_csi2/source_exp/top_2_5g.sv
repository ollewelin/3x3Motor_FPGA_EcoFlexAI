
// synopsys translate_off
`timescale 1 ns / 1 ps													
// synopsys translate_on

module top #(   //csi2 example design
    parameter NUM_DATA_LANE = 4,
    parameter PIXEL_BIT  = 24,
    parameter PACK_BIT   = 48,
    parameter HSA		 = 5,  //minimum value is pixel cnt value, eg: RGB888 - 2
    parameter HBP		 = 5,   //minimum value is pixel cnt value, eg: RGB888 - 2
    parameter HFP		 = 1024,
    parameter HACT_CNT	 = 1920,
    parameter VSA		 = 1,
    parameter VBP		 = 1,
    parameter VFP		 = 100,
    parameter VACT_CNT	 = 1080,
    parameter DATATYPE = 6'h24     //24 - RGB888
)(
input 			reset_n,  //sw5
output [3:0]    led,
input 			mipi_clk,	//100MHz
input           start_transfer_n,
input			pixel_clk,	//50Mhz
input           cfg_clk,
input           esc_clk,

//for CSI TX
input               mipi_dphy_tx_SLOWCLK,      //312.5MHz from PLL for HS Byte clk
//output  logic       mipi_dphy_tx_inst1_ESC_CLK, // do not need to output to DPHY, will connect direct from pll.
output  logic       mipi_dphy_tx_inst1_RESET,
input	logic		mipi_dphy_tx_inst1_STOPSTATE_CLK,
output  logic		mipi_dphy_tx_inst1_HS_CLK_REQUEST,
output 	logic		mipi_dphy_tx_inst1_ULPS_CLK_ENTER,
output 	logic		mipi_dphy_tx_inst1_ULPS_CLK_EXIT,
input	logic		mipi_dphy_tx_inst1_ULPS_CLK_ACTIVEN,

output	logic		mipi_dphy_tx_inst1_ULPS_LAN0_ENTER,
output	logic		mipi_dphy_tx_inst1_ULPS_LAN1_ENTER,
output	logic		mipi_dphy_tx_inst1_ULPS_LAN2_ENTER,
output	logic		mipi_dphy_tx_inst1_ULPS_LAN3_ENTER,
output	logic		mipi_dphy_tx_inst1_ULPS_LAN0_EXIT,
output	logic		mipi_dphy_tx_inst1_ULPS_LAN1_EXIT,
output	logic		mipi_dphy_tx_inst1_ULPS_LAN2_EXIT,
output	logic		mipi_dphy_tx_inst1_ULPS_LAN3_EXIT,

output	logic		mipi_dphy_tx_inst1_REQUESTESC_LAN0,
output	logic		mipi_dphy_tx_inst1_REQUESTESC_LAN1,
output	logic		mipi_dphy_tx_inst1_REQUESTESC_LAN2,
output	logic		mipi_dphy_tx_inst1_REQUESTESC_LAN3,
output	logic		mipi_dphy_tx_inst1_HS_LAN0_SKEWCAL,
output	logic		mipi_dphy_tx_inst1_HS_LAN1_SKEWCAL,
output	logic		mipi_dphy_tx_inst1_HS_LAN2_SKEWCAL,
output	logic		mipi_dphy_tx_inst1_HS_LAN3_SKEWCAL,
input	logic		mipi_dphy_tx_inst1_STOPSTATE_LAN0,
input	logic		mipi_dphy_tx_inst1_STOPSTATE_LAN1,
input	logic		mipi_dphy_tx_inst1_STOPSTATE_LAN2,
input	logic		mipi_dphy_tx_inst1_STOPSTATE_LAN3,
input	logic		mipi_dphy_tx_inst1_ULPS_LAN0_ACTIVEN,
input	logic		mipi_dphy_tx_inst1_ULPS_LAN1_ACTIVEN,
input	logic		mipi_dphy_tx_inst1_ULPS_LAN2_ACTIVEN,
input	logic		mipi_dphy_tx_inst1_ULPS_LAN3_ACTIVEN,
input	logic		mipi_dphy_tx_inst1_HS_LAN0_READY,
input	logic		mipi_dphy_tx_inst1_HS_LAN1_READY,
input	logic		mipi_dphy_tx_inst1_HS_LAN2_READY,
input	logic		mipi_dphy_tx_inst1_HS_LAN3_READY,
output	logic		mipi_dphy_tx_inst1_HS_LAN0_REQUEST,
output	logic		mipi_dphy_tx_inst1_HS_LAN1_REQUEST,
output	logic		mipi_dphy_tx_inst1_HS_LAN2_REQUEST,
output	logic		mipi_dphy_tx_inst1_HS_LAN3_REQUEST,
output  logic	[15:0]	mipi_dphy_tx_inst1_HS_LAN0_DATA,
output  logic	[15:0]	mipi_dphy_tx_inst1_HS_LAN1_DATA,
output  logic	[15:0]	mipi_dphy_tx_inst1_HS_LAN2_DATA,
output  logic	[15:0]	mipi_dphy_tx_inst1_HS_LAN3_DATA,
output  logic        mipi_dphy_tx_inst1_HS_LAN0_HIGHVALID,
output  logic        mipi_dphy_tx_inst1_HS_LAN1_HIGHVALID,
output  logic        mipi_dphy_tx_inst1_HS_LAN2_HIGHVALID,
output  logic        mipi_dphy_tx_inst1_HS_LAN3_HIGHVALID,

// PPI DPHY RX IF
input	logic       mipi_dphy_rx_clk_CLKOUT,   //312.5MHz from RX CLK lane for HS Byte clk
//output  logic       mipi_dphy_rx_inst2_CAL_CLK, // do not need to output to DPHY, will connect direct from pll.
output  logic       mipi_dphy_rx_inst2_RESET,   //active low async reset to RX DPHY
output  logic       mipi_dphy_rx_inst2_RST0_N,  // active low async reset to FIFO

input 	logic		mipi_dphy_rx_inst2_ULPS_CLK_ACTIVEN,
input   logic       mipi_dphy_rx_inst2_ULPS_CLK_ENTER,

input   logic		mipi_dphy_rx_inst2_ESC_LAN0_CLK,
input   logic		mipi_dphy_rx_inst2_ESC_LAN1_CLK,
input   logic		mipi_dphy_rx_inst2_ESC_LAN2_CLK,
input   logic		mipi_dphy_rx_inst2_ESC_LAN3_CLK,
input	logic		mipi_dphy_rx_inst2_LINESTATE_LAN0_ERROR,
input	logic		mipi_dphy_rx_inst2_LINESTATE_LAN1_ERROR,
input	logic		mipi_dphy_rx_inst2_LINESTATE_LAN2_ERROR,
input	logic		mipi_dphy_rx_inst2_LINESTATE_LAN3_ERROR,
input  	logic		mipi_dphy_rx_inst2_STOPSTATE_LAN0,
input  	logic		mipi_dphy_rx_inst2_STOPSTATE_LAN1,
input  	logic		mipi_dphy_rx_inst2_STOPSTATE_LAN2,
input  	logic		mipi_dphy_rx_inst2_STOPSTATE_LAN3,
input 	logic		mipi_dphy_rx_inst2_ESC_LAN0_ERROR,
input 	logic		mipi_dphy_rx_inst2_ESC_LAN1_ERROR,
input 	logic		mipi_dphy_rx_inst2_ESC_LAN2_ERROR,
input 	logic		mipi_dphy_rx_inst2_ESC_LAN3_ERROR,
input 	logic		mipi_dphy_rx_inst2_HS_LAN0_VALID,
input 	logic		mipi_dphy_rx_inst2_HS_LAN1_VALID,
input 	logic		mipi_dphy_rx_inst2_HS_LAN2_VALID,
input 	logic		mipi_dphy_rx_inst2_HS_LAN3_VALID,
input   logic 	[15:0]   mipi_dphy_rx_inst2_HS_LAN0_DATA,
input   logic 	[15:0]   mipi_dphy_rx_inst2_HS_LAN1_DATA,
input   logic 	[15:0]   mipi_dphy_rx_inst2_HS_LAN2_DATA,
input   logic 	[15:0]   mipi_dphy_rx_inst2_HS_LAN3_DATA,
input	logic		mipi_dphy_rx_inst2_HS_LAN0_SKEWCAL,
input	logic		mipi_dphy_rx_inst2_HS_LAN1_SKEWCAL,
input	logic		mipi_dphy_rx_inst2_HS_LAN2_SKEWCAL,
input	logic		mipi_dphy_rx_inst2_HS_LAN3_SKEWCAL,
input	logic		mipi_dphy_rx_inst2_HS_LAN0_SYNC,
input	logic		mipi_dphy_rx_inst2_HS_LAN1_SYNC,
input	logic		mipi_dphy_rx_inst2_HS_LAN2_SYNC,
input	logic		mipi_dphy_rx_inst2_HS_LAN3_SYNC,
input	logic		mipi_dphy_rx_inst2_HS_LAN0_SOTSYNC_ERROR,
input	logic		mipi_dphy_rx_inst2_HS_LAN1_SOTSYNC_ERROR,
input	logic		mipi_dphy_rx_inst2_HS_LAN2_SOTSYNC_ERROR,
input	logic		mipi_dphy_rx_inst2_HS_LAN3_SOTSYNC_ERROR,
input   logic    	mipi_dphy_rx_inst2_ULPS_LAN0_ACTIVEN,
input   logic    	mipi_dphy_rx_inst2_ULPS_LAN1_ACTIVEN,
input   logic    	mipi_dphy_rx_inst2_ULPS_LAN2_ACTIVEN,
input   logic    	mipi_dphy_rx_inst2_ULPS_LAN3_ACTIVEN,
input   logic		mipi_dphy_rx_inst2_ULPS_LAN0_ENTER,
input   logic		mipi_dphy_rx_inst2_ULPS_LAN1_ENTER,
input   logic		mipi_dphy_rx_inst2_ULPS_LAN2_ENTER,
input   logic		mipi_dphy_rx_inst2_ULPS_LAN3_ENTER


);

localparam FIFO_WIDTH = 13;
localparam PIXEL_FIFO_DEPTH = 2048;  //set to a power of 2 value that is bigger than HACT_CNT
localparam CLOCK_FREQ_MHZ = 100;

logic i_reset_pixel_n;
logic rx_out_valid_1P, rx_out_hs_1P;
logic mipi_clk_reset_n, mipi_dphy_rx_reset_byte_HS_n, reset_pixel_n, mipi_dphy_tx_reset_byte_HS_n, reset_esc_n;
logic [21:0] count_led;
logic [5:0] datatype;
logic [15:0] word_count;
logic [FIFO_WIDTH-1:0] r_x_active_1P, r_y_active_1P;

logic w_global_rstn;

assign w_global_rstn = mipi_clk_reset_n;

// logic to handle the init+skewcal timing of dphy (100us+400us).
localparam tINIT_NS = 500000;
localparam MIPI_CLK_MHZ = CLOCK_FREQ_MHZ; // leverage on esc_clk
localparam integer MIPI_CLK_NS = 1000/(MIPI_CLK_MHZ);
localparam integer INIT_CYCLE = (tINIT_NS / MIPI_CLK_NS); //min=400us for init+skew.

logic [31:0] w_init_cnt;
logic w_init_done;

always @ (posedge mipi_clk or negedge w_global_rstn) begin
    if (~w_global_rstn) begin
        w_init_cnt    <= 'd0;
    end
    else if (w_init_cnt < INIT_CYCLE) begin
        w_init_cnt    <= w_init_cnt + 'd1;
    end
end

assign w_init_done = (w_init_cnt == INIT_CYCLE);


assign mipi_dphy_tx_inst1_RESET = reset_n;
assign mipi_dphy_rx_inst2_RESET = reset_n;
assign mipi_dphy_rx_inst2_RST0_N = reset_n;

assign mipi_dphy_tx_inst1_ESC_CLK = esc_clk;
assign mipi_dphy_rx_inst2_CAL_CLK = cfg_clk;

always @ (posedge mipi_dphy_rx_clk_CLKOUT or negedge mipi_dphy_rx_reset_byte_HS_n) begin
    if (~mipi_dphy_rx_reset_byte_HS_n) begin
        count_led <= 22'h0;
    end
    else begin
        count_led <= count_led + 22'h1;
    end
end

always @ (posedge mipi_clk or negedge reset_n) begin
    if (~reset_n) begin
        i_reset_pixel_n <= 1'b0;
    end
    else if (~start_transfer_n & w_init_done) begin
        i_reset_pixel_n <= 1'b1;
    end
end


assign	mipi_dphy_tx_clk_RST	= 1'b0;
assign	mipi_dphy_tx_data0_RST	= 1'b0;
assign  mipi_dphy_rx_data0_RST   = 1'b0;
assign	mipi_dphy_tx_data1_RST	= 1'b0;
assign  mipi_dphy_rx_data1_RST   = 1'b0;
assign	mipi_dphy_tx_data2_RST	= 1'b0;
assign  mipi_dphy_rx_data2_RST   = 1'b0;
assign	mipi_dphy_tx_data3_RST	= 1'b0;
assign  mipi_dphy_rx_data3_RST   = 1'b0;

reset
#(
	.IN_RST_ACTIVE	("LOW"),
	.OUT_RST_ACTIVE	("LOW"),
	.CYCLE			(3)
)
inst_clk_rst
(
	.i_arst	(reset_n),
	.i_clk	(mipi_clk),
	.o_srst	(mipi_clk_reset_n)
);

reset
#(
	.IN_RST_ACTIVE	("LOW"),
	.OUT_RST_ACTIVE	("LOW"),
	.CYCLE			(3)
)
inst_rx_byteclk_rst
(
	.i_arst	(reset_n),
	.i_clk	(mipi_dphy_rx_clk_CLKOUT),
	.o_srst	(mipi_dphy_rx_reset_byte_HS_n)
);

reset
#(
	.IN_RST_ACTIVE	("LOW"),
	.OUT_RST_ACTIVE	("LOW"),
	.CYCLE			(3)
)
inst_tx_byteclk_rst
(
	.i_arst	(reset_n),
	.i_clk	(mipi_dphy_tx_SLOWCLK),
	.o_srst	(mipi_dphy_tx_reset_byte_HS_n)
);

reset
#(
	.IN_RST_ACTIVE	("LOW"),
	.OUT_RST_ACTIVE	("LOW"),
	.CYCLE			(3)
)
inst_pixel_clk_rst
(
	.i_arst	(i_reset_pixel_n),
	.i_clk	(pixel_clk),
	.o_srst	(reset_pixel_n)
);

reset
#(
	.IN_RST_ACTIVE	("LOW"),
	.OUT_RST_ACTIVE	("LOW"),
	.CYCLE			(3)
)
inst_esc_clk_rst
(
	.i_arst	(reset_n),
	.i_clk	(mipi_dphy_tx_inst1_ESC_CLK),
	.o_srst	(reset_esc_n)
);

///////////////////// Start of VGA gen ////////////////
//-----------------------------------------------------------//
// 1280*16 VGA
//-----------------------------------------------------------//
logic [FIFO_WIDTH-1:0] video_x;
logic [FIFO_WIDTH-1:0] video_y;
logic video_valid, video_de, video_hs, video_vs;
logic tx_out_valid, tx_out_hs, tx_out_vs;
logic [PACK_BIT-1:0] tx_out_data;
logic [FIFO_WIDTH-1:0] pg_x;
logic [FIFO_WIDTH-1:0] pg_y;
logic pg_valid, pg_de, pg_hs, pg_vs;
logic [PIXEL_BIT-1:0] pg_data;

vga_gen
#(
	.H_SyncPulse	(HSA		),           
	.H_BackPorch	(HBP		),  	          
	.H_ActivePix	(HACT_CNT	),	           
	.H_FrontPorch	(HFP		),
	.V_SyncPulse	(VSA		),
	.V_BackPorch	(VBP		),
	.V_ActivePix	(VACT_CNT	),
	.V_FrontPorch	(VFP		),
	.FIFO_WIDTH	    (FIFO_WIDTH),
	.P_Cnt			(1		)
)
inst_vga_gen
(
	.in_pclk	(pixel_clk),
	.in_rstn	(reset_pixel_n),
	
	.out_x		(video_x),
	.out_y		(video_y),
	.out_valid	(video_valid),
	.out_de		(video_de),
	.out_hs		(video_hs),
	.out_vs		(video_vs)
);

pattern_gen
#(
	.PIXEL_BIT	(PIXEL_BIT),           
	.FIFO_WIDTH	(FIFO_WIDTH),  	          
	.H_ActivePix(HACT_CNT),
	.V_ActivePix(VACT_CNT)
)
inst_tx_pattern_gen
(
	.in_pclk	(pixel_clk),
	.in_rstn	(reset_pixel_n),
	
	.in_x		(video_x),
	.in_y		(video_y),
	.in_valid	(video_valid),
	.in_de		(video_de),
	.in_hs		(video_hs),
	.in_vs		(video_vs),
	.in_pattern	(1),
	
	.out_x		(pg_x),
	.out_y		(pg_y),
	.out_valid	(pg_valid),
	.out_de		(pg_de),
	.out_hs		(pg_hs),
	.out_vs		(pg_vs),
	.out_data	(pg_data)
);

// Horizontal porch value must be multipled by PACK_BIT/PIXEL_BIT
datatype_gen
#(
	.PIXEL_BIT	(PIXEL_BIT),           
	.PACK_BIT	(PACK_BIT),  	          
	.FIFO_WIDTH	(FIFO_WIDTH)
)
inst_datatype_gen
(
	.in_pclk	(pixel_clk),
	.out_pclk	(pixel_clk),
	.in_rstn	(reset_pixel_n),
	
	.in_x		(pg_x),
	.in_y		(pg_y),
	.in_valid	(pg_valid),
	.in_de		(pg_de),
	.in_hs		(pg_hs),
	.in_vs		(pg_vs),
	.in_data	(pg_data),
	
	.out_x		(),
	.out_y		(),
	.out_valid	(tx_out_valid),
	.out_de		(),
	.out_hs		(tx_out_hs),
	.out_vs		(tx_out_vs),
	.out_data	(tx_out_data)
);
///////////////////// end of VGA gen ////////////////

logic	[5:0]	r_tx_axi_araddr_1P;
logic			r_tx_axi_arvalid_1P;
logic			w_tx_axi_arready;
logic	[31:0]	w_tx_axi_rdata;
logic			w_tx_axi_rvalid;
logic			r_tx_axi_rready_1P;


// Mapping to DPHY TX
logic TxUlpsClk;
logic TxUlpsExitClk;
logic [NUM_DATA_LANE-1:0] TxUlpsEsc;
logic [NUM_DATA_LANE-1:0] TxUlpsExit;
logic [NUM_DATA_LANE-1:0] TxRequestEsc;
logic [NUM_DATA_LANE-1:0] TxSkewCalHS;
logic [NUM_DATA_LANE-1:0] TxRequestHS;
logic TxRequestHSc;
logic [15:0] TxDataHS0;
logic [15:0] TxDataHS1;
logic [15:0] TxDataHS2;
logic [15:0] TxDataHS3;
logic [1:0] TxReqValidHS0, TxReqValidHS1, TxReqValidHS2, TxReqValidHS3;
logic TxUlpsActiveClkNot;
logic [NUM_DATA_LANE-1:0] TxStopStateD;
logic TxStopStateC;
logic [NUM_DATA_LANE-1:0] TxUlpsActiveNot;
logic [NUM_DATA_LANE-1:0] TxReadyHS;


assign mipi_dphy_tx_inst1_ULPS_CLK_ENTER = TxUlpsClk;
assign mipi_dphy_tx_inst1_ULPS_CLK_EXIT = TxUlpsExitClk;
assign TxUlpsActiveClkNot = mipi_dphy_tx_inst1_ULPS_CLK_ACTIVEN;
assign mipi_dphy_tx_inst1_ULPS_LAN0_ENTER = TxUlpsEsc[0];
assign mipi_dphy_tx_inst1_ULPS_LAN1_ENTER = TxUlpsEsc[1];
assign mipi_dphy_tx_inst1_ULPS_LAN2_ENTER = TxUlpsEsc[2];
assign mipi_dphy_tx_inst1_ULPS_LAN3_ENTER = TxUlpsEsc[3];
assign mipi_dphy_tx_inst1_ULPS_LAN0_EXIT = TxUlpsExit[0];
assign mipi_dphy_tx_inst1_ULPS_LAN1_EXIT = TxUlpsExit[1];
assign mipi_dphy_tx_inst1_ULPS_LAN2_EXIT = TxUlpsExit[2];
assign mipi_dphy_tx_inst1_ULPS_LAN3_EXIT = TxUlpsExit[3];
assign mipi_dphy_tx_inst1_REQUESTESC_LAN0 = TxRequestEsc[0];
assign mipi_dphy_tx_inst1_REQUESTESC_LAN1 = TxRequestEsc[1];
assign mipi_dphy_tx_inst1_REQUESTESC_LAN2 = TxRequestEsc[2];
assign mipi_dphy_tx_inst1_REQUESTESC_LAN3 = TxRequestEsc[3];
assign mipi_dphy_tx_inst1_HS_LAN0_SKEWCAL = TxSkewCalHS[0];
assign mipi_dphy_tx_inst1_HS_LAN1_SKEWCAL = TxSkewCalHS[1];
assign mipi_dphy_tx_inst1_HS_LAN2_SKEWCAL = TxSkewCalHS[2];
assign mipi_dphy_tx_inst1_HS_LAN3_SKEWCAL = TxSkewCalHS[3];
assign TxStopStateD[0] = mipi_dphy_tx_inst1_STOPSTATE_LAN0;
assign TxStopStateD[1] = mipi_dphy_tx_inst1_STOPSTATE_LAN1;
assign TxStopStateD[2] = mipi_dphy_tx_inst1_STOPSTATE_LAN2;
assign TxStopStateD[3] = mipi_dphy_tx_inst1_STOPSTATE_LAN3;
assign TxStopStateC = mipi_dphy_tx_inst1_STOPSTATE_CLK;
assign TxUlpsActiveNot[0] = mipi_dphy_tx_inst1_ULPS_LAN0_ACTIVEN;
assign TxUlpsActiveNot[1] = mipi_dphy_tx_inst1_ULPS_LAN1_ACTIVEN;
assign TxUlpsActiveNot[2] = mipi_dphy_tx_inst1_ULPS_LAN2_ACTIVEN;
assign TxUlpsActiveNot[3] = mipi_dphy_tx_inst1_ULPS_LAN3_ACTIVEN;
assign TxReadyHS[0] = mipi_dphy_tx_inst1_HS_LAN0_READY;
assign TxReadyHS[1] = mipi_dphy_tx_inst1_HS_LAN1_READY;
assign TxReadyHS[2] = mipi_dphy_tx_inst1_HS_LAN2_READY;
assign TxReadyHS[3] = mipi_dphy_tx_inst1_HS_LAN3_READY;
assign mipi_dphy_tx_inst1_HS_LAN0_REQUEST = TxRequestHS[0];
assign mipi_dphy_tx_inst1_HS_LAN1_REQUEST = TxRequestHS[1];
assign mipi_dphy_tx_inst1_HS_LAN2_REQUEST = TxRequestHS[2];
assign mipi_dphy_tx_inst1_HS_LAN3_REQUEST = TxRequestHS[3];
assign mipi_dphy_tx_inst1_HS_CLK_REQUEST = TxRequestHSc;
assign mipi_dphy_tx_inst1_HS_LAN0_DATA = TxDataHS0;
assign mipi_dphy_tx_inst1_HS_LAN1_DATA = TxDataHS1;
assign mipi_dphy_tx_inst1_HS_LAN2_DATA = TxDataHS2;
assign mipi_dphy_tx_inst1_HS_LAN3_DATA = TxDataHS3;
assign mipi_dphy_tx_inst1_HS_LAN0_HIGHVALID = TxReqValidHS0[1];
assign mipi_dphy_tx_inst1_HS_LAN1_HIGHVALID = TxReqValidHS1[1];
assign mipi_dphy_tx_inst1_HS_LAN2_HIGHVALID = TxReqValidHS2[1];
assign mipi_dphy_tx_inst1_HS_LAN3_HIGHVALID = TxReqValidHS3[1];

efx_csi2_tx_top inst_csi2_tx_top
(
    .reset_byte_HS_n    (mipi_dphy_tx_reset_byte_HS_n),
    .clk_byte_HS        (mipi_dphy_tx_SLOWCLK),
    .reset_pixel_n      (reset_pixel_n),
    .clk_pixel          (pixel_clk),
    .reset_esc_n        (reset_esc_n),
    .clk_esc            (mipi_dphy_tx_inst1_ESC_CLK),

    //PPI Interface
    .TxUlpsClk			(TxUlpsClk),
    .TxUlpsExitClk      (TxUlpsExitClk),
    .TxUlpsActiveClkNot (TxUlpsActiveClkNot),
    .TxUlpsEsc          (TxUlpsEsc),
    .TxUlpsExit         (TxUlpsExit),
    .TxRequestEsc       (TxRequestEsc),
    .TxSkewCalHS 		(TxSkewCalHS),
    .TxStopStateD  		(TxStopStateD),
    .TxStopStateC		(TxStopStateC),
    .TxUlpsActiveNot	(TxUlpsActiveNot),
    .TxReadyHS			(TxReadyHS),
    .TxRequestHS		(TxRequestHS),
    .TxRequestHSc		(TxRequestHSc),
    .TxDataHS0          (TxDataHS0),
    .TxDataHS1          (TxDataHS1),
    .TxDataHS2          (TxDataHS2),
    .TxDataHS3          (TxDataHS3),
    .TxDataHS4          (),
    .TxDataHS5          (),
    .TxDataHS6          (),
    .TxDataHS7          (),
    .TxReqValidHS0      (TxReqValidHS0),
    .TxReqValidHS1      (TxReqValidHS1),
    .TxReqValidHS2      (TxReqValidHS2),
    .TxReqValidHS3      (TxReqValidHS3),

    //AXI4-Lite Interface
    .axi_clk		    (mipi_clk), 
    .axi_reset_n	    (reset_n),
    .axi_awaddr		    (4'b0),//Write Address. byte address.
    .axi_awvalid	    (1'b1),//Write address valid.
    .axi_awready	    (),//Write address ready.
    .axi_wdata		    (32'b0),//Write data bus.
    .axi_wvalid		    (1'b0),//Write valid.
    .axi_wready		    (),//Write ready.
    .axi_bvalid		    (),//Write response valid.
    .axi_bready		    (1'b0),//Response ready.      
    .axi_araddr		    (r_tx_axi_araddr_1P),//Read address. byte address.
    .axi_arvalid	    (r_tx_axi_arvalid_1P),//Read address valid.
    .axi_arready	    (w_tx_axi_arready),//Read address ready.
    .axi_rdata		    (w_tx_axi_rdata),//Read data.
    .axi_rvalid		    (w_tx_axi_rvalid),//Read valid.
    .axi_rready		    (1'b1),//Read ready.
	
    .hsync_vc0			(tx_out_hs),
    .hsync_vc1			(1'b0),
    .hsync_vc2			(1'b0),
    .hsync_vc3			(1'b0),
    .hsync_vc4			(1'b0),
    .hsync_vc5			(1'b0),
    .hsync_vc6			(1'b0),
    .hsync_vc7			(1'b0),
    .hsync_vc8			(1'b0),
    .hsync_vc9			(1'b0),
    .hsync_vc10			(1'b0),
    .hsync_vc11			(1'b0),
    .hsync_vc12			(1'b0),
    .hsync_vc13			(1'b0),
    .hsync_vc14			(1'b0),
    .hsync_vc15			(1'b0),
    .vsync_vc0			(tx_out_vs),
    .vsync_vc1			(1'b0),
    .vsync_vc2			(1'b0),
    .vsync_vc3			(1'b0),
    .vsync_vc4			(1'b0),
    .vsync_vc5			(1'b0),
    .vsync_vc6			(1'b0),
    .vsync_vc7			(1'b0),
    .vsync_vc8			(1'b0),
    .vsync_vc9			(1'b0),
    .vsync_vc10			(1'b0),
    .vsync_vc11			(1'b0),
    .vsync_vc12			(1'b0),
    .vsync_vc13			(1'b0),
    .vsync_vc14			(1'b0),
    .vsync_vc15			(1'b0),
    .datatype			(DATATYPE),   // data type of the Long Packet
    .pixel_data			(tx_out_data),
    .pixel_data_valid   (tx_out_valid),
    .haddr              (HACT_CNT),  //for RAW8 word_count = HACT_CNT
    .line_num			(0),
    .frame_num			(0),	
    .irq                ()
);


////////////////////////MIPI RX//////////////////////
logic rx_out_valid, rx_out_hs, rx_out_vs;
logic [PACK_BIT-1:0] rx_out_data;
logic [FIFO_WIDTH-1:0] rx_unpack_x;
logic [FIFO_WIDTH-1:0] rx_unpack_y;
logic rx_unpack_valid, rx_unpack_de, rx_unpack_hs, rx_unpack_vs;
logic [PIXEL_BIT-1:0] rx_unpack_data, rx_unpack_data_1P;
logic [FIFO_WIDTH-1:0] golden_x;
logic [FIFO_WIDTH-1:0] golden_y;
logic golden_valid, golden_de, golden_hs, golden_vs;
logic [PIXEL_BIT-1:0] golden_data;
logic r_pass, r_fail;
logic [12:0] flash_cnt;
logic [2:0] error_bit;

logic	[5:0]	r_rx_axi_araddr_1P;
logic			r_rx_axi_arvalid_1P;
logic			w_rx_axi_arready;
logic	[31:0]	w_rx_axi_rdata;
logic			w_rx_axi_rvalid;
logic			r_rx_axi_rready_1P;

// Mapping to DPHY RX IF
logic RxUlpsClkNot;
logic [NUM_DATA_LANE-1:0]	RxErrEsc;
logic [NUM_DATA_LANE-1:0] 	RxErrControl;
logic [NUM_DATA_LANE-1:0] 	RxErrSotSyncHS;
logic [NUM_DATA_LANE-1:0]	RxClkEsc;
logic [NUM_DATA_LANE-1:0]	RxUlpsEsc;
logic [NUM_DATA_LANE-1:0]	RxUlpsActiveNot;
logic [NUM_DATA_LANE-1:0]	RxSkewCalHS;
logic [NUM_DATA_LANE-1:0]	RxStopState;
logic [NUM_DATA_LANE-1:0] 	RxValidHS;
logic [NUM_DATA_LANE-1:0]  	RxSyncHS;
logic [NUM_DATA_LANE-1:0][15:0]	RxDataHS;

assign RxUlpsClkNot = mipi_dphy_rx_inst2_ULPS_CLK_ENTER;
assign RxUlpsActiveClkNot = mipi_dphy_rx_inst2_ULPS_CLK_ACTIVEN;
assign RxErrEsc[0] = mipi_dphy_rx_inst2_ESC_LAN0_ERROR;
assign RxErrEsc[1] = mipi_dphy_rx_inst2_ESC_LAN1_ERROR;
assign RxErrEsc[2] = mipi_dphy_rx_inst2_ESC_LAN2_ERROR;
assign RxErrEsc[3] = mipi_dphy_rx_inst2_ESC_LAN3_ERROR;
assign RxErrControl[0] = mipi_dphy_rx_inst2_LINESTATE_LAN0_ERROR;
assign RxErrControl[1] = mipi_dphy_rx_inst2_LINESTATE_LAN1_ERROR;
assign RxErrControl[2] = mipi_dphy_rx_inst2_LINESTATE_LAN2_ERROR;
assign RxErrControl[3] = mipi_dphy_rx_inst2_LINESTATE_LAN3_ERROR;
assign RxErrSotSyncHS[0] = mipi_dphy_rx_inst2_HS_LAN0_SOTSYNC_ERROR;
assign RxErrSotSyncHS[1] = mipi_dphy_rx_inst2_HS_LAN1_SOTSYNC_ERROR;
assign RxErrSotSyncHS[2] = mipi_dphy_rx_inst2_HS_LAN2_SOTSYNC_ERROR;
assign RxErrSotSyncHS[3] = mipi_dphy_rx_inst2_HS_LAN3_SOTSYNC_ERROR;
assign RxUlpsEsc[0] = mipi_dphy_rx_inst2_ULPS_LAN0_ENTER;
assign RxUlpsEsc[1] = mipi_dphy_rx_inst2_ULPS_LAN1_ENTER;
assign RxUlpsEsc[2] = mipi_dphy_rx_inst2_ULPS_LAN2_ENTER;
assign RxUlpsEsc[3] = mipi_dphy_rx_inst2_ULPS_LAN3_ENTER;
assign RxClkEsc[0] = mipi_dphy_rx_inst2_ESC_LAN0_CLK;
assign RxClkEsc[1] = mipi_dphy_rx_inst2_ESC_LAN1_CLK;
assign RxClkEsc[2] = mipi_dphy_rx_inst2_ESC_LAN2_CLK;
assign RxClkEsc[3] = mipi_dphy_rx_inst2_ESC_LAN3_CLK;
assign RxUlpsActiveNot[0] = mipi_dphy_rx_inst2_ULPS_LAN0_ACTIVEN;
assign RxUlpsActiveNot[1] = mipi_dphy_rx_inst2_ULPS_LAN1_ACTIVEN;
assign RxUlpsActiveNot[2] = mipi_dphy_rx_inst2_ULPS_LAN2_ACTIVEN;
assign RxUlpsActiveNot[3] = mipi_dphy_rx_inst2_ULPS_LAN3_ACTIVEN;
assign RxSkewCalHS[0] = mipi_dphy_rx_inst2_HS_LAN0_SKEWCAL;
assign RxSkewCalHS[1] = mipi_dphy_rx_inst2_HS_LAN1_SKEWCAL;
assign RxSkewCalHS[2] = mipi_dphy_rx_inst2_HS_LAN2_SKEWCAL;
assign RxSkewCalHS[3] = mipi_dphy_rx_inst2_HS_LAN3_SKEWCAL;
assign RxStopState[0] = mipi_dphy_rx_inst2_STOPSTATE_LAN0;
assign RxStopState[1] = mipi_dphy_rx_inst2_STOPSTATE_LAN1;
assign RxStopState[2] = mipi_dphy_rx_inst2_STOPSTATE_LAN2;
assign RxStopState[3] = mipi_dphy_rx_inst2_STOPSTATE_LAN3;
assign RxValidHS[0] = mipi_dphy_rx_inst2_HS_LAN0_VALID;
assign RxValidHS[1] = mipi_dphy_rx_inst2_HS_LAN1_VALID;
assign RxValidHS[2] = mipi_dphy_rx_inst2_HS_LAN2_VALID;
assign RxValidHS[3] = mipi_dphy_rx_inst2_HS_LAN3_VALID;
assign RxSyncHS[0] = mipi_dphy_rx_inst2_HS_LAN0_SYNC;
assign RxSyncHS[1] = mipi_dphy_rx_inst2_HS_LAN1_SYNC;
assign RxSyncHS[2] = mipi_dphy_rx_inst2_HS_LAN2_SYNC;
assign RxSyncHS[3] = mipi_dphy_rx_inst2_HS_LAN3_SYNC;
assign RxDataHS[0] = mipi_dphy_rx_inst2_HS_LAN0_DATA;
assign RxDataHS[1] = mipi_dphy_rx_inst2_HS_LAN1_DATA;
assign RxDataHS[2] = mipi_dphy_rx_inst2_HS_LAN2_DATA;
assign RxDataHS[3] = mipi_dphy_rx_inst2_HS_LAN3_DATA;

efx_csi2_rx_top  inst_csi2_rx_top
(
    .reset_n              	(reset_n),
    .clk                    (mipi_clk),
    .reset_byte_HS_n        (mipi_dphy_rx_reset_byte_HS_n),
    .clk_byte_HS            (mipi_dphy_rx_clk_CLKOUT),
    .reset_pixel_n        	(reset_pixel_n),
    .clk_pixel              (pixel_clk),

    // PPI Interface
    .RxClkEsc               (RxClkEsc),
    .RxUlpsClkNot			(RxUlpsClkNot),
    .RxUlpsActiveClkNot     (RxUlpsActiveClkNot),
    .RxErrEsc				(RxErrEsc),
    .RxErrControl			(RxErrControl),
    .RxErrSotSyncHS			(RxErrSotSyncHS),
    .RxUlpsEsc				(RxUlpsEsc),
    .RxUlpsActiveNot        (RxUlpsActiveNot),
    .RxSkewCalHS			(RxSkewCalHS),
    .RxStopState			(RxStopState),
    .RxSyncHS				(RxSyncHS),
    .RxDataHS0				(RxDataHS[0]),
    .RxDataHS1              (RxDataHS[1]),
    .RxDataHS2              (RxDataHS[2]),
    .RxDataHS3              (RxDataHS[3]),
    .RxDataHS4              (),
    .RxDataHS5              (),
    .RxDataHS6              (),
    .RxDataHS7              (),
    .RxValidHS0             ({RxValidHS[0], RxValidHS[0]}),
    .RxValidHS1             ({RxValidHS[1], RxValidHS[1]}),
    .RxValidHS2             ({RxValidHS[2], RxValidHS[2]}),
    .RxValidHS3             ({RxValidHS[3], RxValidHS[3]}),
    .RxValidHS4             (),
    .RxValidHS5             (),
    .RxValidHS6             (),
    .RxValidHS7             (),
    
    //AXI4-Lite Interface
    .axi_clk            		(mipi_clk),
    .axi_reset_n        		(reset_n),
    .axi_awaddr         		(4'b0),//Write Address. byte address.
    .axi_awvalid        		(1'b0),//Write address valid.
    .axi_awready       			(),//Write address ready.
    .axi_wdata          		(32'b0),//Write data bus.
    .axi_wvalid         		(1'b0),//Write valid.
    .axi_wready         		(),//Write ready.           
    .axi_bvalid         		(),//Write response valid.
    .axi_bready         		(1'b0),//Response ready.      
    .axi_araddr         		(r_rx_axi_araddr_1P),//Read address. byte address.
    .axi_arvalid        		(r_rx_axi_arvalid_1P),//Read address valid.
    .axi_arready        		(w_rx_axi_arready),//Read address ready.
    .axi_rdata          		(w_rx_axi_rdata),//Read data.
    .axi_rvalid         		(w_rx_axi_rvalid),//Read valid.
    .axi_rready         		(1'b1),//Read ready.

    .hsync_vc0                  	(rx_out_hs),
    .hsync_vc1                  	(),
    .hsync_vc2                  	(),
    .hsync_vc3                  	(),
    .hsync_vc4                  	(),
    .hsync_vc5                  	(),
    .hsync_vc6                  	(),
    .hsync_vc7                  	(),
    .hsync_vc8                  	(),
    .hsync_vc9                  	(),
    .hsync_vc10                  	(),
    .hsync_vc11                  	(),
    .hsync_vc12                  	(),
    .hsync_vc13                  	(),
    .hsync_vc14                  	(),
    .hsync_vc15                  	(),
    .vsync_vc0                  	(rx_out_vs),
    .vsync_vc1                  	(),
    .vsync_vc2                 	 	(),
    .vsync_vc3                  	(),
    .vsync_vc4                  	(),
    .vsync_vc5                  	(),
    .vsync_vc6                  	(),
    .vsync_vc7                  	(),
    .vsync_vc8                  	(),
    .vsync_vc9                  	(),
    .vsync_vc10                  	(),
    .vsync_vc11                  	(),
    .vsync_vc12                  	(),
    .vsync_vc13                  	(),
    .vsync_vc14                  	(),
    .vsync_vc15                  	(),

    .vc                                 (),
    .vcx                                (),
    .word_count                     	(word_count),
    .shortpkt_data_field		(),
    .datatype                       	(datatype),        // RAW8
    .pixel_per_clk              	(),
    .pixel_data                     	(rx_out_data),
    .pixel_data_valid   		(rx_out_valid),
    .irq                                ()

);



//------------- Unpack of RX pixel ---------------
//RAW8 for PIXEL_BIT 8, PACK_BIT 64
data_unpack
#(
	.PIXEL_BIT	(PIXEL_BIT),           
	.PACK_BIT	(PACK_BIT),  	          
	.FIFO_WIDTH	(FIFO_WIDTH)
)
inst_data_unpack
(
	.in_pclk	(pixel_clk),
	.in_rstn	(reset_pixel_n),
	
	.in_x		(r_x_active_1P),
	.in_y		(r_y_active_1P),
	.in_valid	(rx_out_valid),
	.in_de		(rx_out_hs),
	.in_hs		(rx_out_hs),
	.in_vs		(rx_out_vs),
	.in_data	(rx_out_data),
	
	.out_x		(rx_unpack_x),
	.out_y		(rx_unpack_y),
	.out_valid	(rx_unpack_valid),
	.out_de		(rx_unpack_de),
	.out_hs		(rx_unpack_hs),
	.out_vs		(rx_unpack_vs),
	.out_data	(rx_unpack_data)
);
//---------- End of unpack RX pixel -------------

//*******************************   
// MIPI-Rx-data comparator 
//*******************************   
pattern_gen
#(
    .PIXEL_BIT    (PIXEL_BIT),           
    .FIFO_WIDTH   (FIFO_WIDTH),                
    .H_ActivePix  (HACT_CNT),
    .V_ActivePix  (VACT_CNT)
)
inst_rx_pattern_gen
(
    .in_pclk    (pixel_clk),
    .in_rstn    (reset_pixel_n),
    
    .in_x        (rx_unpack_x),
    .in_y        (rx_unpack_y),
    .in_valid    (rx_unpack_valid),
    .in_de       (rx_unpack_de),
    .in_hs       (rx_unpack_hs),
    .in_vs       (rx_unpack_vs),
    .in_pattern  (1),
    
    .out_x        (golden_x),
    .out_y        (golden_y),
    .out_valid    (golden_valid),
    .out_de       (golden_de),
    .out_hs       (golden_hs),
    .out_vs       (golden_vs),
    .out_data     (golden_data)
);

always @(posedge pixel_clk or negedge reset_pixel_n) 
begin
    if (~reset_pixel_n) begin
        rx_out_valid_1P <= 1'b0;
        rx_out_hs_1P    <= 1'b0;
    end
	else begin
        rx_out_valid_1P <= rx_out_valid;
        rx_out_hs_1P    <= rx_out_hs;
    end
end

always @ (posedge pixel_clk or negedge reset_pixel_n)
begin
    if(~reset_pixel_n) begin
        rx_unpack_data_1P   <= {PIXEL_BIT{1'b0}};
        r_x_active_1P       <= {FIFO_WIDTH{1'b0}};
        r_y_active_1P       <= {FIFO_WIDTH{1'b0}};
        error_bit           <= 3'b000;
        r_fail              <= 1'b0;
        r_pass              <= 1'b0;
    end    
    else begin        
        rx_unpack_data_1P    <= rx_unpack_data;
        
        if (rx_out_valid) begin
            r_x_active_1P    <= r_x_active_1P + 1'b1;
        end
        else if (~rx_out_hs) begin
            r_x_active_1P    <= {FIFO_WIDTH{1'b0}};
        end
       
        if (~rx_out_hs && rx_out_hs_1P) begin
            r_y_active_1P    <= r_y_active_1P + 1'b1;
        end
        else if (~rx_out_vs) begin
            r_y_active_1P    <= {FIFO_WIDTH{1'b0}};
        end
        
        if (golden_valid && error_bit == 3'b000) begin
            if (golden_data !== rx_unpack_data_1P) begin
                error_bit    <= error_bit + 1'b1;
                r_pass <= 1'b0;
                $display("%t - Error: Expecting RX data %h, received wrong data %h", $time, golden_data, rx_unpack_data_1P); 
            end
            else begin
                r_pass <= 1'b1;
                $display("%t - Correct RX data %h, received", $time, rx_unpack_data_1P);
            end
        end
        
        if (error_bit > 3'b000) r_fail <= 1'b1;
    end
end

always @(posedge pixel_clk or negedge reset_pixel_n) 
begin
    if (~reset_pixel_n) begin
        flash_cnt <= 13'b0;
    end
	else if (~r_fail && rx_out_hs && ~rx_out_hs_1P) begin
        flash_cnt <= flash_cnt + 1'b1;
    end
end

assign led[0] = count_led[21];
assign led[1] = r_fail;
assign led[2] = r_pass;
assign led[3] = flash_cnt[12];

////////////////////////////////

localparam	s_idle			= 2'b00;
localparam	s_wait_arready	= 2'b01;
localparam	s_wait_rvalid	= 2'b10;

reg		[1:0]	r_tx_dbg_fsm_1P;
reg		[8:0]	r_tx_dbg_reg_1P	[0:7];
reg		[1:0]	r_rx_dbg_fsm_1P;
reg		[14:0]	r_rx_dbg_reg_1P	[0:15];

always@(negedge reset_n or posedge mipi_clk)
begin
	if (~reset_n)
	begin
		r_tx_dbg_fsm_1P		<= s_idle;
		r_tx_axi_arvalid_1P	<= 1'b0;
		r_tx_axi_araddr_1P	<= 6'b0;
		r_tx_axi_rready_1P	<= 1'b0;
		
		r_rx_dbg_fsm_1P		<= s_idle;
		r_rx_axi_arvalid_1P	<= 1'b0;
		r_rx_axi_araddr_1P	<= 6'b0;
		r_rx_axi_rready_1P	<= 1'b0;
	end
	else
	begin
		r_tx_axi_rready_1P	<= 1'b0;
		r_rx_axi_rready_1P	<= 1'b0;
		
		case (r_tx_dbg_fsm_1P)
			s_idle:
			begin
				r_tx_dbg_fsm_1P		<= s_wait_arready;
				r_tx_axi_arvalid_1P	<= 1'b1;
			end
			
			s_wait_arready:
			begin
				if (w_tx_axi_arready)
				begin
					r_tx_dbg_fsm_1P		<= s_wait_rvalid;
					r_tx_axi_arvalid_1P	<= 1'b0;
				end
			end
			
			s_wait_rvalid:
			begin
				if (w_tx_axi_rvalid)
				begin
					r_tx_dbg_fsm_1P		<= s_wait_arready;
					r_tx_axi_arvalid_1P	<= 1'b1;
					r_tx_axi_rready_1P	<= 1'b1;
					r_tx_axi_araddr_1P	<= r_tx_axi_araddr_1P+6'h4;
					if (r_tx_axi_araddr_1P == 6'h18)
						r_tx_axi_araddr_1P	<= 6'b0;
					
					r_tx_dbg_reg_1P[r_tx_axi_araddr_1P[4:2]]	<= w_tx_axi_rdata[8:0];
				end
			end
		endcase
		
		case (r_rx_dbg_fsm_1P)
			s_idle:
			begin
				r_rx_dbg_fsm_1P		<= s_wait_arready;
				r_rx_axi_arvalid_1P	<= 1'b1;
			end
			
			s_wait_arready:
			begin
				if (w_rx_axi_arready)
				begin
					r_rx_dbg_fsm_1P		<= s_wait_rvalid;
					r_rx_axi_arvalid_1P	<= 1'b0;
				end
			end
			
			s_wait_rvalid:
			begin
				if (w_rx_axi_rvalid)
				begin
					r_rx_dbg_fsm_1P		<= s_wait_arready;
					r_rx_axi_arvalid_1P	<= 1'b1;
					r_rx_axi_rready_1P	<= 1'b1;
					r_rx_axi_araddr_1P	<= r_rx_axi_araddr_1P+6'h4;
					if (r_rx_axi_araddr_1P == 6'h28)
						r_rx_axi_araddr_1P	<= 6'b0;
					
					r_rx_dbg_reg_1P[r_rx_axi_araddr_1P[5:2]]	<= w_rx_axi_rdata[14:0];
/*					r_rx_axi_araddr_1P	<= r_rx_axi_araddr_1P+6'h10;
					if (r_rx_axi_araddr_1P == 6'h30)
						r_rx_axi_araddr_1P	<= 6'b0;
					
					r_rx_dbg_reg_1P[r_rx_axi_araddr_1P[5:4]]	<= w_rx_axi_rdata[14:0];*/
				end
			end
		endcase
	end
end

endmodule
