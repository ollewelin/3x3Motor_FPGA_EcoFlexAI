`define IP_UUID _dphybidirtx250413                                 
`define IP_NAME_CONCAT(a,b) a``b                                
`define IP_MODULE_NAME(name) `IP_NAME_CONCAT(name,`IP_UUID)     
//////////////////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      Top IP Module = efx_dphy_bidir_tx
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***************************************************************************************
// Vesion  : 1.00
// Time    : Sun Apr 13 00:12:22 2025
// ***************************************************************************************

`timescale 1 ns / 1 ps
module efx_dphy_bidir_tx #(
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
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
oFkALlDIV8Tu/gmJ4XDFvTRDTkaGc6pgF9/bqhRNnhGrq+YwE8uTKKuQcPzJfBP8
B1CZduXHssI/Kau0znBj/l+WniXp+7ydJZfL4D/pzIIA4br/ZgUv19SoLRSnUIB7
ZC0f5mEWCti8pq1R9/sK5vZeEOaaO11FGfFT4/yjSRYRj13rBiaeJj+j76ZXxtN3
bswgybyt9qn44t5v2o97E4syVLOEWx1GKUs+/EOSB02zVYTAt7Rz2XTj4cEbWPho
emWvUCMl2bDYBKMrrLISR89Q+FQT0uLGWjoDw06KnVDRTamBm8uuH5SJh8g4q19v
DoLsb9EK4B6cSj2rcwLD5Q==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 12848 )
`pragma protect data_block
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
`pragma protect end_protected

//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
eo1D+uxBe3yy3aKJfDoahRCtn1J+JAL3i2PPrxR2FNGU8GbH4/q5o1U5EBCsw8D2
CQL5HXpVP/HhzTC1DWXf+oCep+cOP7bb9QN1cKm1pmSWRt2xe86yiJ5qeOoOkkkL
UHrVc2EJoT1VHDcHBLASubFp1zre1hGug0RshaKYGoEF4Tf3lpu+p0dAHdMAfu1P
d1EiuxMtxCnTffQrkjZvoADPUMKvrlaD3aj8oXAtQTR0RmvUbOtvP5wFYw23gByU
NIO/bUEurRPFYWBUOgs6U9ekbQFyEsmHlYqRxtvzqohJOWMfdkFanTM5zLD2RDx0
AUk/1sVqgrlHSvttGkLotw==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 18816 )
`pragma protect data_block
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
`pragma protect end_protected

//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
azcPSr6LFiE4gn0EiEGQybuprAcgf1EXSrsKxcIqC9NJwDCmjmxoH2O4zmx/Ep4A
Oa5rXtLRHmHq0lyFF7jZDR5139Hu8sszfrJKYAnL8KjSMYdxGkNxlPS1/pogM7ua
In/2PP1BQzLl/LqODvkd1jG0K6guzLsp9hgPUGDn7WL03Rf6z+LyuAmUxYeNp8rp
KKh4R7rGtFMP24TaM30NsXsS3hVqzELDZi5v7QdtcAGw9+kwtWpTqVcNyOfmgnrb
9thLcPtJOz0YGF/zQ0AVhSxGBl5hrL95bJJu2cjhF7DlygYeKUhWU6dDO70jo/Sf
u9KMiUyIGQDrfRKm0in8ZQ==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 26720 )
`pragma protect data_block
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
`pragma protect end_protected

//pragma protect end
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
fsx17FmZuEUsFZIoqxhirUeCRLyio1sZY0uZ4CzYx0Jbc36iu/e3gdpeD0iu2Na/
3IZoHovYSom5hoqDF4ooIDbWp9DmTUZRXlqNckX+UbcaYn4+vN8IXleU8zJWbPKg
C9W4kPrb/9Vvb5JayzmsOtbyILT228ZZN7M246KxijvUPBknZAM1mWgYGcPb4Sdz
khxn61NJ0FuF0zZoNJF+wqPKMR33czQWLBe6D9H49+z/S/lHh6cnF4jtF0sBVJoL
F1DNyA5Tqxi5uEdNa2+UMNx/3SrxdHe1m03yPDByNMN/qxWD4oyTHU/rMEUX26tf
VIp9yDZTEZLEtX6XalmQ8Q==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 6336 )
`pragma protect data_block
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
`pragma protect end_protected

