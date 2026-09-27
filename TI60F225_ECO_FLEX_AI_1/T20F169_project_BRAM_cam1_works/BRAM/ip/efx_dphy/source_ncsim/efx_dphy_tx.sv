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
//pragma protect begin_protected
//pragma protect key_keyowner=Cadence Design Systems.
//pragma protect key_keyname=CDS_KEY
//pragma protect key_method=RC5
//pragma protect key_block
vskFPxUQDNkxXf5iLBRMgaidu3AI/5W88FKx+fDWcYlyZ18SfJq8FMGgc6i20XlX
EjQ1smk7vbUltHiwzpdlB/8aP/OJNUAcuTMYjbs7YL/8u7f8TlFtwAuAsSHdD5W2
ESEHNTVPXFr7uCJ4yJ1l4LseSOXe19AqJ+kUs6yB25U2UXRCbzjekw==
//pragma protect end_key_block
//pragma protect digest_block
Ry3Kry11HmfpddlM1hV8/Ub/lvQ=
//pragma protect end_digest_block
//pragma protect data_block
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
//pragma protect end_data_block
//pragma protect digest_block
zXO7y9Q7l5j3FCCjd0CYEDGUhZs=
//pragma protect end_digest_block
//pragma protect end_protected
