`define IP_UUID _dphybidirrx250413                                 
`define IP_NAME_CONCAT(a,b) a``b                                
`define IP_MODULE_NAME(name) `IP_NAME_CONCAT(name,`IP_UUID)     
//////////////////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      Top IP Module = efx_dphy_bidir_rx
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***************************************************************************************
// Vesion  : 1.00
// Time    : Sun Apr 13 00:11:56 2025
// ***************************************************************************************

`timescale 1 ns / 1 ps
module efx_dphy_bidir_rx #(
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
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
FGao/BGOGLNuDoOw2cLD/Qx/svugiMj9nD7/Of7AQRpj9owTruVjfdxPaAaFuQ0q
PFkiy+nVIBnYySwKObURj6fxgHQk0wS+fVNundkD1MoBhUwwP7/CdAJVf5Ih9GPo
bKxmhsinChebYgm1fxCeAtHVRSg7bbKpmQXsyffN4wXOoJRy7ZHQPbkIen/rwZur
affjnvJ6PmOCa6+T2mSA0OG8yuJGb+iB6PgOUOa66jKfn7iJ7KN81elyYLsqoTzg
RwiiuyrpGz4A7sQasaEZTACwodnRq8SmA80yTeucjmU/aBuGn9XDcRy8qyoq7eUc
vquHRKQLoS/0rkve6rFosQ==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 12400 )
`pragma protect data_block
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
JiDeLR0trmGn79Rg0k5DqA==
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
QYinqFj5nylGMuFpDnAAKsQm4y5Qnp+Gb3Rw208w5v2DPJPk8k5Cug0yiYpKfZ33
Vt4DZ5TXJzicJQCfsi1J+in0iEO61GW04PkIDxeFUQDN+6poeJuV891kfz+nfxqq
iR8kF7atFXKHb6dtT7DtBEPGeuQ9qFHil7jx9zj8rkNTVBUve+Cz1zjNb+Cpo5Vp
Ox5mDUDpiP8lGENP8O7KM7beW67rvmD86EEtk4EqGIwFOnwa7djhU8Ubef+08quU
SaroyIOMBN8XLvxjXUIO5ahoyb8iTGRe15MJTvItbWORUNopANTJxVrMTpNuRsGT
vInHOhwp1YlG0E+d8tpLUw==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 18816 )
`pragma protect data_block
lNKIVIYO1Xlp5XzaEFr/UVbVSdn2L9Lomr/Kb9n1Pop8tnMGGkHj6ujJIEVlK7xn
ijUOqBwmsSAaYs9UnuUrIST7ElWiV2oMqf+JhL7b19QbpeYJne6Kgwo9FTtsbpP5
otQrw+TglbOvC0dbVZKWPpD+znZPGVf6k5j/GqcVi5HObEiQgcKBZYqRccI98dFf
hieA69W/M/Vc0225+mGYA54Kyy46xnxgR+5UXdUthWnhQlbIbiyd8RcmIqUNfVid
iO0D7SDC9usbs+D2uHGxKYlpcQGwIozgymqwMEk7Mx23ML3ka7Ovxrpv4t9PRt7L
N+cqb/KeYbVNXpgUwqs3+c5S2Uk5+fMTNK1c24FvNRu2DZefuTBCIwZMmCdY4C6F
Qjf5MEMEDwYo7UbojNu/EtdWkBtaY+/CiPmXfvGJGv9RbtQvVriSTiqPzeVqwT1j
tQikMSf3qVeA+gCTaLhUfEouFwMpZ4eH4CGdGp+87fkL7W0BTdRtX737ou/gba/x
ssxRaw3QMJZnVFXggyq8Ok+IUZDCJPObvkziSgDe2aCRNEAhY9XptRVtiRhDaClX
Pabxn7fXWdi3rF1aKmXsa8jWzBZk3wmmKHvfuNE1Wq9REOWNr80i+CqHwXx2hfFd
055Ew9rcvopuxlaNVIzApr5rEfN+djSTKXOFrGUluFyKRnjVarhcAMXyHudCsi3f
hpT9q2I8eIbh2w783RMr26HqWvG/B/3Aj87UXoF6bArfDyVU42K1wplPmIGwIeT6
N4ybgiGm5eNIuNLNEx8OL8yi3yfQN6x19AJoZloCaA+oPSK3uRtL9fGfwqtLeghl
8HOCBivV2vFk64XtCFIHmgJu+26ad8m7lZwgMfko0O9mRc5M6aik5D7c2lyxX8q7
Cyacx9P1+UhzxHwgxeMvCVrZgiuVWo8FYSeGWJl0ezKHQJ8pfGBN44IZhUrDIrLm
TPfGOKh7rqmtpPSHLfKpTlZ/iqB3Xv7eUII+ivoeyXNwlSKLGl8eSK3p0nJgQrSz
LDnpCb3DeKPEl1MqB0nnfbeKYSmxJqSc2AQ+ZMpBT6gdsJ/Kn2/s13ZO/3iTEeqw
TGgXVQUuTjHis8+MwlGHCmR3WOOpqItqgFvck1b3sb5g7IpIJPZahr2c0Q2vr0ei
k+ztju1KGZHyJDOCumKDl0q+xRID7jYjsnLnF+Vvi2Zd4sR4nazVLOON5iREe84R
7kSazgH+BeO0DUBDMC6GyXbsnpVPj058RTNRJI357k2EGzPRKnIBD1kTqbJ4ZSTN
Q7tfra/xN/8L6zh2vfVWmKwoBU9DXlaImHUXlstlvTQJ5V9TYW7K3gl0cW4tZa6P
nmeJeIUhhCQE/2H3WWMIrcZkf+6IICe1KokQ9wsvcryrDTnP3xT+L7UqiZiAHMOm
6X6TJb3+GqRXL2lXRZGJau/ZP6zsd0JvbFNsuBGqY5R7JcC94ccIBjJg0VtIDf7d
gtRU8W5f8xgZobF3Ny6MGffBRJxazaTmCuQadTmro5pKwJ56O59XtEAC3zFEIhaT
+BzqubmacMaDn1b/YNjNRkR9+Z7PJIN71f3QP+4DUE8EJYz2+TsZWHki4aYSVUQD
BX7wNrFJG8+oG3ZwfKBk1M934aI8VHJuHk9bE8I3tYGwdTk4X5PgzProhP2MYiVI
bJA+ASBC3md5vXFamnCMmvBj2iJM2nOjCFHx6jGdLfutjizRh+/k0QyZF1/kkdFv
AzmEyjCHHYD97mCkIRkSpv9ovKantuAO56lDboiRNLPUjCjF3TpsN8xSIrkwZAlf
yhZV15oC/D6cXliKRS0E51Y1eiX8bZ2pSbTLRefxnq3a37YAtCrfTQDA/lk/49OK
YEnChqlMuYFHr4BrSMx811Q9dJGGXKSY4YxHiqCcbZdjDA2Q2PTCgL7+WWSEsv4j
swCnFHq4G4vJJP3phLw7nA9b0vaL4Df3n4Ik0+YP2aJCFhbOVeixvIbW8JqtYHkp
D4P2QpmsTKyNpaVFpS7v8NpfI92jf2kX4sjYdCUvta+R6Rk4fYfqF3HKFSnXy9TT
f5HEMV/soLHelcvdMxVsvrmgO8xUZmzFQGOQiKRoCXz4TnkKgBLir1QgqV6SeirW
NyF76aH//jVFqUD61tcz8amiYFVkxZEOi8UqMyRbUt7hooHwq+Xz+GGymfwnE9DD
o84pRz1LTBwu6G3klxiIGEG7TIZYszpTo08karonoIhx+5HQoFqRPD3NGtg9OLmr
5ETLwZnUWF227CbQ4igcZG7P4CfER/5aRv4cxIn9kyhatz/7AZYR6FaCscrzQEbz
ousS2L2fH4CDEBAa+CCzFtfGNYTAdQHw4np6vaMlpdOjA5J4QlkFicfH6xFvGVSX
IKtGS+KaYq6Zyo2hAaWcIp7sOKSXzKDp1FTp3Yhv8a2wRCZsuDU9Mgplb1iZYUeP
sPSn2jUuS0Dt8X5VAk6DKWQSWQp8VWvRlxWWvyL3gG7gb47UndGHx1AN+sWrOoUB
Qnyt01YVnETXsklFHSgABUxlj488hAmGQ2ElcClkUKhhj/DKagZ3rwsGLNlRGHd0
TfxgIMJJXss2WF0hsRM7JjpMcQVNe/YRJv9dUZJq2EQY0xRHkzUqG5JZxHkzSbhK
djMzaXRLwWGbGF87LmfMEXIoda2++mb9dz53n9vFjPD46Vc3BsTHnfxghGbzVJwT
TfThv5BGX/oYmcm4NoeWhHwxLY/2FHjoOYR8flFq+Hy8SQthG9aCUbpXZv1Ldcie
HF84rrklkrGCOCQDyMhqsSbQRrQim5Tai5kSPP1G/+cB1fHDydTwKSR2c+Al4T8T
/uc4mlTLwMogDEPWLVeTT0FC9lpNNEXgThPUuS3JvXvqik87kNbK6HenUqjeu9fw
v9skSFt7rBfb3JY/phq9A2+ub1A1GVWMaeiz3ijmsjE3NAYdr2+7h5g8JDfGqoYL
4Np3cWvN/afB03D50AQ+6cEGClbUeC03lvUrF39zZh0uWrh55NE7ua7LNZyPn0+t
QVC7U/e8d+xuNfxzNUOvRBWjI6DQDHL3gJjVDwAjgKJGLy15S8PZlqrDpLtXJgpp
50w5GcxVg4Imx/G9vwCEzU7c3pTPHCoZVBIpkh1/789pRNDVL/U0HccPXNnrlEg9
cAgKMu7j8x7VqZdGbbFIwTJUSBiiitMCyP2rTzrmW+R9Vvu7XzXDbHZDpoz+Y0mh
Bu6d2ZWnpsnecjV2SO8dGX+sfqpaCpr2ckLRX07E7FqPC2BenqCh0ZberMWnBUVV
wBd/OLV7xaWEyUDMlMnGI+pcTfowTVwAN8Mx/ueRq5EQTla33JKlqkJKaAxV7E79
PlQ/PGl80pH0EW8LctobqTDIijbiEunhwgBIaGe+9XfHAJe5Y7yMVEUN4+DXCRZ2
B7irBik66yMC9gJMOPeHWW90X43pQBUmQjSP/aNGHLRM+K/mxligioLJA4C4x60H
Esw6yd107aGelXB9lgfPkaaUk0xpUm95OIuoLW5XcmrrSDCl4X39cMXPi6B0Yi1R
vk8I72dikkAGy+MtTe/WepTqM25rVBp7rXV2jnflQEOE6t7BYSu78U6rwb5+lPbw
VhK83crMZxwfAjw1NVA8HKkk/M+GWijNjvG73iClXQHAD97Xzk2YGucubVAOG3Qv
UHXBdAu4CKfzwEBeAFrHESFukkq6jK3Fz4HwZstzB8CBL9rXmtgIpwnmpx0iXQfq
W3V13hGH2mL17bEmHlb5Ip+JN/9Wh0ilQ7GTLZn5WQOU9dAsmeGaXpAhPbwBU2Rq
D383AOQ5mfJCbiv0jRnBO4d7Hje8ZPKKjAWUnfxOFeQrcEc7+fV6T399qB3OkXxf
G+lNfIye0VRWyz/vLU4S6pofnH2XrGXq0K9GzK3+ieAYfhLMyHHHL6YW3U1ZM7Mt
eky6I+L2dB3Qhwh4qFijg4cFpzuEjd+PvfUMlWHFAGotexCdJCn08LgtGEaXZLYM
US3EO+vwQ/NqsgKPE1Vyk83VvLZUk0OG0KZMUfCH25yw5KXgyDhgzJYdYxMY79jW
bEUbit9ia5vE5wWmtE6l2V9DPT/tACa21FUc+I167AyV5nRDxQdV3cl3QYls+wlb
Jy89BLuHh91obV1rz3sOhZuuLvtJLSrY5W5CuqoH+l+w2NICfR5tcZsq4itkeJm9
WYnuxycrb+VHL8I8bcQO5Zy4z4hd+OS5kRsuvjgYTNDOmbHUk3NAZ1Xn73ixMcqV
xifgapTclMk1+kAyoeSY7AzIX2RkOSQht0DVXXhdqS+l09R3XxTg0b0ZfWUsSGbP
6xySHZ6fK1G/hcP/mJAVSoE1hglh/csOu6c046dQtvHhUHZg9IqNaaOqIE2tuGbr
B/XFviDoSHL/Qi4WUGXOmmot51zQncJOehruGVQE+mts3wBuEEMEiInHeGdygxZM
/1sd0hUZjvPowjDgapJRxI85e+u7EWWunK/WE1uHi8ZNg11IWzhv43S18uvUkqmJ
QxD5ByA3GZ75/+KYeRYtLXMudwOXR5OPKhZd5wLwZgOWHPcKpXDaxIcahZ0VN/JE
ThrJaQqPO2OIhxrgBAjOL5NJg4gUBT94Bau4RBDsjepOz5FGFYNIt6HPCfteQgJH
xBTYrbbpqQAwD6Ib0stqHXdr0AKPvLhfbKwo+coKvHOjV1DEQnxU4AgJSlTe05MN
ZCGLjWwosZtcIZoAX6+E0PfbDS4n/5MFLO3uxC/WMJqPRZseVo2JtrBBx7WRMYG0
iiETfVZyF5okx1pyNx4tNqH+GGbeP9My5DMwjn0BLuZpLsvNMTlNI6d17/6g6LIA
ZxhlewL/kmyHvMHtawpm3FMwESzAZ28ZBjJXWWRpTZBhihkSvBsZSzzwZ1Bz4bid
Ttpq3lxWHBsL+7ywnkNZXdFkTaw5PXQB/OlX7qZpsjPnrQdChPBAF6sbc1djYFAT
RYXm7OKbT+Z5mIrUuRMf03N6JCim4kUEYGs45zPzFROkPU7kMmFYKREobBjylQgL
+QZxRy41WFPsRhuoAj9a3KSp7GP12OJyfebb4jjtyso64feaIfN4FpxgRVCBQSZz
KBusshTgENLOSAAoOW+RMCKQctaSH3uVnd51ePYfTgybrOmLRlkDd+gN/W6e4gnP
8+F4ZLJLt/YohowiMKPb7TaQOf6WVJwtbfGdeVbzo8W3ivCsLkDXazMdjeRc8pUf
6vptJ7Ul7Ec1WI0gJ6mCHuYGBTZx0qb+cHLp+IpEMiY17/Tn+XGP02Ql97hCqov9
ubf/rqlvbdsPNUKM2RYz3FzWOrEGEkE1PhiznMoIaob3HFnbK5s38K9WeIUcaiAQ
FGp2H/6r1Z9y9RhKR7olBpjlRsa2JnvNw1XrRIekCQi7upE6NLy9WDTTo8w2c3xi
FSbPP7Ut4gB6+djVtIOkPCp1tN2w6XjPvtuMqi/2k6aTXaZ8NqQJrMaDgRQBBYLM
M58J8azXfzeyizG6e7Oaj+3sJEYF5JMzYmPtOGeuJXuwiv/Dzh7Fe09GK6LFKJuq
aanfrJ1tFMCp385gRYfnxEHkBakEVoF5mYhLIKVOSN7ZHwihnMJfJ9CFVj/ih16o
ZL2FbZ59IwWMqwm5qNL+rqASEG1eu3bKFjjJAPXIxrU0EyT6P6RPTPjbHgXmvcl4
9r546DwAPKgwXW/n9gew6fqOqVLO8gtdfZlOnM0WxBWe/GUvBbR0Wu4EzYCt7ui+
u6OdXFAnl4z/1VZedpgj7EYNwNU95/ed3T7FptXQxgKVkHoW410C9+rxmzB65h5P
pABAnDvZ9gnnjyOFYTcltcncxuS8klKsoXAyywaKK7tbQP/jKl3NrVc/BLaOaRU2
P45iYm0tVDKfF9sOY45P2J9ep+QxO5vuQeQUBH+NFshDs2XxS1uxXvJHG+S9/tkD
gRhcmrJZF4Q2/AvAHxhsMBpjAiGTjuSTi1uee/rJ7bL6bts2St+i60Z0TVzLnNFo
kaSCTOdJh75yYriS7AUpxV5E1oNQZyLoZPqFf/1Dwcn5YJYg7fdbDqgoa0qdvGqU
wnRoUIn839AhSejXDmuflx5QQ3yaMaf89FwgbYhaJBfn6lcGIXxJ2ScXIGkEnJ78
Hm5xLYXuxDQOS+Q2C75Nq4KQPcVA6BIIrby7Pmz1zjCkLdCJx3hrJdlF++M22Ojq
574NJEloWCDgLoqT5kbj653kZ+BBidi6buUm38INYtu4lpApfsj085chhV8ZnQAE
Op85V6f7xQvAi2KH96YPSpgUSvO4UFm84TtMM/muBXQ871d0efg/a+lbjhUfODfB
mB4AkL+Ck/MmDSlpC1PnJ/nB7c0ZrHCviFOYpNhtdk52POIADeO3NhDP5ESWNZtb
zlgiFbdxzgEl6LZgekh2+P05IWrRhEQVyYBjb+faue7qzYK9poq/D1tPc4FgKK2b
44DNxW+XhUngiAVwK/wpz+a1eAZ6EZcVwjkaHimdD67rqzVcItkNgocVHdSJlt1D
s0kWrwdib8aoR5SvjvtcCW7iTAnHPGy4xaDchUzAUBi2tLqQt+w6otSNPWufvHFu
GlqJj2gzqhQ9b7BHL5bq9Zj2RPEfpwkF6VZR+Tf8EiTZbeCVs/19IFMjkZdL1FoM
2TBjdIz4pg3GtnPXYmrFE1AkQtMi9I8heriwvSA/5lNYj8Sh/+MfO6Q39bP/3aVC
HTYwWYu5EOBDAg8NIRRQ+0WhvxlUI3sGkqVv3YWpri+p2EQ6opTs7Bthn6bVEuJd
43mPACXJkwRsBb7h75qGGHZrp+vKwN9uHPcl5yEyqq/Xj+NIdXW/kWCreg9NDPb/
OgMDW8tfzB6l8MXOsO13Bb8SqTwxT23g711weMyfOr6plqMTH6oLlMmACjvraxzX
okZutEUeBneKn7wscLcyIyBqLSNOP2MVq9rBj0Cf9hvTyi12YIOI1dFLPEO8wLMh
WG9IJctmDYdNYaM4II9WAlKfmf+JZibZJbgrpVYKVVrkE+DLCOuFXyexo0P050SM
5GtdfHZM7bXnj3Z9gh6uMlmHDeG0vwXeKC00RD+T366bEiPY4cDDDKzEtt98IrEQ
0JYbIMVcXb09vuj167ls6C+ibMoHgSv2IklOYJ22XW3MRN/mO5zu6E3axDDAri8w
sowj0uKMdwI0LpwqDQkl0krtH5fzvJqz11eh4y09B3zLCzsuLkVNmv4NplPfh89g
Hb2gd9KVdlbAiDUll0lr527vw9LlSZ2oJ/ZTgzr2AXMGum9iKy/myoLEekAcHBcV
F8De/LCwzF/UOpT+LEn2WMd2WHHIPBD4ueHlmTPz2Z6V4V8FyZUo5SrcsJk1vVLH
i2UAgoH2uBk0BjepGhZgrviGWKPxo9vTZPQ9onAtKudCKKjZaUucu7sbqSYHT4sY
64e4wQiR1zyUBsLrqitBP7EyW9tvfupA3+BjmcHkY31CzvYCCwE96E8BuJE+8HiX
b4lG/6jDrk4rcgGkuh0/qLHtX6n8B3ypT//EyJXu1kCZCEUi5N2lZtoWqMqRW0+U
VVZtpdq4spOyVm01B72gzUySFgCdg4CGb0wBUirUGrde5kQoKgaVMZ76Brujwe+J
ttLyQZrQuckgoreFDossZfb2XZOWPj763LU1beWY7tJaPeBeULsyU1x3EQYjlf/9
nH3h+OfF9sKBaP3bM07ka/lf5V6y0ei0O+PFW7oGI8MbaYRMFnN1XMG1F2jSnHfZ
sB6bT7jQucfjeoM1S/Hajsc4fuFhH5SVcrhyNvNDsIlRox41Ro/rJB01pNfltiQc
giHSANrjtBtHhrwFzvXm43AOmAdVeuHB4KuNEs8xLzdZAKx/Y+Fgw623JYKqs2nF
BImCMJOxXkMO1ScjKfElwXSrkxmAITIxTAFSb1XBr+8IGp6qLHmVngSt+u6LZ7KJ
XvTHcrmoXhf+CdbVnR/8aZQYs2MsvsQAFn4XGcpI/ax/A1zLlt5yygIJ0Xuw27A2
pSCFfhsvT/9XlnAwcntUgMpNJ9BQ7frqszhlq0sP/F6VtZ+5k40xidWgBtWQgyMU
lIaJcQoBQixe75rADEHi4QAQKkgdfKFdPI2XJz5KHUY/+aK+ENL1S/WDDnXJuZgg
t8MIN0cSc3GOl3cYrx1OehC8jLGPrmPoDKEaltr1gAJ10FSmRd/naPVFu6xH+cmy
y2U+wKdoLr29TnbxMvZ0gC+IRfML5gpiiv5h/B3y22ckBkxmpGcZLA2P3gEUNiOa
YsofbbOjDP4pftIDrRS7+0JmUGAfh5l6UeMVYwKhos1HiOH/sPruuWRBgbRvIefM
hts88I1Cn+Ijkn4FOe8RpdahSkCugySQqobGRes60AvPQAOskC0g0APUAALKi9Jl
5WEMJlQQgVB1nd5IomFJuWRMHWD7b2hhZgSSeTTNWOCEmyaI+GP7Sx2QIcjz5w52
5VUKa2OBLAn0ZVeZJ40n4Do5p/ZUVyDh+bu2jrFyJ6kthgcgJFbAUUuRWNu4mKhG
ZpX4DtiijJr+s5VKRhBSVqk8hFCZcPXUcdvWoInl6pVRDVgSjTbZ4VfCTtlNxdO0
iV69uOskbwM9HAGrl8f7hZqd2ekCikQWnWbEZFI9oj4dlLZ2WnuNUBy2DgRiD1xu
SIC7hDV2CNcsLjv1r8T4bjrIrJeNoApc2Xh9QtEwQW7/f/pj8jKdWIQehCpdE5MI
WBJ9pAjAnUTkr3F6vvUto3aaejqqkPN+sZVsdruPXmABkTZi5T0A6UJReCnMHge1
khciGejsBeoSFCoFZsPQS9I48ADzCf/nrfJqJaZsGfHENrONfTt6smSvbOwymrOZ
HVzEBUpuSosAt6pcP5l6WkbzRFcBet6CFSdos1ndMYyFvHNnERQgQtygMGFWMIns
jXaKfuuuJdkQwIHyIvj8TtRUl4cIwAisbBbp45bzMzMmrIvaTNTe6Ly4l/Xwhgv/
L8HvWaI6kVDrFAHlIedkT+Q3rUD67ue12aIN8+0frBO3NVad3ykHfUh8FPlUGSpW
50o9MPokO6k05unn+VRyTKUEhjQwUDlMdXmzmhlJzMC2hTR+xiIMYDcheEacK5Gn
2YNP9OH/mNg2Z9n6ZfONSx0HXW2aYqfdz2m/iWZvesB675HkTRjLXjAhduXoqQ/F
HFCqprxeZ84iP7TrKdvUWD7+orDEMNSYbGzCGq1Klpx51LbWAYkqzY833Gr8Szma
aPE/JR5m3HC0wMwlUyu0RNHVYcCX3Twww74bjMWvCKRg0vZV2ypvFuJR3kcfSO/n
yW9Q6bzeFJ1Q3x1NGfxv2EUfX2EYSBXd2m8PzKaLa2UXyLWPmhm9EcblOFlhXNUl
3b/vCD6OGLM+l5oWV16teIK8mX2Ew1qdDP24cTyMvWhQumTx0/z8162FBJTW3Qjk
DrZ/LYYeSV/YivglenMoVLYDnANfFZlzKwlUeyoIpGytrBwCJ61U9r5jWvUWlH2F
3syqVAWI8GpIxaLV4lRJA0kk0ZJ4fPwBSqmg/lTtup2bYUlSJBjeFUDrrdhYTWxo
0Bo7QTMzgsKJgtmMz2mr+U0SiMtydZLb8Lay/OmLMSrIsL5oLh+Q1PULvSg3NOGE
4c5ba6yxHxqPeYnW73XJR3AROSJT54ludM/8TGcnyKQvmQ9kcNlVqayISD+e1s7B
DvARf5ClK4qJnH2j1Vuo/sTsF0vO4g9DxeFHgNLnlqmFTSbNM0RpAvMDCktQsCYL
7MCNbHt7aAyRyXJhVfCfkEYPngylXQtThVFdOBzYn9JDLizk67em+Di1E8VUB+12
52K1ac2vTpJeBSN9jla4big/AifgHXEazd/ZAv9Fck3gFTan3qN3PX3OeOwNfGVR
qr4Q219GlhfL1fE8z5B1MqBxG8i+vv8PDDvtgTko2mZboQ1Bug87fECBagZe3z3R
/F5bMDT0AWswcSdhmojJwY9lAf1nZyWUCYGzBFG3LHGQEMVpfw+LoIsvwKPo+9hk
hJzWw8wz68ugrPAYbEHkxgeCMQiYH9JTLbqK5bTjb8dLlVsWL3TBYSWiZPrMUDLE
NzW4R0ddDVtQgs5sUBMb6NWYIiiESJyYMrz/l77YRKlvDeD/8vv4cjJrqIvAzPWH
VacqLVmwXjtcVOlNNmRmMsoKvIdqhFgR1KCX4eucFFWqRzWvooxmFh6Zrzt2Hoq+
JKfHvooVxWnqE1ryvKq9ahb+msfFly9uBh2mvWgGFMDOca2n7ZUvL4IwBbeUal1p
Rtwm5yLm/HN5vZdiX1Wq21/BiHeJvSKwJa6agyKgAfcEQpg+CPv23KXl+LG1R3Vi
4mai7J/dJwnXN1v3OaeuK1+xJTZqFapCZ4kg3CdsxjxhEhdJPrePtg8KI1hqJZRS
kCiDygKXjCkLw6NPjcASuvX4eigbyKdS2rFzZO/LMtYKw6rSEVY+oveFF16y1u2O
LRnUv+J+nXahQe2Zl9ORntZX6OSUMfkPaoCN7vWtpZYSx1SGsh8b651ia5zj4eVT
n5I9uEEdG2RA0KUVoOxaV89lPu5pkLoRkTrwSWehHAad1P11ZJAb2qbbkoVa26kT
tpCt6ahBkEEidlQBkgUfuRDGh/w/Y4Dc/pKFZ0kSJwRtPd7dt1ZkSdr8RZztRQug
pH5ivlFuJTpgKWXCru3DkA6I8JgI0Dfto87ECj8JLApQFO/O33QYl9NP5KDCwfjL
HDNU36O1DRdNDAV8kOy2t3v54zguTVImRJjlmlYE5qBpiuknbhvjyOTth1/Pj/Np
3pdrv8l4bl7r1SHGTiQ+byGTCmA7qgG7TcEeIk/ty26Ss8dF4M7R0220u2pJWpLE
34P3jjt/YM3wR2slHj1jnqMSg5+pcE4rb+uZGaIifN00o0b9FELoSr+1h20Q7WgG
GTedEXpOXluI+Qtq+HJSo3aurx+KvLiKlgSG2KQg+Fsj0ax0M63loEXwikrJDZqM
9ejSMXo0xl+mb1z3qO3bwd0xNRcnaB7k5gKduWGmdsUQRWzqO+9EFYQExOYYSJcE
ozgRXUAgTqRyiAQp6SyUwJGmMlm3vvKIrMEKdRJDCVwnYT3g0rcreac6MQOT+18x
qkOGRvUxapqHR3ORkDclmyrwKc6/jOMWa22Y6tHJX5U4xrtzYdfZEN+J7F6Fgx0L
4CRuprBhviq4vihVYyurJV7K1zqHY81ZONtceHkUsT5eH8WbC5HMg9pDDqOrKUZ1
MdOaPQXEOCyP/BDQk4JTphLKaW9Rxe0Bva+Xdf2C331oNrHTrYYMrAdLqgDnlLMG
+uj6Jpj0sgTSRyHR8IIDTf/gOoHndafWCW+ceTA7PT/nHaPIOn+TTq7XB1plavif
H4KnSIuWakxuE0vkGtjDdbHRVj4YQkZuh37JAceJ5yCKhxblCuNIGsYvuTJ4tNft
243EOXvkBUNR7KAR3IrjED5p+WJS4+4O0c4xzLr0ArVhzsPab1MBWPGZcGJG+qyT
ZhHp/+qyAuEldpC9bpXVJO84c8C3damzHg/gSpz2FP+iKPVq9XkSvftue2tpH5L0
jPKyHGMggMC17cZeTNQPIMQsnm3fKdmao13voU921NDyDDs6nNBUIYyA+enFm9VQ
gXv7n35m8TpMHfiEUs5XrtIiAkngWAbF8kPvJve0QHgCLADOSyviSIAuSdkQTrCP
vGkINqBw2f9Ex2EDpM6hAYQdTuRdf08MRSX8JZ7JXEpj8sCZVbt5z0I0LGCOT0kT
UVFEMpflsAIaEgTVdF1ECWpVhLRbd6pMzgHRfFgI0mbKyhsgO531Wz1TJx6FGV5o
esfdPntImiW2eKjVoASaSSNbsboXeouLAZjl/JsarNVMrARx/HvteOco8GcfS4zq
xyk8zCEjWUi14UK/nrEeiPKnv7tFhv/oV6uQSyEXBuqAed7fGH54+lUBNs93ZDB1
9eX3gBuy2dsj3rtIKYk21S/MloaKV9sQgA4Uhc7bSrlSfb3WPPozo4ZkpbcT47Qu
JCFHS5H560lpH6/w+5kwxF1Q2tFtcUKSF6hLbQr/0l/pdtcLnMNe1GqHeD1qAbUj
P7lL7yxSK8isLtRU3d1MMApJvXo8ftVk4UTU16t2oOCIdHwS9q0Se/+Rd/2lH7j1
8H0pJ5z72/eqgO1BEmRZiUtmH9UoE6d8Ad/Rl6uI0j+gaeyyOKhkq+1Y2UaKQewn
HzY/dfRpR0mhYdjs8EbZTZ7RhXKJ4jU9RMq3N6699//VXGa/Rpj3dNmpxBc3Unbu
Ei2FJ7ndlj12xGyu18Xk9Fh/FKqQEjX09Yx1DiU9CpJtQ7xPwjJqjYvlK+6Caw35
ylWNXLF0xKm8sAyjWpQTAp7nWcGKbc3ewDfHgp5XDfbvMwxqvvr6aPJS9HDC4tqH
8sU+haNp9kFZxw+Tq9lCGJ5Pur41ORIb0FcjX7qRmFDeT1eq4nsVrfrpErd8loxw
vTGz8fOrmIkNZ3OdTFxGRSCgI1Q68m/vEV981R0Th+YlYqbAwJLvKVOk3bdGs2m2
Bu4gWbEE/zQP3heMd/cOTSBGBd2yfkrw545td/3taCTpYXCEV5n4LddMkLdzvdb8
djkRvJnso7pK+eQ2SUc17GEqH0unbYOhDb5ZDwHvZ3MORiOqxcLqCznuhub4jHy2
UINe10b0/N6Kz7qAeqUhruaHRxN9Ztz/Qs3RBib7qQH1yl5XKxsLaaHUHMYp88Hf
vMNcPohgmXYEyOkqtUeGe2EmOQJPLGjgcOSwyUlbRv+b7kXNYn6bFwginBSFQMh7
gLulm99aFG0wVbo0vkfMLJ9T8mj74nXjEuQ3zu+UaoHYuXRb+kZKlLgStGqXzmRl
CKhfeZhjSZ3sWw6Sp5caZ3emkYDDMzfAwuOvj1UWHWjLGm5N3hHSZtMyL3Lr7+4H
pHpGmovzWA1nlm/l13Je7zf7M6kDqZf58j+g6TM21CxJY/S68joXhqr9uVtSxaIW
ARPoaSTV7hq1BBo4QOKrI3eAJOfMOEV3TUM/6vRXH0APRCro5ixhubKwjqqbpyv3
fEeQFvKX9My+5b/07tGjDedFaN/xx88pbivhvFMV6l7tDRdWzF/tvZVg13+Ht9AT
8JkwvyYDojW6Q5tWHm1lZAzHK3hkmhLrRIdIf6hn0MJua3Z6hyCVH9O3o74MxLBR
2icu92eB7pcVqwuC81UWoaDYAbX4Cotocj19s1tRVg8hx2T5ewYtFcHV0DQYUV8Q
uJ6Ii1/y7Q1uNFQq6cPrdsK2nE2Bn3oXbCQbFk0mWZOpuC/UQ1IS4dj2CN81XWjy
O7FafN8/z2XOU8XXm1gcAiiGMoCLlwvwq/vHFgPUgS2TwLQzQnRqjUXoVB75IE2+
4FPquTlCq2dGij8j2vIzkIzaLyLnlWoScju1nAnqbyyu4nnFxRYcvn3bL4637pKf
8Y5WsPo/tQ9Szo0RJAm0UQRD+LL0QtYZQdHQnh5wcrFwL54tjz3zTleU/6cY/7y0
fxu2YQivhl4tvxW60qbcZtsGu0dhuV2a0Aem9IwcYBH3PBzItZK9KqqrQh77cXOk
JK1hJ5keNNkvEP9yUpNYOX6SVuf2xirGHpXYnL3OkPnCUnUTAUCXauFl5VD+sics
sGL5/Zy4otC2+HHaXPPJ14q56gwCZVD/ZBza9DpJ3YAGNPDfcCQcr1XkwJFFj1og
wli65Xrv5rdX5Wy79xl8e1YKMfFz5ZltzrFENBPc7C0RA66E24plHjzrEePEp4q7
/HEfovCgP2YNWt/P4Zb13VR576EbsqAU4DN4SGlYSFdQRPhX8f64rINEVXDmvCXo
gyg3nC14LBb822uI+HvAe6GUQc/1DWvB3rWXSBJotHNhqhTbjNcA3djzSQQBqoOw
DOOOVJoZd2iZQOGKeQ7wuqj8+Sa9Iryl1EaYhCIhT8fZ2X/3Y6ocr+QH6iD1xKHS
ngCIgDgwzSDwuyaDWXZdRvzOWqGRDctAKcpa1bK2vJJdph/6QeRWmAUKRII8Ty98
YLmGSD5ZWejTYfeYQ382m6ROxshFAlmU/q4bf5WT7P87QmMjIDg2t9A252FEdyW2
RHdHv/0SAGhhtapE1IDHMZ8uIp3i51dZBzavxktjoVnKTzPHZytNrUPMGnP+mW46
IMcawv0WZZBm0BkUkPALl/8YY5xov7740jpeh1h4ci3anwWK+Yh4MtPQhiZ4xMPA
C9LdSlQ3Aga+5Mx12QXshPzZNJUX7XE514RuOKZ8OyUmNcC3aT6UBTh/ouj6udFH
9KzcYZ4dBBWibfl65hZLbKItNeTQlX/zkz05Gqvu+ShT2fKD3Y5lqrswbhf9SR5O
e7bVqZupZYBKalu62VURNI55j/LrgZUnlGTBHHoLv2kG7zrU830Tr8zFXJLkd1kT
pocP9Pxh6BKnt1506oP4TydT+k150FIscCaG0V+tvXjJbCkSF9a+JF5gPr4LpUTY
l6eBasm6o4qOeqzekqL7F4jjEWbPWm5hiNeEU0Ji2BmWIriNnGsK7ckfzi7vQexk
5JCpHzj5QE3AFj4i478vKFzaC0vA1shFS6AUXydZNe1L4Vv+pl/kS104T8zxTrPn
IhoMnHhoz8LwT0fKSk8O7b9AcaSl4ZdzkUf191uoAih61gkB6GxHuKvBRh+LOfpF
1+SZstUzJjKsvkbZA/+xYnPAeFMp5Gvg5ZDNUeXQFNGS5QZeMmLxJBoD4AZO/+Q0
LwXG6+2ufzwyjl6K9utkt4ei7UR0rdmoV6QQOKu/hoqE4XgXOf9whzTPSocjJCOm
vuBygXl9z63dInTXcRQ80TJUcni7j4LjLCEu48ropzSQrZ7ZKpfGJ23K3wfjgmRI
75uesRLWO+RkulkDqw4dNhmXEHu7ZkKivDMAegkr97R17JfLlyLbX6kfzX7JyFWy
okI4VEFdtc75Glri0qS1jSN89x+o3DZj+SQpblQ7l7AyFZqrPVXbJ1uLVLohVVFV
jDJWRhKaFbz39KkkxD0dR2kdJ1vY9yCvk8HniCasuM2uR+n5J3wj/T+FxqEVcdjr
UQo3JxxfsAlfNMvTX/UGQwh523Gh52J72i8QNbRQ9Y9TXV2540WsLfYyzgfvivm5
vOTcVxzqyGCLU/aNTKkl8EKce/YgEhzQF6MB1HafEa7YjBDYqleIjwwZ/srIdAwY
UahH0eEVhsgdu9VH3QE+ToMMpkkb05a7RoL+eUkDhnnBDWGM5owQPhk9nYLtIdGd
aGXIOTPDslkbCdHLlnmW/wkIYSxwvBsYOq1tNYsgnDfVZGz0TSub/AJlVWj7pdjl
YUuXk45cpfIx6ZgXssl/Km3EjY2zIwox9rG0FiAJIJBuVppuA8Ggr7sczOXkRwSs
33g5BXvOW9CgPT6D1F8vZ7iCyTfAYuiynT+cxmzhiOJ79XDIJ9sQ30Mh4vCStIbJ
EfzUAVOcjrth1CfzCKUntuxhN8mHnHrxrcURYpDWwK3JkdblKI+69QemZ+c3UOx6
aSL5jDUbmsf0F7+eg/Zy5Oe79PLDLunShZm1K0GIWcAMbrKPjE1Jck35NhEjFCNh
lmmQAAFbFTYoYZ08wHFtbBCxaoKXrBlpTePJAlTsOgazTN8OieY8hpeC1IFa8ZSc
4YpDxhkMMaQDFKwb4npHx5fTY/oVJQzCw34RT/Us+2cULODQuLsD77KYVsb7up5L
5fe41VB7Ddc3Q1w9N3vqIax7oAL2MCJxdULM/HuTBw3l6vVExC3LY3te0eDv/xL3
sBz94OI4+GEPTU5HvpQo6CAu8xmDFNrDTeY6qM6VnnVz5tOkh2UxwCYvc2a0FPZc
fnEDGHJhSxd9wSyFrPYdRZWAOJ7HWQeLP0xKrimeV61dyNKXwEEhsQGB8pn7IVcT
T636sDeHp+eBmN/l1LjrQ6pTDR1iJCakVUEVkNqWt16hA5eY+JmUCIJ9dV4UN/DE
6DmsfcHnOBpDPak/cu9KWmB219ubN/AMii5kA/5dwBH7Yqtk9aPy7pyDISEL1OmN
j4MCKldD5iLbmjwLd4XpDXrpFBVE/C52kLR9k7zz+aPeYv0IQNwqDYw9Z+KimKu8
hBKSmdi6A/ro3z8gUccenLV3RUhfrSo2ZZ2NQTqplxgeBREEuzLOcD9jWpumHFQG
z9pnd5uPe1A1CxYHP3lksZgmlSe+IvPRcRGN7TYrZ+QhCK70ThIqM2/wMJ87aYeK
qSL/LI70GkUHh6oCFN8uL+m7MTKiOcmqct5IC87rxE89wAYqaZzLVa5mjp9bA4Pf
TnyDNX1N/mK/LGuyfZ/5GB61RaPcTrI7CR2NuzjWRd9TUSo8+GwtwVeKnWsrLLW2
Gg07npFZYt4feztGHzYRj2YbqnPvLoS4dO84HOSgBud5Sv1Fd/0h0WwkVC1/oDJQ
j3KOZBEcLrYclpyVYjHES2Uw/k2+cytgaAw6tf8XwPkihuy/IQ4o2P4V9z4vjmV9
CjaoqW1mO/v1o7zEpe7KDs1mzWu8a/obP0ypb6BivHxFTHTlVOug1zS1yjSDwM+V
7YBObsfBThfuATAdOPTqhXgMWuuzB3ztY0JwIFpOwPgpk5a8gR3+ePpyMY400iPM
rzcji586PwIc/h/ZKVorxCLzuUWfhLZUCHnU2ppVJe464AN/z3HdyZm7rLPwLVxV
ubS7FiXtzdEzVicrLFrahCKgSIu5QYt4lK3DwMl0uqSkK4D50TWH59Y3UxX/HDXR
s+ByXrMQ/ngvl4cPzMtueRBgsb4dW9NBgVAnf2CGY0wmKkDLEBJBjR3AlI5IhxBH
quhlrmMAIho/B6yNgJgT1HqD+VYFMCp/iX4DicH9TMKuaFoCxeok9aPF8zJ6ogbH
c1dwsGsBsDxLOrJVMtxw76XMMJ8mX3RFg+JEq8ZxQz56HbFCtgy2JKdyukNa32oO
IAUqDf37a0sOGi3z0Rd3tI/mYVy/AeI3dmcbfFdOt/oUmgvDlKi0+lBR4DTk6tUT
ofCpHW5ehiZ/FKsTNCdtQeWy8SMxtBKrTuo1TbL10zgWf8XwNw4xsPmzu7ZdbHCB
KZb6ZWVVOyYrfJHGIZBzhBaC+A6dH/vbcFAW1rvnL6216c5yeNBY5Lz0jnEL1ROr
pXkscZ2YXXxc1vlfMLmkbxI041vrZmJIrHqtJnw4XUBzEAaw74vkrNZIYGD+2fvY
tjntmTj9Vk36eGo3lOl6Gx10/FtQigakCBZ3PAO0Z6SEh3oERk6dN73vLZ/Eo9bp
PnJO73bZakckEM2rJHlPFP9h82iW5G06Gpuqzi9DgtCJW2gN4MEEW2R5TynPCIK3
8r/8IufhocMIJYh73l+XaefhIf3wvbidXksAZ7HSthPJmSQZkGc6h6OeCrovzQ+c
92JlNqSzYDHxMQwjytgnJ7wQ8r93WBfVYI86vHQ88LJQ3ZoR4fECJiysezVL4dAj
r7Qicsxc+BPW9s++OgDHmZ7QKXj4KjJoUO3f6wktvZp5ehqxsNhijmV8fiMa4Kiy
01lKoRRS/xcDvhKWJog5OKyXRk2ty2izxmoPkkRP/w3/VvR1Cz9HqsAcfI/wuwdd
GCyZnlZgjA8dITudD7Uv7+prdJBrb6yQB0yBWnkprTkrIurFXa+cy2zHbuyH6j8z
j30u1YcsG/XQS/sOIcxBSPgZRdOBOY0fmZcFyLgNsHrzYiYPTBnir7uyOl3Yd60V
APk1P+IZkE7Ur/BEWjJKYAKRBRr7C3GnV2+80eKnibfjG/ShBnPoAqGB9i/cnmNA
lmgCwWNnBmXQxBssYTOoCXJr+H3RPk9H9pER61edDQcNzA3SXKQNTTAzxjs1D+lD
RwxEPvkt17S+6/pApwTePfoOrUIHzljGrJ11aYlH332zgzplFL8GxvFlDHoTAYS3
CQGfqKB5QzvQhfrrykKta9HLIQ0Nd7++Ft/Coodw0mvPA/ATOA6HP7LrbzZWxPPV
EA7K8f2fs88BeemHWogyS1UGQcXIhob8sdzqSzG2MNFoyH1d3fuqW89kyztNQ9CY
K3ZcF9GUd6dowNU157kI7Q4Ed1OApKCuQeR7OmsD2uugriNZNMleeVMdYc14B9g9
8o8ysHghIhQs96h2eturXf8Oy0Yp190SAQdE8kV7XKqTymVbU+q1KosgfAzetmGa
/QPY3graIL2s2gS0U+hIbRCcTnO9WFEHBfWrSCvNBXDwIussrbNCjNBsdO7PGYO0
likUjhovxNVMylbb929myQzXqd3dwH0gEzJKlM8cTcGkMm+CFGiJK6/MYvCtuTZI
TN+y9UU6w0lDeM12BxXHeEBXXdCMlWZIjWpayWj/Lpmy72FQAGHnOQuGA0V5sUSr
tuW4Cuj/4k1MQWKM0V3aNSHA+AmYKd9C2cpp0Coo+LPZoj2HSIIpBqt339PEk0rR
MS5xhbKftwsPj3lVz+t/7ZfiDAbk4l4HjZvC0qfIruiZ4xV3JYVGzSVzsChdhBtD
VUCW+qN+5WCrYvUIIsrYYFR8m+5DB7uDLRwYIYlrmnXUGTxZihBhJDiCiI/puhox
mXMvcpPem/LZvKXvLvhqI2Hzi0r0AU/5oEZd73TA79w0BZy77WAE3Ni84PgNTlS9
YWl6Z4a8pYagROWza5v3rR0/0ydDuy4HJhf9eqxwzb1I3RnmQrXI80Jk1yHlAxJ9
LZDCfaQ82SF4xrgibKcqX+rUVCcUqQWC9L0jUVwheyJM8I4XhaI0J7eybXQ94B5V
9FXddEju1MTt/HnmSWriNjFvN0ff9ElTaTVShmDhXR4fn45lDmzm7+bGtax5Nrom
Fn0e0kEdbSJTCySvhXWBMlMvhn5WN8lEY4dv4ah/vw48ubbrGpc//1JbmcCKjKUO
r+kn7XveJu+oMk4GPL99m31ELl4F+Bf6saOYKCgCURvmXFL2IdSKx6y2AOgP3e6O
W2cm3KmhmRhoKgX5IFo5Q3foQMHFvOxGTJhKnQ8cNgDih9c4iEL9hviD35LRChfY
Cj4nTnaydIlUHep8SvOsOzoqKVSDLw291r9rH8O/eRQ4Uth60Jy0nWM103GUGZdK
SD3ZadGr1CFWu/S4FWHqM9ASGhLZiUIaBI4R7jTIo1OVz2wXGFcs9bokfhLz51cb
rMJktenh90/yjdkuXxs+d/Ha6imsMBNFPmoBJMPgNpuwFMnm1xZLbKzYZqqqIk8m
GnNP+c3i9aeNmaVg94e+57yEcy2TYMTnmyiiSrd7EzNr8pWeSimoZDAQTgUIXSku
knY4tdEOW3sC+5w1KYsbMrA3r72WWebBt+3AkPqHKasretSrjisd7XaklpFhk9Sd
Brq8AbAkYEaj8/Rylf6bpcf6Uc1MnfWLLA/2srZpALrERUVvs7WRFLIDlHFbgJEw
nIt7baBW25oPGT9ZFddvmu/hmAbtI32Svjpzb7kXo56lK2Z2+LEghAcq1aVnC1UP
XmJbuIe4upsdkdgyE8pSrjWW2z0YkU/CaPbrRlhXwWnM2hFDm0hH7YmZingdA9aF
mZu5WhgkHDAEkPlyCkKKWDtKSpwWslsSeTqQYNqBdn1vHNvwZa+YPKfd83rCr7Ig
TqUaM7Jd4rzSIJiYAF0fSMUOo/RmAOCOw0k80lCZVzp/EVB4tTcuX8nZIC6wRAs1
4Y8L02JWx4NkUN+Z0DLb8AkquMI3QTnGiIzs+7QBrukufz97NzMfr9lI4JLb06uk
TKFf2Ff5r9JrUErnQjeKXY8YdCv/EBjxY91+C5llX9Tm5CmqOoTUbIYdRqo80XmT
10SCRW0PfOv25dHpudTo7US2uMixik42M6FwB58s6oQHK5kjtpTVyJGL0nWtbOvk
dSoZej5IJfub/0iD0hVvqWPan5Y1fYKHOkzkF4YndvEzTh9PK//xtyIxSpO9k0w8
UgKQd2HrONMODn3q/gpiLTAsFQ3thoCxIKhevFfzWO0qqYYnEvtKt92TifC9LpUr
na0fDEFkZQRN9hh9GQgkRwL64WttKUWRfBi7z7+TlsfPenr8zpiVMPrAfgN4BIlw
j9E8Z5wEdX9dOCN3U08EZLDNophAl27fxYxlzKkcaozzzLZB1VoTZ84zo3DNorrc
GpmfBA3+RV47ruUrFn45A56wxEL5dIBWcN/7poKQuKxpSabaMg3BFIdq5z1GDalm
ZmFf6+DMjrzesaXpaPonm8os6GmpsydKoDlClr+gXexWk12C3hTw62jtbEih8O6M
DH8fuCoE3Bs5mLJvg8xolLAcGp9PaZjDGCiLazQML+rl1ZOrW3nLft3Ed8rOmYZp
3bH92Cq3Cu+HUx5+lI4ZyI9JP0bLNpXXlP6yEnz7ctTdY+g7rhXZvMwC/74EWMPF
qjo19FXIrnDYj4P35UU9cNMbq4P36gch38uOOucv7oAQF3ze7cd+F0xOg6su57yM
Mbt+P8cX1qnmgZkIHyNzGQ4nlsE2jgfayJ6+qPtus8oXlGBjOvfad0M3/7s8I/fv
mi+36mUPWLrLRSsSIwx2EqTFLii43j9egIHWgt7U1/drKB+IpJl5LXSJkLeV9V2s
GMtpbd/0m5Nyq+iFwrAZpQqAaBx25cwhdeeDhynilsx482XXcm2hH169D5eiaX7q
YhEjkPb0RgPNDBpuWsaor5FXVquUTN4a6uz94RyO78RxPqt8VUhYrokhKjAnnnI9
mwNuLdmzUE2GK8tCmxH/YG9Mqz5MyOzn7q8tJw4gtY8Sv0hglOCYn7P1MpjaJI0Q
MtwCj7osKmthVwAIbnbSs0lWzQqNi9tCeYayxUBnfLs2Zwy3gnPKjnaS4cYLBB8n
lD96g/bdOd7X6pZumfdZxtL1WtY4m9BSaGa8gDmfV49yF6JPUd9NUkGTA8uPRoWs
QHNNYna6Baz8eUXjItnQLRU2/CQHiSCReRQtfWvNNuPHUz0lYKTZIX1UMeNwMviv
qSTj+vYE5DlHBfyIUT7K8s4jT3PGJ72exxzwPlB2tt+gJXE9DwVdc5jU//7qE9iX
C+GkWp8MPGAWwmqLpp0sUGElC5uIcVZutsrvUp8XEqrn/YdI1AWG2rfchLDOLSLw
Z+JWr9hQFkpSauHuNMuVWHJJhks6KdsYYJMz3m9IPXr4Hoes8xy05coJ+2gX7Xod
QZ/fTC59Pz/dzSgl0AoNoe3yTqvNELRqHWSAOVVNPeR6bSbsVN6nqC1iqBuDsJ0i
2lBMj2WkD2x4Us4ln7GiOybE3pE7fPHMYYiFKyv2Z818rJfI0xSerlY84xzxio8Z
IkzVNPYQsHpWQqHPDbszJ6HW9aSUy0TLXFH4Pky1UxUgSoilQfC8JpTJnU+HD9AI
wO2vwigt3GoNPHLNSkvEHm519paGbWDyyDWNoy2ve5AylcutSOKG0ZOP+60pnVX5
qi/pvG+vuNTF2rMzyKlAlUvgLbSHMxcst6lkgS82+VAWOosWfFfRVpYZPCdjbVAb
NP0rdaVhmhJEkrRO+GENUf35aHH9yz+fd55BLmDV6rixIGaWcw82UXGS4C+9zXbv
fu1WgJM/YvKGVCW74CzhAs7ayIq1qtk9SdRLSrE7Jq7GOJcOZk90wnawIP8Iwbfv
TXw20L5rtq2VfNlcwK8R3VidDOuOz1w9Jws5nAkDKi63S12bjpzqoNr93QPd+0qb
vdFI9ihHg9U1TvaSGHP1m0dj76GNlWp0y8+yFqrHbyVnEuwbbOJXw4zK4EcRRVuh
Gyk2WMosBb+5IMG6wIXuEqF460/nC2OCAni0y3sS9yDew3+t79bF5O3iarx8GO1i
csYtmpwvrg48w7IJ6LLz1nkv2ck2MRtJLjJJIil3XaI0X38PdoxRoTUL/dZGK7gg
V/JVgXqD/kj9lJmEgHsUZb/PxSOaYETSLhDjU9C7Fs8N3+nqFlZdyzy7wu/R8e3Q
TSV2cHrv+NZ6AGkZ/+5pfsw9+9J5kqtNpi5mOxlMv2hpL/z6X4T7g/QRHrG81iZx
u8PBkyo5JDMJdle3U+kU+vkni4SoHUFtnd2fmLGw8FLrCWrFo4I5Qpu+zY0qZLz6
UHJI0agTmc9300uEtCi9mZIpK2tNjoLCPq2iJtZAXt1q49CN59wXdEzB4QgZ1mvM
WwQU78WALgUseZZiAZ2k1kzfqaB9Zc0NQlcBOu+Bp77oyXs82Jou+NbxmnmjOE3y
IxQg5zqbvVIaA4GXDhNccvjVLVUG3hWPzUDpAo2WLFXGpVwoQjirYpGjD4Yjqb/S
2jKCnTi2FsRF7fPQQfHaECfVj+ndvfIMq7DnKkyeKe223eeHvDfDSIE/MPsDwUhm
zQVALwRwxyyCtkY9O8scgrZVO7+VzO6/GF5iQPv1rZHIHoeIkpS1ybv3eoSNjdDC
Rt6qi4DmNtAUOLStNUBvJAOzh24MIaoc0vjNeyWyQ6skcHNPoJZjg++aC2WN3GhK
K816RZH9cs3yJyp6/g4HXUWCKVk/GmDWznFZ3xXViNL4gun/eRVJAGruuTzoOIBn
J9GYEzxWNB1l5XzT4LXnJ/KKTGsppBxwhHdHlHHK4FVkhJOPTG2eXCGDVBUgqW8R
yoIgam2ZH/JNeQii56HsDGc5YuFSvoxaj7fz/zWiDsVZqnB95KpiJy5XXkq7PM5c
tpH4bxAZe4U0GI4ljTWJFNZ6ktjYM2IA9rCagnowz3kqRNyxUlHSs8NTTEx7x+sK
ZiRTK+P9qiuYPxOqV29GorVGB2pQFMfgDwdLentOcFzFZtykp4hcrpouxRgFllmO
+r5jkuo3d8V2Qa9JQFHSgQoDZ81Pyv46JMtIl4LG7epKzQP8DEAU94qaRMFn7Dpm
UfNtMp0THjUyyf7BU1IJBwYBirFenCjPesW9Ye+cy/sBHAih85X02TcsMJWOGzVD
roXoYzahf/Ant8ArV+luIoLIJrEXi/6n7U4KftyEh7n+LcMr3pk6DWKw4uhOedkp
hogUSIrMfkdRjCJJ0+GjiBoM38hvoGvhhIaixViOgVE9m6K6KAVpdbimin18FUeg
KHB7K8d1TBkQKleIe6SaTs00zwa7W3uqru6lgqkwMcZLEfZeoW3WwXgahUum4vUg
Z+qnIB96ZX/AqAvUzey9vpYTSjShkPM3MnzTjDWQfFDqt6WIq/RCtB9OcIz9NM4I
XSsiY+1ZOY5Ot/cJgWv+w4o3ii7c4eqEJYHe0BeZw72rj+alEz7SIn20CxZXXXtG
/rBxQN5H41inBnfwROOOnNiKQUysAoJ7/Fz0DpFIQ8ITfZD2KQn7KCdRXq6ADrMw
K+HUNRW3EIwN9GZE4W3LDPVuLhKmcRphR6d3WEOpmcQ/QdIc1W8cGGxUlLRgHNbh
ZqR6a8pEcPaNhEJaF8KtQ3ei5q7M+aRmPYsiY8vx7Uv1KcJpwGyHamUl2zgRPMQB
MoCta3OcYg2OmRgzNF5I3zLuDlDzkyFBXu/Lw/2k6RItKgh9tR8F4LL5Yn1+/nF2
JvIEkMMtEK2nBEaaqnHJY3w6yoGDnMPsfKR+6DkBO05sok30rx32gjqEG3uCccjB
/VJhvhzMWlbW43XrB/M2jMWPS8xHvwjYP7eXtMC9shH83kWWIzGPVACY084UBQ6M
hm4+Yxh1V6acj1VGqz0MhSGZkh6q8FxmzkpoHlDcKqFWwxHE+QAcWVmF26C2H81b
+tZrsqVSuHgQlkJmeOXKM9jXn9fOk0kb3UE8VwoxcwDy45Mfoc/062PCDYEidyll
mKyQMCUuuqNKjjYu3HTURD/KxgEkUGrnnEuuLQwAlTTN+NWLzOQzcv2lPi2z7dwU
MYl0G41AemtbS0nvvIO0zL0zasRepsmTnKqhun6ENdZ7AeoSTzuqMzXNOqM6V5nY
19yFHZC94lj/xyoqkXiPsRjZjH4C4v6r0BjE+/jlzmpf9EyJyGclu+1wvFcBQwrK
+JWDAOxAtlgipuOZKB/cL92IbdfkX7LRYhoOnCpQ9oOvYuPkPMzoWNVvzul5boZ5
JHmLoNata504W+CVg54H0xD275NMIpNF0TGLUZoGD708z1rYJVt7isX89Nk/uyEm
eJnQeCgNEFv/6WNDVW+ldifkxNiVe21kh5k+ZOH1bH8mT0jiPd3ZSNnWuWIT0N79
zNCadAhhUpfOeydBI7CSWxLNyQ9XsYHzechjIxVK2Cb8iU6tqBikYtAsRzFKiLyQ
c/i1cDn7Taj2iz5hIV9KeQaQiXLIvciwIm/U4ROzpa6LNh1WWb/4sqouuLqKu23R
rg4AUC+rueVJQRqmwC84zWKLYrgQ0GChoFsI8HIc85qnpjG4mLq/VFj1BDot0o8b
8jikON02qCxWeusKI9HxIA8k6457lml6K4irsElg+7s68U9xZoR7Ke3uwH6iZgOo
QSHPRkrxcHrBkRI9AV2b6HJQpyFfd3+QPmL3SIHceDEVB7A4PhmF5ZYgh1uTQYNJ
q5i1MfKBu/gzuNrWuy4KotkixE+6bFYD0QPlgFyd/Ou39uJ4BS+T7E5xrJUR20bm
5o6juXXuMyvAePi7My8iA0MWCdYfeIY7tKR7ct5rkE6y/g9kMLR5nWIh8f4Y9olF
jVXHgRHLhTTbOHT11C5ffxU1s3lLkPDt+QH2LwCETHaGoMdPlRfSHnOkGTN4J0n0
i2jIbW5n4VExhEAdYyBCNH/5+7pLeLAeeKPzPVgn56zDAL37g51PcuFF/RaFfvfw
y5E6EmJd9cxOILjeomd6i0bf4qZH0MzndZCYjhuJC/sagZ0dvaE3mPvzSNrleKW+
XvkECzDN/3V/BjECd/c8F1iHZlSfuplz9bv+ajKfPsxadeas+07u3TRBG6vzwG+a
l28ipuT1hA0dZ+mbPb1U1jMWdXwqPQe6jQvgp0/EBMFJZ1G4SyfDHiPBJH/E3phU
Clr1E21r/RCSE9QBJHc6a5o07bTfERlMeQXk3SE/zxWtTjg47i9+R3vvJV9e2MMP
kiatOJFW1RNNB+Ht5vDmtMQFDkn03ZxYnHVX94qqQ4GjcoLbuzfPkvEAU1p9fkey
J+f4nm+SwB9yr6VSn41Rd9q76ttMgruQJr7m4G06vU/Dl3qmGCrgLs/cCZq/B/wr
zaMV3XoLX5/9du/G1wDMXvU9mRVZAJ3XECC5BBPyTkO+EGsqSuywhxU9O5uWq+qi
1T0DFYuqtAZ0E4Z8XeqywOPOm4Vh1VC1h0TVb4FFma4yXNOXLa2lzzXYd2zxgQMH
DOaetpaZvvcqnYYXv2pFK6eH5x0OU9EwgXbGJZNMZTR/v334h78EgRhbHD0pJtmO
InxRbslsmwFW/D/xKNCi/XUjf9vZi7oURHbAbHmdqhdAXwUBhADHB9qbR93UFG1j
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
KDDCUFGiUM8IBhIIdrJUYOta047dQpWEGgqtaSjKFtpgHyV15NIGoXhfYogtQcJ6
f5qtmSG/45Oj+LQmJIAHLGmMfq5qwLqMb6kOV70IAiFjH7ssEZH1j/AXdgG0KoZT
0zrsDHKBoGGgdN9Ey9IgaPjgYlkPYnnq27SKHA9Qk/EogJbETrjYACSkGOsY70V5
/Ct1e9L/Pk9HGbZUqXl3kdrz7qbmZmX0gxJWzGLF/XkK8DJxWYxKyAbrlmihc9+L
odXDiSvKr8vh9il5iEtkA85k7vkT2ICKesiqG11rTvT+uyU8xBdbFd3r8QmRHtx7
X/E7R+HuKLZ3RLqqn3OJrQ==
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
nRBslBvhs5ph5vFK6UhlU8QOQISwL+SWA2ZXrVtDb0uisIuE7Rr6Bgs9NkqD4n4z
osg+jvl6pY9UJbt1aQB/E4I1YDm4cwtcpCCZhi/HSPKYwkRtE0M4wZkQhJqPMzaM
0n8Y3PZdqdTDo+sbLgFFWRp99xc/pfgBM84MOSjZIxzKVcg0Wivu+lW/LHRqbo39
wcMNcQOGO+cIaMFoEgiZvP5pnAjuFFBwTwOjBT/RGKxHb231R89Rzz2M/38AchxM
KPOFIi65Ps9lKYYepHZkcL3Kc9ZggPBNmy6uQELN0AUXW4E4s63MVhZB9u75Qi0h
8JG8uGo620rML41K0omkeg==
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
Hm6wycRex3o6mA8poa3KNLEgB7Ys8+Y6JiSek0Hl69DGGcX7TPzrnlyo/QHqvGI1
Z9FhD7C0Zfzeg9GAzR0miuqPC/ZqxMkyDJy2OKwmXfmG5jajqqOMs13j9k/429me
eJ/22IX9fzn9FgFD1ICTFWaxCBIPM1ptwebqL10dOjk9KsHu42bfAIHEzyarNrv+
KabZ/k/JjNT+vgIReCf2+83KkXgazUrJ+Rb2vJJKZedN9D99XlG5ShuHnSkGfen3
cufHfWJLyvwUJsds5w8QDhxTU/4LK1NwRQ2kit0mcEtV22GMjsXcPVkNnmlbf6GK
Aw5xiK/L+JrxRT4OvTgOhA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 832 )
`pragma protect data_block
sz2KAv5QL4gbTxddRpy9GKsUoaGc+0FtP/i2oH4XKCDMsvexGjzQj7WgLfX5o9NH
+fduSnyLrSJwR3Q8+XqWZcMZ+LMvK9scbV7kZLEhs1/HSGbLHN3viaUnZXP2gxLL
1f4AIbnn+f1K/Y589UPUodGY6vgh+sLf1e/jYJ6d5P7FdlVPyTcA3lqiQ9tUqKsj
xmV5SHE3NW0m7XkFw9VJwRC5OLebMVMR6Kk8b9JPOtl07zKzkcJEswA0pZ7BUJVR
phUglP0B+W4wYw7E9Ss3EmXWKmRPBbz/zdeJTrMV/8gyRkRDhitG1ws/CKrLPlOA
ciEodmDCxV0d9uvQYixxvWA9PYbWLXOmdYj1migGvcqiI3U6vXIF0tbkB9v26z3y
v9tURJSNcRPiGB29J3WrjX1M3w8SEltyZ9rBA4eDle3kFydgSob7QP/5ctHvaTMO
ajPwDTUn0y8TLZWuzo5IrvaLo07ge/Ri9oT18vCrT06y7qxYOk00jR5Ilb4F5prI
N3Bo7XOfEuCAZtVvwJoIMUlstJgwzHL6+cwHeOgdjARmneq53WSN25tX1PW82uQF
X5dvWNznRCJIdNvyERK/X27kbiU/3MSLqHPDNYK9vdIOTxTjSKYgTqBjv372p6I2
+ahLoUQ+l9qNV19IBnUUcaMstnzEZdSAfNSuEeEnlPSTSs6eNmIYZwANjCtEJglM
MiDibKgJfEckZDFSlH4nIiF+hmlfEh7XK0/1fd1gbWIeYUcNu9fiopnrnjqc9W/8
Dkei9aFaMtwm2aRjCWkgR7i6czKcNbkDRozPBOo7Rt1FwXkyfqiVsXNmfk6rirgp
vbIiFZ0+oLD+NgkRJ4OwHvvjsRGS4xbI6l3GzPxcsNaJr0/veKGXdujmGBRMKbeP
U2Ajfa7YVykj5fiktceZW5CBZKpuOJemHg8M+XHgM/POnDYFb3Y7xX2PvP+cjLi8
9dCiqDbsHR+Fuc52psMA7zzaHyEpVt6ej1JKNEUVeqb5539ZSoNYq32V57AvUHdl
L2L8WzS2rF7ZSGQXFCZB55tUngn7DN40T/c8MQlalfHThNksH0DvOYyAlBhF6uQc
7bdoCoA/JeiP3SuJJJVwzw==
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
jnQBB0qCCTtPOYhL9gIEB4BQLL3t+P/OTf6qFm0+yAUVrf0AF/AZ43p0l0LKxoWu
8uguBNRqOlWx+K/6n6L4F6hYMfzLMBm3GVoTosoFC88sA+SQRVnFkdHPiUfUAqGu
MBH6oz5iV1K40NXNfsuP7ciKqb/JPGM0xFDnJOjHG1ClSsokbm3XvYAAxJIOLXsc
X1+riy3UWIw5gPtHHhmp5hx9qPyZCg0RFQAkMIlxeW/vZjU90VBKkXFFvLuA2Nop
7LgTykYVLdnam7g77xLivRTHXC/ZOB6waZmX6Hhb4ULmjwu3drbUVn/Iy/iwv9yE
6QwI/ycBdCHo7+niMuIVfg==
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
K51tPLvta6So8qirJFc3zdTMd4ch+emG4Yw1P8SerNrRZaUUg/7RFK4VfR5D14SV
8WvFT+3IZAhdyqqHTAhBvUSpuzEWKgnFZ8NXUX3XyjlP2imoLcldjWf4t+7/LUT/
kd2EIK7ExpUnFK4nWrxLly5IRSSUfq56/doX89LnRAtFDjzYDKwqkWLfQNWXFNDo
3BL+v5U7IJXZH5VSKhY2xEvY5ZruanKOuX9KpqfFxqDAw0PRyODDeHLAAdu2I7TQ
JsF1Il53eZtFvkNoCCR1/26MCpmh7HjjKg8Fxcg4FWLh/2MIelDWoGYJzEL0jY8F
cq3bR69b4Z8DvxdwUXJbGQ==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 8800 )
`pragma protect data_block
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
XU+Zc3vsjrv577uQIr4NAQ==
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
VuBW8ixZwFSathTV6YSF/mOEgNbU3aLGba8hs3eshrrhBdKJGsiaA21/i4pSP8E0
I43/E5S9UgXa+7DzfBOjSJQhs4tqoiQq3BueetEIW7eDWEkZ1yR3xcKQRwj9MkBH
hDbIa4QZIEtQx+Ln3Yv1N3VGvx6lnZr2JzcLLfc32rLo+PSA8oBD6I76j9yCgzzR
HVfAWkHiquqgfpcNc+ksH4XOwW4yGUKWyTs3KeNVn573NBJT4G2PsMYtH9vuhaDg
Myi+hrFxferJYyd5UN4bynGaXWCPRsdVcskZlBGlhZj69nlUDUWbjIX9MJEip64j
L7Y7jVARPensWQo9aiEMFg==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 7408 )
`pragma protect data_block
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
7xGa/sFdH1f8lvBaDpLGmw==
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
gociqG8pD9XhdH++5iyW2oEsLudTtjoZOrAwNayS11pfT3rn+3ce4ypRsYyMIQnV
M7GtGppmtphZT8sfUJbY5BfNQCcXxGYjba1aP3qSgvbpNv2KHBbs9ZeyoKLrjVwW
4p3TzdUrPEx7Xd/TZA3/WbXLPPwt7o0TFT8np/GX2E5BosHQjQzeC3SVXK97vkWz
pw2qwqVjLiZr6P+nV0ZEa5Xl+wiajirr8BNaGIIf6UZ3GVaDgPcP7ngcsxCxFX0M
d6WothQe0RIPOT2gaSBrw35oTmMXUgqInVeQbFjUHDBNjPoxPv0eawcJs7owC7nK
iaCPlv3gl3MmxivKHMyfWg==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 15952 )
`pragma protect data_block
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
HiHJrCAFcgtCGw5NQcEHnw==
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
njShn4CGhvNOZS+5zGFIA02kjJAppohIK3QE/HDH9XKghiJUYcga2Mezo8Z+AiJS
Hg/F/AA7Ae7khhtePzkLjD+YBveuIQAckWUelUW9CyIpC4szLsH2DK8gFUYEcgNL
9idmJsqeCnfCTGYCJBuGfwY+Og7G1NO0ydXNBLZryyw8M+lfPscx3qeFzEjxEgNP
kugMdhQEFqEX+ea3OR65CPBoKK15g5M7OTg1lblKoGuQzeSs5XA87eT4IePyxLpI
7/eBc4G9hNn8nRjBtz8pkEmBVRhpR7Z8Aq9nBpCP9ID9bcHwNRumEuVE98447p0M
0vPd+HNIKlHG46q9n2flpg==
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
XVmOaeFmqFWYSZAFwfur47+uI5byySn7zNOD2Mtzzq59JH0WuZ9auzqA9iY3HM74
ee/UCqRQU5dIFmkvcb5PiECiGlSbgYGAg7AyuyShOehmtartT4qxyPu4p5rvJHKS
HgrsHF9uUlZJrGblXj72AoujXf4SG1hIBVQwBNbE9/Wny4bwvUapYImR9g27pgSf
SAoIXuDt2TgX2xD5qX1LLsKx8PCszLBhvv5oKVRICREyD4Ksed7nKAxqRytg/REw
7KkyFxky1SipxQFgO2TUpf9ptNI/xPYfR0mxof3KzctOTGcKQKkLoNj5CPo2gSCN
14jVI+XMb13dC3WNtcLehg==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 6160 )
`pragma protect data_block
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
tWh1jAtbKh0a/eRu6UQOog==
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
iFq3V8n4D5noZHLD/6kTaODs6C0akIlGvO2BsnWK5vKiZK1HMAucZM0fupQbctrk
j3Be28kK5t1XhYZKlTTCMjlgKSY4oVtfbu8OasIspwmJ5gv1QHfs7GRf66vy31dS
G4h49nes+baSN6dUetZ63VZJVAcft9PLvbFtjZa1giTmI/CHcMdKzkFbQLhc1iJ3
o70S5KHn8fb5jrgsjSZ7bjwsxKXvfnIPUI1zZFW5dl6YqDlvWUa8ZizCl0/DXo3v
8XlxY5D2WpGcgVHRrKTylM/NgKqVUtv0zGK0f6mq6RRjHBm6zNybRdR2gFzo8nwQ
GrYfm3sZSi3a09BRVvl7LQ==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 3328 )
`pragma protect data_block
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
iwD3LW43uot2Tae2j3FdlQ==
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
kNw5oiPW7fNP000w5UdXP6rkWyXTQc5EVWjzW/B4Dlfzq55Y7KIpdBffTV7pXFr1
4Jog3Y1tNpRnBMnKneUHD8ABexOzjdbsYlyieB8psFs4+5nitS9SK33vbHkqxl1K
reQOGbyxDcy7+ZZDosDUnQVAH43+9g8t+T8jqx+yIySpUhTTEElHjlfE/lKqJVKE
FVYyJkYXLxu/YFcI5KPTJWlNNDgqF/Xom/6dAUMbSzy1ZeguB/JLyzRNN8hRevq9
w96iCv1E4DxS/l2Cg6wa6xL8AivFuWwvm1TYxuzmfKONr+30juXZtQrMSVxXF4+5
Rj2SgS7emSOJtBjmImLb/w==
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
Wv6Y5x+fqUIVSdKHAjoUiPD+qOMf2lmG4E1za6yJVYEDQr699VaqliupD1PfgHAN
5qJ0gwj+RBitMxOvEcsP2liP7mkwbmWFZFhoB4e1RvAa0WEg8c2KwqyPNSEyu5Gf
+al+fvDbBgGCTz2ZAOG0gUXFIUBupnd7mxCVEsxAzpsajR/QBARI6hTqrydv9xUP
kldv5uXSnrr1uitsx5Sp0zX0io4/eEZ8AeOXlYXNvHprAgvW5RUvASTk1O6pDNPG
oHxQqbztbj4XWUDc0yoi0zoV8FXJ52OJq07fr2Uo9UuaJiHDojboI0pU2wDAloWW
gLU4cP35Q2N/ejrxz1GCJA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 9856 )
`pragma protect data_block
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
MhxouHVOiZQo811bOVOXcw==
`pragma protect end_protected

//pragma protect end
`undef IP_UUID
`undef IP_NAME_CONCAT
`undef IP_MODULE_NAME
