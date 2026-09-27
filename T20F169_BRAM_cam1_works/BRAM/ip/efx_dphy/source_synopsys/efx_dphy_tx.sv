`timescale 1 ns / 1 ps
module `IP_MODULE_NAME(efx_dphy_tx) #(
    parameter tLPX_NS = 50,
    parameter tLP_EXIT_NS = 100,
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
    output logic       TxReadyHSc,
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
	output logic [NUM_DATA_LANE-1:0]      TxReadyEsc
);
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
MW8qq0BHpk7qH+MfCxHcAQLINBop8C/0+Z86/KNHeGmK6aQ+f9IN8xWCC2N6JP94
5hqDDvz/dGva5b0bcmO6UySs/7+PRe7XBOD1jK1an6h8et4hkoVQYeWxLQPxxdyf
vnUA1LhjABG+scZwl3tTBBsaoiMv5AaSqLuf+QqsO4Y=
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 6640 )
`pragma protect data_block
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
x73YludSlPVuWf6uyew2KQ==
`pragma protect end_protected

//pragma protect end
