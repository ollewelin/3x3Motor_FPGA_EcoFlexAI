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
`pragma protect key_keyowner = "Synopsys" , key_keyname = "SNPS-VCS-RSA-2"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 128 )
`pragma protect key_block
mVGhPtPbKQxY/F7IdHz/0FrKYH7CnAlXvPHxwE1h2Nr1yJ29fI4YM4k9pqlMCWT3
Cmv4TBWHXaYob2YnmVAXSnUokvonHfTM8SdMg4AuZ25Ekqt8w58EhjVHnVzZxSNz
xGz5dZVSdniaG1CqwE1nJSmxltG+NU7TjOn8gqKnMkc=
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 12448 )
`pragma protect data_block
xixMBaCSS2lg4NKo+JNZ49Oa8f090AZEdJPi249YXJUMPViykfdYhEMdzJG/xO+j
dEzpXl6bTT4Qrwa/LBB+5nIrNm7DXFjJ39razwpeLVlfbrFJ/BJTfasfZuuFkNZp
2hwpgVHMq4JGrfRWDfL8nF0NIZnoApL4c5tmfJFrELhscXUG9E6fRkOZdO8tZ8ea
IRHKPsTJD4Cm7aKWoAJNq9Sy1rA2uJERSKSskdIUr6rsdbUeaSlT09LUVLyUNKhk
UqtBDwZazKBIIAU+FrJhHhi3GyVyG8PTSIb5f01w6j0S9CZLaxmvb2JXiKED65bD
A49AswZH4PQSMiRZwvWJ3LxzOOHT532HwnSZbIIji2dKyoA3umHf0Ncl2ITz/0LM
5OYsYf/E22dL+3VV9zirnEs+CPgmDG8uZj55PcZ1wl+w6NOP18qJaIhHiQj449er
Ek9RyGjhy1j2le0qERRY8YqS5ZrcxLfyTjf8bhT7AjLw33iHyk28oWUZ/BTbxAVS
FqN8sjt2vQHaW3gGbZzb/5s+oz7ezoimzJ28x9XVnVxaNedCPp5Vguwu9HORzHTG
rji38s2Im07Y0Mymxz0f9wH+qzgeLlGQQ7POtmgv3G1mIk9j5WsdmJRwK8nOZnPy
/y8D/3ss0rVuE7dFLZ+Hj22FFN1nHUNPQUT1Hxr6B2JLEIKoXMCnFDQ6H05osDYu
jgR1HyJS4/7S2K16rU4Tf5rB5YKTkRP7MWb6EK4aHHdIbXwgpKvIJCtzXiU7NQ3B
oU/TZE/pSd/sUijE4L2AQ0MsdpQlf87qwZi0pZ0ulPlUOaGEAO2UETz0ESRChkV4
j1ChcGBKuIBhEXeErgn7oa2sQMW5lHhNoQhaJI9BtD1X4PpRNEF77MoOhIAzi4Lf
h9Ip/Jfw9PgJHAyVvkwGPIDCXdLExUo+exDas6o+bq7AwVt6LDhU6QphRn25C2/3
Uy5lR9Tw/1iNEmjLk4zpgd948J7s3FiLiG4Hp1xo2WlTs4DgTLPCRzA3qRCkEL+j
61MF+kNNR8WC/L7m3y5rAy7d42tBNeB87y8tR4dpM4mhq0t1/oJd2Rn9EsDYum+9
LAhQr0EWSl5LBzJQwxFVjxSESy0ajJp8mxqAlTkPZjX/ohcR+dmpFKQ9EuR9ry9J
VEm/HmUy/fZqz3kMplOIgjtvfpjAelVCZSIFj0MUfzVtTS+Kv8gqNmoSUQ/lmc3O
BwfAfgyJxhf8zbFZ/PaRxa9GTNz71YGC5+ATTF3W1CWpClHxhzceg/3q+Xq1noFc
OSu4cKeKP35jwUyYZ4Q1y5C84gD2nwLC2AoBYpWAGKo2b0dcdV4rp5Pq2Mo1H92Y
8zCGjngjdERWY4AlZYiOvcq8uMBvV5HYP/sWRtAp8wLm7vyZDsaYpJ5K4B3XPRzz
GF9bWCSWVcDVX3ymCv4x//BFhwttqa47mRyUtuEFm5QBLD9OJT+XZ8rIGGVw4ZCn
7HrfrJTgPEIVn9kUpJaaf0K+VA8dvsRzxBFNGnfBTDDHBXGswY5MZzAR4P9JU4cf
05OZl/f/VpSsfePNzsnrgu9TJvDW+Z2ClMWyrJmTvyJJkCuXfbj2oyj1O34/rDHd
QtOqiq3xtrIREiuWnXnLQ4D2GsqIov6ZOtjbGQhJkQU6VIS1TPxBHaRtkIf0Qj0N
XYfvPJM9kmrwZzcAZHVBwlyMq9fla1Xb0J5Au6rh818j2gZQf+jt5H/N4Eu3rug6
xHnAM/Ze1bQXPUMP5M138jlSLPaZVfa6imrc5s2hptNJAesuYC36uqR10bw3l5lV
Nfnt5CGcPlcO9RFosmYeU64HuKHbozapwmTGo/VV/OL9qcRadqZWvE6AnBiiOBLx
MUjC6QbdnCH4im36cniUDMoalOaSG6HD1MHYNBzTWSUaBeE9hQX2XNgp6OI4uPrT
Vk7PJvtaanP9n8VHMPBOKzvf0WM6r0ahVMwCvi/SdkVwSsHBuy+0axNG6tO5gr9h
VRpZgBPXkg46wh+V0ModrwplePKbWqllcEx+Bm/7CpAnts1IPl1VRksGZsbnyf4O
6hFxA5Wbe5VGesOYh0S1ebdqoNJ+HYsptqZYUZZA4525tSXdBT+6XVupQWvrPEe/
etkmuEMErPjJS9fUJMzcq08Oh/w/15jYe7g+8y7vKF+wGU/YsVGwUHZohqMOAnGT
B4jotVBD7T1u94O+KMWDcJtXaU0/4v9R/Y0e1+u+ti8BXDV1T/G/OsWNunQeW6Go
1Fr60sVGTjW6fPNkXMVRPfYj+ZL25XkQ5sVe58OI30IRygG1g089pSafmvMvmOo1
ALoliNaCy+/oCpOjoi0XOCPKiHFKtx7GOLvucJ40yZabuERnzt89JfJuTut51uGt
SE3RSJOIIjsAxj3pFzrhNauqYr/NOeuyu+dm7HKdi7p2nkEjBKdq9aJlNQ6+WFnT
WaoFsE20QDLYiRlFsm5YyCZ29L+AbnDnglHhvYXSVNRUzuDnhy9DXNiBSjGpwRl4
RJu+zJ66m8fF7/P55GIA6QhjYSINZrWTg5o+o32U8+g/kjNgzSv/UPkBYWF0Vv3O
iDpofeopzO78TD0jzbIKYRdTtymXLEgfjpBAgX3xOTX2bNYyqBZXExQNEQmRgswx
01wwGqzSuA/p+OAQMt97M5ziiTpEGH6kgI5H+UM8WieHUWaTgiyw+5pwx1NPIdeK
M7vW/qbZnsaox9Vvak1bG4vQU8POHCKjyK2fAxvWrxcjweHef3+fL8PxDEl4GP+N
1bGe/dY7JShePYVEthcWDb0KBlLtoji+gQF+nbH+E9CEGxYbN9Szm0z9lpnYnQWs
bwwT15ag0Tv/Vk5kDQGdcDzj0n0kg73uFM57VHgtSVUq2MXBkhPpwVnfQfsNqRaM
NB29ofeC7K5oZP8brPsAseSm1SvSv7NIoKC842fOBKPIwUEXreSlnMBgpaaS1jx7
FcuI7l0eqH1byeBn9Fv+nDQWtFEVPxy1KKGzzUw28XgmMqb42VTbuACN3KYxxlla
vIhpMgoOzaWWhP2vj2xzUEVB4UR/eGhVajotZnssWrmIbmBkDMQVK76egR6NwwD6
vo+TZCi8hB2jLjvBDdPl8G0HvFiR+qBXmOmT07iVuQE5x1B4l8McQ8rgleS5vWoM
WLrBxK0oeVqLGMhIRFiW8shSAfvZ2VBtsTv+v524vk0szk6tXyEPF6ECwvL6rLt4
760Wxb0QXduhpoOXw6eLR56ZwvBQ5TwQa0lbCwZm/vx+OOwGoBDWbomZ48Fwa4s/
1v4zmF5TBVYRdvcjw4DPh6lrEL4bGw7G8sj/Xct4mPq4kiLtJjO0bg/1RFbFNETA
wUqBNIgZScRdBb3rexrXsytgcbTlna5fgVktEsqimr1G53dMw/JsFsRYauCrOmhp
uH5hHZyRxrgkxwPDn8AD1SztmZHH5zmj4ayt8vjfRgsnDC4yewaAymyy8Tbv9tMI
XfeyoRmjIPk2yxTToac8YknF6BhhIiOgZulmLWl8TrZAbJbaWbEjQwBFB+9TfUVT
1WYpkueChTWkAY7WSX4XdPNCYgZUsus7qYuA8NxGODqaaWeLXkttJPX0mjQelljo
K8DWwoXoNjfgniwwMbw2mgRUIAz59mtc1s1RMqdLAVBW+2ldrVU7aTecZxqDV2Kh
pSPkkVLm3EdPrsjBe58BEpCXg9IPhK4+u1mptmAeviQW3qmA/qlY3oKwGwcG9iDy
LLHlTmGWfI1rnzvVKkI3OxsYrX/4K4iPuwsaNnqlmD1v66Xy/QvxlfhKzzgJCRyF
emIcji5JEin2ikfFJ8ezNZguMK9OHDY2mecv9C0Nd8IvguQTUPbnlqqh/PmSNEPc
YX9kzW6pPGqc0n5lFI4Qqu6Of02h3r3rxsL0adRvUfgN7goBRjpRw0YJ76/12RWq
eYsjE+4OKzHEc0fCaQiNWn0s6nhgAvwIvbYcioQixRZhue/ANvwqJBZx1NnWuJSt
hlKfWm77S1GE+bkiO8i+/D9ur17Xaor7jzzYa2XNgsW67mXx4bK8cZf5Ww6tpTDG
lmUSqr2c95PlZl7oEyyxslw2r1O0tQ0hAOU60UtPhemGTSvlTZeB7Fa07TO9Hl4R
sJfeOkPNIXeiEOb/+SJHnKkpvtoLOw2b+wvdvgethIWPNjac+Q6VGblWONd7Qk5E
dlSrq1rdFRPP3NMcx0GDJwUnBLOMqopCOeNmmB2gfQ0g7mm3YfIpyTEth5XCWQlp
A0tur4OpaZ2Ut7Bkms2yxH1dfThMdJAabKHnWfGIQs1Mcfg45/XuDW4BVASUXNnY
Qpp74VDpz62dtCVVUQ21JoF7Sp1aZOy9nyFQGvwUDpddhXHqO68qBvmk2HfITb8F
tZBg0j4PmsAcLrLZZh+79LS57TZAV6libY0hGWDfBthQ3S13DLxBb53NNdEc4eKa
Uv9Ui6q//wYSbzNdvrg9YVg/5ElhdSH2pOYbQEXGI2/e6gY5LSq3rJRHtMOfEW6z
HMT/osZoSVNVvbHF55nMJ+6GwFqc32ZZFR3c83ppu7jj2CzOplyC1X+Ks2gHosk2
JWbiYRToMSSOALd03BlTsv9e3VkncLGFsmNvDEt+az6nBSZCqJyZ11AbIPAxiexS
WACg3nu8cUKdVVRsyyWOC0rAKiA5iz6W1bUG8V2tEesbH5ym/YYSHjEl0HSw9QJi
U09bt1v1IEkV24KhdavrwBAS0soiaIuzasMdNRVbA9GuDZhjHVSVgNQnsUwlTtse
pLbVQuQHKK29nX4dMvCXXxJ0l3bkWWCdZUycslm/MDn9xZsKvkF9S3pTqZ0H4O6Z
Ngnh84j7uvEOqg/SHbk1fdkG4KYn7OfCF9F/RV2GE52FyUs+CZRsejF8ppnyvKPv
wyyXLvBe0tjgF6crJ0WP5tQzeuLeijI9itVD9xNvP4JY4AuLZB3yWlWjlZjgGjDE
alEmM73Fho3H1xsE2z1Vmbi9FmQ1364AHFLQusOxSEVhmU6vEsfPRS0DIy6FrqUt
FlldVWsraJSoOHHcTMapW9MC3woXgCAlxiyOzeKIp2Uml8zGksJGHr6KgQqgq6gy
OfG/TU3gS932HTQGiFJx9L9hW6H8P9uIMJHjIAls+etV9H4ZCs4swyrbJQChifnQ
E1APPsHSXLWdlp102YRNXeaW5R/5DMUaUQkLh1mxfptDBvTHdXAYFt0kZzqGfVEy
wLiSL5PVTS7PGr2bLIks2oSbjORXTyVwjk7CWfwW2aX/TC+FI5u2f6xbTTiYFxam
OrmdynIIXzOJds+QqJOg23qzoz4rzla+4/CEjJbTq5f3ED7z1kgzXlgSqTxqe8lJ
vLJAuazOuPHyLcxgq5njC3WVUjmJhQC9vGywgCXHUw7/YjV8InWaLdXi8aFJDQQZ
PvQr+xPrZv/XwutRDueyOLYeZivVc5sESy0TTvJ3G7/Qj+IhXBybow5f4QebPrH0
twQcJybWTBU5BnVS4rpe3MGHTHWs2tRowpTiqDNf2DynnZyN63A3wDulwGxh0aHp
6HnCzUn2Eac0dzeDe5YCv4DkPT5041oaHbO1M0ut8YI6edV3pBFHR0mf+RGPyrcw
OQiZw7hX5WdZ9qla64iD9ixOzx5G2tlnIRiUJruTWwgTHU6/O2I695k5D+zh4N5Q
7onpPZggrMQG1UgJ+eBj1A8VVA3/GL1MDLjX/YwTcwmzSspdLrn/ciZ2wTvTmtMQ
b/2e05D+ersmzq5dPeM7oA36oMrm9LFIB5g+9h7SzLpY6QJ4FgW6+X1AhO8k1gtV
74lDmvbjWg3leyIYDxroi+5u1bOLuEf4EodVZWKqDoB4l1zzcomx/6PFeOxKKL+G
glU5ia7EAJ2b0Po8OVRTNJu8020WegQbr0F2SvpoooirCwojlbwEMDtKMxrIP5Qp
OS9weY5SQLcS75yh+X9Wa7KSAixDFWd81ZJRvl55heQ/21i39c1gFYiZ8ObGjOpk
zrTxSZ7mdvS1jEDGXgPj3WPWqPYbH3ibtilMtXz0LBNIl8sRC6G4LOdwwSMvG+3j
fazZaOkllxUeL8liiStz02A2eLS56sXcvqAeRC9LV+vpnS0S5pEIfu1db/Qf1FKh
xb49dPcnS+iHV+ytMKsB6OSuhhBPGKNcGDUFM89zabyS+oDc0bfd6C3T7EtJcqjg
Ds6db3Q67VJ6DuYuCXy+J6nDj7j5mYFFNuPt5Q9DjMKkradv2NtPDJp3Nif+PVdi
yq/muV+NIscNDfZi3aqiqxoDnUxUYFQVri0VM7FQTPreUKXrOaxQ2lREd5SfB7re
eVlgeyrp3OdzGYsTkeBTnNkNESpBnW1QKyRETefbK5sixvmZzXkvG66r0xnvzqW7
4od31Pmp6WrrWc95wunWWVlquKfoEhphc2z8FcQVvf9tbmcqzw6ZqATi9RMMhsdg
XaJIm+p0uOYMw1ZSNx+lL+jCzAirl3EKYfG6FY2KLDQ1hRMohD69+fBTQvi4wEYx
bQ27tAo1dUraU3P2SdV0qPE7ipPhK+y6jxwVXbFcLR1g0TQMQoodyD6bU1+qfuJ6
Ba52dkYvMsuExvXI/3pUnb+vjgHuMkKSbYGcjo7oglntoTcnHgxqGCaGT7CNrDSS
KyjxmNYLp0FCpl+5qQrE0r7IsKXDOjhxK9u+GXau+rzN8rS8zE9yKF65iRzPAwFY
bJ3yNwkvtN306CBjmOrwuScjw4yxYVWbeUmS9O6bAQFbLc13IbNZUduKTNS7QRhb
1VbHd047VG/IQ3NbcZN7XT287HiCFOPE3zFDPY/DGmy+8LVOfV+/vwbuj7s/rH9G
UleU+No8sQcH1g/89/Dj3b/6cxIEgU0EOIZD2TNpnx1xrPDFi0epWAxJaOxyWTEs
47OJ+yHrNMXDVA38jemMXM6dUf6BLKkyoZ/wdNuEg/lAyGbmo6cVn6JI/RE0fKrJ
Br+e9jaK4qjZSD33w4pNg3LAnQugx4BZl+OG6J3OCW2nShz37I0TkJ0yDi9ZZZZj
3rrAfLQDH5hnztSn+cflGqkTgHO7q6Mclqs3qn6ULpvrsLbtyo9B2XQujxxgPP1N
69TW6psqqxbAvaZ/4TAhhRyJum5hDxqn9rjnr1Qpth29UfKz7GdfAo/wpLRGb4+b
6YdYEzJWYKzMYNvRWacJq4oVce71X6R3LeUwUQGbYNMPAo3P8hxxUfXpapaHq4/1
45Wuio6Bad8l14T3GZrMnbjombN65nC8bncDKNqjKm32QM+lUhxCOMh8zp07Mzoz
Xd8/eltkU7ZmVxs9dvyPVY/lc12D6kw5f0w/8FFhcxegdePAbNUkYufdqb2lLjKn
CM9uIN7XsV8TxWSMOy4O6rpMfFl85h9Ne088lXRZQV4hXEk65F3vIUciWXjelZ/M
x2rwOtKIEJwaIlwjQkf6iUcmxqddqcForxQIlt/k08HJjgiS5lL1fJ/68APMz+0h
RUZ5KLMIy8knvC7j4H46jWwTndIvdR5FTWU9Ck/nQrLxWpGqgTGJLuAVK1iq6kmP
bCaYYq/bDG8XEImFOICTM2deabM9E6sVrRdDgPMK5K93l7w25MVjS+jRZjWk+V9X
W6rS8qHbfzR72OdYMmrUQ5tMT6RxAhMVdDgzqD6AzKCXwPaS3UWTBeFt+eL0FV0p
7ytzZY7OJ9g89PANwaiy21WQlwDYpQL38jyZqAV/xkKJyQnCYNJ7ekItUNGbe6eR
Vl+I8zHqfzNGgdfvBeTXnXJmhVuf61vdRAoxewwyf/ZXmoakZiarlsu/zLgTDvok
BbW5wexis9/JNxwmdJDU8BReU2l/UviSE5hy3wG1GC3QtWZFT/WHmvg2f9DVDDlh
+G4y+vAvxdU7e47ylqkPfOHAMJ+BPb6yj4x6wQlfIAi364NgSmrmmV5cfb+0FPZs
RO2OVKYUc3ulpNzgmxTybYvS6m8VAOmMv5uXT9ROrI80vLBKx5RcPz5H5ogF4rrs
mvdd+nxFFNIC+dY9SY3JkLCcrfbEdGJ9Yd6nIrOJN802PRFoA8eTkDftpmV4N4OO
wZ3WfqmWjKvk45saxROFpwRD4j9t4Z43q2Yz8yAddslfgx9rgi1Hle1VjaB/xyEp
vsYCh9k8lubVJ61qzvjFOpj4Thm7Ss3k5Kcp8MqV6b4xvJGvSS779b9ztUqV/UTv
oTzmUho4tXeuboP3f+4avZxSsDbJJOervQDgTFLhGn8w23oxobg9bhSkmNqvRWp4
pvzjB/kyy1x8roU4hGiPx0t9qSOwEsJTMNZXjVVYExvUO9Esn6JmIaZ7Vi2WPlLn
EV86WVeu4I4M7yC6pqAGt8MeaelO6NMIuMkIPkV302/SEaOn4xo5p4Ks9F9h5U9j
ik/Oj6VvUs3hdn+eiRT7yFdW+qsJlVAm6t43m5HsnZ/39FHdc9XhNrdjf1wUC+mS
q7HXQNT8FRJpIrsgeQo4TSJWu64HwkjMUZQNpRw6mpTjzSJ09cXL5ZlmPqxB2Gti
hYiOKC0ggm8FzjyiVZC3Go1oOGfNTZAt9A2RmtF2B7WvvvaTP0Ro/EwAX7ODrAt8
dvjqxhJRIYZ1dRskyfeFRxJLf0r6xmmxrnMb18Rw7DsFEaRbUPL7bC54rrh+qtC+
p5ilIew3Wxij8Cne7a2WBkNpUAyvU99e8OTpoTcSBwEyV4oDEvIYuXpNlHbbhz+S
FJsTqz55URePWDtfeiG9eR1k+1z8IB79DZLxaApIUO8gA1Axs+BQ9S7miVa+ny6M
PFbadWQS1HSnNgLIZ42gZqHOaWHBBy6RDRS3/XEstGttgbc+chnyAIhjVfyssQne
EARGvzZ0XmEDE8hHHXl1bUWrjgaloiLVJ/Gr+ByeeEYZ9FE9lOKhvEYLk3t/w/JI
VhMV9MDx9k9VkXR2OBO+kNncxxuakuVBzyGb6w7fWl4LL89vb56q/yy31HWv1L09
IFEJ3QJ3T8cemOgezTntLRk7oA2BL8hSlHDjL5Qq7Drq0HtsgCrnn1ESNTCsvodE
UfNDiH1r6uW9hu00HL/3Mea5pY/+11fFcBtkpf7PWF4w9NKNCNSYpAnSpPit/zSm
fQDcSdAbOQtaE1O971ATAMPx4sviLRktRZbg78WO7mSUVC0pO5STBcE3S6zh5MF4
NjBCo3rqmErG/Xof3ZHQfTl9R4b3nWRBKuoGm+NzukXY5WIxj6cuGRyLEQhWsl0B
I57EehneBOjLDzg3MOS4UVhLmplEuMTBzUv1yPjBC6bRWm7eqRDlNhedpN/yoJjV
Z/uDlrZ0Pm5xFwEys34/EIDl60S2LDCCl+sJZUw7CdUXt+zPVzBJgeav6RmPBtNK
oc05AcnsbaA4IlNt3WjlD18Wm+R/PO4TIJGWu6KCu4pbQlWeFsW2Glm2afNwe1Sa
keLDDWKKuJ+dTNCs8x2YoFK57UzlDB1rcfrFhafqeh5ojm0EpH4CuVeR1pyD2wKB
DJJlR4HvmRh0IH3DsJg5NBPswOK6oOxIRfF5NEYyBBrth9oAaqFoUKbMU7q0eRnz
c4A9jCTfOaZiqutUTGhDPUhuaKwBdZx0oZsV/0eHVSwrFWc6XofCFkwV364/P0Ju
iVk1v6MnuZEvaI+UnFWv8GVXElIQ/Oq8cVqnbeYEet0xagbH53fpIXDvO8hws+TS
Ybx3dDfKeBdlml5JS5V79178OcUEjk26gYGZ3yChYxZowPmyTNAjrV1QdtPFY+WR
v8ENbGfpUjjDqNErLDBl5xyhsDOhnSjgquVyGbbjcQmz13i3e8e4q5eLt870YrOv
l9WFV0InZ/klZOxqGhyIzFofJRB5R0g/cROf6AtNBLdZ0uwe/+nhyhYRRoId5oqH
xSL7y8yiXVZWiE+Ehnf4msyLze4CtxYmwWC/s4v45L0V6IY9fT+Ral0CIQ/GXaV/
CjgQtOwi+W86yljXr59kz3XIqhxwYmxBagD8dyrepUqR/KW3NEmcvfb9eQdG8+gW
BVaO2ibrglKie/pzWpvZYykyfreE902n/YbIzwbrIcgCwrjkOh0eBPqdkHFCqd5D
gYrFK9s16Bec58n3ZPF6lESl/kxKaQgfjwV1wxmY92kf0xT/MYhJ4eeFTQddx3yW
bPNF/LvlazgStRtfOjyZwdwi/GpqOpBD2fls4BWwmVy4ppOa4K8EdSO9c1fvP8ls
wRZuwD9iaqu8Irnr2yFd8nKefi4xvp2lrbHT/0iv+MVzaJz057A8LvSCySxVc7cT
PrdDxAxjVem8C8uidGlOXGnOwMgQqcidd/FZINCxvdmHG1LKHIPab8pQm0MzStsE
5QIqGqAQAT/ZgWM0qmbI4QJa7TMjfoc873BLrtNo8+I/ymbmKXbavVsKJYwyiTJc
i/098dJkvRYFNozMC1sEkScWJzm0iBpJmeYWECeRcr7NBHkV+QJC65phk2U+cttX
I3VRW7NbQrZkk9v/sNeClY9eheeRE1phJO7SR5/UwvjRsl+Wech4Bql+mygEcw0j
qQozgAwjp+e/KD6ZHrH2YrysT9PFCnRDa6SK2MBBH9Z4p8xN+wY0rPFEAXtA4SUB
xz0jlFbcN7GmRJTM3rCb2HYFt1ioUMq+8+i1MamPCr4CAPubRV39XPE5JmtHbaN+
vElqBMIdRzkOwn06ea7f0EuwTc3iOSY6Qev24T4vVlR7B3S9ki8EXEE45ex/RWWe
ccBqXCxf7Xm+wPNIVaPtZ07PzpB46tbPoQ96EMLpqKXkdlcDGd1T9RdwrUouwqGU
OZWV8ndrf5Xq5/0+BnF6lRbfOfS6amEY/QNkipJ54ggn3wC/+eiYnxgwrnHUkh8o
taGh008P5xjgpN1TZugnnB+x4fbDcZrTWmog1wC8ijp/nkRjCpi2drtM6hB75Z9v
uqZwJ+LUjnKGWZFkIf4s5lz1jeMQoFpd3q+iTVMGeYAEx2KNrC/t0wVhF+Qn65cg
OhowZGAuSxKPkWxjvt0doBWYqzqMmgDUIf52Ytz2yzGm27RBl/bXFoPb6TxtJYOe
+nbbB3OI19hKYawJyGay0t8S6TAZBcZtOcYI5kDdHhbh6nYZqM/FkybOCu+D5Ojw
WcdlN+7nfzW16NWYCtzTnyOuXZDuQl6B/m8Cqn/u+qNEmgWMUELcohWdOi6zaYbm
mZhu1B0Ydi+k84eb6EDkNsf7JCwjJoZYSJZQRKMquirJLmVmb8gTRCHVRSDif622
xMXQxmLZLrnl3ld1mR/eQm5wPHREzlDMYnL4FDzCyap/BTltWf8DB1kU8Ikq+tF/
htekc50uCfs7Y2HJAFDbrmCvPvLRKJ5wNpquAly3LmW5upTAwWfVuNQY5ae+/LUw
R6pailZzuQv4Buqwm8KzpT3i2p00h4AsxxZ4+uaaeMga9j9MinZgm1SBm/7wyhvF
VSesg03+hQ+aFOm/pWeVHkY8EbL+isca4Z2Xps9zN/BNWUY/IfcRAwJaXqbJbNOx
KlfAWmsyrBEbNrVBUMRd9VpJAnxVAjyjDNnhMdSseDTN6tgFmIBqddHRCFqy/OZx
NtjaYW1ZAopnv4gLtFU3PELLOMSNhXc7DV4DrnCZtWFSQcHx+NKDkzp7uUrvPmxM
fSXSdlqHBgnen1Ef0L4Z4sBR7FZUloLAThZ5ctqMg4+BZmq3ZJOfM3vPJnbxNFgM
xThhQtQwbLu75j4SHGaTQWI6onUDHFlDB83jduVo2kvmG8gYenF1LB2EA/pVHD6c
jHo5+g5h4n9yOnfBpKGwZgMDF5tEifhbMWinH/hmUeDMlkXjEwAI9JxFY+C0zfDO
W4w0CF8bXwBnKFAXfPA6gijEKGhd58l60Y4M2IvvExnGhEulqwo8T22X4z53XyIY
3TJ/v1WPWUfF1hW8At24RZOSKdYrUAfj2+SIbrxXeLL1qGTQ4rDB19KlLGML6jYC
SABQAlPpZf4X3kGRJxawX1e0qgk+CKW+Bj1lIPpPSTiLytWUETVzmFukPNw26lqa
X45DK5apojtFxh1oV5urNeTsFDSa6MrCf3I7z3yD0fEVqZ7hMWN5rumzqS6CxBhf
rB6yRrUUE5EzB1Z1AF40dAVkXnLQiyto5Z4EsrMmwO9QGmo7hHAklTIyRn2vcjpC
sGo9jo56dGE42UbvBGi6uGGnHC4XmGC+2uKShv9OejlCl+PNr+l4NupdrZduReaz
yLtcYSYFXa3PKjQ5Zeyf8IlV2UNDc9qIYSHN0UdHISI2sPkqq4CWRM0QcKDd9R6n
DL3NxYftecHNAhMcH+qrUeBAf0p1ikMx+NFIlvb5JqMS31tBAxCclxzo0LQq/kio
c0B8U4rD2EmzYWe0/of2YBDXCPIVEcvGPqHvw73h3GYL0YckFvgolbPWOj3+9hUn
P6PaAbsUqWn1C3yt6eGHQsy/F6VHLBMmolCJq2zbA8eS+x9ET59PLe452yjizbj/
HuPpieeQfySrS4rVK8vW5Tfqw+Vgi5quvC10Rrb+E+mLLyJf1h16yvgmIGkU19oe
q4nlzk7yxPTsULUeRymNNRhWX2D20O2mulOMumseGMcFM/INDalSY4I2UGocOa7+
EYlmHS4xDAFHRR7y24uMK1c4yFf8yrfxk4e3v2dJzmgRhQ6JpuRKLlGGTmbo/KUV
W+oepjdbcx/My+V9wW/FQoGMicK1txXKspPgMfu/OFdwYjxv+I+CEU0iSnmp7MF0
STiaksYIECWo9OvOAsVMlYZP/6MacPt3/IZTlq1UQCNTPnt04xI/mnW5Y4n6ARte
GCmflsj9a2nRiDPqPQPl+D3sjIoiwOouQ/ZMYMOIfuZYziylpkLXeZ36ZtG/Ni6z
Fu/Mw78q+i+dAAB9wNXmtNZ4lKLG7l2WQ1MX9f6fiLC2je2arP0Fs6Vbzl4YwzkS
ThRBMSyGpFADn4GBBwpQsAN0M/inerSNOB7mtbmC9s4eb6Sp099op4LyfY/qehHA
0l0HYVSf8VVPfKLOD2coJNAIfrzLD718xjkU5PsdjspbEc6s/lkdrGGI+JEdF216
jzycbDroNnsUMZFSvxpAJVjMHIDrUItjBBMc+DBKpgXTf/w77HSjYzhr8Jzuf9ub
zdsqVSPJBT/eIE6sqv2rzmS68RYl9daT/sykQ7jZhMdyi6x2lkcJovHOYz9KqwUq
YtuYEFb2w/H8F6bnjZohGk6H2bhXcxO5Wqy7sOJXSBVrvSShHc8kMQPQGczA+jka
G01q5Xe99H2NqSGIr8WuBf+5izMdcgM6QuE72ufJJk3ndiJGIsGJ5dd6HoNu4Gmb
TYu0w2USB9pMLqxKtCvr4UqlxNGc1zBWhCeZItdiQ6DUD9m9bGiaUQE/XlOnnaPa
oa31B0dxpxW5AgrRLMvQ+GjS0ebQZmhGMzg3JctTDTf9oYButFK1EVHz3+srfK3B
AH8eBVObHXdru/nBHksDRpgi1I5GLFFsSR6SMaJYKhQAvUJyJcSoC3Jxlwvq5g1/
5M0ghvGCWH3Xp43XtChYaznp8s2bkPYKZ+0vK4500caCsxYdFeyesbWZUeqTnB18
hM1iJ0qGFQABrv35czvCg7suZbmtEjMvuPIZqcjrfWYcSOn7gWEKQ1IVc60z2FS6
6m25xJ051BKh6UCwQEs9A9tH2q7fQqSWrmwJFCOJVVXzO1/jAI0rvnZXdurRRc6A
WzFjIC+x5F8KEddtFDHJ9kDMed6pad+a7r7wTakENqGjrmNsEQDV7NchEJ6TjI70
Gq4W/a9/KjE77wfdMc4GW7lOR2ZZ+Xh7NoCz3J+aQ5Mytq794hcyJsMy5URF8Lh8
RqKjsPMKiVnQQO+VAqxX2kSIaS+UbVS22gE314oTJWyllvpMIuxkVq9EMCS35IEe
oXCZhRkgeIW/2V6lPen9gkhgtLePFx9EV9sz7/VonjBFOHgT5z8dCoSN+YOjAcb3
QnEnmyKIobakBtYOnRUxJylKhRkpPEI2Uq9NECRXnvIqGKMmOlWOCwTlPrHIFIp3
s5wy9dStZy/Il8mciijM83/xm2zd2+GXAF0Env8/W1yuvnIJZT3xCt11nYFG7lug
vpft0+a/CP9UwDEX7ppguplWbhbq5OM7h+ls5mtpNCxcTaUrTk9rHNjVXKzgTocc
NZUq7URtst7H2OiCNPhTp3N9fKwOgdiQr87KgPRlt7mpcEL0nXh3f7wXTbp32mw2
Ylq+SD3efKepipavM7DuBDW7RvHA4Yz+LlFLzGx7Y7n9V/9McBoJFhfMxP99Tjoe
8311U7hFgvV74lfyiBmct1Ct/X20wYP5uaQz4Z+IZHOvnx+1RAoaTA++RCfoxLX3
DVo7XgT4WWKT5u/Wd9ZICaPPSqDTUbbx2WZy95O7jvXQT5dfCUjlTIeIU32Frb3n
qGMUuRFGtzMj2PEGxEaL5eUu46ologkEfLRenr4nYEUoJmHt5Qpns0WsRpjoptjm
HxyHpph5/aciF26xg8ppfivjuOC/sw1vvawvS4HQEOkz+0xvsCAHKZTCaiOX0gAr
NLl6ycaKXecQ1o+nYl5n2ZVQdp5jDsrf3FvIDlvVePemSvP00t4HY/SlEySAT72L
mNN3m0+cKKYredytl8nGUIiHj94bp7Fgu0Z+vhvkS3VVGh6TTwR27SF8Zp+LD1M+
+ktx0B2zzP4CgymZJgjz9GYWIF1xvYcRfak1LCN465Q+tDlq0rGBDo84nDwgb0Hs
6SmwjCwkma0JhFAXw+IE/aP+xXcDhowSG1ckW/aPzrddV5QIqmCchbzAcOSlG5Ww
WD08YK8HsPSdEr2711a9+n9aMzab8CXXeQaBe4pb9pAYzFSAOaInZCx8+z7I2V1D
Aa5QtSkV0ZFr9Vm6ii4mVGSxXaXt2phmUv9KSXKVNHMh8SsrIT2O1XZwIsKuF+DK
C+L3hhPVNV0vKdT6HbkeW8c6eEfV2n0IhEyYXWLn2MPOGZommoKCMnq7v/+BXqvZ
325rDXR74AXPZiApGRxqGzEH7vUrKA7Az+VDu077Eujdq6KMqW4WKMGHTPwNvfKB
8pSuezf9dUCkvPnNFKiRKILHwXH4XRlNxLvMxjnfB5QMTPV4xgcPCd+UsupXw2Nd
K3F8GROzmJcBsAY3XkLxE8jnhp3fzhWqLFJ4y0B4LsGG/HlHk9e6T95jUXtXJljs
3hx38fQkV0sZFv6jkm/RzjVw+/rB67DsJhcX6t+WFyMIVN/we6kB8B4hhbgsCfM8
ZP2wPsd1OaitG52zccsClJ8ZZGwLNbChScQOdd3DIk1N9iuWCbMxHNjfEp75ukwo
QF/II2yCrEmxJ/h4o6spKj8g0EQEG3D1GsseTLgROkfEef8w65SHTYQ2SAFsofTN
Eni6pPSxOMGQmdayFwvgX+UQb3ytncNRRDGuw3QNqWhLTPCDf2tB5UBkaHvTFoGy
jsL6aBv5BR7OgtjZ9uX+GybimgHK8uRxd7WCmewGD/f4uzla7+jg0+Xge67WQO4k
OQ00JT63dBu/4b3Kocm/nG2AThERnc2FiRPyS5V7w5pMr8XwFxRXkLwUluEq4PId
gxoJ3suFjtjseuPoJ1c0kzyWY5OPfsV/OwJXfYef95/DXYyCe82uLdYF0Uo2M/d3
86scIHW/yjtX/bYf41fcKr5wrGpgTEVQsSRR0jy0dsZGld24QjyRBY4MeOctJbfn
qNuokV5fuYwmrVAh+CWOkTuU2cGJZyi3b/CimxZu4mYfzliip80DyqHSBcwXtJd6
9oNbkl2yidcsTyz47kIXNB7FaQ+NxOC2yFqdPBxdcA3XsqawZkWM6y009e1obTtB
dxxQOIYUeQukPBn4Cam2VHFVf41YUKT4+6D50Th813dvXbkBAJljrjYy0Qcbk2Iz
EcAJYNKHLkLxDNf+Ke8tjYK5WXBrmAmdpRykzFhhgB9RxvoedvEzIO8piT3SkRmR
OCLht6q6TmWtsFNV0cAWkGUajZQ+NL3l98tBDEhRkX3WMc8GbERVWZ+0pfV5KQAf
kGC7sLjbVIm+fd9ch1+FUP/FqysVENPra9KiZGsJnpZ+nb7atDyOcKB9YvwkADC5
5YDJDbAaeU0yjlKmIa1ewwFgq0ct8jPUhbbFcE3LGJXD6jKLPGyerJUGXcwlDOSu
ww7dGcGtfL4DHMwC9VQxarXfzp2dwX9xz6cpauhrLLIianfmnWNhllnmmeRU4wZp
6fQfSCURrf1yI4Q5RM1XDusRmKPkPxsezQZO/unkDJe9FeTTVG7fb6TPZEbD4wX8
k8LuL5z2/NpuEuScQUneJohvj2GbdTRAXSPN6sTaOHDhteDO1+tDFRaIRKAV4HaI
3CbpgZFpKcl+ysz+zBs7yIekikdLuZdKDqC6+9EtBtR/iFZspMcvVBXjOFpgZZvw
ftDdsngpOWL6mGiuHDs/LogpX+xQMnbcRceX/kBpmdieSGoSZkxn2fQWMkuRpUPu
nAQ9AgJ0l2Z+6jmXgX/WtWvjEWMvJFf6vFSPk0MLuxeI+jFtRLMlwCC77jfJqlDw
ldSF8tH+inrjHFHRhUfV+MEzcntALX8jjquuQ64xMFDdH8Ku49ziiYkmkFWUGG6o
vBTok9l1Tffecx6K04U9ounn770Uy2mxFQFzLaKkI7UCrvmpJYBt52MvDnDNT/Vx
+YloYDxBPiPkw5IJ6YZ7huKDKFIn7Vbh23pp/pKvMk/knh6qhEMPpvlKOlsI0Y5b
fZ5q+JyieihMv3c8Eh1amQ==
`pragma protect end_protected

//pragma protect end
