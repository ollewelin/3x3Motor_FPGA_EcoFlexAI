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
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2021.1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
kdy0JcYRd9mBjeKGsQvc+rtk3k3/bDmyyVKwOgde0A3FFg5xhbaI235+4ISB/1S2
wOUV6k4jzS1DXEODK96NJJEkSZ+sCakMzF2b+WE4kuRQhIq/hKKi6A5Q7lwlQO4Y
qsJ+jsG7vq52bGHHh1Gx6SMXMI3u0bTi6AYCvU8vZT7bqk7v5qNOkwxPIniY9mXZ
Mg1n1J+FJfQfdCUGKhbyMq7Rvw3IOLy/YrM0kDA7WFcaptxeZniZ3RxsT67325oT
zk/y25DeA51yMl4Th8OHtYvr/m90Cw/BfsONdJh16jKdeZJS85iabN0uI+T7E3iv
uXKV5Hpt+5geuHgFjef8VA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 12848 )
`pragma protect data_block
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
`pragma protect end_protected

//pragma protect end
