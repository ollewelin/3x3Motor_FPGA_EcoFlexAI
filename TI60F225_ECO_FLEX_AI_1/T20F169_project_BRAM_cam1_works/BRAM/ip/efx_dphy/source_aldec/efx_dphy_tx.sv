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
`pragma protect key_keyowner = "Aldec" , key_keyname = "ALDEC15_001"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
AyrwNSQU12foHC7je9Krd2mjTHsbULkq8DGahUfuAnYj2lQys2LMniowxicNYmtm
F8cAUIJY6CHTVSA9kGWXdqNRgrwDNezFkhwHNe3xqFHwrUtjzHttO8xTH/VpvGHj
t8Ao4XejlZtMKuWKXXTaAqA/3E4gIE0plp6j1sCfJs5d8Rfji88nYvBSHMOSwBt+
/qG1SL4N/bL/O6ALbeA+J81lvwsfVKrKTHSdQEJA4WO6VmTAw8X8kzQCx6/69HxN
xkjK8NAHIsKpx6hQ219GnHIAqsShyTp+e3WqynuvqBGAXplNPDsu5E/RQluSL9o2
/POHXGyfp/51iJeSRooy5A==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 6640 )
`pragma protect data_block
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
m1QyF5+BJlJU38N+yXU+bg==
`pragma protect end_protected

//pragma protect end
