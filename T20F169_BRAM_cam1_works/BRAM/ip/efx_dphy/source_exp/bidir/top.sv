
// synopsys translate_off
`timescale 1 ns / 1 ps													
// synopsys translate_on

module top #(
    parameter HS_BYTECLK_MHZ = 100
)(   //dphy
input          mipi_clk,	//100MHz
input          reset_n,  //sw5
output [3:0]   led,
input          pll_locked,
output         pll_rstn,
                
input           mipi_dphy_rx_clk_LP_P_IN,
input           mipi_dphy_rx_clk_LP_N_IN,
output          mipi_dphy_rx_clk_HS_TERM,
output          mipi_dphy_rx_clk_HS_ENA,
input           mipi_dphy_rx_clk_CLKOUT,
                
output          mipi_dphy_rx_data0_LP_P_OUT,
output          mipi_dphy_rx_data0_LP_P_OE,
output          mipi_dphy_rx_data0_LP_N_OUT,
output          mipi_dphy_rx_data0_LP_N_OE,

input   [7:0]   mipi_dphy_rx_data0_HS_IN,
input           mipi_dphy_rx_data0_LP_P_IN,
input           mipi_dphy_rx_data0_LP_N_IN,
output          mipi_dphy_rx_data0_RST,
output          mipi_dphy_rx_data0_HS_TERM,
output          mipi_dphy_rx_data0_HS_ENA,
output          mipi_dphy_rx_data0_FIFO_RD,
input           mipi_dphy_rx_data0_FIFO_EMPTY,
output          mipi_dphy_rx_data0_DLY_RST,
output          mipi_dphy_rx_data0_DLY_INC,
output          mipi_dphy_rx_data0_DLY_ENA,

input   [7:0]   mipi_dphy_rx_data1_HS_IN,
input           mipi_dphy_rx_data1_LP_P_IN,
input           mipi_dphy_rx_data1_LP_N_IN,
output          mipi_dphy_rx_data1_RST,
output          mipi_dphy_rx_data1_HS_TERM,
output          mipi_dphy_rx_data1_HS_ENA,
output          mipi_dphy_rx_data1_FIFO_RD,
input           mipi_dphy_rx_data1_FIFO_EMPTY,
output          mipi_dphy_rx_data1_DLY_RST,
output          mipi_dphy_rx_data1_DLY_INC,
output          mipi_dphy_rx_data1_DLY_ENA,

input   [7:0]   mipi_dphy_rx_data2_HS_IN,
input           mipi_dphy_rx_data2_LP_P_IN,
input           mipi_dphy_rx_data2_LP_N_IN,
output          mipi_dphy_rx_data2_RST,
output          mipi_dphy_rx_data2_HS_TERM,
output          mipi_dphy_rx_data2_HS_ENA,
output          mipi_dphy_rx_data2_FIFO_RD,
input           mipi_dphy_rx_data2_FIFO_EMPTY,
output          mipi_dphy_rx_data2_DLY_RST,
output          mipi_dphy_rx_data2_DLY_INC,
output          mipi_dphy_rx_data2_DLY_ENA,
               
input   [7:0]   mipi_dphy_rx_data3_HS_IN,
input           mipi_dphy_rx_data3_LP_P_IN,
input           mipi_dphy_rx_data3_LP_N_IN,
output          mipi_dphy_rx_data3_RST,
output          mipi_dphy_rx_data3_HS_TERM,
output          mipi_dphy_rx_data3_HS_ENA,
output          mipi_dphy_rx_data3_FIFO_RD,
input           mipi_dphy_rx_data3_FIFO_EMPTY,
output          mipi_dphy_rx_data3_DLY_RST,
output          mipi_dphy_rx_data3_DLY_INC,
output          mipi_dphy_rx_data3_DLY_ENA,
                
input           mipi_dphy_tx_SLOWCLK,
output          mipi_dphy_tx_HS_enable_C,
output  [7:0]   mipi_dphy_tx_clk_HS_OUT,
output          mipi_dphy_tx_clk_RST,
output          mipi_dphy_tx_clk_LP_P_OE,
output          mipi_dphy_tx_clk_LP_P_OUT,
output          mipi_dphy_tx_clk_LP_N_OE,
output          mipi_dphy_tx_clk_LP_N_OUT,
                
input           mipi_dphy_tx_data0_LP_P_IN,
input           mipi_dphy_tx_data0_LP_N_IN,
                
output          mipi_dphy_tx_data0_HS_OE,
output  [7:0]   mipi_dphy_tx_data0_HS_OUT,
output          mipi_dphy_tx_data0_RST,
output          mipi_dphy_tx_data0_LP_N_OE,
output          mipi_dphy_tx_data0_LP_N_OUT,
output          mipi_dphy_tx_data0_LP_P_OE,
output          mipi_dphy_tx_data0_LP_P_OUT,
                
output          mipi_dphy_tx_data1_HS_OE,
output  [7:0]   mipi_dphy_tx_data1_HS_OUT,
output          mipi_dphy_tx_data1_RST,
output          mipi_dphy_tx_data1_LP_N_OE,
output          mipi_dphy_tx_data1_LP_N_OUT,
output          mipi_dphy_tx_data1_LP_P_OE,
output          mipi_dphy_tx_data1_LP_P_OUT,
                
output          mipi_dphy_tx_data2_HS_OE,
output  [7:0]   mipi_dphy_tx_data2_HS_OUT,
output          mipi_dphy_tx_data2_RST,
output          mipi_dphy_tx_data2_LP_N_OE,
output          mipi_dphy_tx_data2_LP_N_OUT,
output          mipi_dphy_tx_data2_LP_P_OE,
output          mipi_dphy_tx_data2_LP_P_OUT,
                
output          mipi_dphy_tx_data3_HS_OE,
output  [7:0]   mipi_dphy_tx_data3_HS_OUT,
output          mipi_dphy_tx_data3_RST,
output          mipi_dphy_tx_data3_LP_N_OE,
output          mipi_dphy_tx_data3_LP_N_OUT,
output          mipi_dphy_tx_data3_LP_P_OE,
output          mipi_dphy_tx_data3_LP_P_OUT
);

localparam tLPX_NS = 50;
localparam tINIT_NS = 100000;
localparam tLP_EXIT_NS = 100;
localparam tCLK_ZERO_NS = 400;
localparam tCLK_TRAIL_NS = 80;
localparam tCLK_PRE_NS = 10;
localparam tCLK_POST_NS = 455;
localparam tCLK_PREPARE_NS = 70;
localparam tCLK_TERM_EN_NS = 38;
localparam tHS_PREPARE_NS = 50;
localparam tWAKEUP_NS = 1000;
localparam tHS_EXIT_NS = 500;
localparam tHS_ZERO_NS = 262;
localparam tHS_TRAIL_NS = 1220; 
localparam tHS_SETTLE_NS = 85;
localparam tHS_PREPARE_ZERO_NS = 145;
localparam CLOCK_FREQ_MHZ = 100;
localparam NUM_DATA_LANE = 4;
localparam DPHY_CLOCK_MODE = "Continuous";
localparam tD_TERM_EN_NS = 35;
localparam AREGISTER = 8;
localparam ENABLE_USER_DESKEWCAL = 0;

localparam ST_IDLE       = 3'b000;
localparam ST_START_REQ  = 3'b001;
localparam ST_START_DATA = 3'b010;
localparam ST_END_DATA   = 3'b011;

localparam integer HS_BYTECLK_NS = 1000/(HS_BYTECLK_MHZ);   
localparam integer tHS_EXIT = ((tHS_EXIT_NS + HS_BYTECLK_NS-1) / HS_BYTECLK_NS); //min=100ns

logic mipi_clk_reset_n, mipi_dphy_rx_reset_byte_HS_n, mipi_dphy_tx_reset_byte_HS_n;

logic TxStopStateC;
logic [NUM_DATA_LANE-1:0] TxStopStateD;
logic TxReadyHSc, TxRequestHSc;
logic [NUM_DATA_LANE-1:0] TxRequestHS, TxReadyHS;
logic [7:0] TxDataHS_0, TxDataHS_1, TxDataHS_2, TxDataHS_3;
logic [NUM_DATA_LANE-1:0] RxValidHS, RxSyncHS;
logic [7:0] RxDataHS_0, RxDataHS_1, RxDataHS_2, RxDataHS_3;

logic [3:0] current_state, next_state;
logic [7:0] rx_data_cnt, tx_data_cnt, t_exitcnt;
logic pass, pass_1P, RxSyncHS_1P, RxSyncHS_2P;
logic [21:0] count_led;
logic [11:0] flash_cnt;
logic [17:0] init_cnt;
logic init_done;

localparam NUM_TRANS = 16;
localparam CLOCK_PERIOD_NS = 1000/(CLOCK_FREQ_MHZ);    // must be >= 40Mhz
localparam tINIT = ((tINIT_NS + CLOCK_PERIOD_NS-1) / CLOCK_PERIOD_NS); //min=100us

assign	mipi_dphy_tx_clk_RST	= 1'b0;
assign	mipi_dphy_tx_data0_RST	= 1'b0;
assign  mipi_dphy_rx_data0_RST   = 1'b0;
assign	mipi_dphy_tx_data1_RST	= 1'b0;
assign  mipi_dphy_rx_data1_RST   = 1'b0;
assign	mipi_dphy_tx_data2_RST	= 1'b0;
assign  mipi_dphy_rx_data2_RST   = 1'b0;
assign	mipi_dphy_tx_data3_RST	= 1'b0;
assign  mipi_dphy_rx_data3_RST   = 1'b0;

assign pll_rstn = 1'b1;
assign led[2] = count_led[21];
assign led[3] = flash_cnt[11];

always @ (posedge mipi_dphy_rx_clk_CLKOUT or negedge mipi_dphy_rx_reset_byte_HS_n) begin
    if (~mipi_dphy_rx_reset_byte_HS_n) begin
        count_led <= 22'h0;
    end
    else begin
        count_led <= count_led + 22'h1;
    end
end

always @ (posedge mipi_clk or negedge mipi_clk_reset_n) begin
    if (~mipi_clk_reset_n) begin
        init_cnt    <= 18'd0;
    end
    else if (init_cnt < tINIT) begin
    	init_cnt    <= init_cnt + 18'd1;
    end
end

assign init_done = (init_cnt == tINIT);

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

always @ (posedge mipi_dphy_rx_clk_CLKOUT or negedge mipi_dphy_rx_reset_byte_HS_n)
begin
    if(!mipi_dphy_rx_reset_byte_HS_n) begin
        t_exitcnt    <= 8'h0;
    end
    else if (current_state == ST_END_DATA && TxStopStateD == 4'hF) begin
        t_exitcnt    <= t_exitcnt + 8'h1;
    end
    else begin
        t_exitcnt    <= 8'h0;
    end
end

efx_dphy_bidir_tx dphy_tx_inst (
    .clk                (mipi_clk),
    .reset_n            (mipi_clk_reset_n),
    .clk_byte_HS        (mipi_dphy_tx_SLOWCLK),
    .reset_byte_HS_n    (mipi_dphy_tx_reset_byte_HS_n),
    .Tx_LP_CLK_P        (mipi_dphy_tx_clk_LP_P_OUT),
    .Tx_LP_CLK_P_OE     (mipi_dphy_tx_clk_LP_P_OE),
    .Tx_LP_CLK_N        (mipi_dphy_tx_clk_LP_N_OUT),
    .Tx_LP_CLK_N_OE     (mipi_dphy_tx_clk_LP_N_OE),
    .Tx_HS_enable_C     (mipi_dphy_tx_HS_enable_C),
    
    // ----- DLane 0 -----------
    // LVDS data lane
    .Tx_LP_D_P          ({mipi_dphy_tx_data3_LP_P_OUT, mipi_dphy_tx_data2_LP_P_OUT, mipi_dphy_tx_data1_LP_P_OUT, mipi_dphy_tx_data0_LP_P_OUT}),
    .Tx_LP_D_P_OE       ({mipi_dphy_tx_data3_LP_P_OE, mipi_dphy_tx_data2_LP_P_OE, mipi_dphy_tx_data1_LP_P_OE, mipi_dphy_tx_data0_LP_P_OE}),
    .Tx_LP_D_N          ({mipi_dphy_tx_data3_LP_N_OUT, mipi_dphy_tx_data2_LP_N_OUT, mipi_dphy_tx_data1_LP_N_OUT, mipi_dphy_tx_data0_LP_N_OUT}),
    .Tx_LP_D_N_OE       ({mipi_dphy_tx_data3_LP_N_OE, mipi_dphy_tx_data2_LP_N_OE, mipi_dphy_tx_data1_LP_N_OE, mipi_dphy_tx_data0_LP_N_OE}),
    .Tx_HS_D_0          (mipi_dphy_tx_data0_HS_OUT),
    .Tx_HS_D_1          (mipi_dphy_tx_data1_HS_OUT),
    .Tx_HS_D_2          (mipi_dphy_tx_data2_HS_OUT),
    .Tx_HS_D_3          (mipi_dphy_tx_data3_HS_OUT),
    .Tx_HS_D_4          (),
    .Tx_HS_D_5          (),
    .Tx_HS_D_6          (),
    .Tx_HS_D_7          (),
    .Tx_HS_enable_D     ({mipi_dphy_tx_data3_HS_OE, mipi_dphy_tx_data2_HS_OE, mipi_dphy_tx_data1_HS_OE, mipi_dphy_tx_data0_HS_OE}),
    
    //Bidir data lane
    .Rx_LP_D_P          (mipi_dphy_tx_data0_LP_P_IN),
    .Rx_LP_D_N          (mipi_dphy_tx_data0_LP_N_IN),
    //PPI clock lane
    .TxRequestHSc         (TxRequestHSc),
    .Tx_HS_C              (mipi_dphy_tx_clk_HS_OUT),
    .TxReadyHSc           (TxReadyHSc),
    .TxUlpsClk            (),   // Transmit Ultra Low power on clock lane
    .TxUlpsExitClk        (),
    .TxUlpsActiveClkNot   (),
    .TxStopStateC         (TxStopStateC),
    //PPI data lane       
    .TxRequestHS          (TxRequestHS),
    .TxDataHS_0           (TxDataHS_0),
    .TxDataHS_1           (TxDataHS_1),
    .TxDataHS_2           (TxDataHS_2),
    .TxDataHS_3           (TxDataHS_3),
    .TxDataHS_4           (0),
    .TxDataHS_5           (0),
    .TxDataHS_6           (0),
    .TxDataHS_7           (0),
    .TxReadyHS            (TxReadyHS),
    .TxSkewCalHS          (0),
    .TxRequestEsc         (0),
    .TxStopStateD         (TxStopStateD),
    .TxUlpsExit           (),
    .TxUlpsActiveNot      (),
    .TxUlpsEsc            (0),
    .TxLpdtEsc            (0),
    .TxValidEsc           (0),
    .TxDataEsc_0          (0),
    .TxDataEsc_1          (0),
    .TxDataEsc_2          (0),
    .TxDataEsc_3          (0),
    .TxDataEsc_4          (0),
    .TxDataEsc_5          (0),
    .TxDataEsc_6          (0),
    .TxDataEsc_7          (0),
    .TxReadyEsc           (),
    .TurnRequest          (0),
    .TurnRequest_done     (),
    .turnaround_timeout   (),
    .RxUlpsEsc            (),
    .RxUlpsActiveNot      (),
    .RxLPDTEsc            (),
    .RxDataEsc            (),
    .RxValidEsc           (),
    .RxTriggerEsc         (),
    .RxStopState          (),
    .ErrEsc               (),	
    .ErrControl           ()
);

efx_dphy_bidir_rx dphy_rx_inst (
    .reset_n              (mipi_clk_reset_n),
    .clk                  (mipi_clk),				
    .reset_byte_HS_n      (mipi_dphy_rx_reset_byte_HS_n),
    .clk_byte_HS          (mipi_dphy_rx_clk_CLKOUT),
    //To LVDS clock lane   
    .Rx_LP_CLK_P          (mipi_dphy_rx_clk_LP_P_IN), 
    .Rx_LP_CLK_N          (mipi_dphy_rx_clk_LP_N_IN),
    .Rx_HS_enable_C       (mipi_dphy_rx_clk_HS_ENA), 
    .LVDS_termen_C        (mipi_dphy_rx_clk_HS_TERM), 
    
    //ULPS clock
    .RxUlpsClkNot         (),
    .RxUlpsActiveClkNot   (),
    
    //To LVDS data lane 0
    .Rx_LP_D_P            ({mipi_dphy_rx_data3_LP_P_IN, mipi_dphy_rx_data2_LP_P_IN, mipi_dphy_rx_data1_LP_P_IN, mipi_dphy_rx_data0_LP_P_IN}),
    .Rx_LP_D_N            ({mipi_dphy_rx_data3_LP_N_IN, mipi_dphy_rx_data2_LP_N_IN, mipi_dphy_rx_data1_LP_N_IN, mipi_dphy_rx_data0_LP_N_IN}),
    .Rx_HS_D_0            (mipi_dphy_rx_data0_HS_IN),
    .Rx_HS_D_1            (mipi_dphy_rx_data1_HS_IN),
    .Rx_HS_D_2            (mipi_dphy_rx_data2_HS_IN),
    .Rx_HS_D_3            (mipi_dphy_rx_data3_HS_IN),
    .Rx_HS_D_4            (0),
    .Rx_HS_D_5            (0),
    .Rx_HS_D_6            (0),
    .Rx_HS_D_7            (0),
    .Rx_HS_enable_D       ({mipi_dphy_rx_data3_HS_ENA, mipi_dphy_rx_data2_HS_ENA, mipi_dphy_rx_data1_HS_ENA, mipi_dphy_rx_data0_HS_ENA}),
    .LVDS_termen_D        ({mipi_dphy_rx_data3_HS_TERM, mipi_dphy_rx_data2_HS_TERM, mipi_dphy_rx_data1_HS_TERM, mipi_dphy_rx_data0_HS_TERM}),
    .fifo_rd_enable       ({mipi_dphy_rx_data3_FIFO_RD, mipi_dphy_rx_data2_FIFO_RD, mipi_dphy_rx_data1_FIFO_RD, mipi_dphy_rx_data0_FIFO_RD}),
    .fifo_rd_empty        ({mipi_dphy_rx_data3_FIFO_EMPTY, mipi_dphy_rx_data2_FIFO_EMPTY, mipi_dphy_rx_data1_FIFO_EMPTY, mipi_dphy_rx_data0_FIFO_EMPTY}),
    .DLY_enable_D         ({mipi_dphy_rx_data3_DLY_ENA, mipi_dphy_rx_data2_DLY_ENA, mipi_dphy_rx_data1_DLY_ENA, mipi_dphy_rx_data0_DLY_ENA}),
    .DLY_inc_D            ({mipi_dphy_rx_data3_DLY_INC, mipi_dphy_rx_data2_DLY_INC, mipi_dphy_rx_data1_DLY_INC, mipi_dphy_rx_data0_DLY_INC}),
    .u_dly_enable_D       (0),
    .u_dly_inc_D          (0),	                     
    //To CSI2 lane 0      
    .RxUlpsEsc            (),
    .RxUlpsActiveNot      (),
    .RxErrEsc             (),
    .RxErrControl         (),
    .RxErrSotSyncHS       (),
    .RxDataHS_0           (RxDataHS_0), 
    .RxDataHS_1           (RxDataHS_1),
    .RxDataHS_2           (RxDataHS_2), 
    .RxDataHS_3           (RxDataHS_3),
    .RxDataHS_4           (), 
    .RxDataHS_5           (),
    .RxDataHS_6           (), 
    .RxDataHS_7           (),
    .RxValidHS            (RxValidHS), 
    .RxActiveHS           (),
    .RxSyncHS             (RxSyncHS),
    .RxSkewCalHS          (),
    .RxStopState          (),
    .RxLPDTEsc            (),
    .RxValidEsc           (),
    .RxDataEsc_0          (),
    .RxDataEsc_1          (),
    .RxDataEsc_2          (),
    .RxDataEsc_3          (),
    .RxDataEsc_4          (),
    .RxDataEsc_5          (),
    .RxDataEsc_6          (),
    .RxDataEsc_7          (),
    .Tx_LP_D_P            (mipi_dphy_rx_data0_LP_P_OUT),
    .Tx_LP_D_P_OE         (mipi_dphy_rx_data0_LP_P_OE),
    .Tx_LP_D_N            (mipi_dphy_rx_data0_LP_N_OUT),
    .Tx_LP_D_N_OE         (mipi_dphy_rx_data0_LP_N_OE),
    .TxRequestEsc         (),   
    .TxTriggerEsc         (),
    .TxUlpsEsc            (),       
    .TxUlpsExit           (),      
    .TxLpdtEsc            (),       
    .TxDataEsc            (),       
    .TxValidEsc           (),      
    .TxReadyEsc           (),      
    .TxStopState          (),     
    .TxUlpsActiveNot      (), 
    .TurnRequest          (),
    .TurnRequest_done     (),
    .turnaround_timeout   ()
);

/*------------ PPI RX interface ----------------------*/
always @ (posedge mipi_dphy_rx_clk_CLKOUT or negedge mipi_dphy_rx_reset_byte_HS_n)
begin
    if (~mipi_dphy_rx_reset_byte_HS_n) begin
        RxSyncHS_1P    <= 1'b0;
        RxSyncHS_2P    <= 1'b0;
        pass_1P        <= 1'b0;
    end
    else begin 
        RxSyncHS_1P    <= RxSyncHS;
        RxSyncHS_2P    <= RxSyncHS_1P;
        pass_1P        <= pass;
    end
end

always @ (posedge mipi_dphy_rx_clk_CLKOUT or negedge mipi_dphy_rx_reset_byte_HS_n)
begin
    if (~mipi_dphy_rx_reset_byte_HS_n) begin
        rx_data_cnt    <= 8'h0;
    end
    else if (&RxSyncHS_2P) begin
        rx_data_cnt    <= 8'h1;
    end
    else if (rx_data_cnt == NUM_TRANS) begin
        rx_data_cnt    <= 8'h0;
    end
    else if (rx_data_cnt > 0) begin
        rx_data_cnt    <= rx_data_cnt + 8'h1;    
    end
end

always @ (posedge mipi_dphy_rx_clk_CLKOUT or negedge mipi_dphy_rx_reset_byte_HS_n)
begin
    if (~mipi_dphy_rx_reset_byte_HS_n) begin
        pass    <= 1'b0;
    end
    else if (&RxValidHS && init_done) begin
        if (RxDataHS_0 != rx_data_cnt || RxDataHS_1 != (rx_data_cnt + 1) &&
            RxDataHS_2 != (rx_data_cnt + 2) || RxDataHS_3 != (rx_data_cnt + 3)) begin
            pass    <= 1'b0;
        end
        else begin
            pass    <= 1'b1;
        end
    end
end

always @(posedge mipi_dphy_rx_clk_CLKOUT or negedge mipi_dphy_rx_reset_byte_HS_n) 
begin
    if (~mipi_dphy_rx_reset_byte_HS_n) begin
        flash_cnt <= 12'b0;
    end
	else if (pass && ~pass_1P) begin
        flash_cnt <= flash_cnt + 1'b1;
    end
end

/*-----------------------------------------------------*/

always @ (posedge mipi_dphy_tx_SLOWCLK or negedge mipi_dphy_tx_reset_byte_HS_n)
begin
    if (~mipi_dphy_tx_reset_byte_HS_n) begin
        current_state    <= ST_IDLE;
    end
    else begin
        current_state    <= next_state;
    end
end

always @ (posedge mipi_dphy_tx_SLOWCLK or negedge mipi_dphy_tx_reset_byte_HS_n)
begin
    if (~mipi_dphy_tx_reset_byte_HS_n) begin
        tx_data_cnt <= 8'h0;
    end
    else if (TxReadyHS == 4'h0) begin
        tx_data_cnt <= 8'h0;
    end
    else if (tx_data_cnt == NUM_TRANS) begin
        tx_data_cnt <= 8'h0;
    end
    else if (TxReadyHS == 4'hF) begin
        tx_data_cnt <= tx_data_cnt + 8'h1;
    end
end

always @* begin
	next_state = current_state;
	TxRequestHSc = 4'h0;
	TxRequestHS = 4'h0;
	
	case(current_state)
        ST_IDLE : begin
            if (init_done && TxStopStateC) begin
                TxRequestHSc    = 4'hF;
                next_state      = ST_START_REQ;
            end
            else begin
                TxRequestHSc    = 4'h0;
                next_state      = ST_IDLE;
            end
        end
        
        ST_START_REQ : begin
            TxRequestHSc    = 4'hF;
            if (TxReadyHSc && TxStopStateD == 4'hF) begin
                TxRequestHS    = 4'hF;
                next_state     = ST_START_DATA;
            end
            else begin
                TxRequestHS    = 4'h0;
                next_state     = ST_START_REQ;
            end
        end
        
        ST_START_DATA : begin
            TxRequestHSc    = 4'hF;
            if (TxReadyHS == 4'hF) begin
                if (tx_data_cnt == NUM_TRANS) begin
                    TxRequestHS    = 4'h0;
                    next_state     = ST_END_DATA;
                end
                else begin
                    TxRequestHS    = 4'hF;
                    next_state     = ST_START_DATA;
                end
            end
            else begin
                TxRequestHS    = 4'hF;
                next_state     = ST_START_DATA;
            end
        end
        
        ST_END_DATA : begin
            TxRequestHSc    = 4'hF;
            TxRequestHS    = 4'h0;
            if (t_exitcnt == tHS_EXIT) begin
                next_state     = ST_START_REQ;
            end
            else begin
                next_state     = ST_END_DATA;
            end
        end
        
        default : begin next_state = ST_IDLE; end
    endcase
end

always @ (posedge mipi_dphy_tx_SLOWCLK or negedge mipi_dphy_tx_reset_byte_HS_n)
begin
	if(!mipi_dphy_tx_reset_byte_HS_n)begin
	    TxDataHS_0 <= 8'h0;
	    TxDataHS_1 <= 8'h0;
	    TxDataHS_2 <= 8'h0;
	    TxDataHS_3 <= 8'h0;
	end
	else begin
        case(current_state)
            ST_START_DATA : begin
	            TxDataHS_0 <= tx_data_cnt;
	            TxDataHS_1 <= tx_data_cnt + 1;
	            TxDataHS_2 <= tx_data_cnt + 2;
	            TxDataHS_3 <= tx_data_cnt + 3;
            end
            
			default : begin
	            TxDataHS_0 <= 8'h0;
	            TxDataHS_1 <= 8'h0;
	            TxDataHS_2 <= 8'h0;
	            TxDataHS_3 <= 8'h0;
			end
        endcase
    end
end
	
endmodule 