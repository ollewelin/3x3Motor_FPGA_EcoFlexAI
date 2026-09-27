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
`pragma protect key_keyowner = "Synopsys" , key_keyname = "SNPS-VCS-RSA-2"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 128 )
`pragma protect key_block
fTFMQtiI8dXQfrPGPq5KvfS50uLDEqIpHsRWx64t95W3GQ/CoDvKAyhUb1faP/Y3
DKwtqXvUuK9qYDKPG8HCv084PziezWgwL1l09gFQG340cL5KcEHwiTkQoQgJkyqF
4J+nClAP8aH5epG/NWjE61RKaImdUwXToU48C5QlnwM=
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 12848 )
`pragma protect data_block
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
`pragma protect end_protected

//pragma protect end