//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
NuwiC5RElEk+657SFXrX/J4z9fWbGLyoeQkr0O84fHjaPK+t4pT6gXlemmIGDaDA
xmPJ8sdcaILes9zvTT2CF+IanG8VTKV2CPMy0WqTpPeNmGAxUIQRkDUTRu1+bG7E
JHAafQ6fXg0fV3C5w/JxR2BZ7GkLBAYuR5GoCwrDja9hsCvT3PLTws52vK0wQlUC
VDxTCoj2V2z/YMsQ6o60D2URdOk1x+zcbJH4IdGOkuOyGHH7ZQKg/xAc2BnmCdmY
dDFMLQeYGV9nAq7BaRtQSJreIkm9Zw7Hc1CjSLGXcYDFTvusj6UkU6+70ewY1ZDX
HCxzYJ6Tjm/aOhXgDY92lQ==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 832 )
`pragma protect data_block
BtOO4BhdXfrqg9IRtm2eSkEMLU3fnx4XKz4uwPxZReVuaC4xATU02J2r1sm/DFsr
JpabawAt7ZOLp303l/iCh+5WOg2rtcrEsvOv2wCyWKhPkqYyw8gdReXpGyLFJApj
hq6aPLHOo6X7WpiawXSPgT6lnVJfdtxBjSI6+6+vGYPpE8uEYsZFFuNJ6DBX5ne2
opphrJ48WtSjA9W1q8Ay9GlOI6zOnsm5VMSauRj20nZWvPRwZAXoUR9uc0GbcHN7
mlTNQXSENWASglzRx7aRj+BIv5jWVeGFW+ciaSv8xwJuKUrwzWof82H7Fi6GIUJS
BYSx1gtIpUBQ4MLj4pRoXTn8MaE/RWb7vs3sV3zs5NTylRcVsTWlMpd9tAofu+66
KNyX4O/cFO5/4MfySiNQ6g1Xy6xZm8gHesWRoVR6L8ow2L07K1TUSoIobsaMmeFD
8LwM9OshMNQ42uKYf3kGm/msw5eoOfqSC6f00MOJjJOFWN7QZ/pFwRe/Nyuy1yl1
JBa93sXYZlVtjNPEKjwITVKG1rZkxGtisUyBLtfTqAaWjlP6JcLKwL1/8q3ayzgw
tucnrUZaUSxgBFDrA7DJN+R6y7zqTcAMe/m1uMuPNRIj2XwpowNZyX8megdWXH1c
W+WfM9wEv3YxPd+wHwHE0tsPHOqdPMhkTW7qfIv5lMsbVTcZBwMYg4GJpsUGnm2n
XaGkjoGMovg2M/5nFXVEG4doggT2HsmgS1x9Tq7ndmx10cCM68oe435D9O60jCpP
eC3jCJPqKDr4h309KyGmZRgSTOl0uymS8QfMMUYUM/yaL5Lbl37XqVcsA8RvYLP5
rhNYkeyW/mqreREAIv8cWjMH/Q73UCYFOy6gRfbJ7EzH6jNLAMOFsyWI0Wz0g1cF
Aj//oMeJBJP3WmCXfmKwe8k51RPR6VivAJzSSiNPnPEYOZ9Riemcy/8h0Q1lkq90
hBzVbx+eJpR1pcL1gy4jqYyGbsiPc9mmE6ggjpUlyiDiWso9Q7/fgv1Wa5rMMHAq
kvnUL5ob5i9egfy+yETtiTP1vNYszGxzac4w0cemvQhQDWD1xdqNb9OiFerCCQZo
XMXSY6r3P9ljRM1gVXnXPA==
`pragma protect end_protected

