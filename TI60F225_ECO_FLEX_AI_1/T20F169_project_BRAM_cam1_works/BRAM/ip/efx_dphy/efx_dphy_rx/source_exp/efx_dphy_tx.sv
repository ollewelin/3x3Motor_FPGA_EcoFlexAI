`define IP_UUID _dphytx250413                                 
`define IP_NAME_CONCAT(a,b) a``b                                
`define IP_MODULE_NAME(name) `IP_NAME_CONCAT(name,`IP_UUID)     
//////////////////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      Top IP Module = efx_dphy_tx
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***************************************************************************************
// Vesion  : 1.00
// Time    : Sun Apr 13 00:05:35 2025
// ***************************************************************************************

`timescale 1 ns / 1 ps
module efx_dphy_tx #(
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
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.1_1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
cBIuqq3jN36ibdl6zFA90vbn3h7ZYMP0oTymqZXvcc2nV0yx0tIfGAorHASLj6Nm
osIVz4hEkQs+1zCO7aYEkQgSfJFMBCvUmH61t7gcIi4XumioPkZyjLDbEgnoerIh
c7n4+7dPfdy52h4EWW9Fqv6x/ooItdH3HeP37qBkIVB7y8aokJJsQaXnc/+YrDQa
WHN8kA8KXTPgVzh6NvwxFSN6lkr3SceEJt1M1j5rEmEfvOkoHc806iCYXaI30FUT
RVZTTpq39NMe0JOQMACC/f4WV6JtatZVlKGpfpO3pkvd4/D3KlsxZgPk+5jGs5EV
fq3WbAVUUL8j/ea9s2yzyA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 6640 )
`pragma protect data_block
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
xL0SW61hFT/6jQH51O83Ew==
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
FP1H9jvAct74ZtfZofPLzuNB64KBH2runcIDSJ3om3wsNbebrrfupqHZZQJ+aXEp
VBMah0v9tEf+nIqm61az4yqFwpphbLfAotqg5aOCwnMqKZeGVITUKGmwFby+aeZ+
xz8hpFMKFyZr2sATKEk619Ppt8DgjZL76FBeyAuUVfcQhhV6TJ/jcX+HviOJrc98
PjPrKZnCHdQ/Y2j2geQhNKpb1ctWr7gDeX43jE8NHkD+g/uyihcPdilvVOn7zg1n
4+K9vqfa6sZiJDZMw719WO/RkYOENRieusTFToaZTzyzMCDeqi2NDrUmxuMAFSjl
F9u2952OQGi6L0g9HB703g==
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
a0G4kwcZ4zhNEwFEQcEZikhGX2Pcrbj02xaDS9QzbLFVHOE+JVYOyTAflj76aH6O
DJFWTN3+m+BkPvtOF5v5r/8E60DPDhJM9QwAT4YPuHCXhBhOToUHE9pi9n251Caj
ec8R76POWjDp91PHsW1K0Ptlp8SFSBJcdEt0pRIwmiHwujlz3rjbCLnnQ0b4obn4
apDpYs1UL3hLjTV9JNSr0i2HRsjcO7LDCEILfsMLLxRoGFyRVM5pcF+apNW4Haw5
lRusPtnU+m/0LCFgz0Y3sSoa/jCqyBnThAZpBCfmOXEReKy9COQAyZHQyfFuiO1N
sNZxvoxhK5eyZ30ov4WSAA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 832 )
`pragma protect data_block
Nte8SU4tcGUP6HSwb13+Qx2Ep+uX3QN/gpfdsHfu2GJHKvgI1lud3B5JgFjCPrK9
u7OI5Db0Dx9330+P/Sca+h1qHqPz8zyP0fo5bsdS6aYAph0vgwTU6Yx/LF6uHqis
Pe6PPd1I7a9OFUw/nv4ufPnK4yukiJm67HtgZsUXa8zBa+o4af6iRI1WExfBd/I+
wwZkyujXvWOxBKcMKbbibf7g6c+Y0exDeAu/tbbGlGEfJrIGKiBevwOcBxNFe37G
2z3d5DsbZjJ85Iozu+NlqTYNP9catxyt1K/CeysWByw9ZEBmn8BEzdUdg8n6sKiT
yC1AY1hnG+BSQFnQRtXkY7S3JyuTtw7wONSvN9rInJoF0mP+1BStywdkR+XXchRf
oZGV/KiTO9lE0KGGxlvJb1Z33MfCT5RBKiWbrrNd9ktd8g+9iY5+hVADBn/ZIAi7
XXlLRNaZEyNz/zHOqazBDxNUZM7MMXivk4Ni2ODFwGF7KN0cMWE70Ea4vVVXB6Vg
XsXKcITijJiLfxX0axRi6XPalSZ9zCASXgp8lei3CG9Kv7sT/nSfwFJryFCIfoTa
5881rAzfGhgNbTGJvHRzyUfDN0lkFkcBWsECoFOg2JdTXgN4TYrd3h0FKB+PheUn
/VXgfyT5YdNA6l31EtK0EG8c+HDVzSLkJPPy/Ci90aUyayBiHwhhnKb9/OASRttI
RFwIafpC/1x+/sdj7OmAkH8aMzW9LkTMdXoPOBFYXUCO+kSTaHPJm82MfI+xFWr7
Qc+ZbGBC7e6EDcTDPa6dSxg7DXiSh1cQwxaE1QhVYZEXsmyJYxQsJOTt+B7gi50N
rklhdmqbcUy6wkp33yNeZ+nfmUmIpNvm1qJUsiS6OJU1+VnQO4CxuV0jn0+eRCVm
xgwz47dBrlg6j47R1MDQwW2bpJfDy5x7MSdbVPbvPvOfaGC3YNnFELzte1WQrGM3
+jPeThbIp5ONVVyxGNipsH6ICMYve9r8EO4cEmJ++hu2VOIvwtfLaHiBiUBT7ZzF
8eBnA+3Le/cJdRKRqrGjYkNJKHGGFudmF8ZOGSZ+ksnw/fStnYXQg6V+7tnB1LbI
pX+vntqgwrDp8ognMuulyQ==
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
iMWWesb0AULy4+hw3QjaHuTHjWx+O1VUJ66oEgXAqaKCf6GC6qWK3HyqSpGkb4rY
rQtTbgchGotCdUxA8dPNBoN7jJOOWbk6DMwikPhcLLn4HSP1SOOABDPJjX8xMAH+
49LY8hDf5qCxLN2SbyXi6YUZtuREQ/GTOTLxrLW31/CYQoacgQc5cqpL14Da2leB
jbGHmwAnpnLYFz1GIHg3bbAdt+daTNNuc8DI+2CHHE9J3EGbKKmeby4gdsY+1XJJ
CX0EIP0jfZ/H7Lb2mDHPFFwKCi8YxE+/OwW45WcLlusNLtlCSskjkFtkwP4DO1BK
ngfFlCGt62GdwcqQeLH9Ew==
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
fpo8I7i4se4fxaqOZLeVtmaPnwjA0nHTuAyAHkj7rW67F4SKbGFJ32ZFUHwDpre0
o6SDaVo9qspz1xCs24VJAJW0eQDLtCdPxI7IPpxfrShbJ5lV5ig9atPKI99blyoo
dtd8oDrKk7Li/mynKY+cf5q7EjaXFl5PhwWECz7KTPS5zum4yeNw/2GoC0wuqAlP
7DXmbLBNd5mRHWOaHMPj3esi5A+DgRLqvThLlRmhDTe5Ee/8z7uJqG+WUMCSeqNB
rdkvdqCv+6iu0QY1QIltbqCMdHVMFD3jwIVHwOVoRo8giPT2tneUUK6THdzlrOV7
Si7Gep19PFY7z9eq+198Qw==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 8800 )
`pragma protect data_block
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
DTRSdIruak81xc7Qlm5Q1g==
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
T1HXeGajuyew1q6CGOdRVTs9mhwzLtySOBD2wGYaQ+qsgpWQXv05X/mrlceG28BI
8AhIaLQQP/MFdb55n5gPoSXfHA1wGvy7W+OLsCBa6brKevoaqQTENLx8oFwttymO
uCavJ/Q0RhjwPuzEwWwS7NtYN/34/ghzO5sgdSFhLBJ8fwL3N6B26FH3Vpeo+ZyW
iBd/goYyx9glkTbzaCAgT11QotNzB0soZ07CKsV2z/lSogcm5vfdL1Bk3SEiWgE7
guGckTEZp1vl7C8T2vf0LXVUMlHekR0uJnHsDd2oIyaqCT3dZrz7oMq0r1zfNbQp
ouLCWeSLGGP6mpyRoubo5A==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 7408 )
`pragma protect data_block
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
hDua2OlhmHdSQClQm0pgSQ==
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
I5sadIm9wvskNssJ4sDoyO544etcNxNx6Wm1T3aUJu/ckuKOP0y4fUqgw/02MLPH
znPp9SBPLcgSjK9B5Kkpu/KRHOumrAOfAUwvHumOAsEl8NAPp51t9IphixvWscx7
HrSwcLVaWpeqWhzPmI0OA9ZKSSR72itevjfGaNJFNAz3I0aSyqLIwsunyZl0Xdfd
4F2OwfRubGNJcRH1ISOQRT0fl10nZSVJ0MCx01jKCUTR4R9A4ob3zETfNE7/5I6m
EhPnvZecApJEJ8xsd/XKfKuMMNGX4QIRrfEsLW6Q0ZMAaW2CeUwA/WIfYFIELPye
GAIYCibHgdK2DVTcBOUMhA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 15952 )
`pragma protect data_block
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
AU10RJYfsMU3QjtUibDt9Q==
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
UFzH+fud72etD7EPPAdXSqzD48FE4CMUGu3SIo+r0McJ3j8J0e57d7ChucpEIqgO
qbwrRTL90hDUkbf6ag5UUVeP5aUwpNfbL1LC7Vh/ZstGGcKHJKY5lMilMVGpUu2f
aF4st7Dt20cGuq0tol7Dxd/gfgLz71HSLBSiRxsuUjzXwOWUHDkrbX3KKpo3+duI
G1bpdd2lqYZjqWXQFiYePSQy9zX2sBVMPnz7D3SspA/Fh4ndYBRiHVroYKB2wfhu
KAsgQHZmTbYaSiplVyUar29SSH9WxsFXqsuN39m75c8w16Tzx2F8sk2JZp+bDVAe
1zYOUxGyH46V5h5RO23U9w==
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
CnlTlnluI6Rsu/Ry9HemoehgCLDcldtaBaZVRMH9qitfMJFPzh3VFj4DGyU7JURh
TGanQRFBBGx7JmPzsLKNuIZ8nMeMfXBcTD+/aOYtq24gdXx7LUGYRR8XDUk0fFww
wu91ztR8G7UoCIrN+wTHz/ELZ2guMMPBdtS/w1Xp7l8fU/z/a0iEzryBveGMX682
dQhsCmtknccrk2M2LxEg/NGQtQ+iKtLUOJuCvpHS0KI6ROVuNO1b7V2LQe2MuItn
/XibIGwgFwjXrg+ZvSMLM9lNTe6CrHYSR7HPzHU2BL83yaJKp1+Py80j+V/KkyOX
RO0j8b+B9vrpQ2Vuik91qA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 6160 )
`pragma protect data_block
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
1YEmBi/d/q7xsllfCZYqNw==
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
iQsthM63pyfZCBewNOKYxZNTWb3YFaJc9afRL0eKbx/b7PnjRBXs9tJFsrAi0Xde
HA0VtqMmU8OeYMN+mwUUF/Z/idf4Mn7oYJHWk1ZInQrerILGXsbPAn51I9Gp97jr
3LGvwBlh+0kZ9qqkelVzCqsdZ5FGZKJzHisiaJzRd3VCcPkO8plA7BgaUwgmD3lw
8EfXzQu7cBzhRUfE2kvl1ChleA1k16dUuDJTCoD1xV6VfoZR6hPAavQUza0agYm5
7O3vlecxMmBL3d+tAAoxmftwKXOnsypkfTnh+wrnjVw+VNTErAGHqryJ68GbSGho
zY/8WU8qqnsAkPNWjVY/Lw==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 3328 )
`pragma protect data_block
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
u7nBcRjUXLRGywUAg9KvkQ==
`pragma protect end_protected

//pragma protect end
`undef IP_UUID
`undef IP_NAME_CONCAT
`undef IP_MODULE_NAME
