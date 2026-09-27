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
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
A/AMk5tcac7YdvIb/2pC+p8OmiPHrLjsRLwy3LiPL0Ua5sDtH0bV5vFpd5lc2zzU
nWJK7Y/571c/2KDjWkw6tK6ZIniy7b2NQtd9mObJgub1/2mDfMIZQ8cMYo02R2ad
/QZ136rdRFFmHgP7DSJ7wLyFwayqnKRea5CzKx2z7+gosg+faYTWGGmO/DvQyb0f
Y4lXYYRS6M4gkyzKZLuBWtxVPSwr4ecJgnzIazLBnidAWN/BqTEjjQG6OwBJkdUD
DlvdB/+996gkuULCq2u2fBUcq3eQ80ULL8I/43R5STa9iP41oKfh8pwzv1Iq4Fhx
RYKYx44xmVWxrYSFeb6xlg==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 12448 )
`pragma protect data_block
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
1c2vvuZiLgK7MaIdDEr44A==
`pragma protect end_protected

//pragma protect end
