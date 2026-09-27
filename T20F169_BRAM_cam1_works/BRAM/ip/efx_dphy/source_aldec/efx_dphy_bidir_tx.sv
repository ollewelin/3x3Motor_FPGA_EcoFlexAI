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
`pragma protect key_keyowner = "Aldec" , key_keyname = "ALDEC15_001"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
YC3WVmDf4aMQ6rXipoADCEa9/5XEULpiuBdv1ZFZraQIe2nv8SmejDt6ddsUfVtY
P7sxb3rZ+GBDFwCD9DnyQ9alXU5Vd70HvbNuoEQwX5p4YxIclG1gYFAYYY1PYuGg
d2m3pkc7BgDb00TDvsYrVQmFApNEAU9hyV0oRKFJuENF2JCav1iXc9ZLIY4PCIzn
cjBB/5JIIkv55WTYFa0lKT1kbbTVNmX30uqbGAcobmc5lC+oCT3xZ+m4GTv95zxf
ccneHctiRLoQ1PIx9hp/irLWrLpkdzC4xCil/0IHcwBwVAlHmkVJpbkedmDKcqbG
oYGkh1HNF1l3uFKCDtJv5A==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 12848 )
`pragma protect data_block
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
`pragma protect end_protected

//pragma protect end
