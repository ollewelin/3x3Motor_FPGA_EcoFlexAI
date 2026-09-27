//////////////////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      Top IP Module = efx_csi2_rx
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***************************************************************************************
// Vesion  : 1.00
// Time    : Thu Jun  5 09:45:38 2025
// ***************************************************************************************

`define IP_UUID _csi2rx250605
`define IP_NAME_CONCAT(a,b) a``b
`define IP_MODULE_NAME(name) `IP_NAME_CONCAT(name,`IP_UUID)
`timescale 1 ns / 1 ps
module efx_csi2_rx_modelsim #(
    parameter tLPX_NS = 50,
    parameter tINIT_NS = 100000,
    parameter tCLK_TERM_EN_NS = 38,
    parameter tD_TERM_EN_NS = 35,
    parameter tHS_SETTLE_NS = 85,
    parameter tHS_PREPARE_ZERO_NS = 145,
    parameter NUM_DATA_LANE = 4,
    parameter HS_BYTECLK_MHZ = 187,
    parameter CLOCK_FREQ_MHZ = 100,
    parameter DPHY_CLOCK_MODE = "Continuous",  
    parameter PIXEL_FIFO_DEPTH = 1024,
    parameter AREGISTER = 8,
    parameter ENABLE_USER_DESKEWCAL = 0,
    parameter ENABLE_VCX = 0,
    parameter FRAME_MODE = "GENERIC",    
    parameter ASYNC_STAGE = 2,
    parameter PACK_TYPE = 4'b1111
)(
    input logic           reset_n,
    input logic           clk,				
    input logic           reset_byte_HS_n,
    input logic           clk_byte_HS,
    input logic           reset_pixel_n,
    input logic           clk_pixel,
    input logic           Rx_LP_CLK_P,
	input logic           Rx_LP_CLK_N,
    output logic          Rx_HS_enable_C,
	output logic          LVDS_termen_C,
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
    input                 axi_clk,
    input                 axi_reset_n,
    input          [5:0]  axi_awaddr,
    input                 axi_awvalid,
    output logic          axi_awready,
    input          [31:0] axi_wdata,
    input                 axi_wvalid,
    output logic          axi_wready,
    output logic          axi_bvalid,
    input                 axi_bready,
    input          [5:0]  axi_araddr,
    input                 axi_arvalid,
    output logic          axi_arready,
    output logic   [31:0] axi_rdata,
    output logic          axi_rvalid,
    input                 axi_rready,
    output logic          hsync_vc0,
    output logic          hsync_vc1,
    output logic          hsync_vc2,
    output logic          hsync_vc3,
    output logic          vsync_vc0,
    output logic          vsync_vc1,
    output logic          vsync_vc2,
    output logic          vsync_vc3,
    output logic          hsync_vc4,
    output logic          hsync_vc5,
    output logic          hsync_vc6,
    output logic          hsync_vc7,
    output logic          hsync_vc8,
    output logic          hsync_vc9,
    output logic          hsync_vc10,
    output logic          hsync_vc11,
    output logic          hsync_vc12,
    output logic          hsync_vc13,
    output logic          hsync_vc14,
    output logic          hsync_vc15,
    output logic          vsync_vc4,
    output logic          vsync_vc5,
    output logic          vsync_vc6,
    output logic          vsync_vc7,
    output logic          vsync_vc8,
    output logic          vsync_vc9,
    output logic          vsync_vc10,
    output logic          vsync_vc11,
    output logic          vsync_vc12,
    output logic          vsync_vc13,
    output logic          vsync_vc14,
    output logic          vsync_vc15,
    output logic [1:0]    vc,
    output logic [1:0]    vcx,
    output logic [15:0]   word_count,
    output logic [15:0]   shortpkt_data_field,
    output logic [5:0]    datatype,
    output logic [3:0]    pixel_per_clk,
    output logic [63:0]   pixel_data,
    output logic          pixel_data_valid,
`ifdef MIPI_CSI2_RX_DEBUG
    input  logic [31:0]   mipi_debug_in,
    output logic [31:0]   mipi_debug_out,
`endif
`ifdef MIPI_CSI2_RX_PIXEL_SIDEBAND
    output logic [15:0]   pixel_line_num,
    output logic [15:0]   pixel_frame_num,
    output logic [5:0]    pixel_datatype,
    output logic [15:0]   pixel_wordcount,
    output logic [1:0]    pixel_vc,
    output logic [1:0]    pixel_vcx,
`endif
    output logic          irq
);
//pragma protect
//pragma protect begin
`protected

    MTI!#/TO=i]-}7eA$_qgVl$z$4paO<$Z}DW9caGSrZAkN#7E\}$WXJn~[5!+7l^js#wOxY'3_IAZ
    ;u$U@7Q-HpQE7*n^isrTQ[wBw?,WTz2{rvzJsIZ_GWo<Q)r7<*o*7uK,J$@j~sA$2'u\Ru5Vk]R2
    aA[E\U'pB{zH3l#'DvuRK$\]}^A]/BBa}D[TrBBr@j-l@*#]@laHxWUmn_-\}q=&,Iz$@E<!,C*;
    7lz,UsmxVCiHaE~'&r,OeG.ov5AZ=5j,Brw%NPBIv#!,Q-{-K^R*;B0-5{E+ja{zp{l!7@I*}iIB
    _CscqR$x!73nA?QHH^Cj{{Dx~pm{]GODpI;COZrG-Tw_BzZ>J]Q^l%>Ii'G~Ax#7O,rpkX^+aDs[
    i^>eQ^vpHDlCa\LO{$kpwD7TE[pA=7{Y^Z3lI2vQms}*W_+[uAslk_^)L$Ku]^uK!=;^Yjn}3o}o
    Q*m^EAO3wpVJ,s[lk5ZEn]>]1_sQ>}]2}fl+ED$Ei@[W,@6<[R?@[OJXlHXC3G#=G-vR_#}vK]lK
    XDA}E#25-;a#aH*AeW'ap?+3Ho}vTvXQYzpZ\eTeY=3v@xsGk<DDY@U<B;]n}B$hj_l':Y!x+9X]
    <GYs{j/e}]=3z;3zI~O%eHjrm}j$srYHDnRa!$svoJ$x_[#!moi*gk]"[%YmATil!_%w,5#Dz+C[
    p?e/Yn[KI&-oQZVj<?WB?Gw'WWZDR[XpA#,<>29oRUXHji[/';<no+,a$uoTZ{<$5k<#]^kj9_!n
    @:wEIp'^@K!oZ56+-^3$Ix~<pGzYOKe_snOKj[}Q}Ykb1W-,m5-O7B'7QpDnC_Jp=xYCj<rVY7r!
    !_vE^;'VB\T#{[TG.uCnp?C<n3\#~,jZJ$F@X*RP'}OR'eW+Dz=VellZ&gb~7v^FBc&WCW?OG_7s
    E+z!U*Is5m~vp!37%Ajx^esrVc,~TauYDwAUt$C's?'ezC5uj46]3A{7@v@IaY$<=5rKrHVaBp|r
    rr1k'AnWoCJZHA~]tV'K]+G^\UDkIG,XXY22z}3R>|xw=?$Z{Jl1-#Yupm><mYB5k'js+r}+\sz;
    -ZB+mkpsovO]k*5Z1HFR^!zC5I2=oQw3-j_(7sAoOHz-IGGz[T[^'m*IaB\;HD+n1s{O~=xJDi@v
    "Xo#T~]<x$KAH~sJu<H>X7+Q_nRpIWEkpM#\{T:9a7Eurn,<J+W*O1Q'Tr;<nXCvY-]+'-lmla2p
    7x?-$O*VE+x1o;ZpnwY}RnX_-Np37u'A$Gv>vJTVT2w{u?G>uRuX1;=J\ZAa=lz+Krg1nU_q"*m<
    Rl3-2CZ$QlT]WeV7}o>ulvXa;lN@G[5waaUomzs3xnAsYoGTwn#~$S5?!$Kp*Bts;(o_eE,aE=rV
    jI5Jmw^DvjDk*p{Xv!%8oKWUxOI!ARxvE+W,@=[Bn{pu9XTmA{}E-pn-Y[k>V\-I}wpI5xHwIExY
    ;vKmo1i*J-^^1jCY!U\}nKpUww(5EEZO#OnU*{e7-]n\vi@-<+v,emkYd9nUx'|:pj]X}j$G;wHD
    }dKoU[iV+3,_VjQ}paX5o*iRCl4;xjj#z+_MW\#AHD'<iYJ;Bu1T-oxo?<5Zo2a@>7!x~jOG(Xlu
    O<^XAp{QU[eQ=CW^UL_;X?3X_z$?Qvs!E@>7TxFmI[DJ$J!VJ<^LB}Gm$+~Q}~U\)lmV5Qnm_3$O
    w<e-7Bm[_W+{xzIxn.{Y@rCbWp{Xz"J\JXsonuJ1{kOTK?(Gp?'Z_-Az5{Bz]Ipzw\sGu'=o_]CU
    B$nyU><Z$pA+w{{aWa{mjDpYN*T;$VlHV0eZ!-K>^B;pmZsVo+:ss<]On1[EHBzE1*E>U_arXv5G
    ?JBx;{[}V@]R]z5}Nxjoi4KV]p;a[iZj;aG'mcTo@uCR#TDX[mBQuX$!>J>7jB.$z;~[=m,WOpOD
    _HsXD3rzpK$<xY@>TC5QnoQaOa2bx;3~^{jYpw_Yo7_[e<IomsxK$D#[H}J^3U>;#Elr:RZ@EW'>
    HCJ{;&Q'{3;vIlha*eT\FQ*-nF^^^Q=*AawnB#9vz~X@Y<uv{+lEU$3aG1U$Epw;[k=yUI}^voI?
    Y:!,JuG~DDi5R7>5ma<H-Y?CwxxlJKYU{JKBp\DwnXbKaj{v[jUd]37mpkTr[T^p[_Bv-pI-YJ;U
    2V;$\WKB]*lmjKTw.zY_R1\eJe*D<lmll=2Wv!GnW-B1^^#2#CsBYB~R]<z$H;^VrpXz[{z7]aY+
    zr\<M!*uBajrUa}Qou*oIE#G{w$*5]eG1s*nZo-=XG<}CVZ^Z\7rNX}kZ!vu!+}-pk_*OZ=5}Q!o
    Ud*,>*"mG?XJvDk.X]#uxrA1vw21ilZ_ymXBsY'VzRW=^Cz@e,V]u=>o$,EXaDRW$^Woau[nEslm
    nK$p<sp\QIn{*m,{~9_X$u#,;\yfv~DZ~B]{wsk'7Zsw?.3I_O<O^U_!BVOVvs5s7k#QCV\w3j|Y
    x3VZ'[={,iVE_eW\3G$kOw~2B@,r1@sjV2Ru>'[Y2Brhqjwz[T\j5HnxjDmGr/\zj?eE?_IkVvs5
    +<pr~r1C711Kw5YD+j+5l^e!{u7DZ}VE1Qv[{BcB]YX;lIJw7~v!HVY[1in-}e3C{e?I^nvX'>o{
    }XGbG6%-\v!I2*{$uZ]>O*>BrZQZ1+!sDv#o+AKI<_vEjVR][L{<[mmGR^OC;x7Q~D5{;n*<p'kw
    HI/G7XVm-smZ^wR+EOTe'A2pHKTTI*BdJaHpB{O!;T+aQ5,]5\R]e=IA[?KBsaRKou[~_U-UfH11
    =h-eJ2p-m;,?YOG}mvH*O?BE]nj-j{IE2l#>[p@Hv$^YUnpD++8M$TQ}>X<,,suk^jjn*o{T7pTW
    sHET{{wj,W77E{j,lD$~5^X~K-s38[<[pJ]+[5>m*r'wvQeK*3U}km,$5mQJ~nO#Z\CwnkDX$KI$
    DbQTwZcHVK>BBT;JY<RU[KxV=eTXh\eKAWs,@EH*poJ'2$-A?_D2D1V3=-1*ZFXl?2OUs#TnBm;l
    i;snUAL'_r5l'$5L|_$Dm's<k^U-2s2+\mo[i97C[{9u*z{l-D,VC\zX\Q<UUzap]Tx}31<2A!7A
    AC@LEKln@{DG;=TK,uTK>wZBBzU}'mU+T$v{Eo#D;zYQ+1w'_D6<T*it{>'z$,]20I2Ie@O*wIGZ
    #Yx3T{H-v\b9B?,v@R=D'-DR\!_@/H\a}YxQO~TU@fkDRZp-uvYOi$>{aK:Vs,Q5veaKX[i{]@s@
    }<?Bjrs,),vIp\z>D?t,W$]$1?BG3Xu{U*WCrxu^V*s>EQ[''xn!$]$DK_{irQEr,cXr$A|rXD]=
    _rYGs}>B5A<z7_1'\#5$jT*1}a@hnAG,,Tx{xJWQTnD3E!K'V\,n1*n'dVa>xQI?ez7nJNm5uB7B
    XrCR$vSoE^p$*GRL<V#XY}"@+vnx-{k
`endprotected
//pragma protect end
//pragma protect
//pragma protect begin
`protected

    MTI!#sw3sXs,X1jTwEj^evR~H1=p;cFFB@wHNgl+ri=k<@'m@'<jx1r5ZJUOe[1!nvcen1*yeVfm
    T_#<|OZz%lwJ#*+[[o_n=['CW!Ul$HUl=U7BvVO#oskU2*3vH!'#Z-C_Gs_KH9,@Ce|)v++ot1xl
    @r?jHNj;Xo]g}ZJQVK!?N5CD-^sz50)^Rm*^a,mx*R^uoB?\='E-DGK>&ov3^Z',?nl@av^l}ZDY
    m]{-X\!EHvA'^97$+n}m^A%}Vu[Y+RY!|KA^XQmRH$D-+<,G@fpz\$mo?pKYjr'zTuQ$i]Vmz@Di
    ]\W&nj5!1x1CosorzxGDQzVs['[RzkTr.%i]V<uTK1-CYrS]'U#Ollre=2QBHmX$Kpuz[,H_$oAI
    7k@r^}k[~[no_o$W$oeRv!2lr<,NQuaQt?<p72EC{nO?CGWzlVW~e$+}UG;u<U-]Z]xk*q5zBUuj
    Czu_xZC[?;7#=YN+OW+[5?+o$m}_e]='1?5*kY'[O!pOT]u{w1Ai$W;;{-Z*\r~lQOpIapvYan[e
    \Xu37DWw<AZ5#+#$nMVQ{ZxZpWmY3*H-{IFVJ@o7*rVLij3j\_kwBV@a7+UlIO2WYnmQvX_~&A\W
    ^@Xj<'pV3:J7l}B]i2o2Y~,ez^[Iwm(1,zi\7v\/Yg,BiC,roaNo}O,ACV$R$xE5Uw[L7^X\_@s^
    }jJaD;-u3a{7VZV![JO+BekGz*Cu4'DQ[$?jvOI7sjln-GKV,lGxu?Dl!;C-m$&={{E]!Q$JnE{Q
    Ogm]7Zf#^xoB]#m\eGs'^BaGZ'?IDM_VQHpquTX\ri\,#,e#%LQaneWz1^E5K^jUTow5Yk5s{I7#
    Jxw]]?=*+EAqKBr<pxaunjkX_nOD0*jkaDd\WVOIE$nYr5~]o7@ou=Z1zYnRVQ}l!),UCDT5<\|L
    8\[$J>EERK'!IIlC3l{@QN,3X!^~n_]l\ex]n]7WC[qixRij]>ATEp>?Ow#@T[Y>Uax,pE*BU]o!
    }ippx;!IZnV]aBx_,X<DW\e<^uJBTY@KzI3Hw>sv@HWZ1p}}p?@=elH=xnR><<J7+ppe2O{73*z@
    Dov@zReY+\!n>YIGz+w+[Tsu-@~qyajmesY2CRI*o,'#5TD#2?[g+-@eClKU'3aoqtx1{?R<+A[a
    ]ef1U3;\<'}G><1^'''YX7*=IxzXxKzk_3*xuT^7?}]^-5rR5=pr3'VI1wXs?mVa1-;@X!562pQv
    Mw\~<B>2T}x~Bq7Z<v}HYu1O_D~GQ3.c1T;~XX1~><Di^],]YxR3*5emOjUjO)~DooNJ{;<-l~]C
    m21?A>+HH{UC2aOs@z-iHIZ,{<Wz*A3VOORv^o,:lupi-Gl'k]R}iRi7SoCY!'m!1,Y[lB]EBB+5
    !:UX1@BA$YrG]@EB}3Ve*3r_X>T5lzUXI{Dk_17k_GI;slW{=Y@\C253OW#Te7CII2pIu[mRBk-5
    opazZpAv~usVnrs*Q7\n~H<l$]v~VK2jG7O,u!eH-H'uV^Y3+r3o3'ck\>R*us$lr_zaQ1u'+;p5
    <]T2>E^i=Q#I25<Q^GaljzRIm$rEE,Qi1-1e^DAvom5Zz+}[zIJo;_VTO\3,wKE]?QWIpwxLKDD_
    <'J#'[?w=+rotY>XZ[Zo,oDzn=D+^Ux3G=,]$o_Y_WDsDcr7p~sB<Zz<X7fT<m!}2,TkR~\j1OAE
    Stl^[3Y=TKV5<3p>KEC#[zQv~Eo![^C@WY7[R+T{I>y;EaY2lEKiYZ@#eI{xE='CJ1@G5]pxK]#u
    z=HAxI;zBe#11$?avE5ix[z}vHx+=U'GvZo,35v[z'uX{mzaIIx\7R$QkAH=jV^vKIH)\DEkA[?*
    Gl=XK+nou{5#m,l9rDXVrYKxEw+Hizz3~oz1f*uD!s!p'c;Bp}9:}[w1-=Irx7w22HQ5VI^V'B#o
    woC*$Hnu>'CzOnH1*iaYJ}IQEV;2VH5zsuYQIz{=B7QoX$2EsVm'5?TKr;[j13Ho^n$_aO7eVB'I
    A[,E+C7Yhz+QaC1D+Br@OWDE<V<5ZRT^?7J\<?YEkKn-TzCxTqb\{{\#T2>[)-}JrJw{aQxXBvZ}
    >ur;#]IY,?on[OumV@Cv<1[
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#O}AXmv\'HRo2jR7JsiJXfp^VQdda'viFIZQe="[ze5,v_2OO2[?Qr['#-X]p_+3TM.B2WX;
    ]T]V-ns~{BBY6+1$'Q,AmOoXA31,['>Kj^iY\|_j-RJ+z[v5Xe;TGR_$Cpek][omYK$@=ekU~p<*
    n'[+Ar;'$UreU,g=!x7aYQ*,O{I)eYH}eWx,=]1sZwjDzj#]K_jTkBrDI+<s>5*3rk-jpp\e5X<}
    {$#2[}'oJz'*$Qjr}'><Om,;i5oV'_?pupETO-Ojo'=x!,\*GlWssCD>Ba2zlsk?r*_i2XTk_'i1
    #sD*DH=Ook3_]#vC^2$$}_jiOiu>!+*luC~<I?XCCmmX<O-1Os2x_J~BQm{B}{ua*5kTz^}7#,1U
    q[l\OIA[nzW'kzsVWTa@5p\HWC=\5S!sB,{YEm~$A2Je@$h=m'^arpkI'5@Rn->V>7-p'i59[?CB
    N1iKw1u{Kx>=j?]I3m7?l_*upgiwVDP{Y;!]e'Xg<<;BKaaKo<2}Nve$$2-$\'[$\!YRu!H,lV1E
    T1<BB|1;Ol=5e_7k]D'!pGHr~^^jaIYYioY5!uq?1?_?C*ITQBV_[rUUEYu*#eX}4Q=V{yuns@VR
    ;a7uB?C7e5Le<
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#57-5726kRKrs#RY1DZU,QD=zDB}Q_!z=;7z7RiUvnYi+$Zs[j5o+C~7jB@7pp_V~Uz-QD3m
    lQ-MX<+2U{){Ck;G$k\s{ErsSKwJUz^;}MJ'+H1vHa0xzuR!{H2H_zo<{O^0"Q!{w$*,iY;=B|mT
    A[vZJ7DZA[]Jr=rv3<N2C@[3(*@K>t,se$]<[D;oB7&7Q]7x<UB=\AAe'v,~H*3$B@3KpDarm_{b
    JY7x=5HQl^zkGDo;RzA\T_YRzRin5=zIyK6}?G-eJ*5h=wY~*$ZJ&sz{r]l[i;jeV]2T#,V1<UIe
    ]'r7BJ}'1C$oBqIRO2]WYA;o[By}J[Dxr}l|@5D7dZe+2@7wrxxrnKwr7esk_<l]r[,,zIuC#s$X
    upl\$exiozxx~jQzi'A}_,W^JlV]}Qo2pY?Cvcm{X]1xZ!0;{uIhnjuV=lU?~UZQHYrjSqwsz]p~
    +#B!\zy1#{vWIGn'4CTn5RZ-\6CWZX]NO^7QY-Y^G1$-skGlHrzU^~B*,>OVJ51sQuX~emAIXGxY
    z<j[B$I}]uzVu+{EV>)vUG!9dRCv^l;Bo75k2ReY?KvR[R_vA!r1xGYow\+'Qrov@*_Dxs]e#HDu
    27va\=\<lU1ia''77bC#jopI<E'2Ya1puC_A>-sY{JU<Q{maC?ZIi]GR@V-CGs$,xn$B2T#r7;Bc
    eTXD^^,*qVEpOBZ*G~eW!DVZu&O;,[R~sR21RY_UX$i]_YvAnsoH11-=]7opv]<5Hjr'R'OE5AU]
    '__R>u^u5$O},r\~a]w_IUo}<o@aB;i[bpw3CEpTH{j-#)B_$~pA-<UDxxUH1[Ip!r_pA?IU;2,,
    l-wrk;a'XXb$^B!Ue-sBuY5q{r]7-rZ[[;<@kUvR_^jG~EQQVoeQ,';_<E?aUa_lOAWzJnW}fAUI
    *Y+\>l#OlI*O[NE@2BWH7ATa{eiDkUKa-~w[Vur}+-+R]<c=!+nj'jH3D7[1>w{x4jK^jHUxT1H<
    a^O'}\BD[ce5+r7@*[r<p2B1XB.,Di^|5j?5V>TkjG~~}U{~IQvj1K,AvBp}YoOo]~j<2E+oIPI-
    ][jm[,!D,rC'O5YW*}v>WB&QCuwF-7UB~paG2X[^FA7wTjHw<62z[p+tbmIOi3]HJkB*7T5]k}3-
    @^JoU^E<R2ouW7AK!vXJ$8Krux*K7@xrY;HDXeCi@*{n*^M,G}utGn^lU+QGQW<Gp^meGG=GdH_N
    }mpn\jD>'w-]IE1YweJGB#rCl2wvN*KX}l-[##eXQrQr$erv<sUQQ:a}]pr4,\k{-H$3~+<uhl4U
    ^x<[VT@.Eu-2GJsZh?_}pL;1z+6,n]z+^Qw<{{<czR=[V<A_[sH7=nmv2rJ{\z!Y@vB$1BaDMI~+
    #X^GmeYAWrX~lc*K1VJ**AkV+{-YH'DlVD-E=iyl{JVq]Qr1'2*=wQz~G3T?pnJ!$ilOoOk[B5x[
    k{O\sJB2O2Wu@je_Yiakr]J#[#O,]eAxTp>=?>Y7f^dv\z!]*r?X>mY}ngDVauIBQ#8zGX7*Wal?
    D[n\VYzjnGTyN]>J;|==pz:HHjTBiTX]rj~*&15vCTOwY{V_$z?-$=5V18_r=K*O>_C?V~@Bz-2o
    7_QU@3vA(h!\JX:n{K\_a3uHxiKEG!$%Lol<\w^;zrG*^$ep5#=nQij}@o@K}'Hxi']',2Cgo\Al
    Y2[vN'J{mT5QmYZro?DkIo>Gl2Y>$M*DDpUV3!@Dk-WE5U[3D_ra-jHY*7SnUJ[pu=_@[u!v2@mV
    $X-)6-s'e~Uv-Qa=al7}ILKC~e$UUaUV1>yn11i-Gx#i-\luUGBa*iD]VkaI7@HLYjD5I}1[pV1~
    ou!D_7_JHG>2V?pprn1_};@B5R~,RVUop>\pI{*@p#W-v+3U1w@BdB_VVHCoxXr'zQQ<pH=YCrTr
    JN-jj[bnrC1s<AZ_}KE!ji!*H]o/n<{3%a+-I+D{EvzG~e2HDIVrW,!{ZC7Q~WH-~HEi=~j_$'?H
    KwCL!{AXyiU;=W\u7MJ'Ei?w;J\uWlqY]p+M]a5vB2DsUN>w!rfjmo{BWZwv;o>.U<T7Jnrupj3w
    uA$=UGa2<_>VnVV7eek=-x^j_sux\$A]#aHHsx<G?.<H\{xv7EG~p=sT1sZYs-'@35Ie5rTzk[V\
    p5%$zim#lJ2V'#E<Yln;vr9VUXZBGKQZe'-\wJ5$BH-jQw}Y#@ut{a}Zr*zxNoBGOleBW;<]@SWL
    Y-Iin>$+5pXUO7m[*R}?[Eu!-=T{3}?*/_snDYY-ojlAO~oY@VDW70wEI!]Z7;ravG+Dixc_s#kv
    XK'j?[;'pU@[YX~v?JJU'rvYYWV'Z<1x+12aUw5UQnIX{uwIeA-E+zBpXCz}^u]aX]#!ID@Rm~_e
    G'1N,#~r~a~?[A[\9%'1<xwn1u^m^D,E{R->vQQ=ieGBQ27}UB[?_*u1>V$2,eI[[EAoXW60,3^X
    Kn_5}5^_:GYmKHRA=3[a2-YJzS_^Xu,naXHD$Tuv??U_,}conJ+Ld!YRa:$|{--U'7E}|InW?Y}*
    mlk~jvo^B$BUx[\k?oiaa3O7?,Xu2ioAD.i=$$[B$D[BZs3H\C>7wa+j!{s?>2erv[E5slaYG=$>
    H$YCQV5XjCE!,BX';vD@\li'J7R2p]|}vJ5<Blu~{5__Im?OeH}oxs?rj*J[+XK=J=-Ow~Y\o{~D
    VUK_2=)ARolP_iDTpW;2:CnlTU*wReOsEI!zmOGXrBU>}1QeiFDrmYkwH]A^CX7w5i3pvB",,JX1
    *U3Io+EH5ZY#$<Z&GAOxn_BHOa7-u\@2cIJo>IHZ]xp,^,}>V2Cp]aE-asx<*p~zmYpovvODTQ5T
    {B$='>wp~B7}s'X[EKXaZBXBezAn7V[7ZbC*k@]l<z5Nr!nOi=^'#TjT;'1lO5;GbYCkOI!wK7uI
    Q']5T3luny*UHo1zTV.=5}kFj/klpzB\nvQPs>!AW{I{]xBjr'u7aVKEx-Tp_L#>uOmUI*iBs@R<
    e[U-olG+_\'A>[G@E+w^Ju];Bp@sr!25KC${Z?.'i,=l\*r)zmxp+xlQ$O;}=HV~2R@oQ_G*5G'@
    l#zG|[@,aEZ'\i>uvHU=Z,7B1nnuAX<;EuHzk=1enu[su~+-!A,5Dlzm5xV$^,BXe7ls=Y],^UY@
    nBor[YvDakAjUp!5DDi^D?>\Cx$z5?o@sB~AOU{Qmnw\^p\>$pAHlG;In\COH*_apbFr$1B1n@rr
    65J5-P&IKnpEe}J3^_,YzpaxHok\sXs_wZ^C{KX@_-B5KW]JX7wq(upoKwrz'T]p,_xnYROs}nYn
    UHHJ,'Y+[][;=_E1n7e#>C>xZzY\D[j2sl!QH-nn3Q}r}{+OX*Q$$2Il2KBe[DnUI*cCT+C;pwj;
    vpRMr[T@'=BXJ1<z}Ux+nw3Wj}JuHV5=IKx_T+*3Ue']ioIkUlH~r5+s;nV@E1]n2rkWr~7<G5ll
    Y;D}4MmA>~*]j$#wAwr=T}O>x,5kozCpm+;Qw]cBl>[(Cs=_HOXB,5vCW_r-7DBTraw{Cv;<[],'
    up<TX*[s717rETu]TGoAEnw$ooxunD<CAa}O>SzJ[W_,V?rn\nzV<'xH3lZ};XUQ,sG'Uuv5@}VE
    eHAvp!na+*1OclaT!iQ1Bx[_!wD2?DO>3<$O[so^rHBXXTs)(%jZ1_{As]Rk*[^v<OB[*a2SeE$;
    EU3oRx{Ow-aeV-l]e{_p.xnC}p~8Q+xrZOeI1zK]d_f>^v+;j{Gr[{}[aXpm-wETEn=z>!nF\+*H
    }5Y_r*YBZ1?O,'lj[{UJ'BJJiU{Ch@*?YDkpp7\Ij$ODHVp5$_K]BcsRQoZ,eU5!U}[5ir]!vn35
    jC
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#GEODR7^^\^nJCD\x;I;5?}>X@lTn=p-l|)B>N7k!7|[1RAxa]TKAx3x#-j3rzuxz8*;[aw}
    @o-lX2zCC[EfkQ'Be-e]iXa[zx^QI}VCX$E7$W=3NWGuElK3nva{U%{oQ#'Ol^9<5uE:L)1C=X$*
    +''C}rBl^mYCRjWUZ>J=i2IoI2sUQoiB'is\Jpte$_@^zzZaUpzCi1i\lGv(<Q2[zWWke1[}W=@}
    $lJuD*e'v1H*3jk!2_{=DmE@:3=+]Q]#?~=@o8*33;=r1<BmK_K<3^.6HA>TDt1Z;HJsVa~+!U=s
    pwan;]G\A$iUrpoEDWsB'DH<sALICAD!TDBrk-*T5={Vr+Hmv7X.Y1<X/oiJ*eRn\!UVrG-Kuup?
    2JE^[eer~lW3l%[x,j*kle1@~@K5[!gIkzHO\VZV>Qm_s5w?B_-e{m{=m*#I5#a1Q,B3''C_$i2,
    gGxW={sIIQQ5'*#lTgeCKBkj1a!{UwSL;xzxoA!RxEYTR?^@ae7XKro1pY^VQ!1R$3OV1@\E{^>Q
    GZz+XXN3<<-CKoJ\}Ho(7Y}@|JoWIQ-5]<1#@$is*IUo<'+Ex=Iv{E2<$7vT;m'E7=/*v,Tj?,O7
    ERs*raZA-pl;HwDPY#*>p3]pluXoCo+Wxla3$<nU#7;KEOO}I+7n,Z$pH\*>J1WwR3xmCYWOsWW#
    xmZZqX=HI+QJ^fTBi!^orE1<2-Q@j-=1$uIEun9'}1$v~\2>ADGG7;@'l@Bwvu#!j;-!E_AxWmzb
    xu'Ea^2~~zW$nT_\y^TrCCX$Kp~T-H{Xjv_X*vp]u1H_lXn*@ro#e<CuADr~~Bxxe(AQ{Ju,}{Ix
    3B^$T@<epZ\<uTWv7uQQT!^IQB<z+=Ep,eHLe?x$;sWzCT~G2'\>u&RnO>+nel#>'=v1V?GvC!93
    Bj+OxkJRGD=IG3G7xKl'C*1$UeRfKo{K~+mv_jC**#5uVz}j-5=}~<U;!<T]Xz#jHTW!r}C_w=$u
    ?Q{GH_;}0$Y},[Qw2mR#V?T=Qs@Cn\l_[TV2oxuK=12E*np\^T_,j8lvzllkYIvmBQM^pwjJ<T@o
    Z}7m{e]\,An)leG{},]'i1Tuersk<_=l}$+I?>G<kTau:Xj'u,#_5u*#vs2>##CAU}JDaCXZR{w2
    Uh/?]r3glG^wH^XJp+<{JzEnxeCwn\*IVT37D,<Yez[Xxiz=a=v?#}$2$Cv'XQk[$#ws3jDa*1k7
    n]R<Tx<lI?C;lwmVOTV[@zv-9Epv[=[e3C<Z^u}u@1zX+ee3Djhv2+vH*;p\lzuBn-r'@*WHVu\+
    UY=uOYi~TXR=}##OIA2Tx\}@EZ5V^,vC5_^*IJKr@=5H7HO=xXXS-5_Tp'=Klv;Wj,XG?RWE=$<m
    =~+p73RGo'^Ha$m]=p+V)WRWrmAQl/o]GJ\1pCqtpkp@[k~JQ@r^v~'EIJvuK_K-28qQ^sJIH{@A
    jACx,'J7n]pa'}'Z=nH/=?wj5Bv>%{$\}nlH>R=Jumej}}5xaoB#IvlH3<RE2]J{Xz-7XxD\kYms
    kXeBpj9ln=}a_k$0<s_JHEkCK5nC<]A,OQ@7A<C73pBvN2\w!rwpv(oaX[?+O[(w=ex1EU_|s}*$
    ~<T#*uTB^[pA#a<pXza<![}R[5-pk]j@;D$A!R'Kv_GKjBaszUZE>'_Rr-;-%C]2[p+n^Ytie\\=
    r;w-nB[)?pka7Qp}eXs#xE!?lWY!nQBH3OwT?CxDI~112UOHzC;+%{Q-~@=xpAn{'zGB2!jjK#,;
    ?^-Z=/+HTAY5IDUAl]R<J!uB#?{{Z-Un,7D}3o>'l~rK<Y69=sTE<IY2cjapvwH_~M*}@eijpIoV
    +5\{l@l{~}>XX]Duxm\B~kIvJ;;O^l}}Uj2s\sp<aWjmAHHH3=oG}rje}^v3UD1a*'Y@ojh;w[B*
    k]UYHBXTw[ErOe73rU2\H@afx-KX'\'Ks$eO>r\$*5vanOosr*sUIil1bEKAYVG@C1H\I='UKiYe
    uxl$Zr+lAmCHH7T-;w[D@qvijI]+YA?{}wR{ZX|Yx*H!ERmej1RQ[{+rTEXJHvT2en;DxxQTQGvr
    ?2$sX=zRX'5)j1T,c]X]jHIX@j$;1G'E2H_H{8Bux_jw!Xk_!-seGv+1{KFT>!+-'Tn+V+jY9]!j
    X~5z5p5}[{=Cny=n+njm_n5'vTGwAe0pO3,]_++B\Y]=KW+EjZC+oIQ^wO[aD]i3SFQRv_H+AYQ>
    n#o+n2zXslx!2xosm!#$nRE#,1z+zV}E7$U[V+-T]^]]k25n[ErspQkp\a*-lwlAvk9vpaY>Ao-[
    <^vBY2p?rjVv2aO?]RXq9fZaQY,EUO-EjlpkOE97!;Aawv-53-_pOi;=m71CQI_j!]{R5WmN11@H
    K}K^1rBeW>@-sDJX~\zGz<Jz_~><OK{#A>j-sJs@rsvj]Q!{(Dk5J^s2v72pmy4_Qf~whjQ*U]r,
    7,m]!5#mrw><ro}Zl'C]^=!{zsp-m<{VozxaEXwGCk5<>lkvXE*[ED-+v=<zA@rUJ,I,T+XI\*Uo
    '!$iXFqw_#sB=Jwh,iTB}Yp-&EuD#VA5_\n$EA1KO<]}@?YinYKpAg7IIHE<'AK]#W!+-rov~YZ'
    ;ws+GoX7QJksTm{7+B}G2u<Az3DU!kaw{7W-1#~$5'D}@l_z-T&Es2+u9+p1p<QpU.7~}ve'r#Q3
    !!lAp@M3aZZw$Ca[HU~kE\7!';!aOl,V-!ZiwJm7Zaen]_1zQRn@aCsMe>WXa5i\^U\anI7~YeG?
    UHQorma~OemslGI}op<ktu[Dn2-w'bQHUGC}_x52OzHY1l#EIv.7!j-m7<He2~o3t{UrY7$>e^Jo
    C)5Aw=I^Jr,zv!JCm#VA{en}_x\y7bw'#*3E$[o96p7=2Hnepc^^k7f0BG@n_E60e5EEKY?]
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#n,]UHTas{eB}l>*H!e$,*=I5^,DIxI\,|(E_J[vJ>O=~W=TXW>>Two4no#<T]zT-TMQk3?l
    *-MX<+2U{){Ck;G$k\s{ErsSKwJUz^;}MJ'+H1vH50xzaR!{H2H_zo<{O^0[;ouXr}x}!-zTS,+Q
    \y>>WaC0]Jr=rv3<N2C@[3(*@K>t1_\eY7is2YI1#5iE3+!u!{=7$B*QO=Q>si\]O=@*2]THuD@O
    h?-'Eo=3Ec>=$]L~j\u[7I#9Jsr\VIXRO1DarWz7_o>;}JrrVz]'oGl;;5}nR\AkG~[*Ao,G=x*x
    NYImu~*=!RZz3$~pZezv_Pf6\Y2rUaA}CT9!Yi\!RIuQQev;=}i$za7msG#iopshn_k[PmBBO-1j
    >kav')73z,5Trn\@T,3DY[$VuX2R1vK<4}IW3!*uC&zzl@t.kERX<\TJ^o{WCBs<@zE@!T\2Xj7T
    eTw7l\u'us\ln1{B3op^Y.UlOz[15x617vaLNJsWx2+{u$AHXVlA,Zw*$7wI773Gne\Dv[z-2lYG
    $*$oTpZ$+dI+<[F[um\i+Xp{I3!vgZU>UOxK2.PE7,Jz]E=R<,iH_7HRraC2$QH!EX-7>2s}D-9)
    Q_,IHGnW1U5Ut,*XugBzB@E*]eir#79w>W,RGiVg/(Orej<TYaZO-,xYkBvi^+Tor?:rF#r?*d3l
    A_HX}$$'xoC~Zm-vx[YBKo'HV<,3KT_!Q-!nK3XN7TY*ya+Kaj\3Z&D#AGUaoRY3Bj<VQ{=2ATav
    vrwO[<tH$wep+VAv2xKYv<X[UU7EzH$#wGI[DTVYO?-}Z5;1Gr<-Uo22v<*K+j7E5mxj+mOalmv}
    CKkQ?<;o@<E{[sW'~7{-_7lkT<?7,Ax=[ou;<}2Gm-ksj@ZREe],?HW_*G1sa$kuE$[NIoTz$~@Z
    {jpzvnY@V=l_$aoV5mIH,(ps>s$Hv5*iXxATT_/3-o[xpCT\zs-X7+WKV+[FEaK{!'+EusXo5R{2
    Nio1[rnH{~[BD~HZep;pIO,Z<n^Y37lE1\QCXAaB2l1Z}2[VCpv{,?o,Db@Q#s~8^{s#:*Ds!z3l
    p.vBj-_a=i~\V*2&*X,7kXrOE>Eo=T!<}D'Yx)oB=W1aJ+l;\$,[p?5cp^^rUO7~E{}$1;73oAT$
    |!1!sG3KIT$pD@<l7B>_W<s-mBVwZOaZ=I+\k[am7EY]7,$Rs-^eW.|Y@j}$Ye{UVIp;=+HMQjT[
    {{w2re<{OT++DGB^*}zm72Ru}T1a53(KDRm^KH]j$lQ+TrEtOV+DAEzup[E\o!JHPCJ{CT=mr\C*
    #&jW~<H$}w{>KkCej,eEmsnqGl-TowWD3l*^p${51AU[KI*]W*mrA'p1+a\pV~UHh,WJJ<>v=87;
    7Vo*?\i}1pV%?jk[_U,[CxJu>*_!xo{[R+>EZeR7lQju#]K{jOG#{+RG^o!T{_rR5^w~+OHbvwvV
    }kC^B!5Q]2AoOxI}71;~3sk=yIarHEGOZ;njGQ>,AX{XJ;'WoImwj27ja5XEsDY*\*Dw_o$?AsD<
    lY]Iv@E#IEn-32s3~ZIv]RZnwx@\u$>@IUR=lO+-;v)KG$TQ;WZ$3OVJpY$)oEm*o#UlaXA^-Y-!
    }C#1,RIwRw>pI{\k1_D7EjQn#_^iGOBon'r'Tr7Yh{5YC@jRwKAT{^-,Ea+u~}>ARyX]E!HG?kel
    >O~HpTDDa'3ABJ4ZQn#_xX?+or}Mk}]AN-X^Yz,pZ.@A+j[OC>BoDvgJs>CX=uD}pX{i7Z7Kx-IT
    \'o3{;QKB#kU>vp1.Q7~oe2UmQGUe:-o$*aeu<Y<>TJ[5{<'!}#CmXo5E,.z?IG,^?}xvOTMxvaj
    BR^s\vX7vn~ujzQ@}XD[D-=nujj^kliuCQ=?_BKexJpmooz1*<[;*-<J!YZkDHa~{z{5A_$!G51a
    sx27d[?KszET'zZYkcyn=BmC;JIpDZVAH@^W<@}K9o[j*DXo+#{AuGY\^'*~3A=>{BBAY)C_#nH\
    Y21#ww5DV'^K+Y1pQlo5~^rXxVV[olae#kQQ>!\Xe1|53CYUAu+l}ap7-1AmV>>F$?wu|xY{3$}n
    ^CJ,@H5;]2n]Zq7p_Wl{VJ)uC\;n]{l$1^;!_2>=oA1{7#~]e!B2'*wEnll,l=JE^uJ2BnEaG*3J
    onZ#nEkjw]Z^?p<C5]IQeJUY[Am'\YBn}oY$GZ3C<vaGnxre1{\T]15\TJ~YHr{]aaY6HYoC]{@W
    =~zsvuJ@1KZ!_mzHa$$lxsI{m5i'2+Z3Z&p<,rHz$^}@lZ2*C]XCK'Qv=uO{<?6\V]UTD)TwO'S5
    !{#D<enR_{?meU\nox+0zQe5/ljJ;ICW\_zOJz_jCi\@;RY$TCYmRCW!<GpK]r~TZ[Rl'U}[A&KA
    Q'!s<{eHOC@O<[.^n,YeUp2,]EJzM:4k>Ra*vB#noKZfDGm{xVAjnxXUoXa]E_=7-_iBk']}^o$^
    ua@=ow5EQRr*,p]-ql35vxIHoXzs!}HzJ\m~ExY*#[G~X?5BRQ+$<qHs]]7kYT{YD?wj2XrAWBI]
    <DE}CEv?CJmo_er?JBoR{7DvD#Y_W\>nnTW+@Ykz~{q@aCUda1\*HGaw7wp^!w-aEk>#d\^Aoz7H
    mD3O*072*2l*THo~]
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#u_BBo<Cz>z}Oma=@j!l-#jv_3}sm$C5V|.Q_$[IuK2=~3={X;,=-5{S_'+7leVKBAG;\<2Z
    ,*ZOcX7+2U{){Ck;G$k\s{ErsSKwJUz^;}MJ'+H1vH50xzuR!{H2H_zo<{O^0[;ouXr}x}!Az!Sm
    TA[vZJ7DZA[]Jr=rv3<N2C@[3(*@W>bx_?=\<I}_'<uGrU=<=#A_Q{Rl5iVV~!=p\V?l?M}$sYn'
    [vXxuD-]-e^1_7'-E3Exkl5U}'~=!J|BC-Y-=D1QlW\C}zQ^u-+kV]r**A2D'+Rgp^B>Yp$nUEH<
    }C_2Z=p&W'^*HHTCFhM2T}^k=Vx[?=186Bm<Rm7#WQ2WC>j!#0v\EeX'EnW$11M[#C~]_z1xRZAR
    2(=#=j_Tn,(Tol~iD=KuB+EH=Q,w$J=cB$-3K-G_}5<jrevw=I]_pQBOv9jRxr7RO$QKpo|EPCQR
    UZsm?<sTC[Es^{61WAV=#x*#He7rj%%r=G@@Hp=$1H1}_w?[5B@1,J_G~]XXr#=#vVonT!<i{12;
    &bbzrO-!T]BuD]ua7DmE7HZVtYKRvXX<~9'2Q]}nl5>5@plZ,RC-v^MIW.]X<B^M7<-;3$A#Aom>
    DHe!bCV-wX{!>9{Q{CZ=7AYJ+GPXQ+~C2+#I~K^2$1#Xx;CxeXsB<'^m]Ap+]w]V1k-s*YWd\5vY
    $kOpR2*#Ww>-HQm3vlR]+vulRGr<HoI^ajlpkY\[W=^U1w3Iel^o=?Q<yTIK2fmQl-I{7rqGZ5!>
    9Ck[#Ir#K'z?!!xRA.Iz=]cQnOuMCEQpjmw,Ic,sG]&mU*QClpE{Y[~^r~j'Gl~WD$~1;;H$GBmA
    HRijXWp7_2,{rXeexu7B>pw7oU,mOja}We]o~5wDDR*ffCvJe!C=1lW}1Vx1}rumn{7?I)~']=H$
    7OQ3a}vk,xIi-+\nXGV2eT?[Q3:!wvjEn12^YD'l#>X3[Yp{7@AXN,>x],e5X#$?$zep}geRoYe]
    1GG#Vn]qCHr5$3Q1V~-C@er773WV=m\@@5*W^@C~xRD+Iu*!o1%l3\pYm=J7XDwjGVz,\r7E5'Re
    IB1RUUr(LG+zGnYBTCZKHK=sn_VlYGK[7>=[J'ODEUUJC0I]*H'C\!v#A!#IKprGCWkHC~}kj[w1
    [=>Au_=O!V?pso+V5B^RJ*-=I^kEo}]j!]BA5G>1D@B2_J*n!E;rew?]i_}t;Diw*1]m5$I[pQ-R
    l35wB'$'~sE1y^IXTv='D5vXW=l]~:V_z<lOT*lEJQ+Xe>$-3C?1,nr#-5E?,~<X}<D<2W15DD<$
    ;G0Be?s)=_{2X'kavC>\RJ=-ImU+e+Jan5zp)^5,<Cae+\3H2,,}[wI1iB^KIRalI0o=kD'$Awi7
    wzJIr<H6#1;B=JE3m{>7)#_?CrV-^QJ,^U*J!DC^W5{mTGWQ=3DRXEGTpW{]2<Ye#DJZ!o(pHr;-
    x~!>D+jTaK['1ikVZ];;>*xj3\pe\HkAo=Ifnrk=JoQK8UeJ2!'nWpo#u,<G@xZI\UjO[>tI>Ewn
    p5r^T,aYl+Yt2a\HFDmEK(MDm@suIYx'{CaGV<r,pn7*%CW{C$_$T]w$1=H1IIw\HTYWxxAK^*WY
    1W=Rxr>^*@A=TEQGnvB{{-V^XBIK[v3lZa,!!}V+Zpmxi+<D$UNL"'CY+7m3ZoEp[IpRx~a)NI<w
    rPhRZQwWs;1?X^}=KJUekxe%jUUX-si7'v#O2=$IlluW;_R$uEDo">[,\U[iEh1^km{sE$\{DJe^
    8D^CXIU}^pR_KXrx}paZKZ$[mY/rQBxF2SuUYed-'UwxG,~eZZruYn5m}urR;v^_YsG^ZJ2H,lu*
    Av]jB\$ICp1G~1#Vn3Z-eYC]iO*RQ3\ju+@Rpw$wTYJ];Wn'EI3'#p1,R+CV3@?>rD^R?'#(%Kre
    wOaCw{7Ks11-=7aZ{}@}x:YX}!sT!sz[CX5E{??n*z-<~+Anvs,z5psHsVvr>Y[D;l,#$Y'CV1_u
    2j,#$Dx-,~c8YG<G4UB-jkCKa9vQYY-l1QCac@zjlGnr7I,V.AnlDyg)'iD^OeG!-xxmJr3C1W1U
    H*k@=w<EpHKAKo\pe~;CZUj<k$-C,A}Dp}_@+nJXCkp7az$Q?RnWGQ=Vzk[xA5"GV{2i75<R#wls
    KHX*e}KPxTGjFl>TJwUr*#SXO<O\+7-=KuuX-mw>Y*HYB$R{>p^{-Cr^!$xrH1Ib?+z'N:#TWI+e
    TloAaQall=V_{u.RkR[CJUxEn^\]-Br|m-J{-v#Gs**mNYk+16\E*weHlYr!Ae!xx+n55IO*JO)0
    lz$Hn5,H0uYkn7rzGJHx+}^Z*v[iD\Z+1$a<{!Y3,3$meZ\i'YxVuH$s~@1>>lVKa>r^K7a[wlRX
    ^G{\nU(3>X5OV753a~R@'#?w&~Si+jvvG+O,7I\KDus*@3,$Qw~_QQB$Xr_C#C\~GUoE<<^?<w&[
    JW;<lr^Q#x[Cusp!wn\Ic)O-K<tM+ar-H{D<lA'-E~riAGvp-Qmj]xRHV~@pRn^p3[saG_]o<+^I
    >e'joJpD'nvJ<(DKJw,,,,}llRTp#,2x<7ap13=ow}L'[YRq?{mm=7^sEaDYEk_wgrYX@LeI_'7C
    U{]kwl>o[,K}e3+\@#j1a]Oev]]K@KwDI~<$nV-{*@\a3^{xu7'TZB{X{B$lK{@w}E2AEKI\~joz
    _aG]<1;8Z>[<io*$r1sTxJ-K9mTu2*A]~I_Gw-aT_#oD2-lXYXCs-L1!OC!^e2J73EYe[DaxZl=i
    ~mTl_]]KrnAHJOgrzEZ-Cr{DrV]DIVozw}l9Y^$BUrR2{I7UkYrojC^V_+W[mRD2,evX9]_2sO[X
    !MP<HT2vI<QIZE,C#BRp\eDg[H+@AC[Orj@5(Y<UW#YT,@QC;moElIA1BmVe3Imerc7XG$*l[~Bv
    C3esITos3E,H}5g$5QoO*<jUX=~p^XaoUJwBA+<Lur1?H*nxGUs-+nsz:^y{p+CG<1e'x]wUR;C{
    [XCUHj~wlu~wGjWP6;s-Ux?~e\kDp*1?nF-_J_!]21[V#{e7UG;}v'w13*rW}^_}p{Hp^{T_^eCp
    1]1Oe'r{wlGD+p,_RB=RuUxTzYup+73'1k^^a@,;svC>\[m{>zqz+BmVa*ao,-aXQv=I;-llYGw{
    nxj=,Z]>^VV?T^3jwno}Z}K+XZk|*?\~Qi7,!<7oZ{Z,lp~C#Qer;HC+Q-{,5^V+^]$GOBi~;A>B
    HomTII!X'KJXIWv-ji,[l=v*^K@$mVZu$EwIsQxEBYx}%DaVeX+x]uUKl$^]2PIu\G7n13,[~KU5
    ,G!jQY7Y'2%XB!@n]>]uX}_\vZUTrDD}C3=I.R#lJZ}aa7*+YZV~wz5z{U<REeiH!n]7XJOB3xua
    Vf_H2z,5jBN~V3U+Hsv}Bax*~G,Baa5?s3uLZaU\uUn}3CiTGk>^v62eo\'DGex!<{T\]+asCOBI
    p_r#]iUr^pOo_GN-xmK*_oUpi<{~r;Q_WBZ~H1+@Y$-vr1K@va?qX>sDlUD[qeCIQv?qIDTWXA!-
    }K!sc$-]>YzF.D^H]e*!YGZw'oT[1[Du5-O2vT}>DUe+Gpnx'+1k]}OGDkQ=G=rC<nA]AwY!oL'@
    J2LU11+O\\Objs='jXQI57kTmp\V_!>1nRpvkE+~[5Q1+*J@Vm-a~{HBsOD'Y$3p-e@XQZDC=EkV
    RpplV|;a-XIz3'<vKCR-H<RQZGYlT=!>>[DK2\\\w-z~KIWskv5!mT'z\j1x~>V7vnJD*IQUsk}O
    R{7s+#rTm[$iQ#_iAKViWrVUO3w\n7^j1DGi_,l1~!n5mE^a1m,Aj,3VZ\HEuV#VE{&|Zr?J*&?A
    uD$TuH#_^\J\@=;EB@&wz-e75DjqK+VG%RZ<]$U\oXBA#Ye-\3erIlj>nVu-o\~-\T]CxX*<*%5[
    Xup_VUIW+]aVu_2D*;,!OHU>\VpVVH>UI2,p=OrvuEo=+5ysU_aij*i&wV_$77U<IT,n>7W<3<XK
    -EVxAO=pYU7~J\3TUa_i5-T1ZBvDDYZTI<5v==I$x]pXI7l-W$p*NU\Qu>e+DDsHKX5@U=rAzosT
    CQJpQs]^njioCv1_Zva2OC!JHKY]w~5XWCe-QIIxmB77G+O\3Q-[1~D>VA'#eG}$,:?A{]a_GelB
    jT3+Z2VEnBsCx*m]vH$UDJVEB2H=;a3U1I1vT1QDiD!'_on,HRj]^^J5\Wza_\^,?]}a,I{EuxEO
    is-aDWzQ+T+,ZB1HTKH$Y^<}GWZjU'wjwuG_,ZOVAW<$Bjux.3QIOdjpDalTj#'{xeUj\Yo}oGtz
    ~@w'UjQ.pi2?x~;]GlWH3ECHD>7K_,!>~5KBRw<1BAjj3]ROEZ@G8jEI=fjBrOEX'QV>R'-[XTrA
    a]57o3KD_m/i\>J7IY\rR<YyDnoA71eD29_X^]-D+v_Z}$*HYn&c7*2[a'V=$='O0D{o*p4"\v{R
    GUzk\nT\UVi7HrJau\#o>z{nS}77p|OuK+@nV[Vi
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#'2oeUU<'>nRCKsZCAxRv{UaC!{]^~aK,"N&,&^Ju1$#X}7QR<*uuo,uDif8Q\-#[vBT<7x;
    Q+OJ<|OZz%lwJ#*+[[o_n=['CW!Ul$HUl=U7BvVO#$skUZ]R3TJh_p?~E.'H~K1\Vm|8Bi,B'3Wo
    p?]H?CAV@]=mnxrnT[xVI5,ZT*;[keZkwsQ'_ri}_UA^S<5^$@G-=}>*sI5k}jB]$+wYK'#sH?{T
    ]moVQoV#zoHBH$r}@!5z1G)3z[OBn<JBu*mWTo5R$oO\x#B*]D2F*$HO,,?=^Y]D4aGnZ*G!K1_G
    ZY-~;Rnn<I?Br?jrp{XU#/".hQwQA/&WCQ77B'i5[DYBB#xc*ZDE2r$J{,{xOA}_^e^oIZGWVu,r
    IZx^O$n#BH-B+{2?*?xv]GQ$jCkkZ=XuG]x]oGCwzu1^@xKlsQxw@wYJ}F[}oTulR5vJ{Z&I><aB
    jZ5yRQn3nCG$1!CwvXu}=?m;-nA[YJEJp0jVxiGV,Gow_I'Ez7e#B2xeGV12{,7_BnTe}}'msWQu
    V{V5?ZjAV<(Z'J!D1nAB@HJ7(Gz~jy{wru2]AV->B5V3J*#_s'UU@U[RD}e;=-j_GWEDQ@ioD3Y\
    !-'Xjsr}wYT'vb/^>CmQuaTB<{#~U5~2C<[[jiZUe@!sCv[5!72+IkB;}l@\j5zU*?eE?+{5>p;0
    DmB<^<1YmRB'HCZ=_K_DFZH{kxr\W;]eu]%l?+5VKAKz!<G,$k-\-a^li@3}3OEvW3~1]I!XQu#,
    aAoQ2CuY$^+Pl+7l[GXwOD\iUrOuRA7JD*QO{oK{D_e!tln{uTv3D!77>)*T!?kTVO@sG[37*-oZ
    a{e^}XUeuC<5r1C37j^_e@7T-<GCxik=C!_RG=omOTC_C$}SY@7iYjr>(%!v_~!E!\^uV-$T-~R+
    {\nwej'#JkB,~-5xD~CHG;$GX5+*Rz0<D{['H~AB*BQUp[Je[wr1A3@l#T^=e]?=XlV!_@Q"qY//
    c=z3n!]#\l-<K)drV$o9Ho-Z#*w<ereeDi}kk5e~X]l,}2\ojDZWH'.WxDl?*e?V7pi(THjT#1,Y
    o\*DDwzGql3=woU77%oa_xs;<TVZVwT7uauUV{>1xu@G$UI-lCF^2vQZaXJ!7zXT<{#X^5a'_AYz
    ^#3'?5kQeIl($m{ohBX4Z{~O#}3^#7;p*>p\fv[2vYprYjriCpDIa5J$*17aJ'1Q@O~np-wTzRR*
    VJ_^C=D+?7Zjjx)xz~mO^1']W{<kYB~=*?E#{jmGH=>BxQW|sAE]m-OG_+>vQr_ZQn~U9*D1uyuj
    <Y$#*_l+@n2oo{o9N@I,1aOR+$D]~07}!T,WjBTE,TE8QUAo3'zsZGxsl<<<I?{$I*7E|,[TY9Zl
    Zxu*$O{>s2=!!DAT\Bf~\>v9zKCBH],XnrqJ'ks{nrZu*'!sYZuxRE2kj22I?nmT\@I\<{p\12-J
    -m]}!1k\BGKj57>oO+K}=*Vn5=3*sW=6ORkuX=vCZnAv$W2]Rj3k,GJT>^k,ss[@5xXHk5,'UDJx
    'W}kIr5;lWnzvW-k'uno2eB7[h}vav=iAmiz7ICUCZkV$][sTTl2j;>{>3gwsR;\@@^jBB@^~v@e
    W<,\nAxI>{]=@!RGAs!@73{s?V*[r27'#m#_{{!4!B_~BUwKjgQK[_^2X#H[X3:<>1[Di-Z,em1Z
    o-;^?*+yY]J3~a$klM^{7Df,*1~I}\KDA\OoIRe_B#='OB-OKCw_vOxxw-'N1l!C72vwqz?&{l2C
    kImoiwBm*][H(K$}ii^2x=3n+lJQl]^{K7$rUD2uVIJ]eHT\V'QXC}n*A3E3'AaszrYsQ61G,u<G
    szzk{>pBjjAHH}~+rwI!'>l2]x_jdT]2[%1@_VLo<;'?sa}+aeZ'!Dj!'E->]V{.@H3n|mYs{j-!
    >*RrA>G>p,5+JJA~xPw7+_<{Q'j2CX_$2OQTD\H$>!zQCHOCI<D5ZG"&WQl!lEaX]z^;,^_jo$_C
    VD#DQ=ljzpxHFAnw+1_UUj7mE~ssRnv#\3Y{kIDi<7>WDBpI}Aw$,l_D+$eT<lXoz=*VV1AY^%lM
    alX{:IAO{{suo@5Tw,e+7RG33NfskAo;$}-l__J\bS\Elvr_\_
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#epCZzp3[jp3WTOa]|RGwsIARQqq9o7<[L,;D["p7Q1>'_54r1*5iSdYX+oD'1j!'7GQ2WjJ
    ]J]Q-Cs~{BBY6+1$'Q,AmOoXA31,['>Kj^iY\|_j-=J+zr7'D]#$GOT$]G=k2}1e1['@1>iC1TVE
    $CDx*{vKEA|;,~\Iw>-.mrQK'vvrS\HXa<$I[>{$2o<{O3LtKBG$n[Bl{a7>[pwmUHBi{<CEX94D
    }rZ^*\}eBzDSW'G1K5W$Q},r^p}$&*n\;rzW7wTVlAAl+{}AeA1kBCiTQ~aA\D\A{jYGkIZ-HGU+
    \3VI@ipEo>};\osUH[egDJx]}'Q<2,~$zQR^$c!QA$<]]pzvmD!5Al?Uelt[I+}uOCu4'~W=raxa
    }\Zx'3uU;olA)x#m*TxZJJO<pQ'#}VV?B^;O&1W[!^#_rYC[DYz+#b3=1YmTZV/2>s=[;^+61G#a
    #wuwVI7?5~Y3!+urOOA,~smRsu^s'lz@:r;EEn$T!,BEr3}}xfCB*JTaY1dDA>2>*mvJr^*l'#ml
    m3r3sJI<Xep$e2xb\;^?}nYUv-dlIB{@<>JiOJ[mz#'qK*b3TV^Z^Akwa[XJCi^GzK^EuW^C/Hlo
    Od'7w[j}HRjv7DDKQEV5zkXO$ppOZE|Sz)Hx[I$'su=],~HAa@ID{Im_^7D~3xJ]t5ZzD!I>=vms
    }9vW_iN,gGz>a6*RACX[Cl[XZk>=l}8ok}mP{=Z!5?d:#R;I3EZ1*!1!{IR2u<AJ_,J]*UElc=_{
    }7KKA50Z&pwX3o>3[R\~eqP?pkJZYbXB2BtWr}ll5k-Ilw}j?*{jY[!Br7[<zv]rTHe$K7wB_*C<
    ^we\ZCa,Y<Z~U;-z}\u_;}U},{{p]EadkQA=$/?rGv3CkUZsG?Yam11nI]Vr@{nQ1Au{1aao,'pQ
    CjQa=iuA=>/$?AIrR7o+YXu3{37xAxO08#D1]B+-m6d.xIi$<$D-C^A]B_]!r!HE~YrKxDk<!5@-
    =^x!~^77w_(,~Y]<o1m\@Ii|kUJ!zn~l{]\X~R]VlmoD7]EXQ@sjZOza]-vuCB#aK-l^ie2-<}<O
    ~$v-uBEKs=kVve5+O{maN,;XoNd!B^@73WQ=@@E7~-Vpp\[E*rG#Xs*[}p(>_7,7BX~+YYr-$jKQ
    O}7Bzs!nTBVr=<Q01CoZ^1jBB;^'vnjVlvAWh1T\WPQp>WvR[l#B,@p~a_^OYA-E13*=_~X]KA!l
    eQCpG7o1)7UCD'uBe?<a2GK]koX+rlu'Ez,Be73]7l}]?Rz=n=RXU=(1_Zw*GV@CJ=@1Hv+l3uXB
    IuHN=<Q\$p[^1k3{'E]p>5D@YZ}Y'7>\o~2-A=em)Bp1={+u;eK@,[>KBVs$KKX+*Ep<,7Um\b_V
    *I-=iTT1u76@]aO_Xw;$nm5DnejxxK]Cs7}?5kJoreWIk2KC22whC<[T/*?-Y#-YruxBnVQ$X1HB
    rQC;WZe[~o'ak<,ZWvn{U~1YXW^TAfE->WUlw},E?LIDO@!o\Wz~e@A]~wUjKOOhvp*O\D*@Hal{
    Uv]@UoEBe2~}vaxHQI*-;OA2DD#Waa-O.wYXB7sjYQ3j>Rx$jL?elun'#G1~7n$iTYeoEwi${Gio
    z?YH=[-$e#a]nWT\}QY~_CA}JA\x\e<Dk+xT!jzW5*?=luD1GA8,JvIoZDB=oo?'<~x7TKl_k'7D
    +!?guER~;qJno[Y?!7qEAe]cY-<W~I}-z-}~lBpw03[eIW>7o3nj_|t&r+XT]"DdsZG[\DYGVXpZ
    m+Ru1qu*u?5nsrKHAwO1O1g1TuJWO\'0va=Y~[\Jw{[R)AoDA{$TzEn'O|e[1v,WWH}r-}I<@RBC
    ^DG<XmBkXXsuKZn7rwK}\31ODjo#_5wT^vW-;w1}=CWr=pe5H!$-;kC,VU*Hul*u=V>B[so73,J_
    WYG7eol<WCWwAuWQ,#.UX-;o3D\<onOE{aE1,2],GJRI_^a^iJ1;T$jI*C]^,IUKUT#GoHJiGQ$l
    3HRTsRnX-an[T5G*A+VMW+aAoK*?W15D^,Ce\-nA>QwuXBjAwrIJj!RB@8OZ{GeB-H'ewWW*e*K=
    ;RY~\kp"}ZpIr#A?x>IZsOo'3Ge]?w!kl_D\~$1IveRoXX>C(?sO^;+p+ccC[j7ql#X}}TjmYKvO
    GAEK7EYUHT[;D1OQ'HOT*~}uqp3^s^r1B>lB^JpB7w}E\dnTK>k+XeUjE#<jEoEmC17['kAe~XE#
    E@(yU>^TO$pW(x.}5n-GTJXp$r5r,3->aCeZx{<c#>^^CRw?Hhe-OVF-nx{ri*1@O-^xHE~2x;R3
    Q{$xa{@I~wE;7nJ#w}[\zz}9zr{}U[RaR2Pl?K[LH^WKQ^oA
`endprotected
//pragma protect end

