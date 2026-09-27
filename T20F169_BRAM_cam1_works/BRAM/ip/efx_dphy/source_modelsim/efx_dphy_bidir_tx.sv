`timescale 1 ns / 1 ps
module `IP_MODULE_NAME(efx_dphy_bidir_tx) #(
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
`protected

    MTI!#i*jKlAuT;ARDfp1?+ep1Eor-rPPBeGY73[>N|*/\b^IIv=7Gz:'B-jf$u~3c-TW[[K3Q=?Z
    ;u$U@7Q-Xj@;$O7^is']XpmpzD!]U?>Yrb!}+ov>wxG#d'IG7,mp,E}\j;1[U{Q-G5D*#VpU;Ns{
    r{ZwBI'-'!}e-e;l1!7C#$n'X_'[}^Omp}r}A;lBKYYIr@\w*5uRo-KDmzEAOQz^eJyy@sT[x!s5
    ZQYo+xA<Hsx[Yj~k$\1\j}-QWjRpnjaQSi=;7QlTezE-5-,R-xZCUH+Q+J{p\VzNEe\I%kU$o^2B
    UERe}?jzAz?\mYu;T3Hm7QY2}+I,':lvH;i>ll}TBA=>{#5aI$T15*5<@r{e{~57j#v\?DB&Dv@o
    =n_-o@m~Gzr}OvI1\-}lviIir"E;=_$uT!oC+75kvB1,l]m<XH2+sRD1!\u<O3^={=$'k_M,$'AX
    \B1sG@a@e-x'<'<+6QU>lN9'ekA'RY-wG_jRC2,<,CW+},zY>I@a1BV![i2_TlQ!>bT${2EbkHzp
    }~mI^nB5f<E{GQYXVp5Bi[V$IN<r#A[rHw]<+zpKE__;CxzIE+\a!I)WT\KZEf/g5J9O@3ZvosjR
    Cva(uo1@omV7XG,ZVrC@7r<_7}QOGe^#KUU-;_Y'>D@2*Coi'GQz1pA}_|{r,t[ll_1HJvv^-5EZ
    @unUrwo3a1^u[OI,'Wq9>YIo[e_E9"N[,X?jwoJ,>w^_ZK'AD{!v'ix;\mGRl>D@U<Tp<I^g*2Ta
    aoH=+'u@165W-ZmSk7k!Ws2A$-'^Z1DCl}5CTlV~Omro>BxiI+A2V+5E7--Z,a]<@Rk7ral<?+DR
    oaQTFT7]IZ7*{$_5v_#'7YwD-]xZ2j][!YWm=xj2*hknRE.2${_YZ*<Q?=vW_T-HQTj_n[Cek>I[
    TaXqrsua'~*ZE~{]5eRD+wpx+7w}}]v3]+CBx:T1Q2oj$WDvl\$w<vG!YlzQIBoCr?Wrp?>Tws#-
    }$Q!GX-]IxxRZC7uH@H[aD#-!TI{_<aDQ<xB}+a'Kn~CKC3Y2;XlnsCWB]-C!5>=_<$CUEk5Il=z
    Kwj*Q7vIe?KXskjNQi[}'e${I7-aEw+_$?$*ezx'vV{1^Oo=S1u']CJ@2*B{w:7[\oa7[,z~a}3]
    oQR^lQz2+3xAjKO]$D2nIsiR[Cu|KaEI]]l<8azv_$-<{R#@1h,HAH]]ZJWCSuAITHH7keuloi$I
    #oeu~^G^G;C5s6iDFx=D,*AZ{ol;]EE1K*p+3QnYAW{O5^7>jR}Aj_Dn\YGe?KTvji'{xJ<[]H{]
    l$}z1;n;OA]2v|$X_?MDK}z[5?xBJWwhB~ZQ_1+w2RCu+\TCl+X?<TY]x*tuQ[mQl7z7@!}oQ[]C
    =,Q>=QkQZ!*v;Y\s=]YhDvG\DCvo}*\-n5$2v!==C>pWE/@xvTk_B-vY*5aIX^}a_*:$~\u1^OOW
    }=HVT+X+E;=H*Ypj>Gw2pwB_=o[V1i1d<*o2EQkCMO;a'1x<uZV\~;Bl?lKDaO]lV<^C-D?EHbs?
    1R6u{=C=WeRqw1;Y[;ZaYV[x=Z,nCT;p3n-]DsouJ]-~:'#$\#e@{7@<z-QJA|ZE,2eC$GnCuQ$?
    $R@l\m2vC7x{jrYl!a[AOmeTG+_om]Ri+^V[;VvK}jIO;l5j>YW1#;EWe2aBv=k*<O,@R^"p^ZV1
    C}H<]]QQOR;_#os~1JHDbNE,*mYmla)E<pa{j5pzOn7]~<Ov\,-bc'z+Qpu'Bul]![C{2sv'*OkW
    ;p[w6sH{D0$VvEZ<j?G5;VDToGpHWje;@@jEnX7C^@Twx''~V*zE!K&#[$j{[pv,l=J<=Wr@{+{Y
    22?B_Vz#D_roYn@oAVV~$++Xan<W_X{XnOH5Hv,OOu#5[--g@E^>*JKO=smHETZKpzC$,>[p,sDR
    vwe<,A1!>^C]{Hp7\E#H,>+kE#~;}\+?sn~2IsvO_zke<x5_@[$@1aJCG!=1I;COzj[GGu7kqVGG
    aV@RAE*Q*}',p{Bwkxgl\'!'aY@A7evP5v?!w{[1%[Ju\@Yi'vm2@@[O~_R>75#mI~zK\dU$H?ZA
    IDB!v-s[!Ga7Bu@{}jJ^#;Bs=Dk>m{[Z2+{}@3n]?@+_#lYwzG}u^x={',Cks],pVw![u^NTG$#j
    Y{]^o1~[<-$z-]#wn'Gvrr}}'2@$Ek_T>Ca1{8"[V{}}n;jZHQIVvKR1R$o?T+viTrBQZs5UQQ@O
    1_pia3-z*X'}j6.+5DD~Em~nYzX|~$I$9k}VWE=OotRu<-VOGX$Ao5H[^#5$\{lhlvRD:8D?E=$!
    ARq*_,H+pm57eX{HjGAz$eH1CB}Boja!,=$ew[W?{D'jT}lAe*pk*DD@QAUD_w^V+Az^!J#\{TIa
    ]_GJ_oUB\Xw^Tp}4~n<'+G]Z@\koPWjVn~Iwx^Z>w9oa6{n5k_$szhoi2;_0r=]^,UAnR3=,NVk]
    ,Pk[{{<Tn]_Iull]'~e-J1u{{wDGY]]?,wvvBU'=*j{xrvJE2#cvap_;[H<]AKA'UVEJ8/*7j5ju
    bWR[@5=~Iu[l2wYzpwj,p*I{IHr;Gm5Y3,s>@D{~2pI+pQUOVw^GrxZWC>O'mWY\5jYBZyaQaezu
    l3'ZwC5lm+s?s!B-JEhG{e,=uYl]X5ZD{V@5-vkrv$jo!E;!RG{VR!zUr\Q!nW\_2{^O*B1eG^_h
    vF;7<7$2o[Ly>YvoP3{\2RH<CKT5!4m5l_F(>TN=?XwD<XAlUUWo3o=B}kU}W{~vk'rJ*_JC_B3x
    ArAZBOu5vl~fRUIYx_jGOvYs#l]G,z$-#7B?fGI2Qo!Q?C=}OH}<XW\wCD?wz5er!\!>W,=n5#<A
    Q7HRGOH-Gpn<?\Z2jj7B\O]=G[EOQ#>,wA\T\E3-!$oar'nV1'nB$\Cw~Bp1_n]OBB1mlszl7QGo
    }>7}pEY#X3}CGq^A$CAXDH\xTH#l_BaaZ}?,[Jl@xT#<B{,TOZ?]x*QkYT0'R5G=a1j_<[ala,U|
    la}@fCoV-;=H]>_Dv=5BKI^w=5+a'>QK=-*5?^XUAR~sT}Auo8>pYDO"[_5Ji[kWv>eIRo#<j1_B
    \,^}[_UTJ5pu?z{Qp'\^tZB$#lH;Rl;V+{[!Bi\w'*xxnCkr]ZRX'Tx]_[u~uQx^V_vHTJz}A(<o
    {xIu$\m>l@^V15^$<U]R7>=s'-k1<-j>o]?neei=$x[~WEnnEV![?H^1_-BB#r2<OB}}Ku#jV5@w
    o7'I7{bwC\12,Vm%s+R{v-v3HUEV!zAsKa\*+'Guc5[eX<\*a~>2KBJ$O{5u1Cw<=#}i=(xD-;P\
    HVol~_@or~QYwnW}V7~Cu1x}$?s;\A]s32*!$C-$OGR*T!rNei<$!_xA>X;ezk{B>Vu{=7w$\K!k
    9Oe7QD_QWY$#kYn2D_2_ll*{!#]?-EY3,9=!VGju}ehB1CH|tG75EDe'KzJA-zBRYwl1~IuHrl'1
    $Y$Jvo-*7I_;o$m5'z<zWdp{]5uIeJ\]~{2['-nI-'>Q]kO$o3_H=w$eCR<{W#O;7]aY#UpW<{ip
    OWue\?ns+Hk7QQsO2KIY3pczG'Ai{}O-[AkR[eYm]$$Us-Grw_WkGRv++Y]K5xVO{D$k$QWkDx}5
    R?VrioIMs~R1X9X]JGv<av\vCK<l^W-+!>&RmV;e}_BOG;kep]A0',Ce>j^J>nITB+-Eew!oI^$B
    I_aYA$>D-QO]@j&Bxn1HnIvGwl=<'zC+}<Q3O7uEB~GIk@j@e^HrQj;o3@+WRJTza<[\?E7R{'pl
    7vv=ER^tixT_J[xw$;U?XT*ew773(P2E}OG;*1{=1Z[si2EG[m'-,zmC#j)goY[1Ev*;rJzO#<mm
    J5'p}p;]P$uSx3o]'*'5ZU++!Y%Emx}1Em*zi
`endprotected
//pragma protect end
