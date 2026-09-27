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
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
CKBHIz+69EpFlVE1Nx6lvrjDa/YflMrcDBDmef+1oopC1hBWq1wxsv+akxId43LU
DqWIky+qEUFeMOc3S2hdJ0RXnMqCg4s2VFp2QRVTXnMa3jgWderCEHYLaC6Wh3VN
BQRl5205ab0QDaVozErIl4ZJKtrCRRF2p6ZrDFL51n3YSD77NfMHXz25eIzLeLPz
hwZd1JgwU3kauERwET37m/uVN6iQrbv56IsjdnR5CTJ4VrL9Lq+o2TgdNtRk3VbZ
ST6W3pwzoG45k5VLVlGQVyD85eagD4pIZrkDLu+3rmFKpknJjy883G41QiNdm+pf
8iZcIqMqfM5VkV+sTNgIXA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 6640 )
`pragma protect data_block
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
osK6rKqPqTzm/XIyW2KLYQ==
`pragma protect end_protected

//pragma protect end
