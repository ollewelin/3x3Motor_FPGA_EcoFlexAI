`define IP_UUID _dphyrx250413                                 
`define IP_NAME_CONCAT(a,b) a``b                                
`define IP_MODULE_NAME(name) `IP_NAME_CONCAT(name,`IP_UUID)     
//////////////////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      Top IP Module = efx_dphy_rx
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***************************************************************************************
// Vesion  : 1.00
// Time    : Sun Apr 13 00:05:09 2025
// ***************************************************************************************

`timescale 1 ns / 1 ps
module efx_dphy_rx #(
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
    input logic  [NUM_DATA_LANE-1:0]      Rx_LP_D_P,
	input logic  [NUM_DATA_LANE-1:0]      Rx_LP_D_N,
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
	output logic [NUM_DATA_LANE-1:0]      RxStopState
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
PStrT2XSQUwhMiziev5wQmCULmyHSXA7i5PE4NwncP3KHn4CfisOFV9mvTLSegSt
F7WYNo2HkoVmD8WORcbeHSgHUNywvo+7/QP87Obu7w7k681r7pJi+jthCMXkuXTB
VCmvMPlQ0NpO3Iq/bVt8M3J/9HGIICBJv4JoqvN+a+XTWKjF+TIxrL1e4KzwVP3g
9PxI2cu6MLl8G0W+JxbQujeB0EfDuHPJEkqsJyqYpvQAnuK1MrNCflpbTtfISU59
wd5ddCda7JCVD1ySPH+3ALpHX3CbqnbVyYps7kYKRg7d7C28wzmcBmp+TRD0LuXI
4CWAenqfG2MripEeWRD+uA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 6784 )
`pragma protect data_block
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
Rwj0vMbhwAdcmqnBZn5Pjw==
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
jlK2D/TdlXcLRxgKw/3mpOG9zydQRm6F3Tgt07WxwOahpm/WdZr4Lzi/chmaEuoi
Oz10MuePtNyOT8DGVmXev1b4SL0MLpAFm1nBka/CpEi/bm6eVp+QASYg3h+v7+r7
Q+blvEigdYHNFHixp+3Jkq8Rrvm7HMzqolvgY/1z8IgrOuDYrtlhLgk0SNDsM5tR
YNgoko50fUlpiSR+alLNiXAEwM5h8i+iZC2adxLzfZ2bDHZe+e8kqW8iSQPWTwRD
lTtlOP7d6LHT/xh/1jNKawe5lKSHASAEeefHL/7LnuoGUoxRaQwq+aeDuN/AhC8W
CxU3Nn0FuJ6AeLJ5AxVMQw==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 6336 )
`pragma protect data_block
YxXiGYWL9NDnBDdioNon0wXtKQE0jbAl7RHYfD0Ak2EaL3LXfc6hcPVXuf3mGcd/
9utmQANDxAOTDBTj1bGRiJ+XrK9WmUUbXKCY+KqsX5/fqYuG9oZyYvtDXxfHAzjH
2W4pPaEIQjoeCvc/f1+MPW3r+rIHJeeBN5FdluN5yQb6R9SSqVXEOPogEqCGXsUd
YNO8UgNfE6gLSZrQZnHtY4tfXxPklIscg6edFp927N7hlh5ZQ+WqlsT+WrDnhHQm
B213Jz2iTTAeAbpzZ4rr18z9eH4036qFrLMN+VuEQDokAJPrmtvIRtVVDp4KWcgX
vuDddNutcVksTY0xaJRBAsVgmLG0pJb9F1yC4EgYIG55r6mwXfUWBYyBG7lrsOly
oYWp3/6NErVjB/tz2RwGAJlfb8x5VF1oIkQu+1s9MCUfeRVknqtZyTxIMtVBCrEO
jU/GBhTxGp9c9tuW0zGnXhQcso26BbAKCZpm7CVRZ06gHFtlQQ3a/rGLGnop9xB/
s0HCeqFAGQxthWk3zwIvVvRR/oQ4Ye6XkgJ/H5nObi411kUFNrEuLhj4tKe2N5BG
YR4enREjEKXUgYpbDUq4MSmbEziUWYupR/R4Z+YZEfBme4Z9komzg1F7BQkUheqk
3QYBUsjWLoqoQqwPzQgpWLHRmm6AJ4QXTeNBmdiymfrnraZ7AQH8QLO0pcJy52yU
443t4i09VZyv0ctYg/jaOETWvJe2YFkKjR1qYlbsdLD1hRq02ikOQ4IdJhkrV+yO
dZm50QvziVnpVJfFWD+QYP6zec6pA6eIMJiGPgGy7UD9AdMBLVnV/MmELuk/bsEI
No0s4mzMtrLUaUJZLayL/49YJp+G9URElsO1uUNH9qAaUl8hyz3krQb3ciKxmIVv
2HSx8HNacjywzcrtAH+yR7nGIP6RGxx/ey3RcO/vGjcQNRl2PX49VYCF24FQFjb3
qdnXL6KpNfMjV75jBkcfpXrAc56GqP+MA9FWYGYqR0Ju3/gtPEXoaPt+fYTlyjTe
/8UtKzgvcWqlNgL4aRITHlw5a2tmmPyWZW1NCwV7g469CO5zDKHyDXGCyatMZtL2
Fl22yRxsVSMm55A8eSD55P8vj4YNMTTvJ1qpbLHQtAddkfekokioW+92bqHBS6nJ
Y+EgzVBNKMOx5o80qiF3uT+fLmzIQTOlbvjb/bFmePXB2Zxp5/KXmstI+pD8g4aq
UieQCft8msUGQgLVXZrEEvfMcD0EPLV2sFrbn9L48yg+NADsuF7OC5nKSN7TgxDM
k5GTjCoJ5m5PeF/psdX3ap/fYWoclsPo0C6f2a8fCJwbCKSyS4t++5pe+BCya0dN
pjEqwBkjSe7D1hnYlbRm9W2s2LnB2swDUAZr9PlId3DXTqMCRCuWU2rNVeWOpqlO
s1RwKeZ2wV/A1Ai+am3jllHc7Zxi0mfvJaiddg0cRb47FTi1u0hWcljRaU2WHXRN
fdtKbm79ZaBMqzLCauki85APxTz3F3BSOyVMnvZp7hpvGLgAA9nKSur6fzsKWM1t
39J5iREpvww/h02kSyKnzwcjhqw2BdOFNgYU7GXzXTtrTmPZQSB0lqz47l1Vakop
YWggjdp6kmzd6SFOZg+F9+33zIie8KyK4ViXTI3evTKDoDmko/tSsLWpD0y8cH5U
82U472zRNAKtfNthwqlP/RB7LaqDWml1Dxy5bH+WTV4VoT5lQo6xi+ThaxJlfngj
6O90qrADsOPZC5dfhhVIoj6qtH49qtvzHUY2iXVrw0YcsWfdltssUOI2GdNJstnx
g8Dcj41hq+YWlO5VAEfkUEnPQ12YnAEmtZcrL3tdIReZ7ri+vEc6TXXA0YTK40Kn
1caQaPWwDiMLJVEvHQYdyci9zD/JqWI7/zvnRHVmdHqFdIVX6hAmQOWYsgtka4gX
kZrOMi3oR7s/780vOFOFC77qVp4HbnWGny4Uuqn9qOnj/oYlCzF0FRIhrVlEFohr
jQgFOAvZcsjWDpzM61C2VCXJ9dkY7d+hBKmVONB98+Xk1DuA1I5/z9mQzLbm4hAa
8Ys6jdJqk8GpZS4L2+Cycl/t+/cRFa9QjcTILCBxSoAvstNenVV+8XWsOeJRHJ/B
L0i1d4iVKgZ+lUkpRNKz5c8zgu30Bb70jK2zEZNVa6Zd2DFoAi+G3pmU9b1QNgIK
emyLqdomN7bIVWm4j3qNeJSNvt6kF6/PB0JYwMUX0f8sZikhPiAsEGw3lHxerrU+
RV3bFa+93MQ2cbiF9077HhDo4XASH6PxWMAFLOwnKBuTG1Xub6GsuZEr0J1N+f26
5wvxcsFmxWbEwHjPHrEYQI1Cu7UZg48JXmYW6HUlAUg7sSNyeX7a9ofCwNoyOqI3
+abncNrYrXsFfFKbzGsYlOqHIWY/vNModYDIavV+JcVccyrL/2o8xJmvNzybPtrK
tOWtdod9HvmSebQG705eGxkQLvFEpVL9F7zeU9EPwHDPEPxOwulAljr1PJQtRgr1
mcmOpCjVSpp2lBfXtGaoMIiLaHT4TSgUShdoVsLu2wVohHkuwdgLBqFnAtLNYthh
B/BYGuB8QpvP8WO0URVh2jTic5hkICvT76nsVreca1w5YUVI4W/4nNfI/94rF827
w8bcA/4FhIrw7FkcnhAo0L0/ZHDz9uv+U4Y4eMBCeZTRf72AFe2DBqHlE+vxqJNw
H6mIaMHGHLroxLAS4SMl0lJqPC9xwY2FTIqnxl0daNLyb92uAcBkXwZbPrvvgtTn
98p6WNwCo4IdJeTxmT3f+m4dFpdooRkhqD2zc+BBD3LclmJ0VxX5wNzgY+YhLydO
rEpDOjzC3SaemWte2Q3/sMrARAOypNJEPulC6wnctLMGL6HowV3m2AZAPWQNQbC1
L+wFqGqu//KTdY4T8SECLfovx3TRFGOTE+b6rmO9Go6wByjZjQibjtuXKENMrt37
WVV/OCjxuxvIFH1GJJ8uqXhSrhhWfpoeQXWsbNyj+9t0HBeN8uuZaEIkrHKYDe/Z
sawTX2o2aDohKB6anKNeHBGZWsHYRX5GhAj/ZxYXlc7Tj7CJkKAk6T0nSwRJ8ek3
5mFnHjDyVgxCsIRMOJBvo2/pFLk00M26XcMoZ/hearpVpB820fY0bFra4iq3vCTe
irwhYLxs457Uk1EzpBEXF/4BytzOi7Ucmy3edLAu+/t467r6d0hHUq9y94VP3pyu
/HmCu34t2UP8ngNHN+TZByMpWcR3NdMjIXVdhWxEzpVTWtb7sWvUxmZ97oxvixdz
ctZOeHAQnYh4MaYr9ankRPaihlAkVQR3yOIoo9QAg/VEnY85vEScL64BQxxaOwk6
hVi/jZARjyB6vyY98QU03omjugN9lnjTPnkHOYAM+dVHRemLOLz6Hc9iraFEd2lZ
+Ea6cG6gM1aORJCNnBEZbTAPOiU87ZYXcj0HXMlb44heFaxknzCPJoZBLereh8lD
jr5uEEUrtWEJ8UG+5NlcYhlLdTgRHH+j76ayakLwv1NLGzFj7Fjs9+RP/dBKdP56
k+cQ1qQvb8NaUkvgJoR87LKyal3ClPI8QoUftp4ru+17hVrpZ4PYAjqiRrIb1+0Z
UOG6Z5ylqp85pOlZcamenvOfV5M0ZqoyIz8Ips0pOtwC+x0hVKSZIZoM7/QtyLaD
gBzAwSFqsz9oWVIxPICmujyQLu44B7VHZXeMg91v7iyE7zp1j/8ODQPypbGLGlB3
i5JRrwQmA8WhvtRwr6NnJbQlnDSQvyA7YTeZHJ4tiKHqAW0vgcxJ5oZxis3jkItV
JMmTjxqzgf+Uqz08mRwa1KOh49P14VwsRneMHhtEWIbuF5xniFtRSMk4X6oqrqJO
qvpQG0axXdFqmxra9DYOmF391kxe2DoWeRQNUEin/0objwV/Kpxy94z+6fubwuz7
YsBunqA8gvzlzqThnI5dRFT8+aKm8CtBGqlkHRZzPA6dnbfaFHu7t9RYGLUF4YGM
O6XtsPEBaGvEZwCKLZijPKsFIVSmIhRjynqZG+fYT9WjQOGLuaPknh6O7ZkJlBCB
ofn0Qa7+Jop1bLeh1jE0vLbjtA0fqRMzP3CtfgWwKVuL6J306Z0DFbPNrIvm7Mac
lgr6mLaehDRAVlOg/GQClregnkyYw3mQWHn5JDPEizs5kQ+8+R4ZLe+tcc917pQj
3F3bu59lwe+ijaDgOubuKcc7r5zAJBkEDUOREyOIpfCNZAmxgAfasJa7xZOHmnvq
JJNS9lCipkEVKMnNnGUKGd35OF28ilKJQF1rFLXUzKXojWSlqtOvAydF+qHzsTm1
KUFLlmujfjWXTnkVMaiJqrKppydWGvll0XZr9fqbDbCs274eye/1oFCIgvkjYImP
MzjLiWAf5ulju7T7sEtdZsfl/H39jMqjLi2B+tMjZFYUjCqum9RUiT5mGThVB7Do
9yEAUBYX5X20MUVIRhnkWXJ1qzWZgA/omU6cwdUzaLk6aY3wdr3+Ew0m5AGaKo+V
kt8QGhUB9vIDBu/gC95SIMFp6rDIv8PIWYW7dI6gpYMDzZgFoNXLMC1qeAfTP4dY
cRcfm/cFwRhDYUxHUNSeranHeKZjL0kKdLY7qz9E5FYN/74B3C6qsXs/Vj6LizWl
QTdrpyzCD845T13YWWIRZ1niDU4vp22+XG4hfXsDIRmUEoQGa4ncn30ESZnjpTsS
o/68mEoqi/vY2vpKE+Di9Xd/9ttNSU8+99EwmxLHqI8vysj+J4/GDk8v4BkbQuOe
e5MW2pnMXghA86C2pPpLw+SRNq8zH0u7FrvtYZVSIzCcJGkykC5LOVdRNOd/oC4R
mDFy5Ez4KigFwtrxkgvCvD+iRJ8wlwFTK2JWIqVVJajyd0UUI5+krosOvXuI62hP
co31kmNBiT1U0yRYiZEmjwRoT7d1KOEBxhbwsSelq5YMmdD3iF2NEAsZi8x/26o7
XHa0DNk1EiGuFa+TQ+CxA4I3Hm86lj1OpAecq5qUrVMqDI+/iQo2294cFG2QtYXt
PNV3YN7SvMFkvRME1gdSYxoJgVgvg83pZAn3VLkpbRP+60Clq0hRxJEZCERZI/P/
jZnBtyEYLQWypOt/vOXzMQQXIKmERC4oTuW/KX96v6a2HQUtZXd0ybh0utRpN+Hj
gwi5hfDCJFS2ftxInpqm/pDMrNRzPEOftz9q7B6kF9e/uzwbTYlQcF9RuAkWZnhL
7QKBOWMRdcmjy2y4MzgxYnI5WzV+NhV/48IoPv+Y1vCqk/rPZ4Ymlh4KAcBVXKhH
XxT2Ac0Nj0CfLMgxM8Lg1lAFnJ1YGABx3MkEIx9N4CF32evkkAZ/EyuWxzYl1prA
WTrxYEvB5p6EyCBOumeU+2xVJvrFb4D6kPM2kG1eFPK2iaYAqlCvE4mXVT7DVAFG
fhenz1+3tp5oSjldpzN8VMCgYy9G9gdJRsZTYIPkFBbHkZ2Z6wFiInDzFqLi/b1h
Z6BrO0CBXYZWQA1AYsyYdL3D2I8N9lNBIYKSZTIzSxtrANB6olt0BDrdZWurmQ5B
HdfPS53jdm6FKHK6pHk9keRM5BKY6Aal68EwcUdcL/xK3UiPzF90tBeSzrwWBNFK
WHwaSrr0Ymqhxc72iPwhZUJ0G6+FXa0TjYbg5VQnsnSHcagHLujdVFVRZUbI/pDE
4BgA6iGOn4iK9zxY05fjRYK7K89LgnODjj0Ke1LD2F0lvB8nVqyVmsTNOKKvzPPS
Ee+mjs7o5mViaeeJR3B7QFSUHn3Nd8ySfPYUJe9kQYf2JwrcKY00b6pvsMWqXZ2j
jHtch46qf14tzBsvEILCjK4CwcUS+VMe7d5b8I9T319t9MxmH73lpriBa9stYhSt
D182thcAC/mgkqtdgCtETySa73OeaVZh5VMfZgdgZuo06qDw5vlfF13B0JA+qhIN
XrHUo2HgaPoPOHo0k8HewlXviRRpO4qdEEKtQFimIXrns2ntnO0B9mXI2IOACG7i
MKrLCMFGiU14Pu/Pjk6Cp84cfu8NeCGY9tOBgVqiNbA+0iAHc9M7mzvG6DYUJulq
ZN3ON8351qoBmPbxNqzXd9jpyVuRXlTMcS892DOvzf/lvdbW0Ka+Au7Wa3q58iwF
pn6z4aTVT0XB0eOAriOoGJWBmiGv7E2Zw9sU4hUJ+09ycpdH7ZA6JQavy4RXp4HV
RkH+6G9QeUgytG0hH8eBG6dGbftAgY/CdTo4NQSHmqTU7B9MkJ3ncHnIX5Zk5K6d
eODQhgh6atPTL2o5wrX9LkI6F2FkIvjjeJAxXFGcyyQZb40NyWJ/m4R5EWmFpb0i
HNYg3LclMq4JH92EP6gbNM2o9ZqXTkG4mCIivxg4BxINcbQDFP1sqQEZZNWvqbOF
S42oEO5/4bTs2rncuE+rx5RXdQYKI5j/yqCx7ZBc3CZv9tIRHYWxHZe7T5vjp7Bm
F7cDqZu5sxIZErFlUPYwqltuoFNP8GW3rxtn0qnwKlE3SpeCpg1Ous2eEd5DBoo5
2y4waCu4jno3n7P1kxUn/H61CjBZZDUQAIk+Rzm2M0nHYS5+OOotlAwwTqF6xJse
wOMqM0sjr4z1ElBG+GqW1P87TJfrgIE1fQwsT62qPMAT7TFPDdfr2s+awXHo6KjC
bNUPTk2/hKxq3SPfEPaRsgctotIFvnZXnZv83jgmhIWa2g/cXaqHISQQ5lmk3r/M
hJKg6MQwdwCJDioyjtwHIYXIFPLLXI7/iCX9GJ8HK7qq+Pkf+hd9ZzhMA6GJkGCC
cZrK9Wl+hX9JBJUzYRd6iUxUTbL//0SPLyC+LU1BXaceINUAGMk+AhG/H6jm+wsW
yguRvEJKuE2aE/TMM51hga3fTHcU+smHkMXiJfXg5L+YPiEsdg2IJMgo77L6F3Rm
SVE4hHlVl+aQS6WdEog1LioeV/HAueqoD4N7HD3hCLWMMFSGg5bZDrnzVzid5p8O
TsmTftt+8DbQjL/N6KGYmUuCx3lr46OZIljJBCpQcSaT1kyfSnwrFhPgBSVuB3ds
5+QSQjyOJEoYwxKtrULZdKCcrHoYO2tofpWcXq5dg63bDqPc9f5R7XLn9re9Nv58
BwNDtClnmcOUZ51Sp3/Wiwvo4K9AnABut2wcDULB/pNw3+xx2lOKpzjnl0iUi2AN
rocPOcQ8jrUI7XMuy32hb1ciAqNEdHQh3VeO0WTYz/+/3p0mLAOXtqv7Mh46jdU6
Jks+zH9WpI9SvA0BuZ+Zv48o7SA+gH/d5+wAOlVs3Xlw7NVTAVTZYxdjkQC7n/kN
Ur/N2uKsQoIxn39dmWdrhf3R0IDouTHU7xMDEVMVW3uMtETEnf2uST+8TQ6wYb9W
4ODjVeKJxxcBI+2UopCWXbmQwcRPcO6LJ0gtIxUuNvyDBdXloR92IpnJd5gAKYtA
k5bInZesSu5c66sJUPf/w+03VODVcwayTQXtzd81knVByaJqOEfgLHgqLgnHeMCw
YqdlCHQMH6zEjJTSeatIo9OWZC1K8rBNGwkKRv7XKp2KUuosDwyCwVd6n5aYTk/Z
HAWxXJb+jUd3Hht4UyTBLQd2PhNoq3iEjqnmF27b4/1OjKGzDonpgdCESG0Kr8Ve
YMy+gG7R33Sfdp3AJj59l7xAi8CkCPYfTvTtfX4I8DV+0Quy0lLCGjC8JXwaoD5n
woPY9+tR9shrwsd5amsH0x7QG6thvFA7G6OggveSgRi9MOKrgw3Ql3GHCviE4SCw
BjbymRBbUbfkKGOeO3qhGof5QCyqLHwmSCJgXBiGLw4pBSBi8V0Htu6+EbULtj1t
h9NY7TEu1+K09g8lZ35aLKJb+6+1+HVriZxc2dZwOjWfB0qA49Gu6xren/f+mtiS
naYLD55WnXYVXlwWXJT4DtDx37IYFKcgn3ztnjWnUc+gYzv2uadbhjzB/kwHDPZ8
7KG6fzcGa24PMHijTEMgXXDdThR90qpI3UvHaCFRW98GS7pC+LlbbFuUUm/Zc55w
j7gLaalIIc00CqxfsDPGJZj7q+TdjlcobGUQk7PdgtzrAt09+0D1N3pKnfE5JUC3
Rq4wGy0sAth/l+fyPWwQDttGkuAD0hRGOf3Qocx853WyXYXVPFJc8AxV9m8o725V
DtxxYLlA1/utzbeBcnYt33QHBLcr6/9/ZIoY/oLATHT22pmSCZCMYhBkgLFpA9dz
I4ykVwoHpxeE7NGk4WG+6C+wranNJCwkAgiU8icCsuIoKMsSW9SU74oE2vXj7Ue4
cW+1bXK+5waLWewsj7XUJE3yEqqsgjyUc006apU1DgHIKRsw7ZOufxPlOz2LF2QP
oKu//V5kRuQB0DQoyfmFP52fxhGL9Ce9YSwmZKyXcyTnYHDp8/a8r2ITszfJuXFK
E9M1Y5lqOr5LSVmJihx/mDflBkn2+UkVKa3MSEFxIRELKLkE+vr2QSHyAwbd1qLg
2L8/j8cK95nKcRSjjokoq6KgWSCXyDGluDMz8L7XniHeTqsxgYzAZkFhZAMBfUHD
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
FiHyqIX/rCmXJmjEkGsnaMQ5iI/RPotf6mPw2pdms4jioVUtZB8Ye/KPzP1QYz0s
l6NHbva3zj1vf1eJDc80eERZEuct6Polu+Sspoen8NjTe57EAxLrjMAaMnhuQKdn
lgdpn4yN6ZPdkIgMb+vaev8DET/zTjyI6Trf5EyPd/s+icq7JHyIs6HqcERe6ZzC
Aw302RaSvy2yhVLWtUoGyRC8MER2gZwTiptR+uwoVFYsCbpnvjaV1k8vY0AVtCXO
gA2GS8VZlLOrX9Luwjm2domPzIX6faAqS5HOiKZXOafuVBmGzEg8p4QC1lf7jkBa
IAAl0sVhVsxIrF2EfG7w0w==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 832 )
`pragma protect data_block
ELU8EyN/sumSrWdJhegp8b+WS0coK7zLwG2kgFr95v7kZQ6QpYa+001oRvPRFKee
1YsUygc6SQ8ih/xV8lDZK3PBuZmego3n201XapzckerDWz2WgUIbtqEHU0WnXIow
0klcp6QKIZ/1P4SaHcfkciEsbDFfTvaTyRuowc0x9v0l/usrSW0h8C/dlZBGhduo
4x98uGbjC/hae2wqPEUsEPLcxUVk3MIE78+FrBjWKVXD/91N7jND6JqLf6BkT8h4
PctqeQiOCMpi2a347PRppiOaeBeDbC8h/AsMDLUn0XkX8RDhkyku+KCMoSWsvio4
TVVeIxiXN7uMgSmkXeMkbSz0KV5f9mxnSBjRHJjmqE5za3+bYjlQF+rFboy6KQT/
u9gAz7kNEci9FQDKFMs6YoqTsqnmRFkZNMtQgGatUCCqlENay44NP3zMX5rge08N
IRNm5DmFDW4lK+j/gq4R3/rhqJu5dphXI1syEdJyP+EPE6bWjDA6e2EhKVowC85n
M1NdGGgNODabKtd+RO4yvkuayxtASWIcxTC1FkWq3H2khxNyqUFnQj9Jz/he3d59
WUNDQp1/apUtTBU/mNL0N3iNc1/neK8sI8151kkg4HTzMV4nRl7BxlKT3EBJo4C1
i+El0A2HseM2UozvuwZiXsi0H+Chgbk7y0aGquV6+1c7K9oi6uhtMvDmnKbCeJnv
Dx+BoQBv/PjkQ4mpPDdytrR6Fur9E2o5Vzm0wAVHQXOzvHczE9QKwZoUjTsFmS2b
rLNmb01E52PxzEdoBrEL8/ai8g1o4O1pMwnLDi1EIMgwlOw2yVPBIj0NI4ZvJVDY
VXTD6tXbYuJNAROaxfsOnuCjzaNXr0onwKPRpEgxe1Na+DiGn1j6/YE996sYIAhx
pWasaovnvC8Ne+1UyDswrF8hi7YsdMtWKF7C0SbEzGBAekO+I1vqL1eVa3pXcT4P
sSJpG/bi4TH+9QrY5zBQVZhSEg1KGr1TwMLH4T8kMiUgXSVHtcR1QY3pnWrtdcXf
1rtZ7bUQWCQDcRs5W9hN0fltkBcwgbpiCZTrb/AK070x9oKXtKflqEXNNnEz11EU
8VzdAtucx2khrKKf7jL4/A==
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
VST+3Vk7oI5waeEpiruPl2CTPfUJPrdw0wGFGIMBV4XR9udSo+YZdj68bphYJ1Jj
vlX/FSBl+Ug3qr9ryejNoTKLg9yVM7fVpLjKPeZisbbYZRgldLUGHrMEH2Jm3Bi/
+Tb8WDtwQP0rxKcQNKW/5quGnOTHgTlaIM/NBc1HfXgUZdcdGwqyH6WSwhlJCik3
F4t15/2kP4GhScFcUb1zqma3QeDRxmOrFkBNmmEyixH4PQp/nSr7iQxr0VUzl37J
jYOp5DJl3J/nSa9VyljEM9rvb7FF6YrUt04NAnX0Zv7JneP2XshtVTOnZFKp7TR1
7z8soHDBLrjfGqun21d+9w==
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
k2utAPAHdfnrOYiW8zYIlqbAZh9pLI8TC4LQI/u1xBrRDhsgO+0St7+1nq4RKJPH
q+mI9A0IqSC7dWcTpfL6hM3icr9AaedrxpU4TUyiTtIa5r0AZtvZzp7kNAU7Tyqb
OXJTrK7hy8kl8aDjxw1Tm79xmZ6BzFmtb5f43XcQGploAf13Hbro+GK6k6XsW+iz
ogIvP64TJCimitUQPRGzCCyt0AkRqANuYh4+oU4BWgU4Yt4xDaY+QNA7KaHtN2M0
LK1NI4Mqc9mRKVinASnrrbuFrJK+LZ9H0kM7BMWNy6u4nHj7Vvw23fuZlT6OuyIi
Zjta/42q5xOG2sxqymJnzg==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 8800 )
`pragma protect data_block
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
Y7Oxq9UJANTTgtZmJrik6Q==
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
d5g0CoYQz26qzSFbvCRHXrpx6VmfuWvCLPYVyxLiMqK74M0fDfO/gDhE9cOk4jFp
2ahSK04BenE3gI8i7LkCmlwkVLy7eldWO/5ehbp5Zg+EH/VnVsDz1K5845g0JXh2
ROptlA5TfRmp+xyIHQuKnF67pNWJcWZUax6ZEhd84Gd2cXvxv8EovBCQ8gqrLJew
kZEC3/BRqOz5rwOdymMklluT7aExyfVEPHkQZb97U00g0kQhOS0YvkXkPCMyzQO8
z231Ojcds14wmkEIrvJNnj65E+7gtGWBEZcXO7tFZsARWBLPaZSIeyQn21EPygQ9
IlscCN1SzTm6h5sJdfixJg==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 7408 )
`pragma protect data_block
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
X1d8hiAARSTRo6MWZqSdPw==
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
Y8LXm/0RA9QSU9H8cUvZ/h27yh9LhiHdrvXfx2mRtDT6l0/IrAhYRO/CmRJElcQj
xWLXr7mEr8oyScswBw9j/aJAJbmEp28HoCpkOKLQ73vM7XM0muXgU58oZXjuEMZ3
GOt8AgZpJyj3LYxFp1pUMadS0GmzRyAhFBRkXipv14OoYZDHYjGifhoCrNw9EwOY
UXoRj/xiQ7eH1d+NUN28nxVdS/DsKDw5ckW1hIDJqx4+vOQR1DKkMuRIYISg47Xw
WxRa+IwKLgDCKSkncyooZlgo8NdCJip02D13vtOYuKMfWuEinofQCnEbT0ZpPxlj
12beM+B8BpfsjTA58MtsCQ==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 15952 )
`pragma protect data_block
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
RcIMzwE7yIvzwxIcNpXijw==
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
lKzWvsiKsw4XvQ1c8WPEJWPi6346yGUJ4Me440WWr2agAFCfanNZh1/8dhe/+0Au
ganhUDpk+EyJYz3+e0wkr/3zf5NI3hRdcCBO4Xx53QRcrglyp64nX36hAPG3+SGQ
LKUSAyGAO33qBd2Vn+3H6U4cyfntDM+HPPujLHkBzzw0hxeP52xTypSOiwyUjNK3
h96NS6MDZ1uaeh701x4U6ICZkrcYy+fx24EBMR2dC2/zFqG40QTpKT1HHK1TKk9b
WfAhsmC49rj7r5YWuVDwXg+YUiH2yqUP4TgqI8/FZQprnLBqgSxqHy6CTx6UNgVY
0AtGwN5vc/X1i/v2jIYJiw==
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
TfW0kqnkTBLA78RO7ACnV2EJx1aAyRcXiEHYiPEKV51ih9OuZi4kxp89Ajf94p2h
UcygbvpZ8nXyC9dupvSg70nDNs9x7DKOUkdSoJeBjPeMNfNzZr5ZVrdpfFvFokaL
LaP2bA48gw9sZ8Qvku53mkmbJa9D1y1Dha4Iq+VdFB418x6YHQqc6RS2OTx0e1Hr
snBFXTBbC97vkfUBNemPeZzZ/ZAjdK77x1ipw2Qmu8xsRXmQH4tDPqB3QAeNnUpC
bkHVGLnihZqrwIuP7rfRxN/Zbam7FojIlkruzqpamwIkqJN3OJoX3i0PSyEV2hQH
fS/aKIZ1tpFV6N//YLN1FA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 6160 )
`pragma protect data_block
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
LnmThKk2bAq86LGRm/9wFQ==
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
kM1tf6tXVyCMuclNXygLwG7wiUvzVjvuqbuxml/Adf8G/9Skt2ce1/nccoCEETbm
9RjZYOHorm5jzkano7P2IQMgh0pcC0oUMEuEj4XbBKhBx5NV//1BohqH0UL/bA1I
g/JIpJ6B21JtMevXWTFHhu3mPpjRiC3WnZokHTY4VDB31XnxaKY0HBgaKRYXfio8
sws5m/NbA3Z5LzIzjTNPUIUPbyW0JvlMvPvskgsxtbNBEt5Q1t3jFcn2Yso+swun
WLj6tHT1W1Yuqn+nCZbFhO8WSSYobD2WjITtpO1hNp+Rdky8eyJRCJCkVVzE5agl
pm37EijWdOnnKtwFyhmDBA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 3328 )
`pragma protect data_block
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
hDsNl60bXSIP7kZfumfdDA==
`pragma protect end_protected

//pragma protect end
`undef IP_UUID
`undef IP_NAME_CONCAT
`undef IP_MODULE_NAME