// synopsys translate_off
`timescale 1 ns / 1 ps													
// synopsys translate_on

module `IP_MODULE_NAME(efx_asyncreg) #(
    parameter ASYNC_STAGE = 2,
    parameter WIDTH = 4,
    parameter ACTIVE_LOW = 1, // 0 - Active high reset, 1 - Active low reset
    parameter RST_VALUE = 0,
    parameter OFF_ASSERTION = 0 // 1 = Turn off PULSE_WIDTH_CHK assertion for a particular instance 
) (
    input  wire             clk,
    input  wire             reset_n,
    input  wire [WIDTH-1:0] d_i,
    output wire [WIDTH-1:0] d_o
);











`pragma protect begin_protected
`pragma protect version = 1
`pragma protect author = "author-a" , author_info = "author-a-details"
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2023.4"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
n9GXfY6k/ZhtJD9kiUNVLtaH0OSdANAy0snKnBtVVWQ6QOE+Ndo/VTZDI+hGg8g9
BQuVUO9VYpfcYCQvBCADNQKgSAqxFZjzIRV27HIOeZCFcQqQWxv7S+5zWngR1OAV
+Gybs11Q3LoZ/IBIGBpd0XnkdyubJyu4oBd3pKxGDxxRxImpbWTGclPoIrWLQbHy
BHYzpKNiI06B7YEvoi3X/d1pKZDVylZEMUSddSlug+uFiiaJtWQh6NA+z/owDEDE
V6bVUxyNm5aGjXjEzEECUcMJcfeV956Wj1jl3fVxGiNP0REOhvPr0bI/Girb6uQV
p+McpZkCfrqzEUBv+tF25w==
`pragma protect key_keyowner = "Cadence Design Systems." , key_keyname = "CDS_RSA_KEY_VER_2"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
ANz2D8YrxkPjLNtSoqQ0qL/n/jE0iquIWk/3e3vE+oIaj29rVvK4slX1wAMRUX9N
upY9Ha7G82YH6HOWpzJQwnJ2DAY0Z3VQ3OFLkDk/Huz3SCQACFeCg8JTJ+gkqyIY
3qkzAdDWdipMtrWdFBeESV7jsaxlunckrpbgbEzci0JaAN21i098RIWuzrZr1HTH
dhLLzlbWTgr2KnB5l9x0HVdJAN9fzTDmnCmAJMU6tkoHiQaAhQNuBUDo0LAEd86e
FLJDJhF15fh4yrlIrzYr3WEqxNEjnYmgMEPuSLo8lQrcsVIomt1zamkCO09pKhfp
/GUCfdkRxv3JWfTNRFn7gg==
`pragma protect key_keyowner = "Synopsys" , key_keyname = "SNPS-VCS-RSA-2"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 128 )
`pragma protect key_block
Zr7q0eHhaH7ptNB2EeBR/IQwCwGbZ8h5GSZSb4880yuCpqV3mF4LyVsWhgP/s+oL
K0Ls94YLsw+5IXRtW0LZarLJwXt3vd7exEKa2b4yrwhA3xkg4lvSFlzHYvUrejVb
pvELZpNMkl7gKvWAY1rITa8iFy4DIl/v0EZIF0sNnts=
`pragma protect key_keyowner = "Aldec" , key_keyname = "ALDEC15_001"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
FuzzgfHyzdkm19HzCmIN77AO/gXQ89jPquRQ3E29Wuyahb8Rb3IaHBb2xF+ucNQz
iriPZJpxHjpFDU1ldMRZs9rmKQ1IEUkfM7Uriu9aXykiHujm16In9i6+P1J+GMdX
fZceSO0vZqr7OJB+4FbDAMjM/QN925xh5XTjFn6MNb2q2yn29Q7L3rCuZPQrb4Vn
lEQirmTxGZ1E+vr3rJPjXwz6dreTQb/ZBO4iFjveuPzjMlqJPyzHguB1VpgxGTPN
IqMyha9gI2WVCxiYdOnU3qGdds73SXmLkRRdn+veAxtnq3kfDb9Dkm0Mba9yro3D
hqg+l7kOuLXNiFKheBoksg==
`pragma protect key_keyowner = "Siemens" , key_keyname = "SIEMENS-VERIF-SIM-RSA-2"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
Nfof9ZZHl85LF7VV8kwqITImnG3WEZ0P0YVzEeGvnS0PevbCKwpIf9HZIn40pDjp
6C7dsnYUSjkFk098OQT3cxa3sB4nEQ7tjghscEBIcr11fLIYDU+4+loBl7+vKhSE
JRtG25f4RN7VbiA9wVAQvgQi4ruRsPHC7WogI4wtvEQU35OHjmeDHS3L+Wnepjea
LnfRJMDlzCoG/Czx+a+eVXCSIDfoPGZ86v2+jnHyFeDiO0Vs+tyViM9ODIUyuDce
hi1T1CYfxnmsbjBWvmVUO1sVbRzXnMCK18kgayk/a+4zZuMsazRunqrSBabjCfrv
HMYPUZ4HGf4jWmz1yLuexA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 4288 )
`pragma protect data_block
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
A1csd1tPOJMVvTV2UTAmlw==
`pragma protect end_protected
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#rKG?rvCJ@E{Qaae7s;s>,i7'&Gm<XWTYi]#mDNYJ@I7@U[<[;+L~IKaH=w<o^Qs#wGCV$2;
    QQnO:X<+2U{){Ck;G$k\s{ErsSKwJUz^;};<VnzxCXX{Dwo*iIM(HHm]XI1px3eR$@OZv=#$,Ej[
    @-72QCZk2,~aYj+^*@R;;$eBpUaz2w\pIk!sY~YEu\Z1!<xpY*A\?r\A/N_z3+jcp+u<1#!KH$Q~
    Gp)c,^Y=2},wJ[?3[J1#k]]*?]DB'wa7E^],bWT~YX=kG}JU#EEK$!'D~DY2\2eD],{>;B7lim^!
    #^B{kc}Vi*CpZ~]WD\5Dku'*<~mo[Q!^a-<{Q*uVx[vl]I<RtasAE}zWQ;>RU#*sjno+2v-!G-Ez
    jwR\ov3n=B}![nC\Z]Kp5>=['viVsrjXl[$2m^5Iuaw;-3TW1B#+B{RRk;pUzezHDL#-eYAEA7jE
    J2Os'H4Eu7]*=>j=TQ,*<;EH]Ka0DlTjU$}7|6>x-_[a,iAC=C;<c("VI5nWwR'zR2z}%~X{!e?p
    ;[psA3QeRH}V7iAuz'Ix21\<sXEEpiB;Zsk@V-oYn}aU-?<K13sC_J]~^,Q}JN>BI\B}7$v?ep}3
    r-zVTC1zw\h>72X}I+YRdAw=[zTJTZQQAADEOsB2T$[;-a=H~?1^'w'n\=A3A-BK=pXOCVQ2pGuB
    -ppQ2hQ[OD\]1X\o$x1}Ck@+zuIGxae^lJxkJ[j@{Cv^AoBO}@[n'YB#RJpW=zfZ$\ir;WOnU2Dn
    6!<3*x\rbIR=7GA-Z\B'sl,E[#{uI6+{@\Bj-<m5U{-w<]xw^W2\l'zu-^vJe{Qa{\-n,v[#eGnr
    QimG7vIxD>hWrO1VQzWu<~Jko,aPTE'+[_'=tT<BDeAK]WQ\Qmq3Xj1C_2_[\x!Io3'==R_,u;@Q
    V>*+z[w/$3wVx}$-sQAzG,=$Ew,rLD!U[oD#_o#-@iDp#,G#!E2j!iGUUDV,z18|YH+lzVoK.k$2
    ePv*_\>A1;$RZVGHV_VVHp667B<u{lwB$es?aX,U3x$=\#2@!{KT3ziVLf\J7D#RjTI'A@kpx$BK
    m*\nl2JHw7Rw_VVuQYj~*$*+]v{{>o*Zew[>vzeBs#w[jsTB>>l2ZOm,Z'{eH-=RBkz{EkE{XCxu
    Iu^,>2Bw\]Y='n9j\xQY*5p]x7I~Au5eJx^vX*}\mzxQVv$%WOT^{*E;nAzJYLvDep;+BEn'<X5G
    ?[noJrG+3]-eGG9$aw!,+E+}r\l{{Ruj5CQ!o2#VB<$R~urN-a<G;nU5?<YIloA_8{CA'rOknR;I
    zI\},V@<;[p'<K{Y?^Qn\-5]J'W]@t-z'^}o2^,IuAH$C;qj5nzHsY]]YKwypQE2[D*e5iAk;[RW
    J_[JwH^eDEBlA*}*@*Z\H=<pE'TeiE}]io$?']\B#>Zz@1xowAo;e,i>Eu^EIpjK=*T1^>I&Ii-m
    }{>~A<pk!oH?{}AaBEGww<Y-g9Va@p]GrD'$=?m<Tk2_,J*R:V\r51B#[_,TupQ]>>E$+;l$H9!R
    OZ>]-\[G7vap*VxolHIYGx]!*AuVw+:ZTVB*RnAG'WndsaDO]Ja,_-$G31\Q{O?TZ$e\/W'<T#nX
    we;]Y_?Z>TCim2j51H{!?_W,kXTJ_YTueZvYv,T~Zje<ljiT5}W[UJEZTIiEu#vWXToKwJ-;rEXj
    iYx]Ip@sV8jG#s;1D>l-R0Kp5Qn-osji,EgB5+p#YZ[o$WzRZx~b/4GZ!k]<@zYQpiU^REIm;l[C
    5zHGxl[@J}i>s5^V<$VE#oIOWG#RD<?s2nY!epI-V3zG~^;V$a0?7[=[O<2[$Kw$Y-_R>r{aG'G~
    XV@!C*JBN}3=31$p7xCA]b2BDi;HR@}JoCvOm>}KmCD/"-$api_!B$k!u,>[}ErpJ5]jDTDO[+\J
    ^=_QWTTu~E'7k<-pm^BWV]#@X$}!EL;-[AlCma=2lmD_k$bWoH>]?R<UzXW[3Zl?IUD*U!T,W$O7
    ZoAvHZG+wOT%eloDv[E'C<UIvO,w=wz<lsOG+>*i(l{DU={avw7YX'URC|n]W>iRXep{,3pUzu@1
    yQT$1}~E\71WT&jjs[KlE*lQB;n7{=i+mOk{TZzeB2EC#3KCCsK+eQyB@nDS<Dri*\iai1KJuEi,
    ih-BQ-kS|_^WurKVBjjIXE>sQe]xzJ^}C>vi=\1OiU$+Gw1?\Y'pU{C$r3=v_^kj@?aA'Wp#H*Ve
    Oj2ZT!\{Oe$;IJz\*GV-e?HU2*I731~w'aRo>DnnaACZ^VsKVAwR{Rnx-+nUErK]*$>u_Wsn;Z[U
    !}izB3'>T^OE2b{+rYrw^3a5@r]GY,j[Wk'@}E'ZRu=-+ejk1V_Jw]13xwU5J<xhjuG<$#oO2Y,}
    <>DWW$@a#]z1j,+sQZ^=Ym+=Y>-HnQ!e&N>oW~r!_]aC@5FzCUE[6rRT!3V>H[i=D&dJYxTUsaW1
    v{eZv2@WR]rG1x5Uo1U{lk@%A]rQDEo>+=k5-*2UjpJ'+oz,x?UC;'Qjz^s^6j5-\v!prouK]yXe
    s=1l-e2+Wz+_3rs$=Yxvv73BQedD?m{h^^X+>>xJ3XC'XllRerlJK*A_~nwkZUK?\7{xpsG~Qwus
    nO-VapOB2Dp?BQOZ8Z'7kQ$;;oi>^_,r@:7+QvPnplTH1]Q?-oZBQVG>^]eFUa>{Aa+WWa,^-nC@
    7\=\V!v>R@nO[KjE<hxT3VTG7sa5mA2\>}@7VZJvvKzowEXDpvnH!v#oR+_[=e{{UGKs]GC=e^n$
    *E(=w+W];rT6Q>3Rn_WojWaDKIC]fw5<zlv=^JCoT7{J+%e;X+GU[aCAril5K$]mBz1Rr,$G<**A
    1@Ds1G_EX>grWC3PO3,TpnAA^A^[o[iW1Hl7f8?,xQkjKA1w^r*W;rD$H}Y[!0rns^jm,ivv^!5^
    Ck\O--jnZ[vmAE@vTvWezD\GjUZUm=mz7~C_1Q+HXxx)YVV~u}ICMNnsxuV~!+[e\'sO!Yuzuu,w
    GC,@RwG'\uY37!Cmz2VUO1$CGzk=m\upa!eBR{E]XZ>-Aul+o-wzoW\aB[ViXrnBom#l$'?{-_QE
    *5k$r[Gn&ZQla}ap$HD>TUs_1$'YujAZ}^[!7Hlux7{oAeE-E27csn$r'o7{I_GGsAIUeXmxJBC_
    fYkvAyjE}{{^;ZBIam'e?pE]$XH75HspZ~#RzW+e}@nwR\RI@Ks7T=vno',{{x$)'$j<1Z'^=+W7
    3><ATv$i1#MrWz\|X]<Y2rj-!Hll\n2!-j=V0B?\_4oaamw{eQEs!VjXHofl'WEOeW$VRs+v\Ewd
    ^mY<G*\_TaCj{+r2I+j<JeQ]mQ1i:+rxlx>!>2s'n'n,1-*]aBxRX(B!DlBxIz1,2r>n]]2RJVL@
    T[3jQVHe$[GYE#[7oVG(kG[aIE{<)=ap@G~2!-ax-f=>RDJ^leZw1}]-x3i_srVWU!1nKDnzZzNr
    QWAGm,an-sU1s<]t<r'IG^^^zuBeL,*r;n.kG@w<}n$,i3mj&YaARC[*}h*AE!pk<j-V{$Bamm&%
    QVQoX',]-CaG=r{K_pp<ZHOe+qv3xpv'3jHwC7]AT<P@'7$pX7~xu+U1YE_[lUR#6GG]r]ET{z@@
    11C[ENx*x_YAWv}-UHkjIuJr@*:;57#VA*Xzx~ZzzACUE~QIu'v{$ZRrk+W^1,spJ@5.CYo+z,YJ
    avBXKUoOO2a_IOaRi'GinODC35_@C7\sZp=r$n<^m_AB}J5K*WeRJjWx>=wvrUv}uOx$?sD2Al?Z
    ]I_n5DVEV},<$>XAPy0KG>]7_E!A=s!]j1*ju@pEC<!~Ip,#BR$v#ZA-Re2i\}oyR*+*;CHJ>Rn@
    E2J<[A<lOAKAaRjs1Q~5lj]5HxUD#\JG1exmiQpz|*\;!#D?kW^^n>R_RBT@}Pe*UT\3@R-A!T]\
    lzJ}]Aj'$,3a=$p6ji,T@DUkR+<E,pze\[-#C\ek7@vQ"j*!!JjHWKOJ;X>]{#{=i-+e+KrYlqm_
    osWnsV;]C=]jp2<'{eR~T\'[jvupaA0TBxspw5Z)s,''(vr*YJ}H?j}]B8I2l[e*R5$x~7j<K]T5
    _'@w_e{z$^GG>pO0u}V#[V+-$mYkfW'eR}#@<O#Hw^<TZ[nB7+'A5+T^a%^2pT(er>$2zQo5p[#e
    BvwO1#B?-pBT7;}UpU;]weJV^=^'~-+lTsw17wO5vB<lu2<}G}mX[AwBV*Ej2I~\IE$}FP5wp-vX
    [2'r]+veeZ_2Dl@7rn,j}k+[D]G]j@WOYv-E>HTRxwa5jrX$pKGGDv;}ADw*zi5A_A_fI]{meXEk
    jJ,u=r^CGrrKzA\'}2}5$nJ7"0Kp=!C?@av2mw>eR~*R$_n>@2!oUJR^v=^_\r_fl_RRmwCukDAB
    {rGX)w[?sz*3<Q5Rzbx3@#kXoX#-Q1X'K~vI<Av,Wa@1!7-7+mHa{,\]#El;\i]=jO7~m16aGYr]
    j]pKRv+fa1+BV{w-yQYzv-ADUk>q?1i-_ij+tZxi5,]B}Ue1UZz[w'pw;KoH'[EkEZ7ID/iE@IIn
    ,lH=;~m7+T.j<*kq;C,zYx;<.7pQ;0[w$^-B{@*nAzDozlK>@VYVrJeperzan$YB3\g-O^u*uoVn
    av>7V+#\Z5WW{JIG*AkZ-3I}k_0}7H;7nEn6YCT;9,1R]AI>+b=ZG^#v}sM3sDE^;mxcO}%pX;}_
    WC#^oT{p*XnlUnl~A[U;}KCfR[UKx1IpYV!5Nps~r3^Y<ruV_I^37wGEU}C_CI~V~_~<Dx3jG$DO
    ~0pG*CATDn^xHEJ5#o[-\{WwJXjGY__>p];T^~n=AE*we^T-KQ-$u!7#CAR<~p>I?*oA[O\U-e?<
    $k1pZ$qR{BvaAA>zuw[Q]k\#1aU1>2_Y<V\#oDAw]Zr-Eu1?XOl3<;E^,rn@]xoS~5jV{++Hr\x'
    1v#1sOEXiR<B'@GianYr3o{Aq)?jjJv#GBH_E>lTRnVx^RvvD'&H}iH(6!IHCYj\3KXUzoWo~Fj+
    UU1?WZYClj.ZDjko%~rTQ7;E{_3{#K1Bm+\^;w\x?V}_,-,W\^5^sH+>_<-=[JrR@es'm',*E~D<
    Z2oY5]C,_<_>]{zrIDaK3,w@'\O*\=WnBvvZoieKGl3m[V-,l{]^TI{xBx-s*{sDRfU{>,jQX]?Q
    +HOBemeupvr3T,$Jj7B_K}8O[EKv7\A~^X,s_QrWDsQGC#^A>5@2zxR;BT<[Ew*^K{_K5TR^2eQq
    R?JKNl[2l5,1KWvGvr?*~WRl~Ym}C#]XZ*p*+G-Xok[UCiDGmuHD$#zoD$OH^3vo\eIWpJ}?IEYi
    k^2'Tnn{[0"k,C?G}XKjjmkl]QeX$O5}{W_Y1*XC,v!XHTWeYo5H1k-VUppCKpXea~;VG~CIFs<2
    7@aW=,2@zTUE2Tw@3Tzee3a>rg{,$;^OJum\[[rw1rrOVmI$vBr*EwAwGo8l}<rm7ZnY'=];1^^_
    OXjUn+I_DE'a^XI^<}l<T}ZVnJV$woI8@z~RqC!55!<@wc>so7z_nj*4^JE1a[VHIZQ*j<<7D>$R
    O-v70'DX}GVx5X<sJI1i~C?@;7?a{*a$3x~][s*vk1A^u=CV'XB@2*\!RB*'Rv#$Il<!=-YI$Bp5
    w+^kC\l,_\HCvo7E5IQk#17Tx\?5B2G$X>AD?OQvKa*lTDj1IekR$O$l@B#x,WBBBw-W<[e5A^55
    @m{7sYQJm!vD{sCHeIoW5@E~B_C7J^j,'NJ^lkgxRAG~C51>Az_Tz#KYazvaCs_eke}tWn$aQapa
    m^B@Oalr2]R]$'}$z]pIRp}\T>aJCCER;V^1~pW$1Gj~z*Km8VDVA)[^vZkoHHR5e\o*koY1ejz2
    o~,@{2j,Ga<nY^\mu]zxDY_oBul>2wD@wD'B7!2wY$:jDmE}vll3,ZQmYeCr!=?I~}I<\_pY<{{e
    CH~@O<#sXO$pCv$Bp<?IYawb7ru!=XE7O_$Q=m@Ykapp$Ol[ms+@'Z+WKX__^5x70EQVOC{;+JT;
    ;aGi3~Gm]BaUlaO!{H'[,uso+;C\Jhf+G5C$@7G^[k1[5ssheV&!,TBD@l![Awr\^JzG{$1I]zsP
    F2ao{D[\opB5vV*T$BqIm2Z~+}?IvQ>uY_+G_3J_2YWU]TD~rrYSmAGT{{<}mH${oXzHa}i!#_?u
    H'N_Ts@60koBE[~U?*=HQ~p'E:-C@Y%s3$Vv^}!,x'm5iOeAo;nWGRsvVww&o2W3<DWo}N7O.YnD
    Jf!'B@wvHjEYR#7_vY;}pr!sk3CQ7Jru{Vb[BZRo,I?/loJRUnHzfDeE'z.]+s1{rEU>D~KJ\#{H
    vB?\%qHRl;kGs*I'?3IuW2IJ~o]VlZk1$ofv{]'4?UI}KE;]Y1O?U<zTF<o<157aH_K7vskG2D_r
    kIuB?-x{A93TJ\X>\!i']eV=@@{w_#mIeXv\li?Gs{WXG1zJOl]]7+rZHp2OGa@_ZOJasxX7*oE!
    {7Rv$1x+omJwOJX=3EIU+ajYYn;^<Ir7TUev-Y~xa\)&-e?#ujXxj=$e2Bw@VCn},<E{a{=OX<3Y
    r[1w[}KKZI1l=,-mRVro<DlGU'!~?xr2DT-oK<T=oQAaorHApm{!jY,?EzKDB-CK.a9[OHakvCRo
    ]m}HRC<*_zR3p-pmj$xuV{?kR+>X{\,$_v,<$BUY;$]!\RC~^z}}mQw\x~A+aO,#n-x#\l*X>=3R
    o}<j$jB'aYR[JYX1{4l2BYDso_5eTYxVl@8+1mC;{\2[C}Vzxe~G*sAhzIKounu?m,vB'EXl1@vQ
    X<z'xR}XHU5OGs\'-'JI-o@XWRwlAr7lE_Q>Jr[?:As@jGVAVV*T<u^wefz#2*#j'CA\lem,G#u,
    \U*@_}G2{$Ups^rIwJs^5>nCAa\VV]QTs3]HE}U{5w+=[~|qx<!;ws1BDr?_#E\lx?A;*^H]rK]R
    Bx';5i>K~'DT\HO3>TxVGT]_>+3azAj#IXv@Rze^sGX>RJ^}^RpU~C!$;QjU$HVU'GI<:#>5koE]
    ?$WH![ZI$q}>lV?+$Z*s{z!UJ^%(T}D@UvQoOWuG}YR+W=3Z*^Q>kYIJ\W}w}^2lWB=XuA*<p_'c
    OY^XapR[1o^3CnE,_!=joTVR/RzoDXG}VixwQlWaC3j_?7GjnG3~I8_5jYDm]UL-He=dWCssoO_J
    5Fo1,5b^XWa15[;G1'~Yvj\q=U!o-Q+ms.,GiCsA*31i-{G[}IKwX'-OQUhmR\I='5+n$rIHTj@s
    >Ys[*K]\1GT7w>>{QexGwX'5I?2]5*5!rspeG3}Z+Ym_a{r.XwpZajU'v^'VRA*D[rE#3YHoeRe1
    $'m]y2Q*-=Djp;6cm]A=+=z'{-_YG~57j,a2${'!O3~eN+x\\6wz?>,sOJ=]^IOasr3z2OCW{Dr\
    ~;!ao;7WxuC>Q7xJ[Zi*?^Xj*ZZ]X$h7{z2ek}?;7ijDY#J@ru[,;Tx{^??p>'QI+{^@ziA>BJkb
    OxVvM^wY[}K=EGK;GuE_leKY]ej#x1_AJx7o#pII])9nHZl#>\ijs>QPD%Ne\j2}i[2[#A\#1_Kk
    Ol5@}ZRRpu7+$e'aA++s{wI]C]raoln[e^lr1IH^TR5FaE'\'v-UZRpDD^;CiRKK_3J-d=T\+}WE
    lJaur}l?jSO5<BJDnKMC5ruvipm'xR't;Ou,rx+?mI,xCwX<nCzREg}E*i?^A\}5'HIG-Kz*1w2a
    1}=\1^jrzDU^eOxQ<oZjW3b9rxi1V\{<KBu;*QZ@ClHYCTz]_+mR-B{v*G{T)k${l6(G,3Boa{K3
    QQ[2xV<$e!j+7z>r}e[UGW,\Ao}wA'3v5W?kBa{71+_^{epS,'~;TCY55~mj^>nQVv1jWnUk91l'
    eZr#=9us\J1T@U2l_=XrI]Pwle'rxTj,+Qo}TxBA+{x[~7Qe\os?C+U=/]y]wajeeZGIJKXpXAHp
    [BO4vG*sSPnRl[*r#;bD~xoiEV;^3BJ2wp@}aHEaw_3'2*KSwxH$:eu1s={nW^J,e7,;2f^~IOGQ
    ^eQ1-~zQ{xLHGK'DJj3VYv#ws7eiV{p5HJox5WCC$$pY;e{IoanqnAK7O[Z;mD,GO\3'sXAWRJ$+
    7lTusZP\-*E|x\sX+H]=@]lT#{>2%^C2ew>ZR@^<-KVUV:r?n>,GI#9eZ{GROn$rrQpBj*zopQWc
    ~AK59|-sW{P6H-73]=?$p>s$A'[=i'nx2^#TA7s7O}!eXI^WdYqM_iUx-]a@e\\{,JDV#*w$GYei
    ,\G=u6#RZBCoz=vllCn8EiX+Zv3m[R"kRkOpE>mlm_O;_PWV,u5~Oo7$rD?[V}R@e;rQI[O=,kDu
    gxrO;G?-]v#U<s1mYCJJ>W*~Q5kz'=r-'$XaRAvz!usJj!pD_<$Op^IwTRirv,e!U^ml}z*,wzIE
    DVT}jwDYR<5Yzqluxk+1_QI}vAVx$uQ@+KG3uWH\p=qEk'Uu5<z*-Q2rD}jwO_>t)zlZZ*@D1*{m
    nUx<1>X}Kp>[r(Rw+w>\{pDA!~[^pz4G*-R,}s<H*n<@CH{v-O,GZUk3swBOp*;DK=eA,RJ*H5{z
    ;3a[x;O=$kEU_-_fn[*}E$#[E+Oo_#<3ms<ou*Z5<TxpxG}l5*WEKBu1-lO?G]uWma[km{[,maCD
    *#*?RX;z7X>R@_oIi>\RatzZ*+Q5VBr_Br3zv?Tp@'x2@~C5Qr~Q-ReWBO}na*>=Z$l_xvV32ruE
    e'al~GCW+!#15Vxe*3ju'*=x$OmIC[1o=Rx^AY[n}_#XGY*CuGGmK+~'U'G!~_XvxTbxzmAq[A]K
    ;YT^j;=zxAjXinz1VD@[u,Vw{U^};rC_X7R]zBTT'wDZi{7#ar2?++$BBJ@e?>l]fEp}rcKBw1SB
    s#zro]QGIlYf5+$3ovXsc^zB+G>3#-rwD7j!=xx'wUU;!Oo*'l]wxkj\G-VjG^D;{Aok_^5\\$[3
    o[[YZY'-,p7W{,=}aR_uCI/BJ={YsB{!j;Of]$vR;*QTCA!EBeUUOpxak.X-nV$V1sU5{U~U;RX7
    TA7[G,={T7Taa}a{W_r7>Doas]_HVxr=JKVUJssU;<5ujQk]DjAH^;raK'vKTvvelU!1aazj{voY
    UT^nv1%2>,~u\vOPr}\QV2Vxk}uzZan~iR#llk+BH=$->Q,j]Efz,$zl3KU}'CU1m[1-Da?:QoTu
    'JpW^3+~A-~QfXRn7sev'Dr=lvSK<T~2oU^ZD+orO@!i*]O"DW>jVm-zm+_u9^jn\Yk=@lD_k1]@
    ^HNzwTlXo35OJsVR(BnRBV77Z.EI;v@Vi$l51J9kv$z5W=ZoUZrT>vIOrWB-5w?[]^Eoa-!:y$OG
    {7aC\Cx=,p'\=-[IupK[Q1xZ*i,*7C2n*x!w<7JYa%CAJr3<
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#k7BmzIra5^K$.ueuZXpa!VK<Q1s^xoEr[L%~&B~!#<DUOi=_Zv#JaR+AueWjOE~}a|0*pwE
    snn?pHQzvjk}]irz!w$wIi@DFzx^QI}VCX$sD72[lNW'#Zz,C!q$H<pz{{!Tr$pYmsQ9aDj^FBmj
    TP\a]R1;]w7i3[kswr3\B2'r2k$w=RHV=io<Q{\Vju2Gf[W<?:ERzv<G'i^zpR]U\{s?o2?}=YaU
    C7'~T!Ark[&1,C^!$Ym1%lY}K{C5VEOmmjlKrdsanWcYaK3,me2^o$jH<5$a*>#x[\w;}p]:,7Rs
    I{TXW+Y3ZxA#@{A~B~G,51=\-z22fo!$~{7I[MIT;nEwo$c-a}CQx$'dQ2pev\ACV3I5I$$eaYYD
    GOZQV;<Vv;*!,D-eH_s]WxZBE_G#B!2x-=T=fTH+~G<O2~YjkRmZv3B^plHZ?-wm!{eVT7EQEXOR
    i!n!Qvn5_IkH$_~Ex._Cvp1e[=i'uovj+p1<lQQVD1eR-AeD[K[KxQoX^Oa[Tx4|OoXxx2A@Qa!Y
    g1W=~E*BwlEj1>jnC5$r;]{QJB>ZD*;uYGR7@}QwC=mlA/GC>T~e{lCivv_CRj^9?ooozoRz|V2K
    !RR<ROVQxJU}TB*Asne}A-ET,k^>uxHn,YI7=CeZzynx#j-GWuE*k1~U''^u~aiaX!\=@Va$YvB{
    _w$Vn~|.G>X7[-^73=je[3-x~xZBv_v=1zs+vZx^ewD]D?B*a{C[~[ko7E2?1HRip=TEapjrU{_j
    IC-@v5'@}JKAxM\u]2EA\\yWU3['s<~U-jJh3X!D"r]K*i1DVI@-5Do{==mp@h-C=]!eQ5#*\seK
    TT%^.|Xza?X5(^;{xz_-vz7V]G#1Z]v#k1*<pZYP1eHpTpvjR2m=1^_+_vsH\W>KVo~7.[!{I];I
    C=5@s,_~Xlx<I;HjkEkm*qlkwvQW^ICjKvp'C@>nQz__kDE5G$W1~e]\;VlZ!@V}p]~n{Yn[?Wr[
    \x+xH<P!wYHQ@j]9OAupHIEu5kw3BRCa^b)P5OOpy^5nRo_vVQ+GYz!T'XVD2!XC,I?{RHa=^O3_
    X51,',xZ{CsV,Dm3e7x2Cx@<I5o{2waD;coB-+r[iZ:v3nlvOzm=XG2Qu2^L.GZBG(#+X$5GX~Q>
    n\}5Z;m51jmHJ^p.Fs3XC@T<}UeZG]@<?-_;K[sA~WT;5>1DmTrQCVwI5x?53T[5!zm[}}Tjr$?K
    w^~}jAC^ZRiX$=!'*'C3?(2'szAX~Ug*A1K{]pE=QVY|<'rJA>pv@RV$\r+Ze7kno~<GRR_xWDnI
    wTGHQ!lA$zT13EBIm{771k<BuEnR7^>R*}+a;j~$TlB?K_HDB<3pjGZEci$![G?\YVA-Z@_lX#HJ
    wpu~sTXjTUlm_qa*'@*\s=*<=^=-{#Uw]KpeIXGAE#E1Tk${u\{wG7]]U3Rk@BS,=o;]]{sS_l[W
    1sjW\iKV*B=Wz]p~sAXYRYovg12'mqvQ?xj{UA->}^9Ru*!B5}AI5zon=@lwDorZ[nVC#1Jx5DHV
    ?T[N\\<E<puV5DvUxT}A{BUJm\~,@[VBnUxXOs-s*v77xJ\Y#s!oy]ATwi+zB\2DXDCo!O1#UI=p
    ;px7wB~Gw-IiWr'wO1GW<^Hzx]X<WAqKe;^$7]EkUj#pj5J=?xo*+XYE'Dr{Cx_Vuu;6pe;wIEpQ
    H]D#~TV[}#u?4YHworAI}1{p@Y!z1Ion],u7I'BRC3BOXl,_mi$@#^mD@e?R_R~<l_1+W!D|"BRG
    ~<11J.eC*x15Z=DXQ7GJpz?r1,~C^$@+T1h6LO5>JoOnnUX+WIYVooXUzAQxE$!,Y-I,@\!@K3sj
    -w\zaa<@TURVsu$m<ssAC3]3wI}Oz7Ep;e<DeVl'<RenV>,V2+*{!_o]_U*33A[u\pg>Q*viH$\x
    Oe5HCY7kE;AxjiD)TGJUz[n]m-G['mj\]*W_d7=?}+S8_e?v7_!R
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#6<<},TD7O@{}l$rwK3oZZ_n=>RO^zH55[yBON7kQG=~WO$VV=y,a51co!$~mQ*}CE/W&wD@
    sqC|z3C[EfkQ'Be-e]iXa[zx^QI}VCX$sD72[lNW'#Zz,C!q$H7pz{{,azT\Q_+$wt-=][^;{Am^
    [!RRu$7\$?[viro*ipsY?Y!H=_lO35vO*XQQ{?Zs*k>OU{lvGs{lA*5,?[(@DpJT,!#W]<}+D_HH
    {]JY*=!'^D,eU2^GKIYdIuQ2J$]2[;5{>_ZGD3OB(Dw2~\v,rnwen%^a1Oa^~OHD!xBmQ<\oe32*
    ~YBr<m3VKW[+IauXKYi<HOWB3AizJj@OK{m'H;?DRJBJz*+Umje],XRL;sm{OzBl1,z^IpQQ<j+k
    x?>Gj1w*p}I>pBxwo-Q~R#o~,i*KY[eU/1YpOCu'oXC<\1?p3w1+Wu]ix}2Gjt[oG+O.u'_ZK_!a
    B$KKvB3n,#KThD<<l7~'pL<,=?_nUB![;jD~Ia&V!RHUn;Z-[uZfr>TRs$n#A5]@kpVGol#]k'A*
    t;'X1pCbiz;pl-w\xKn,$?pXsk7@G7psI?FQzmC'r[wHn1xv3@j,AKk-YGK]^Z2[ZK3;Op@-1X;r
    w$*PwYmvW-m>3Q5zCoQXw<!U'~Km$vBTH{s}eI!=sEQ2|E\n=5TH1!]@1QRJ^]R{?YD_$(#*oUFp
    \v-Cav*z=T@ar-VUBaTrK]k]G7+{o{HBpsJ%%r^\W@*xDW-[D^<X7rYxv7@vpQ5\G$>w?sr+,a}G
    HwDn}Hp+K6=1-AY!1l\r1s+CRi7=!IA7?'''+o=$_E1<[l9={-Y7$X55}[!A[V@iIH7d~U'nasO{
    n7m-J1nua$5IJ1{lAa;w_Ewzqka!z2qpe<k7vzuRu'we-1e5rK#wO$vIkOWVe?T}3z[R$Y3O>x<V
    u{OIIQuGRxo<_UH^v!58<{[OIlslUo@~d#x>![zH1mUQ_(uXJ~#wu>kOna=oGr_2;OZ]H]/}#oZ5
    a7!F71esKUC_,zkr=zexRCC{Lf^jKHs;I]sm7>oU2_E\*=ji-]9V*JE^u;Dq}\A<g}R3Z=7okRXQ
    T'@-C7OKJj!p?rmwpB@A<iX@'WaBZ?Tu3i\*aUR~UFY.*\~_OK<2*#@s:5k'_1<<KVu@Km>ROr^Z
    >YTCiUaj-wUAoiOu!1J}?XHQ$']~?)H7{WI~2IesTw=mIzIKz#F/1xE2,Z53^BQ{%42}_]"a{jsH
    Hv~zI$]@-+rL\iaGR2Z~2'_l<\1s!1X2RI.fv?$?-\XKK7AnZw^3B2eOq[_5eo_V!DOGHX*2vsjn
    ^G~!>|\^Jj%xm}~Gx*!B_R3oZD7IaQWY7l2[;VkCD?',uG1is{xvw->GnoJNap#A=A{ae>B}wUz@
    XsTKU\*T{Qp]!rE=3<Ore0RQOW$I@<kUlj?=![-A!2O$owqmr@agC;e}OTE]F~C+?!anaZ1Cx1an
    a3[Tn$!=\^\+]zrlWOJX[2=oV[DRoH7#=*zYouRQ\lrx@9=v@A+a>I^W,VVQmB0rY,-h?V,JnAY$
    r+}>@wKAHAe{KVXxZ*$kO1o[}l12@T5{(}(^i\AAxl<]kuBU7{Gvi^$]2Z$wY[3?lkD;_>#/>A^<
    Ia<=[KR-6<}CvoJZ[G;A,sRo5K}{@Y@5s7\O7>+1,kzwv7rEC$Hj^>$,C12@GR@7wwQZ;*GIe|rl
    wQ;GZ}:R,wpBDK<u[Q5j<sY<,Ensr@s^32HBUr!_@luC]>Z2\nBs>T\MTw}x5awp{}xO;E,K3^xO
    u><Ca=Amp@HG21_Y}YTj7-1}$p}r^7v;I*sR^>r+wR7C2v$Ag7!U'Tlir=BmxM-zllyC_*U-}?#v
    ^vu_3-XCrk~*?rRzjj@[Gm5TC$<lFr3Qo7k>QxG*Xj'$esExT>AYn7=#a~AxI!>zJR@*ex@DnmQV
    B2Apnu><lI-D[L@UG]OV{1Em;u(V[a{}muY4,}rR_$X,gSJT'ngCk<o]EomlRTwO5En^{XkrjY_B
    _BV3n<ka{KC>}{]/lZQKVil3:>[a>x+1$w,zOVHBBe?;=^WzmGV$?p,@\2=pC;l]rm5Tk%Zp{1M1
    m}mtr$QXM/oZ}Ci\_Db!<D*A}[Gx?oxw^;$cI!DTp?W3[z,v1REko*jZl+Xa,w5!DI<=[I_'w=;7
    _je>vj+oHVw+$T^v]^-BXIXY5X>'[_@E\iw]E*,w~{]n>YGo^s\<Q{R37}><]QVK1EXR2lX#[Ke$
    #op#YXps+DaEw_7j~B<pvnRm}w{'T*A$s!_~\UUsvC7AA'W~[m$@eiJ=D>Q1>E{5=T+nC-Bp$2]R
    -]Tw2Y+3A\Cx[sXsux~A3T;;7QVB^^1aCxA,s_VH8]2BY/~*[TBT@+@aC\QOl@Eu3aYrXH']Tpq,
    <sr\VaQr*+'HH>zV=VC8{VXork2vBsi'Z5+?[#>Xnw@'RVT$(DHROjrT}BQwr~IO-w]~E-{+BnAp
    '5Ko][YIAV3D3*7Up_vaR>rrw?Cq7r<sin}^GT+zX_G=sj]DYK3-}O_z-+pEVk\QT+Ax5jkl#[mX
    n-Xm_^>GRs;7QR;1z[*kGkJ{FipxW_vW1n[D!^1r[1{zz+BEw*T5u1$UDwB[H(=$<Ak[-#%Y7'kH
    [+Tc'}*2oBr,o,Y@1!,zI@];_B51[#!odzi1]n*Jn#n'o$m5UI\;2PIj#BK+RiV,J{1!\1k}E}R2
    B#A915Eo{+J<Y7e]i]le?1Do[Ko>IYIe2D-xY1$GovJECk]B~E[GCsE^s0-Xm<v'Vuv;RorYJ~1}
    Q[1V\vVouAj*In$jB77Jx^=ZsG^\]GoI-m'mw'$1x[!{<rr!v_l]n~9ij?<XXODzROo]wACQ89}_
    <D]*o>RmTQZje;$3O~$X\I6']j#[Kow*IGeg@p2CJ{u$>r$U!ToYzl'E_zU=eAop",C*ir,}B1kv
    jBQO~l'[m}+VH;53z^\{a>{mBVxKE5e*_UjwB1H'eWGU'Qp!C#]X}ez<wRTvr$I5<KAT+x'$}#xa
    -{QVvvW\G1^>]AeRo$K~xJx5-lIV+p';D-GCwNnECvEr\xpZ$!k<{[#j1RVTaKRi^Riw>+zmDlPH
    >VXseDiK^@Qv}515>VpjUlQHDoQv[<O=X}TD;Ga,ZalHn[l+5p<XxJ;rDXzipA}WjY~o3,xdCkjD
    l+W;_T-2_=7'\]Hzj3*C0li[^l{=X6I}RHapDn,*o\CWe@DUw]xlED[z*?)l^aA3-]w^WlBlZw<E
    ~~=5#$R~5u<*sOBkAv~|B?<srZC7^X-\BnE[1;\pQQ<<eWIn!T}W!,,mE-^[-=aD{<K[v#^Z7=$A
    7C+XUe<@x,_3a]<!WH$$2_!\92}QAo@eEme?5VwJa8Dw{n{EH$1AQQT>}n[nDAQl1['CjmHsQatW
    rlC{}Q;,+CZvw7]]!Kv'TXB2VI$Z'eam5mem*^B>,kQppxRHnJeH-mQvrVB7{=ue|&U<[eaUX{]A
    v!7m*5#Cr!D$Q2/=+1}7A1UBxHwZ*K},!wni[*z[lYOEx,WQJ!WYDTx8{qAzKKqu*ilo{u@L=piY
    mA\@QHp;s7vCj^IpedIrv-.1}To-jQm}uWAkUuAGC5^X&s77!,tk_vwOJ2Q2{^<!X,53'@a~{}'Z
    r?D#7r>B+u',AW{ajZ1e_TlHXT7I5$pj'@CspR-<}*o>s#Th'TJj7OAHo$GIorE2,5u+(-E2eh;v
    K!vKQ@l=RJBOD>5(zI3HB^^*~7$\kRN'MFoWX;]^2mZ=+_!j%E~x2w*ml\[
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#+T$HJ,w_Qon{G+>1rJDZ@$W##A<$^[!VN/<<7"5e2<mj'e}\3<[X}iGml?2[;CCJ;u(=u2J
    %<RA@@D=pgaap<+1$'Q,AmOoXA31,['>Kj^-1V-]3]_7[{jx;]}jpm_Vxi]}?_G,'>?rTvwt*?ZJ
    E_w?Y,AIxQepzzozkjH@k,1Txk3$Z$>*[!~o^z*rsmDZTeQG)rxnz']l}YsUZv~s*zzE~flz>sL+
    QnWnsrousY'Vr#BG1r[X\QTPmour[k1RrVKoU{<AK'T\\@{GnA1rpV*Ki17H]+uCI^{!bA*5~Ql-
    @C<o#HsTD,oWu3$vZ\qeD+_}OQ$IOHeR!Oko*Isj#DHa}!T>DRCrT5kVrkJnrpj[D!Y=5WBlW\a7
    UVex^A2WvBuZ[j]*v#*]$wZ=n^@BQ-}x~oUB$+5xiB{1{K#a]!3,[!j*{e-AAW+^+sisu,]<BpGA
    a;;25jxjWm{;DC;YnzzleCW^j]pjWWGYW+U$D{7,=lTB7u?C]i@Kok$a+Q@rQ,l'i,$w-akRm+E.
    +5-xzH1u;5}5=uRuh"3zG=-oEJ*EZWEizC\Wo1H]YkEQvi>a[\e;TU#vK!@EBV%eB&lI~v.][U]7
    =*T;wzRW5pE*-7avwl=Dn@V='><xI\lzHC,$_pj'DnD-AjiX1->;UA?7OZ~RQ,[O=Aeq-U>u^>sR
    A5TE?UuV;DH?re?I#$anWvip[-KBUw~?>oRwr#\ooAIH$B]r5Iup{z5!nj<-k[2}Xr<nxl2@,x{B
    A{p1,;z[lVsOoQK^qez2Bl];C{RT~Zn;pw<Ue^>}\*oT'lJUYv3\$6w{!>cf5vmCj1UBp3]OGx+l
    5GHG1+\mQ{vKo}R$TrZ;#5*~Z]Tm6Em@CQVXxuX~vO(SQXjzr2nVCHv@|'DGCZAG31>>K\EB+'mR
    K3sa~.Dl_@C5BQw^#ai=1C$p1]uYB_YQrDHea_z^nV>${}>l!p$]+$^I<w,VrDm><+GBr++oBl'G
    T$]z3sphl;_3'EY!A^[B*wu,T}\U3V'55kI]!xWIl!A;)DA;,bsY;GG<j;r{v]TU.jbBT}-#>E}r
    JH<--mk!1Oo=GZeK[1\|xKZe.7ZYmTxX15A2TI+=rlnO;cI{B5-O~+Uek[l2wKRjQuOR-<J{}TH]
    {BpsO1_Y>[-Iwjq0.-7&Wj-p%b!o!K[75-\\Ok?=Gm<EZ_\rKou{ouysn]Z-7CU*?_=h[Vxw#>uu
    7~Yip13z7k!;!_G$p'X?nxlHe$Jz$>CD>YE-z-TGF(uoT!MsH<;qv=G!=r=JuVwObno{=aoR[jk+
    ?+zDw}zsD>$;zDHWV)WDiY[j{[<=RQGp_IV_<^wwO1eX7Z,,,U8BprC-X7k2B5n7]pZexruI$7u]
    oX3BvRUD*_7mI!}V5{1:'~DD;T51V{<H_@+k[AHQR-oD[<{x*?Jk_w7OHB']!+$T]2}]]vzXqE8z
    Dj#YHmYT7EUrO-<3A+U^aUa*pEOkwQY!BI*0x1A?o\ekGVR>IY=o[<Xj,vRupz7~A*=R~s1]JD-J
    IDYRGzkQWD+#]oBe[_jJP*v~_k{{-g2D3~I1esEBA]7wzBG]5v}kn-hT>B[GXCpBkpi3>o\$=UpO
    ^O+Ar~oaD,'*+s';BQ?vUOvk$-a_js}@wzmtaw,WInn2IQ!I@lKm;'?YMu$$}sG<vkXY1V$x7iTD
    nsC;?3v@\Tz*A5$smO;*k}\^XBD7m^Hj]JQxHCQDE2Y?^[H{o$;v+Jpz]jwoQ5zY^G#xQ,'oVl_X
    ZO$J$wo,D^r[-Rz{l5{r^G['JFk=}7p][i*vi<XO7W&O{R5x]]w5\1l7wA,/T1^;DaD;boy:vv+R
    eiAT>5UEsD>u-'2vGkJU81BAp.p@[ZMxe?*"nBK_h;\2-A}[=F3E*Gm,]{/i\QBRYv5A-KEAO[ur
    _j5B'WT[T*{j{5jeE7<'T'wxYJzO<D]lJGD#+-KR#BU1Eik>R_CAzGWY2D>4>\<,T<CH]Ek-'@H$
    _-2'lXK]1p-r<[]_!-K;!vrn5oJp!7a_wa3YG{KBT+Gno\lj<,_s\'{BRzsoH\-K=v,AQ==@l=ko
    =!XVwe_D3p+we{~^Xr;2U,];8QK\-[=$~{\Z^j''AQ3RnY[\-aOJHGCWDI;EEYW^I2BYHZYxXy|o
    ^KoTXnjcs2$;vTY,Xne74Y#1$vGI{:R+X^LaQu1RD]#_w\C,-a[Y2uJ]_uEQam~DEn21G>TruwI*
    W~o)OBQmsAa]x@OV/CsW+}B\rQ+}*=xUK'wDOG;uWqC^?OkUW$3V#w!a72lIDXy_{2$w_ae[(Kj#
    a6z\'KC>7!W7{A6i_?1#I7~Q_pexrV@GU{'!VnwHEVTvY2<Emjo=li^zke}OG+jYpT5N3>}wv$#!
    J^$Op~T<^-1[?VQ$JDEA][A!lnAKz\m\!R-G(FE;V]W'X]oJ\v-OH7R;Z*"m=k'GG_H},j}HGl1d
    X']$<-I*e!sBE3aEZX$<v_WrxupEVQ!?C'Dxev~p\@>uzunWmzK}KawKi'-]3A>W*'ao's^H1VB2
    -o[3jnH5>n$us7IT81ZeYuVsW5;m#O7__<eUp%p}_nfCHzxA5j1'W-O/*<]k~QXr,#OV#5\a$5w#
    WTO3}1I7dna$,R~xW2A2QY,veT5BQ#[B3[<u5!suUp;^Qw<I;ulxC3B2XOVV{uBTk'AR'2BeO];3
    xCmnQRXl@4j=WlvsK5-VE@7;BD'7A[sU*$o'Z#C_H\,z~TRMWG\jZ=1Z+nA?U<w>v]HTR]-''a5^
    A+<uN#5VQeAw\^KE3ZH='8w1T{~T<$B\Q5I{n^Dj1GOA>_2=Tp4O2^2mI!<i-H<FQvk3l,I-Y>lE
    UY1v<$T2\$2s+\C;}QQ_*7mo={B>jQB@,m7ksR[\_J[sg>>*Zv['-nR}!v;wnlY]RInXZCs>1BQZ
    3Q\I*3-]*b*eJ\^~p2r3lDxO@_ETDZ\;J7"T<j,D@*X84[mz2nET~*@<1^_+]KA+ws$H{#Ep=1KW
    !ouYW!VT5,>!Jx0VCo{V0x$[VXG<vXs$VEC]\aVpK0mxUHExT5nX@I^O[QNnGl;z]IrO+oC=xeKG
    E;^YvQQ^x2upIrns[**ZDqVe,[jwwI|Uw}5o6CA1C1T^mIHo^'<OmCap~,RNpW~m[,n=_5<ns-vO
    e>V-I\7Ye3CAp!'a\7^Xr]Q{pH_n\A@~7}eHIxaG$}~@E;'^;TEXZ\{Kx_,;~{V}?DRjru{Gm<v2
    _K5<zH3_2}Rlp5z@?RVs1+l>y{tg{[HKw${V^C?_VXl;s-w_eeY${{{>SCiwecO^A!FC+uYLzxer
    +}QK'Zz+R}2ev+\auR=l?wHa{}W+mE^mwr*iO>]?L-Bj'$5CuUpYpX[=;z?WKsU_zYZp<2^Wx7T]
    mvk2<}^TVCUA7[QVm;[leHG2>\+=;v;j=g'3<^\27^,B,jQT+,v;XCNXr7eZAlob>1@+X$vO@s$,
    z+CUn'AXQ>2Gmnn}Q3-I7I[Z'@x+L2<lkz2VU1RBwY-rX>^<J]!~AyFxTrnn<C;pIavuj,XG[<Uq
    /7\QupGvUGBo7k1{Iv@]@)t*1iY[$iz'oWjz_$,ka]$HImp1nno~]]Xo-ll8W*l~He-H)J[BC^#\
    DOsHXjDVX7#IQ%!wT$j1paOR-@jGsXkr$uI[X[QzJOQR>*J\BuerVVpnW{TR=5P_rlvj7k{,-eB7
    ealWR\,B_]mp5=}@<C=1uK=*xpTWoi[7OW?Z$j[^[kwJXm?#waxTGU2lBu]Hx1=Y[YH7m7U%-p?Q
    iG3vCjw5DG,+\TCrxaGIQs'\3TCH2U{#s7pX;AJIxX=2Z]Ea.TzX<R1+p8p3}Q^j#Q>j5JyMK1G~
    to]^,,^JEzapWl-2lmTpl6E>>nKXX[;,AY[Q'udV[@Bv<WR@_e5ETCJf~'HDv?XD1}-wEa<uW<7$
    I5A}~vIC2]?eBr~Hj"q5W^wmzJ12=\Jl[]OmnuKTAppJEVxT<><1uYG1C-1Ho+R;{3le'5sGwY!_
    \AmaV><1al-7GT*<5ex\Ql]h<=G$BC=VZY#w,1Rj{['vB7<#~Y\R{sjC_,3_"WCT@E~j#7omaW\E
    lE{EveR5T#eO?V[okXGV^FzJG\[E,?~Gsw'~]oOvwwnHxDeZTV*2jll>2jF$O=]=ODY^7nR@ll=D
    1i'+v!s1&W$]vp_\B>Uu2deY~jIk}ni{nXD'#CCCT-E+DQ3G@2AvzU1UW5Y;Y;V$;o7wnEG7r$\U
    A#uT__KC=Vl~^*;[o@kp2Cg9\1XXOTYOl'V7^KGw-n[wC3\u7BZoXOvXH5_ER#;}z!Za[AzeZ}$W
    +]zzH=}xeV2@dQ_n~0kU;{ROH}vBi$(Y7e2r,C3;,CaVGk2mBi_]-,K~Du<z,>{I={@@z3{IOI!*
    2QlICueTTKXBwZ}Y}Go/EQ#~x7!\CGeER#Ts\AlQIj~~xWwp#'TCH1'{lF3'_*<VT*r\i,;5l1x=
    J@erlXO2JV!Q3RIY*-[s[k!YmDso$R!X7GkXT'6'olxP1>$T$D-u]BO7&Z5m=@+@@6*V#3$*kl@*
    a*AO+Y5z-*+lxTX-J'Un-;l+O#$QYU^1~{ZtuAo*Y$3Tl5swio*^=<*{kGued0xnl$7OCsGY>uIu
    *!vsn-IXz#JEk';AA]-1QUO#5XvVa*vv$OFO_17Dpo>>VR~ZSon+}<{laJpv$v;5o,v<nmXP>\EE
    \+~?w{ZvvTRpr-*u=3pY"X=k<tqIiA+u=2<x}p$un=-^;ZTvwEWzuH!2UW;mG@ZH62hp;A'aR<sV
    7BjbiO<n=]<zoHQ~Ez5-jR!E$n\B9UCx3As=QR2=Gj2,ZOWD${1jRz+2KHj^2ID-vGsDZl@<1g>O
    m{*2IX#pkWp$xeG]\]7Wp+ZaQsZ>$W~R>^{=IYDmR@Vam[72I~mBpj2UrHDpe'rWEG$#;jA[3RvA
    \Ozk[uE3mu%BVDJ=A;K_@p\h,TaX|5RDDE5vwAUXe7i{'K'in_zal9b/I]7^41<A~]BjR#+WwAU5
    pZz-#,n~V>rX5?CBn_}EAwp2e7*W>\'ACvkH,8b17E3uVHG'Ia5[W]]51W1Vj@]C-rpQmX@o#$^g
    HB*,V}al6d'YXevW*A,{=XpBpT$z<1@7$X8*!X},aV;wzn3rO\1$]E7h%H*J{gUXAXG,~p=TjH'>
    +3n$,x!p5p3__36wEk+Z\=[~7]RJ]!#V3_*+X~nJ-V'l'5HM^?IQYSF-{l]%@G,=#BZwG;Yr-677
    7Oa{Amv-uVrJW,E@zx-A]7K+^7!$j~G_IW}VG-jum!I3<w}#R=s3YD%Krl}qG!pEQAKI]_ICNMKw
    n3rk}-Ov2C^AsJrUe@I\n@VC5\H]}Z*,p^zD\7E]~E<*rDeHw!B>~@ks^@%m-u?6D!=_T_D{R$lE
    ss{X#jozE_#2o!;AKjpx%1HEv^=55*[KjkBa!+j>}V7T-x}*voTQTHv]5eE?sizu{lz^jOWv[A]X
    o!ax~uls7zn\[r;Q-OE[n2DBI1ZCDRs;$@Y=DG?T,k{w\Iao53A_U~X_X^-U5K\}3Z6DUHD$,E_V
    HYo6yo2x~'@+mp3\oH_nIC}']7o~Vt'e;RO_pHUE#GRO_Ga,r5x$B~RZo'(+Q{1x1[mGuAR$nlil
    ;+w}'Z$3\KvVQ\\-j1lQZ;^9pp*}V1x'z=J-QuA>>GejF,pKx?*Cl,i_XRlH3=izTnlW^kH]s\vk
    Cb;,<l,21nz>[IwpKG#w^X4bC!@=*!{-:p$_C7]KV}o#CVD~zw^XB<>aosB1jp'3AEC5X[jYT^=+
    ;^a<r{lVv\w1Wo+_JQB2~J$\iu$CrJRI>U[o}@B*noj;v(v73Q?]lHCJ<aIr,,K1's2B[{fkD[xD
    K-xT}<O0O/+_s'%CHH_r}is<Qw?Dl}]-BA**#~DsH!Kv?Gi0y]1DIxr_@RGYJ\5IwDT7Bl_WK-DX
    +9~tX]]EYRu@vwCu\eI3nRxB[+*HaA_;!Ri=~,A=J>zC;pe>mnsRc@T$lz]7<UrJRDE+VHUmZ_v~
    TUIpG~V<sRY!!rw>Kv!lCoU';7Q4'[AQI~,uX+xOVHp<Te+$V@jn/JsR}siBkkH^G+'j$mwW^bPh
    ?Ul2jA-wG?_Wnoekp5\Y;xj,oCu];eKkgXU^I'p\,1KXW^O^5?>,,JO,[.qO,VIW9D_*n#aw}KCE
    J'%i>Y7QC2,BKX_'G>pi+aHo+uv2'YI#Q~3e=AE|3AKs3CZ+53@j'G$>>zIkHn@nA{zG'2!#sJ=<
    ^kCBX^+vvZZuI,ECp1{eBR_,.5es^u^!ey@H7XW=UE6sCn;;r*@DE{UvWH]/QBk'"xH'x=;3{H}}
    [Y,K<aIzT$=Jefzn*nvWs-oBsWz1up{n22q$2uQC@Joe1?YvRm2*!r+l?OY'5Tlg^-<^ok7@WDX3
    Y7YZrowUERVu=8G$r,'jHjXw12,TBk7o>HrWGs7Hj@v<OpO}-\1vI].ExXX$U~rpkG=IG*_mOOG?
    <Tszl'ZO!>Z;oA7|Vn2>O1wUvk$aW+{X2Xx;Ou{OV2'Z]r-rm_s~^1kvl[km,X<-Jr*3K+}D,HT$
    C\G#=A25O;ZY*GJ-uAjVIo^YeD;r1Kpa2X;,w[n{_UZB-O}?#wExG+oj_j*W#COIpM;^i{AwlQh@
    QlJ~Xlm%7wXRBI?-VXrJmU_#y^@E_7'omP^vA~]U[rvpB[lOpjaE?7r_!CI]nk*7E\$k^*O-*z3\
    RR\nEO^tK<R{V]=HKoXT[%XX$?cIB_UJ[pDRi~^YJ@?JGlp7z<TOI3R^+V3+ET^R'TXs3KD.9!lm
    !{'H,=k5V=2=U!U{!lXmze;wrBoawDE*~Fm$Qe5_UGe8\wn#993-KxUeG'>Q#T'Q]Rxx^RYW<'v_
    x@vm3YEz^<WXA#37$?Rx,K?]}G@,gK=_?IGjl*Xnva1[I3^D74_zz@=w^EQAzI5_{-c\2viIo#{z
    =Jz>[nam=jkl'#2O-zI@T=pcOx-3u5>nOvX{Yq<e_H>pcE3J{9s?a=#Hl#iRX7TYOiR3{@7m!_o}
    5RXw[HEalR=D,xw}\1s=>}s6OjkO7ZwH~-s]mHGrd=@BZTrkK[IJ}.eB^]?+;X>,-H][JB-H*uD-
    pJ^$x2&vf%}sJWY[mBE,wE'ZQsoO7u@T!*;IW~BZZ!>X'Z-17oL#XG'*_O]~1nj~,O*]&F}H$B9*
    [B99KU-2x,TnHU5ioaAV7,m3?Be5s<IY;jU@o{jo^+7!K]7]QwX_AI_Ju>>2y3QT[l<mA~7DK7Vv
    ^7,uw_I]]ZRT->_1ms!3BB+mzAn-,B\\x~\zQs>VH$wWJU1^~;5<^qKOHG-IR^l'DsAUX[uz]<Hz
    RuaI;a8#\A,5H5uI@l@3-ae_!GiZX$7vj?{3G{z6BUvA-5\JTp_m(v@;x[]'<#x@D'<-jKIn,_{r
    JrOj+3-KwolHTjWYErnQCouIUIl*pZ[R*mAomCT\p5a,G}ZlXs;!{_jTW#\m@C!vz}-wZ;E]vA-T
    3^#7D{a=Baj1v;Y,i'#E]$~$kn$j];5Q~\E3AyCw>@};e#1;[os^mp{ej{]GU#IrU2rz__BT;B.'
    -A5,e'?77V]UA_[<DreQ5@<i+T,bxlZxA1Dld5,v@RCz\Yrm',GAu@DV?[;K*]{v_C\<GyV2DV^x
    vIzaEw,CUA#nuQuD!W#=Q$e-W[d3C=C}u<R3w1He3];A_@zh1H@ZuOZ+i\x-J{Q$'}[>G7Hw$Dom
    9@Css*lQz1W-V$sj]VoTWYep^!x$A[G*1*'}i55]<C3<*G<B5,TV{y'TU@eRvH=uo?*7}RD;!
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!##'@GHw-ZIAuD>_\kiU@QHDC},sA]Vm*#=37,<RiUYnWWz[x\{,,$x{<Wp#B+r]zT3{Vi,~<
    vo*n]-nXuz3C[EfkQ'Be-e]iXa[zx^QI}VCX$sD72[lNW'#Zz,C!q$H7pz{{7?r$plrXQ9aDj^FQ
    T{TP\<]s1mDTP!1Ao\V+K-,]7+l@A,*aDw7?}Yu\K;<,?5,3aGMHU;<x!<v>{Z]XnA#3^ijt~v7l
    }>@WL,z_>v5k?1EI^>=<H,X1pl-GW>GYiG~<Hx^+2qBC=DGjN\Y^oIO_C1D\JxH*vTQvH_^Q5HjZ
    BEa-vB5[7I#nxrvZ[;[n\EaXCGKp1YDBD@,j7rz3ZNomO\QGr$13RHc6&#E]n[!UuqvIDT;_ZEtq
    ;=pnon+]h^~<}2=j<;w55GnCv<U=a7s'H?{Ju;=CJmU{ZuBIB?a=BiGVs_IR}x>@Uh^R<BQY[ix!
    oUUzV56l@j]P^;-QrDw*X1]J$ZjO]<mp4'\]'xk]D7mo[pYGpivBrm7~sG+AsGT!A13zBCCi!VRr
    ECzjlrl7sCTJ7RAHvYi}j#[AY][3XselZqOH1Kbo}DkCl5K~,+T'KT;o7"B\Duk5me~CKU@ox\wY
    ~B/J^3;<j5>iAn2jWX[+V-nF_E-$iTj!+7#\X,[#?hovs-I[C?bKnJmH__+YlQ_\}G$<jrB?Ij<E
    '^I,isXCjX!?E{_[3V!{*U]SlWHT=D{$xUH[T'R6ECx?=jjW+HQuS*'$@lC^HYp\pn<^XJV!?\,}
    e=UJ~+'3^Rj1*uHA[kT[kC~EJO[+pW.e1k!v{3#TY{C=Ju=Z{3_J&8VI}5q'V#?4ME'1W]Ir{yw{
    _U!IH]Q11wyql#1^Gx!mH'1D7>A'[!mQ83s*2,Ej}v#eoz@C~-aY^G^nRezXD$'$YI#ssWDo^MX7
    JJ_}X>*>a2j#~!CX*iU<Qu]}$~Q-]5u{<OX5w-Y]BW,oK=[mz7RWVm^Il+elBk1s<[}ebIUu3w[v
    G7C_neop[g?5X!I#jC^Co<5'~aOINKz^-9EGj<=Gm~wO#nBn2RqU_2Je3D_7RvziDUIp~5r#z\[]
    Glzxoi--C{\juavgsB-a|E;-RG?GrHB_5GZQZI$pYV}]#=R?J?jT;p~oD'{I]7Jw[6=j2Q,2v[T5
    R'H7w?J{K7Ex2]@+_G0kT@AlD2v]WlXsprnjG.{e?KRnw7N-$]Q{}k}VC]Z>Li}$oaU$GD\HHIZD
    {1Yv[,3mCe_n5C5TJ=XRKNuX_*z{BGBmB+):lm2T}u*AinKe(v=+z-oliDm]!1Y~AE[
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#Y><5E-s3Onn+vI@G31kV-{u[B&F^#~{N/!N[:DvP>jUEiV_<$nf418CEO!lA3W\<2Z,*ZOc
    X7+2U{){Ck;G$k\s{ErsSKwJUz^;};<VnzxCXX{Dwo*ap0&HU;z#GwY'a_V$@BZI=k$C[C<v]CQG
    #Dmxi;kJRWma7C=wn*B_kl@EpH{!CGll95wszTr~Ri[l?7rDX2{'<RG{@UNjam{hr+sZr=lAlj\o
    l_TkxaJ[zn\_pkDKs[;ZQ}?pXjBXp[5X1*iC&>$+exGKBe?E$kwY=5IO~#$,\W{s<''R1w{IhC<@
    $Usp\HoX}UOxlJ*A1tAx7U}mAO~+1}KXC3P{w1ep-@2,x-J?a}xQ1G2i}Z=3$xpZ$JI>$nZ]KA'G
    MaaovOoz[}<@G\Y_w[[AmCE\mG;52rIY5*!75Z_?CjOw>TG[sEgaA>[Zv2B"7zGXz_Y;b[[1erj?
    !_EB{=pZC-{z*X<{Z'jX{+<7J]w-X-UUUTU[@Aj!^#{'sf~X3Hhbi5z@GpwGsoTm[}=D7xpumn-e
    krsljH3~5BHe5_#-Y$Dzx!Q<;G}C.<>m*rD?*]m]l3{oD!EsB@'B~{}=,8C!7#Z->_FR?'+NJr^D
    sz*j6|~wAWN=koKE<1\Tj]z_z--^}-p,3Bl'm'JUYO?Dr,IvxGG[<r+tw{<ku*t[i}Z+Q?1o^iGY
    xl^CHlY=UArmapG~A$U}"Cx?Q"l][!8{XezGW$vs~I@=a~{xJ}x+wJ;C;Tsk$Ve}uX+>R]+|z5jY
    ZRwYR!72x3z,[jV}XsTTT+=k{{{E?pl!BOT!b@Oo[n][3Y~7a?li}M\&pk<wwT*-1|TxU73{wxYe
    ~j]VCQm[m\^osmQC^]2{Kv\ms]ZHTDDD]#Zw'uV#{n|7>BOwV9t/hxp]jlIXv?jBCl+=+rTKG?*}
    #\rzX7C~vl^}E=WeYP@DBIjI{B3REvy[(onv;>TY+s~owA*~@KT1i={_2z#v[zdCo>zG%)1Jw{l1
    {knG1uQDv1,CH7#zJY2jA>j#@5Z^J]s'B*5Yo5*9]z}vBTs>,s@rzrPvZYoR[zCgr'K1<r#GV]5i
    xnOEIGOiozE=(5,v#\m{np"xERv*2AZ?T;*C'E>5,+cjXHp~<H[^ZKO{*z#GZU#pT1iGm>Ab!lE!
    l3WAO}uR!Bp;peoulKr,u1+?[v]K}GV7Yn1pT['ke?p5kaVr"lj+\1>+=>[==WnD@e[\Jo^JX$KA
    =jz22Z$*Yp.,)l2GW!p_GcD;RTr*-7$nTvHp;Q<$<>Vwn2kXH~'\JeyK=}R2sujW5As@_w+lW~Hv
    ;,Y=]Y]M;CK23QR#\aooA,5RcO=u#-]-*2'r3[<1e{=~+1f7[VU3<-@f8f)o?]pWqyrQ=+n^213w
    \BojZAw_os{sa2vwQ^qrB7sjx[#WY7>l1X_8_^'56x?IvH^D@gno+W@w*1qp*GG4tXnZBom5R6v_
    KB=OEn,5i;s_jj|eRu#Jw*WoTe5+sIK=CX5C@OTBx#JHzsJKeUx6e1;5ADC<p2;uZ=#H?+Kp57RV
    [BQJO>!'YI2uCGDG.bNr,aQinlavu,@T{+=pWX{6lsBXj?'O\',OHG!kZ1\';DO+}k*QV{3,ArZZ
    U=js!(JB_I'eOuxGm36<Hn{<X]A,5DnVpZ{5OIVR7Xla-w<oCXoor~37twV~1ipU'T<r735-vD;O
    ns_OOR{=w+$!WE#$p{I]B2=lrD\kUV[w#!vox5On-&2zez3Di2e^]>x2]DgFYWW@S?DiO-XpW[[i
    vX*<K[~Ek5u5EY[u#JUl,QU[;Iu}wOe^AAVG+yT*a=*><;EDJBR!B52Y+_$jE3A5um_CnjT*Kwwo
    l3m<l+-*p=]*nw=],{zEYzG<wacA^v2*kEkV>lO<D~WQIV,_-$XrY!CyDCY*XnQ'DrI5"7EH,~{$
    Ho\=5%w<+1$3wJG;owpWV>-l?];YY}jO?DrVY[D{JUH[GnWjvm^m*}?B]o~}Bi$,_uz7J];U$#jA
    \iy3RUxB7^IwV{{X>E5:wDJuE;D3_J+J07r;;sAcEvBE+q!E]}C2YuvWZI|}yQ]kKP;7n;$+=i$W
    xkG<]5!<
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#Dn{_,=]WC#<1:,Dm,xI2@s1a[Kor@B+riNY?T[l!rE|a'a?BoC1[5}+vD#a]zCT^H'>yAoI
    eA5OT<'k$_rPlwJ#*+[[o_n=['CW!Ul$HUlIH-BA=O#QET}7B3pZ~'#,o/s?~*@<DTber}=7VB^=
    @m+p5BQkYQZ+XT^w=#_iT2}-rQzQ5!^P}wl2/a{=i<s3?H><>B,?A;=xDKI5Inxw*^H~1$2$-nrO
    Io@>aX=?$wa5a)jOek1Y5w=JE=1mf2>+zCkeGH$J\=<<Wo1!Xvj7v$JJ\uOT_o;n#PEaH~|]J*,B
    <I;lQ$e};;;DDjs(kY<#C;mIHoUGKnm,rw!$J[Qu*%IX,OBXEEw+x2X]DsjIT-(>=-JA{~!>Vzjn
    XJ]\@e@{$s=A$@Z]KA'GMaaovOoz=TXHY2YA<s-em-=EUOBY?OnCV[XIY$J$[sj1~_+$3xurQ"iv
    ##F<'r7;ji,^Gm}'WBeL{slZ,^?pr'a;ws'G?$HUl-1Or<n3|.6gEm*~I_xo=_$-%!Bnx[iuTUUY
    =xU[;^D\eD!nK!*sT3-llR7-e73av$G3]x;$Vz={UQ$-W,Vx=wAsB*DB@Bi<Ez_eQZU,JTlkG>Tn
    !eK3Wv~r<w$}eU-{Q29r*okEIBlCOz^^]3Rp~'r>CYapEv;^oskkO3lU'jrR%xZek[?<GK>]p+Q1
    [T,k3aDo!OeKO3YsJlwx=Q,;mOD=\#eZ_QvnKGHjTm+Gj5!m<r;QZD%[E\DL8?}#W$;l}$D#QE;Q
    ]Q2q1I\;U}Hn]s+!U$pX0]svlCZ\1IUwo5en1P=hDDHwVrDO$;^$z,9$*wB7?A3s&<{[hp@-ZWG}
    ipT[alTXH'YVBs1,X^,V!a5rlW[R@Bs3Y~$T,[IYuQ@a3si[3O-r-'6wY2UC~}DB]?CVC{<xzlzX
    BE+BOm++rQ@v;V<C'#l@}$~5^!+75[W;h)BI$KUn@pDBA5SpVkU#^eDK*=}'<eDvAIrCYs$\X3I)
    CY!WR+DQ=C5^-<@lpTJJW-p,7cLXl{pBmeVQDrCNQ?^w_m'v.1AvBP|QJWk!+JoSNoul!|,z>j~o
    v^{B$uG?!OWEpeUEWwHvv5WX,E_raQ1A=eQ]Koje555nKO"~vD2kw\Q*n,*Zz$1?TV5slk2XXTsQ
    ZX]_3a]Bns5]>1a+O*#mCmC,;_]q<{B_2rn>y7oYvX1+uz_TdX\Bs=Vs-I:C#U3#_@KpjaQV5Ol>
    UBJsr$zEE<CIGJZFFQ<r#=-j?2E_!ZYik5>l'IAU]5n!;/;]]?5Y\Y<Cv{E?5@}^raP1-D@o@_,&
    _37TQRY+1C$?wE1-p,HwZYp[',uB*Q*!{a+B;DvvjxZUk]5^ilA=+eiT)\RGT1#Hk!B=H)V$_Z_Q
    K*JrG}1,oeyv[U~,Uw@=vpCn6sRZU'vp*8^-^VIs_XHA=Rzp+#oK\Ga}5w]HW~$oWp^\m^Z-@CcR
    =DC<\H}QWHViD!>[;A,z71Q5^o}3opm3HV}eD]liwa^4,1EvC=u~jDmZ1bVRK~:K,K*Ym~!j,5T.
    I;B1gQx52lzz1xx'XZwXV}U,^~[[CV#TrKQIIMG2G#^AG>N2>lGO$oa[ZjiweI7R^_]]1DR7<w~$
    }!7[u1nu7KOUEu_A$WwKEACn\TDLmC$-s,]_{j~pKj-{}T@Tmw}l7.@eCCipi@^TRBH'#G_!!n=z
    jWOYHmQHAlue=])G>CzeQ#EEklXXBnVRYljVIX,@Dku=x\QwOGZ:<+\vBW=HYxVrjzi~{}#]T>1@
    |Hn-1DjVJV]ne_GX-q!5=7n{BU/nnEGXEV5i<KJjjXlp/=Vo?CB-so{>\nEursskQy'r>eW>O>I2
    B?{{J]^K!o~Iv=R#_1j1#uO5*v}nRm
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#@VCR;7BubG{nQA_p=^>s\pUGvGm{j$QIi13v_|.3.}mGC*5;eior{EWJX]!}T_o+OpUH*w'
    2$A7#H#Ull!r#~$!RVN^,]Eemp[KwJUz^;};<VnzxCXX{Dwo*ap0&HU;z#xkY'a_V$@BZI=k$C[C
    <vrC?G3]AIjWWusKeH7C=wn*B_kl@EpH{!CGll95wszTr~Ri[l?7rDX2{'<RG{@CQoje1He-]oT'
    I1Z$D{Oc}<'Ux^}]I[J[U[\Kl?TwZTZ,+5K\j{*zR?zk;}iJ>n7?a\rT#<'7Ue~lLlj+o?=}p$KJ
    }!XDQ(}j>^l+A~zC@pGr;aUDWxRa>VD3wJ]7#>u]p]liA~sCjku}!=Qzuwol>GztKToDU-,I{*+Y
    [p'#N}p7vopA}]J2BfjTZX3TCuY2=aUlOCmYmv0l)+&l7i<RV[$-$=n}~-DxDC}olJ]!o}Y&~awV
    $+Ww\i52_-]][,TjcNB@R}U<jW&2Xnmv!uJ[=RrC5=\^AsuxQ=[$[X_]IiJB==z?RJO'QRW[K'pI
    u^Zva}oIy+G>'(lUmGUp*r~,\Q-T~DDBo+vl?oo5=V\_'2O_QHIEA=JUW{woTr*-Oz~\O2wz3<>}
    !T1njWeE*7Q]W*U7Qu*{mAeVEi1'p}DTZ!_*nVs?,n#H~7jQ<z-z_Bk-33pZE=~Rpj\?5wDJ[}{8
    DQAo!p^7=Gq-SVK7<~Ckaz~7*eTm@[H7TzRp+EK{O1>WAf@zT^#=?2uRA^;v}WsJA\A-elwhvIO+
    r;vm#'k?3'XYeuZX}D#<#5<wOwovR___<vv!TasY={I;,3\IlWA#C{;r:^IrZVT]W2zRDrj^,>-H
    I}5jZlQ}\X+axC{<A!^5lEDkzq;=V_bC>Yl?RA@*e7@5a7J\+Q?nlHp1AXDa_VQQ$nU$E]QRz@!C
    *![d[KT#xkOHT,An7,v7er,>?XlQpJ[OwUWZn+OuTVEnk>vir2sYOCGr/kU5v*J5anD2\y'i$D4k
    I!+rlE,Vpu]v}XZ@]H*x+Eu$^>DSHo'p:^+<x|"{a+$$!u}tj+@xo$]UT,+{Jv;eGZNR~^\lGKK2
    GW=^zaQQ5Zk*!O5,^3Uwo]!v@Gn^_o>C{n}QQFK1^*"7jz?yi{+HEA}uzW++\,k?W}\n[3lz>\jW
    p+ZC$H77UH^o7R!^{}D}B7pa_i,<i&7Q+~B~*Hl51@v$#-V@;sZX+Wk<H7naC<?X<m!Q#BAD{Y~=
    5}I!m,lROE~v7*p_au~z}vQWXvIJ_asJ7=vAr7C-@FEo!,}V$JDC]-oHY*KRmp$Z7U,#{\IIH-{q
    F1kQnY{\wH}2r91!_^EwpepQ!2\^j'W+W'%D_u}vWYr.EHB}:'Ep_D*wV<$O-kw-3]]ue4c*E'J\
    ]!HuH!uuzTKxqERUX;HvAUE{*#_7,>,!D-Gg'uA;$an;]JK-_O,}GX<XH}H*HxQZJ7m^pElOx52X
    [*ET#eI3'7#ev\]k,waAWVG;Ip=V7;D;KSOl^WlHEJ}KJ>w}>#IIClTe7X5{<nzz_A1E<WrOJ_?A
    C5D;=]Kl}~pJ]A(*qAj>R~[2vz3<_}2DlOWQ-5p;IW^m'=ZRKRV;][R><}O2eYX+Q}WrBF(m'DYI
    jCja-uEjEkrGUm}Ao,s'$\Jji]^I}{_S:Ko+nGwD$R3U7<Q{@k>Zuo^#k*\C1_Z=wQrJa1yv$>jv
    V33t$W>>!>-vq=~aYGRC55K3jC2VD5@$I6Rvz3iGU2]Wwr$E@>YJrBrE=?x=Ejt,2l]YZ,xx8sO4
    J[[AmIwI[Ds7j=fQ!*23+n]ARrz1^Dkc!wvX$le$Ea-u#aEDBk5GHOk@o5ouDzQ~EUYTG#DEmOW'
    Y!Q]4s}>BKHEWCWwW}=QG$YaYllJkn]]v{rATGpi#7k[Aus3@=IB,3$gF'5ZnBnOe
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#}^Oe=$w\xW!7@qx!mERpE<<Y{!Y~J-{]#!Y-T[qiw7[EQRBavrnon![]~B<rBWz~5xvssW>
    zAWO4X[+2U{){Ck;G$k\s{ErsSKwJUz^;};<VnzxCXX{Dwo*ap0&HU;z:$EmlBz_<S-R5iGZaZtv
    ]CAG~D>v]3KksZmw7H=wn*B_kl@EpH{!CGll95wszTr~Ri[l?7rDX2{'<RG{@U5?_[G~oQOV\G}G
    YvnsK+I-[7!JDxC}k3A^o$HK]enA=zp\*?R[nrwQ-D>On_WXX=i~nCe#G#YHl]u$D!+Qi{R]-YA-
    ;2+l}M*e+Z^*Jm~$x>TrZBx@>!kE'xVw'xA'ru,si=}n-WFQI7UB]$2Yo']oK2^{>U-Ykl\!Dprt
    H&Us@CB^s^$}ys$p'KU*C3$Zkz3eieG-'y&;jT@[iuJ1T*k]$<m&*}T@7,$#~B\@.5v-EX_A-rpV
    Rj5x>H[QR$vjBVJ,i5pz[EO}Ro5[x[7l,}i@Q7;7z=kl]]]+[p,O[5_pK[~O2C=,=Q\KYN\,[[>T
    ~e-T;GuDIAU<he21,lU+>4z-<JEk1a$AQ[pK[{UUBJUvOJP=}I=i][u(n7Ju^kRA5U,~-{J]pW>D
    Vr$+F'A7-DIK2<5Z^8ABV~Xpr~q#<X?popJv<uI%$[oZtp8kDXEZwz@lTA_7EE-6EoEUU]I7=e]Z
    ]@DA'-Xx*nlTgdVHEBlB\T5>VmczKX3QZs3D,$DV@I'7~Va6WzG22RH1}C{swH]^E~2_lU[R@lEV
    !sT>V\5U|Y5j}CjIsD#~{v[R[r=-j{_1~VxeGm5<'sZ-A'5Yo1*@lH}77#+H&I,Z<IDoQO5pCj!A
    ?~e7EisB3CXo2}wK]%|7Q@X'_u#7*{_,Q?_WI-C7A*o.#l{#7a3HB2VI8U[Yr@a[>IoXC}Q{]Aou
    eH]Jef7OK<T\am>A*,,Q$@#w^1*-u+$zB_X^v}ga<}[EvV_^-wA@r;JJ57xDE!$p'J[tNex<uI'T
    [{QDGMx->>hMkp5[#*tWn{v~[HIEX!Hq]UJAHr7Ei6J=XHNCe[J*CnKiT$3usal3$_iCap?,Oj-u
    xC'oji<q!B1K3BW3@{*?!>v'cBXo<6$,!k%SU7!kvC,uUG<]fl,3AaOHX**\#GXo}Xrz<;nC12]_
    lGX2$a}a[Gml!1Eml;[
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#}KOa5BmAfxx$>*Cs'$JH$~o'YpIC{E!T[qoZ$[IJ]H=Z;]J[WVo;!oQi$eP_rE]-a3=R'W_
    VAUO%S#Ull!r#~$!RVN^,]Eemp[KwJUz^;};<VnzxCXX{Dwo*ap0&HU;znIK^=^wr[@@;Q}YRnD,
    isuUZrO\5r,Aa*]RirC#o!roEuQa;$CuCIW*;Q;>jj;}1_HR[_WU!l+Js,=KAOvJp8V+B*I*AY+=
    pVk}IGwrA_6!Q*#,zE+<BHE7HJRVlj\5Ww_tr<lO}#lm{R_IUX3V=*Ap7;s_GH'wpD\@I3JHUj*E
    ~EA2$35{s<YKpmp3W^zX']m?ErUup?3e3_3[<Q?pcJ[Z>@+_neXZ<A_V<I5?[SwRE[$OzTmI5ez7
    A2eWv#Wo;3J\eB}a~op4Q{-R7v]ZkvOv^~Wllu_};nKjDT(OpoDB#*no}Ze!OsR=e@Z-TUH7{{uR
    ;I*jjps]epn;s--na*i@<Rl2XTwHC_,N=^x,uoCvAG?7,<;~D}vxep^T]_VQ%]'\RD?D\MZ1}K1j
    n^!Eri_x+51a{#VB~um'<{EmoR-IW#(lrWsU_]o6in3x,B3_GpGV3-^5e}+-},T#xY2^HRRpUYH@
    ^**^;]'<eI~}i}iXBE$u[u13LE'+HvX1Oy71HHkH7^xG#s^~$G]v-Ez_']aH{_,Hs@UoD]AnIi,@
    KxyXa\Donj~znA2kr!34v#vBiQHB.{5#^u^oGW1U,AYAVM}vQ3ge?mGipQ1xI?lB3*!/IrRKwQnK
    JDj-fLRkak|#-EuPSErVGBxAkj2[Q+[s_>Aa3U*xZ9U*A$@<^\{$;v3_enwHK$OEmXXOI2dZ[{Y3
    I7K+lHV2+m$2\'YsZ]ZkpUm2Q[#FC]lpIzJlR*@$8#>W~YjwAVsWww+x=-=Z{E!oQVjJZZ[av4jx
    Tv'?\;Y^[nx#;[DvklY+[JOgXpWQ[TVT'_!!IjvJZaajoM9oT]V1oRa'>IuOoxRr6(*=,$jXJExO
    7*dKUz{GOna;e2T+}-?j(+^$i7'G>;I,a$W_mJ\}5&(K}n{E\Roj+=2No{JIr'~,Q]?>[[oo\C@?
    =xKOC]wOZUDTD]2#\;]2)Vl-T(2z!z_Q'w7oT2rT*Y}3'_e,2=^R,Y;R\#}x=<WnJan+hDUW{=;*
    ,{XTT=75rhk};p0<Y/Gj<w7@'\|o?*k'e{a$eR@U'H[~{U$]zBZIo\s2OBpGpX*$|*VIU'[xOua2
    3GOp!axooHGvHAD>CY=;[D+'Ws?m56)|3XW-fm[<[$ema<]xi1A7\='Evs+QiR;lEWHK#wU~*{{T
    ,G,!Q+rKAr+ARD5lJ$]$=oG<_x,{nGW1XTsvZUoZ>iR+TEY]XlAj!4$r$vxzZ>'Uz-(wOeA@E=2{
    AxXXDY]#sm,A'7e/(.Roe,Z<w]67pwmNVxZu~}on~rjno*^^^]V?8[Vzemv9:*K''oOu+#jiJ*U=
    {evl*k7XpMB@mXZ*!'ruVsQoYlA<wpF;_>#eW+URpjJpnEZ*ZB;QW>n'2RAc13=$D;YUIK*@WD~>
    2_-TlX\x=s[oCvwHIImvkrR3wl7;;wBs!Dj@i{GsK>X\VUu2AVY~}~$O'lREI<T-apKGGU_>1Tv^
    8^r^;@*;][jz<X\C[TeZaqy^x'ln_#W^\33>*57@=1jusY?ejIRl>nuCCDD~rswj}?B,V+\eGUZI
    kV~s1A-n,A$aEe*Dj<!}dxDmx1<*?E^mH@}pJ?<<'+e+C7CIaQ*+zJnQ<^{v{(sQeZIz2Ie-CElm
    B19kY]<e+<\}&06eoKT5UxYgFeWl_^_pr1]{I"G=*uK{Y#_k@O}kIi_1In{CIUvVx}WTTG>}AO$O
    @ItIi2v^-D$Et<OU2VeAkC-ZK{w;j;=GI~1+z_mD?oek+tXXzo^1GZ_]ovQz?YYZr<vAmk8azGZB
    ,BX!,-$fzw}xITs?[hvBxZ\G\$m$^,x1an+O]J<]71_*#''co)>OYVDv-{(aQ]7^+'?&Jp3{_XYa
    OF3ERl-=j{T*!H2x1BB'IG#R$7oT]G3ri}DWm27->\mIU$~'@URypG+GvVGU.U,WZBKw^KT\mBB^
    Qd@eilvlu~vBr>Ka=;#&#5!1?{~Bol}AB5?Da'I_vj#H7'x;uBC*G3A7-1v~HI]@GzZRTU=vgW$$
    N\@$WoEU1mp1i@$!pHrT5IAQIyJD{]j#^D^G[kH1a=#R>XG^xIP=X*znau,i5WJs7oT2Am7;>GZ\
    E\="zmmj~Q,e}5On<,IHERBxXwum!>>-^m<Q!'I{xOo'H<pE"r!\T=W27z^-<vdRZHo^@25GxrvG
    Dp_oGz+J\;,k}2B7j!e#av{pnr\]O[RY-XaHB^mKH>H~,8NDzI*A5Gu#QJn@jH~?^-OYzwR_?C\]
    3rHeswe]pA$A[Jo?a,Gm_A#1Z[EVE;p^jO-x\}B_ovxi^J+gYOR7oI1+^w;zp\R<=Y!BeipU^8Y#
    A7nejpQ3<GEBp_l_o}[31]u$]#kRX<wrIkRm<^gqHwKYie7w}-DrI7H7'vwJvm1v5RpKw*nsoc]R
    *Z[U+Qu$HQpR?5ap]uluBo.QZ^U2E3+ROr==EHxQl}K^;+Y./EanD(Y[s\fCiUk'EKRTOG'$COxK
    z?uFIK!C}k+T_k_ue5^]H{eRxE\p(d8U[J@l1-z<wx,]~}#FYo]se-1Dn<Am8{vXaD3YGQi>k^~O
    =XOaKe*,ib|^w;GVYnu;v5Ae~W,x2*r_pw<RD}3)@CT7u{esYCoV@>T,FA<rAfC>Z[unC<LIkuKu
    eU;DaIDO#*;e2^2iQI~}T*v?Q[;#A+lTr$VTzm3jm*KVCWR*{;*Q={k3x_oXjU31{++\x_Br*ivk
    {X\\!mams\!2a@~~5A~^21+ri1E],I11,~[?T1j,W^-sua3'wI>pjVp4X$>$EO3Q4xxU^3*W#)vz
    w1-->,7C+*oVuu[hY{Zr7s$j/5C-^5@7\P,T$]I~]D]CV7XemrVoDR!']e{juXinC~]ip^xmlW={
    -K?<!Z=\jZT1p\G#HU[2nRx7XB}<K[^15OUr+mRz;2+z7#Q_\r,+s1sO!oD?7!_rwrJe_W2DmUgI
    '#J[z*m^kQKTj@lwvse#aGWG4jRxE\mDelQEm!B^G1[_skRK^\17RQp=OaD,=7Au#H=A$i$Q+uYC
    p5,[ZJj!3*J]H~RzWDaQ}Y?r*2s<>xXT<zxlj_n^eR,Ba2TZCM[_S]l\52D$-e{!3jW\se_#sX=a
    5ezQn*\[pK1_'tz;a*Tw[H[^Bu>-Ip:~xVCG@,H'sn*qv!WlVe{s_'oesBRBa,+nwz+O;^n!D2,1
    5EeTz!3J',*=KGW5q'Xep'@]<Yl^J5+l^A+3Acja*^a]s-O]EEOZs~+X$uUV^GDuCOeJ'Czs-s%a
    \p3IvjB_C~wIHJ~5IG=v9{-<H9CxDEnjj2fQwa^<_W!1sC#GZJ#i>C73\Uxy[Tmp9sw2EUV?T]W$
    Jx3Qj^p^'W{nTKCo}OK{2V\G1*REAa[X-keOl+TQ2ZD-DHYZZZB^"R=z]eJ[*YwT!lR2*_K;IieG
    [qE{6E\o>}pw+kHa>;+Ds2-u5#oWZ}o\JN}Al]{G=RI!1CCx\2zW$<CZw_@In>\ek=MEa!m95#W3
    o$RUA[_j~av]u-l+Ba@ovCXOBU{+1l'x|DC_~$lQ^G7p1bEH}}'^U3x-EX>H[o~5i1W[zIO1@RI#
    ,C*'DIQnVE1J;=k*>~?=#p,2TwR2zO+8.KHQaz!'m!CJ5@]@+cxv,?l*7Y'-wCv7C+zIeU,VU}AB
    {E[/:e[[*+aBuoWj3Uo;Ze}^QBz*zGm'5#ap;<Cpa1]7k!w><VRI11CG'Z]V#hD'IJ}]<E37=2l>
    +]LOO+5Zr+u-1HEjJ@v!^eE/E;K_+T]k,o#@VHRH.+=EOG~2jUxJIoVo@QLBj3!+*\B.}}UCk]'Z
    BKU<<7!Y*{$2[x\s#n[z1IV+kHB#Q$31_ilYpmB$OU$!XeQ}$;O7~T<5=[5vUwU501mUKiHKzUpm
    [0We+GW,mWk^xTWV_^G@_@BO][$;~;&=^=@^zY5*!as>XX=_3pV^7?^~'YjZwevz7+Tp>!<kwI=9
    v[nxQ\}m{\+@lv,Z1iWR\T$W$I1$ViGl@H\;!A'^~CxWH'@B8__,X4I!J~]Rn3xDnYi9^+eG\oXK
    oBv@x5z=5uj@o#D#Y1ZlE;UlKA<Tx5+#.,xwT_iRuL}w>]'*BC:K^w*Q]^__WErX5I2OY[R,GKB<
    B{A'a-{)5_J@RG#5<n-,^sIT2<7Q2}^_yxI_-Owpz+OKospmQ31AwxUA~Q5C{jR}ZaQJ=GiU${77
    ]pHWZw'U'TQ?[lJZ=,UQwO]3~1+@D$rw31Bk{A,~x{5V3?Djx<O~eKQ+-[{l,un<R#5@^[__C3_v
    ![K7^e@oVQj[lVEz!1u$n:n^AU~$Q]_H73ZCK@$wOT=$Z;jXHpJjJ_BRV#!5vJBO3ZC;-_AOX\?O
    WBvJHppkB'7{xz$5Wv{O]HeKp_'EJmxDKwRn1{xE5\_o5H+txQ]@9VUJ@[ZTu8H\$]lA1n1QzDAl
    ?5!pvuRj3OGHXsAaHRB\-+@,\#|77~p?_2BD7u[@lCHV>xvh}Q#*#z#JU\#Gm[nRcQDWK1~vAIWZ
    5T53Z.Z_~jz,>'VxJCRmlB>U$_Gn}}}?$Xa==EClDZT-X2H}lovErsi$TLm=u<,Un,nD7B~1AvD7
    zo_Dv35,RXR;znZ5[RU++Ob}5'U}^>xv;DpO[?sH5~z;Ea+]#@7>{nk!5;ZZ[;Ce#w'G-a^JH@^I
    ,R?zK[i&jV]{I-R;JAEB}ZYDTlG_WXpRj[>^l*[]&l!aDVrCC$r\{^X;%C]CO1W]knCO7K<aHz[W
    jxaV\RV7VJl'[HQiT;>;Z;s!~u_<Yi,mu7:^l~QvBE?sv2}7>Ea3>OEiv]#*7TZ9GX>={wHse[nR
    },-}rQ{GeG+HIDKe,3zwAV*@*Gk';aEz,K<#uw7T+A]$HA5?H=iVl,l+s<<Xkwp!k,t$]K>1n!73
    InOe?-'J];<HExWJj@G,pH@27r5IYt%\[~n=z*ox$lZ3}',Ru7-5w~19B'TAT,nUz@XzjeT~sOTx
    u-Zv2+XX,i3\n*$R$m1[j2j$8ixZI%#x<u}a*nwCAAQVT2n{Cr_K~JpjZX-D2H,Z!Ic;RU+W7B$G
    ,*m_wn[JB^I&$r]32'@Oy*[a1,'[Efk][5HB-@+13klvYCy5OB-IV'rWl2A[[15-UD2@QO!wGX_E
    _VGolJTIw2BGn!]esk<MkEkE1{=\%Y+=r!>JwOxGoY]s>xz1J?r7?DzzrI3Yr=<j?=VKZ_(K-a+E
    ;jx<>@>51o]TsH2}ivO={V,iVE3GD;KI-u[5zaO3pxIGvz3qTe^m1r\;BmsUDAWBG<n[Ir~@$GXD
    Ia{Ga>{>=Vp>%;w2DBBQ{YJ>$lO>G,]GW1r2*rvpnHXs1sOARcvK$QixAj|s'A,V_Env?3{]D5ia
    OnQ;X}$Y2>v{vvTYOn=jlWO;_l<sHXDuUl'J^B5GnZ[x2C;!C$EoRHn,pTk^Cp$!h'vC*GL,VEEk
    xH$<j}U*Z{QOpTn2^{^5QC^^speR5ev}_KKUGEm\XyHV;Cwl^z,<R$]H;Kj[VxA{a}[i3+Jr_I9O
    (T^]Ew$i$pvUTGlpuY7jVaXXk=Y1KR7$~ApD*v<~-V]5ZQYknpgju-mCFvwe@>$$^Z_,OW_H{}Xn
    m}^=Oc'#]pv_7i0~^uzunpl_IBVl(B?X;r+u+>RJ*?w2~a>}rwD^x7AF;]V3/\G;ouU,Jjv~e{EB
    kuaD^Pd?=z2k$Xu4GNZ]3pxB$idr'Tzy,\YUQ{\G\=jo^<l2mYoaf][-,oR,Jy\[?QvKW]GkO>\w
    QEeOBo7+OJH*5ZKO]lzR}>y}%LisKJ1{u!Ax^INkQ7_'mOEFR!}jEEIB_nXU?vG^an$+m5CWl'VE
    A+~eAX+{rK'BHU3_,H>rhVD{voKB3O<=5Az]]3*ovI1[^Fe;2p,njR3V8ZG~+U_$2IX~m=e'VDWA
    !nG#vY'x@{_#!eJv!dC-}lv~};%!^7TpK$*ws,?JxUC:GDI5KT3T}\$?vlp2[w}D0xO;j{C!O#s-
    o3V>ZzBUA-*@<O\lZ{{]lw}nz3x-s5Cw~^x?rOzT>YsW}_R[$?G~!fVUGC1=,X5u';_oZ?xW'\v~
    AvHjRTErm-IiekKwC<~<CErGzn.9Z-\mXIBv%CjX^v?+YaYo]FWOnkc9OR1J]wI}uCa$k$OO5_U>
    R\l~[,]}1ATJY^5k}[B_T^7$UQGE~C?3&kszU1=zl_Gj^KX^[>l7Ds]#o',AJyvH=ZH>RH~X!$^Z
    [VQnA-KR#W?*-?h?w-oQ3zml3,\^s^a2TGB}-{OavTJBs'=#I@Tvp=[GB#W>YCY5r-H\^CsUjxn=
    -}l$r]$%e+H}7xs+^[;oM'7;HY?5+dQIR}.4p)_R@3q'r5eY$A>1*O$=,G~0Ble-I,HE}En*;T+2
    G@W^Js_oFlzD'RO+;m['zEks{1*r~{^'VCmoppz*<j_V;+1{Rbn7k~k-7XD"&IvK2pm=Qwvep}rE
    1n\-UL~]'o$w1waem$G+j}>Avzn=zY6#aRpvxK}<erJCEDAe$xZoO{n$f#{2YX9B<3Y%6^nww5_D
    rT17mZ{_pu[e+zV~!X^_#v\e]OBvn\1\aS*5pk557>YBeA}4UlWKwv+ms#!^DB[J);Xx]_O7#IaV
    *rTJ3fWw=HIA]=_k{-CQm?B@T#'G^22'on\fLb#*m~z;]YK[]{.]E>5*<X_!6k5UnwC+-2,,=~r9
    5l#X>jH'fYW_7oG1BKVUOurR{=r'^('22sK[_!5{]Q]Xnap$T<D$QKx''}352^uUj~.6.Z>o2m]Q
    5JsvE[GEI]a!O}H{5^Z52C!l-'o,-<CUlPWlA$,4]A\X&1T\^0aj?GD*Gn$1klYvn-C'DIQx\5,C
    2Y{lz5G?1JZ}w2no5KQBk540-l=--\1@m<K1~lek-A+<jiG2lH*KarDxZs~V,-5lbo>2p[@^[f1>
    U\BG=QKXv+rOXD1iz]{Cn-uwxn,orO7>^K{x[u}R'?\GRA&smjV+sOwEZQU{wmlkz>YD<nDie'C$
    @a331s{@Q]J<51n5dZ};moUYvUvp[kU{A+Yw!e#n17[A1zGzu+O5JwA_AVY?75CEp5D;V$WvIjwn
    ICl\VPjIvjx4=_sa>UYk5\_\j^<w;n^>E=m;>XaC#+*a5T~aet?_#XX'~5pz{k_nQQIZxOOa27Hs
    <E^?<e{Ux!I'+AB@}?!_H'EpaKQ*Ip;]jB_IaV=ooi][\A5+R]fne<BTpJKJ<$l_pl2wB5^YXmR^
    2v<Y'u5ho1pwnY\pR<C1<TG3}~E\llV7Da=ZUzp>A\!5~$R{,^Zp]YI~;-1;p_-kKxaD}@om\Q7?
    =>*p@[Ra:j!mWOn-'*el@_ZX7+_2ZV-@?2UE~CvDWm7@m.1i,!=jXwclD''GU_$~HEYX7!XA_>Z\
    <u7u^Wx5I3z)w5;}kesljG>zkRXE%T$Bo_1['WQ]e\Ij7k,aDxs+XY7VG4=C2$Y+E;wU{G5i{o+'
    D*#{~W'En3aoTZOnx1&p@Gw#l?{g@*W^C,x#ACzGBJxD]'V=OxCr[xZVjW-zoe?$/_X,3x,_2WT'
    #'zrJJ7TCeZe+1}GB+>sD|a<IIBn5YI;[GnICjYH'EBqp71zJEi!]$\>R]!oQ{^^,\m'}O_Vk^^<
    %-_-UoBnDnV!Dz>_na$@a\3,@[>vaq#>*!IC>QW{3}QxEQzpIm<H~u]jIZH+K3_\;DRIm^=r{e#e
    ^G$C\>rA>7\pQ<2aHKr={k-}{JGsO~>*aU\Ooe{$vKvR?e_}_]E<I<*GvvwH7!tQ_Y^\nr-\B$=I
    !jG[\#{_ka1VOksx-<',!m7]sm2+CRHdGaRU,RH@XA}OHBKR'?~,]O!nVz**jT~YJ-vET]$'p\X\
    :TIm{7}eEv,@m,m{xNj@5v'_!DYtETv@&5<+rKA;DaTBaUaX'+xav*[I]KnW?I=BA5=]YLk$VDpZ
    Z{oR_1%cvEwEQHxW{C~{KlUGAp1#7I$7VmJ,Z+<36kwE2$UITioY<1re<Va-s<a1Ge_wpk+a}s+3
    J>xkV#n+JlGEpm}^$Z]3Z^=57]To${O\^OHYOW,A]y-E<?wLK}U?&'n=TswKz$na7'}]BVvZYO#$
    zCj+k=DQj1ZeT]aDe5VJ\uo{-W}on[G@,[Cw@=_+W2TDn$_eaArmr>]#*@avo2o!Z5pwX'CpuV=[
    ^z#GQaBoO?O;3=2awfp~wu>z,[rx{\in*A;wBe^}Js@OC#=$-vTjYD7K,,_m7*dC+1D2n71z2{7U
    -7@e>xneZ*X1~B{lYYoKs?Jc*a*#/(UX!<+{QpTv1$rEjj;'=C)DrR?o>\p'5p^r^V@aCCX8#IR\
    #+UTK[xrElQ]D~3^EmKY+DH$nlUX2>e<<[~[vyZ_~W-I]^8V:XErp=,\pZAl'[U7vV+o!nAjV3^E
    o:Q!mE'\5j_WJnRJ,{CG9Ox3vjB1vgx^C3NjsOAs[+*KAu,OUw]z^C1HnY#l?u7_}Up1t;a**9^>
    j+9n[jjZs;}}n5m,IV+_{Ge=7~{>B;]'aYrveJGt6r1,*_\>oNz;v-d<AEHlO!DYerii^I*+1W^%
    ksinYkIzXDXwoRaT>z]H}HI1*R~UT}Br$[=mFa=$$,#T|(QxKkj+<>UvlK)xlue7[^JRa{Ym^xA\
    zx[m{Y~zIjCr,Do#GE'^[s}P\{Zanv*\]/1u-HuIH1x\~Cp5uCIG*mWH'3nY5]eulOoCx@G#Vp$$
    QIwQ@uADn!oBX?]!xVeeT,EH${-<[57GE+2<U1PEVDs,@nOIl\I+l#;]^BCMzA=1;YB-Y+!J$CC[
    m8$^U#x\@2s]!ZTl3{BAYOrrvJ:'uRQyn}TEI1'pxXw2.!r**zOJz=aBTfv*_?p$,xoUm<'QzQSp
    V3BR\KeDi2[EBH-{,Ol2A=\WT]AeTHn'O[X-BGHOl+B=_>_~5l5^u$C[e7K<_IQ#TX?r'pHu\sVv
    ptxeIAjD,x&[@m-%B^e[^bQ@DnEv}!k<12Qei]GAsOD@{'mnIH>B3JKan2pZ$DpW2]^rYX,,Dj|+
    zu1{XoH-HJuR[-{+O5TRW@=d*Cpuj,=ee3j=oap$[K*>AV$~]-,_CW-aMjkZ;?R$#pmX'''TeW*[
    ~YaDOi'vKdG_1n'^mr@_,vpn<jR\!#5I7H,_,Gs'G=|3]QU^7?XKp5<3*Dvd-^+<VI=HXAXoi{lH
    R?u1-+A{iCzT,m$2(-*<*>pe![-TDXT=~l5^CJw7>V"~GO!\HZ{Tv<[DjWD,Vrle'uH7UEGeDjJ5
    O~+Epr#'#7^7*p}GnE1\,.2]@CKaWTTw7~_}?z4<jp==}YDZoE]>-~KJvXOYx,JnsiD~>W[cl+^u
    Z+aO-nGI!B}H_p3vH\+{pY5e~{UEvzA{l,}@\*Tk{UY7n7$A#jo{}7nQz1!Z@ormz]XvxT3-z^vu
    ?[UOCaU?Dz<5^[wCl7$]FBonAn_-rYuUkr<X{+AAUI2_VD%~Uj7cj_>o<p\J\+I!G^>ODiHG*_n*
    J'-\?lA;l}wWvVRUT^E[ce?nn>-}pBka1E@J*[!n5j3wR<6o5zE>,onD!+]DC>[3CX7Q?QG-{}V1
    QzxvOY{]Zzu~pnE]w=>[@e#{OAD7ov+?*==O~{IvZ5wI$,nVQ~l=nA^*,@soOW#n5#2{*voU5W'|
    GR[e,Evam5H<E^X^>UuTw<[vroKo~Ulpl1eG?<+*ATD>Ae}+CEs2WvmD"uH;j<^'@Y,,1I*D2wB@
    #O='R#7sK\>I@/]JGGx\Ks*<B,']T]Q\7Z[{GX~,Bm#QQ~om-=l!3>axD?$x,v~^r_*'2G@X_vQG
    r]E,R{y$j}p,z3nIE@Y$wTl?D1sw53oIs>w+Aj}wp+_c]3<XnDRm-\;j]7~ZBTeC]]?Ev'IxGG^G
    oIrs*rJ{XO+pS'o^-^ljs$I[kEp'kY~ue~*n3|E=n!C5u?>j1,pw<}a>ITVeX$0Ou2@3pVR_';rv
    C$z=i7}U^#~BVQ}=>}!V+[n6<{EG+OE<AOOD+zH[-^E<xiaw?A,+M3>1Y'1Rs!s]3iG1v:?ln=f$
    \i2O~2W=TxB}?!QTO;$h$@zzlv,VQw>}jU=Hj~mVIpw$6Q[BGnxOV=iQ]*oHRf=#J*'$~1r-T<EQ
    GrKz<vEZGKe<1=v2\{>UCr~<Yn3RY{-Iw,UC*;Y<,5pKC[D[ZmcmX-[BH_;7_Zz,C^<YV$H_DZn}
    IZ_x#sJ$^D]K7a2B}37IxmzQGDO#[zQ_']\_?[Kn\mnD;![}vRj?wA~;vz~rmuoaOJ\'?l\T<,]1
    XI22om@;on^juXsyQU!{4>+vUO'XOE>+@m$l@Ol15\Ye[oHO[Czz~zx2BLpsQ@7XOxunvu$~KGH*
    <w3B;*X=mj}m$@=KDV$x^3{lU!M~\JOy=va{pTl'}!5u>{pl-+7r~^*V{swws?m!;Vx^m^?D[]~]
    "{AY>-Ylj7'pYeCW3}!J@k7CskA_eH}V72rm]n=p^za\jU_H+O\@K[;s\o;,{G'ieKCn^VC#s#5m
    \_W]*jK-_#_ECB-nWr!1=#(]>>Z[>Gxr}#Jk}\=\Z+z3Az3zVjrVDt!THQAXnZ3R[VD<Zo;$}iV^
    5ZG!{uf@UV>OX8B^u]Ae?R.!<[UK]ZV^#Qs^*D1DDDnr3=BK<O^BGJ=3emaj=-n\;C3D#!+r\E3{
    1CJKaC'*\a2*n{AlKe$H+$Ze?oVYWW<<e'wW8?<w#T>;5p^2{_,jHYnv@fHreKd@5I{wAW;z1=^8
    +$l3>U1#']wApT$Ko~naC!m;+^sJVUmxr_AWuOz[rJeGJ$7Doe^}vKZ}kTGeUUenBj]#YG#{xSIe
    m=pDw^7\n}U5J=3Cze*2{jXQnkdT1jxr\zo[XV>]\'KQ9[XDrozmA7+TpzjoH3EV7G$~\-rZ^'vk
    v)C]kC/uI5^D\YEjzZ*|<O;Uno^}I^*G~O5Q<DW~pem-#-Kp1irK3n]T;[$i#{soBrEXR1O#iHpi
    ${5U~U^raDr_j$;lw^ZXR-~$?\s<OevKA=$x;\Z}3Xa==B<^IC!jWsmGm(+G@C?$!Xm1u$wX=iuU
    sRZU7\o!s>W7Bp1r2>0w{p=25Yr2<,Qo'Q5x*r-~O!x'R'EmI7!2-2CjrsBiUAeZ5p2p<>[;XH7G
    Y5ER>Ds\pkaX{~7yWTOVG]Rl1+_7=]G]GQs?#_A@'p]$RXXDxQIVN}#Du{_kE\>vJl}\7lC}Xeaa
    J\VokmlEBvZ7wk]]<C7-=9x}e$'Cr1r!XBAYm3{[I$3C!oxV3uN7{CD[#AkzQY,8aQ=OBTQXBi3}
    3=_+K^_E{$D,ux{ZV+eu;=X~$k,{k7*'_>$u<5Dm]-IaujTIGEHIF?'~QCkmp:$WVxx*'Hu_Ju$b
    r}rzV5jX'z}EIu<?KQ}mV*'+#\Dk,!uDRQrQl]DJ_K=a?'wKmY2OKv[#*+n\q'}+QFY$s>-oWoL=
    -7J*xB7X7}k'}?}O<n7A*1]-Vr,v3ua#jW101[(mv-zskTziw!oTnX5;_$r7-ukzuwxxsl+aG_[e
    HJl#r;rt&WxnHu-<r;,@m7p>\j~3ju[-#[mx]z#aGJ^3p1]vRB<+T[VV${C]A|rmD\]*2_E2yPl[
    i7r=\n~X=3
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#CwOAzGnv!\^@=rQo3Tu=Me{Ewr>@X>+o[y^p/"~XY}m=xVk-;'vFN4o5Vos=ER!R7^,22jk
    ];]l-Hs~{BBY6+1$'Q,AmOoXA31,['>Kj^-1V-]3]_7[{jx+v}7CmK]B#lxR^';K,wrlxi[,UN$G
    E=n<}*qBHG_}[Z>B52_\BWu'#EiYOei#>BU*T*QWjv}1WIux5KmosiZo'pm]i2*#Tv37W+Yv+\-.
    *vXB<*GXcD+V7<*77S7CQAU>T2*sa[g-7m~xlmx'A\++QUmYT}o-1GpDD!]Vx^}IU{@w+1e[TYJ&
    R|v?H\@Y_N=^=1\VV2'KTKO!OuX<Yr7B$WZ+z#-O{OurYY#TCs_1aA)Q>swRz}\'ox2*zlpb~5G@
    a'-romaY7s$ei'VI]AX]D~>B+DxR^{R@}V]s%+1*>RIC@V-a#I3\}vv27i\D^2w1{\BRswTo@j$*
    B'E_.NS&GQ1BrR]R[$GQL,lX!41-!\JQK$E;~UaYjUx=A?CUE^TD+^WxknQ~1T+}~5L{a;v^v[kJ
    w{=*Z@uuH;<*;>>5>\v?^QEz&5XB#=p=uB7[jN2{Z;\nOkOL}^[xbNmHIik+Zpr*HX'*WD@>)/IV
    i'O=WR=@$ArlXY!G-JD3_IlBDW:Brm2jD?;C}U-YOJUxu}^HImHv~BowX'Oe3K}H]}-^X\1|^1DD
    |iw\#E5RlNk_B;EVQW=!J_U}z[IE}BuHpp-]VrIWCw7ZB*e!I2;O3nuteQ>]x+Aj+7\11BIamA~5
    KaIDi$[#{lKAfRG>^pXx1mOxjiB2@sY-+1Iz$#$xRn,Ej;-aBGr=exn~+2sRrwIp^>vEkWB][*W@
    U=3U=mB~wm^Vmr^lrA{~O-Cu=TaEz\rD>'n+^,wz!V'~pV@zsoznR-Iv~A<Wuj'$5,e~uQKo?w-l
    o/uaRDXVDzxAJE'H<rExwjU5HOsDXCnz!<V82OZAMJRB[npUR>[]xD{D!hjj!_OT7Q%i7rl:k1d_
    _>2aYTT~A2n^i;KJ5vOA5H<{X3]^d%9mET'}U$RpT_]=XI7<5pB!eYl2UH'El-rSY@XOl\ko'HHJ
    Qve^A5#@A${CsvBOHT\<uxGk*eYwHr*'UD2[$\-DEt#*[@Hw}u,mmI}@nOGN%=Hz~CZ*mh3aEe=<
    ]C?|Ck1KK9rp'!*V{3w^#v+CJl@XOxE!5p^Q!k*$JX}3^!1Y_Y(Q\kB{[eKk}-G<lv\q>C~@Yrja
    JV\u,lR~j!,V[pj!MaUHsijC7Css,>=z,KnoYNg+Q]x72C?1@ne\#@Hp?7BqJ+uoX.saKj*x\W];
    v+=<mp}o+1v*Q@-E~[*aU']aAC@,$1_RQl}Jz]{x<$7zrrZ7}IB+1a2RX{^skC*ueel+HV{p;^rI
    QnJ<VD"+wQ[<Dxs}7w#]V7;V2I{v^JoW'#u\DRpj){1vE;r~x}?n34"O.\2A*<^-T;1X-?a35DV*
    pn*>$=V2?Z[JeVA={IvVJeR_n<D'7K^k]mTVup$!GEm^@h_xnEL53Z@![Q2Kzl<mC=I[vkk:!GUp
    .5VxkH+QeJesQ3l->FR\}$p-uYk}vRmHu3k_vRiskTjxpCYp<}l?;v?q,X!1V;RDKa3'iUZ[>[]J
    [=Zn+5VXtixnKU-u@U.{CL#$>AUnI#!Y<B^5jUB7j*B*2l_+>x5sY7|fsi$]@>j=X\s,^i+![Hrm
    AsGjQ@$iYmE\~*CG@r[omsEzM*VTpTAEV&jzVp\?Ku__<W*{na3RjEvI@JBU@GZBx#Z{@]{H<33I
    }eT5RIiH~[{-RIBmC[mXb-rXWxnR<pOaENK[n2r<]+X>2vH,lEX\Kp!-}jn\K@I\#QQ<CTC5Tp_p
    krwB,CIul~fDB3*VmeQDQ<lDC!5IE32veVZYMB7OV$@nm{pjZkTu{a\=lm*eH=>ueI\-IDJz'O_*
    A*liHxaKJ>7BOP!<AjluY3K|_$m^wzKnOU;TY}I-BUUG~$+KWa{!Va=JQN!e<kKIW]$Q~li$@mEE
    XY_*$piD>H(BaHaQz>eI>UQv~3u[tnO7QQ_Bo{7;-I}>v?s;[_Ii@BD#T}>],_5#7DxmA6sv'ZY>
    $z$uQ~uGmT$@Koslpn*EI*>x>Ipi,;<rG[w5>>IzR#;Q]i5K-m};JR1{n!^Z'!'H[wlYz]m1,YQ^
    m1z7\{q7xH!21@X:8*zQ+erHmjaH-3Q>C5XpuAI[~kwT@Q,T@3EaK]E#Y_>n5D:j^\J[2TW(F73p
    ;)#-T,D;a{rEnn+AzGnHKqf{[!]yl@xjL11s_?T=Vw7ZO}W!7Ujz*UwlvBGVUJG3l*lBs['11[52
    +Vs5XQ+a^GA'eu';r>1@'{punq@<QEAXZ##x$A\UVU9^.sX+<kXJ}B,<uk>wsS6kOZ5z73BEm]+}
    3Wm*^^J-\BQjB7l[>wC.Q9>vk*,r#@RDGvvss@D$Zj1QiK_O51U>xuznpJnIo/i>[a3e~VvVZa2V
    Ie}!Ap}IX35E'
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#KBC^k}H^Ym@BZ+1l7n;'Z_1ByATj~vUf9A<$[fYL">=_X[=5szem'kjr7_De<ln3kVk2?Q*
    nO:X<+2U{){Ck;G$k\s{ErsSKwJUz^;};<VnzxCXX{Dwo*=B~]lpzzn5*1_jpEoiTTRWYm,jW]?}
    >w!{><7~x)$jA[@GI'_=kaT*<3vevBYejz72Z_KR^n*m2[m{aHnCiT^s#$e#x^[,v@VCY=x0P}!H
    kZHB=zQlJ$[7JD>7jVwIe#Hxa'RT]\#~sIUHR[HBJR~AQilTo{x3<G7@l}4pZx,5BB=_,5-uEH[j
    Y]s!CQ#G'AR<aDACTTITp[ofsU-o#V{m$rps}vj=JY<*=Xa[pKvB}}#+Y-x>2wp}#ez,vUU=a^*7
    }Yj=*a>]o6BWUCqiDAuMYr#Z)=YD>_]Dps;]u!>EH+GOX^Ya;[^DoZ1u+RRaTkOrij]l+LPVH3$l
    ~j,=Y5K>'@$5D<EasRYF91!{CBuvsE<{o#^m<EeQ[CjK^<]J*rXI[I^Q2[IxD]vo;2<Y$v${@sZ7
    V#wo@%|kwpTQ*@GiQaWps=^{DZW\*v{C5aam}p5[]x?qC^#{#5{~<]]IBn$[RJTmTaGVUr!QWlep
    _saA#R#]']TkRI7#;vIHKjX$U\e3[Je'iXH{^7u@V]]-4mXKYZ,##,B2wnOYpQl^B=XXuKYnrH>+
    zxEZeN+*$i!7kT8J'Z#k+A3FrB$<Elo\3YHZEp[^t/mY1r21pK.mQ'ox5kjm,*zB]=zy?5IV5w_2
    jV=,o,AeD\@C+_xryz__AO'uIhrX1QE~BnA5[~rCTzHj1A=HXaV<pr<Xs@YK7v;HalH*A~cit}#2
    [px,\GWn_nsoa^?s,pW[Yj^xE$vvZH11IX\A;|Fy-H@p&ECm@ITE^)]B=W*j*AsTRWs_W[}l\Z!X
    rX,w<~'!;?E*k!rBoD2Ujl_#5**3n\%B~=o&.DvDOur1jvR@HKDjaf'~@Z;'jjbWaVAao3U!B]I5
    rornU'R>e<~lVZo0iXE5*X+KH>=GO@DmsX}TK-Q,cck}'rO\ezBG~*$GGD_X^A~,kC4vVJ[iQpu8
    mV'+;]3![;vxuAA+vRWrP~IH;Wn^XEK$s=dpTBRrp_[,<A'S-hsuD,l2,pYVCUGGl;u}\C$^~{9p
    l}1vqIeoKREr~+,xCLK7<'kLM-zG}<Q{Q?[1aWBpwDu1olC]HsO^x=nl]pZ''X',rpjmr>{U^i,m
    lUp7Cp1{l[v2+#EG+C6n[VnJr}=J+R5YJwRVUYXGamRm^3W\1\?o$}UtYEi3DTxex-T\WnT_J*>-
    ]{Wr++a<piE5OEsx1]5R-X]XS<LM]m=k]I9eWTYeXY'WTTEGl]5M^D5UR+C^C,]-DnE~,x2AA=vH
    mHZV-p^K\=+zIsZJ->+,k*IWiHHKAxUHsinwk*U[Z'\BA1}GC@>T?GCYjVQ@zIj~<R7<ZG~n,'Va
    w-D$iE<,{1}5]<[^EU{5q)CzziC2~UYWmwt71i<9=iQmBYEw@Y!
`endprotected
//pragma protect end
//pragma protect
//pragma protect begin
`protected

    MTI!#Q~,oMUH>3#Q*B,1Q2}$_BB]B[]Hu{]AF7#Bi|%,1EJOox*wI^$HAH2v:xE>;B?R2=J*u+=E
    CTTWn\;z+|EfkQ'Be-e]iXa[zx^QI}VCX$sD72[l|W'#Zz1a,F|,*Eka1#>Y]J}vX}BJD72-a-u[
    ,K=;Cs3H$Cr<_An?<7~H1+pGuxsx#<B#a;-7{rWYIr!=kvrlm'Tt#E]a%EXI7q{_AovOH]Q~YZYw
    2U}Q-+oxE_P\2,TEQk2<{'5;A}<XX<[}?uZ}XzkMI?<aYR<$~lxj7CY_[mQ+na'~j,U^pmw$#7TW
    Y*ijl+IoB_jV{*nG-={Z^x2e{UnGvvkZYWZj@VQ]v3~@qe,2v1I,,3',km\!kY>o^(bs$};RmH-.
    p?D[-_BB-Exrz?}=]#I-2[]^AG~^!5W@2\Hu?<-D=Y+ep~5j\&wrBWxn'2mBv@-+Q!eF3<wolG$<
    =HR}}avr*;3QInOl52V[_GTrUvww<]jJ\xR[QIj~YZ*=wAVBw[CJ2*WIuoE1$R$UeHR<u<R7GRnY
    l_<K'sX7l1#@uH^E~R!GWU]1A$u{5}z[EI_?s2AO+5@73+_@llCl\>K>R!,EkUuvlmZ}"k>HUDJ-
    r/}nY<CDQJM2j+{]2E?ek[amrQ_VDYO,!wxqovvW[$Bs[K~uaE#,k+1Emag1?YGmQr{1<w3vBI3Y
    RG=:HjITC}'+n^]e,zBu*AA>=C~}ri7;i>su5iAWxei[iOV$,]suo{r-HzXmeU3J#{o>XG3,i^ZV
    ]IsQI2_$eG-$uARQ&lr?pQw]pkUmTo}arB^W[v_=_YHe>2}H'EV*^B3;r!IR<jv!QOj+zr3G-x#p
    WCo{[$R>[s#I\r@JZ*j<pkp*Z1V'mh#IoKCCoRD,,2x>bY>2_G!n>r^aUKO^lKDvQkYDVD}{Ap*k
    ]ZzkDl\-m=QKWe;*YoCje$aD'JU<]R<!2I3JHjuQe>HT2eoGW6sA]2kweUDTzsXlv5GCoY4'?$p?
    7=ZWvOjMLu[<kOli2rYp<uwlZ'xT*PJ\TpEZA!m>**x>a]]@QInYGaY[<1y%F[QjDqB'kaQo\x+o
    '7Zo;e[k>]5,j$5!OWW5BlEVwDI*!\Jz~v-XY[;<'OB=W,$+*,.1z'HIf^U+Ck\~@kQuO}Ip@'A{
    Q7!_!\E^TX,;-{D?RxGn},U]m+p+'rU*-{s-pl--2<>rafEU7nm^1r$D7}_Uo{DDB=]?VI]!R*1l
    v@==pax@]*$K0I7ajKoGT?_Cl*#<jZI1?Ts}p1VUV(e5=n${D@YBEGI<Wx!jET';VwR}n35>xv+Q
    U=Cr!^}s'a*Iu~ACYU3Xx5Gx~*,>n{q{$T\6>aCkmB<r{R!Ip]s7+nOQ~OX}#'X^{+IO1'7A=Oj5
    }YpKIAe-x[llHzVor2w~Cv^\VHoX$xj=7DT*7]]k7a=Dua}C#Auri$uZUap*?}>#^25,{w}2qo{Y
    oaw;o$_?=AsT3HDWr]x@u'aE]-a;5\K~uw*lQHxj5OWXG'\mOj$}p'<=XT$wu\sC]os*Uu5+sU1w
    @Y^[\Qs;T~<_s1sR,#EekJU~~{5w<VKCWx[R\p'j+~Bn]83IjC+]zn,B,pToQD}*X<~+JJ4@+]ri
    V!;v>DpQ^=7,@_?A1Esrjerm1rB~'KHrG+Jv!D]ua1<vaC2,GWs!wCe'Az~A]ZJm[v;R]^3?',ZY
    '>HDr^JC-Xw>\aWu\Uz"6^iju=#ApeD?{Wv3C[Yv]REHY$JzO^C{=BTQROK,@D72ID?rJaaJQwV*
    shKR,'Yx2!NE?_~'?GG3$TBFv3[wnRDl]V_u1W{\7ZAp/|3R{xmRX=$l!^WYlaVmaJ]^g'ADi4PY
    H<K^$D>#'v@\u5!\iurr@_]j~Z-Ww2K~_aTvR>G\7wpV0$lmYGuHwqCaC{Bz5Wuz>}W7VavBjZ$e
    +5*[\^pD!<s>U$_UZ5$e_oU$wX,z;pRe=x@wJ{>=A<-*]rG_}<_@*5opVjQ@vr2T21{wQGz<UxdW
    EwJAAQ]*3T-p2osQxe*AaBo*12DCZ{$?zlKB*B_"u'i{O_HQf^AoE5E}Kp+Uxp?VukskKGT{ICWB
    EJ<_vkUj;g-p5[:sBu>}QH5fRB1ukQa?$5O19=DGGQCIC-Er-H>vZBHm<C\}eC.jQ$Q*TTWZ-raJ
    $-ozB#?Q]=!HHY>l_=xHCoKuq*X_>JUejI1i{e}eO?vj#e^z'OA~CGXVx<VQ+Fzn37EoenA<=,p<
    w;R7#Kle3w%_wlVjzEz*I$}U[X-@Y$<je\5#jaZJz^;lTeiXpu#UD-z'2j3<-Ov'{R5R;3-soY1}
    *~G;Cm,AC1Ci_+UhVk<jvOV~#_+z><+5r^![l_$Oq?>GZGW!U--+r^eX?z'D3[ZpeB3$KEREIM{U
    *R)!Qj?uVIIvCC>>AHRxb+Rm5H>K!8=Ka'ed"1Ksk$J2jN)y{&=GX-E>>,~aZ;Lko_D]E[uiA{b?
    ^;j}]>_*_suojp@>aj?oGuQ,]7'^*D]l1>\5{pp[U+~sBaWQxzkl6v2rZ#='z@j_BY=C;E7aoU1!
    <AvD~GoT?}Gu74Y@pRiYji[^$m3'[B{,u\aOBI%URRHenA+pYzs{Cxz7H_^^5=2e!E}xC3Z['\@?
    X![9^K,k][*WD+1Tou<H>z<B5UDp1eJwxnvDxwYrVaj'1TZo5eA#DHVD$>3j<,']jn_=-Y\Q!+Vs
    {$H1+YI_Buse5$V$!DejC?H<\@-\VHAwiXC]THGD6=!@5+>YWE7+AraI]n=!Kxb6Jo>^FU<]TQvT
    X1_,{V+C2AQT7W=+36-_~{O'31=mJ}Zs(pep,{Cz#L}wnz;B3<r~jkxXG]$_-15x]B7sC-HOEII'
    *mId+CCfXUX2ElZkAnID'wR_g{'-\RBA$'{{v,7_V-apz<BT'w->jW<;'z?W7GmK2m==C\;HHTnj
    W.{aX]jGR@B3;_uvXn5OeXwtB_W_$WzxeaJpl_e5^sRBsE6/B[{*n{vG7A!,-7naO<Em1vzx5v1@
    +IK_~<<mTnO{B-O$,~7\Sk'T>1Gj+s?pnlX7sm'[j8]*5\h}~]xeWN*De}-A,xI@J\_Oe1'2ouQ>
    u}xUZr]e@#QrI1K1*=B2]uB_]rj+2Dv^[El+m\WEI7vH2KDQ;E#a,oOsnBG#l\.+E>nuURu$[OWw
    7X_+Xro?QV^H_}li_$l|$;}oTR5xKGe=Ro>?i1^[~}kGC}?,;aO#EnCBDeBUp^ruJ8Gl$I]eJ,>o
    HkITjl#z+2<A^<]-\![w;!\'OTQx,1x{eAi]\^m}=p^#1>x!v1>V_1JGrw*B-ZD<KAM{>DKAVRHH
    xwCV7D*BrVJ!$i5ix31YOEwAokYEWVYu[[2gDKW_)@xims*D{m5572wDCM4.Bu+Q$DT5F?o[7*aO
    W1<DD-e[<m<Te/=Q]m@YvC~B-xhEa-^BuA#X1HI!1CO2z'D<\^;UXdjaWXzok^n'jTx'I^|xze$*
    \-nXA'VnvXWO_;*=V\XQKOuujV-XHCVj,@U/i,^l+x;3s*[}1_!ws$apYE'#HOn_n]i;zDD~5$pr
    aE[GBVC?VG<?,-!WXw]s1CrAqQvwG>an,=+sWt!-rG;w+?oT<IE!]RWCzV,Hr$lGZv5G\w@Y7_^Q
    X^Ysw3_AJ^E>m*"!n*A2=ZxA{G+~aVBml@V>'~@pZ>zykv~soj{\HCCIwTw~w^B}qBGs-'o7zgKn
    \+G?~}s3wuTep,XX~~Zrolb2[$oE@R?^I,Ba[O,3&aV}YR=uIe?u#Xsvlr?v'@jn;JQps7slY[![
    XXR?*#Q$Ir[3Hzwsa5IA^Gl'ExOe],'IVk,ZpaREir}n5~rk=?x,5P=kwUD+Q~$>,@UpjIjejB)p
    !wGCxElr>lQmQT{uDJ]>ET!h*H2]C_$]<XOzes1]]xi\XB,EK{^}@e]o\uTKHC<\>I]^vG##UY5@
    ;$>Q^<\$\5zp.rwxVv'[^8zKD\U^nQmO]jJEHGRIU<R45YC!)o?A@Up}eIEo5~75!A<+r3X-Zasn
    B{D$nJlA#w{B>7re\[GJuu$D*lu2ki1_^Yr@,as$W{<Dpu<Re4G1XjO}+{;pTn$WR*Uz->lZEGsm
    @G-]2^!x>jl7pEUEs]BJ2?Y7}x/,?wQs$iI1\vaw*\,Oa2k#<1-i'K=C!lm~>w]I<+;o7m<AYAw]
    Hu<<\\_R~E#D\#wUU-H=GukY@-?@}{@YVkQV\Vvl@Xu!$^r:l3wnx-'<wxRQ_!v>#}{*7xJ$B_HZ
    E2[z_R_orW{lplm!*En\G$jQ@eID1r\~,-CZ2CaKcxvHn<z2!1->mxue@n}WVO7U1m_E>WD\@jeH
    }m==v^p5\GV$=$+jY\kGD=JmIt\3=p{VKYGwU=x*#6>xKQryC!mB6,]Z7P*nm<oYn2pCW[i5+m}7
    @n*?r_,r(r]U7@wruSZ{[\8j~T]O!Z=-v]lkaA!A$#\xWVlIJjoj!_#}p\u[JH?lR#O,R<GWrs\B
    w^XI!ADUUU[3RXZ=Xu[h^?K-ZCEm}[<U3>7^z5<DJa@<oQ+DUa$HzwnlZ{]I}UIiwR#\+CVGoXCk
    771a\ZG-<pll,evr*2!E[5TBEj7?U1Y?j?'z^#W]En}a5QW}G'\r#zu]{nU[Il3HnQ_aEH!sE]<z
    b[KGC4A+QR'Xm=$,,H;a+'9v@lv[?G{t_;DY>>-1^J--4I>$O^I#@$v5*Qo_s?pp}T+Uj2XKuQi2
    EBVm,>G#{OrnUBu$*!sx>\vGB,++$>wj!gZ<!>*mQYITwU_p?G,KCXH<HO,BCKr^zWlzVaXHG=~l
    7_jJ;x_xw5U+pDWR[TGwJeG,@R7DovyFv2E?e*_jnxC@9P'Kxlv]+xE{X;]Tl'21v,Mu[-x5@]$|
    @YJpJj$Uf5-W#v'mAv*oll]3Kluj7s'lT[{^[vi<O<rR+2-,K+-X__W5\<1p<!nV;:C5Y<2D=[vR
    lj*OQ,GssGV*5+O$zjcjQ+exCuo*O+O[o+rTE=ZD[O2q1Eu~l>Jz*7BYs+!#Yk1>(*?rU~=owpBX
    ,[GWjqaoO[^'RrJ*?kpAAOpX@'o^'e'_={^]CojmRx2elrwaVo77@Xq;1eu#pV*on2IoV>E]7oQm
    o\Ee[K?l}m[%TQ+n><\CIv^p_Bnn~>3DZ<e@{+JZO~==]oGk\z~C7Q;1BB11D=**lB\?~Ca'I+V>
    ^<Y-}~J$:X+$U*KpuO*Ak!x<pY?lJ_~V[4V==w=!H5HA[@SX>nw#>VvEG\,v_rU3_@}DlwY1B+QC
    }l*qTD#]D-usmXT_xBGZ0~C5e{D^3Kv;s=mJ,9nOe,snA?D17iKa'~'R?kr}7rGJUrouX!,i5nq{
    aCaVBEX7-UOE-T?1U[kJ]=Ub/Gz!vfBve'C^^Cr+2laT73?][U>e>YEGrlq.,_pK-T!\E>$_/5<[
    ]K+{xnlWBvwZ'I_AC;&^NL7iOZIB{;;+\QzxWW|e272*iQ{1[~-kEnK)uI'uODp\GrD@RX;vRvzx
    RRDvx\,e@^R{Yw=JzI?uk]75jT1Rx!BG_ZJ#C*R}e-Uw~C]iU^w^p5@2-XAlf[KQ*q-TY;~o{~?Q
    }j1[wH&1tEKx=b>A$o3E5G,}pa8p/*4;p1Xtl1TXps#UEjaUzexn}Wvxw,QYanK}=exKiDl@GQw$
    xpw#n}iH^IOAn[<Rl5OWxmw7L*K_'*RR=VgY\E;VkY$XnCE42Qe7iVA]xW]J[U}$N^I;-jF*ans,
    QI'}}ZlBZas[>@a=BRYK=wlx{Q@rv~A#<He|YB3ZeUa+AOD3X[*3Kz5@BkU#Y[ArO,Qv{V,'J*w,
    n],-_uIBw'}Ak6nt#Azn!Y*ms3vnu][?Z,J~7x3vZU[mm=RViRvpA[~e}xJIjknopT_s#<@$O[^=
    ZjjQ7zHV+$'r&vzax7r2CrT5B\!s~uHGD*oVk[+ojev@v0BIxzxw~Uoc1"5~Q~z?Ysnl32pzR]Ho
    ?w~^_COY5'I;3o>rE77ZWWn}>vZ\YXq\=_uYQ,k-[CCn$>=X5+HuE~DrJpR+DEusXXK|IoR]Co[+
    ?sXIw[Y2}m^j-BIv9ER75iru7>\mu$-Il=*\Oj'I'c>,aW/QFBJ3+IJrDl3RE,Onvzk}kh\;wE'<
    nOaGQmxW5,z<\je~HzOAAz_;RpxjX#hx2R{YAm1$Um!jO1ZaG*p_EOlviV$ZGT+R77m?Ho!;<aOi
    X35Q,BRBXrp=RlnJ=}Ha]@B^'V5n+{}k=aV+[[x}2V>-A7,KG\G|aGXBopQJkO!Y{U\{XDvU_=-V
    x<peaXI,Y1}nQJ+K*+}JNl&'Y--(5>wpW\Ie^<,Z-aXeDQ^-_]s@!OK'j1=pj3{2aDv@zusiTslG
    =rWRXT+xv\zZJaQEJE1QVKy.(u[U23OjuO=$BI"Wr_mDzuaB@xo5**X5{\Jvz-z3pv$}lz#UYmEO
    \*aU\@7f;Vl?|<E\]4e\a_Xlw@^k3p}IsQw5Vil,j1+>EG1T;nsKek=Y[GCd!HTW<${2EgRQurHB
    siAO;IWO3weEAm28DGwG'N=WQoZ,}'<l#1>okTI=Wn?5rx
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#sJ=zDz+\U7nX*iuj^x2>C$1T2Vnv>GY\FL%^&BWnz<[UO[,5#ck>GCx@AR~RRi_7A[&[?5K
    ;Xn@naA'vjk}]irz!w$wIi@DFzx^QI}VCX$sD72[lNW'#Zz1Hk5~{U_3~^EZKk{}*TD]ia)j$Z~6
    mQ-3vlA![$n?fA+n@V$Cm:"69fO(2IarBCw>y}-;eK+[1[G27ROY$7;x_QZaDlKUe!&Qz3x#^x5T
    Tn-+$$!<pEBcrde?A*DsR1=,*>21JoR^wD$UjIh~T7ghz<{k(a[mk^-~Y-rro-I~Cl;]<]7ls2Eo
    js]$W!TvWa<Ho"2]1i0%_KYiA[mz]2HYer5-NA]@<#1;@bMwImlvc.7>V?IesEz_2GF*O'';},Zr
    AX[-}l!sX\'r>K_R?DJ^\W=0l9;jQme!uk=;[_1TDZ!Y5s&^1Z$h#]mZV+nm<nTpBz~vaOGp6J'a
    mrs]5a[sCeTr}wUoi2s]aB\XD\ODuDj?}(xn<GZOalY3ms5J3>{T=!I;aR-x+BoE~oQ\-Ql#ruw}
    [?O^~=3Ql2v25vem2A]a'!1rYDGH$eYa*H'KnO+G!v91X[lj[71'@3Bqs#B{Y_3A.X1<=vkd1-zG
    -{J$7UjCYUV~zXBZJV]Bp|$QV]yXE}$GXoxr'_5YCA[D!=k?}zv^W+e]_>^3<EBr[To{$HTm>OEZ
    {u2$vs*A$W#h~r?ju,@[V1~E}<oplkj~#w-Z=\?wAzUpb={-m?_275y*rE]H[IB^B?s$sY'_~5ae
    un<Ix'psxp=]esmu}+*^lx${C]WpV2pO}x2l9}mH]p<@[//*kY2r'CeB'BE<''Ueu=!*;sJowWTI
    1zzzW>U9B,iE_2C?rszRV\>BYea!z*pm{aV#Q?'=ZIpp7l?kx;Q$,]EeIIk3>j}').=;+puo{r{l
    mOC7<O&aC_Y]n+~\=kmKH'<]z~>7Q-C[2Z[@e_uC{'VrI^zn,2<V#J=;*$vA-B{sO5T=E#@+je@I
    ku#\l\OWa'k9lOU@@O<Oy?};#U>H$V1zWUG@OG!URrGUm}[<Qn,svma@JBri+k*H7'g7[Y+Q$;!n
    >'<7xYzYt3E'uiHBA-EJK+12!_}ej6J_O~<XoOr7#-a$a,#^C]AG}Zm{>j&HHHOO5ABCTV;|;'DJ
    x#,UcJEesV2'aQAWvA7<m~}T=B[$kB+eYh_i[!#5EvW$!YG*aD%3$wTWQeJTs^vM^nvA+rr}3_1R
    pRC3y9eBnO1I{ovE#n=(ArJA~[JU^{Y_A]D+WHAT'D,sV5wWpo7@_prusZji!}p~ajiEs3[~vD-Q
    @>jVpQ2I*+'$pvJvp\OB_qTIpl%l?QQD;@BcM=OnTD$D,OvesdHw7'?Q-^[C$['{K;pi+z*<G#W}
    sAvl7a|ix=H-Cwmu_-C7=O^'Z_[ViWI^<U@lsU$#Q7k#r[vi1w=_]R<Tnl[<xWI%\1^Z2,Kr=RZZ
    pJDsuRGI\["f,Xp7K_C]=?@}3Txw{+-2jeAxlkvBLB?+2Nfkj#p>s-HvKa{#l2WRD@AYC7j'!,=J
    w<5D'\u{sZ5[#l\m$n>QDZE;<{nraC'y7H<r>z}HEZw;BI'kk$XEK\-j#<vn#Ye3s,Vjw=2R\pC?
    pWj58,Fo#{woV#{@awlk_x{~7x;l;YBjOD~ao1,j:1iBjL>7[+TU-Cn[*\Kj3GJv^nY-j?'O5lwx
    JTDA***oH=']Y>ujxso'szB[-EG#@3,~aD*+],2s*{rYJ;?+=B=ceIw[#Qp~X+Ts7i['N*+1wzO~
    ='C7lLnj_Z$CBi}wEz$7e3]X>CG~,<E5k;pi,}d=z77iU+DPsTTp#+$nXauBlKHG?=k~GTnr=reA
    Vxe5iXapOd<T>#zr!u-s5xUEV_FPx7soevzV'5+TR35;xnp,5^?uGli]ZjQ2O1OTWE*a0'jIi<r$
    Ks>3!7KjB6@}VHDWm^c3a;ECcJs;#_Qa3KEa{@'jkYj*$=vI$Y!>DVA+@=7r2kV>pT7Kp]iUz1U3
    ]t3zpx"@]opOB-C2D3j*#(G+\[;Q=*"[?g?<@;WU[Dk'=jJ[KR135-Dou=e@ZsTa[]=_KU5ivQKj
    Aj*n7})l]{v9pJ!7\U<lrXewG!['l}Z=iXKOOJJn2YR2|v[U\spV=_Azkgom+a'2~]{O'+zC{R-l
    Kp_eGUB[=JI[{p|>1<Uh=CTk7'#w|2,>;sOYuj372L1lDeL<z[~~57aXR\[j>z#.>\xp3Y#+/}*U
    p'B$HE?gQ^YUS/Kl{<3,+[+7JC3H+X}pZ}Cm\p3+xk0fkHVnty],<kv!Wk?zQ}emCo_Ce7*v_1PQ
    E+ZG+pwa{jX[X-!x17reCX~+>A}[k\'x@zAp>aYRi]!F~'?vZoKGVX*Y$HsC?1K;G}<H_aKBzR,v
    \RBQQi,ej1Uo!C;~J$sH?1mTV7C2,!{Ql3$j7<5WDjG_$iozo$*_oV=koAOXxUJoIJv\s_n7\JW^
    ,HO_repV[x]G;[RsD~_WEu-Vztx<@Ct$8%|eY~_RxoDb7WuJxhGD;WaIQTK}A}eaC-Dx_}r]HG#w
    A;:=E]=^vmpO!T$H}JEAoA#Pxu}aK\j^y?5<kQIkv5rvx87Z>mQXVpT>m{Dux?w{aux#u!F*7uI,
    ^[s!\Km&Z{l~FB"B^'}}I[sN}#3!,@Z][m>jQsY'$ZG#R^piYn{HrX<ZtH7U7^O}Xwn[B_('ZRlG
    j#?vrl=Ua!vo^>?e<123--J'klolLk+*r^k-!vnm'WT;DuEmrGvAE#V$BvjO*1UuOIzEwC[oEu7?
    K]r}Urh*B[~m]u}J,'Ik'J;>Tn^rwl+oe5arD2Q&Awu!CbvVW@0%#a7pet0*i1[\O=Wl@vpj2G$-
    },pvI'<XzD_<hGJVDnlE=[31xkQu7D?{Y["}#<7R,^Y'[oa~E_=[OupggYu!RGdMOZGX!BD[TR_X
    e@1mxiOZrpA{jx~lsJ5]rJEoeK<;8=Ajle^ZI[-I'd3X3#r<>DBwBAK,k!2=xD}Cp;>n}m^aHj>,
    YrI;onf(*u[BX<UB!*$R#]{^6j'C7(5LplrxFAA_sI^[WG]i{UB]>BZIR^YYpv!l,<w{@0Hp4r2w
    !\5-55mmvKR!^$nwKvRRUZXAD8$+CeQuV^R4EDu>lR'sR\We7-XCv;z!%K,Os7K7ekCBU,Ce]&Kz
    kO-EDlEj5Tj>-XvK^j_VJ=m[DuQl_~KaIXm{,CJna;=s*15B<V'[>;;BOJUs=^+{D+R{Vzp5-3-U
    H]Eihi<{_o'ws-lXzyzr#l+eYl_G+k^s+~b5-K*YC}rGl~1h0Q_pA{Tl1nas!{Q_[AO,3^;G{W5K
    =,QG~j=|}Z5JI2\uaAE[KGIZ!RQK#wJlD>YEUE=Ts+mR}-$,Ixo$LOa[;:Bl[K.xCO[pZVVIWozo
    AA!QMz7m~s[vip@lZNEXjuz>1m=+G;>xW2WOU~=;E=v-xE?<OOFe<nX<pG^!Il$ns\$*sXVD\IEK
    epkovC~8B?G;#*JC2D$KKILmB!1$!TI|53-TIGOeCTZYDY5>M[G7ER\.A{}kk-<3i,*-'~-Gs2xe
    c<'-o>e*{D?3GnwT5Qn3+J{ZCaRQZ?EGGC0aR}Deo+wD<7Z'=j}~{joTC[>EAT~ZQ'ztY@12-HvU
    !]H7UIZ7{wa@q{<^w<<$kp1pAV\X$QmeOI;2ll5>s!O{u;ziJ\QTY_<*jR,?!T-e,L}G<~BQI^.#
    QYBoU+n'JD*w}=]a,oX1^>2QHH]uR[~1ziJ~v{e@nlGAxjIsJpw}s-zTHO^C3wx~6/CQmWQD;vE;
    ^ir$}DvCu7#v3KBsZKlmj]rlnXW^]Y!]EJ5YZ?u]'HBm$W-pJ<*e+-3AA[v]2*va7~KTlE9?*5]z
    xl}I>,7e'~OB3p=pV;@ur}uE<-3>TXn\~mzoEE3#TV[F"Om*=\w>eyu<}}>rZTZx~}HU$=!AJ5#B
    }#y^iWnVu2uEx2Q#B,lRUaIUV+Yh=no$VTK^[Y~Cc@x3@KA!*nliDN~>A*$en=gV[ms\>\iRl--R
    !H}K]=rJnxl1$}Rzzjkvlu2;aV'}m_{uoBX7zCKm[nw:]Tje^+5A#LLD!;[!7xBfK+HhU>*C9AAo
    RUCT;,CB?L(p^Q<xp@=xQ<HZUsImY#G}6I-2@^Uo+{{m5Z-B]=7p}?o<J='<QDIEsCWX{LADE'^~
    a2e>25lR8!B5YNQBwU$pkBU*-U!}5^Q<R*Bixj}Q}7La[oXi7YZujv3p?ZB_aW\$;^Qpr>nImajB
    ?j?4?j$Czv]?U[srw*J1#E#1{ALEWVE&'Y,-Sw]U#G_AU+{m;Z5x~~[ps{DH;^n<X$K~nr]mV6wU
    WC1Ts_OsTeu\@u^^D*A<CQ*XX{x@B{t1rXvpn!kA}'n5=z;z]Op^i,$YT2w1X1AWoO'GDY-2'Xe;
    oo^DTGR1jzUs3a#vGp+IT5}nIou~BQ^kasC=-w]?Unp@DAT>7]'Yck5i-?E[@BQ$J);'p]1O#>5J
    Ym89nv13lXA~?[j2Q#7ZA}Avx3@Y<s{>mv5$(>Y5aC.5ar!:-$U*UUoGvij;y[U3+#a$E]zi@A>I
    \1UnOLKoQ?cRZB-HnOTWVEuxvC2zj\*>n^,A_fzjmWSCRUvv?K-*m[p)T5mjvk[{1aX]~5e-R>+7
    np>1~7E@/AlB@\mseLcC+=e,p?BIO5E2]AszX7@1C^KLsC#Q\e^=a*!r=WpHZEAzd<+BGh*kB}<Y
    [ViBQ<qjTY2'<w-5EZuzux>]Yyow@sIejlB,,lVIezBI]=V\_{k_\^R{D2Xs+jWl,*svmk]C*nU\
    i{T7]vAr+Y2*~$aO25~IHx[C;ZqHO]aHC_At0Dn^?%7<}DxlvC]ZUn,vG@TlaXDwQEIC}Bk>*RTT
    X2'$_BBlR];a{;XS5Uw>Ew,'G@Z?{-A$QQ~VY[K<L9sB1Hjr#Q!j#$xjjpU=*7I;3<6oIjve(nn}
    3rDTTQ@m1nDVkJE*[^xQkw^j<]7^~lH{[N$O>n9R-v_G[AA%JYm{Uv_lr,$I+1GvvnG$Y~Al1=]1
    >Vkn2H$G:Gj]'?5YsBi'jTDIGDB[Y*-=]Cj<EB,J>5sos2[AEA*!{DM5Hoa{s-Ya'_1};E?&<5@7
    K+QZ|Givo^V<=;s?}1se=Y_iaY'lvoQz3VIH7W][jork>paZ?QIG,#x[e$@Yi,mG_cxB_}UwOva1
    R'^uDRTC,=VkvIuYe;7?CH!I]uE?G@ZjlCx<nHxmWvTGrBaG;2MI?'^SMATC@v3DkWv~]?XnQQYv
    B-{{1>zDx+,W,m$J1p!<Rr-'7yAHjRm-=@~{T]{v5*p{BnxVi_{*J@J*1eAeJD]res1_en^IZsv1
    vI*glUG*%=lU!m5Z7=wr{nCa_C^IjCWTjA5Tl93,ArB**u2G1VxwBwNU=Ysi[R3j$<DhjBeo?VO}
    'wRC*7koGZ}<sen_Go7Ej*KRQiDYI']KlCaQVKl5?xk+IWoi+T$1]_ko1#!Ue{QEr^;JQCOuq5BR
    \:}]E$G2W}Xo]C$^E^sv_lzjx5m_i@5'oame25[_G;m]7?GmasE'rz&RrYTz-_z5>Ba]uAQNVT$!
    -EHj]^k@=,,vFH-+Q7Evj--Vz;ea>6D>$n{vmW$;<K_'s^e1-Iv,$3ZD!rfI)-AB@CpIoq_s5wrr
    @?+\-]k>jI-,^7,{>$\2Z3Rnl,"weGAX}$+@_RRQaCOJv}-[D;K7}lW]]W72A!\]lWOp<o1#_U5z
    \]HVraUY\e-+QIUBK~*en7>qOJ,{eA-Vnz7{=@-R__+ZO1<W\JQ1{^p~-U*Z!xIK^]Hm63Y^u^Yo
    1v{wAU_^jZCi'LAIr7Xl1WU\Tm~oR]+{Q,V->J,r{BT{T-?_>2\5IR}#ClvT!C_5nA\}57X7>$V5
    z*,Kj!2GAs.#HwTsElJ,nm{'p&o\@kG]\RI5[TfkCAUilIK*E3H*s2GnenHYGrXSD-eAO2_E0{nZ
    3RG>3<]pDGXQO,nvRdl'[p3Cr}Kj{^X}'+tEInp+wVax^;XR[<a*{H-\QHDK\,<K,1{?ja2}Bowe
    #j!7nQ<=,WWW'eI&I[*!1CKE2j+E=Q^I\@uJLe[JVBxJDD+o>]\s_kYkeG_?W]kTJXjr?in!5fX'
    7=?YiU^]B{*[_~_s]?1O-^3VVKtV{XJ>psBuAp#fx_OCaU]UYmz7&kUOzp];a[z73{-vKsH*-[BA
    oeA];$ooK=u@JpRu;I3Q!aY}5inmD/r-$s3&~z=J5,-5*K'#)k=vJQY]-]xICDR_!{T*XoBAph5E
    eV6bXX<m5;7jjK+AKBomo-1$WDs--x[n{o+?9HH>GRBRkI}D[yB-x12e!;CjpO1p+,oa~Y5o-<q,
    >o]xowK\R{r,?2Ks5s]=sO+~{KR{*wsZUD!KD=zRTB*+x$j-{[U{5nA]]z^T^2XoT@BKrWWR,{Kr
    @}I4=BT!^b1_1{gDe5!Kw!}oO#K?OWKuvrG?<$^#oK{v*11ju+k,Czps<~$Tl-I{l^@[Vp;Loi*{
    apK2axG*'<UTrm!}#IWD8}O+n$1!73Xo+]mJp{GzRoDA~Cj,\3=V+^mZ<z2C~QxRuRQ1GlsxKv}C
    [jR7D313ly6;-;RJTjk{&'z2@v,Z#e3vZ_1<?puZoN#rJ}&bAsImpkB@X1KwCT3>[k7\$u}\JV3\
    'izYJ+nQe]IE*uT2B=#>GInkZX>#:=j*e*AGDi5xz![*K6w$<,,@5{$QTkc[;p-rQ1sB+KrSlJ-a
    WQ=^UnuRl?o\Gw,p}XxTR:#v{k$WCp}]-w',K{]1nD+GkEur2x}p5aA}mQ\Q*!xKvooJ-r1!}3'\
    _Kon\i&k};I>je<[o+QT_oZ@Yj>A{I2)2+R^7aB<RlmzJ[p$OV3ea'j;vq-'Eu'{_Y3R_Je>l+Yn
    RDUYZ^uHVr$X+zoEzIi[vQJr]Zo,sj*wcq>RZ=OC^'7=UQAs5H%eH5ZYei?#<l3B}Um#77]*'TW}
    ji'-_G@^=aOQm+XZ}O7Aj'ZsFi'$V\pT2A+wJC#5o13,-ZE[DE$<AQ*HuG<o3Ax}#NjV5KrHCx{s
    *3u\v'x^OoEE7KTn$7O3OJbW_a'E=k\&I*-j7$un*FF's\2GQUsiG!D]}<'KX_<n_k~D=eA\JU''
    ++7$J$QOr~21Z+U-QQ3Y>3Ernsj4+=E36&]=GWXli[1*W_R3OVZ,^xP_KE]lJA1seo3C5UZuY3$s
    VjkK<,'[=^7p:A]_<FlaGTUI2=Uwpx9iV*oRWJDDY?QQr7\Z,HseAZ]3Tn-_-aBZ+<V#>W]0-w+~
    D_uI7vJU]kY^RHQJY_I'z7D;T]J^\f6xT_[FBrk^[CjTmOIAG\m{\UYGu_$@[ArOswa?Yp_jBsK5
    R<+3U,K+@XpZy~\<^,QjJD=;3'W=o.Iw5$?Ol]ur,\<wQ<ex{,eIuD,EE>V^HkAwxa\p?#'Yrp3D
    eiJsKp-{5Uxo?$KQEv1wKX
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#x@5^*]I>K+AIl5l@7r,VZ<T]\$~k1ZXs=?7\F["~el!m7'Z#x;u$7:4YT+oJv,]a=<uEX2Y
    g-jAnc>YT}aap<+1$'Q,AmOoXA31,['>Kj^-1V-]-]_ipHj'ms1+B>w[[sB;&}ZEW]G$w{,ACHa~
    [_!v}SOxfF.GmunCJ-;Wo_\0o=zsn1TW-\Ipo^2-9RoJu<=w@ZY@nk7iYQu3Cu$?uq6<<C<-Qk<U
    aZT1DXp*@}l~wls\!nKe#zeI?'n~17<Ex?Kg?Y$=]9AT[wYm3!C631a]3}WT6[kGA^R=!G<R$L*$
    T^dsG]Z?-U^75c['C2!a~,HX<Esw>B#7vWa5H'Ox#Oc^T,'$2+<DA~prVxJe#oe:?j~2T8(W>W?7
    O13l;D$+wWA;7DTxCV?e1$}'TKYj5oa1!lOm,7n6y*m<#*ue\os<aYg!.C[>eK-Uem\BTb};oYEw
    Cl"B{<llnBo#nz[vur<-[On]!$#KoXY~Az?+,G<QkQT2+X3![\uDvR~9g^nWJ2\*__?.hrIj_/-j
    5^!>mRlz[QK5;aVKWw),Ck[P*Jue}nHD[}lO~nx?F[=<Q14vOBw'?RU{HUp[B3E7elp+^+$a,u?L
    =C_W\1^+NQ?5C1HYIJ$@m(<pAGHpip%&\\[xBm^>CaO-?+T{C_$_n9[VjjD{sAoWYu|bSl*$H!zY
    Hlf-D,H7$<or1\v'XE]T9[Ds>OV=OU}1@<z23;X1o"$n$!>Q-nnH@D\\aD,A5]lEG+{T^p&G=;k^
    eUeQn,T525p@_e<\kDWupk{Sj;]>IrH+qRY_X$}V\1s$iJe{'G{lHwlUJIvJTjU\u[D{}c,mVT!R
    err!KJXBqXH}U.DAO;{aADeV5Rvp@[iwz}.z,'T}~@W]iW#5r+*a5AGT]J7R2zQ2*R]-D3?eI*vC
    57I,^W@'Jj2;s$s"=nAXx|BlTIEx1#[1A[.Q[C*l{x1CH+p"3ETZQRY5JX+evX,7;Ao,};RioYx!
    <Em#CA-w%U,DVm^z#Eu@X.Y$R!S'szseVGiVW1ap!Rk>=1_v=#Zj~;}EAVz=}k1Rj2+8mVJvKT]}
    y@Al+gI7-,Rz2_z3XYBu=3,KaOYjYm:d',[Y6TAR!i[p^=@mlr{>>H{e;zau@,3Ts+sJ-=la#~Cx
    jl1o2s_xJXo'lQj-l^;Al~}xK[T,]73R{PGBpCHUD7D-,ArCx'aHO-JHAH}OVTxR'mS8e\je_W>R
    ~TIO%Ks5TsGnWlH}dwIm]r3@mj$]O[|IE1jWo^;IT+Xpk}i1:whc=n=#_wYik5-=K<nm({eKOTY2
    Q5'[A,GkJv>\H*o~7B,[EI6vJu>ww$+OT'A[VX;\>wAu_zOI@BD8}f?DZEh~sw1}p<+5Br?VA}$I
    ]51lA*1jE^vn>E;2*R~EDJ73x*X7X<TC;^J1[<,=A\~a,~pE3z>mDVAY*!wxa@3Eu[uv<w3\e,u<
    7U_\maWg=Q*2[@jiG3<J_3H=)xRWBex_{0,nZz-HWB\s-Qv<G,*GDjz#Ra^@j'{s};^+GXQ,=+*p
    @UXQwj'BQvQeDJTIvA5#+*:bnw$nXEYoH-<$p6pn<$WoGZmD$Jf!U+G@1E~5~5TRiCZLWA+\G$TJ
    BjR\C[^Vl+ev{AB7GmEnc^,poVmNkXW=?wEBl'zk+C<!JrYXk5l'7r\o2'm^\vu\R*jp2o^Z1Gu+
    =~p$-oE,J\iDE'anE@]1$@rwI*Be*uV;Rk![1\{Gvnu+!n\\$G-j^{<#2X!ZUB;\COpj*C@^1?7Q
    KI,3:T9{a'#I*,}72a[WoX#li_muB'Wn\I^!oK2!wXGC{\zUsQ;Wx=Ckj5n%@avifAl=GO}H~wV_
    {MD3K'k=jKw-vO\]OxR=#;[q=HI>j!wTr#T^;++~;C7V]-E<uI?u!_}^mp<wz})z#3Dz[xX{HzBr
    +>Oorr1({+r~eE-O=J^>a7>}BvwQ)sVZQ5[7mhD~+V$Urj\R?;+YQu5~=5aYJpH+z#UEJrGO\;66
    kI!p!la$+]AU5'_=)<s_~I-E~pAaY>n,#&-j=\EaaRD?lD}2XokHR2KoCZD7izV]^iw7l~$o+=VJ
    ;pG1C[Z{{'IxTUfZp+>7sA[I_VITn_R?X^HbJ=O}$,!pIO~Gep*Xwj_H>x$o=5]m*Z'Z!_rBZr~-
    h5TD;QeUwKaY]avGrNW++@YIi<wR;7@>,a?wnoI]3^{5A,+[@]KV3RuUwj7A3O-w7D<]<3+RY~<s
    sXu12>o72_l~pv7]}2WGB-O]X@4[*e_JIw@;wH[JGa+@lHXaXQ$j#RRBr-R|E,QE{^nQ-T3!KC@W
    :V^HJBZQ'O1SCD#ev@ACEk<oA'\5,$e5$E>Ks}eXl!-s,Yz#TImj_op\BUwWgo0[EOz:jJGz@p+_
    moTDOHDUYJ>HC^+?+an;[Z=mCOi<IUsBK]sUj)?^wGVpIHKpx!17J~TrQpGnj{p?~\D+5am-Tm<^
    o#*zkoY|H7ouW+m@{oim=#$m,p~=rvp-a\s,=illZn<'FIEoTfi=w?BY75{,QX-jvIHED'a]X?Z^
    @Ks!7}M^p7Ea[qBlzZ}zApKw*,3UA7-E5Ja5A?T{xX_GmeTCO<j<[["*a>]{e_$"}WXWz*<JH_eX
    'Y<?$k{X={VTb{|eD13G"XY=+x=CuSPJAnGB>ZQ&mUaA$@j+~}u$43>[wE]-2uo3RG3r}rzRzmR,
    Tn5a^h7@nD3>^RIB~78_aaE#'ZHDHZaJVG>+ano,2ImW_<?TsKxn{+CnGrAC#R,CG{{BJ->2w;X'
    A,w+5GRes{GlG3#QrpURnT?ZHJ+^~1o><<nJv#V%NJ\n?p3uE.#O[3?e_om5!~Ov7x'G1'$A3!_o
    jCvKVWHAR#@zEH7w,^gXn3,Q]r$E(E1=*KC}CoZAn']u}a7n~}pE],X@T<TDQrZ}+Ts-3y@G+D:,
    JYn,=GUnv3=7]DOiXQ@Wa*E3=$2P}KD@,QCO[-3,_!o!G@3H/Lw[>$LY;A>JQoUv@^~u\VH^i[GT
    DuEaI+sCUB$@vlv[jJ2,w1o@lO!R3UY7PgPDCnpIx7
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#_o35a*'QrKH^]$B{AV<m*<O=G3\HDx}~N9mUJ[clio!VGZ*joo,}5IVDs#}G_;TGHj>yARI
    QAaOa<sk7_rPlwJ#*+[[o_n=['CW!Ul$HUlIH-BAI_#7Eiu7p2<5HGi,Yl1[tkGu[Iw!,m<vH73K
    T'D=20nHIsn1?'O6Xxj2rjV3\V$z~C<-3-\lgBMi<2]-Oxs<o-{QI;AUOIm{s_RGG_[*K]RE.O~W
    wwD'WBJ-$Bk7-lD!l~AriQ'3Xe$+}TG!#?<X[2l*?z]Y},$*[;7Q?cr;UHpx*R_KX~oIXmaTIBFI
    ']iQA[\L?=7#@OTGpzCW7VUZ[n-#j<*3oK$<eA{n1KzXom*ZR;s*z#3]!RCKqu]$p[nxu{$!V35*
    #Q<'W9}Mv{$2Y__o=~EQ?jw}O+U7BP,JW@tJ$}G^I~?7?C@cl_r\mQjIH}~5}$!@m{Ye$JuX.}@Q
    ~VWUIET[nLmv+?5i];byZ{^oI(i{X'H[\p[o#DR'UQBm\r@OJ!1VsY|!Y7#7A{J'7u~5~A;iAE!}
    o?JmpAaolIkdKH\eo$msw[~DekBOY_$Z7QnnH$lHnj-Jsu>@WrsVP0?xm*yeGQ{w**v}Jw*E+T@\
    R\}NZU}Dm}x1CvKCYF6~n{[2<I_K5aKaYR=awWB_~E_OjvKgC>A!L'lWkE{B\,?'jl2$eaXVrm<<
    x+YW@D2+B<aR=z=2!BsO@CJ\#>rOiRzeHgW=x2xFgr<,EI!BsTlnUF*AJ#2^sH=UoRg$RYU@hAh~
    I#K?r{GBeDA&r[*~{soR:E>@v&z\EoI3C<rk-Q.FG-XEK<Ow-*\}uLV@nJXHR!>12VlXWOx*x$a^
    $pl,jRf_n^s@^DIaem$5!D?@pZmT>z@*D{#(KBVT[;-=1}Q=l^}I\!<Hs,B^_y:+*J$#7DzO37{m
    +V3^nZl+a@u!V>~i925nZYliT{-u=2h;{lVY+w]1-AX'$\3j${QM:/vz_+WO?k=COY7'G<^<z28]
    #G_^\a{~x7YB3G>psz]sJ37IG]?ee*KVwU7_p!Qx{xA^iRVmw=R*Ok{l=2[+}u7OGJ{5ek',x^7r
    XX}=W!+!EpU}7aGzX=$5_e-1R-kDRBRe\xUXE@;7'JeeER>X<oVOT=*rHOC!z#BaR'VM?H-B+Ano
    qlR1zY}A<I}+~#IToTx$7yajp;bI5!oXwBeVWBD~AE$f%l!;^Z^}=x_J>u*'zt?U,VZD;{D3Ka^W
    ;l+}om\v!HOQp*&zZ,Y2Rjv;{n!55jBG@j$=Z>Zj5_o&53RG7'x^7*rs#oB2{sEz5$-[4Wa3ZpRQ
    X6,$,Z=gAs,lZ7XUs,@TpY+u~sx[5T{^gzD3U7@oJGaHozE]!!<A}=g6tzH[<m}[^Y*jkmUr@k]Z
    e-TAv\ViT_[RYC?_]\'_u5ko\5Y;*xT{E3{WUWTI2Io1UB#*5w5IT$B^[Mlnn#nTZ+l_;A77,J4S
    WXK#2vR=r=kpyaI1^\;>$@ou^s_-'{=!^p~jXv_GE<$iuoz{WS}[soHAaGaXo!is]-Y[-uJ$u7BG
    z?5$uDR{Zz5Q+>fsXEXl[urVenor*Dnma$IHI+K*l*n]*]HzH_]a+wR+Ykk1,!{."g\+Q{o?zlqc
    oRi=jRkV*G5o**aa-G@'>*sYln<\:=,o2y,Q5T1?Kv2oYkx1UX,vv<!n{Wj1DYm,s-FhV_l7Vkwj
    vOnX]mR@Qa[o_D*2ozo<jHEI1+}?;_n?'Gk}i[O{^~QCF/j<'#;ozpPAD-35r>\_v-UJr'^]I_{<
    VJ}~'R>opj$G?<;8U$7V~VK~G'?JsT[5B#_uUa{vRzY7xvJOozTCLal1n!wTuJ,Huz!ZA<ze>p$Z
    BiAjiUr!aemrsC{l@jQUj-z$-H+eOHx!71>K{]p}mwaKGs-^]B]'}gWRC{*>U1A\BXi\<p-*G[<Y
    iB6_!'!<8Ww^TqC1+on>OrOnHIEJB]ws']OWn<NCa!I,Gv'QXowl*Iw-arA$q;DA?iBji^'U~Kj<
    TuQo2TXE#r-B<X[j_}7>W-aI+>}$za>'k^V}$R?Q*H1Cn}HjzMo$U>-Os2[$>n5jYRj>MwR]ru]~
    O&G~mz(a]=u>wY3C!-=h<>2{,NjFT]rACHYX,$;>^eK\Rz^O~{G'1B~p7Yn-<riYl2U@lxnYn,U>
    Oz[o6fO,;];lG>~EVTH5KE$1-D,u'nb'7I5_2_+HC[vm8XnR{NG,]Q1=5e,]V}~EpRms{wWG?1'v
    B<jH'+nOD'0vjDW5#B7e-Yn=AxlVY[JK*srpj3e#Vi[~e73Gk{Y.IjBZ1iQYqE{@k3B2K=am>?BO
    j~7]$=H'aT]n5uaDmI7VRror}z7=,Z{AwBp?rZ}zTk>'jBx!171px2[*oJY!Z/~jO!?{!zXQD2@A
    3IB@n2pr_lIskUBnG^RBDIEC^5<xXOnlQu+,Tv;B#KE]QW2O?E^IDxAT;DC$R?oTUK[JZ_Ko{{!l
    VCEe!sxRsC@x]aKT<3Bkem@aOlP-_jp3ppxk[Ya2E;~W_>GN@T;2@[@,ZnR!E^-Rl_*1#H}eBvvw
    x_J\x*~^2<l?bpC'JIDam1A1!7Tr,RBDYxmH@5IRX'vRKnI\*}ZU'plEOZ7G!]Z],_=I#WRjQ,z}
    2u\DG\Q2XoHrr'!,K~{~7+}@vkea{JOQ~IT,u&VT[@P]i'sNw>Qxxj@aJj}mW7X#j@XKpXZ!1GG^
    !CDnC<o}V><s!YKYdGmVG3U}+xaW;V7owm]H[VZ7,O$ARMgCY3uxBEaKXG$E-3'6v[epQpxH]$;=
    TonG@aE{ykv=JT7!Oi1{\[UnEcVODuOR]rVm!AIwX<$;\Bpl>T2,uamE[2Y3R~ilr2z\#2@-Aox,
    2=lO_]P->l'V5vs^3Ww!Hu]pDAAWGH3?]vJ{GYi^3O36,HEBIVOs@+^A~'X-lY7n=^uRzI}HsXAp
    ?z5Es+=v{BKO*xkB01VInDEQ^Kz=E^lw]Bs>2^!l=5s<V]B'-X>Jvs$HuDYs3jizE=W]zl-<AA5W
    =,:_AX^0y[$pH--'?,j>,Bvo#WRvXX]qXAZ+T$1YYAY;uB3p"szHQA+=J|(G[*-aGs<#{K5_#VGv
    @np~7E2Wa2\r7?no7u@JU[prQJXka+K+Hl]7HEU~<zj^*nX2x-EZVzXvu+H@T],+Xs~a5r]l?,K7
    T,z-zi!/^22^8^Yoj.Z$T]rfRdYKnO]el[@T+\l?lij?@Ios>*z<
`endprotected
//pragma protect end
`resetall
`timescale 1ns/1ps
//pragma protect
//pragma protect begin
`protected

    MTI!#l)_]]#OHn<su;>-A$T~[m<%Djnp..zgy~Dd"iY?!m7xZmx3]-vF6F]@~;ykU27UE5*JYxZL
    v--s~{BBY6+1$'Q,AmOoXA31,['>Kj^-1V-]H]H<C;jxmzeD^mmp~@VnjK'IK+]?$I&AUZ[p$k1X
    AY^RW;5znBRNK}oRvERGRRs<kAG~n'vJAET=5KwaO5;K5p[7QwJ#EH1O6HUV~j\5lDel31B{}KY_
    Kd?ORKb:J5,A7pROGBr?isnpzA*\!xB[g3<D7i'C{-YI3_9]kHbBlVT!XRTAOmj#]^]'4B}^ZK[|
    7?{J=;EjZ{DJ\A_w_Wjz!X^~*2<RHs[i[+JRz-B]~7~e[eBC|G^Yl'urm_H'$3=#x>5<g7V}@t3]
    k@'GW+2ED3JseR=W+[z;O;p\[W_1m',v-=<H\B#YW>nwJ{W[_s!>2e]TT-V{o\C\,!B>Wn1RpH!D
    9aY~^,Ei$EwQ!xI*'R$R#Q'Az^Q>Zw{Yzdu*$r2vD3^?Ck1,7Y?]+jbK[*DAsGK/7!uYIp[*HTe!
    6BT3slaEJ>x983V>]d@R~BJ+Ks$I,x>=@a5DD]YKo1FoiA>uD71;Ynm$-=itFX=^sUr'
`endprotected
//pragma protect end
//pragma protect
//pragma protect begin
`protected

    MTI!#?[vD'$s_,T{o]-!uKea,O^RmW$p~w5wT}ZAWXY"rRwo>RC1E?3=BK}iG@l_r\;A3TM.^22X
    m]C]v--s~{BBY6+1$'Q,AmOoXA31,['>Kj^-1V-]H]H<C;jx;YeZumw<2u*Z1[$m}+]?vI}uvBpZ
    Qp[B,TsnF@$B*9,=J@v^\[n5j}%|wH'[n<3K-{H?U9iY?B@BinoI'$H_ox]ZAeN\eOw[{Em}7mY/
    O?mrKEE@1kWJlT~JY>ZV/kQCG<<-{+1Y?o--GlIjT.^'av\A$@V[lY2x+U2<E+WHuBSga=#J_^x[
    O@>B|I<E\@_?Q81_}wE;{UiR2<,HpQ?Ej3\?~~~]kRM4Qr@UarZ;aImZ-Yo39~hM*7i@onxZ2DQ!
    >X]@{[Yaf#pn2,m&CX^>>EOo$sxE?j[KRQX][uUksv;pL,XKIV<,JW^e$-a!'&L_n3^p,j<2sXX\
    UT[YHAeyGCsGAj,;6^};,,1Y*8AD+>ZRmpj?7>pJBo$!7\K,Qk=~-wmY*5WXY@URmO}2U[-w5mOY
    kRWoWO1j*sv7^E^2}AS^2mxDzIJQ]reVwa+EvrJgI\#n-p7!q=Qroma7~E@d]nUjG7zA[k$*oBr^
    CZ~]qa}@+-1*ecrwHCC2wnvIuw}ZU!~oR]CCAjCGX;1!>~Jom~WxZBERK+6^z<_Bhc7^V*xm;nIR
    ^+5o7@aG~TjvUV@Ej'e'*23]U}jW@e-U!$vili3,D]#ov2||tP,z_V,=\1*xKk<a1GQEOV++{K@Y
    UE?_?E#{VKaoQOr{~[Cepr"rzD+:I}OAz?a$!>2Veo-olC@nIkRW}kA]'{1u\aOO[Hx7GD{RY@*w
    W{jvrWvuRK$zr*Di7JY;:T5+[7~U^>B~K1-zEG,7=I@7i:AEkIBy@s^?kO!~!Rleo[r],D\$i'KB
    ,*~O,+vza],HlLC,*KC=}i7Qwzx<u]D+W~ywQ}EZsXT[jxaz2DBwoE_4]!vu@pGm}\n$rw+jRD{_
    n^l@#D'D*He$x;YBkz'5oC3axHooH7>xW17X>B}C#{+u-zn_wDYHJo=i>7Eo6~[R[TI3uGHJ5#eR
    >XQ-WB@X_x2*jYnB,_^7j*^>U&}7^_r?YWup}T7~'7QjX>jk,kClypo?+rn}!QBVI=?BYCT[iO*i
    ;lKuaC}j<ozmTu7nH_[?k%Kx!^^7_U3-juoV3Jws#1z3-GA5H@}<1U=>JU5Ars{TI#x^@$^AKrr@
    nB|?lz[GsTViR;ExC<B<w5wBeuroW==7r7riBjRCYA#z*;_rV!eHX1AT]argrr@G]AQit^\@<E'G
    oB?Gs!{~jrKu[mleG1Am^>pn$p-YB1x;{in<T-aK5szH^+<=GO$K_sq=J<^7H7UI5Jx}AsswrsA5
    p~HB+A+]+^oKeepIi*;<=\ieI+Co7kGkAewUD#IW+3+YH^OlvuZ2+^pB!WG-]7@exwuHI~Z^EOBl
    1v;_gL_[<l[&'U!X_@!1Cv,smnB[-RU=@B!k$KDCrC@RTHA=zuwXz,+]G'n+Tn\DF=+CsLQa$31=
    {}2^7e+'v\UO@lIiYHC|[{{oE@majOVZ5]<}}_zm^l~p{}1l7-3Q,V*{\Ku$Q2@z@sn2sBU?1azX
    >^l[UpJ23Up?iv<;T'vi>'<voC#e(?H@v]n!n!vVKOZ{pQG2^Y1Hr{RViC]75SJIJ'zdN-lVu{_,
    3Pf}BxulJvu,1zT>nXv-s},woVR'k_RK}A,-OJ_n+eW~>a*lV'_$n=*Q{sCARA[6o>;#]Qu#?}-}
    anlJ^H<?^KsAJ<]Xm<E}WHTJ*j[T,#,>}]zv>z@['R*JV#-\<*B''#ouox>j'ZVk1=Y@>5TrC3KY
    /<YJrurG~Tw;$zRoz6|Z-2rW7Z<1l{,v>HYUYT{E@wBDu5HuXQv{C-T-aQTp'VBC<{'1oCKJA[rq
    Z5Ci9;[U$%A<$u*#oo?v$CRr<'j^}@,QB>@TBix>{Qb<5Y@$Xx_qvFmxD2*RWT=$v37e>xTnX?RB
    p\xl[K'eA>WrUYe*{$8J]2pPDlWVQ$H^_]*jmOQKe~~Z/JpqB?rXI<;xsJ\!=}*pUjQl5Z!X-eO\
    UR;WQ'\7,<gZ<GI!Ios+sn~KR5>Z7xKw+I;ITv!8Qo3;{apx[U<5xv$1GrU14-'~]>HYH'CluQC{
    =WO^Q?-a@V!=~r[A_3-vBc{ETR<zer=XuEA{<I=~UoB~IWQ>jHZDGJCG*k;'^vBU,><*\T!oDZCI
    ~zoJjvQ_3AVU@[mX]=[x=xo@XA==W;%D~UuG"QU;_u[T_\_3ZBK1n7aC1Vr#{A[,Tp7K~Yp,=zBX
    ;B\i!7xD]RV~~9x<KrqU=jTk7U!\JED;Hm+BTI]ER+[VI-<?=3xexms7;=AL|3O;[boGk7[<$o*V
    W[,Y#O{>mAXa1I!+j<$K$W-jD~zvGus\$p\z?aVusC$\AGwrev~}#KHUJ][JG=zYz'|R2HG-R[lB
    ~vlz~,#;[R2_aY$TI2~|lOHAW&{QXsyo$Y?B^~u]~+ADD\^;j,Jpl$ueCQU;Yj2$[Xa&@Q=#=zV'
    QX{R,(z9z0?X,Or2;_n1Jk4K+nj$s#n<>7[k5k7-n-[qI#7}vjnWK-BAave}3+op_zB;k>eG2r$+
    vp]as[pTQ}w5wC~A/B=!BB,Z~?+vTh=>^{V]JYmEkK#xi5R;zRz{A~=mv'oGIkZsl@A<-aU\YAMM
    1_lIZ[33n,lT3<Rp@vXt$1O]&=]5-@>VeG}~-WCm2I]YXWBZz~sa5^BK*Ua2zkO<-u+u'ZzzRGUs
    n#V!#N{[U##Q-EDx-Q{Y^Ot$_u1,V1=~nxGjx-WajsJ+*^R$\DonnR5urJDz#=eBZZ^el-H:s{r[
    9~>av:t6\jpU7eSBysDIsj-^GzEY_<lxeXUU>?GifvBjEnQiriaQ2T]1*']pAXR>XR,s^\3Xonx>
    v2-{B]A-ZDj-D-]AOq^As'B]DHd;Q}>Qrl7LEIUJqwx}$]42nVl+{B\UGDiT[WG1+}{(Q=ZHFs{{
    _@'err*B3;'<Y3ar{>,UoJ[em7V!OxH7;-xvWUT!5^K<;DC,@oa\^#GiCYvID^C\u5YTDp_i@-_j
    =LW7CG>[++Gz_zDOO+\vu\Z]_]DRp1Twajr2ew7OovDKO',tJ7D~[VT=>pzGE_w77o+#;'7^xC,1
    >$2xzp-BW=@Ay!l^J{=!W]+'Heie^IwOVj7~OGUCi96f\?}3LVH@G=HKK@5~xT{!Di][3d;1=]]B
    -a!<\OZs]?8XeV1y],TI=YBTMGQDwV{[<V;3k?CQnjd<sv5xKh]>VI7*]A*r>nw<o+!6k<u@Ar{_
    UT_[72X{^WEm~DXIO]wQyQ>o3|[+!'AB<7!5v$k$=3pKu_~RV~Iun<yv#oV\<${K}k}1a+au'*5H
    aI]WLSxa2}[3Gj>\}VB,wK$>O'$=jeXw-Tr,B*ri7JG\p=.a}#K_K]j@V1BxKG-|_*T;Q*<-X]pI
    -\H~epI\]zp\\{=[;A[YPOT<@A>{~3'DKa<{el.oRmXejC{^aI*Q\Z[ge;2Al5VQ]UCYOB<r.Vru
    ^xX=DU>TojuVaxJp19W{r-a{x\cEQW=#a<'Vp<Cp@vv7#HXb@ECr{v*r\?jH;s~E^a}BGVlIUzB3
    EZoBos*;7K@3-1UeE1lG+a2$Jr1I~=D+K=C?~],Ak>;kC1^]5k)OVXvu}A]xK~1V?AIoI\u'p,xE
    EvRXIR\exnp+I,-JD3['JR{H5+eGb}<R@Os_{8n}eA>oZEBQ=RY+7eTlR@f=2RZ=%Epoi3G7@l>5
    su5#r~QsK,]E~
`endprotected
//pragma protect end
//pragma protect
//pragma protect begin
`protected

    MTI!#ro}l"2a]7~OJw^pm-EpAJ=_r~[}!7~70b7Gri|,XR7jnZ*jj7A}T=*rg7/!HAxCiwTW1#w>
    {z2N}mBz77?@}aJ35/o_n=['CW!Ul$HUlIH-BAIz#^^BU7B3v?~'#ej\e*5{ek/[;^R7Z*_v3~Ts
    la@D3Y@73olz15IV7)Q=OB({O?Ermjw*oBrxuD}z^_+=WD{]5k2Y}OiV!YX]s1w_EZ1M^4h/2RD7
    ?Um_;*BWs,km#>e[-$2u*Y7JeRv\7VIB=1J@>T,JK}VOrJ*k_U^Y*ZEjI+CY}F]sK[3{vm\|ZYz[
    i<z]2=|Hz@@pTmrXo~U;sm7~T]~aG+l[*_KvTp_BGi[EkxEJn'p}kYi[#JQ\nriB>ooG@zlRV]@k
    7D}A[{>{szk#]~}=<Qkz{3QVW\WADz]G?CDE>B5eOuz=2[[NwX_,pWxGFzKXV>}Q$Y*V+nw,7o-O
    K7mv->j<}Av{pUwEaDx=,ZE#x'23^^Qae\a*1sBQW]I~]JsVk}2D12se~~al7qBQHu,ZKQ[3QZol
    K?;>'@AI@j"'WskG<ps,<
`endprotected
//pragma protect end
`resetall
`timescale 1ns/1ps
//pragma protect
//pragma protect begin
`protected

    MTI!#-$'j-xz#Hxvs1?$_}}vHP9r{uX@YK@?[:&*/f[B7{AXRe]]XTJC]-CJAa[j'<m51[=Zn^{]
    nKNxLzGC[EfkQ'Be-e]iXa[zx^QI}VCX$sD72[$N!U'wz,3!-^DU!tK5a=/aok#Na>mIO[T=*;V{
    vKDj^KYV}s#~H}2!mD<\C&t6x5{o#{D1rA)#oDx*w+k[4G+vm6Uj+ee#^Y<X1BY[BuTw*J}is*$#
    OsDve[]\E-i_YTC0s#zZY_eAprKs+jG5%cA9'EK?^zJCOx_=-wx*C]3U:uAz]@Ru?_UB-=;=kgR_
    p}XTlX}RWA2qp_X>HOQ~lXn2_jvxX{ZrBROkHVv!\x?U+SZw{TUwPEcD$HTeCZsG3=x#|RC[@EZE
    zUrV>]Dn+AC}-X_r{kXl[c"(!1[sk]o?uE#^D{D~CZxW}1X7g>rm@2]QJWo{mZD{}Ixr{=3aU=4f
    5}KrXvE!?s+OD$>'r:g\l<lq%},#@jCRxa{no75X[_};x'n2e{r3XJD1*~'jW!z@JY?}}*a[JKeD
    {is#2QCAeRR(25P^2>sreY[eTTZdloi$(nY^wC!'
`endprotected
//pragma protect end
//pragma protect
//pragma protect begin
`protected

    MTI!#5XT?53U?ln<jJam5zoux}R],Xes,njo+}mAXjt9f,,-H,zraCmAC7H!T9JnGOh7-PckjwE5
    TvixLzGC[EfkQ'Be-e]iXa[zx^QI}VCX$sD72[$N!U'wz1H>{rD'27@}[*ukN%'nbQ_V\#T7,oX>
    ps+52}Hw{U$VKq"I#1QrGX']W~T1*sJ}'QrNY#Q>yLlek[+XlUuHao^#@K#1'Y}<Wsi_7$z^zOOp
    ekP2BtO3_H-$*ZQD@2Y@vo|AXrH[vZ@|#{1Hv)3e\T,1<,BzG;zx@>YBpGW'@]5~GK!s?aR#\[H<
    Ol^e#]EU,$Ox1#3sEJ'VA*O>IT,\Cia}Hv'^+VYm2!}RArrC-V9;svVQ?O^DYD,SA5En@RviD~E7
    rij>_|iR>'$*ZZ<Y+*\n<?=Ze^88CYU${[2~}__v3BJ?\CAppv@?XQ1KIwpEweVxc2{lB6-{DZ<}
    ~wkUR,<r^xlo?]}O1nxK,a]-KGj\u;Jn]2BHa!l@s}!O\'z;;erO\_{jE@?}Q!-$U~.rDUX*Hv#A
    \{KYa7<_TY@G[\}5dzH*W7K3Az'ws?NvBx!vB{<TO*sQZ'e7?V~-e#^Kn{]Goe[WY?rm}nvmHvQ#
    YuA^?x,rwWK($j?,~7\+Jn-!*H-ZDR?T>sp~)[\w}xmZ+QH>>}';ll4.e-_]r^]2@Bw=e<$C7KOQ
    A,x?e,swn$TW>Ce]&YaE>y3-\R>=>$FET}+nHX[271J<Y<CGeHu}B;#k-=@>5r[v#[G3RJrJ1>!$
    $JE^5XC_<YB4*dYR>I\T<O'OK{G5EoRiv#-w{zWj+an1!roG;n1EV}s?~$5#AaN-aTERB57jEmvs
    '-71?I$Q+*mBTGi,[Cosw*myX$vu5xuTTD$k(Ya;Vms+oi+@Y*wTuR;aXG^Y!sa@KE;XlNZQ<ZkX
    E]~><B]$XCVamCA>7?.=?A<$5_7[A\pmEr}?_Tl?_K$=m@+'-1;a*=RE[Krl!RaE_lRSe}zi7E#O
    #Bu$E~uEIpe;cD>7Rr^Vij[1==\GEYxBHBwI1njm^Kl}^>]Ju]a7OBV=>x~Gi?}[woH}[W>KCn'e
    o'+C#=KD?l2wv1r8D+3$i++o$/"o~+<D1VR'i[E*"pAWw1{msP}D+AI]nG.Ij1G5k=VD>Qe=TQIj
    <D+h#D?CRAH@-l$ojsjk-jajDI!=aXjYiX,,Rpm-^*Ho,}_e;<\!={ZT7pX3LT_z73pG=*d+TB]]
    Ir{#$$Ww]lr<1;[@s!=eK;1i\l7kTG;&h71Ox3<Y2Vy_C3@b[=-w.^QEDZ[3*{GpZH5p;MF\{p,$
    :F<7p<JOik2I^\{5D~Is]^lBW~3D+AF^Z[?_H[WBE]K,,;X^Ee;'ZlwHwr#/OT$~yR'EW~$^'Toa
    ;]>vJslKsQk~>vk]IG6o4m_JnOr]B{}^GmjapUa$>ivlaE*^^ww*wH_s-Dr?^XR[p2[?!vv,'H1A
    _rl=\T}rQ5pIi3{]3_Wems<jW[inkk,$R1yO7^]OA;-Q=~Y[uDX@QD^sHAk^1_+vj^sZlKYAO6*A
    JGmHs1\$nXOEj2-HzV}-<}zaZmC]K2,z*')nO+R1Oi7?C,;\B~Y\'2_HVxYLO{=Ge_Jjc2T[,@1]
    xKn@I=>',iHE>]7==VIrm'geYAD>I5mwvHsHjaQ5Z$Y#\_Tk,[T'\jHrv~v>+GZ+=A#GQ_G@Q>p>
    5R_}G3z2GuaD!3VCYQvi1=j^?!-_up!s7U<+^1Ex\#xVDGp*><B_>Gs_wZre\zv_1jGx<ZxY@u[~
    DBWlTeko2V>-wu@$TnV8\<Au\<7'Qb/%o_3^U\ZWCJDHt]a>K!puD7Dm>eD_^Waw3]MU7*\(wlV!
    maE>YmmX@\a;Q_G^_l>T*;}B*AJ'ral*I~m!zBeE'wjQ:+Q!JGIW!RXoW=pI]lI!^2,@ZGHo_)"Y
    Y_mJss@ujKW/l,GzojXCrOZ5<5^@-Y=W[^[s,}\R\r^a/@'v[+na5bU]i]Q{-e'7;O5+-U1le=!s
    !QBVin_IUpOi,z+X$CKe-uz_Y>lz\1<$X{kz^ioGX\=DU>RD^G{x\}s;B$*^u?KIkGer@jer}W~_
    T$[e5nvHEJ?R*T[GVUk<'=1U{pbK]E+!l;1UenlI3_7TQ*kooiaua$[BBZ>BC'*}PEFelXx1@'
`endprotected
//pragma protect end
//pragma protect
//pragma protect begin
`protected

    MTI!##7X<ev_CA{Upe=!OeKY2pajCAOe1VQd=~lA1tE@@~v#n!7,z[}}JKRoOieWj=G~]=?,<_^@
    ^Gm'li}mBz77?@}aJ35/o_n=['CW!Ul$HUlIH-BAIz#^^BU7p33Z>=i=[?{}XYeBFBF;,!H7B?Tv
    3'p7#eES1-Ya&!n5W'BVuj3j$ee><ep1CG{-jo[r[G$nG!x;{O]E?z{OC8JIu2[\+!NUHnHTQ;A7
    jnTDVl$sIV#N\GD5l+]DioA'@na+Zj1#Kvl7eaX*o7#JAwT5uG_XzkZ'7{O}^x\ji9YxxkwGp^La
    A<ao?nK'Fq*R>p;Q]mHQ-k<n-#V$C~{rln@V]!;IW-~zi1jwsXr?]*-5p1!ol'xlmm=?XB=<wZw,
    m7};aW=mvQjKH<[BlZrv1?Hl1D[CNOl_$hQ-,iA}o1U}sal?~3*mn#}Dl5}ZeoR2QH8\$~]>>v^I
    vAlBWjXx][3o3x{2Vo2YDGW&-{pT*i]H-^\GG^oEWs}wg-s~<l<uK@UJQZU{Wr$+wOX>rQalGC%x
    a*kiD,i=>U'lG\>z"25{*o+;mdF8rVu\=5[T,#ppnO<5v?!npiT\,+@}#p[i&!T,u=v1#uxDT~V@
    O_o3vCCV3ija}+V~@Y2p#t=Aj"}ZJ>:17ArBx3?ADEDl3JXi*{[kvk~RJ5Dg}J271>1zD-!z^j{x
    P$%[D!ElrzI}Y'$?<+!^^AsVQ3K9iO^e0a=Z_}J-!\_721uo;x<lB8AjC'Psv5=%mj;CrGQ#Z5nl
    1Hnw,{+_ir3~3n]X^Q*#l1i#DexrEor<l35?%HT\Z63O?xJRAI)!1<lbr!*_"X--loC<Q7GYl[Bi
    [1Y-;Dli-7BwK<wCW=o=[b&F"'Ipo^_TX1O*aW*x2+v>TozsIIzv5i-UJI,CGJ{G;LxlE#)=7<wq
    E}xAf>'xCF}wrk/2T{#!};k*7-K2s1V_@}XTCwG?D[=1>Z#Fk,w*fWH'$}_!*-Em,_$!\iTHJU<7
    [vJz~')$7}x*vO=oaAR=uU=?U,YI{!r-_Ama=>J[vJIa.WIIuDGJV^~Z'rrAl6oizHi_<$.@,2\Y
    O<uR\=5Ym_a^ln7y&;s{ePCarz*$iK>A~+I>2-#o1rGmRKVXO,pGj,ro-v=a>oWC*BTOimB?GRKH
    X{u}:n\<G"YAJrnOX<w+^E~>E1FYx?w%^}m,3Vaz}U[~HEuECJJGoACYSOdeU3DgQ-JY--^=xa7s
    RPr_JoqG2V^4JUAeB,H5B@W5_i^zYC+o|UB3A3(_ZuDyDB~}_HR$=5nrnD>G-H~^Y3TI5#~xe52p
    aT[#4}BXEj{K*E~;[8i-w]BX2n#$]Ja'~GopO!<<EeT7pE^v,nw\RY$.i^u_\t7?@w#*KTA\#@KY
    Unj#TJ!Dk}^~JA]!<;Q\B1&Zl>BvWnAfeJr\I3a3Z$2nx>1umTpY@}$U=i+J{TW{;s'OBB@^#oB{
    \XHEi[*uIVX2D_K-5\s@H^<^HYkpYv]7+xQHP>1BY-w;-]}IkwDuugZe<D+7un}3T@r,ZUs_~',F
    op1AC=#X}Bw@\mKjw}v5+7,au[[KO05'@ryF-e2nX$!jmn<~Yl}j5~Y]'lG]3-K[ZQU~5,uV"1mB
    2R'X@CO=',k5xIFyw1IU[Cw[^+A<#a!-V]=2vQ$vQmzU>_-]r,+=1VvK8'!EEv<m>]K{D+5j3nl?
    vv>Zr>\n5ao$IDAJ{A[,W#xH$Ta+VYapvlrC>{V_uVi_;=<3v,GsTC,DjZDI[0i<}G^;2^=5_7h<
    H]zQf*o]zIaxK@rQO";UTsj'ssYpo]+7j165o$]u\~EKCzZ;nC'ekB]j'uK{^;Havu!'_'l$~<1?
    e~j-A1]jB={!l*[=RXmKBa[*mVYwXjW%YH{;Di]WzlQ*z~2efBl?e7*ln0~TTr;v<=5KJ?u6*d"]
    5ATx3,Gr@',[R7VCV}2z-W-I_<R~RK]e,Vo5v3{&UC'ovm}Wk<Y5rBlQvkI*x8ul${,mgsz3ouj<
    n$IiDDEH*'BH@oYBBTAUn!AVj3lHo2rjvs>v$_Yim#*u}?E1JJIAs%~s~{pxVK}WQoq\5Ua7+7}j
    3O7~_<'xwH~1rXWToj<{,3>1ZA3UYAYH>x2S5nxvuTO[Ux!s<Qj!Vo~+CjZzA^ZKG!\m'K+<o}s5
    ?HQ@DK,Doj5x=EzzqG#psC5-+<oXnG^]r4P%FD!pGCiTDH{Tvb}^uCUXe@D5!kx*V]MQRn{27Y?Z
    sTklC;lGQHzOx$2|fZj\Zuz|[V=u[I1]_pnoQw2RwTXKR#'Js@=\1GWKZ5zWwjm+o)5]BJmTYDj*
    DwNWH13RKJW~COivKXHIGGj\{Tv7{21]Eaz[$UE]#{#~IJ^[*2-2G7lrX2T=ao-wO}vnX5?4![[E
    t1al<=}KQR=sW_1Q3(<UBveKUzKv,!]3;AmE!VATaUU[2Wu};GHnR,as#ad{AEUHHO^]BQVz?1:7
    vYxa'H>j}5Gjz*\_w{w]\;k{B<J-{<!&{1C}qZs+@1;w^3z=*-AW[^^^;AEWna{oasempGI<rk}a
    -![*5C#;Zu$7siaC>{<s~rjA,bsTv^oTO@iUZ#7I5@xmz\l>CQHvj\lW@[\kQn{U=xV?mZ}]'+Kj
    QE>,zpAlDux~Bxo{*57H2v:8[xZaD|WD\n<X\jkB]whA_u]Da}mE@Jz2U<DOm{]CZHAAOea$+O1B
    @nw+sRwRrIn*jaYyR$akv!Dm}_nx1BAoc7L@Qk_53]Z$n1XR[\,D3Y~O"m*?351no*sp^oG?G=$E
    RI\I{S[^X]v)e+p}X-{30@7=@\KD;#ETuTaQoAQJpH-m#,A<'}={[m'1*3+2_}o}~E<rZ=Y}HGw~
    CVX7}uD#IEI[<hsTU7pEw3kaEp)v0[GprCZQeivw,!B7I~xDlnU5rKwQEJ'+7~T-vgewa$)%YUx<
    pW5$Apk#UsDzUY_}uhE#*GX>In1Cw!oJV>u]7k%xnIpGJpO*BoBY3-D#zA<[DA\Px=e*R=A>io7J
    [D]D+E}JY@>1o#OB*pYB'vC^^+WXA7>]}/+sol^EuI[RB*kjWeGHx[RA>EN{sEkF1;^i}Hx\&]WR
    I]UAYV*3*R,A?)o;l_Nlzj,*5x,Y2!K%C[-#F#rGnR#vE_77':_7)::oJj3=-Ar5E=>Rz~1Bj7s;
    r,,e-la<B{o@[1[Y[*$Wp~l^spWQj5K#E!Zo*j{QW>EUvRQ[_~r?,7<O@<K]>!K+jH_$pAV?B3Q>
    wJY+lo7R1Q77$Y}~w,x#+_#;Q\z;Qm*j22;],E?ssv__xVsk*Z^s{*\62TQelTo~3E<[C$j}XO$X
    v;*X}nvZ$;mTn],ev~HQ^1IY$nY$C;Vop,\Dg*u$nK{<GZ\YZo!$vx;jT,@El#j+VW=>Vd}w[EIC
    pV/xmGi_22r~\;uClTBC{@s*R@O=C}ECr;U[;s?[$A}V;VI{XDiew^73aE#Hz~[KVAauL-E#<io8
    I>2s75irPWC+p!oa
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#Q*;,>Xa]vH~o_QYeiEDuj@Z[e__VOe>z7@[ei9"[xuK>7UD7v;TrTQi)mI@o{Q<^7,?YG53
    {~]Hu$--s~{BBY6+1$'Q,AmOoXA31,['>Kj^-1V-p~]w-~@'2;Oe*rm|"#=QR}y5sR<V<+;eC$*1
    Y+wv>RA}Au2=D2\12_n'EU}&_1TDW]Ae61<mOZR<w&@o[=xa}I<Yj?*VzrP_AX}F[i;ZrGVXv2~s
    AE^2AR_x6x_I~aswsUUz7z$TB[~R7|EK><1G+]Dj}mg~$nX-6[OTA*{\s2w^K{UT-;tQJ[~qAE?Z
    _<7rs^#V}A-BpxD<e,~$@j,T7Aj!'AR#5n~Zl>2Tij!Wy;pU~(^+A2T7^}JTQ@[1H@$<-3Q-EHhV
    2~$JI1a.2w7a[@{JHap<j5X~x;'z#R*Jv;qj-{*!wwe}}^R'j#]13W]zr[]?rlO,R!THew<v!\Q<
    vO',<UJKaw}OmalXhguDwuW}J-HT<JL}emwr,V5xTwup?YocE7w$z_@]-7R@TVCr~=K-in$3<AVB
    ZD*O*ZOnop#x1faX82=zGJ]_K!Xfj-$]to-Vi6!\@{lJRTH5Wuvb5un+kpI$e7
`endprotected
//pragma protect end
`undef IP_UUID
`undef IP_NAME_CONCAT
`undef IP_MODULE_NAME