//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
Ie6wmsJZ4tSnd5S/XquJnrO0PJDQSoaQ97E2ecLtv4filM42uDj8OOIDYfFHvfEA
wJbLhhfHFY0calywHH78lBP2hygpW89MmjoJduqyC1+iBXdbiMaA4aBo+fV7Vb/W
/FEPE2GQ/CZn8eWqIuiH2C+goK1EsXmzJCpn0BgZnVgNdGWmM/Reiwg4rA49qxCK
bSHlMxEaNir3ea1A4cU3ATezqKVGX2R3JIfGPLbx5jBGBMp+cKgA9KIuJ96cy2YJ
m2AcS38VgLIOiFCzWep5iCywNStbosOIJ+o26PYJoM7/iDCONjxKY+thfaMsOE4U
XMnf6Q0iT2H5y4SqphYq7g==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 14000 )
`pragma protect data_block
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
`pragma protect end_protected

//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
hR1IGLMYd4JtvX1L8V5toBEOmQ9Fl1RFgkGHvtg2TNQqYieu1Fv3+PSM/M+peke7
c4g3INErI922JAQZY9Z2+bL7ir7rnS/E6HpUxnxYJTe6XOfIzbNRwCWGHQtky08a
esBP0W7ZWBMieZZg3Iuz1Pzp3vPMCTDJSzPsv3H/AgVH4FPa7KTGUxzYh3gem6Rf
TOTpZugE1N99/IIVpOF1ku1f541MF51U/DqrvdKAR590z8Zrj+0kxUngn2D1UheP
tfkd4ghKYsVAfexiLTbWaw2XDHaMk09LtE/e/UYViL9IMEa/kTAWDgwoJfYUqCku
kmG89hokv8q0W/fHPPyPXw==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 8800 )
`pragma protect data_block
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
1Qj12PoXkZja+30jram6kw==
`pragma protect end_protected

//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
FNsSZs+V8EIsgszm5HazKVdw81ne/Yf5u4OqqIgKf0Fh+MJOVSo78EXJmprAcJl5
mzAiO4RqS+x/A9b4rn+kchOJk7usU+mUFbGk/O3ky4mgtSc+py9zXpJNOT2jAYcK
uIP/s2TjAJxx8OuS9WYZg0gcAmNPykjUAoiv2GqVxf9PbvPbqyAvsBSTG3xeKbSl
s0HH0zLFqZ6xU6pSkvlCmJW8IRPu5fxj1ZEx6n3lFGpDdLHSR4bljKddG56mG2k8
v3iPVBAwmMYF+j42LfJa620sfJYYMsUw9ukwpWDyF4lx3ft74eMqcYJa/cNSD/z6
+pByeuTx9ADypAUpOoeQaw==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 7408 )
`pragma protect data_block
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
qK9GdbXihG2M5yHOEKjKgQ==
`pragma protect end_protected

//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
HaVyL9HA/3bvnbzyb2C2ErPV5X7gnUTU5lX0Y/qx5rlPVce8cMBl9RVcFs0KbSJ0
82y2iCiRroUi2VgexikMf+xRiJy4Jg3lBBNH2ll1n/s8FM1AhevOMfhHN50tClSd
aZXLd7Cu5MLBiBVBUApdMx3mNqrPPhvvowe/4AruVKmZJdvwT19jSpwbwWe06SDJ
8P0v1nLrw6kmPcGbddokl9Gvkz2H+B0sxR4msX/ohKFnrNyBVN3co34l5Xoqr0TC
0ydm+i075xZq0D3MBN9MJEcTFQlmW4likQpatmHIvbVu3opUgNq1mSFoztUxwU9J
XJJOUVtuHMKFI8i80QnFrQ==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 15952 )
`pragma protect data_block
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
yYX+8To6BNwl7E2Ba8kGAg==
`pragma protect end_protected

//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
fZ7SQpNbbDBa/CRIM7iY1TmT0AQlfbAqEJTsV/8PU9SBeZLUgXYe0UXbupvwZTBO
3krxWf0WBUQUgCibphoDadQznRKFJZJ9miwEn47ef9ucIRQwPn0HTA7tuiimbkkJ
m+ay+nYDNrK4hpx45jX8Xpih3nqaN+5/ZakkxOcj6oeTpdfr0Sy4KWWKZkibH1Iw
mXWWcbZmjQBl7yfrZ3M9XfZSyugxax1s2qVq3jGBnmr0FytJ4TMh8up85ObgAJGV
VhdyXWzGz9Op1pN6SlJbKKl3tDkRI4O6dJxyeQzkZTK6yNlyCt5JXCPXrJ6gttIu
GzRQwYvhhRk9BbJtqTHrWg==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 5616 )
`pragma protect data_block
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
`pragma protect end_protected

