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
`protected

    MTI!#uE-}II_Z<sJ*U1JrD;DnGT3x5}D~T5Z?};-5*Dkrr3\XvXzm+*o$zXnJp?*Q-r'uQx![bwo
    }E&w$C^[;W{uekJuQ2Qe.Q*X!rUTee-Vz\_iZX'Y[3,s{As=zofe]k^}\WBrG}5Ta{*!Qv2f!<7u
    a'U$zmV_-rI?Z<@ro>V]u=rl^nJs]3Yx?OkoI@553nEm>sX#w72@zj+s|k\mXv?-nAn2[hO3xU2O
    ;ur!\EZ=}^T$o2BWCWl\#[l~rx:l_Ox-H*>V:m=Da1uv!!11lkC!A->Ym<pr~'sw;=m,sIU21q}J
    =OeKQ7zGX$_Jn3I@vT=53]1r@OQGeX$m;KvmBv1UDDReEG$pV2D5inJYQ}H7}2kBK?sTXQWl#[^O
    !+mEvm-^AUxe!^ms]lmCJ3u-VI0UDip[>>p3=3AEOwRujiGRr~~=mxv|t?='kVzB2z+V?]+zTlle
    kC<=Rgw}#jYn]~#E7T2p}u^#!*N.2{H!iUmw2]wvjI3{3osT]DpuC{='ieajX$aV~n'oYWw{wUUO
    ]z_C&2_[Jr;eDr\$-lx^3=XJJY7r]ziJT*]ZX>XuCQe~elE>Y6z@3nnUT1QBz@05A<vlk!_n]Y*e
    R;#i1;?mOaU:G7Q<[Qm\ZO[]e*+C:m7=XKp_sEI-kUAAQWa5{k+URUOn[Unn1BJUn{}[*C513~rE
    ~Az@{WH'#eH5G;v{$.u$2UY~UB0*>HV!+]RB@WjUa5,^H@^w,xo\}+2@v;#Xp>CKBToxZ!'!+]$p
    ?U'e*!ldhsB~l^Rxj6'>n<l^$lBKYGvzB1+5\zW]~E>Ia7:keUTBl=VOzY7_O<+{&pH\33sEGT=K
    v!hG3VCv~]=>+x^$+JQUrT$YK1<'nnIqV-'Dv'KY,2E+:CC,}Z7AAVkDG,7Br;O^5-A<oe{+~?_x
    Xs$[><OV^jjZDpi>Y7nnrRrpIrDXV1*GReelX$s^'i'p<+=jVqG.\1T*[>BG}nAe=uoO7nR{fCiW
    r5w2s>>=1'l$R*FGzE7\THGK57]Cpes-ROHql#smL\p\?.e3AC*Z[un\-Bn]v_-Tmsi1\=,]n1l\
    7~^z#+elz[KswJz7>7iRaCRYXXOwv-S7kE3eO,uzs'-[2CYrDi2{v#**3UQH]jHXTB2s\i\l2*{|
    D}<#?D*Or{-V&,!ej%X'#TCz3?.K1HOU}#,?_7r;5X,]}!}R!s1I@@Z^K2;=]z~CzG$RxX!{,kIg
    vs$l,T1\T}-,^;!=mX>#wa\RU<<?*GmH]D]+1W3~^<7eBJY;<nz^#$'}V]XI^7#kARx5'*pimGVw
    vw_=vRm^rUD]_~QJ6iA1]-Te[!'0{R>Z;[2UDIA^#r\@}1YkO*[jvkx7E~~s<G@EqO3Y]eo}ixEV
    CxS!Qs~/QX\w5=?n3zQx^<{[Bm\IC-~}E{>{zv<OplV#:S~Vi~B_$1;r=3mBi}n+jii=a$3nVGja
    {?rHrBzk33-'^D}2{V2v?<4e\X~6\WHABRG3DUBo'[iJ3UYua,EVB@>[Ye'G&IAW?'23{C*VB*^{
    [B^W2]kRQ,Gr'~U3C>+2!GXQ@x_=^}O+[4yD"9K}[5kO,'Xl>J?^mw#j$,yY@e@M\{xQ~VD5"^-*
    #o'Bu[z=slGo!XX_!]YvE7#-Zo7=Dn=WBKjk~O*K;EzjuGv[25mO[,p;Gl5Oa<]AzZQ-x,-QVNY;
    nEo@\>9er#EH1+s[wjO*Ze,UeoQ3pX5Z-,o*}vJOBIoN[3'VxTDHv<(TTQOf_XR=,en'>U*O7ru@
    JrpJL!nREHC2QJ}Z$uVHH$2@rEwA7,EplzlmkC;!lnHOUXI\aYFX$Q!D$2<#OH^&*ez_UpvGGzom
    Gr3sA*Eo^lY,;r]GBR}Wo^R{=-lZC_1[G+3!OuVz@7zBr'6le<jp;p$\GzT=o7_K=~Oqs%z}jlGv
    GQ[X<#PlzXk1{Ks_?V2fP,@wZK>j7^+r?a$ooy<skw4E17KR\\Zzm7@uzB>>*-GQuG^|Q<!^oOQ~
    ]}wu3UmV>[I[[#3{'HvlBKwj'^I<F;,u]<_#Yu\X@IsG<nO'{H*m1nEYi{>7ECOr!VI5w9u_nzJO
    1Wh7iYO-]{n\Pq(EG7oIB#G:pZaEC,?ZxHATzoYsG>'D=[D_Bkp;5[\V[(^{-#[Vs=@5[m^l!5([
    f*n>7a7sZjG+{VZXEmBJ}u9whW$<@$$OwrsTY'nXK'WH>O=R_-zswl]'$[n^zIu;Y$-=o?{EYZX=
    -epZ-E<YWW,i[-*#e7f~wGrg>xx~F"Vu[!CUu^[3Z>eZ}'%}F3Y^l)o~J}Ct(pKHY&l%l*,kjmZ+
    ;vY7TjXpO~BisiAuH>Y<R#,#w->wYZ,j}eu_-^m*ax}^Ei<]pTJO]=R#elk@k'z~:?-75!jv>+a+
    keG@Y?DJkx#v\NI@O+n{l}e<_mt^p3TCkQp'^uK*oZRBABoGaUAH_=aej@>[33@3Uw~CWmuwUpo\
    ;Cv1_=Q$~uDmHRY;H!wA_3,Biw!DV5!7zl^,EDG}>+G}R>kCX_@KpW=ErYJko!vp{~=EQkZ\$V,&
    ^K2eG\av(D=okw'Q=k*K>-l-;!7C@>E<3Nj[}K^Q37K,za+^*\3'3@*I=!9U>w-rA1K^[jxHe!RE
    Dks>r-ZM=HD{ZX\TOU^H_YqaT-xfn=CEKj1^3>*^Gw>_(UCalECvw3Te,_#^]=llvz}o1}~!ErAC
    2BAO^H6{s+rAri@a,kYQUDi{VAQ*DG'I;C<aj*33EjWZsBk,jw2+<$,};Wxw-{>I2Vm-pYY\TB<e
    RpUeoUkW{<eP{jIUX{};2>UX1WYXxUT[~Br]oKVv\IX'JsuD\snv\T!m[++VZ7-?h~V!=ue{?3Tj
    Ev2KzOX[;/O1T_Q,sAxi]{uT5EP}!YaT-$i2oZ-#BiXr!wpl^-@NBg^V2\bC;C$CuHw'o{+pN][p
    12=[JZ^#pCl;K}DApEQiJJLHw\\wBD=W<n~k-~3#TxX7}DXiVK]*AZ3I1a7>e~axeY*v]pzHaKK#
    5{z*[+zz_[nORQ,M?YD^X}BJ,*?KV[[zTE^p<[a!NvszpOZ=_4?aB3=HzmG3BVIDUzW&~5,jhoO{
    rHelHZokU]jlz;G=+p7XI>suQI55AAVS'}O2Voa][?1[kaO?#t_\=7f*iK,xJA~$^#TTvZYF7=i;
    5n>'}V5{EO*Xk*x@<''HmaTp_2J'IpxuV3V<IT+XrD+<a[E}a*p'D^iRC+AKc7EXJQpQ^7}$Hx3J
    *[#Rx_>O+1T\RLi^};@G?UUXeWzRCiK^UECKOr;I>_*,=z}ZTCEW3zd|}2A56<+7XVvA@9)!n=x]
    TD[l27~![u$qxvHXk+~r.}7kp=W-k=}n2[Ql5B@peA[z3IZ-'<[DO=?~XYEo#WzQl#Q=ps-Ye8TC
    VDIswoGOG-lW^W,]@x_H>[lD1Ua$j'?'oWNnXUKW}zC;E$is=Xo9-p,5v[u?,U$BURQ5ev?{+DUn
    Ib#j;_pka*l$C$p{<BWz*5pXbGvZYRaQp1!,\TaH=*n~~k5@XSEoBt$\!'*<!YnXK[Ge3?Y[]_Dp
    aGTG*xB$As]u\r#C<D-nj$']l@zYj]j<,}5w1RUs''_-21~OzuQ\I?$Y\lLl,2Q1*9!j[~Wa[iEO
    Tw=$;HPj=asO@~kzCwn(\$rK^9DuKrT5<{RV[DnjOJ2}Ralzj@1J!z^Jz#B~YGN_FOi3[,\aIXA[
    ~[!~V~BWR:s+lX,R!#]e*YYz'2>7}3iGnOsv#GnV5E+HnlUY5}g5.a>{I@o[llC!!P:uV{r?peC6
    $a-YiAT\l<D}Yaw<SxAA=D1$COXA]|W]iWlXpiCs^V+sT3C^DJXUpJx*#ZU}uJ?U+^41+liK7p{c
    9i1*X122n~O5spWD7+,maV@C_e1sw<l{xaDjU\KmR&VH3<B!]OA7XJOB~p5K7AI)Ys(vWHORi,[^
    H[lO\U[xJG{GTD?t
`endprotected
//pragma protect end
