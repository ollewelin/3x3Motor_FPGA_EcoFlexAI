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
vkHxfWEPgV83J3SvS3e/uUffUDv3Al09d8itufa/5P+Oy6kz6Zn+Ru6qfit9EQ3t
YMA6UE3YRSiP3vkEtBSpvvkvYQtHPWVrg1EhdTRcZdv9kfObODxK8fGoXOiMmFPd
wvpsD/vzNVrRxZ1Z2mvsYAufBq6fLxR1xut815AC4wgABt2EX6/gwf9pWd0qj33n
QFTpQ0ahNfH7F41W/DUPGvDa9Z5HiE+LUnl5FJP/wsdJG2v1Hj9s+E3PnsAdB5wb
rwOUhzOEvgK33kHFzCEkVQ6+4McD1NiEEVEe/Cnp/FrUsKerI8PYJm6t6w19phKq
9cZGULVUJinJmYcFeQ+xPg==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 12448 )
`pragma protect data_block
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
OnNQL3Spu9Aygm3uJt+usw==
`pragma protect end_protected

//pragma protect end