//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
KFf7Zp7NQ3VKHj9GTDOOVcOuqK0Gaq3Q4FyzhTHPc/F0F4LFRdXNA3eh6OR2/kfj
YempDXGPDgme+3it5TM1LxrX2GVvMoXjEfe+c6jte0KwGQFu9/VXHecSMMckrOpi
aMR6T7nqVEeQHlRq63s23j0OMDraiWGTAVxVz1RAaMDH/QlTXtnjHwVzgj5htRyD
rbxVOAojcotyhJU6lGYW/4sF9GZX/s6Sj2tMTTdcATlYl+RVotIZNNoZwB9FBeIw
9xKaozeAzI/QfzuC2K1BhSWTuVy9laxzhN+rBgSg6g2jdzLHbkX5cmRtYqZCtvTx
nhqNzR0P9QHJch5Sk/KSTA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 6160 )
`pragma protect data_block
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
ZngJjxg2KrKLI2bvoq6j7A==
`pragma protect end_protected

//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
jmJ2ulgyRVEbBNZ9cAaX7ObpQqhkDvNOXBHkKhcmJUBRlFGmLZyz736MikplF0K+
hPVsYSJSfbxfDap8mkNEosSOc9VLg+4IS7XPeKL8SIS+vm+10bBNUaTStaFrx9VR
LFNh+I0Mx6cdiF5Nkcakxm6JJcguq6FrC54y12/CSdKgxiMd/eJOmkkNlB3y8wd1
Jvb71oBB39LX6QRERjnqJcY5u48YMKxFl7m311tuqcmhpnhXKx02FvG2c0AgNURZ
ua0smnbtDi5XPnmlMth//KyRHtciiYrjMViBizaMvZaGfsBH+G7GP9zy0Bey0mfc
Yr2/6SzIOGHA960ysZEPSQ==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 3328 )
`pragma protect data_block
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
5XjATNdzBftXBH5je47bTA==
`pragma protect end_protected

//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
JFeDc9LyZ9d42zpSb4osVZZJW6s7BzPSkARRo3ZPxCoko6IHrTG25XEw/f788sTp
qLkX0n5W9574dqFnSNtJf2j6TyMAku8+NiRsQfhK4z3JkopLcx+L983CCeOvRArj
Bko79kG1VLuoweZHuucS6vJ0UsLOqT2k8SoFPPWrhYxv6wQcKdMPjAIHJdcMjh5D
eZQQskkUlq34wND7S9S4dpl+OlXwYWL+N6GNeHoF3TXSc9Y/80QWLHVYNHYs7WeP
2logaxd5zaIRxUFC6Msxbsw8ZEviTYOlQJouOx/5mnahOUBF056Zqgm+l/Bivep9
c9kIxc451idYH8tcmG5AYA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 10032 )
`pragma protect data_block
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
`pragma protect end_protected

//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
AXamqV904BqdEhgswUSN2PZRoOwVXiOQD3TWllCGZLMd66hjnbCmSjXXjX58Dshh
E4Q8z+86Y8ZfV/8TUdyuIjMa5bxecOnZHBCBTtCm2KKg+tAXgN4dvKECB71IIUBI
q/7erGkddYNg0/GK8li5yiRhlorj8MpujjXk+d7R0qpsEV5sRYLpjWIARb4yT8On
GpSAQnfwZzYSPEyVNwITyMtTfVwGg4yP5Wow9aAHbOXOEOwv0uypzxumGXr1dyHk
0eSY18Hhn4GDdPOoKI/CltDQ0/aiNrMNU8qBv6ml+u0Dhf8S0kfSeDxgZukz3wju
3yzh3elq0FsvwV+vRZ3kIw==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 9856 )
`pragma protect data_block
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
biM/M1yV0xrLBxlzMWt4/A==
`pragma protect end_protected

//pragma protect end
`undef IP_UUID
`undef IP_NAME_CONCAT
`undef IP_MODULE_NAME
