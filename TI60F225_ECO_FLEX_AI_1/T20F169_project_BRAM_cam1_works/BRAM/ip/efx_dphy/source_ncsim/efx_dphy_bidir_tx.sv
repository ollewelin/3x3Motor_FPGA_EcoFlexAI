`timescale 1 ns / 1 ps
module `IP_MODULE_NAME(efx_dphy_bidir_tx) #(
    parameter tLPX_NS = 50,
    parameter tLP_EXIT_NS = 100,
    parameter BTA_TIMEOUT_NS = 100000,
    parameter tD_TERM_EN_NS = 35, 
    parameter tHS_PREPARE_ZERO_NS = 145, 
    parameter tCLK_ZERO_NS = 262,
    parameter tCLK_TRAIL_NS = 60,
    parameter tCLK_PRE_NS = 10,
    parameter tCLK_POST_NS = 60,
    parameter tCLK_PREPARE_NS = 38,
    parameter tHS_PREPARE_NS = 40,
    parameter tWAKEUP_NS = 1000,
    parameter tHS_EXIT_NS = 100,
    parameter tHS_ZERO_NS = 105,
    parameter tHS_TRAIL_NS = 60,
    parameter HS_BYTECLK_MHZ = 187,
    parameter CLOCK_FREQ_MHZ = 100,
    parameter NUM_DATA_LANE = 4,
    parameter ENABLE_BIDIR = 1,
    parameter DPHY_CLOCK_MODE = "Continuous"
)(
    input  logic       clk,
    input  logic       reset_n,
    input  logic       clk_byte_HS, 
	input  logic       reset_byte_HS_n,
	output logic       Tx_LP_CLK_P,
	output logic       Tx_LP_CLK_P_OE,
	output logic       Tx_LP_CLK_N,
	output logic       Tx_LP_CLK_N_OE,
	output logic       Tx_HS_enable_C,
	input  logic       TxRequestHSc,
	output logic [7:0] Tx_HS_C,
    output  logic      TxReadyHSc,
	input  logic       TxUlpsClk,   
	input  logic       TxUlpsExitClk,   
	output logic       TxUlpsActiveClkNot,
	output logic       TxStopStateC,
    output logic [NUM_DATA_LANE-1:0]      Tx_LP_D_P,
    output logic [NUM_DATA_LANE-1:0]      Tx_LP_D_P_OE,
    output logic [NUM_DATA_LANE-1:0]      Tx_LP_D_N,
    output logic [NUM_DATA_LANE-1:0]      Tx_LP_D_N_OE,
	output logic [7:0]                    Tx_HS_D_0,
	output logic [7:0]                    Tx_HS_D_1,
	output logic [7:0]                    Tx_HS_D_2,
	output logic [7:0]                    Tx_HS_D_3,
	output logic [7:0]                    Tx_HS_D_4,
	output logic [7:0]                    Tx_HS_D_5,
	output logic [7:0]                    Tx_HS_D_6,
	output logic [7:0]                    Tx_HS_D_7,
    output logic [NUM_DATA_LANE-1:0]      Tx_HS_enable_D,
    input  logic                          Rx_LP_D_P,
    input  logic                          Rx_LP_D_N,
    input  logic [NUM_DATA_LANE-1:0]      TxRequestHS,
	input  logic [7:0]                    TxDataHS_0,
	input  logic [7:0]                    TxDataHS_1,
	input  logic [7:0]                    TxDataHS_2,
	input  logic [7:0]                    TxDataHS_3,
	input  logic [7:0]                    TxDataHS_4,
	input  logic [7:0]                    TxDataHS_5,
	input  logic [7:0]                    TxDataHS_6,
	input  logic [7:0]                    TxDataHS_7,
    output logic [NUM_DATA_LANE-1:0]      TxReadyHS,
    input  logic [NUM_DATA_LANE-1:0]      TxSkewCalHS,
    input  logic [NUM_DATA_LANE-1:0]      TxRequestEsc, 
    input  logic [3:0]                    TxTriggerEsc, 
    output logic [NUM_DATA_LANE-1:0]      TxStopStateD,
    input  logic [NUM_DATA_LANE-1:0]      TxUlpsExit,   
    output logic [NUM_DATA_LANE-1:0]      TxUlpsActiveNot,
    input  logic [NUM_DATA_LANE-1:0]      TxUlpsEsc,   
    input  logic [NUM_DATA_LANE-1:0]      TxLpdtEsc,
    input  logic [NUM_DATA_LANE-1:0]      TxValidEsc,
	input  logic [7:0]                    TxDataEsc_0,
	input  logic [7:0]                    TxDataEsc_1,
	input  logic [7:0]                    TxDataEsc_2,
	input  logic [7:0]                    TxDataEsc_3,
	input  logic [7:0]                    TxDataEsc_4,
	input  logic [7:0]                    TxDataEsc_5,
	input  logic [7:0]                    TxDataEsc_6,
	input  logic [7:0]                    TxDataEsc_7,
    output logic [NUM_DATA_LANE-1:0]      TxReadyEsc,
    input  logic       TurnRequest,
    output logic       TurnRequest_done,
    output logic       turnaround_timeout,
    output logic       RxUlpsEsc,
    output logic       RxUlpsActiveNot,
    output logic       RxLPDTEsc,
    output logic [7:0] RxDataEsc,
    output logic       RxValidEsc,
    output logic [3:0] RxTriggerEsc,
    output logic       RxStopState,
    output logic       ErrEsc,
    output logic       ErrControl
);
genvar i;
//pragma protect begin_protected
//pragma protect key_keyowner=Cadence Design Systems.
//pragma protect key_keyname=CDS_KEY
//pragma protect key_method=RC5
//pragma protect key_block
dW5ykLnS1N9r+Ccd7R+85tl4GwQ00Z0xUv6adiToLT5AV//n5V2iFTn0yh1Ghlfw
qoYJnP1KkK/l8blzlRjRDH6I8G/DLO8rcJ5uRg7h4qnoBBCCHD0yH/51gIC1AAwR
CVGjygrz+S7jJDD7/PmVP98ZM/ADF1aLV013kWZhUiVyFFja7ueHaQ==
//pragma protect end_key_block
//pragma protect digest_block
mp2LCXBz53MvfNNxU7wulBDYDbY=
//pragma protect end_digest_block
//pragma protect data_block
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

//pragma protect end_data_block
//pragma protect digest_block
9LPz6JJaI16c4NGyaaL88ZW6SLM=
//pragma protect end_digest_block
//pragma protect end_protected
