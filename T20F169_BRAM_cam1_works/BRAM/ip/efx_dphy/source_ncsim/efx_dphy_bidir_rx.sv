`timescale 1 ns / 1 ps
module `IP_MODULE_NAME(efx_dphy_bidir_rx) #(
    parameter tLPX_NS = 50,
    parameter tCLK_TERM_EN_NS = 38,
    parameter tD_TERM_EN_NS = 35,
    parameter tHS_SETTLE_NS = 85,
    parameter tHS_PREPARE_ZERO_NS = 145,
    parameter HS_BYTECLK_MHZ = 187,
    parameter CLOCK_FREQ_MHZ = 100,
    parameter NUM_DATA_LANE = 4,
    parameter ENABLE_USER_DESKEWCAL = 0,
    parameter DPHY_CLOCK_MODE = "Continuous",
    parameter ENABLE_BIDIR = 1,
    parameter tLP_EXIT_NS = 100,
    parameter BTA_TIMEOUT_NS = 100000,
    parameter tHS_PREPARE_NS = 40,
    parameter tWAKEUP_NS = 1000,
    parameter tHS_EXIT_NS = 100,
    parameter tHS_ZERO_NS = 105,
    parameter tHS_TRAIL_NS = 60,
    parameter RXSTOPSTATE_L2H_DLY = 0
)(
    input logic        reset_n,
    input logic        clk,
    input logic        reset_byte_HS_n,
    input logic        clk_byte_HS,
    input logic        Rx_LP_CLK_P,
    input logic        Rx_LP_CLK_N,
    output logic       Rx_HS_enable_C,
    output logic       LVDS_termen_C,
    output logic       RxUlpsClkNot,  
    output logic       RxUlpsActiveClkNot,
    input  logic [NUM_DATA_LANE-1:0]      Rx_LP_D_P,
    input  logic [NUM_DATA_LANE-1:0]      Rx_LP_D_N,
    input logic  [7:0]                    Rx_HS_D_0,
    input logic  [7:0]                    Rx_HS_D_1,
    input logic  [7:0]                    Rx_HS_D_2,
    input logic  [7:0]                    Rx_HS_D_3,
    input logic  [7:0]                    Rx_HS_D_4,
    input logic  [7:0]                    Rx_HS_D_5,
    input logic  [7:0]                    Rx_HS_D_6,
    input logic  [7:0]                    Rx_HS_D_7,
    output logic [NUM_DATA_LANE-1:0]      Rx_HS_enable_D,
    output logic [NUM_DATA_LANE-1:0]      LVDS_termen_D,
    output logic [NUM_DATA_LANE-1:0]      fifo_rd_enable,
    input  logic [NUM_DATA_LANE-1:0]      fifo_rd_empty,
    output logic [NUM_DATA_LANE-1:0]      DLY_enable_D,
    output logic [NUM_DATA_LANE-1:0]      DLY_inc_D,
    input  logic [NUM_DATA_LANE-1:0]      u_dly_enable_D, 
    input  logic [NUM_DATA_LANE-1:0]      u_dly_inc_D, 
    output logic [NUM_DATA_LANE-1:0]      RxUlpsEsc,
    output logic [NUM_DATA_LANE-1:0]      RxUlpsActiveNot,
    output logic [NUM_DATA_LANE-1:0]      RxLPDTEsc,
    output logic [NUM_DATA_LANE-1:0]      RxValidEsc,
	output logic [7:0]                    RxDataEsc_0,
	output logic [7:0]                    RxDataEsc_1,
	output logic [7:0]                    RxDataEsc_2,
	output logic [7:0]                    RxDataEsc_3,
	output logic [7:0]                    RxDataEsc_4,
	output logic [7:0]                    RxDataEsc_5,
	output logic [7:0]                    RxDataEsc_6,
	output logic [7:0]                    RxDataEsc_7,
    output logic [3:0]                    RxTriggerEsc,
    output logic [NUM_DATA_LANE-1:0]      RxErrEsc,
    output logic [NUM_DATA_LANE-1:0]      RxErrControl,
    output logic [NUM_DATA_LANE-1:0]      RxErrSotSyncHS,
	output logic [7:0]                    RxDataHS_0,
	output logic [7:0]                    RxDataHS_1,
	output logic [7:0]                    RxDataHS_2,
	output logic [7:0]                    RxDataHS_3,
	output logic [7:0]                    RxDataHS_4,
	output logic [7:0]                    RxDataHS_5,
	output logic [7:0]                    RxDataHS_6,
	output logic [7:0]                    RxDataHS_7,
    output logic [NUM_DATA_LANE-1:0]      RxValidHS,
    output logic [NUM_DATA_LANE-1:0]      RxActiveHS,
    output logic [NUM_DATA_LANE-1:0]      RxSyncHS,
    output logic [NUM_DATA_LANE-1:0]      RxSkewCalHS,
    output logic [NUM_DATA_LANE-1:0]      RxStopState,
    output logic       Tx_LP_D_P,
    output logic       Tx_LP_D_P_OE,
    output logic       Tx_LP_D_N,
    output logic       Tx_LP_D_N_OE,
    input  logic       TxRequestEsc,
    input  logic [3:0] TxTriggerEsc, 
    input  logic       TxUlpsEsc,
    input  logic       TxUlpsExit,
    input  logic       TxLpdtEsc,
    input  logic [7:0] TxDataEsc,
    input  logic       TxValidEsc,
    output logic       TxReadyEsc,
    output logic       TxStopState,
    output logic       TxUlpsActiveNot,
    input  logic       TurnRequest,
    output logic       TurnRequest_done,
    output logic       turnaround_timeout
);
genvar i;
//pragma protect begin_protected
//pragma protect key_keyowner=Cadence Design Systems.
//pragma protect key_keyname=CDS_KEY
//pragma protect key_method=RC5
//pragma protect key_block
ll+myYUwY4isMrq/uhUOxZCOb4TR/QMBsaElgT4ilfD0Lo5W2aNZIPb4bfkxg9iW
DZ+dWOKWrNyiPeLBpaw6SsrrqF0mO1YC+u3z3hmdH3uAjHk2/SKltFXJdHfqaAlx
osb8VNPYPixnhw5zdZ+t5qzPuQCokWp0y1lICdm8V5NV+JbsOGAlKg==
//pragma protect end_key_block
//pragma protect digest_block
T4FozY94ce6uwfdl8L/unEymsLs=
//pragma protect end_digest_block
//pragma protect data_block
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
//pragma protect end_data_block
//pragma protect digest_block
wmWFP2GVGWgn/l2i8SImzh0oDsY=
//pragma protect end_digest_block
//pragma protect end_protected
