//////////////////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      Top IP Module = efx_csi2_tx
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***************************************************************************************
// Vesion  : 1.00
// Time    : Thu Jun  5 09:44:30 2025
// ***************************************************************************************

`define IP_UUID _csi2tx250605
`define IP_NAME_CONCAT(a,b) a``b
`define IP_MODULE_NAME(name) `IP_NAME_CONCAT(name,`IP_UUID)
`timescale 1 ns / 1 ps
module efx_csi2_tx_modelsim #(
    parameter tLPX_NS = 50,
    parameter tINIT_NS = 100000,
    parameter tINIT_SKEWCAL_NS = 100000,
    parameter tLP_EXIT_NS = 100,
    parameter tCLK_ZERO_NS = 262,
    parameter tCLK_TRAIL_NS = 60,
    parameter tCLK_POST_NS = 60,
    parameter tCLK_PRE_NS = 10,
    parameter tCLK_PREPARE_NS = 38,
    parameter tHS_PREPARE_NS = 40,
    parameter tWAKEUP_NS = 1000,
    parameter tHS_EXIT_NS = 100,
    parameter tHS_ZERO_NS = 105,
    parameter tHS_TRAIL_NS = 60,
    parameter NUM_DATA_LANE = 4,
    parameter HS_BYTECLK_MHZ = 187,
    parameter CLOCK_FREQ_MHZ = 100,
    parameter DPHY_CLOCK_MODE = "Continuous", 
    parameter PACK_TYPE = 4'b1111,
    parameter PIXEL_FIFO_DEPTH = 2048,  
    parameter ENABLE_VCX = 0,
    parameter FRAME_MODE = "GENERIC",    
    parameter ASYNC_STAGE = 2
)(
    input logic           reset_n,
    input logic           clk,				
    input logic           reset_byte_HS_n,
    input logic           clk_byte_HS,
    input logic           reset_pixel_n,
    input logic           clk_pixel,
	output logic          Tx_LP_CLK_P,
	output logic          Tx_LP_CLK_P_OE,
	output logic          Tx_LP_CLK_N,
	output logic          Tx_LP_CLK_N_OE,
	output logic [7:0]    Tx_HS_C,
	output logic          Tx_HS_enable_C,
    output logic [NUM_DATA_LANE-1:0]         Tx_LP_D_P,
    output logic [NUM_DATA_LANE-1:0]         Tx_LP_D_P_OE,
	output logic [NUM_DATA_LANE-1:0]         Tx_LP_D_N,
    output logic [NUM_DATA_LANE-1:0]         Tx_LP_D_N_OE,
	output logic [7:0]                       Tx_HS_D_0,
	output logic [7:0]                       Tx_HS_D_1,
	output logic [7:0]                       Tx_HS_D_2,
	output logic [7:0]                       Tx_HS_D_3,
	output logic [7:0]                       Tx_HS_D_4,
	output logic [7:0]                       Tx_HS_D_5,
	output logic [7:0]                       Tx_HS_D_6,
	output logic [7:0]                       Tx_HS_D_7,
	output logic [NUM_DATA_LANE-1:0]         Tx_HS_enable_D,
    input  logic          axi_clk,
    input  logic          axi_reset_n,
    input  logic   [5:0]  axi_awaddr,
    input  logic          axi_awvalid,
    output logic          axi_awready,
    input  logic   [31:0] axi_wdata,
    input  logic          axi_wvalid,
    output logic          axi_wready,
    output logic          axi_bvalid,
    input  logic          axi_bready,
    input  logic   [5:0]  axi_araddr,
    input  logic          axi_arvalid,
    output logic          axi_arready,
    output logic   [31:0] axi_rdata,
    output logic          axi_rvalid,
    input                 axi_rready,
    input logic           hsync_vc0,
    input logic           hsync_vc1,
    input logic           hsync_vc2,
    input logic           hsync_vc3,
    input logic           vsync_vc0,
    input logic           vsync_vc1,
    input logic           vsync_vc2,
    input logic           vsync_vc3,
    input logic           hsync_vc4,
    input logic           hsync_vc5,
    input logic           hsync_vc6,
    input logic           hsync_vc7,
    input logic           hsync_vc8,
    input logic           hsync_vc9,
    input logic           hsync_vc10,
    input logic           hsync_vc11,
    input logic           hsync_vc12,
    input logic           hsync_vc13,
    input logic           hsync_vc14,
    input logic           hsync_vc15,
    input logic           vsync_vc4,
    input logic           vsync_vc5,
    input logic           vsync_vc6,
    input logic           vsync_vc7,
    input logic           vsync_vc8,
    input logic           vsync_vc9,
    input logic           vsync_vc10,
    input logic           vsync_vc11,
    input logic           vsync_vc12,
    input logic           vsync_vc13,
    input logic           vsync_vc14,
    input logic           vsync_vc15,
    input logic [5:0]     datatype,   
    input logic [63:0]    pixel_data,
    input logic           pixel_data_valid,
    input logic [15:0]    haddr,   
    input logic [15:0]    line_num,
    input logic [15:0]    frame_num,
`ifdef MIPI_CSI2_TX_DEBUG
    input  logic [31:0]   mipi_debug_in,
    output logic [31:0]   mipi_debug_out,
`endif
    output logic          irq
);
//pragma protect
//pragma protect begin
`protected

    MTI!#*+,A<,>KIpZkVG-Al>[EDvm^7YTpqiaT[B4M7?YI#}?zp>A??lx!UYA<]c]BCz~5'nGDWeR
    QKOZ$a@7Q-Xj@;$O7eis']Xpmp=zWa;aI\rN@wzrp~Vo7J>svzil@]ATr#[Yi5spTQw3Z+li7p,o
    7Ae?1DX-E+=Ad->@Qj,DTqR#Q,BuX*W}A;]\#pmnmOF$HVp:E<pE;1lH77I3.RA}<HGJ#s{v3CR3
    uaoliTD-Ttx5X*8QerDel5$-*WH_]+2\EYoQ!@@k]U\x}WOrmasv]wraXz?*T@<#5{]=j>ma{OOz
    e@VIuR\=-o$Il>Vzl+koH*i{]*YFuxxX=?\R1sVTp>'v}?B<e\jZ_T+}_{TaT'+$'m[?Pp2<5HGi
    ,Yl1[tk}R['~7Kd3j;j}HRXZTyY1<#,_{C(Q~K'5Kj}5G#aO^O]on=G(,vp~=@_>3nK;M{*J$-$;
    nuEHav!!{HE\<p$]~{1nj3UJTxeiWwvs@P'wGHoC;;-TAI=OWl=YIr%]=CJuH[~aS'a5D?aI]~s[
    UnjaUQ@J@5'}vr5[w@AnkTX@Vl+r*pUYRw1E7-R;n?\T}7Wu?BYCo7k$uQZ5G#En{)(v;[WJ{H*^
    <2rBiT]A<+Bz1io3xB,;o@!v>GuvJa\L3HKxQ=;a37k*Cz*o$^+WW*R}ZY;n?^1V+C^,0vHoQCv+
    3u$5]Q;r;\vO7:r~,;}}mr+XvvBAR;$eBZ$Dizx*-$=!Q}uE\Ei7T=@}UVUjn;Yf$=x@I#j1(?j]
    G2*aY"@<XG:i$nYR+<]^{U!b0kE]aIOKnvmUsOz*m~oIRZXIpDHn+94$aE]dW[vI_v\<^-7V%@+&
    DiY_pxC[(l_Y]8>BY#yRz]slR^pe\BR_R1A/|lW\HuvTk*+}7}wY7Q*T!iU+e^K+u2+mQlkVn?vU
    WD[B*#OW]E$mn>$Xx>QKsjU1\!$BZK7$i#R7[}Z[?-jE-QazG0*zv}O=l;E;+V9WU,U2OU3GQ[#K
    D7i=pkkyG{!1GK=;57{ElWenOQ?1x1}eviXAB,'Q}-vZ*JT\w^uT=s\Kxv*i5J>*j}rw.;rR75\a
    KpInaLI8~aG@@T-ujin^KCo+E_?;CHo735RUF'>@G}lY$%^3~H$DwE}*QuZGHo#YHTp=ACH^pJ*D
    @Vq*[@elGTDB[v;x?=D21eV-BV;Wwj!E;UGsu=Q7H*A?}Gan7[#gVKxu|\*$IR$}U#HDB,~;BTw'
    ?KUBz{_?-%xa[V-{22^~KJ27r*f}CVR#'+lVsH_BG7[to6e!}=[2]nZE*Z\CE#-}W\kRn;uzrek]
    ,-Co^}!EQ#ZwQQ}wZ<qj'JmwRKeB^Js(mTe*W\Wko^w$DCeQMr,Z[=rvZHnDG;wDr5mVs[^{>vD3
    soCTJvG=]jm^'n_i]*2_e*lVQU}**BIkvt,B#j8e1k]h0{RI7N@nW[E=Wv)vz=Qk$D,|9pZ*$Cm3
    EF<BYxl{XRH,@+ZD2<5_j$}^a!R[7@E-7<+[}WwHTw2D,rkD#!G@HDvm$-r-,]Tvp]2E=][+XUA+
    <75$JC;QHQ3-<UCZm{GJOe(l}k]Y!I>rr*Y[+FH$^ox@K1]Bs<?w\KI$X}iIG$_l!1,~-v@Os<R-
    KR/O1*J[CvKW1po5<!~i9Q!XJl*ODE,x=~HGw=*RndQDaOUR]mkYE'EB?m[-j27\3@iVmIX}D5KS
    n<JCh~GXY{^o[,1n-D'ixq1=sYU5iIw_lll}lZ^++JO$uZf{+@~^Q[]'}sneosWO;H$}#3y0K>o;
    B'w>JsawjAZW>UDO^CA=;wCk%br[p}>-W~'?m<B=G7!<UvFUxvR-X~Z'o@ZlmnDo?[l?CZG#[Zp+
    |*;[$L\1kwOEH-n{j}=>~QR^*x]rsQ=-5@Rk<A[^n>}v,]z2_s5E+'*RmsRGY^MZ5W=*OU~^<Gp^
    O=G;*A@>7w@{}a_w-JEFGEZ[RD$^odIu;pCH>uZV~$eaYxrj5X1<^B@D<+a5-T\m!CEU1e=s+]BK
    >s,^CKHO$3+^K?<7maeinm;Yi-a]#?^wKr2sG~,@Ua5~5zxr$O;_B}J]^\%@1>k7JeeDw+5''UZw
    7_prR]<-H$T^;*-nI7Ym_?H['*Vk'^Cx_vaD\}+s*DGOnY3E\<=O$RKs@Ci]i{3@v}3R@'iS?{*^
    ?n[n$7#Tp-5e)Mx**-#{\_YkDUIu*7]GXHaEQUQD1$n^+@R+,Y(ka$Wa+TJ.ru73i_7<jriE!{CC
    47Q<J>xpo(<_i@~*=}ZQRBV}<!-+}E.,zj?a}H+w+ju!wZ>*wR'Q_mrEe@{wUo+<rIG4AxYmcZVU
    W]KJuRfoQ723H;x]D2uo}B<oORJGlZ1@^m25}[esxeTE+7a'GZ,x{U,y<Yj{vEE=^,5m=wC_s5D$
    yV{\v[Jz?,aeOm}=2eBIrwAX][I],p+7}RK<2mlw\m6x{<G6[awHRj\$Q2E_;p,1J,7TK-,Zje7V
    %,C!TviXrO+WoPez!'EH=xDP&pk^E2QmQ;YIv+eQQTp{e25ZWD\m@}HHV!HeTs=eaWw=3~<bnsjX
    0qk<{^G#K\KY*>,#7*p'RTlwZ_-Dnv!CoCuX5@jelw=2n1Uv>JuX$AvlnsTBH+IUJ+^$QC5J]RBC
    wl2>CJt?1YviR_3<[-oU=n*=QR\I[<WHGzX_X-GRjO=\+r#v'CW<^[5BlJ+mlREK-}RVA^VuV{D,
    :j]s>eY3@vw2~ln>;3'aHi_[$BYW+x>VR<7Vsp2>j]W}+I<5ss[]eD#nW{eBBe\@xHU<w[DK'G>l
    7lVKsKs,@]?<^{j3JBVXnuYBo\UHT{Ixxm[VQcI3=j~r+^;eIDc*?m-\RxJnSCpvTZz}CuY<D_-$
    *H<zx^[QOnr5sEw-3QK;j_5RGe7\V++BQjBYsKHxiKT3$nQ@Kn+1\QinWk<!'T<a*E\$D]Tm3\<O
    IpECA|~AuUNE7IC$2Yn3^E^BoB><aZlTGKI1mHu9K[VG^<l7<C!>IR!v'\~25JuY>Gx3;rjus*G3
    jka~r$C>1?K!\ZCE5#B7GEolG_=zi*Yu^>EYQsYx>oepsZJ7!X!2YK]Y,O=a7@HO=@nBfHX9sU\<
    K}wz_Q<@rDRD73[;*elYr>G5]=Bk*yz{$s^@VplXU};RIuIZv;Sa|#}AuRIYnE;l-sO[{^zY5T*7
    p-rJxi*a-xU\J^zom_O,D=J{eW$Ou'zr3[vD{*;pIOIWaa}euIm3T=4rD+{pJTn-5_uMNj?@HoDH
    Q,7
`endprotected
//pragma protect end
//pragma protect
//pragma protect begin
`protected

    MTI!#J[!rOCY;,O[;Kw_i']R^5j>xD]l2{Xz5}?-D,=k7,]+avf7xR2?ouReUd:DZH$}nR*yeVfm
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

    MTI!##jR?HaCsi$KV{'s3Ba+2\3nW[-'_!7+I""}4["i$e}m=x+>H3rI[9:kB+oXzal7x#sB2WX;
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

    MTI!#*oY'r#2>%8;&Jwr5I]aQ!'$=EK[n1CoihAD$[^i~Y7m_U;52ejv#oqV#@7pp_V~Uz-QD3ml
    Q-MX<+2U{){Ck;G$k\s{ErsSKwJUz^;}MJ'+H1vHa0xzuR!{H2H_zo<{O^0"Q!{w$*,iY;=B|mTA
    [vZJ7DZA[]Jr=rv3<N2C@[3(*@K>t,se$]<[D;oB7&7Q]7x<UB=\AAe'v,~H*3$B@3KpDarm_{bJ
    Y7x=5HQl^zkGDo;RzA\T_YRzRin5=zIyK6}?G-eJ*5h=wY~*$ZJ&sz{r]l[i;jeV]2T#,V1<UIe]
    'r7BJ}'1C$oBqIRO2]WYA;o[By}J[Dxr}l|@5D7dZe+2@7wrxxrnKwr7esk_<l]r[,,zIuC#s$Xu
    pl\$exiozxx~jQzi'A}_,W^JlV]}Qo2pY?Cvcm{X]1xZ!0;{uIhnjuV=lU?~UZQHYrjSqwsz]p~+
    #B!\zy1#{vWIGn'4CTn5RZ-\6CWZX]NO^7QY-Y^G1$-skGlHrzU^~B*,>OVJ51sQuX~emAIXGxYz
    <j[B$I}]uzVu+{EV>)vUG!9dRCv^l;Bo75k2ReY?KvR[R_vA!r1xGYow\+'Qrov@*_Dxs]e#HDu2
    7va\=\<lU1ia''77bC#jopI<E'2Ya1puC_A>-sY{JU<Q{maC?ZIi]GR@V-CGs$,xn$B2T#r7;Bce
    TXD^^,*qVEpOBZ*G~eW!DVZu&O;,[R~sR21RY_UX$i]_YvAnsoH11-=]7opv]<5Hjr'R'OE5AU]'
    __R>u^u5$O},r\~a]w_IUo}<o@aB;i[bpw3CEpTH{j-#)B_$~pA-<UDxxUH1[Ip!r_pA?IU;2,,l
    -wrk;a'XXb$^B!Ue-sBuY5q{r]7-rZ[[;<@kUvR_^jG~EQQVoeQ,';_<E?aUa_lOAWzJnW}fAUI*
    Y+\>l#OlI*O[NE@2BWH7ATa{eiDkUKa-~w[Vur}+-+R]<c=!+nj'jH3D7[1>w{x4jK^jHUxT1H<a
    ^O'}\BD[ce5+r7@*[r<p2B1XB.,Di^|5j?5V>TkjG~~}U{~IQvj1K,AvBp}YoOo]~j<2E+oIPI-]
    [jm[,!D,rC'O5YW*}v>WB&QCuwF-7UB~paG2X[^FA7wTjHw<62z[p+tbmIOi3]HJkB*7T5]k}3-@
    ^JoU^E<R2ouW7AK!vXJ$8Krux*K7@xrY;HDXeCi@*{n*^M,G}utGn^lU+QGQW<Gp^meGG=GdH_N}
    mpn\jD>'w-]IE1YweJGB#rCl2wvN*KX}l-[##eXQrQr$erv<sUQQ:a}]pr4,\k{-H$3~+<uhl4U^
    x<[VT@.Eu-2GJsZh?_}pL;1z+6,n]z+^Qw<{{<czR=[V<A_[sH7=nmv2rJ{\z!Y@vB$1BaDMI~+#
    X^GmeYAWrX~lc*K1VJ**AkV+{-YH'DlVD-E=iyl{JVq]Qr1'2*=wQz~G3T?pnJ!$ilOoOk[B5x[k
    {O\sJB2O2Wu@je_Yiakr]J#[#O,]eAxTp>=?>Y7f^dv\z!]*r?X>mY}ngDVauIBQ#8zGX7*Wal?D
    [n\VYzjnGTyN]>J;|==pz:HHjTBiTX]rj~*&15vCTOwY{V_$z?-$=5V18_r=K*O>_C?V~@Bz-2o7
    _QU@3vA(h!\JX:n{K\_a3uHxiKEG!$%Lol<\w^;zrG*^$ep5#=nQij}@o@K}'Hxi']',2Cgo\AlY
    2[vN'J{mT5QmYZro?DkIo>Gl2Y>$M*DDpUV3!@Dk-WE5U[3D_ra-jHY*7SnUJ[pu=_@[u!v2@mV$
    X-)6-s'e~Uv-Qa=al7}ILKC~e$UUaUV1>yn11i-Gx#i-\luUGBa*iD]VkaI7@HLYjD5I}1[pV1~o
    u!D_7_JHG>2V?pprn1_};@B5R~,RVUop>\pI{*@p#W-v+3U1w@BdB_VVHCoxXr'zQQ<pH=YCrTrJ
    N-jj[bnrC1s<AZ_}KE!ji!*H]o/n<{3%a+-I+D{EvzG~e2HDIVrW,!{ZC7Q~WH-~HEi=~j_$'?HK
    wCL!{AXyiU;=W\u7MJ'Ei?w;J\uWlqY]p+M]a5vB2DsUN>w!rfjmo{BWZwv;o>.U<T7Jnrupj3wu
    A$=UGa2<_>VnVV7eek=-x^j_sux\$A]#aHHsx<G?.<H\{xv7EG~p=sT1sZYs-'@35Ie5rTzk[V\p
    5%$zim#lJ2V'#E<Yln;vr9VUXZBGKQZe'-\wJ5$BH-jQw}Y#@ut{a}Zr*zxNoBGOleBW;<]@SWLY
    -Iin>$+5pXUO7m[*R}?[Eu!-=T{3}?*/_snDYY-ojlAO~oY@VDW70wEI!]Z7;ravG+Dixc_s#kvX
    K'j?[;'pU@[YX~v?JJU'rvYYWV'Z<1x+12aUw5UQnIX{uwIeA-E+zBpXCz}^u]aX]#!ID@Rm~_eG
    '1N,#~r~a~?[A[\9%'1<xwn1u^m^D,E{R->vQQ=ieGBQ27}UB[?_*u1>V$2,eI[[EAoXW60,3^XK
    n_5}5^_:GYmKHRA=3[a2-YJzS_^Xu,naXHD$Tuv??U_,}conJ+Ld!YRa:$|{--U'7E}|InW?Y}*m
    lk~jvo^B$BUx[\k?oiaa3O7?,Xu2ioAD.i=$$[B$D[BZs3H\C>7wa+j!{s?>2erv[E5slaYG=$>H
    $YCQV5XjCE!,BX';vD@\li'J7R2p]|}vJ5<Blu~{5__Im?OeH}oxs?rj*J[+XK=J=-Ow~Y\o{~DV
    UK_2=)ARolP_iDTpW;2:CnlTU*wReOsEI!zmOGXrBU>}1QeiFDrmYkwH]A^CX7w5i3pvB",,JX1*
    U3Io+EH5ZY#$<Z&GAOxn_BHOa7-u\@2cIJo>IHZ]xp,^,}>V2Cp]aE-asx<*p~zmYpovvODTQ5T{
    B$='>wp~B7}s'X[EKXaZBXBezAn7V[7ZbC*k@]l<z5Nr!nOi=^'#TjT;'1lO5;GbYCkOI!wK7uIQ
    ']5T3luny*UHo1zTV.=5}kFj/klpzB\nvQPs>!AW{I{]xBjr'u7aVKEx-Tp_L#>uOmUI*iBs@R<e
    [U-olG+_\'A>[G@E+w^Ju];Bp@sr!25KC${Z?.'i,=l\*r)zmxp+xlQ$O;}=HV~2R@oQ_G*5G'@l
    #zG|[@,aEZ'\i>uvHU=Z,7B1nnuAX<;EuHzk=1enu[su~+-!A,5Dlzm5xV$^,BXe7ls=Y],^UY@n
    Bor[YvDakAjUp!5DDi^D?>\Cx$z5?o@sB~AOU{Qmnw\^p\>$pAHlG;In\COH*_apbFr$1B1n@rr6
    5J5-P&IKnpEe}J3^_,YzpaxHok\sXs_wZ^C{KX@_-B5KW]JX7wq(upoKwrz'T]p,_xnYROs}nYnU
    HHJ,'Y+[][;=_E1n7e#>C>xZzY\D[j2sl!QH-nn3Q}r}{+OX*Q$$2Il2KBe[DnUI*cCT+C;pwj;v
    pRMr[T@'=BXJ1<z}Ux+nw3Wj}JuHV5=IKx_T+*3Ue']ioIkUlH~r5+s;nV@E1]n2rkWr~7<G5llY
    ;D}4MmA>~*]j$#wAwr=T}O>x,5kozCpm+;Qw]cBl>[(Cs=_HOXB,5vCW_r-7DBTraw{Cv;<[],'u
    p<TX*[s717rETu]TGoAEnw$ooxunD<CAa}O>SzJ[W_,V?rn\nzV<'xH3lZ};XUQ,sG'Uuv5@}VEe
    HAvp!na+*1OclaT!iQ1Bx[_!wD2?DO>3<$O[so^rHBXXTs)(%jZ1_{As]Rk*[^v<OB[*a2SeE$;E
    U3oRx{Ow-aeV-l]e{_p.xnC}p~8Q+xrZOeI1zK]d_f>^v+;j{Gr[{}[aXpm-wETEn=z>!nF\+*H}
    5Y_r*YBZ1?O,'lj[{UJ'BJJiU{Ch@*?YDkpp7\Ij$ODHVp5$_K]BcsRQoZ,eU5!U}[5ir]!vn35j
    C
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#B#~XMu>pKZ5K?.gd}i_--OI*_+vOBTr[l~*V|QKFIGWO$xj2G?$xQ_<TGY,;^;O$=!*=dw}
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

    MTI!#H*7vavOnK7ErC?QT?TxpN$*lA>DIG{}u[^#ADNYWV57@5[r[2+49UEq!B#wAG-@<'?2!$;J
    yA7#H#Ull!r#~$!RVN^,]Eemp[KwJUz^;}MJ'+H1vH50xzaR!{H2H_zo<{O^0[;ouXr}x}!-zTS,
    +Q\y>>WaC0]Jr=rv3<N2C@[3(*@K>t1_\eY7is2YI1#5iE3+!u!{=7$B*QO=Q>si\]O=@*2]THuD
    @Oh?-'Eo=3Ec>=$]L~j\u[7I#9Jsr\VIXRO1DarWz7_o>;}JrrVz]'oGl;;5}nR\AkG~[*Ao,G=x
    *xNYImu~*=!RZz3$~pZezv_Pf6\Y2rUaA}CT9!Yi\!RIuQQev;=}i$za7msG#iopshn_k[PmBBO-
    1j>kav')73z,5Trn\@T,3DY[$VuX2R1vK<4}IW3!*uC&zzl@t.kERX<\TJ^o{WCBs<@zE@!T\2Xj
    7TeTw7l\u'us\ln1{B3op^Y.UlOz[15x617vaLNJsWx2+{u$AHXVlA,Zw*$7wI773Gne\Dv[z-2l
    YG$*$oTpZ$+dI+<[F[um\i+Xp{I3!vgZU>UOxK2.PE7,Jz]E=R<,iH_7HRraC2$QH!EX-7>2s}D-
    9)Q_,IHGnW1U5Ut,*XugBzB@E*]eir#79w>W,RGiVg/(Orej<TYaZO-,xYkBvi^+Tor?:rF#r?*d
    3lA_HX}$$'xoC~Zm-vx[YBKo'HV<,3KT_!Q-!nK3XN7TY*ya+Kaj\3Z&D#AGUaoRY3Bj<VQ{=2AT
    avvrwO[<tH$wep+VAv2xKYv<X[UU7EzH$#wGI[DTVYO?-}Z5;1Gr<-Uo22v<*K+j7E5mxj+mOalm
    v}CKkQ?<;o@<E{[sW'~7{-_7lkT<?7,Ax=[ou;<}2Gm-ksj@ZREe],?HW_*G1sa$kuE$[NIoTz$~
    @Z{jpzvnY@V=l_$aoV5mIH,(ps>s$Hv5*iXxATT_/3-o[xpCT\zs-X7+WKV+[FEaK{!'+EusXo5R
    {2Nio1[rnH{~[BD~HZep;pIO,Z<n^Y37lE1\QCXAaB2l1Z}2[VCpv{,?o,Db@Q#s~8^{s#:*Ds!z
    3lp.vBj-_a=i~\V*2&*X,7kXrOE>Eo=T!<}D'Yx)oB=W1aJ+l;\$,[p?5cp^^rUO7~E{}$1;73oA
    T$|!1!sG3KIT$pD@<l7B>_W<s-mBVwZOaZ=I+\k[am7EY]7,$Rs-^eW.|Y@j}$Ye{UVIp;=+HMQj
    T[{{w2re<{OT++DGB^*}zm72Ru}T1a53(KDRm^KH]j$lQ+TrEtOV+DAEzup[E\o!JHPCJ{CT=mr\
    C*#&jW~<H$}w{>KkCej,eEmsnqGl-TowWD3l*^p${51AU[KI*]W*mrA'p1+a\pV~UHh,WJJ<>v=8
    7;7Vo*?\i}1pV%?jk[_U,[CxJu>*_!xo{[R+>EZeR7lQju#]K{jOG#{+RG^o!T{_rR5^w~+OHbvw
    vV}kC^B!5Q]2AoOxI}71;~3sk=yIarHEGOZ;njGQ>,AX{XJ;'WoImwj27ja5XEsDY*\*Dw_o$?As
    D<lY]Iv@E#IEn-32s3~ZIv]RZnwx@\u$>@IUR=lO+-;v)KG$TQ;WZ$3OVJpY$)oEm*o#UlaXA^-Y
    -!}C#1,RIwRw>pI{\k1_D7EjQn#_^iGOBon'r'Tr7Yh{5YC@jRwKAT{^-,Ea+u~}>ARyX]E!HG?k
    el>O~HpTDDa'3ABJ4ZQn#_xX?+or}Mk}]AN-X^Yz,pZ.@A+j[OC>BoDvgJs>CX=uD}pX{i7Z7Kx-
    IT\'o3{;QKB#kU>vp1.Q7~oe2UmQGUe:-o$*aeu<Y<>TJ[5{<'!}#CmXo5E,.z?IG,^?}xvOTMxv
    ajBR^s\vX7vn~ujzQ@}XD[D-=nujj^kliuCQ=?_BKexJpmooz1*<[;*-<J!YZkDHa~{z{5A_$!G5
    1asx27d[?KszET'zZYkcyn=BmC;JIpDZVAH@^W<@}K9o[j*DXo+#{AuGY\^'*~3A=>{BBAY)C_#n
    H\Y21#ww5DV'^K+Y1pQlo5~^rXxVV[olae#kQQ>!\Xe1|53CYUAu+l}ap7-1AmV>>F$?wu|xY{3$
    }n^CJ,@H5;]2n]Zq7p_Wl{VJ)uC\;n]{l$1^;!_2>=oA1{7#~]e!B2'*wEnll,l=JE^uJ2BnEaG*
    3JonZ#nEkjw]Z^?p<C5]IQeJUY[Am'\YBn}oY$GZ3C<vaGnxre1{\T]15\TJ~YHr{]aaY6HYoC]{
    @W=~zsvuJ@1KZ!_mzHa$$lxsI{m5i'2+Z3Z&p<,rHz$^}@lZ2*C]XCK'Qv=uO{<?6\V]UTD)TwO'
    S5!{#D<enR_{?meU\nox+0zQe5/ljJ;ICW\_zOJz_jCi\@;RY$TCYmRCW!<GpK]r~TZ[Rl'U}[A&
    KAQ'!s<{eHOC@O<[.^n,YeUp2,]EJzM:4k>Ra*vB#noKZfDGm{xVAjnxXUoXa]E_=7-_iBk']}^o
    $^ua@=ow5EQRr*,p]-ql35vxIHoXzs!}HzJ\m~ExY*#[G~X?5BRQ+$<qHs]]7kYT{YD?wj2XrAWB
    I]<DE}CEv?CJmo_er?JBoR{7DvD#Y_W\>nnTW+@Ykz~{q@aCUda1\*HGaw7wp^!w-aEk>#d\^Aoz
    7HmD3O*072*2l*THo~]
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#BsJ3rIw<=BkZC@-DY1]s~*#k]zQ'_$~pFf^:[cyiYke;1@*XITITs#}l,?WO2E@W$RCi7_s
    25'TX7+2U{){Ck;G$k\s{ErsSKwJUz^;}MJ'+H1vH50xzuR!{H2H_zo<{O^0[;ouXr}x}!Az!SmT
    A[vZJ7DZA[]Jr=rv3<N2C@[3(*@W>bx_?=\<I}_'<uGrU=<=#A_Q{Rl5iVV~!=p\V?l?M}$sYn'[
    vXxuD-]-e^1_7'-E3Exkl5U}'~=!J|BC-Y-=D1QlW\C}zQ^u-+kV]r**A2D'+Rgp^B>Yp$nUEH<}
    C_2Z=p&W'^*HHTCFhM2T}^k=Vx[?=186Bm<Rm7#WQ2WC>j!#0v\EeX'EnW$11M[#C~]_z1xRZAR2
    (=#=j_Tn,(Tol~iD=KuB+EH=Q,w$J=cB$-3K-G_}5<jrevw=I]_pQBOv9jRxr7RO$QKpo|EPCQRU
    Zsm?<sTC[Es^{61WAV=#x*#He7rj%%r=G@@Hp=$1H1}_w?[5B@1,J_G~]XXr#=#vVonT!<i{12;&
    bbzrO-!T]BuD]ua7DmE7HZVtYKRvXX<~9'2Q]}nl5>5@plZ,RC-v^MIW.]X<B^M7<-;3$A#Aom>D
    He!bCV-wX{!>9{Q{CZ=7AYJ+GPXQ+~C2+#I~K^2$1#Xx;CxeXsB<'^m]Ap+]w]V1k-s*YWd\5vY$
    kOpR2*#Ww>-HQm3vlR]+vulRGr<HoI^ajlpkY\[W=^U1w3Iel^o=?Q<yTIK2fmQl-I{7rqGZ5!>9
    Ck[#Ir#K'z?!!xRA.Iz=]cQnOuMCEQpjmw,Ic,sG]&mU*QClpE{Y[~^r~j'Gl~WD$~1;;H$GBmAH
    RijXWp7_2,{rXeexu7B>pw7oU,mOja}We]o~5wDDR*ffCvJe!C=1lW}1Vx1}rumn{7?I)~']=H$7
    OQ3a}vk,xIi-+\nXGV2eT?[Q3:!wvjEn12^YD'l#>X3[Yp{7@AXN,>x],e5X#$?$zep}geRoYe]1
    GG#Vn]qCHr5$3Q1V~-C@er773WV=m\@@5*W^@C~xRD+Iu*!o1%l3\pYm=J7XDwjGVz,\r7E5'ReI
    B1RUUr(LG+zGnYBTCZKHK=sn_VlYGK[7>=[J'ODEUUJC0I]*H'C\!v#A!#IKprGCWkHC~}kj[w1[
    =>Au_=O!V?pso+V5B^RJ*-=I^kEo}]j!]BA5G>1D@B2_J*n!E;rew?]i_}t;Diw*1]m5$I[pQ-Rl
    35wB'$'~sE1y^IXTv='D5vXW=l]~:V_z<lOT*lEJQ+Xe>$-3C?1,nr#-5E?,~<X}<D<2W15DD<$;
    G0Be?s)=_{2X'kavC>\RJ=-ImU+e+Jan5zp)^5,<Cae+\3H2,,}[wI1iB^KIRalI0o=kD'$Awi7w
    zJIr<H6#1;B=JE3m{>7)#_?CrV-^QJ,^U*J!DC^W5{mTGWQ=3DRXEGTpW{]2<Ye#DJZ!o(pHr;-x
    ~!>D+jTaK['1ikVZ];;>*xj3\pe\HkAo=Ifnrk=JoQK8UeJ2!'nWpo#u,<G@xZI\UjO[>tI>Ewnp
    5r^T,aYl+Yt2a\HFDmEK(MDm@suIYx'{CaGV<r,pn7*%CW{C$_$T]w$1=H1IIw\HTYWxxAK^*WY1
    W=Rxr>^*@A=TEQGnvB{{-V^XBIK[v3lZa,!!}V+Zpmxi+<D$UNL"'CY+7m3ZoEp[IpRx~a)NI<wr
    PhRZQwWs;1?X^}=KJUekxe%jUUX-si7'v#O2=$IlluW;_R$uEDo">[,\U[iEh1^km{sE$\{DJe^8
    D^CXIU}^pR_KXrx}paZKZ$[mY/rQBxF2SuUYed-'UwxG,~eZZruYn5m}urR;v^_YsG^ZJ2H,lu*A
    v]jB\$ICp1G~1#Vn3Z-eYC]iO*RQ3\ju+@Rpw$wTYJ];Wn'EI3'#p1,R+CV3@?>rD^R?'#(%Krew
    OaCw{7Ks11-=7aZ{}@}x:YX}!sT!sz[CX5E{??n*z-<~+Anvs,z5psHsVvr>Y[D;l,#$Y'CV1_u2
    j,#$Dx-,~c8YG<G4UB-jkCKa9vQYY-l1QCac@zjlGnr7I,V.AnlDyg)'iD^OeG!-xxmJr3C1W1UH
    *k@=w<EpHKAKo\pe~;CZUj<k$-C,A}Dp}_@+nJXCkp7az$Q?RnWGQ=Vzk[xA5"GV{2i75<R#wlsK
    HX*e}KPxTGjFl>TJwUr*#SXO<O\+7-=KuuX-mw>Y*HYB$R{>p^{-Cr^!$xrH1Ib?+z'N:#TWI+eT
    loAaQall=V_{u.RkR[CJUxEn^\]-Br|m-J{-v#Gs**mNYk+16\E*weHlYr!Ae!xx+n55IO*JO)0l
    z$Hn5,H0uYkn7rzGJHx+}^Z*v[iD\Z+1$a<{!Y3,3$meZ\i'YxVuH$s~@1>>lVKa>r^K7a[wlRX^
    G{\nU(3>X5OV753a~R@'#?w&~Si+jvvG+O,7I\KDus*@3,$Qw~_QQB$Xr_C#C\~GUoE<<^?<w&[J
    W;<lr^Q#x[Cusp!wn\Ic)O-K<tM+ar-H{D<lA'-E~riAGvp-Qmj]xRHV~@pRn^p3[saG_]o<+^I>
    e'joJpD'nvJ<(DKJw,,,,}llRTp#,2x<7ap13=ow}L'[YRq?{mm=7^sEaDYEk_wgrYX@LeI_'7CU
    {]kwl>o[,K}e3+\@#j1a]Oev]]K@KwDI~<$nV-{*@\a3^{xu7'TZB{X{B$lK{@w}E2AEKI\~joz_
    aG]<1;8Z>[<io*$r1sTxJ-K9mTu2*A]~I_Gw-aT_#oD2-lXYXCs-L1!OC!^e2J73EYe[DaxZl=i~
    mTl_]]KrnAHJOgrzEZ-Cr{DrV]DIVozw}l9Y^$BUrR2{I7UkYrojC^V_+W[mRD2,evX9]_2sO[X!
    MP<HT2vI<QIZE,C#BRp\eDg[H+@AC[Orj@5(Y<UW#YT,@QC;moElIA1BmVe3Imerc7XG$*l[~BvC
    3esITos3E,H}5g$5QoO*<jUX=~p^XaoUJwBA+<Lur1?H*nxGUs-+nsz:^y{p+CG<1e'x]wUR;C{[
    XCUHj~wlu~wGjWP6;s-Ux?~e\kDp*1?nF-_J_!]21[V#{e7UG;}v'w13*rW}^_}p{Hp^{T_^eCp1
    ]1Oe'r{wlGD+p,_RB=RuUxTzYup+73'1k^^a@,;svC>\[m{>zqz+BmVa*ao,-aXQv=I;-llYGw{n
    xj=,Z]>^VV?T^3jwno}Z}K+XZk|*?\~Qi7,!<7oZ{Z,lp~C#Qer;HC+Q-{,5^V+^]$GOBi~;A>BH
    omTII!X'KJXIWv-ji,[l=v*^K@$mVZu$EwIsQxEBYx}%DaVeX+x]uUKl$^]2PIu\G7n13,[~KU5,
    G!jQY7Y'2%XB!@n]>]uX}_\vZUTrDD}C3=I.R#lJZ}aa7*+YZV~wz5z{U<REeiH!n]7XJOB3xuaV
    f_H2z,5jBN~V3U+Hsv}Bax*~G,Baa5?s3uLZaU\uUn}3CiTGk>^v62eo\'DGex!<{T\]+asCOBIp
    _r#]iUr^pOo_GN-xmK*_oUpi<{~r;Q_WBZ~H1+@Y$-vr1K@va?qX>sDlUD[qeCIQv?qIDTWXA!-}
    K!sc$-]>YzF.D^H]e*!YGZw'oT[1[Du5-O2vT}>DUe+Gpnx'+1k]}OGDkQ=G=rC<nA]AwY!oL'@J
    2LU11+O\\Objs='jXQI57kTmp\V_!>1nRpvkE+~[5Q1+*J@Vm-a~{HBsOD'Y$3p-e@XQZDC=EkVR
    pplV|;a-XIz3'<vKCR-H<RQZGYlT=!>>[DK2\\\w-z~KIWskv5!mT'z\j1x~>V7vnJD*IQUsk}OR
    {7s+#rTm[$iQ#_iAKViWrVUO3w\n7^j1DGi_,l1~!n5mE^a1m,Aj,3VZ\HEuV#VE{&|Zr?J*&?Au
    D$TuH#_^\J\@=;EB@&wz-e75DjqK+VG%RZ<]$U\oXBA#Ye-\3erIlj>nVu-o\~-\T]CxX*<*%5[X
    up_VUIW+]aVu_2D*;,!OHU>\VpVVH>UI2,p=OrvuEo=+5ysU_aij*i&wV_$77U<IT,n>7W<3<XK-
    EVxAO=pYU7~J\3TUa_i5-T1ZBvDDYZTI<5v==I$x]pXI7l-W$p*NU\Qu>e+DDsHKX5@U=rAzosTC
    QJpQs]^njioCv1_Zva2OC!JHKY]w~5XWCe-QIIxmB77G+O\3Q-[1~D>VA'#eG}$,:?A{]a_GelBj
    T3+Z2VEnBsCx*m]vH$UDJVEB2H=;a3U1I1vT1QDiD!'_on,HRj]^^J5\Wza_\^,?]}a,I{EuxEOi
    s-aDWzQ+T+,ZB1HTKH$Y^<}GWZjU'wjwuG_,ZOVAW<$Bjux.3QIOdjpDalTj#'{xeUj\Yo}oGtz~
    @w'UjQ.pi2?x~;]GlWH3ECHD>7K_,!>~5KBRw<1BAjj3]ROEZ@G8jEI=fjBrOEX'QV>R'-[XTrAa
    ]57o3KD_m/i\>J7IY\rR<YyDnoA71eD29_X^]-D+v_Z}$*HYn&c7*2[a'V=$='O0D{o*p4"\v{RG
    Uzk\nT\UVi7HrJau\#o>z{nS}77p|OuK+@nV[Vi
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#R:sRTVVAjoV2@}N1uj]"siX3]fr*?G7#B*g[)iV^afm[2\TV-#$B#X|ST'xT-a3a6<7x;Q+
    OJ<|OZz%lwJ#*+[[o_n=['CW!Ul$HUl=U7BvVO#$skUZ]R3TJh_p?~E.'H~K1\Vm|8Bi,B'3Wop?
    ]H?CAV@]=mnxrnT[xVI5,ZT*;[keZkwsQ'_ri}_UA^S<5^$@G-=}>*sI5k}jB]$+wYK'#sH?{T]m
    oVQoV#zoHBH$r}@!5z1G)3z[OBn<JBu*mWTo5R$oO\x#B*]D2F*$HO,,?=^Y]D4aGnZ*G!K1_GZY
    -~;Rnn<I?Br?jrp{XU#/".hQwQA/&WCQ77B'i5[DYBB#xc*ZDE2r$J{,{xOA}_^e^oIZGWVu,rIZ
    x^O$n#BH-B+{2?*?xv]GQ$jCkkZ=XuG]x]oGCwzu1^@xKlsQxw@wYJ}F[}oTulR5vJ{Z&I><aBjZ
    5yRQn3nCG$1!CwvXu}=?m;-nA[YJEJp0jVxiGV,Gow_I'Ez7e#B2xeGV12{,7_BnTe}}'msWQuV{
    V5?ZjAV<(Z'J!D1nAB@HJ7(Gz~jy{wru2]AV->B5V3J*#_s'UU@U[RD}e;=-j_GWEDQ@ioD3Y\!-
    'Xjsr}wYT'vb/^>CmQuaTB<{#~U5~2C<[[jiZUe@!sCv[5!72+IkB;}l@\j5zU*?eE?+{5>p;0Dm
    B<^<1YmRB'HCZ=_K_DFZH{kxr\W;]eu]%l?+5VKAKz!<G,$k-\-a^li@3}3OEvW3~1]I!XQu#,aA
    oQ2CuY$^+Pl+7l[GXwOD\iUrOuRA7JD*QO{oK{D_e!tln{uTv3D!77>)*T!?kTVO@sG[37*-oZa{
    e^}XUeuC<5r1C37j^_e@7T-<GCxik=C!_RG=omOTC_C$}SY@7iYjr>(%!v_~!E!\^uV-$T-~R+{\
    nwej'#JkB,~-5xD~CHG;$GX5+*Rz0<D{['H~AB*BQUp[Je[wr1A3@l#T^=e]?=XlV!_@Q"qY//c=
    z3n!]#\l-<K)drV$o9Ho-Z#*w<ereeDi}kk5e~X]l,}2\ojDZWH'.WxDl?*e?V7pi(THjT#1,Yo\
    *DDwzGql3=woU77%oa_xs;<TVZVwT7uauUV{>1xu@G$UI-lCF^2vQZaXJ!7zXT<{#X^5a'_AYz^#
    3'?5kQeIl($m{ohBX4Z{~O#}3^#7;p*>p\fv[2vYprYjriCpDIa5J$*17aJ'1Q@O~np-wTzRR*VJ
    _^C=D+?7Zjjx)xz~mO^1']W{<kYB~=*?E#{jmGH=>BxQW|sAE]m-OG_+>vQr_ZQn~U9*D1uyuj<Y
    $#*_l+@n2oo{o9N@I,1aOR+$D]~07}!T,WjBTE,TE8QUAo3'zsZGxsl<<<I?{$I*7E|,[TY9ZlZx
    u*$O{>s2=!!DAT\Bf~\>v9zKCBH],XnrqJ'ks{nrZu*'!sYZuxRE2kj22I?nmT\@I\<{p\12-J-m
    ]}!1k\BGKj57>oO+K}=*Vn5=3*sW=6ORkuX=vCZnAv$W2]Rj3k,GJT>^k,ss[@5xXHk5,'UDJx'W
    }kIr5;lWnzvW-k'uno2eB7[h}vav=iAmiz7ICUCZkV$][sTTl2j;>{>3gwsR;\@@^jBB@^~v@eW<
    ,\nAxI>{]=@!RGAs!@73{s?V*[r27'#m#_{{!4!B_~BUwKjgQK[_^2X#H[X3:<>1[Di-Z,em1Zo-
    ;^?*+yY]J3~a$klM^{7Df,*1~I}\KDA\OoIRe_B#='OB-OKCw_vOxxw-'N1l!C72vwqz?&{l2CkI
    moiwBm*][H(K$}ii^2x=3n+lJQl]^{K7$rUD2uVIJ]eHT\V'QXC}n*A3E3'AaszrYsQ61G,u<Gsz
    zk{>pBjjAHH}~+rwI!'>l2]x_jdT]2[%1@_VLo<;'?sa}+aeZ'!Dj!'E->]V{.@H3n|mYs{j-!>*
    RrA>G>p,5+JJA~xPw7+_<{Q'j2CX_$2OQTD\H$>!zQCHOCI<D5ZG"&WQl!lEaX]z^;,^_jo$_CVD
    #DQ=ljzpxHFAnw+1_UUj7mE~ssRnv#\3Y{kIDi<7>WDBpI}Aw$,l_D+$eT<lXoz=*VV1AY^%lMal
    X{:IAO{{suo@5Tw,e+7RG33NfskAo;$}-l__J\bS\Elvr_\_
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#|zm@>gaARGp^}UU\W5'*,Zo2,vxC=xsskU2$)"@,o2elxp1v3$^{1i^~IZrB;_GJ;u)Q2Wj
    J]J]Q-Cs~{BBY6+1$'Q,AmOoXA31,['>Kj^iY\|_j-=J+zr7'D]#$GOT$]G=k2}1e1['@1>iC1TV
    E$CDx*{vKEA|;,~\Iw>-.mrQK'vvrS\HXa<$I[>{$2o<{O3LtKBG$n[Bl{a7>[pwmUHBi{<CEX94
    D}rZ^*\}eBzDSW'G1K5W$Q},r^p}$&*n\;rzW7wTVlAAl+{}AeA1kBCiTQ~aA\D\A{jYGkIZ-HGU
    +\3VI@ipEo>};\osUH[egDJx]}'Q<2,~$zQR^$c!QA$<]]pzvmD!5Al?Uelt[I+}uOCu4'~W=rax
    a}\Zx'3uU;olA)x#m*TxZJJO<pQ'#}VV?B^;O&1W[!^#_rYC[DYz+#b3=1YmTZV/2>s=[;^+61G#
    a#wuwVI7?5~Y3!+urOOA,~smRsu^s'lz@:r;EEn$T!,BEr3}}xfCB*JTaY1dDA>2>*mvJr^*l'#m
    lm3r3sJI<Xep$e2xb\;^?}nYUv-dlIB{@<>JiOJ[mz#'qK*b3TV^Z^Akwa[XJCi^GzK^EuW^C/Hl
    oOd'7w[j}HRjv7DDKQEV5zkXO$ppOZE|Sz)Hx[I$'su=],~HAa@ID{Im_^7D~3xJ]t5ZzD!I>=vm
    s}9vW_iN,gGz>a6*RACX[Cl[XZk>=l}8ok}mP{=Z!5?d:#R;I3EZ1*!1!{IR2u<AJ_,J]*UElc=_
    {}7KKA50Z&pwX3o>3[R\~eqP?pkJZYbXB2BtWr}ll5k-Ilw}j?*{jY[!Br7[<zv]rTHe$K7wB_*C
    <^we\ZCa,Y<Z~U;-z}\u_;}U},{{p]EadkQA=$/?rGv3CkUZsG?Yam11nI]Vr@{nQ1Au{1aao,'p
    QCjQa=iuA=>/$?AIrR7o+YXu3{37xAxO08#D1]B+-m6d.xIi$<$D-C^A]B_]!r!HE~YrKxDk<!5@
    -=^x!~^77w_(,~Y]<o1m\@Ii|kUJ!zn~l{]\X~R]VlmoD7]EXQ@sjZOza]-vuCB#aK-l^ie2-<}<
    O~$v-uBEKs=kVve5+O{maN,;XoNd!B^@73WQ=@@E7~-Vpp\[E*rG#Xs*[}p(>_7,7BX~+YYr-$jK
    QO}7Bzs!nTBVr=<Q01CoZ^1jBB;^'vnjVlvAWh1T\WPQp>WvR[l#B,@p~a_^OYA-E13*=_~X]KA!
    leQCpG7o1)7UCD'uBe?<a2GK]koX+rlu'Ez,Be73]7l}]?Rz=n=RXU=(1_Zw*GV@CJ=@1Hv+l3uX
    BIuHN=<Q\$p[^1k3{'E]p>5D@YZ}Y'7>\o~2-A=em)Bp1={+u;eK@,[>KBVs$KKX+*Ep<,7Um\b_
    V*I-=iTT1u76@]aO_Xw;$nm5DnejxxK]Cs7}?5kJoreWIk2KC22whC<[T/*?-Y#-YruxBnVQ$X1H
    BrQC;WZe[~o'ak<,ZWvn{U~1YXW^TAfE->WUlw},E?LIDO@!o\Wz~e@A]~wUjKOOhvp*O\D*@Hal
    {Uv]@UoEBe2~}vaxHQI*-;OA2DD#Waa-O.wYXB7sjYQ3j>Rx$jL?elun'#G1~7n$iTYeoEwi${Gi
    oz?YH=[-$e#a]nWT\}QY~_CA}JA\x\e<Dk+xT!jzW5*?=luD1GA8,JvIoZDB=oo?'<~x7TKl_k'7
    D+!?guER~;qJno[Y?!7qEAe]cY-<W~I}-z-}~lBpw03[eIW>7o3nj_|t&r+XT]"DdsZG[\DYGVXp
    Zm+Ru1qu*u?5nsrKHAwO1O1g1TuJWO\'0va=Y~[\Jw{[R)AoDA{$TzEn'O|e[1v,WWH}r-}I<@RB
    C^DG<XmBkXXsuKZn7rwK}\31ODjo#_5wT^vW-;w1}=CWr=pe5H!$-;kC,VU*Hul*u=V>B[so73,J
    _WYG7eol<WCWwAuWQ,#.UX-;o3D\<onOE{aE1,2],GJRI_^a^iJ1;T$jI*C]^,IUKUT#GoHJiGQ$
    l3HRTsRnX-an[T5G*A+VMW+aAoK*?W15D^,Ce\-nA>QwuXBjAwrIJj!RB@8OZ{GeB-H'ewWW*e*K
    =;RY~\kp"}ZpIr#A?x>IZsOo'3Ge]?w!kl_D\~$1IveRoXX>C(?sO^;+p+ccC[j7ql#X}}TjmYKv
    OGAEK7EYUHT[;D1OQ'HOT*~}uqp3^s^r1B>lB^JpB7w}E\dnTK>k+XeUjE#<jEoEmC17['kAe~XE
    #E@(yU>^TO$pW(x.}5n-GTJXp$r5r,3->aCeZx{<c#>^^CRw?Hhe-OVF-nx{ri*1@O-^xHE~2x;R
    3Q{$xa{@I~wE;7nJ#w}[\zz}9zr{}U[RaR2Pl?K[LH^WKQ^oA
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

    MTI!#2+;amABBz]'k4W}K<#C^*3C=2~o5u~eMd[zN"5*;[m1zAzH2re[R[F?*+ojRHQ[xB;=u2J%
    <RA@@D=pgaap<+1$'Q,AmOoXA31,['>Kj^-1V-]3]_7[{jx;]}jpm_Vxi]}?_G,'>?rTvwt*?ZJE
    _w?Y,AIxQepzzozkjH@k,1Txk3$Z$>*[!~o^z*rsmDZTeQG)rxnz']l}YsUZv~s*zzE~flz>sL+Q
    nWnsrousY'Vr#BG1r[X\QTPmour[k1RrVKoU{<AK'T\\@{GnA1rpV*Ki17H]+uCI^{!bA*5~Ql-@
    C<o#HsTD,oWu3$vZ\qeD+_}OQ$IOHeR!Oko*Isj#DHa}!T>DRCrT5kVrkJnrpj[D!Y=5WBlW\a7U
    Vex^A2WvBuZ[j]*v#*]$wZ=n^@BQ-}x~oUB$+5xiB{1{K#a]!3,[!j*{e-AAW+^+sisu,]<BpGAa
    ;;25jxjWm{;DC;YnzzleCW^j]pjWWGYW+U$D{7,=lTB7u?C]i@Kok$a+Q@rQ,l'i,$w-akRm+E.+
    5-xzH1u;5}5=uRuh"3zG=-oEJ*EZWEizC\Wo1H]YkEQvi>a[\e;TU#vK!@EBV%eB&lI~v.][U]7=
    *T;wzRW5pE*-7avwl=Dn@V='><xI\lzHC,$_pj'DnD-AjiX1->;UA?7OZ~RQ,[O=Aeq-U>u^>sRA
    5TE?UuV;DH?re?I#$anWvip[-KBUw~?>oRwr#\ooAIH$B]r5Iup{z5!nj<-k[2}Xr<nxl2@,x{BA
    {p1,;z[lVsOoQK^qez2Bl];C{RT~Zn;pw<Ue^>}\*oT'lJUYv3\$6w{!>cf5vmCj1UBp3]OGx+l5
    GHG1+\mQ{vKo}R$TrZ;#5*~Z]Tm6Em@CQVXxuX~vO(SQXjzr2nVCHv@|'DGCZAG31>>K\EB+'mRK
    3sa~.Dl_@C5BQw^#ai=1C$p1]uYB_YQrDHea_z^nV>${}>l!p$]+$^I<w,VrDm><+GBr++oBl'GT
    $]z3sphl;_3'EY!A^[B*wu,T}\U3V'55kI]!xWIl!A;)DA;,bsY;GG<j;r{v]TU.jbBT}-#>E}rJ
    H<--mk!1Oo=GZeK[1\|xKZe.7ZYmTxX15A2TI+=rlnO;cI{B5-O~+Uek[l2wKRjQuOR-<J{}TH]{
    BpsO1_Y>[-Iwjq0.-7&Wj-p%b!o!K[75-\\Ok?=Gm<EZ_\rKou{ouysn]Z-7CU*?_=h[Vxw#>uu7
    ~Yip13z7k!;!_G$p'X?nxlHe$Jz$>CD>YE-z-TGF(uoT!MsH<;qv=G!=r=JuVwObno{=aoR[jk+?
    +zDw}zsD>$;zDHWV)WDiY[j{[<=RQGp_IV_<^wwO1eX7Z,,,U8BprC-X7k2B5n7]pZexruI$7u]o
    X3BvRUD*_7mI!}V5{1:'~DD;T51V{<H_@+k[AHQR-oD[<{x*?Jk_w7OHB']!+$T]2}]]vzXqE8zD
    j#YHmYT7EUrO-<3A+U^aUa*pEOkwQY!BI*0x1A?o\ekGVR>IY=o[<Xj,vRupz7~A*=R~s1]JD-JI
    DYRGzkQWD+#]oBe[_jJP*v~_k{{-g2D3~I1esEBA]7wzBG]5v}kn-hT>B[GXCpBkpi3>o\$=UpO^
    O+Ar~oaD,'*+s';BQ?vUOvk$-a_js}@wzmtaw,WInn2IQ!I@lKm;'?YMu$$}sG<vkXY1V$x7iTDn
    sC;?3v@\Tz*A5$smO;*k}\^XBD7m^Hj]JQxHCQDE2Y?^[H{o$;v+Jpz]jwoQ5zY^G#xQ,'oVl_XZ
    O$J$wo,D^r[-Rz{l5{r^G['JFk=}7p][i*vi<XO7W&O{R5x]]w5\1l7wA,/T1^;DaD;boy:vv+Re
    iAT>5UEsD>u-'2vGkJU81BAp.p@[ZMxe?*"nBK_h;\2-A}[=F3E*Gm,]{/i\QBRYv5A-KEAO[ur_
    j5B'WT[T*{j{5jeE7<'T'wxYJzO<D]lJGD#+-KR#BU1Eik>R_CAzGWY2D>4>\<,T<CH]Ek-'@H$_
    -2'lXK]1p-r<[]_!-K;!vrn5oJp!7a_wa3YG{KBT+Gno\lj<,_s\'{BRzsoH\-K=v,AQ==@l=ko=
    !XVwe_D3p+we{~^Xr;2U,];8QK\-[=$~{\Z^j''AQ3RnY[\-aOJHGCWDI;EEYW^I2BYHZYxXy|o^
    KoTXnjcs2$;vTY,Xne74Y#1$vGI{:R+X^LaQu1RD]#_w\C,-a[Y2uJ]_uEQam~DEn21G>TruwI*W
    ~o)OBQmsAa]x@OV/CsW+}B\rQ+}*=xUK'wDOG;uWqC^?OkUW$3V#w!a72lIDXy_{2$w_ae[(Kj#a
    6z\'KC>7!W7{A6i_?1#I7~Q_pexrV@GU{'!VnwHEVTvY2<Emjo=li^zke}OG+jYpT5N3>}wv$#!J
    ^$Op~T<^-1[?VQ$JDEA][A!lnAKz\m\!R-G(FE;V]W'X]oJ\v-OH7R;Z*"m=k'GG_H},j}HGl1dX
    ']$<-I*e!sBE3aEZX$<v_WrxupEVQ!?C'Dxev~p\@>uzunWmzK}KawKi'-]3A>W*'ao's^H1VB2-
    o[3jnH5>n$us7IT81ZeYuVsW5;m#O7__<eUp%p}_nfCHzxA5j1'W-O/*<]k~QXr,#OV#5\a$5w#W
    TO3}1I7dna$,R~xW2A2QY,veT5BQ#[B3[<u5!suUp;^Qw<I;ulxC3B2XOVV{uBTk'AR'2BeO];3x
    CmnQRXl@4j=WlvsK5-VE@7;BD'7A[sU*$o'Z#C_H\,z~TRMWG\jZ=1Z+nA?U<w>v]HTR]-''a5^A
    +<uN#5VQeAw\^KE3ZH='8w1T{~T<$B\Q5I{n^Dj1GOA>_2=Tp4O2^2mI!<i-H<FQvk3l,I-Y>lEU
    Y1v<$T2\$2s+\C;}QQ_*7mo={B>jQB@,m7ksR[\_J[sg>>*Zv['-nR}!v;wnlY]RInXZCs>1BQZ3
    Q\I*3-]*b*eJ\^~p2r3lDxO@_ETDZ\;J7"T<j,D@*X84[mz2nET~*@<1^_+]KA+ws$H{#Ep=1KW!
    ouYW!VT5,>!Jx0VCo{V0x$[VXG<vXs$VEC]\aVpK0mxUHExT5nX@I^O[QNnGl;z]IrO+oC=xeKGE
    ;^YvQQ^x2upIrns[**ZDqVe,[jwwI|Uw}5o6CA1C1T^mIHo^'<OmCap~,RNpW~m[,n=_5<ns-vOe
    >V-I\7Ye3CAp!'a\7^Xr]Q{pH_n\A@~7}eHIxaG$}~@E;'^;TEXZ\{Kx_,;~{V}?DRjru{Gm<v2_
    K5<zH3_2}Rlp5z@?RVs1+l>y{tg{[HKw${V^C?_VXl;s-w_eeY${{{>SCiwecO^A!FC+uYLzxer+
    }QK'Zz+R}2ev+\auR=l?wHa{}W+mE^mwr*iO>]?L-Bj'$5CuUpYpX[=;z?WKsU_zYZp<2^Wx7T]m
    vk2<}^TVCUA7[QVm;[leHG2>\+=;v;j=g'3<^\27^,B,jQT+,v;XCNXr7eZAlob>1@+X$vO@s$,z
    +CUn'AXQ>2Gmnn}Q3-I7I[Z'@x+L2<lkz2VU1RBwY-rX>^<J]!~AyFxTrnn<C;pIavuj,XG[<Uq/
    7\QupGvUGBo7k1{Iv@]@)t*1iY[$iz'oWjz_$,ka]$HImp1nno~]]Xo-ll8W*l~He-H)J[BC^#\D
    OsHXjDVX7#IQ%!wT$j1paOR-@jGsXkr$uI[X[QzJOQR>*J\BuerVVpnW{TR=5P_rlvj7k{,-eB7e
    alWR\,B_]mp5=}@<C=1uK=*xpTWoi[7OW?Z$j[^[kwJXm?#waxTGU2lBu]Hx1=Y[YH7m7U%-p?Qi
    G3vCjw5DG,+\TCrxaGIQs'\3TCH2U{#s7pX;AJIxX=2Z]Ea.TzX<R1+p8p3}Q^j#Q>j5JyMK1G~t
    o]^,,^JEzapWl-2lmTpl6E>>nKXX[;,AY[Q'udV[@Bv<WR@_e5ETCJf~'HDv?XD1}-wEa<uW<7$I
    5A}~vIC2]?eBr~Hj"q5W^wmzJ12=\Jl[]OmnuKTAppJEVxT<><1uYG1C-1Ho+R;{3le'5sGwY!_\
    AmaV><1al-7GT*<5ex\Ql]h<=G$BC=VZY#w,1Rj{['vB7<#~Y\R{sjC_,3_"WCT@E~j#7omaW\El
    E{EveR5T#eO?V[okXGV^FzJG\[E,?~Gsw'~]oOvwwnHxDeZTV*2jll>2jF$O=]=ODY^7nR@ll=D1
    i'+v!s1&W$]vp_\B>Uu2deY~jIk}ni{nXD'#CCCT-E+DQ3G@2AvzU1UW5Y;Y;V$;o7wnEG7r$\UA
    #uT__KC=Vl~^*;[o@kp2Cg9\1XXOTYOl'V7^KGw-n[wC3\u7BZoXOvXH5_ER#;}z!Za[AzeZ}$W+
    ]zzH=}xeV2@dQ_n~0kU;{ROH}vBi$(Y7e2r,C3;,CaVGk2mBi_]-,K~Du<z,>{I={@@z3{IOI!*2
    QlICueTTKXBwZ}Y}Go/EQ#~x7!\CGeER#Ts\AlQIj~~xWwp#'TCH1'{lF3'_*<VT*r\i,;5l1x=J
    @erlXO2JV!Q3RIY*-[s[k!YmDso$R!X7GkXT'6'olxP1>$T$D-u]BO7&Z5m=@+@@6*V#3$*kl@*a
    *AO+Y5z-*+lxTX-J'Un-;l+O#$QYU^1~{ZtuAo*Y$3Tl5swio*^=<*{kGued0xnl$7OCsGY>uIu*
    !vsn-IXz#JEk';AA]-1QUO#5XvVa*vv$OFO_17Dpo>>VR~ZSon+}<{laJpv$v;5o,v<nmXP>\EE\
    +~?w{ZvvTRpr-*u=3pY"X=k<tqIiA+u=2<x}p$un=-^;ZTvwEWzuH!2UW;mG@ZH62hp;A'aR<sV7
    BjbiO<n=]<zoHQ~Ez5-jR!E$n\B9UCx3As=QR2=Gj2,ZOWD${1jRz+2KHj^2ID-vGsDZl@<1g>Om
    {*2IX#pkWp$xeG]\]7Wp+ZaQsZ>$W~R>^{=IYDmR@Vam[72I~mBpj2UrHDpe'rWEG$#;jA[3RvA\
    Ozk[uE3mu%BVDJ=A;K_@p\h,TaX|5RDDE5vwAUXe7i{'K'in_zal9b/I]7^41<A~]BjR#+WwAU5p
    Zz-#,n~V>rX5?CBn_}EAwp2e7*W>\'ACvkH,8b17E3uVHG'Ia5[W]]51W1Vj@]C-rpQmX@o#$^gH
    B*,V}al6d'YXevW*A,{=XpBpT$z<1@7$X8*!X},aV;wzn3rO\1$]E7h%H*J{gUXAXG,~p=TjH'>+
    3n$,x!p5p3__36wEk+Z\=[~7]RJ]!#V3_*+X~nJ-V'l'5HM^?IQYSF-{l]%@G,=#BZwG;Yr-6777
    Oa{Amv-uVrJW,E@zx-A]7K+^7!$j~G_IW}VG-jum!I3<w}#R=s3YD%Krl}qG!pEQAKI]_ICNMKwn
    3rk}-Ov2C^AsJrUe@I\n@VC5\H]}Z*,p^zD\7E]~E<*rDeHw!B>~@ks^@%m-u?6D!=_T_D{R$lEs
    s{X#jozE_#2o!;AKjpx%1HEv^=55*[KjkBa!+j>}V7T-x}*voTQTHv]5eE?sizu{lz^jOWv[A]Xo
    !ax~uls7zn\[r;Q-OE[n2DBI1ZCDRs;$@Y=DG?T,k{w\Iao53A_U~X_X^-U5K\}3Z6DUHD$,E_VH
    Yo6yo2x~'@+mp3\oH_nIC}']7o~Vt'e;RO_pHUE#GRO_Ga,r5x$B~RZo'(+Q{1x1[mGuAR$nlil;
    +w}'Z$3\KvVQ\\-j1lQZ;^9pp*}V1x'z=J-QuA>>GejF,pKx?*Cl,i_XRlH3=izTnlW^kH]s\vkC
    b;,<l,21nz>[IwpKG#w^X4bC!@=*!{-:p$_C7]KV}o#CVD~zw^XB<>aosB1jp'3AEC5X[jYT^=+;
    ^a<r{lVv\w1Wo+_JQB2~J$\iu$CrJRI>U[o}@B*noj;v(v73Q?]lHCJ<aIr,,K1's2B[{fkD[xDK
    -xT}<O0O/+_s'%CHH_r}is<Qw?Dl}]-BA**#~DsH!Kv?Gi0y]1DIxr_@RGYJ\5IwDT7Bl_WK-DX+
    9~tX]]EYRu@vwCu\eI3nRxB[+*HaA_;!Ri=~,A=J>zC;pe>mnsRc@T$lz]7<UrJRDE+VHUmZ_v~T
    UIpG~V<sRY!!rw>Kv!lCoU';7Q4'[AQI~,uX+xOVHp<Te+$V@jn/JsR}siBkkH^G+'j$mwW^bPh?
    Ul2jA-wG?_Wnoekp5\Y;xj,oCu];eKkgXU^I'p\,1KXW^O^5?>,,JO,[.qO,VIW9D_*n#aw}KCEJ
    '%i>Y7QC2,BKX_'G>pi+aHo+uv2'YI#Q~3e=AE|3AKs3CZ+53@j'G$>>zIkHn@nA{zG'2!#sJ=<^
    kCBX^+vvZZuI,ECp1{eBR_,.5es^u^!ey@H7XW=UE6sCn;;r*@DE{UvWH]/QBk'"xH'x=;3{H}}[
    Y,K<aIzT$=Jefzn*nvWs-oBsWz1up{n22q$2uQC@Joe1?YvRm2*!r+l?OY'5Tlg^-<^ok7@WDX3Y
    7YZrowUERVu=8G$r,'jHjXw12,TBk7o>HrWGs7Hj@v<OpO}-\1vI].ExXX$U~rpkG=IG*_mOOG?<
    Tszl'ZO!>Z;oA7|Vn2>O1wUvk$aW+{X2Xx;Ou{OV2'Z]r-rm_s~^1kvl[km,X<-Jr*3K+}D,HT$C
    \G#=A25O;ZY*GJ-uAjVIo^YeD;r1Kpa2X;,w[n{_UZB-O}?#wExG+oj_j*W#COIpM;^i{AwlQh@Q
    lJ~Xlm%7wXRBI?-VXrJmU_#y^@E_7'omP^vA~]U[rvpB[lOpjaE?7r_!CI]nk*7E\$k^*O-*z3\R
    R\nEO^tK<R{V]=HKoXT[%XX$?cIB_UJ[pDRi~^YJ@?JGlp7z<TOI3R^+V3+ET^R'TXs3KD.9!lm!
    {'H,=k5V=2=U!U{!lXmze;wrBoawDE*~Fm$Qe5_UGe8\wn#993-KxUeG'>Q#T'Q]Rxx^RYW<'v_x
    @vm3YEz^<WXA#37$?Rx,K?]}G@,gK=_?IGjl*Xnva1[I3^D74_zz@=w^EQAzI5_{-c\2viIo#{z=
    Jz>[nam=jkl'#2O-zI@T=pcOx-3u5>nOvX{Yq<e_H>pcE3J{9s?a=#Hl#iRX7TYOiR3{@7m!_o}5
    RXw[HEalR=D,xw}\1s=>}s6OjkO7ZwH~-s]mHGrd=@BZTrkK[IJ}.eB^]?+;X>,-H][JB-H*uD-p
    J^$x2&vf%}sJWY[mBE,wE'ZQsoO7u@T!*;IW~BZZ!>X'Z-17oL#XG'*_O]~1nj~,O*]&F}H$B9*[
    B99KU-2x,TnHU5ioaAV7,m3?Be5s<IY;jU@o{jo^+7!K]7]QwX_AI_Ju>>2y3QT[l<mA~7DK7Vv^
    7,uw_I]]ZRT->_1ms!3BB+mzAn-,B\\x~\zQs>VH$wWJU1^~;5<^qKOHG-IR^l'DsAUX[uz]<HzR
    uaI;a8#\A,5H5uI@l@3-ae_!GiZX$7vj?{3G{z6BUvA-5\JTp_m(v@;x[]'<#x@D'<-jKIn,_{rJ
    rOj+3-KwolHTjWYErnQCouIUIl*pZ[R*mAomCT\p5a,G}ZlXs;!{_jTW#\m@C!vz}-wZ;E]vA-T3
    ^#7D{a=Baj1v;Y,i'#E]$~$kn$j];5Q~\E3AyCw>@};e#1;[os^mp{ej{]GU#IrU2rz__BT;B.'-
    A5,e'?77V]UA_[<DreQ5@<i+T,bxlZxA1Dld5,v@RCz\Yrm',GAu@DV?[;K*]{v_C\<GyV2DV^xv
    IzaEw,CUA#nuQuD!W#=Q$e-W[d3C=C}u<R3w1He3];A_@zh1H@ZuOZ+i\x-J{Q$'}[>G7Hw$Dom9
    @Css*lQz1W-V$sj]VoTWYep^!x$A[G*1*'}i55]<C3<*G<B5,TV{y'TU@eRvH=uo?*7}RD;!
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#E/!AG=WE3j^^,XG~E]-l{7@[+7'm=AXt/[>N7@K!|ioE?3v@T<nFcFt'eOTp>D_G@xr<$vm
    7udOZz%lwJ#*+[[o_n=['CW!Ul$HUlIH-BA=O#QET}7B3p>~'#BzJ_I;DpF*#Y2=#*?]X,[*kET8
    7QeZ;>BX}CE>7<32#U>zl?Ro~T<;=!T--*,p<'3[[V;RQ]I#>>rB7e;T7i318J^-^~G~7i12?VIz
    KGaoIv5Z'}=E[<RkT}2zT@7R;V;s<8KpG#oA{2@T+B[x2^}~,zPKRVrxXRJz>BYKv,rpkr}{OYHT
    *s'eu7+k9^9bwG<v#O>@}Cn*mp7i'"'=A_r}oi1lK!$_z*CH[C$p[sr$->p*V!4-RJpF-Dsi$e#X
    W>CRip}2=u3QE+R3KEl$g7k_Au]3z)'$?!*l^m\mr-Hj<oKoX$s<>Y?>Z$#<3sW{]IJ7sO;a{pBb
    KBjJ'mUBi5#D[$?l[O1it\xmAvmsz#7\3uV>$mrI{^?1;~1eB{rjlB*SGG'<Y>!}P};EQuDYjZx$
    ^4z#^-CmmI+sWw*'mZQC=@LWoivJY#*eH<_IVa~h<1D=.C1[2GX\@D?]EhBq?n'["1oCw^?lE=@j
    \&BCCwHr=HlI1-<Bpina\3~}QEf'<1nl[-kGO^vQ,*n$n\@]1J+*RiX-=<XB;a<-$25ZDk<OD5V\
    $!kWa+mSC7Yn~{A!Pjlvolpp]J=1VozZ*X7X7X5pTks{kP#E+z_?'2z_I<>5Ywiz?ap+E~ZEUe,_
    e2=czpnzmAUU},K<Wr2O&l7Yi&17X<VleD5ur[C2nOU6$nCj/*,Uj?a!I$\KmCEXIr@J}NCar'<>
    !=7'!w?sCnx3Aw@+ow1]X\jva!8ke}Bei<pZ',]j}iTp?BQGz\_ln,eh$UI\>eJ!POUJR$1i#B>-
    5}p<*uouE]2aY=3w'm}p>AXu-!=K?V_!$#wz'iRJQRRj-~pnEQ>ZQRIk2iOxiB:*x!KzQ}Uzk]Ia
    ]=*B5aC3[iw]Is+?l[~3X\mzO52BIvm)mXej}[H1;$7=Qft#wAT,*@k'!]}G7Vux<wJIoQJxAm<9
    =DjT5mjJRX5mYn<15~RoO$JT]XzJ'@KK?TvO"yE!_*XssDvK2oB+[^=Z;Oa*A\zrXI?B3[^wB\~5
    {C>$$kp?H*l#^R~1,aD\rWeTIiBKYe_aT{JYV~Ok@?kwpmWI{'SbaAZ7\@_5aX[Opp{A_re@!An{
    \)]];\BU\al7-]VCmCxAn1[fD)Nx>]>R~mO~InJ*Ou]}-vx#VU{Z+GBurRoIrx[A'-kCuAGCkaTW
    ^<u['[KI\=uI~}Z7!YZ*ulw7JDXbprzJ>[oXqI<<U}AUj@$jD!Ol#Onu^mvvmr3xz2=Tsd&5$]^E
    Y}]rB,U!OjY[1\]ZQOXmIO+K_X$T's,GIJ]]}*=7$*Cx1T5RejoUTE,1iJkUw-Jkz}n=|QQ?'g,+
    5\IvkfZ+u3nj,WoTumv;^]i+V[rKEJNE^AeB-',[1i]uHvnC+@2
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#'mD^x+K7^O-Q'5A=X{vJjR<_[KRO@<2v""=;Y"#Y,=m'z_MroBWuo#<[WA{\=,5!j7Ho[Ws
    JTJ]Q-Cs~{BBY6+1$'Q,AmOoXA31,['>Kj^-1V-]3]_7[{jx+v}7Cmm]nK*H{}jOE1|,?<@bjT@J
    =Z-2}RpQ<O5[[D3<hxAAANh#EV]n-<[[BJD*V+$CuQ]O-aDB}[HwVrk}]Q7$3G@Yw*Y(nSK1u]?+
    -ska!Z}2DEn>pkDC2ZhT7C"xjWe~jH]Gf#XHvF!vBz}Eu{Y#=W*_[l\-Yi,kIZlKaA=:oT{W/!OJ
    wNI<2*}Cm=IVI=U[G*^wsVqHDk;ZXpx/5k+XzRAu7?Y;^JlEJX<$^IG#$ulpu^ZWp$>_$-GVl!^a
    FwIl7@GoTQsU<<$UZs>wR>xY#V^H?.%kA}s&CX1EejOX,1-AkQAC?ww746t*,X?UGXIL\w;'fBDD
    \;_z],$,kU]B@s{a_,Aoi3e3jH$EpIi{OrU@-KE]B_+A*2EZ,ov]9eeUrZDnxlmo{L_WR$QHY3Bi
    ZQx=zDZ^>v8'zxC5pV!#<>;2_^}Y2Q-Azpw\*Q,QI~\RJ+^,ImltKQ_vf&rD+${}!*#N2__^@+~C
    4UQpOaor'}^rCTrX$CI<v^pi{T+rj72Cx72UvBHm,73-WUv=OR_Dox#nH>Ri[#v#o,j{\!Vle#7k
    7zg1[!c
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#o51z=$_B}rAo*XVBF3'O'mVG@%%}<$iNY3Z5N9=:G3\ORvY'G;jpZ^-a+v3Ot-5PvZ2^{]n
    EqC|z3C[EfkQ'Be-e]iXa[zx^QI}VCX$sD72[lNW'#Zz,v+-}5UCO$^,*?~~aZvsDylv][I?QV[X
    1Y3XTT{T+{ylII#iD[_}WmnYD#v{_jEd=WZJ}\_zEO$^{siBB,~Z#<>rUr7CKXKsb-}@mXsI?Vxi
    GqevoGTY>r5<WunTD<15U{|f-rm~xv2I<YoDpRo,~<Rk-AW3+R[\AwV2!')=^5G^<QEp<Yer?vK1
    HQYb^w@;#|X[{om[3kQ-;<]5J$[,RzY)B#[#:DHXov7Lo$=}}$Cn~=7]v}#GrrUU25An1nm!\+jK
    >7V}YOmTK5+G5{VQ;l#D-^OO'U\E_#ol2SOi7Ykn$uB!Z[@noYEH_7bV3[=6xA\]5#I-Xau$EG75
    1vuaK{5l4Glal.We2w@Tez1An$m]}uinCu<UR57X_3bOXeG"QDk2$C~@D1zBQCXYAEDYp7TlvKlw
    w}$i~Gn!}HWDx!VJ^Xj>^I2#+E<HX7Az=G;1c2wz;v]{;2C!e?IRGk,YOG5e5m,vX-qw--'0taw<
    V]Xu;lT[Gj#QJHjI1Q$>YmjW<nQKW9^_J?O?3@#_2xM3{XO@*Jo9]1omC{}O+>J25ZmjpXW@wACi
    \[s?HYQEOV#D^lipel[aT[BC^R[z1GzTl?j5Z'?@'IkCmw'X^n0)lvu]~o'2>EDeh)R1\!=$]]>_
    X<c=\]Ba5{G^TQHKe~$Xw=@G3WGAxE7V81;JzTOG2xOJ]R1z@AX$~*>ralrZ1u\zJ3=RJBrR!DJK
    ?T1xT\Z3mx+$#nAaJH>uVBZT+R#=JPsHw\7le=z=z*$C+OeH+oYs>~\2a^7A~\#HE?n_u>$rp+c<
    Ik@7@xU@<lDk}jw\?lG$n~Dna\Cql-VD[KTB1e<x=ADD>AcT$DGYH_m-n<>~eR*s3^C@'_*ps$BB
    Y<AVr<K:j*?p|r!w~[;w2EHB-B;Zo$l2=EiGT15{'=r,uazsuJw{{\Z1kZIY-$WZIn5z]Z]W1MrV
    =e<1j;2r!!KaU!d'\$Y$=pA7DBs"I&#rn33TXET-61p2X=HpT-DE!Gi;*zeC@wERaUT330f7_$Il
    _EKXS@=o=,sj#CuZY=zm'[+x?v*J=Ywl~$]mpa'V[QD!XID-rAlkojp<*(oGm[}G_m^Q!u9}H7J[
    BK'GpAuvB^5l#^@p-2^R*a\<RpVflmrxOxDmKD@YJ>C7l$r_H_QA;n-O+n23[5?$QOVxAR3O}p{#
    <}x7^VX^p*iZovUDyHawQu(u7HZKICl}?Cj]^}CLbX*!nQnG-~Y5;TQHv?HJw?O-KR{WV=K_TeOK
    sAVQeGDT'QVU@=Dl]',JR''HzAr,@2RXroz~7k.C<AA@AwesE_\9RpY^l9<rHz\Q!zx2]Z!DYKGQ
    3Y<$X=;jp$DsWn$Rl5'{w?FnH[=BK~H$pnsH\=Cw1\+^kaJiUBwanuj%rQXwmlRzO0>=EpExl!p9
    ]HvD~VjO'm<Q}V?W:&<vIx^XKor~Qi.4v'><q@DzHO<j~1-Iw^A1OR]$!_)C;v^Qz71z}mObIW-?
    aQ{=^jkp#HxioA~=$mEe$anp7U{_[nIwX17As>sp=[=k0$j_{[lQ~E[YG{Xa,I5I\\6?I,o'}wr-
    _,TW,G'J^^^5o-ApT^!enjJEE!*E>+^'UoI$>;2A['Z*!1AT*~X8$na#IHw{{wzJvn;DA>InWrCs
    kE7[3Vskan2V7XUoWGH*COR!Lyo!<['W}_"DBs2|>lX]{V!XeQYV1iV}@eWn[m[i>R7=?H;~b~O*
    !DWUAwUBTEB;T2Q^D}}@@|F}zI[C$imD,jVfT,ppoXDZCl^HWCx}LOI+_xWBE>1;[$Hepo@Z+r}X
    nPlG<kil.3<@GzwWI?D*$$X5U75#!OIKwT\W,7YXA<+Je^=_['-j<|xie]TC,$<*VDZv3JAV=,^<
    XYG}@vHYx*nB3GARar}Q^'r+>$|>A[>F=~oDel[a12-A!1[+7$A+UrioA[5siHHn1\uK!rVoWo,1
    eO+~2}}CVGJZ7#DD^Dkj_IJ+F]_n!CrxH@=wW}^{[]O?_[uT}sjtH-Y$m$ZClC{2vsum^XuB'kTr
    ='mQw\_UuCE#CzwU}MEY#Y:vTAa5iEoEH3_3^=U#DT@[xx;[p}Q-]Uwx<m]ael+ap<J.GZn{75RE
    h?ao#gEGR_+r<~2sG}H,Kly7JAEzi~[+a]^'w7{zXI)x1w~B[w]v\#]VE3Y~U53DJIZ2VVDpz,aQ
    nz#2=u5#1<@OK}xna{+}UT@jk3Dpm!V&^V~VO<;DKR[TExBovl[U6m+Z5}V*1\o>vo1!pETYuRv,
    u)#zO@s{D7R$EXK<^E(N)te[s?s2B[T-Z2WCZn]Is$=Zmw!xY'sWHV*R7Ku,BA!-<O^TXrf$#~?t
    uw~?*ve?pQB?Z'{mijE!mA53uoz$B3a\TzTem,Xx-]A\LxR=oO[wZ#j5ooA!51<5K^J<pz*T,!Do
    uO5}WTBv[{=koI<!;^CA-z35*f!eQCVu1*aV5K!n_u?\^vJTEBpR7Izlli5W@ID+X3qRH>V5RB5I
    ONY'K^vGx;$XX':*<r^l,ea@G#?CY@>JQnaLu{3vc7?G]u'DAzz?3DjZkI{jja7?=jRQ$nxC,vTo
    smjX'j=Au=7*[/sCn+=ABKO_,w=mrz!B_,DZB_]'z2ivmE6s\J]OpDs1}ouQ$7e1+;KpQC*I2pD@
    ^$'kX@eP^3eEIT^VUe^1=vXDnB71m}Rle>22Gm5<A}EnTs~peE{_n5+zI}B{-xKOE5jQi+-;}v[p
    ,D72U*p{6ioE~<N:}Tw@Rz1RYpV>2+-OZlUKT=O;~BJkeivEQs,]B@JK:CDnG3j55,zwlxl+oH*I
    joY[V$<@VUL3,Bx[3[\Vr!uAxOaw5J$nooDTlmpEeV^IO,\l5{*Rpl;15KRS@}RWGX3U/*IiRI7A
    O?eln;G?pR!lHv?},_ju@*1jA5}Q#'Ra'w_v~GK}!=a<<#[a7yr;AUo~\VhC>eB5@,;iX~?Xrrj3
    s[!sB{{>w13Vk@3=xYx_QOui}e^'xTxUBw@]QZ2SpX@?^x7]]'<<j3x]+qVn<;~rEalW~?o]_$Cu
    <WOGk@mR$_G@]a4-=oQ<lDn[eQX\(kCiE7B]J/O^?eTV!}2Bu[vWTW]Xm@C?lOv[ij3n*3,C@Xe^
    ;DPpm+aL8Y}Ds=rZ5|Yu5Y'TX+K\*2h.rY,uz_GusG?!0,oOJ]\;<7sQ'q6vW*Q}T=nvxVn}CB@<
    9!C^jf_Ewzw5rp*1>opHv}si2ZaQ\wyQ-\T^mxBI5Q2>\wB/]sn^D9wjAnQlA5$kQ@17Y}vQ@<j*
    VZ]VUv2Ua5^;+_j[}orW1IM'HOnpi_D'<YmY@xu+Bk@k>[7U+o}jKAH>nj5CDV<e-VI}AI_-IT5]
    ]Zl~Hzn*3V$rl@Vwlz\I_Y5'{QC1\?jTXR$)OvU_pTx@Ha]#lr*T$!_V7Bj};OXD>^w$JUD?'31K
    &rBDnE;Bkv7s~3n7j#jnW\iT}Z]I}HNC<w;4oWC2IaxBm]OoBK7Y;{-j+_#]\aG}rA~#)QYY1O^;
    7DxspR<U*~T}E@YzsURul[Q@CT|{^s]UYG^5,XC^7^-Ca<[C9~s!!iHHJ#$V{(CjGzeArr'u*>vB
    vuO!okD7;R%6"K,xeG;TR-ETW2IrY$rQ~NT\s=yeeTVT^o3E5I79x'G13R'zr1lZojo<)Y'~K?XR
    ^*lUUCHUO_$;u^JZQ{jD'1-;DuHY#jREm@ROD'GQZ({Gus?55*wQmD3njJN*5,5t++TkFMQja'GK
    ,m-aTx[DX$l_ao\Bs5wG\T~w^s*7V{?z-!lCjpWI$$es\GGTxoZs!oK=e\-5rKuaU_d]o$KL2[_l
    R{[v#1=K-+uk++R;=k5E~XVkk\ZAG}R;vwrV]}m->$~,(nAWVaQU>be_r3Uv15_H^Hw*R\#TXz*<
    }{{rz-nw^z>O+I@5CZD;zHB<T7v!n}z1REW>2UC=V71ne@=!R#exin^^<'5[R{^{n3i^YBlV~j%_
    >C_($>=@PWH}?[TX#'U,W#QO*v+5V,x]QMa\n\j2p]T'QDR\QX,OI[_W2=R'VUA}n>1AW$}2uBR5
    2@7TTIpm,,(71B}Q?B@iOQer#!m7-5zuT_7_pW1~rJ5#BGXUV2->_]+^neUZsU{XS;5xOi=$?EKQ
    pOUKDf[j^rQ*JZ$=$X_*'VBnH<mBRHr[I~hB{x1}U=mrWw<B@aC?U>s~X3_\u'n}]{De=kz;>Z@F
    tjI,5DW}35EJ{ylajs2nB{)I#]u'<+3}lnXin@rpoI}_QCaCsH3O]R++_1eQkw*Ww@CJv*W^pk}F
    2a[34~5^j3v?!jUr^,B5eC>D5!UR$YH~<^r!7]wVwYC{s7}7;\O}koC134*[A;,zI~5]>jO{WTK_
    -T_]5IDelIp-5eW[DI]W\zl5RTa'uX'l!_B>!#x!_{H\[*~\_z[ajA#_1oQX3nlo\-S|Dm}Vi-X5
    rW*$R-Ae]r'=A*CUX^kBME^$>r-C_Y=OrYQB5R3e,~UTvoXus?}<^,EO;_#ErYpB[rApj5mA~>-l
    e_CVGE>^?jw33+]v{'<mlOu<HU=jz^Y{XeKRHCs5G$Re_[TpDwr;x\J@oXUw-r}<r$Dw#e=*Gj'v
    2K^l7cQI_EBlv>[,3I7ez'*-BJ~UrULpt^>_Y48plp}_,\1'pp2mI~ulvnoKaDIz3vGAHZA-AV\[
    ;l-vsix==T=x;Bs,WXoux'GGs'}oo$DXr<!k_,v+Isow[HEB]2>OvQ@Yi$UGGCE,K^J-w3T*ojj*
    -Z]}-U*y^'}k|>=X_A,!n$pm+j;;5[kEJU7+<p',1@T312\pz+x,Evp7!}a32<Bj$2pG-r'Z=NZ[
    RiI2]'C'r;*3z;'[=Qx\O'>AG-m1-CxZ^HeQixKDOZD[Go>O*<,=r$!*1xQ*<Y@_J;Q?@U{Q'rlx
    7epo7VUD]u![A{oO]O=>*}U^5YQzWB*[nv;a,eXe*@1<l\7A;D{<K2n1Gw[<o~sm<VvxC$#HeE1m
    D*+^^ud>nmEBE_j]3tU5RmDA\Z{vojz7C~2x+rlAGwYQG~\7VppOI3TXERO;[I7>_uDmumpIZ5rN
    WH+WNQzv?la1kj~v;8%D$RO@7[3]H-'neQ\n-}~!DkD~A5AmIT_lpJvR>>J^^-vJQ-}-w$]A[Twk
    RJAQ{a-@Y'KVBW+I-XxsYrZ[U+!EuWOI5U+}bv<Hl^>>JozR#=R^+>o;Uu,nJY>Bs$1~eA7x<GXv
    Q(cAlZ_^D+p%5D-$*i_1{5Z_*$sED;I<jlG2IUl^Yo*J:Y+H,Rr<ezwV#)W_lw{z=32z5a\iCGO,
    !#kv$Q?,]w#E3*aOJaMs5_Emj{lXvAHB7Y[l->+kIx[UDmJ{ajZydsBnnl{GU3*\'RI2gEKD\Vbj
    1\V=<zGO%Q/WO7eD>~p/>[mE!ep,Wo#J,l2GZ_^7OUCEQHZ>+5k-~]\v8nor'-A{Ix}5Tx[A-ADe
    mX-=;YXmpUCTEGO}J>5HO?]e]\EUQIja\}oC~Vl5DATW<-=!vg^@>]zljQ_m@W8G1Z}nx1Uos^u2
    '-R~rB<ET<=me*E-11rsn7korKaCeEUuj_2'@R];1e!KX=RrTD\~Q?~v'C_3U37pY2mrIk~+x+3V
    wOxBOHa)iA;5e-op}x=?E*3*;V3lk,u$+>v_{7m@*m5Z)7Z5\OiT?_;3Zw+K_5Y^U<Rra2,CW?l3
    [=z2jVrV1rmI'wDu$5@3_b\GQ@l(1mHXxJDnJCzD$KBveJG7PE-G#r?7]CNr+nmCuQZ^GA7b*=E]
    won+5{H!2ABJ'vH@rUU?G<m_m}QA4^{o#rC$x3E3IIwAv{Elw2XR2Vi'#3xQkaEB~7JYUv\s=KV]
    ~.ECC?jk{#~C<Q,^+=p+]mi>*>Yw=o7;xv>Y\w7s;Zv2V}^{!Or7srl?3J'>p$D1_!e@K$C3ZA+]
    B+>'mX;rQ-=KXeIQl_WozJ+$Hp7}3O$BR@,l5rI~m~^^Vxwaw]es#U#AEB=r1>{>>v_CX!^m^nPJ
    ^,7}UAjneYwjvB$xYjePJe,iEjnjA55^e1@Zlw~^7R1R>QD7G->?[!T,GH;r[HVaZ[u-kHY]=[R2
    {>+lG[Fq-,GHF5*DZhrKQnKpeTIK'e&QKI$BpI[UE>e@p_$j<G>VvzoBH'-J\?U*sZZR#,z8X^#~
    .lB~wzA2[0^^a5Q7^QG*DjbTHursC*HI5GVxmZeI1@v*O*uzG$ALV7_rkB,7BoBm17<VUa<luzEI
    D,^Ja><r=om>1\-Yok[wa]aH<o<sBu]n5!2-_?>3sHVelJrn=Q5}#rZ@']'*saT>O^v2]KrpQ**T
    #-<Q2r{e1ZJEvWPoZuzQ+pO=CwuEUpAL9Wl\~0<YB'AA!Ql:~qj<E+Vp}[J=,#=RwQ1+A~QHWo5}
    Y\*]Q$fTOoa*Zj*,1<lzWwo=@O_WTZQWA$<U-'pC'7p\Ya{}Wnm4L$\?uV2Xm}ujZj@KG?]lB+|\
    :#e1_#eji+E-Tv]s]=1<,E,~-lD-1oOA?'kE\$DIrE[_n;Y$+]zIZz<]G3TTs-op>5]{[E,Hz@C_
    IQI=RvnHA?+spIA<2L/;OR*GQ#{KO?=hU,n5/o^I-k5n\rp,*QW!<^m_\TA}\BI32AwBiw,x,1}T
    Qp3+uW1pBkI#>>{DO'G=Z}C#^^xU,s{V<JUT+=owY#E?R5H}VSXXo\-s-1&a$*H;E_{#HBVCXC!r
    V1!D8bC5QR-sxo8W]z-]@nT-z?1EiOk$<lX%_K3O|QRV>R_l2>vYQ9j!F?$;l5+oztr?EZp}V2I<
    JD$[rCZUn>x^l]?1;@r}RI<o-+m>+Vi-Tj-7sYrt0YxksQ=oH^-!a0%-,TONTX{A$E5AResEmYsO
    UjV$:la[Vp'~xk[G;W[Qe,wzIpklzYR5u7*G#]~Yv==v=!>+a3,u-#Y~<Cu!;a+l*A]rp#I!@o3{
    [Vx]UJ1x$5}pTxl[\A>Zpls11(;ri\Q$@'a,CT*JpX,\{UQ*zIkH,mK]]u}Z\Qi[I7R.GwDwaAVs
    1jYV/kv!IXsmJ|;\X#QC#}H]zipL{T*uUoe3Tz+T!x,\J^ZpRkC*J[Bsl2Qe7s~?usRXe<p+kjTm
    YveVEKO7q/1Y1\pw[,AD#u~Y7v'_K\$aDUUx$D=WslI\IKXY_@CivYW1T@YxiR=zWGa$UeXD]HKH
    KZYCmwDQ$3:1K[Dv5?>rW*ERO{^Te'GO'p!eil;TUx\{+5=1'\3[iaIWx5\m\?spwwU]{YIO-D_t
    oJZUl~,loDwEv2EKs;}r'*1#J*m]$_-AEe[2pA]~s~G=>[$DYuYu%aE}lB^v!GC=E8iRY5TjQ]IH
    RRru~s>5VDh1j}2c*mYXv;a@d;-rEeA-mYYT<x^{vYpVaYeVovIvnW+X7u5#+>x@x1_vwi6R2QX_
    \Z]h|'1JeBl;krx)Q<K\<BHKp{*,%#XxJwoO<!RXETB;#bX+]n'G@rex@RK+;1%O~om}AeavaYHn
    O~Jq?Y}oOITuUL"K$5KuTHA}AlexuXvU=iv[Ia2]2}33wAu7=7I0I?G{\X1n}+TuTa$>H>X2Cuwm
    KYQwz(^H!ATwA~T]vmfKw;7,77WaTl]Czim__wR#a^*i=\2@OG^^B'+-nO2~o,K,2ApxaKeZw~ID
    JXze;+5Tx>eYOvju*RI^pR$Q@1'@l=jH{^o]rvaG^1?<THQjs<J:T7XBs_7}B1?TD7JvB{sss+7\
    %w1p]_5$Coje>RaQ7Z\[x5nZkLvVBm;nO=jZaVDx-]6n^W<xTlvO#wUC}+!T{CIZ}2#Er-7JRlkZ
    IGj>[Jn1waW*}z1Kw_CDUaxj{@Os1o^l}?1{}O[C]j[6>-5*'1[~pZJ~sKaAm,B^<BeUi'2BKOpE
    []IJN,7{H^~ZXORQ\)OIpOdQv?!~UTORBiA;oQx,nAoD1#X~n5rN$~n{<Q+Z3j}@uVxDVTv$^VvT
    Z+5D:X>zxQTA@=rKAR<+3[BCW@Y}oCTZQ}n7;~,Enf5DHp~']ue-a7I=-IH_>{=2Dw1HXa*1R}^Q
    ^vuvV5H5QVj'-VpI[n1Zlk}V;R"-$>ZI-XVD>}~~Go<o52e+IT'eJC2GU~AB++pQw+e5,Apx7uJD
    U+IGR<;lDDa[zWC,>Q'=o'2[>C>7XpR*SXRo;ul}1B'_\CA2U4ga}V\z{{I]Y~u,D#Et=#3WZX>$
    .BEsVJB>'TI2JRJ]w\-X5%x!K3>\Z7U1?,lz#;~Ci]Z{HxbV=wm[seJH<s!^rz,i'77hw=1e$TEE
    !Yz,Olp-A}p}%'JV'v~uzw'O$'$v[sv;nU'}YzY<C\Cs]V;-A,Reo0"ija>Rw'}37G2~]l{Guxi.
    N4_wao\=u$1ABHY<<GlxH<^wCXT}QQ~j}@_x~zj>~zgR$m#u>;^}k{2?C5mv<1Kx_HH~S_C^U;V>
    T&VfliIo>Cj<^C=eiHKe~*lZ1<II5k$kWl+uJR*rE$mm>\QEW+Ixb%><,Y,aup\C?a1o3asTplX>
    XX7B\~*aH]WV^kvRX@RRoGHQ*HVW^xROU[eG>*<{<3Y3p32D$oV5^Dan]uo}OoOnj_T>Ds,=+$[B
    =H[f^W\rzQO2x~I@PX-G]G[oAKjX*<5E;lvk]_\72PeHjaLlwp=dV*3kl;@?Vx,YU-IO\z>XpwJz
    K\_!@nDJ[j=]^RIlV#Bk/>oWl'32uA+AlNIm[;]*Q<<=Xz,I\[(aQWKQ]>^
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#+[aHiw;oDwu_!'<\G3,wO7o]WA7'~RpJ[4?YT[B0-]~\m7WZlx<-D@p$qzK_O[?'r=W[T-U
    ev8<eXazxC[EfkQ'Be-e]iXa[zx^QI}VCX$sD72[lNW'#Zz1->qYI7\]YmB~a3[[3J<|9A9Apqk_
    Al3E;*\%~YGVv>v<g?$J2r><A2YV166H-r\;jKup}krGv7~*l[Q=3I7u_u}^X}W=eQ^1}XsO,w*o
    1V<!$\m?{C\2*!D~1#OI?<v)7nG*v-7mE$?j{v+<=HC$mCB]!=@}7]O^,aR_f=-}ni5#a8^~7aQ^
    r^v*V-BVu*usBW={xxeo7xHX3yIjOr!v_;x&?QDCKAXC3a>ziUu;AxCr#_w=o2CJW=*EGU[Te#U;
    []Z}[ZRoJ5!6Z=}1UliV,IJ$xw1#s,{z72Jz-$5sY__[g_jBi?s]7VxTCQxJaGW3QD^QTY;V~J'_
    Cs7n}<5Ux]nu@7-XBUvIld"?,<j~}W@?vBG-Y_zt;=U{a=5WGlDJ*+rQeK;xAe<H[jw7UB7]<}+=
    CpUC_^>7JD+l#zGj3xu$Cw@V2TZU-BQJ+=B{4"EkUZu{]JQZTOYA[[IE=VeHJenVjT\)+aYZwRT@
    pi{rl=\,g7Oo][XT!_C#-K5vl>RDjzG[[ess@$5VJ=HvACXTGlGSkXr~^zjU[piCzXr=v[#B[2jX
    x->2C]A]pV3!2osmOaKsRw,\wHVHRsE!e5W_p_-pRxV+'\pafEK]$U'Du}A*uVN=RiA%5'nwj<uk
    |MlJ72l~DuEHuCvrv'eO==$~numH'_;v=![D]?w'Uo@5VnB>G>DOx,Du7[opAAEA^YQCa~'BX@!=
    C+r@p}7U2KUo1Zov\Ia^KB-$=>0]!5T#{OTY@wJW^I{E[ax}F-7ACm-n!<[R7i+AJs_~D}RoxUj3
    a)]Ii#=r3#]z@2TC?''iapV$,xA-7>Ar,iYmB]RpG'|O-+C)513?k}Z<xI5x[}QiO3C;|]jQD:wo
    <};*=uN>zK<DKXK\;V$7XR;oAap*X_~JDz,j#Js1u>kH{.OReTv_~1{'jRWXa[O^#,IeAmJvv@Qx
    VUo'VKVG{v$\D[6cC/31]UH}#_iH{1"r*]@:^Bnz^>A!'sA;u<n1*73sp!a^d,wE~O+e,73_1\s*
    *earm\7-}-v$-)![T}skO,Axvl^sY#QV<#H^Bv[X]KRHR{qEEijV<=Rw$*ow^@>xs\a;VO!*T5J=
    k>*Yk\~vHZ^HLUCos~r-G;XX#@e?eRT\U_~ADTC!2JoA^J[#$/p!Dx5IVi?Tr!ieK[Z&oHR>mXp+
    (~}m-=UXk3CX~GK<{ZXYkxH@O5Guof>x#s?*3jfwCal,;jpE[J~DO@pO#[Q=x#W}TZr:s;!CLi*^
    ]*i<7A-nk~YI<7u^>pGT$p,#;=+U\sTR2LgD>_-7\<-*;Ox<T=om{$#lO]ZeUYi![xu]5oX@7n{3
    ^i7,)aw+Z,E;!@t[]\]jXm_eKJx[J@,KV<USlYToQHEpPKX2-}v@xlBjBHepEDy^VZR;jG\mQ^w;
    7w@!eZlDien=J.gUa,x]UuQ:7xKvkjGU!eU}]B2@AR\@qL+DY@Vj-pkQuvKU<QDHjOQU[sxsWAva
    D<Av]^m*;-T_57zZ-{5^l=}ZC7o*BX+<vALJ'=x[CJuBj]kJVXZHjDAg^~m^Q<TQYkY,zUY$;A3u
    7B<K1*<pz=TBj$\3e>zWGxX[~e?}e]Cz]?}s{,<sG;Q-w1WG^7*U*R*K/nRWauYi3;I{QSXBkuR~
    C]+1GYuOX+>_Ax-jAA,CY?QQ!5:WEEEDll}Lcp%IQTDRGGv?e\V2-VAZYvuYKCJsGkWu+-X/}s\V
    ?$-?~w>3^KEz!I"!]}J>{C'Ul2rQUj-wO;TGvJV+'JsZxvXVZ7eL*;}~<*Xam1]C\G<>V=Ujp#,m
    }#pKKvpRx{UT\-3E6Dn;$Bojw/7_',}}]K>\$uZUH<%7__DZ'~]p5UB_kJuzxGvqwY7kW_]!\{<^
    y!OGY_\xW<7\Jjx1#{RAAQ_+CsC^[B7Ue+,1!U=~^Hpa{>V?#bFW1QVcUvAka>X*;Y2~V}_@2l~5
    }sv--,Rjx_GY;_k]$-a_R1$k*T'Z=Biz2TQ>Ip_~{,yQ3lOTGBGY!{2RRHkVkx'D{uX?V2G:>qxm
    pR<-$a$<{>6|=Q$2e<+Zi,C}5@]j]spz<w@!UrK3ip3>B1s\2$mBlJQiXr\Z}e~QWwn3N"Hsl#Ox
    Kk\T}UYj=a^#CrU7V]YTVaXA\GowVW!HVHu^lupA7J+-eDGiwooR^}+_w}f]2,'5D?-5TXj;*eGD
    ?>CV2@<N1H[KyR]oIdf2'vTqXV]l^;$p%-B[!O-Y_v2IVsD~$GoB;9,^Dxo2<jQps7a<Oi^;e,m=
    \746a[Y3}=vIe?'OmsO_Q!mR~Vo?3TJCplOJ*u7WzCEI+sHk's+315WA_lZ~25_],>^^25Q2ZsQG
    n}?VHHsUk-mBwpx@]u>l\_+m=kI[}OKQXr$2TG@aIwG!~7n@#{=Wu{JEuBIs{a7DZok+Oj-B]}_J
    Wnm]!G[3V7w+lQ~aOOGV3EWYZDHZK1roZ<H<$}C'sYr1he*AsB-XVJDA@Ous]oQ_']Hu+yknj+}~
    wV=D^p>5s~[KjJ^lAuDDG+x#'<x1?>oK2!X7i\1E[T#^==^A{\Li<xCF'wau=,=Te-o\!D7WoJ]2
    ,3]ssHYxD-HW~IZA*EB'p\{55[nDZQYn'@=RG_@Rr\vU,u@Xx},x%p+'?,vRCVsaj?V!v$]]m<Ev
    {>T,K_Guf!<D^e~pW6\'B*WCZ}Go}Ho]E!7\xT*~KmkTs7K$ZZ#|~_1D{\CETOz'okH5@}]vOwjY
    @nHY{,*knlrTiGNnr#W}pW,-UCYEjQB0'm<l?]$@'!V}{rH@7m@nl3uJ\A+s!V+sCrn}x<*u?O2w
    \#'n6J'<ZGdp+--'ZXBBQ1~A[?T<'5p*T!O)5EA?o$Rwl[!lljIiTvEVVvmCgvm<xDr'H=/#V[CI
    ]5wrX^n_QaGe2=]rs3u\^poeme<TH[5a=iH9'e5{?B5;6GA>a7lm,AUXA73YC~HKWl<Usi<IHr]Y
    R]3JD'[k;d}>Yn4;<z5l2O~Qk5oGiGQ\_zVno>@)jrva*g2=u_f2pxiaGVWCGspa-V2wTT,3}+3B
    ka1qo=IDp13$'OvvRoLe,7\Z<\+-oYA?oz27CXu5mV;W+^~,p{n4RIa}0A>1G_a\{JIk*Z}m;+5l
    [{In3{wE>~e{Ugg$soYQ?DalU{?KlTzjkr2R[sji6-CW;wU,zB1^+tG>p{=@@;DErjZQ]T+a}HEO
    *v7_ijX';W7iD~5<5Q!<jevB7[A-[,mIGo='a?jmC16^Z2Jr!$HiaW*:d$'>}jAs^2[;n<T}@DJV
    Aha_\Kxa]^sCzi3e+R_7D_@G^,p>JEwHCaC{ZG=l,$nD'3vHTpoyRm'Z@UD]/$CX*7a-+jmXnsAl
    !B+WO5+ok$,OKp{s#_QXJ_~U~vzlZjOwj:ARBxr{DT5wQzVQ_++RJCyE_mC-pDE[<usTHX+>HOmR
    @oDT_GV8#$E2ODAoQj,w'=Z5ppa3;n5U}<CwGsv@>CY+=_WnTz@7X-ID]jQkV]BBJh_#XvK<K*Xx
    Bp;*D?i^7H*u<omjiG)_ZaJ+A$Y_njnGI'1eO2w_Tv|>,XE\31;=*~ohTw@[JQ2#,O{7g:]G7nla
    [*O5A>Jz]HYj7m3__Jw'In|z!vm[{pID!@zY^*}[3TY^7oRi\!z~QiA{[+I]Q1J<5;{va+C#ar[B
    ~$sWx^$#w=w@C{-isiVJGuve[j{+rm*E+[_Pe71C{op'W[$]VC[GO*-]\*W#*V7~jK{_X^QW,IuC
    ^BOJXr]^JI<Zo+_$q\1U}QJlA!Dn@iIjvu]TC^+OY}DR!,Q-?2Gx-A>v37<x,5Q<umw9|3^CY!7C
    r7E_KGwHn^-2l*>VD,e+@7#<oW^2X{Q@e#'H1^?nrdp,px>j#WO7mn[1IeBD#sEQrxv{jz+CVkIs
    lGHznlPaTn*mXv,Ho_s\DkrO5_T<v5Z7j,Z>xOKr25ie]-<Ja2E+Q3pf]}Pd5?{w5K1rsJjJjuYY
    =lwWs\=JV}GX[X=+sueGQm{Q2za{kCAQ$lCKBbe;1+RiDB~$vu*X$Kp$-R1@Z#K,uU8-UJK>U2eD
    -W@vR^s;{p]Rn*x'\XkmpvW;{DnD+H>RZR'Y8"@\RYHxa5EkDk\\W;}2Akx+^'lZCw_uWu#{5uCK
    -s@UT{2X7Ii$rRpX,_r{IrjRl>OH>+4<tmAQk%ZE#ZiaTKR$*DfkswX3z\p=ZT}?tJER={Q5K/:U
    [-G=e=w#U!JA]?{#ef|I~BG\=l'IFXs*7f~{5Q~Aaao3{~EUHnICmaq<DzCX*rx>n>5+R[jIx#W7
    >A+sup\C?D,jIv~}Gr^A_H^,Q1Z-CWIIoVRQn{5=I{unB-VhxD}<]Y{Y'>,$Y]'rHQXj-vKX?O,]
    A7ZHzT$Ax[iGm=Bno"!hiC}BQ,+U{l+YZ57V5eZ53GB<Yb=oQiDu=+*jJ,TwpXlH53_YKu^C*pD*
    1uIHzV=d{xp{oo?;!xl_<hE3x]wBm\M
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#!^OU!5,Ef$IuXt_z]BJ>[kd%VG1>3+\idi'N"5D/Z1\*WlkU<+m]Eg}k7[G;\$3^A,sZ]3}
    xvk=)_rPlwJ#*+[[o_n=['CW!Ul$HUlIH-BA=O#QET}7]3vTmh)DV>^f!$u![?ED7#YEp\?[k_Oi
    4ElC\Yw=$=n2Enr2TAEz_|k,Ap8V4Bn!W@'+\vjm?_ZzWA]@sK+mp='_oVD+}$}[oR3,#^*1X^1s
    #t]jJTFN[ZOBuV_p9[{O='oBC4VLcAlz!@aR$jw*+lHH7O$nrKo}2-UZ<Ev1leK~#AVB+oR>SpQe
    u@U!B,z1\\wjItiw,zW]Gu,$+oJn@mSjo5wQQR3qZ=HrR$nGVrUv*W]*{X-O<Rn<.P{+_#5{m,ie
    m-[l2'$}iBl@O,!5'5Y]knCHp\osTKhvHDvTY{ZO+z[Xe+-0EYYQ}BspT-pu-A<T$?[u*<pEIC@v
    U=Qa+Q$k$XX?7!OmKe-v0DkZJQa2T8B+*lxCUa._v<l!E{lCHomMkUvJ]\^_v~Q]$CID+5?C=u3o
    p=Y>72vaiv!^?_3~#XBW?Q~lm}X[rEw{+pY^E1#pApUU14c=Y[2}^Q+:x3lj<SBi3*b$s*QVG$[Z
    5uCav{]kn{viRWx*jx[Y-I[H}+O-e_v)NO'jjp?\GYo@\Vep?{B?^EwHVzIR=DRjY<'+=(u'Q=X-
    Cr1<*TsI}Q?<pEl-<a}N}@R$=ZwJj1\o{e>A)z)!}$1![=;^OAD';mwH_@szRCBQro$52K]EAQAs
    wB<'euClk5poG_]5v#*NJGsXsrQ~vK_J7J>Z@7Zud5u~jqEs--=+Or[vr?*1WZ5p>Zu]>\WC1n0{
    >Tn@*@=+oooiG^iNl!J@2OUW~=Y3oQC@9D1DXuj'7$A'{7ekx5s#ICD]G0zJKDP};o~*'}?[2-5Y
    ]Drm+H[)esuxl+;k|Wv{@o.R,JH,vp7ae7<^1]C&5i^D~,oJD#[7yHaG$2sr#{]Ez'UO[URO!JxA
    KjReR,,DVxemE]RiDlrjR5n~C;GUJ<vwu:]DD2?_BI~'UEQo#ook<;vI$JwOwKh?Ao~X$]<Z=wBk
    ozBu5ZO=we{mzY?[z1>l~~~C>^=uI{T;'ZQK]OY"[T~KY'uCoLKEOrbRxG.JGoT7K3HlT1k'=+$2
    rO-QOp1$Vu^A^2BsK<oCu,rcK5KHG2C]VvWw',OlK5,1ZC\^Jt59KX\T'TI]Ao5O{lZ-'$<zU7!;
    +1GU%=_vp~7[U<U-*iX-B5e{xl-C{5,J!sBA1j=o_iU[~,G#7-1@kX,_l2BswsQ~v*z;@#Uu!D<u
    55iD<_#ZTA[Rz^3Qz7Emr6X,j=pvOa27a<VnTTs-H#GsT\Oo7oH,X7*<-IRB_K>AJ\DHOBwV]s,;
    VH7{+;E>\ef2,e2o\TojX];],r;L'aV3fRamK,{E]^sInQZRQBJ;*jHv?1)x2WlxUQa1IOo's5Z#
    <R-Xp3x}>v=g5Jura<[p,-In;5-DfQ{u;Gajr5E+apx7~^3]$l{JzAv2UE-UmoAwe3>XHRooKIY=
    W'r\,x3jHekOT=\?K5E'BOOr}XE#]'!jE6H{_*GT;[JT$rvGuT,HuVvKJ=(1sX;jw*T_<lv}{'an
    ]7W:ivG^RhYjuu?*!}^moJ~GZ#pO>_!oW=Dw^rV2[]wOBT[g\uJsv~5z>pV\w+OCk>VTs;rpb^AJ
    *cD!-upaj#4Bz\O!=+odQi{*#X1\}Hr*w-KDeiOK$$,pr}!+cI<j}_@VphBw'KJQ'3_X^'x2@B=-
    _V>*H1F@,ZJG~TT2G~ExnaQlUD?*HKWm7T1ZeHo;n!='iro{UWTZL35v}fB8~Tn3GKH@xlE[HpG+
    ^~3V,rg1QYwwDOQ{rqO+-re]aB'[!_O.(k,TkQ3>$27sDD]~\vwnZ2G'm7wUD?'<+3BX1W<xzUBC
    m$'Rs(OK5=JUI{jXORk-x<7!DWjw7R"eOA!nT5GGTe[\Ee1z2nRkB<x^vOTX*5J+Q5I3^mT_Vi-W
    OivS+>vX\n@;wr-v9,eDR[G]?Wwv,i7Uk;sOU>Eir@GrG<H}rk$7vGU*ZC@veeE-jE'IJ'D=Q1+X
    CC#I7x{3}B*;Btoaji]B=TkO'H!Q=v,7I<RHJ\0GE?z3ev[J$xWJ[W]HXw#15[UWrpR5i]eDWe5B
    CA#w=aK~<_o$E~Ev_^aYrAOip2[wzz,~X{~jO<?clV^lU}"a-{GuR{[uw4yUY}o#$vll+Cj{}"xw
    ZnB+z;
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#,IjX~Y3@KXD7/#s1s,U_}*Uo7gg#U_(|)a9p#^VomHU<RzE}1JW5xOi.@TCTHUC76=lGG*_
    ;+<'k$_rPlwJ#*+[[o_n=['CW!Ul$HUlIH-BA=O#QET}7]3vTmhmHnj1{<*<<YuW}R^CeW3CPUwe
    [V,OlN3,$7Sit{w}x2l,uW[mkH>Wx,j3!Z_HW}+KK)-7Kp=QX^V3KlwC?D[.QzARa<*{:<lTKRom
    kU,~#]Ri1-eQ_pZzVin2}mX;Rb#$ZR'?=^)y7aG;I]jv'5x[*o=mx+'\~VlWtiA2592,BIQ^_BQG
    p;p#XaxZe*#YGuzDW!\=~n,xirp+O-=@WGZ>Owx^7?Q#**]@$v{Xjipspk!=}O;x$'#R327p3m|&
    \"r;U=h9e{R]Uz}Z,^?@v]5=j@DZ4\X5p'jIYt&?pXTNo^n;cR>lO$W]R-xjVajT?UvWDr,C^B5z
    xP{_][;GBw*#Yps$o$.lml#[YZ>Gk*QPjC{xp>x5}r?;Zl*]C=_p#5Q-Vn@=u]Vo<AA<HQ>2M"o?
    K-HT{Q3>_oQX-z+R?vuQ?QVfWv3!Z\rT[@$TxIukDtIUWD{+oYs{*Xjn~!GVBlE>\r@R@CsDi-3w
    U<oTD=*Av{k7rs^*piLAAjn1-{#rlK!Wp*[7TElyw-n~BrR{KnE=RBVosm=pR_#wRD?QJ_jYi$j}
    aUo*DQD>VCz[6OxHA[A[2#w=nFzQBrUY#!>[n\[E-A'C]{?a~ILIJ\sT,kDD3x]OOVY+R;B,v,^X
    [iVB\KDe]iV9#zp_G5[;]iXojQHY}l!rE'ip"s2Yi\V_E7A*@55=TB~B7!w{K-5k_rs<kK\u>7mH
    {Ir~TEna'YvV7:!'{3\We\,[+j0xpx3->*3ZR2jD+K^E(R~7#V}Vm<HZnW}vRKUhe;Z+4STUj<\n
    aV=i-Qi{{Os~x@}vX1nxp$E$$!XjlJeWZR$3V5QE\'xiRCsBQ>>}Densx$WwVorQj_+RG>@]iZ#-
    X,rm!>&xE@je}K;Y+Jl!-Ru~7[{*uH>JHG5qB{wZ4'uKR}5#pA=TQE*XT-67ax^Hrw};1E\1H}Z}
    GA?'RRi+a'2KXz'u[>]oWA;@UI*Y52x~5D3$J,zW]OxC[Z'gDT<?r#u\q4]-7ek1\lF'3mXH[\V_
    Y+j\K,-lBx*BwU$='arTBwoKE1$H_l_?DwHFdC#K*vJnI'0YupmE!]rs+jCc0.DBYi5a<,HY+5y]
    CUZAI\sZB?kA}=V8hW7?>ea=lE7pm~Ts]:]T!K<ldl$]7<>Z>I@Xu$$xOm>rjr=3Y|TB5-Y[>e2_
    pYjp*l~Bp]w1wYI;<}Z5+xz=_V=rsoa_Iz>YJCG{Wk1eR!7;lU{s$CVsmwvJ$W}kUk9[I<7H_Ren
    1Aj_eRC*?HmE*WXeHBoaT]>LIJ{mD-Kep<j\cTQ{;'pzl;$Az|_oTuj*LOrv{<BxG_~en?p!mZ1O
    ]&H<JQl@x1^WX^?C>-sxKl,2UHC-\!pZI]sYDo^j@m43<_W6C5?#Gv!W_>XZVC3Da}'_uABu?B#'
    ~]*]|j3,C@nIw:z>KKO;lB,oV=Y}'i)Enr{hH=,^TRu;Hw*[=?GET]XQ:]J\X*3}uEYk+,#Amnj-
    B)'XZ;'B,7alGIBao[#Rir#]!#$<[V[~{BrvDk\O<,I7_e=X~DOKTv62Y[By$OJrnvRAzma[-OeE
    1DUr5xVJ]x>T'J^{~l=uetoCkV-*U'xZJA;r^['[XeDQ~J<Bz^p]2+mG2Ou'oTjz=iO'[][BCs7U
    uwP55-k-x]{@7o[a^\v_]UmmQ[!1{DYAq[7}=,H!5>l_po;ZT2{s,*_5{C+I$%r@rzj5\izr_<<+
    {2l=meQ\'2H<DnG3v,:}w;u\Un[_~<7u1ux7pmQwX*,'CVv)'z5?G<[=r73Iyt?e5,3to@uJ=Za\
    -p{7ti,2;ZD;m!5iCW^Evl3G$B2Uj?O{Gb/\K!>$6_;ZRBWpe}expQ3u5dHxzKeu$U7{E\2na{;e
    ~uYoxY{o=EGsE<<$CV!C-=Oao-[n*^_D~Ku}[COxeYpe$U'@H$uVkR\#XHvdur=1Dev=jER@?>3U
    m_W*UA=ZBOwJ17?Jzea2He^'Oa*X?$7?r6~$1z!aZ?DA=}]zA~V>VIoo~x>DvArwe?5_><+\W3V7
    l[;CEz,\S3p!^E7A!@z^7\-jpABWK*z$I'l$I2$TJIk-xMCs}T%D\Z'XsV>~RQJREj>,saTU<-[v
    *<!p@Xkanv~6cU=AY\}X5Aew_i<VY<s@wWUoiWln5Fk[#\2]?r5H1v^F$$_VV-_5GuYsPT<-x[5m
    A_]J*K_jORZ5wBZ27E>[lu],G{]H1}jQk;-Ts,$IZk'oI~+BiE*11aCKp~G$R5>!E;TnUW^<^5x!
    $z+$A1InTAQX!H,w[j+K}w]wCxl>>,or!SOYr}Y>1-na~x4v~7E7saZ/rEZV-5U'^Tev+UE_5m{u
    p_UCZGm-OERVar[2z>\_7R\m~*GV*2XH=Hv@[pl5pL1x3WuxoKr<]!ei-r=Ju#YTGvvD{15X<!j+
    Io<nw!=H^!DiA?a'J?xe1M{aRU^JGWQ9p@aw2rC#[1;rR>65KTmYEI<E[
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!:XoeI-l[I:JBO+iUr5jzxVwQ>aj3OaZS.Qn$[LYAWoR5x,&OOAvfm^{a-xi;8:K7?$pQ+K3X
    -@naA'vjk}]irz!w$wIi@DFzx^QI}VCX$sD72[lNW'#Zz1->qYI7ppYmB~a3[[3J<|9A9ApA]K_-
    <?s\;UoGwaoJevH2koDQVB9Z]+XZE<YsuXTxmI!i\XC=3I_93psA*}He7;*eXBY^x57u.s2'#rQA
    W~+OBsh#YRp{ta5U<+IW![T@x+x{,~DZ^WVip~wDTBTUHknEEz{J~HTA#5D@+G<akXe*i#>B_ba{
    17=*A_=CHYoZvE$e=oB;2w-\7r"ajjkBI!+N+lr-~T{_'{siRKYozrB~|wXjY}?ZYSmji\lI{{\{
    e~U<sQ@Uwe{ezx.xx+?'}Vvwek''zH~Qk]s$*[@=iO-|k9B=~z!\RY}lH\T}pYHsR*r=oBwQiBH$
    1pE/=AER>n;#!Q;w\?_<lpH@i*wDG}HBz12-,O1UipCKwoaX]71oXE=j~_[5wj!vWV2j{w_'YTH2
    o,WACi+u_CT#2owDG*ZIaGe3E(KTr=^i31REZX/ZD=d"C-!$^dC]\k>Dt#>Q7:#TQT#Vf4]]5T#1
    X-'+AeIiQx$l?HxaD-oJV7tRo2T93G2}xrCw$s[eE$;WX,v2;z>#*cE;z2rYeW'=73pU+CH[n+u-
    JKyl~$mW\[wmBpGY;2@aYVY*R>W'OCs>Ez\GIn<%#X+oBlOo_V<{]MCZAET__ZAj[T+[oT^>UuOU
    o=LUn!}(C}?XB<=}zJ$R>UT3hn^Zl=>pEVI];zDD{A,uRgIJ*#}z-~XzvnViVA<Q*Z1>n<6mH<2A
    s#CFojDGD;{oIx[O1[\Vnn*QJ>Cux51RB_eOa[^[o5>!-C^\WxCGB][7-<v[]eTWB\@32Tw-6AxU
    K};Uv$Uz_zxm2n_zp[DHrEqp\{{\2CI'65Jo^nBET7{^HC9A=IW}U$lO$#x,\G^(jaE-Bvs!NeXT
    \DjuZUAEDOK_\+^x=klr5ouY>YxImH+$Z^;xA;EuRQ?]JoQB2==sljHv$~XK[15x{ovaBaRrXG]s
    x5#d,n,m{HmahO3Z^7ux<~AlRY-DGG{=T{s$oO!BDwp2<*IWKVx3;2z?'d]x=}j}1AYiO#B-pw&[
    }}lCC=j!HnxvFIJuo2BEGCz-!!s]@=^+nE8l6^kZk5j{!5pz[=~R*uY2CE2Waus|r@7$wGm;J<
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#ioW2?Be]mC~Afx;K{#=zln,x},5$Ce21i$3ez|,3*OxpZOjIo]G~$^,,{U^jo;e@e[|j;~H
    {}n{<IXUzxC[EfkQ'Be-e]iXa[zx^QI}VCX$sD72[lNW'#Zz1->qYIljvY\oyjJD!l>p}aDV~F6I
    ZVouXW]6aHK'}m1mC*R}VuC[?C>Ca<}31-$2lKYrCsIIa>C@>{;A]w@u?R[?]\1\h!=+-JLEU'V7
    )v4YARKiT^iEv+?0<Hek>-a~7WzRB5l{a[D<!_(HAW3KwnJUazW]!H+Ekr{7'W7zd$B1WWoZe*37
    DZlp<D}ikX'_C=!~oN+s?,[2D]7usQJ+KTavW{\;!U21IU3>x=1,+$25u1^H;OC5-,!^_}z7i17u
    B2]3z=@'R](2pBu\IAsmjwDO?wj$+}73Qs{fnv2rKT,K{o<Y>EKzYuK[<GYxs}$2D${]a,rXXl7r
    u<Qul~a=JDppj>rY{lGG}l~QPI=@Qc%m^-H}J1E-L5T1m$YYAEUrZUC<?0,~EV>_Ia<[O~=JvnEz
    jA#{W^v5Yur,Xw|Ja{Rn(_7#TP<>1#~{RR#nRV/[Y5,-Iea\1,ex\rZ$K2Gvk=ikjZ{wlm~E[{G$
    Z<o7>mZqirV<-[0,xZ{o^RE_@oJm[_xE=Okh=-IeU,1u>'\Kr5*<)#jAp^H>1z^2=s'm^P[\7sp-
    7WNzQ=etk[3YvxZ,}rkZKUEB5~1ZTR\2'gnGx,[\Iof7O<B:a]^~FNlT~YiH}}S7\i7C<XYz?z{j
    np[6EB$a=aIklEwnrOVBDR]$xI,EBwTElCL^\k{rvAjW1~o-\KBlUrnn'TAHDzWZ{w]81e=Jwx^U
    =VAC<^KszBv7],$pmOlvHO~$#TrJ~[W;Bm@{Uw;XB-HJ\e!ml2[~2T^Eu7@@H$W}EZQ<Uzk[0[=1
    '1i]uE2B;5n=,T1HeG>]BEDl;'ZrT1gc.Rmuv1W,3CSVEX^~5e@6j'YpR]BYI{J^aB+'GEkwL55x
    I?a5>^zV?13A*v1<K,p]'U*'eqUYYXnwn5OOomRu5\.}*lix*W-neik0Nsze=iElE_B!R*~=>~9O
    oIj<EJGaDV]JN{ps!Ltg^fiXzBFf6'I/CY~sbEZ[p_#DuYm+IpjI!Ue=]^T=sZ$u;*Kon[Ipw#'p
    *E'>BVO[O?=GwUz>Rs\v7I1}I;n}nVXjZjpVVpZaoqHo,U',^V}CiQ|mY2CFCn@V1+CrOTjY=~fe
    UuDWz8\xOXZ1G!;T5[}NaO#CfA<RoG\xKUBG_z>a$QiKQC^^,uxXJHH^}e1k1=;7njUHe[@m!X{x
    n1*U\rZrQnq[#evx^1JK\TCz=7@3\12>soH!zmH\!T[K'l,l{>KED?]2<viBWW17XTetkw{<6^>x
    omXv5gwUnaHoj;9}eix__I\/7\EmA<YUOpOC(!VRRu<nU~>3CQ+<we^Z~'xZ!@eO=HC_>+=-2^\u
    _L;_5Y\^1WRe~5m7Cr\+K2->G2C@YZ{Qi7g&2QSRQk=ecE$mrv|mDmQAa,u$*Y>Q-YkQissZnE3n
    -}7?='!rHJW=KwX_!--*zVBzuev7**n2}NeoA=(X7B#T^Bx_?lY[{H$Q<>D!a0.C1@#U'kUr$Y'@
    Go@j%ZYT!K-7[N,j![mDvD!B!wzBlKR$$[_T_*Y?+u}I>QCx=$sip1<UXUBpkDnne[@1RxI>1RJj
    -2=w~@nBl=e~Yrn{A[CK3Us@[xkXe2$-2XB+*!-s[12V3[)$dZ]w{\2}[^xZ>T$KZ1'*Q-X\ROQ\
    ie$]]R=u7'u2um'EjQ]TaYZ7+]kJnuX_2e]pD^~D<<\7C?w@\*AHju9]57-}G}l-VE5pCjlsV<BY
    "JA-knEpuE@V7je3usHUE.5~QVr]HmOuD?YYBo[_+R\'~z],@U/Q{!>HnR-ZsaT^<<ua7R#;CsJQ
    ><Qqnw;>mCM~DiJZ^^*g~w'T=V'<o3W3x*x$L~={5HGEe~r@Rzj>ssUe}aRew2pvx,^=~+e!a=ZQ
    IX+7$JXWKn\v^~>o[sYrA^_[v&Y}_~O,2Yx-C~^;~[j*QHG,B,!B?~]-3C[XmJB'3{B?T$5;D,mE
    +lJpeK}7[K1uz=G}#{5pwzOTDzH'Xs1@7lQQj7JCX+Q^{xxZxaV~!sQ;5v5HrW]]!oZE{1$$$JJ=
    _mr=$1/r#mmcVHADV+Gu}>rTdoXrWrJ>G.V}@e\ZYinrwu-+<IkwA$VC;eW5+*"u9;Brp}2>W1V$
    ,[7J]OXK>o#!*]-m?GU5!HQU;H}r3YC>*'+r}E<RZsVV!xs\R]7wH_^x7bTnKmC^a!zzY'^{A#?s
    ,-#>~TM!Q,!r[{^OI}n[KCeI]*zazmKmY3E?rr-7T{HV${~4H]7vaX1Cjrz3<=+{CsWmY$_<,N?}
    #-HB?JWxi~\YD?k}\~esm5[3m#nCDiE3{#=JX^/o,O\G'=^xK[jlRXW5UJT*$TmGamkvvHR5]_]D
    TE!_C#$)_se1O'{s'u5iDZrKy{wr}2*R$$o1l};BI]3m<,x*kpi,]YQaCS,2p]wB5B*a{@<-GW5_
    OoO1,xRBwe7@mU>w{>7Rj@sGZ{)Bf2XpisB[^jh/K>el#DzG+O~,p7v!^A[U3joWlWB=eZjx<+aU
    pajuI?epxU_!R'5W*;>?EBBnH{ZR5-wp,JHw+nT;lJ+^zCw{txZ'VK-e$;ImTCNjG^o{D]G}Ezr*
    m{C,m++_aY5rk$p!oaOmCEzk<>B#wC]7_;55e@BjKx>;A*5Vp#CY^mno$]Cf]<^\-+v\H^AsGrWE
    ,OIT{_[elvnaOK']$2w\CX}Gn,T<2+'u{l;oMQex3;Ra_k[lH#='mbpV$KK7x$}}@!<'<CU}D$o<
    3@*iKW}5nX$5v^eC,V\@T2rZT-KB}@nV;;38'TRKz5B>QG2e+lX<BR,Bw1KCIuExkX3Ri,C'$VE$
    gZRZOBA*ps*a^3DZHTs?Bv@DiMS5D5W-A,+XD5j#narv]*DRiQEsaQe@1Kv?-n__7eo}pF@YJVJ$
    <Q;w]=vwjswsQBZ\3as#l#V[e#C$'~X{nGIpK*B~T_;1!J@RG~WpkKW}Xs7$[1;_Bw-$}O!5kn3X
    K^n-Xn]}Wu*_7$E\1uAExTvR!Rw^s$z^?Ko1KI>,+_r]ZW3O[Z=+Zpl[Ze]CT,yUE=HllCa+,1OG
    -J,6+n\V,mmTEzwoEbx~nYL?Eiao/e5W7ar=l"2,x-ZBWDxsl]WOkI*5ZCVk1nPE,ll|cw[^<1H+
    WjAu!,epooqYD->r3CG~XO^nj>^an&Yz'27?e][?]ppam{HIl$@+pCqUs[ITs[l*,2l#C<Y[+$mt
    Ej\'m-]*pA>@mI7z]1{Ou},-aCIGT_Qcys5;2l13>O$a<JQ5;1xe[6sYkr1Q;^B<$TRv{eGml\}n
    ^Ei$K=u7QE}3XGQT*]Q-s!V$_p5[~,_Cv1$wQH5[m]UXJ{rlDX\oua=w=G}2K2AY7*x-sQ6eUp+@
    x3nX_A\xKvW'z*~Q!XBO~GBc!-ps*CN<aV-'v@={GaI*Ia*#s_H+T[1)&R_?C%3\G7D_$;\G*e/#
    [OWZ\O!YGr![[#@j,W2is<^kYH1mTYOYZ1mArY?Kw\Xw}IO]<rBUG@1wp#QR{QRCGnnlI\p8ve+u
    \Cx}zK\_rX1?7-rXC-}@G=XUDT<s,2Z^+><Ovmu{1p]<5=KV;-xKleQT_{C*#[^o3-ETxBli!G!H
    x;ov*>aEsj#rxI<o<T}kn5skDU~T<{_X*]s*5O+Di=O<nn$T5A-Knea'37~JWIxZ#TD+C2Z\el=E
    [RC=TTC,?,+YTGw]gR5uX*+sCk}DoYO<IE=@Ij]KJwIEi3T=w_oT+$We!2*E$G>-jjB#<%3^ZVBY
    2*Oa[7p]KpI+m{DX@-o=iH7?w7K7j~yxa1Zc_i$,$m@YSoZ${S<AV_RO!,yBsi-j;up,\p==I7mZ
    Cei^[k!nAvW9HnAVuCK_H^!>Bk7?Ho$U*E5j_yw=~~wQRZAHoHGrmx_{EkYZW>6+=prT_mRR~E'@
    RI}kB=I*A,j,E;Gw\V2CiH5vVBOiw-{=ViBK7E3<[@=[Y=C-Ci}lX3YQJ^#;C,Tk'#K^S";Vw-R<
    Cw7RU?!Y\,<DOHSVqIaB<=joJIB3Q2Ba_vZ1u}+XDiez}@EWp'*J2TE-;$Xw,UBnTXe2@ns^Qb,a
    V*'EJUi=DYG?Br*BQYYaRrj*E7{O<X1pa-Om>@=OiltxJnX<^HCN~IzU7Ei;iYwQAj$$e*D__>X'
    ;HY3T,ziS1sX$\j[jDDRvI;{OZ=^x#s7*>]E7VlexQ+,x@\kO[5}7,~Gzx]Z>iVEakQk22eQEYQT
    -K[*p5jDwwC1{_w5\\u!~+}~uLp5\vYpC;sm<!uT~;D$sx2[J^p2oUIsk1lek}\]zkEa_!#77[_A
    ',-1v}vv#'=]X*=K_7s\@Dzp\B*e#?eu2XnGkK}IW@DH+Z\B\U7j7@SiR$G?]O;rUY!rwVC*~H;B
    YpE=>OWanK?51UK@Oip[AA]p>reJT\5!'n3*iwO-lxE-\?5lI5HwH=TI1+Cdp,{#dTQ'BIz;^Q$l
    U=Q5euV?GVe>p5B!Z2Q;p~+so@T,z!UYRHQ's7sJ-8-I{R"7z7!ErR,L\#s@6;nTU!>OE<O'EQ7K
    r\-oi)AI[<*Uw@@EXvT-Tl"]Q2{zOj#W^$j7HjTsaBsaR\<nH+~wvook*z;sjj+p$oIDWOAm|IKE
    2NY{I1GZlo7{3mVH2DR+WE_~XTKszal3VYs\HkQxW\Wx2B\<u,K>Uuw1x2<U<R|L\_E}?Xoi-H!_
    =$+$c4$Bm7*H{K(e~E>-,n1>e{K,upQ><EB3Q#EoW@VaEQ$->-?u]'>Q#J7]EZsZ=*Iir>$!YH[m
    5iI*ij?ZrInpM|JeJ=_K+@wa's^_nG:W]>v3<@ne=lkOI;2:k755f-'G^z@zZ/~,5Onn^Hr{$W'+
    {!ggB[7>V7pGaQ;XHla-$u_ASsRD=IJ>COK*Rk$OlYJEe{_3E\vZW'Qlz!vi,RJl3=mKnx@*K'Iu
    vsu{KNx<K$W]#Hm{B}h1*\w61^nJ3^wm}uJRkr;#$=Qi?=XV{C\A!O@IoV?~Pe\U[\1{0WT+~GoQ
    vw-,JER-D*EvOoXA@BVo}J1{~6/ejx+A>[G2Rik#\1_I*UUvA1z}TOAnXe\^UDAY7T'n$kBrWX1s
    o,x*m2xoD~3X_H~oEUjy&#e*2R^J;<r+\GEjv3}kmY^QTo;5I/'O^zwVK@W\Uw+I~?:?VY_Xe,Y#
    >![;1!u1A'2O%"jJvO2+pao[D4JanCpJr@r{B[9_C~>'^n*.*#n[_K+eYE1[y
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#^j>1E[2{OsC1RXQ#k>D}BxEn'Cm{WGWI"=Zoe="j!B5,v52GOPkzr['Z{wuDUlkU27'^5*j
    *Cu:j-ns~{BBY6+1$'Q,AmOoXA31,['>Kj^-1V-]3]_7[{j'?zs?vm~-~JVhI_\1E$;uvvG[,uj\
    [5=oHonU=WF|d[ZBBg''w7Z17;x,u>]koO\|wUer]]Qk@=#oE~CoQX[_}Xe*y}ysm<p[*oChCwA5
    e;uvw.OO\?*<Cm?X@7HnO2TUo-i5orzjax9)=zz^}^pwEvV'X$V$}#{Dzr>HzT+[@<JCvhnD~<nj
    k~a=uGErW1Gmae3Ro'HwrX0(^rxzl_'>na+OCOH@!>XZ>D>ZA1u\IiK]~{{}!E;luUJ3G-Z5?,xI
    JOApUTo=je5TOa'J]~D'=W^H)plWB6}]3D)1{j\Vn;@iA*W}22@>1l-=l-H#>\v}r5<\}{a*5mDk
    B];Yn}}GVm@@51K,Z]DN$u<_eOOrXs!YKIZ{z-n~^Ue!2*k1_k';>TT>YZ;<G=?-BwYgajk[l1K>
    2^7YDI!rpekQZDR,eQm{OAK,U+RV1J'nI<2\*!B}e+5sE\rK;[@Z!V_O<[H_S.nX,$QIW[!rv+?5
    YT)o,>VGRZGv;~Y-[$<QwAW>sA_X-a~IW=u(E?zOI\K2'Gx<;_l<6KoiG}ZY3ms'#^><oHRX,W}@
    I,[HO7n!]YU5K\~JUI~jA#{xUSaD?Klk$+[+Vx~Ho+j,k23I]+%Om=$"--3u2aa7He+X@=2}7OeW
    C2~^Liw-3[ynT,>GY-QYu3<+Hu_G;zi=vu^#TG2Yrk7o@1Dp\Opse[]>IE[,Zw^z^;57e->?x1U~
    ]G[YB_;jsei1Y?;+rBxiUn3s,uxtB\;-hrp!ISV{la>1O=Ym;!jRlIHHwljRO-1=W*yQG1W'JrV\
    }}$VR#xmX7[{^A@.'Q+!2w-v\Psz_UWRex=0zQ>EJ>-WQ1WU)i_TI1'uK,6$zCkDw]H~,RK-t>,]
    Yhz+7$N3Czp}r-wFmlOoB!&lV=>;T$7r~}Xe,Qz%hFNo'X<O5vkJr*CtBHzT}K3e57~@$+xmU}17
    [3_3=nB}jr$n$B*T&WGnwezue|lV@rZl@BgRI?ozBeu\5,Kx{];>{z'wa5BZ'Y,)^is'lm2nrT<_
    l_,\x*zj$+In5]3G#avldwasD}4YuA'RvB]B_2Y]@$RT+]-zsETIsB~;vo_7K}p1*orbBXa7l1=Q
    =3>uz7nUeeB?Z5GB]5Xsa=QsTxn[X7u'ycEc"lIBYvX]}<Y!Y}-W=92r-mqrOV+lGIi'kv1uEK-]
    }#]oWY5*XVWVl~DC-QBGCKQ@zp1o2{WxQ_i=VVHa,BZ9YkerpHz{I;xDOs\2*I[1;Tmz+[Cr^@7w
    2Y#A=BHwOmmOW\zAv+}#;1,C^@D*Ck1V=-<ezOxun^R{2XZRHC2JEx@~Y~]ss}p1xr}uH,RG<{W\
    yijDJB9Up+KMp};7!An~DF]2=EE@]aWRDz%L1W1}lU*w1TI>.^A$nG}THIr77I\X^$HIY)UH1T=7
    p3zmCx\9UBRZi<H[Go;z>jOY|&$~An$]kW@'T\z{Wu3rv@pxkC7x<RqXp<T~Q-[g+A<J?xK?:$-C
    r1*$m@G;xn{**-YED3.jG?}rH{p:#{$ZGKK76]dx7T]OJ>*I!BQxQe3RH12Yl1ODUxVoDBaKer[-
    NKRT<D;DY'?m\?EA!Q'J2x}zGvmvDW7>H'HjHsIeV<BxTa]mkq;hkszTs,roy>Hz,f='}O@_[a'x
    2aIk]$I~OD7!z,#}Y!Bv@KzC7'-zoR1vue=v{[H{r*}e!zCo>kZT;\R[p~lkO}m}vRswI}z?s*ce
    @zXl~s[msi~$3<'V?B@G#+=7[5opk{p5;o!F+]z^:*QWzo3vnfT[TC=2l=#zG<v!{x$VY[BYV{'*
    r;$!*]>w,$DJ~1(\JDj[xKa>v*]^_}kn==Ca^JZsII\@UJXu+1,OZ+kpmTG[au7?C!3rUAXH,,C]
    <'xWI+2[Ksr};{J]]j<'KwuAVQY\~21=unV^gu'1ps43pX1B~KJ5TlCuj2[tU]{~]a;=5;A=^]5[
    3\oDsXR^],pBEiu'nE*+T[~^;w5s;D#,[FBZ'K9v~*<THWm^7Zv]}_G2UW\#xCX2$>Wre3u_C[V3
    zXG$l@?C$s*zsQe$Y71#w7X@[u~CozJO[uIIMKX]E!e<oD]#+k{Xj5<1EYA_uUI@AJ7wmdR-}]7l
    pV5TvlUaRWJR{@Dj2'CVu=4r>nC;7DE3}YW\Z}]=o$]I#^X[~oEt<^z$@au'1*{sOVa]1oppBB}\
    [U@QR{Brn_Z!FzAH{QTVW]>z+Nyn-+B\nZ<H>+]WaX^"G7?s\{+lXOZ5I]q-v<K]>V,{HAHunB;x
    Vm<jEl[I\$XN?R~Xi^T=HB3]EmXXT\ZVA_mTj@x]$'e=bFferw+J]rRk_=>Bv'!~'Bwu,vp~BmI<
    1+R[ee7[Y32i7$@Z^s,8lI-{1eJkQY1x?1Ws];}_+_7mp<B^[#eZVmID[34'elR^2p#NY3_V}r$@
    EskYWGo>Js}~,+^xh)@=v=*<WwI;JBO7Jas$aU(T7ea{U;oAA;O{e@vj>o#az]VwX=[^~D3Wz*E0
    AaW<=2O{$~V}1KOA%#VAl@{7oknY5^2@jD[+^ezs1IXsexTA>->O_%r^o37\']ul[^ElQTTv;!VR
    ^B{^rI,\KOiE5a_;WQk8zDl$U1-axmwpskV>*C+@TE~Jx+>!)qpK5Tz;o[-G-p[ioGQ>C@E]!xj~
    =ma1Y<e7sk${!\{nu#-wEupJ-?pJnQLi1iu}?->QO1xZE*A;okaAe-Y*QnB4De+uXr'JD>[[(us3
    zoKBjHeE{_;V7|.,iJ\1O*}a*[j7*j'~*EJ2Rw1sW3vaD#<[r^~TlGsEer;J'+*QU!n<_vYylmpT
    1Ok*u7Io~*}rV>'CT+o[B[T#k<o7sn2?vI'X*<x]-=u1~[EpP=U>Vl3W5R]eO}2HA{r;'@naXS^z
    $5>OB[)w7X]-HX-ICEwOwrlZBW;$V,v>]J+^@v~/u+]!E7Rk[T~$j\O[j***2*-]14@Dipz'B3W<
    @5EB_rKp~QB[2V5*ZWm<n$e=;-TlQo7sw]@x/QJ]Yoo[ps#BRrk<OKn5_HVv~apZuaA\{,WZmIK-
    XDEVs5m@kpZXe2AD3<'HIe=ZIe$>+)~=~X2EHn^^K[+j7E*Q!JUa_=WY>];p$2A<p[QK1_!v;D+z
    -_=gd2G}TnvT=iY11Y^;*=o#rtJ$'G}?>_4Bl1{'sk{qJ_+kOO]*As,3JOY7d<(s*TGIn[[XY@Z=
    QiEx2J!GX[)EoRJ.5'_QmRe]smJ\YEnk=75'"mCU1xnsBUX<C1*#'-aCO$GaxRZ2-n1poQ'XkOZZ
    ]&>^+Tm\!rH7j-EuR\_CrR)DCDn-Ya_vBR,k9)!Xp$!Y5Xf!aCm@$21H{Gnz_]T<s@-^UxG}\K]z
    J'#b[6Y_os,eC?9V1B$o'J<RE5U[BD's,O5on}^*k3KK{e==.O$C?Gn<]uT*e7O@TxGY^t0W=1ee
    ,+~EpU~v-{a>GB@,pl#kre*pfFw=_Jmj7~Y~j}Ja*l9'#CmUI3+XE@~1#T@ATXoP$K^UzCDn+T**
    EnvsG#jW2EBXOi<CJ}R]Nw$sr!E@^lZG7XTGmvmw\#A{aLOewUEE+<K$xp,1w-$j-R52=lm7,#Ll
    W],=T}_GDKn$ODsSE@mDG$3HYDYDxH_lxX;p@73x^*D#3rAT}z~wu'w5Ljw<_GT}suomTu]V{Q4~
    ['zDU[vgkEBXEEO5P3^@CEj22x1}w?vV~O5#W#,@Hx<l7ACEOjC]?U]s[$ExOE*J?Gp]o2E>a<{O
    \uDKnr*ovCC1#4V?YWY1'-YGTKz[}VE#VK!7~A[]nY^i^B~x;]wr{}[]7wr7,rBk}7xV?TN5R-A'
    1AE2Ul~f]C*$X_{R'E?]O2W-,YV1BT1D)liTDq;rAz3VZQ35}oPuXY+3YK[1BJ!FtH'5G_*!j]_Y
    _^twX,A|}3UBo<1\tTVuX1TJ1Z*WY9?pG7K<2WrW,C^&^!-5Yv2ni''^DQZHDW];eaYsk\'+(^,;
    ]R^VV=+rY^CW7s-e!$-]s'Y-DE7n$YKm{L[3,^}2Ra5^k^Civ+]!]DSev@T#rG-BO^Rx8Yk5mDr1
    @VpzD{<+!W,vAG<^zv1<T]_]x?<,[&UYQ7-,r#},E2*<G'_UDuA=DK8OOYw)'W${WD<vIj,XBGZR
    WsverowVwn+u<\W=Y2$K}>TB:ZoW#1*BQ_U*$OED^Bzu@'*r'Do1G=<eHlRp1@oWzes?uKxRoJ+R
    =ro7_OB3pHRsm~CA-ClYaQE$Oz]3AfQ!IKno{j7$=w?AZrp=CzHUVp?1jCY;,rxj+ZnznOED$vKU
    >v3CE${G!E{r2[>s>Ku}?AGGmArIusYnlGu\5Krst*I]n>-O,nsXVmH+O>e2KADK_53v<oG<AKG#
    ~#lT}bHw]$aB$r^>eAG}^<?HU<#p+32($Tu1C~KoDOWG3A5K=wov2^UrTo~W5@5R7VkX@=[EK]XC
    B13]l;U\wz1?Qp,Z2G5V.<Y?{5~>W);C7~ur{GQe{vI^mkDIY>;eKso3lmUY2UGOJ']>-vFlR$5!
    7A-$xnX;}r{o;oozA3}~]2$ozjWG@AHvXT?}oOoCmuQ/V2'ABaBlEu>a}~uA?rk1{Ge,+zDGxeTJ
    VRxB^kOk@lsp5D+DU.[D-jBC]eR]OxbGOW*'^\QUT,QfDIlx5}TW[#w>XT^[gUIAG5!WZ<'I7k7o
    #dhCK-sa}H{U5iT>ria#>OD@$a>=cGroTgv#nlYJo3;sxlOs=U]c/=ia;$^w[]7Q@kolpZ,jJLR>
    2e89['J@C_Ok;VHjWRaHM{O7xiBju<oliX]D?m-A@k[{R2>'!#z3+!*R}*kJH5JOa}J=wHC?l?o@
    {@^pXLH=sp*JA];Bu~s!e*vWjmq7<W;'H!=[E]=_m2zRw~R*ar-3TjE7DIOdg4W=?=E'X={5<x#U
    \<Mu8z[jOB#7Ak[<}uXa+iXzvsjR>i[rjQU*Xwr,umojX!,oBRsTl?DH$Ja$,>>nze>\5GO{DsBk
    I.+n3!Q?QR*_u@OwzaOUQZjTEv0DQHsR*p-3<1DsE#sPx\[eUaxnkjp][W$DB~]^Bra$A<j2QJ>u
    i'oxeuR2-EeK!+Y2v?s#0_$Ul+=TKKT><,I?--o=au+u,]xHJKDvlYp;Jssu\l#ZUbH'T?.~'7$S
    L^3!B(iH_J!$HH1krIzkIo7kC[r>=IXB-JXUWv*~r-;C17*!CHW5X~b?Be-xaCf]wD<UzYm6PC@C
    imoA1E2<>1]VK9j3wY-zRRts]_U*[1m,vA'\X=IOKV\,G1p_Bj#EnIwr_}a$l;IjDA^NYC,@R;Oe
    Ik}DU>7uweCA!E}@zn=Y=Yv}*EEUG?!JZ=z3iD#-5YTaRxwn%Wx*$wI<xYEU,[UYaE/N52o[-a7l
    <wT^[Ii}WG]oD\--rQA@OOk:G[[r>T!A^<XFz-,<V7=Zr?lGHCeR"=U,C3&iXIB*#<T*^_n3DaVZ
    G_[!]Z+i-w>Jn2Q2Di[OnUj_O]_JTvm'O{Giz]#ee\VGkJaC5^wpm2!l3=\nY$UeAnI[r={_#U~p
    jE?>HH1+Im<!xewH\vE$v_]+{ARz~,Dlh{T]^,j3X;O,=AwA-p-+Ikj-uZrx{EzRCL'!\Or#YxK{
    *u)=rvH:{{=Is}W-Q=iO\\[l#DA3WzCX]I{74o\*Ajoi5j_7!A,>C'{3o1|?\,1$1rZOYKVZ-*UR
    pE[\pIDt3sk$1ua>7;]B@$s^4;D+xg4x$A3Ik<z{oG^D1\^Rp[CFv9|I{jxwOlx-UoW\[rmU$;<B
    !]}TTK#OV@ZhTv1^l+HvS5poHRJ'{Clk_=in<O'Xk^$nOkCI3YHpW?V\Ix7{~SsG'7hTDKBxX<Vl
    =w5avow*XX@~z$RrOBk=-B#nx-\'jE\gkwn<+[;7xR>[=1_wU\?jEwVTn'T=jT2jhPb]B72UOjv&
    bC3GZ]3,=$j[]~XG-)\>>DraXVQ*1Q]=nG_~K+1R7jR=?'F=w}#vVsx[=Yw1kp1.ovX?aREw'rkm
    ={x=Z{,v.foUa_r?$*Ixl[#xV~oZY]Lr{O?3YXjG'popK!r//G}XzoGoD^C!AUYQQH{*>Q^A^B-Z
    Uz]jQ]*-_{saje@nR*W'H*Jl555GsI+v#,{zG:}kzVw+<+Qo%NiYAYT-w<1GABgIlQ53-RDPYe$I
    '-o*W1a_!lAzuemJTskBArJspOvR_\!2p7x#x?UJ<+7QT-IEH'zE:F#-Rk**3@{Y'@!TKm5YAx.X
    Q\slv>,hymeWE3<2,YEG}*,DK_J=e{_!-UxB-klCD?+[Qo*CaN|B2Q*Hzr,:x3K5p3s2I\[m2=Aw
    juJweE{+YD{WpVm{F1e-Et)o+!e\eJOBx+X#<W^.*n,OTw$pkUDV]jQ~kX\C#E?QDYxp3'^;$+]@
    TOTW(IwaZsk$Zp-p3@B$~,UuzI=^os*pRfAABK<IW}U]!v17o}wwv};7rG*kD=u}wX?Vr~$X_C:*
    VI$_loo$*;]aUwER}Xn&CjR[e$Ce=V=BMZz[r@zjG}se1=+ZZ;IjXaGw>3BK}DZ-WQ_QH<[K{1#3
    *$>n2TR<zE#v^*Y?TB2m<ss7E],CH-rjR/o_ODV]B1;$XvH$o*\k,T1o]DW-e7VHH,i5!$~_\WR+
    G!CZR?+_2@=['exVVsOWOD!-I_T'<@UT2Gxknw%7?T>*Ar5HHJ*:Qnx@w^K;Kx3{Gu+kpsp^EU-$
    {xYjkBX+lEke3ICYCxUCiRo'$~@]pxR7C_oXIQ=\CXAR*\pI7#BDND1DA^Y*s+{v!7CZz*JWRvx?
    2om2I_2m}i[J5bl-RD7jv;r[RE,QZJOoWs0JRilGi};NezR,BnRAx[?7EjEvEaEA
`endprotected
//pragma protect end
//pragma protect
//pragma protect begin
`protected

    MTI!#U\m2\QT\Q;nex][ppw,J#}Q7kv@-wY~R}#<k[7"*o|QlW*$'j\!HIIX'#rv-xT#Xr@x?UBw
    DVOvuMGZ,%lwJ#*+[[o_n=['CW!Ul$HUlIH-BA=G#QET}7pm$7le!l[Q5}XY^BFBPC,!IIG<[rmj
    ^N!eB7zzAwT*<3vevBY**E7!@V+Dosp-5#kvmOa1a;EYzO6yND^x,9<rk,$@<_R|cKDC\{-H*iT$
    u7jP*m__uB5IlXssc$v7rr1X'+Q[pX1Z-x3n7vi=i'?I<BXB<i=]W'u;;2{_uXvJXpSKC@~Rx-k1
    X=so>RnpJz$C2zV5z@kORBBH$[#=CXBbWaRH$O!1A}@mTX+r]WOT)o*U5c}ksU7v1*AsX-R]^\Yv
    }=T,j7_U~H=wHu~-7V7A~O@<-}B3Wuxx--a[e^u7\=]DCV#nU?><$;dU*j;YZ!nlu@$@Y\nK^[E6
    o=#Z.ZGE$VraKuD=ZE-5*7^V?BV<;2V+3++~x?XIH~E,lIo$Q}xl[=?zE++R[xI$@$XlVBeQ5te=
    CR*B?=IK!Q^JIs<}eA=1lY~llxfwrxsVo2zPS^-Oo^J+e*V!]*4oI{}nwj>-l[HHwp<xl3ooCO2B
    KIi]pWJvX'xoS^+,T+>[+}7+mTp{G\ZT@%vpIO-z<A5RJ>u$vRl@na#G2aZ73^eX[[2IWksUar~5
    1Z3v>mo,a-WwDa$=i,V!Wz|[u{UuCUQ+G^+}!^UnT--~[Rpq]*aO5;F=w<vk*Ka%3UpzGimYvYD*
    kXE@4I-as.wC-HVt{l~B2OxiRB'}@w'kzA!?*H$?AXYj$CU^D?-T:{55[Cw_ZX]*s@T7}=;G^qAw
    }liU<$oNw<x}1naQHa3^|vOJw5x@KEQJTQ~^V^f"bbTEzWp2x'lr7\9-6bH}aJenxYsEw!x~n}^7
    x*[>Xk$Ku-wwKpvCZj$sZO?5$,HD<J4~1+E!5wCor~=QW!Qp5+?Bzo+y8QC2\B+nIo_G'l5<_awQ
    DZnj,mRpImjU[cn]]k?T_?#elj*V+HJUZ{se_*=3E$>XsT8._-++YrHG)^B$^}oY]p\@^zCx1KX=
    kQ2]?._^DEx~;ZsjsOMEQ$<C5QU;C>w5m+OAr=<Hji$sa<XomOB5CB{C15m$o;J8E'uDv#nnl{]J
    )ZC,^i}v+kTa$-lrG#=2lpX_s<=HK;_z1@]n@\W3oKp!aD,R^^u]i9zW[xbQKK{H^<I7T!pGr}J$
    xsr=wDGJ1k_%7E?AhK,X7LeDiDaB<[C-[*aeBv$\BTA1#Bpk-O~o,ATT;v:ir;eCn3u$Kxx\$!}n
    {_D58I;TxJY^wtx2]}xQ:a++*~ITn|}n}Q8HUXVU*Z}R}zY?{~ZV?Z3~BOiQo<r)#5KzZOa7^)V^
    CB7Go@K5"Bk2pj#!u}l?IIUOXIJDG>X>Tx-*woH<@Ow72T52I5pi{KEQRsV\sLJR]_eD_EUG';Gz
    BQ9DoC!_;jk%l!;7n*IwRH!^LN}Q{vV}-^-O75oJ!pQAosPjCB]b[3@@Qm$jon7m;SX,?<g,YiOC
    #A,{aZ]Vp?,<Ejs1xmIla-TrZ{!P]N!vwZD>~Xq[<DT+wO@Q\lT^k~[p}Z_{TjkKs7J}CeE-*x*i
    zkULa'Gx2>>Q2}T[@vl7h^2ViC>C@isHplOKJV{llQ?~GRBpvC,53<v2!ZRPV{exl{UUno<rDxxT
    GH==kl[ps[KCiDsCg=vrj)!L=[AEOmu7GjjHK<<Af,(f!5l}woV<:]XxT1s{]Z'_>LTE>o|UUR*U
    GvK1IRa$T<s<-Q]^wD;DGR$oBnImCDYp-o?v5w$X_Gw0ovUlx><n[H5X5BmH<nIG3X[+Bx{II[xI
    Vi7wU+XUSC-*,x[7VJra131_Xq0nV1Gpr5l+zo77'^Q:1IJx@'jUi\<;Tr2\I'AYKX\>CYC!Hr-D
    "-N9caY?3fFNvAjil>_[JE^H-7vk,'Z\[>_]Z7Jnl5}@.DI*,kCx{Y=3s3$wG+1I[JoHpixT]!zo
    E^3WRs~o@bk-BW\1;o@Y[x{O@x5-^pUXJ{qvvK7:@OC{FsGeQW^K<}GOrz}m~nD#@jl}'LO>JI'+
    R^Gk>@ov5v}#-#+.]>WxBC1>7srJ&HICei'kn:ZA{ZmnBugf-VGEpC;,l5IxVJ,'u^jZO#HR?\oV
    ~VzG==HG9OHRRU$=QzZ{Y6l^nKcms@@-h0;C$=ze<_u1ps_~BmZ1-5[za@Ao!Q'#-DF<=3JQz?~r
    Azu[p[J8|/Isj2GU']V_>H^5xU(]~wll^Q>&QpQr!IOurrKx\1]^\WHQ,eI'RO,U8vG]*E\=~>=<
    aplT~*nYBKl=XYz[}<G#XG;+}iw]H^z!,)Tam\C>AZ1RJ^,,ra<vkWEek>OCwC?x'ZFAA11v3TW1
    *OES*K<ZQCTO<]lz]^_25Gm{!Oe'2*+a5a-DW+KB-$<CTE5Z)?xvUBJ-HZRz\=+},B2+YuzBzVn}
    _!s?}y+Hzoyn<IT}G~Y&lHD$+1o#s,o_R~37ss3}!s;AwrHue#e?(ZtQ2_mr'v{s|**7A%$*KQ]^
    s3Owm_-nV<8IGVmt^_2Rp}KWCX3Z++v#~I${1';nx\Au\;,^dK{D1nCvHDu2e'_VO>TG3Iaz@lH*
    5r@}n{E^[BnHr)(_'uzf+n<A:?aRu$!3+(YlY[sap<.15pQE~+HG=2Zl'roGO~7g{57>,11o2=#R
    >{Z-r=+pHR}D#NZ'T_[x@WTsI<~I@'Kp5@u$O?nA>oB;{Qbfz>,on_Vx.7zGv2[x-8,XJz@(c^*j
    n{YQ]zZUB2+E[:l@B7e$OY=ie_Te4F(}@zTpW1vo#lDz\In1DX<}!Z_=k5Db#Dv>c5}i]%UCN=uA
    o7u_A;OGB<_=C3$sKkw<GxK*#_e+#7$7*a_!,]r~27$3JkDX2ds\}##*YGJs-~i_;$\XjuiC~ApV
    D^jm^~!n<'E{J@c_CKHL}UZ3ml<rl[$u$_A1>Ru!ms1u3wZk>A@n2CI['AU}[s}^Ix~[1UTw7z}<
    J}X%J,]w[vu}{$v>!jzl?VDJ+j=_J[i+Cm{Z#]1RQZH\IQ@n}GJ_=KB\sYX#?EZ1Y@n?nB$',l+R
    H&ff!v1OoJe~<-u$1eGpI}5{KTmnpVA3T+ET=D^^G~QvZaxGOE-VH5]7oO7e^L_BV#JBXC27VxV3
    \kr<^ksiH5;YW$maV+TDwOO1Kesx_X>E=peG13#^jWw,lXw_K<2GYpG7I,64j]XZ7Y!xB[s+$CDT
    m^=2K[++Y?~sj>^[CC+n-B]nQJwu<QWD/i$n#{BJ21a$7(Y32{9$75=Cvno]Vl\l*Kr\@m2k=7VD
    GH3K+nR0Dvjk=;Aw1e^QAGX3EsXoX{K[+_E!?+awY_izHw@eH][J\w~B2C\DRrr}T<o1=E_?-pk1
    o**[1D_28{{,BkHnv[#Eu31-}R,=U$Vz{kDY-mImA}1xY@HJOQT1ioHeQ+vCAe[Wk\5jKa}<23Cr
    XVC}=jCJ76LyfwVk@r1zGBxnr~HUKwsCO^JA\]Zee&=k!>*YY]=QX'mn7J@p[sL,a*5_!\kv{E}S
    l^o'ACi,51C_wQ^]zDp2}5TjYoBuI?H?lAn~s!06_I[o2$KeQ*U?PB,{D$v-rE*V~-|LwH$IvpYW
    VG-]5_]<2\C[$;3+elleJ'n<&Z<*OYoYn~XU!>[s~[iwou>*<nC;Z<-GG)[^[o~]p!oQzk[O#@VI
    +o,e=DBl\HerH]$G}\V*xOZ$JIY'5eoe$!WlAKG>A@~Uvj](]$jn'<az<zZ@Qr-^Ii}/}@@x]-[R
    U<=2G-1rg>p]Zt)u*H@aB*OwavI?xHp~OoWD~3Gr#<OQ2<IzrovBx+_pzK>Y{7uEu>-I2Ek~<*}r
    BznxVj1!enARHrWY{BK'vIm~+Wv^-}n'p-}AHI>h|SIzm^peVsd|^$?#@Hz^;$B3dEoTJ+$lvI!;
    !]KB@(BB;I|<x}$mDH;la<o+jR_JQ>K#Y~no?>YI#-oarz]:[pxQ-Rin~\rm+_--DX<]I#;^+^T7
    OlBkno<<ERkjsTVJ\n<?E1=iaaIO]<Y5v}G2^QQQ/av$#eUzppAs*zG-]$5+1Tjr!r{Q,Ya-R<<o
    'IR@B~=YrIwR+v$<#>7o[Y3J[j[x-u_{vLV*Q$X>JDnCeD+lIUc'Zvz+1aZ]aDlHa=jAE?DD_DlV
    BI-jjw]NsWw;*%^<[ukn@TH<[=}}vnQXD{H$'-OQvlc:=ppE"+>s[/N>'so)uI$2pnxE]s$,U}w!
    iBE$'QOUm*?{a\!G]me^ToD@cRhDYeGom>~Y7WIx,[vGE,z+Ts1P}u;{s*aG%DK$wG;a=Al{{]OE
    nWU-T}I5KJeV!X7Vvx_eQ'7nnXo>k8wO<lGiA2.jAj'A]lYTQerY*^'$BiR]!TA%x2jQ[\_X*'An
    4*[\Qz^z$>}3'2eYl71]$+]@RmIse;^x[T$nz<\]*8r<;]OO+D>_*=KB-#G+=RxlC}ZG_}<z<v7p
    \[=}r=naeDAa}5?*{+iR2]cKTQmA*@#77]*!_RAWv*>o+xB_^7sivEzzWzQnppmB1eRrlT$K<'kM
    JGsY}rIWpipI<eT!;za3?G->XA<!n*\7z[a1rosx*Ts{YWHTWVH3C~QuIYmDLJlWB{\CC2H!O?pA
    Zn\~o}k{^EnRo@^pU=AE{1!!+;,GY:\YQ$Kpu1Ok]Z$BO]Rp?vC]T7'vwVH'A=@$@I5w}{1ZAkpI
    TTv<+uY<j1>'^}1;ZJ]3zGDi~e*$7Q~I@o<R_z=!UK.E$lB0IA+Te$;J2rE{CY=kK5psE<\-\QHZ
    P1Uj]YRK1_~5+RW\w\RYohOs_R+$QJ-eRUuQsKXQ!JIYer2B]#x>\-;*AJZV}URvvW)?r[BrEJA$
    uT^YCz^h1ZAzImjv_V,YY+[*,ovV;rrjv?~UfOsa!S\n_e*=}{i\p=Is[3M3B>@?jjp+-Ha<-w\@
    H}_,jWonB~#V7!k1;$m\w72_mj]H<D{,;zCIDY$-amr-[;*s'pQx25??]'1mI1x={mGE]]ndw^rI
    >B;u1oZnz_5m>$$X>]D2H}[n?pe,*$]R!CK$;S>]']*$EB4S3<O[$Xp]cE;*~s6o=\O!jEmY--Q=
    !j,@=-sIW_l~+3<Av{kL;ssKUvKU!Yi7}*1EvkTWpri5L^pK7_,o~EjAOHOprr+_xkn2=dsH@xE<
    {U~D]RYxZXP}n]mK'o\[1HR=D@!~Xl!s3pZ<TV*WziOm$UoWU7$v^kQ7sj\u]D-Ojz!+oXuJ[{aO
    @7=!'/ueQiR=]\OJu+n$7upPm-s-;x/'e's~<OH\o#T\olvr{\\
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#,]UpQ~Qu9\[U3Z[EX]K+!B1CXnn+KA>@[e3TRN1JpTCJZOJ={\v~u}A,<UCQ>;lZC@7u7[i
    7eG_$avY;V+|EfkQ'Be-e]iXa[zx^QI}VCX$sD72[lNW'#Zz1#k5~{U_3~^EZKk{}*TD]ia)J$Z~
    y!,-x$-A![$n?fA+n@V$Cm:"69fO(2IarBCw>y}-;eK+[1[G27RpY$7;x_I@7}psG-35A?'+}@1k
    DZ5uIi7QVY*H}*)#xpJ>{QXb(U<VJAtPq7J\HT$7;oIu?6#7vpf[;9u7n*v@v}@X'[lw+YC2G,Mv
    M[Ev_6v57v=m{2=@7+~\7uou]7rW+<'r!Ul!=r!jkmrI!~b%#+xY^kVJVRV{B<*iVg6+BD2p:A]>
    3+j2ko-],@rG^^pwra17^,r_=&jnl+<U!n}iC3*zv{l~n=|+H+C-UK!+oUp}W{^kj^Epi87]4>Q1
    sVRlRKne'GpQsTa~e@xnQmB*=INLfH]C3Iz\K7_Q']^D2s^<'PQx\i2In!RrukY,wo4-,OV0HXAx
    7=aX=aV7J->!v3Y~;<'1\ln\[nEDujzD@1x7Y^{*7=n!vMCZI]sXD3x2o?p*i=?so2vx~e-{VnO?
    ![.RKGp1<I{C']v=>5s]Bw~zwBi2Y#Cfv?H~nUX~%u>=[O$?mC{vYz5<-\Uj!H5#RZG@pVB-_]2V
    o<AA3_D7QIx-XGlOE;X[+Eo,EjCm5e{uRe5Y$@-lBv@ZYlK7H^\W*$^uTb4Ql-\=nXpRTA1w,,+v
    J-3Nj_#~f)5{nV7U<kH1Qe0s^<QI'VeGs!Om,*kOWn~Vx2zi+Q~@EY;ZQQpBGnJ2TDu9B5uO@nX!
    zHAnl\^2u-}30,nn3ul+#W'-T?XRnK'B,3T[#Y?Inn'*OdIKTCPATp3I~j#1$UxCTo+WE5zZnQlY
    [@1o[5\Hz]K)l=XEo'?wO+^O).)>zR!e\"A=l-YY!aH+=$P3sBEi5~K]2oIClBR{OLYpo=3rwx,3
    !udO<p\}kvjpo}w$[l=KE^5u]XuU[J2[a<x@>rA^Eme2xR\5GYm/u=si7HJVVJOV-.y'Xm1G7r$v
    aROis^#v5l2V_D<,^ix,iQWn}TOBvI7Wr#K]#@J=a<BmDu$!epK@O{*xWI*e3VAeA{>iV;Q2oQ{L
    5_1-G}i21Y'B17B53YAOyY@Vis\[nMpZ!@^3w^k5$I#_2e:1HjJ<ICkQ#@~mEa?OEnW,{UuouH#E
    >DJ?=Vee@]'6IUr[(jeY]}jxzH[WBuTI^\l]weepCn5oHXC>VDVO+-ozV,G$GYwAw7*@$,\j@IAK
    pGW\-EU]BWRHuZ_=z5*$!2{woDp>ox-xI?vUR@*#mYYGU[T,Y}>QG9Yv1]Br}}ei]X]3\Z,lKe!w
    ;E(r!sAl*B>rrlXxCH^RA~=n1R@_jY$:U{alU7C![ZA}w^zG57w}'jA;\*'~!]7woZ^+YH'>$k+J
    Ov]Jp-Vi_dkU}-lC-Ul1Vn!R5_RI5^kCEYE,YuiBRYw5#7=r!J~GQ+$z,[p-azYX;?'92*zs_$$7
    J{vxB]3$l>Dzs?xml{eu]6^~@IwD~nz<=#Y51kws+k\R}>E*CX#n=p}Z$I{DlO<1+r2XBI}?2rX5
    !u]p?OP{X-!oz-ReTBTv!@JUVp#TT\7I+_Ko{<EwxK_,ZvYQDJWUGAApj>~_!{a^evwW+j^5G\^p
    Kv'n$T7pRT?ThHYQ,M?-hs$+=a{ECGuB@YuxAYJ<#;{w$]aJY~YJ;$Oxi)*j{vCOlu'J7k=m}C[Y
    npU>-I:w'QD-a}<eyOs{T;>\3_IksJ7ukO^x@pY2EG^=p'?X!\HJs\7zupWWnT[YK5?@[;aJ',o!
    5we?xrIm,7a}<!}CBM,Bz[r+'VOTp<I?Z#;7[Y[g$,E52*C$R[ouFi*~#=GYTZI*x$^J{$!J|/C3
    IX}=E$<w^wz]?>UoDU}I?=3GB#OKXAy,n<5xWlO9!wQ[;eU+_X@D1o{Ae^QGwUu^+'QWzwap/Yx3
    ?=J5a3*m33<JYn}UWC@EnWx52_KsJK\C;uOOk]7k!/Bx[Y>sAoJjn<z;*!N~w'vY$o5C{5if=Dj]
    ]rZ*vCXo7Un@z<B7yVZ!*k=Ex"}35H7KCo\5^7nIa*3r?DBviRsQzTR~GiG;QlUO$+9XOall^~T>
    QojCG+=>_pVusAjr*AE+w_*Uo]O^o_QmX[sgRO!#o&Bj6mv7[z~llk6[sK>JOZUS5'<oeQ{7G3I$
    }aL]ZVuI^;Qu+@!OBn@3}?rKs$Xz0D<<W?a*rJ\*#;{u@q-}Vsro_5=A~~e<[u6-<ukh~[AVWrT2
    ++<1RonQV1Do3e*DED,Kjw]n%R7uB=*#x;>Tu*5>O-TTHYYXz*TxpH_}kI_JJl-+~!GO+sB=ihSW
    Rx@c\ujpj#w1>Ir*=[Q+uD{Ok[1mRuT5$#@@j[ksIX+{ji>nCm^#RmXw7TnvH={Tz*<ExVA*G1!W
    Glws}[HvB,OI'Oe3Ho-Y^=5~O]QHl[on,kl'1x7^aD1$#voariV{'DZzwX^e[<3'1YoRUrplSOG{
    r=HxnRaDw,wn_ouJB$n;x}DAIvYlX#zGJ!OX2vuu~2-vzMe]]14#o*?+Ge$^;sJf7XmU@\i\nI{Q
    'v\_Q1+r[\;j_lzpFBJec5r!~}J<+%*lW';z=EV7Or@qWBs\67!Q1_DZAVKlD*!E_suTuoDQ55Gm
    !qalkKorp$HGGWgrTG}.#}u~Ef0{D2z^@1GcEji2_nUl"7?[s0vipHL*/7jT[]u-UO$mJ$BJ\jrY
    V-{piRTx]7#Wlm=VkrQmny{=z=IEAmR?D@$]jzAxmw71ZZskZ7-DD?oiAA{p{oHaoRRn+<vor[n,
    XQ\]?*q<}_]5CUZ$sAmsO\Y\#=n!5AJ@'kBo#5[zm3??RBE-\?uDU3Z#\[JeREVrY,<';[j{_!z\
    *#Z!1HerDA]J8i]uo2$w7w-**I!~{GI3Ik1jnpm[p-]m~u|me#JK1ua^i_~nR-eYuAs]^lJKHKI7
    UxJpPS+$uv*xYJw+u?YXO3\avefB+OA^xXplAm^P*A^vY[=17J7;!=i<O#T2k>T^l<Z<lkUp'uJ<
    .iQJljuV[-{K,Kwo!aGD@,ov,"xwXjt1nJ<:CCT7\;3~5eWDjYKs_i@uirsl\^B[Bm[vX}A?BUT^
    1!}sazQuT*@~X_pYpR_kdR\==*@(+R_eGB!12_<,;}3\s#rGR>ppYAw'%xk';#z2r,2-XI5BEUr+
    VeYAQ$e_WYn^O7}$Y-DYD]~I7I5v<p>'#v;-2(jw7\}Tx>peoR]D32u|k}XTBR'w=zrB*K<sjrB'
    $[AkJa1pSp{}]?E1Csm]J@lOo$?_\Vk=Q$UO@#p!GD@<;]R;GF,dE=T[vvQm1'?Vl!HT1#aHT]<]
    _a[r@VI$+VX}I{$THvRQKUTj]}}Oe2{>~jnBpA,iKrHri'E1dh*CAk<'rRW_32sV5EoreO_l>l{l
    GQlHIj3<A2enxR_dOjT_i}3~HXoCBuemF!wK2(OUTrA[irt'?>!6L)pGGU,#I3!w+HW==e~nXj*e
    emrQ]7B?mrUU;<?aG}l3X-RpAZhEjv@UU\?uG[a?e6SGaJHN${$O2\GI]@[<p'HkOIeClj1'pURw
    _zYwxDnXzx;l?*R[BB*YXG*J3r^C.aH@[75]ZoO^CR$ss+[^ziY5pTlKQAa~U&>xRW^U{7_\1*%}
    oIz]1EIEo<$tpTpH?aC@]u1H:j->p~E_DzEkav'W~eZ2;w>BE[s3G-9{s<1@U7BlI[3=xTYz#X#>
    ,a-KnZ?ap>l}i>Qi'+DUa7'DHJ2nplCTX\nHA*K7DZW1JWOsusrX^YKrpk$%TleXvjAOj{ET,Zmu
    7?oTWHwIDp?>fs?\C;=2a+YG3I+v#Rn1~v_IDX{ej}\Z?cJOJY{{eGd,=Knuz17Jw!s#]BD2{@~I
    4jGmrKXmXs3Xo\zY[MwO@l-Qxv!aRWxpB@TvKp]^s3k\=I1CN$?v]l~1lYGBK>E7\%rj#ZQl]>5[
    [Dr\2}crR1jV,*}XG-v@[ov;Q37z@]2on+I=^5$?\-C!a;jnlT7BY2H,k3<}s!^[}K;{=D+Y<-Yr
    {jTJU~sF!Ywx[]B;}i$*q4K<Tm<aGxG~B+}r$B)Ipm}J7[m}{saCBDECxO+!11mQG2C}V}Et@pG3
    ?B\G#{}G\;w,GJw@jI;m?5C>m{<QIr@lg_?'EBk_vKUj[Y5_'a5IpdR*ue[[I<C7]>[KU<{}@pGu
    +KQ-D7a=A@B,^,J_?r77H?pIU7e]},CQHO^>,?v{]D>'r{BVUjX>$*~]mwTln!R7JU2][BBX+$Vz
    BGQmo={O[?}{,alK~[~nVm!>o7el1ep^[[Izvxr~T;wv^KkE7]LQfe5AzJHl=OIWYCa-I}AEm\[+
    kteDC,\k2ooG{pIQx,<\Q;,[_Z<OXoA\~CutFDEk@k(rB15*_wUOl>+4sERmE{5RK<rHkC]\xY=?
    XAl22,Z!1~-20gMv_@3\xK^jsYRw{z$Csumr>+Wm5Q@Yj$'Da5H'JT?3vr@^w=mu\{sx?*~2Ve]T
    5zYBi;p4m5jrJA@D6@se'K1jWCKl5HA}=1j1$$oQ^JC<>__AU3^pY_)E#G]7m5DnDuYtssAv^,C,
    U5,~e{CV5<lT'W-*^=XTXGJoVA{[++KG,RzD}!X~preW1!~-2EZ<ZTBWvi3Y;{'jB!\e$+nOaBUU
    rEnIj_i3_r~k]OpY2>Gm9P~x_{@UA{!GVH1U^!5w$*9g'ijB}@[\"sDH+[~Zo'x]nwn5+]@Q{Q7}
    JxKQ^alwU_k3[;7k5I1@HD{BTD?GB+$j<\O3rz<wDC2lQ+s;H2ACTVuH2+[7QU]Y'-}Y?'-RH5,O
    }@}K>-_Y@?>T'p'<A#>'U''<Hw^Z7\ji^7>5av#m=J7p=?YlA^wx$,pW5Kp)*VzA,pevCJD'z^X2
    _urn5!^'+[,YTBVxRKziC<mmI5Rz4!Ul57OIrXplsBDuX5nI}?E1G9^WKnoR*CwE<Cv?21jv><+=
    k^E^1B{[%e#7vvvu3bVUoD[o6{oK'7!7vGvvYaTR#1aK1m-,\<A~^ap+X5oXGCJZ\VZZO'a'\,3$
    O,RI3Qj,p.O~WQuT$ru&}>Tll3jG=}[w_+-XY?\$C[l^C?U]%y}l>KB<}YXDiEEXw]z3@Q<Vxx3s
    -$\5j?1*ZelCsj$d5<=Y~BU-FJ1D-=#-'?-2$rZUex{$?^An@-'$j^mR,xOR$mG_=Dr>+XjIxd}3
    'J5uxkj?SnA5@;om-?7+oJY1Wzi~<=H,nCRs7R2>GS=GuO-r@#;$Z!YAJ7]WA+f(m<T$I=HCE,Px
    oE]=?z]xUZOI[OO;_E'C#-W@BW]B[Aj^[7_WI^prY5BEY!3C_vKA'X2Rj[ro5]Juj5ZeA7eRwXIU
    {mpYzsAYV='}sOx+DC^ew-X*TJel1oH[xEQUo2}e;]i?T];>-K{8l1[\pV5n{QUZjiw38rK11l>x
    2^T}w*AB^e[7@NjiYHc!REsF^5X\j-A[r~]#evm@WU<BE$AR0WIVuujRTse7Xj[]w?72T7}7ml'{
    an=D#EK5;ulKs@H{e8\U;1iao]QB1Wf!]^EQ@{\ma+;&<\rY'J}kqVY~1=++2=};Y?Ol_+<$;V?B
    +Q}}1.!BeaCv=rw<[#u1]';]oV_Al$@skVDBlOlr-{,-Uw$mw}CU3$"&+[ur8u1-jk,[5eUKaqB7
    Ez!a+^exV}O{_s\}V<kV:LfqEKvo'mR$v"'[vk|N'[T?[^_=,WsiqoPlsr-Z7Y35joBRx?kylmsw
    ,aO@e<e3U1j[,KO'EYajHr_mUE;o1OVn[Dw2dw5XWP=$rsUTQ;2=u_XXH$VG7IRUTlmqADk7_*Zp
    yZ,2Ul*J]oR+Uq\7Cm51l5QyT75]KU<B7mCjAe*eTel+B7{!'$''}2-aBQX'vAIarA3C=>]Dwv^l
    7EB;SEZZT@T55wAD5l~W=ZE{!A>_C9!ImKCa\@^Bu^+o*vUICO*ma~ov\sMCnp{8o~I15nQoF]lX
    XxC'j2\Zsx+I?Ja'{!U3Ts~V{v=Bz,?lO\QUnT=Rei<o!m5^1er3EmO'+x=~3]W+lQEWs~HQRr~]
    UfBT[_e_^v>nUI1q;7j?Xj_wD;sBBV7$Q+e^YDj]}Y_#ZlW3W_T3Xp@*;]+v\Vs'YWE@K.j*V^Q#
    Qjj[\EIV+piYpB#}AaokVQi[#1XUI+0*_-QaO{odRHv~<]\]ve+3VHJuea<~uLHn}#sZp{QA3\nR
    XUR-mQ+$-Qm<11xD[-z#]il'o*#z;Jx1DspwD+T$YExZsjP>=K={Ew1T[iE3TIV#1op3-K,-,*']
    nE7Rw_AYCp#}Q$O*a_vE'_Cx]>VK_kOG3m1J\EZ7.vlVW'@UoraZV,[Rl=s-<+DOxd:njQp)m]{-
    KX*kEsUWB^3}2GwWZ$HpsGee,{5s}r_7a]<w~r,IBD3jUOj[n5}KrXTV@_H'Ysn'o[5Gx!4VrV>V
    p$}4JeXV;*=A%il2A]{Uvlo@orZUzv__p.B?-pzI?BJG>UOv+Bz>_C'e'AF1}^B#]r'}{I;1ovBO
    X_uU^>k_>OJl1\A0Qo~$V'T]7~7HDlCs*<RjQRuT;7\3kI>rlz1Kz^u$lBr3IknZiD5nu7JGfGuw
    QQ33#5j]+jwTGCzVG<az<a7X3utIADY^OrB8J7Tx\G{>WYea*Ixm7kXC=JEZE,*^?I!_dv@W2E>v
    W>YaG@\CIe?,j3*Hl\Z_Vr!leB-Ws]O2OX=uz[j3+>eU;VR*j6H1E}@znWA^!llc$anY;_KpXj21
    Gx+w@U'vIN!eX^:_er#\_'$}eX@n-,kn}XZ+I12QBl==WV_gms~Dz^+I1v7u\ZV=]w]<$*m\~{'*
    B3Z5"t72UKZe>j
`endprotected
//pragma protect end
`timescale 1 ns / 1 ps
//pragma protect
//pragma protect begin
`protected

    MTI!#\!]mETJlUGnTu<,V[~jC{(QBzRzOxV,si'BVN"~OQ[m1xA,H3r~p1iL~\#{Q$A\i=[@EX2Y
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

    MTI!#!sou25~B@<23E{U[F>\J\C,BvaXJrVJpi1#VZ|%ljou+'Z*D1-K[{E;BNcsOm$rHj>yARIQ
    AaOa<sk7_rPlwJ#*+[[o_n=['CW!Ul$HUlIH-BAI_#7Eiu7p2<5HGi,Yl1[tkGu[Iw!,m<vH73KT
    'D=20nHIsn1?'O6Xxj2rjV3\V$z~C<-3-\lgBMi<2]-Oxs<o-{QI;AUOIm{s_RGG_[*K]RE.O~Ww
    wD'WBJ-$Bk7-lD!l~AriQ'3Xe$+}TG!#?<X[2l*?z]Y},$*[;7Q?cr;UHpx*R_KX~oIXmaTIBFI'
    ]iQA[\L?=7#@OTGpzCW7VUZ[n-#j<*3oK$<eA{n1KzXom*ZR;s*z#3]!RCKqu]$p[nxu{$!V35*#
    Q<'W9}Mv{$2Y__o=~EQ?jw}O+U7BP,JW@tJ$}G^I~?7?C@cl_r\mQjIH}~5}$!@m{Ye$JuX.}@Q~
    VWUIET[nLmv+?5i];byZ{^oI(i{X'H[\p[o#DR'UQBm\r@OJ!1VsY|!Y7#7A{J'7u~5~A;iAE!}o
    ?JmpAaolIkdKH\eo$msw[~DekBOY_$Z7QnnH$lHnj-Jsu>@WrsVP0?xm*yeGQ{w**v}Jw*E+T@\R
    \}NZU}Dm}x1CvKCYF6~n{[2<I_K5aKaYR=awWB_~E_OjvKgC>A!L'lWkE{B\,?'jl2$eaXVrm<<x
    +YW@D2+B<aR=z=2!BsO@CJ\#>rOiRzeHgW=x2xFgr<,EI!BsTlnUF*AJ#2^sH=UoRg$RYU@hAh~I
    #K?r{GBeDA&r[*~{soR:E>@v&z\EoI3C<rk-Q.FG-XEK<Ow-*\}uLV@nJXHR!>12VlXWOx*x$a^$
    pl,jRf_n^s@^DIaem$5!D?@pZmT>z@*D{#(KBVT[;-=1}Q=l^}I\!<Hs,B^_y:+*J$#7DzO37{m+
    V3^nZl+a@u!V>~i925nZYliT{-u=2h;{lVY+w]1-AX'$\3j${QM:/vz_+WO?k=COY7'G<^<z28]#
    G_^\a{~x7YB3G>psz]sJ37IG]?ee*KVwU7_p!Qx{xA^iRVmw=R*Ok{l=2[+}u7OGJ{5ek',x^7rX
    X}=W!+!EpU}7aGzX=$5_e-1R-kDRBRe\xUXE@;7'JeeER>X<oVOT=*rHOC!z#BaR'VM?H-B+Anoq
    lR1zY}A<I}+~#IToTx$7yajp;bI5!oXwBeVWBD~AE$f%l!;^Z^}=x_J>u*'zt?U,VZD;{D3Ka^W;
    l+}om\v!HOQp*&zZ,Y2Rjv;{n!55jBG@j$=Z>Zj5_o&53RG7'x^7*rs#oB2{sEz5$-[4Wa3ZpRQX
    6,$,Z=gAs,lZ7XUs,@TpY+u~sx[5T{^gzD3U7@oJGaHozE]!!<A}=g6tzH[<m}[^Y*jkmUr@k]Ze
    -TAv\ViT_[RYC?_]\'_u5ko\5Y;*xT{E3{WUWTI2Io1UB#*5w5IT$B^[Mlnn#nTZ+l_;A77,J4SW
    XK#2vR=r=kpyaI1^\;>$@ou^s_-'{=!^p~jXv_GE<$iuoz{WS}[soHAaGaXo!is]-Y[-uJ$u7BGz
    ?5$uDR{Zz5Q+>fsXEXl[urVenor*Dnma$IHI+K*l*n]*]HzH_]a+wR+Ykk1,!{."g\+Q{o?zlqco
    Ri=jRkV*G5o**aa-G@'>*sYln<\:=,o2y,Q5T1?Kv2oYkx1UX,vv<!n{Wj1DYm,s-FhV_l7Vkwjv
    OnX]mR@Qa[o_D*2ozo<jHEI1+}?;_n?'Gk}i[O{^~QCF/j<'#;ozpPAD-35r>\_v-UJr'^]I_{<V
    J}~'R>opj$G?<;8U$7V~VK~G'?JsT[5B#_uUa{vRzY7xvJOozTCLal1n!wTuJ,Huz!ZA<ze>p$ZB
    iAjiUr!aemrsC{l@jQUj-z$-H+eOHx!71>K{]p}mwaKGs-^]B]'}gWRC{*>U1A\BXi\<p-*G[<Yi
    B6_!'!<8Ww^TqC1+on>OrOnHIEJB]ws']OWn<NCa!I,Gv'QXowl*Iw-arA$q;DA?iBji^'U~Kj<T
    uQo2TXE#r-B<X[j_}7>W-aI+>}$za>'k^V}$R?Q*H1Cn}HjzMo$U>-Os2[$>n5jYRj>MwR]ru]~O
    &G~mz(a]=u>wY3C!-=h<>2{,NjFT]rACHYX,$;>^eK\Rz^O~{G'1B~p7Yn-<riYl2U@lxnYn,U>O
    z[o6fO,;];lG>~EVTH5KE$1-D,u'nb'7I5_2_+HC[vm8XnR{NG,]Q1=5e,]V}~EpRms{wWG?1'vB
    <jH'+nOD'0vjDW5#B7e-Yn=AxlVY[JK*srpj3e#Vi[~e73Gk{Y.IjBZ1iQYqE{@k3B2K=am>?BOj
    ~7]$=H'aT]n5uaDmI7VRror}z7=,Z{AwBp?rZ}zTk>'jBx!171px2[*oJY!Z/~jO!?{!zXQD2@A3
    IB@n2pr_lIskUBnG^RBDIEC^5<xXOnlQu+,Tv;B#KE]QW2O?E^IDxAT;DC$R?oTUK[JZ_Ko{{!lV
    CEe!sxRsC@x]aKT<3Bkem@aOlP-_jp3ppxk[Ya2E;~W_>GN@T;2@[@,ZnR!E^-Rl_*1#H}eBvvwx
    _J\x*~^2<l?bpC'JIDam1A1!7Tr,RBDYxmH@5IRX'vRKnI\*}ZU'plEOZ7G!]Z],_=I#WRjQ,z}2
    u\DG\Q2XoHrr'!,K~{~7+}@vkea{JOQ~IT,u&VT[@P]i'sNw>Qxxj@aJj}mW7X#j@XKpXZ!1GG^!
    CDnC<o}V><s!YKYdGmVG3U}+xaW;V7owm]H[VZ7,O$ARMgCY3uxBEaKXG$E-3'6v[epQpxH]$;=T
    onG@aE{ykv=JT7!Oi1{\[UnEcVODuOR]rVm!AIwX<$;\Bpl>T2,uamE[2Y3R~ilr2z\#2@-Aox,2
    =lO_]P->l'V5vs^3Ww!Hu]pDAAWGH3?]vJ{GYi^3O36,HEBIVOs@+^A~'X-lY7n=^uRzI}HsXAp?
    z5Es+=v{BKO*xkB01VInDEQ^Kz=E^lw]Bs>2^!l=5s<V]B'-X>Jvs$HuDYs3jizE=W]zl-<AA5W=
    ,:_AX^0y[$pH--'?,j>,Bvo#WRvXX]qXAZ+T$1YYAY;uB3p"szHQA+=J|(G[*-aGs<#{K5_#VGv@
    np~7E2Wa2\r7?no7u@JU[prQJXka+K+Hl]7HEU~<zj^*nX2x-EZVzXvu+H@T],+Xs~a5r]l?,K7T
    ,z-zi!/^22^8^Yoj.Z$T]rfRdYKnO]el[@T+\l?lij?@Ios>*z<
`endprotected
//pragma protect end
`resetall
`timescale 1ns/1ps
//pragma protect
//pragma protect begin
`protected

    MTI!#n[YRBz<AMIIznNvIils#2R,eWJB\?;1/Le4}"[*?E>=CXQH;r3eQi,@CR]OC?#72!Cw5*JY
    xZLv--s~{BBY6+1$'Q,AmOoXA31,['>Kj^-1V-]H]H<C;jxmzeD^mmp~@VnjK'IK+]?$I&AUZ[p$
    k1XAY^RW;5znBRNK}oRvERGRRs<kAG~n'vJAET=5KwaO5;K5p[7QwJ#EH1O6HUV~j\5lDel31B{}
    KY_Kd?ORKb:J5,A7pROGBr?isnpzA*\!xB[g3<D7i'C{-YI3_9]kHbBlVT!XRTAOmj#]^]'4B}^Z
    K[|7?{J=;EjZ{DJ\A_w_Wjz!X^~*2<RHs[i[+JRz-B]~7~e[eBC|G^Yl'urm_H'$3=#x>5<g7V}@
    t3]k@'GW+2ED3JseR=W+[z;O;p\[W_1m',v-=<H\B#YW>nwJ{W[_s!>2e]TT-V{o\C\,!B>Wn1Rp
    H!D9aY~^,Ei$EwQ!xI*'R$R#Q'Az^Q>Zw{Yzdu*$r2vD3^?Ck1,7Y?]+jbK[*DAsGK/7!uYIp[*H
    Te!6BT3slaEJ>x983V>]d@R~BJ+Ks$I,x>=@a5DD]YKo1FoiA>uD71;Ynm$-=itFX=^sUr'
`endprotected
//pragma protect end
//pragma protect
//pragma protect begin
`protected

    MTI!#J+E=}7J~e,O7:Rl#'Z^uHFbx7T@=3Co|,?ju="r7aW,l5]2v2T{n2[t}0T}R2;Y;rwwA?@Y
    IZLv--s~{BBY6+1$'Q,AmOoXA31,['>Kj^-1V-]H]H<C;jx;YeZumw<2u*Z1[$m}+]?vI}uvBpZQ
    p[B,TsnF@$B*9,=J@v^\[n5j}%|wH'[n<3K-{H?U9iY?B@BinoI'$H_ox]ZAeN\eOw[{Em}7mY/O
    ?mrKEE@1kWJlT~JY>ZV/kQCG<<-{+1Y?o--GlIjT.^'av\A$@V[lY2x+U2<E+WHuBSga=#J_^x[O
    @>B|I<E\@_?Q81_}wE;{UiR2<,HpQ?Ej3\?~~~]kRM4Qr@UarZ;aImZ-Yo39~hM*7i@onxZ2DQ!>
    X]@{[Yaf#pn2,m&CX^>>EOo$sxE?j[KRQX][uUksv;pL,XKIV<,JW^e$-a!'&L_n3^p,j<2sXX\U
    T[YHAeyGCsGAj,;6^};,,1Y*8AD+>ZRmpj?7>pJBo$!7\K,Qk=~-wmY*5WXY@URmO}2U[-w5mOYk
    RWoWO1j*sv7^E^2}AS^2mxDzIJQ]reVwa+EvrJgI\#n-p7!q=Qroma7~E@d]nUjG7zA[k$*oBr^C
    Z~]qa}@+-1*ecrwHCC2wnvIuw}ZU!~oR]CCAjCGX;1!>~Jom~WxZBERK+6^z<_Bhc7^V*xm;nIR^
    +5o7@aG~TjvUV@Ej'e'*23]U}jW@e-U!$vili3,D]#ov2||tP,z_V,=\1*xKk<a1GQEOV++{K@YU
    E?_?E#{VKaoQOr{~[Cepr"rzD+:I}OAz?a$!>2Veo-olC@nIkRW}kA]'{1u\aOO[Hx7GD{RY@*wW
    {jvrWvuRK$zr*Di7JY;:T5+[7~U^>B~K1-zEG,7=I@7i:AEkIBy@s^?kO!~!Rleo[r],D\$i'KB,
    *~O,+vza],HlLC,*KC=}i7Qwzx<u]D+W~ywQ}EZsXT[jxaz2DBwoE_4]!vu@pGm}\n$rw+jRD{_n
    ^l@#D'D*He$x;YBkz'5oC3axHooH7>xW17X>B}C#{+u-zn_wDYHJo=i>7Eo6~[R[TI3uGHJ5#eR>
    XQ-WB@X_x2*jYnB,_^7j*^>U&}7^_r?YWup}T7~'7QjX>jk,kClypo?+rn}!QBVI=?BYCT[iO*i;
    lKuaC}j<ozmTu7nH_[?k%Kx!^^7_U3-juoV3Jws#1z3-GA5H@}<1U=>JU5Ars{TI#x^@$^AKrr@n
    B|?lz[GsTViR;ExC<B<w5wBeuroW==7r7riBjRCYA#z*;_rV!eHX1AT]argrr@G]AQit^\@<E'Go
    B?Gs!{~jrKu[mleG1Am^>pn$p-YB1x;{in<T-aK5szH^+<=GO$K_sq=J<^7H7UI5Jx}AsswrsA5p
    ~HB+A+]+^oKeepIi*;<=\ieI+Co7kGkAewUD#IW+3+YH^OlvuZ2+^pB!WG-]7@exwuHI~Z^EOBl1
    v;_gL_[<l[&'U!X_@!1Cv,smnB[-RU=@B!k$KDCrC@RTHA=zuwXz,+]G'n+Tn\DF=+CsLQa$31={
    }2^7e+'v\UO@lIiYHC|[{{oE@majOVZ5]<}}_zm^l~p{}1l7-3Q,V*{\Ku$Q2@z@sn2sBU?1azX>
    ^l[UpJ23Up?iv<;T'vi>'<voC#e(?H@v]n!n!vVKOZ{pQG2^Y1Hr{RViC]75SJIJ'zdN-lVu{_,3
    Pf}BxulJvu,1zT>nXv-s},woVR'k_RK}A,-OJ_n+eW~>a*lV'_$n=*Q{sCARA[6o>;#]Qu#?}-}a
    nlJ^H<?^KsAJ<]Xm<E}WHTJ*j[T,#,>}]zv>z@['R*JV#-\<*B''#ouox>j'ZVk1=Y@>5TrC3KY/
    <YJrurG~Tw;$zRoz6|Z-2rW7Z<1l{,v>HYUYT{E@wBDu5HuXQv{C-T-aQTp'VBC<{'1oCKJA[rqZ
    5Ci9;[U$%A<$u*#oo?v$CRr<'j^}@,QB>@TBix>{Qb<5Y@$Xx_qvFmxD2*RWT=$v37e>xTnX?RBp
    \xl[K'eA>WrUYe*{$8J]2pPDlWVQ$H^_]*jmOQKe~~Z/JpqB?rXI<;xsJ\!=}*pUjQl5Z!X-eO\U
    R;WQ'\7,<gZ<GI!Ios+sn~KR5>Z7xKw+I;ITv!8Qo3;{apx[U<5xv$1GrU14-'~]>HYH'CluQC{=
    WO^Q?-a@V!=~r[A_3-vBc{ETR<zer=XuEA{<I=~UoB~IWQ>jHZDGJCG*k;'^vBU,><*\T!oDZCI~
    zoJjvQ_3AVU@[mX]=[x=xo@XA==W;%D~UuG"QU;_u[T_\_3ZBK1n7aC1Vr#{A[,Tp7K~Yp,=zBX;
    B\i!7xD]RV~~9x<KrqU=jTk7U!\JED;Hm+BTI]ER+[VI-<?=3xexms7;=AL|3O;[boGk7[<$o*VW
    [,Y#O{>mAXa1I!+j<$K$W-jD~zvGus\$p\z?aVusC$\AGwrev~}#KHUJ][JG=zYz'|R2HG-R[lB~
    vlz~,#;[R2_aY$TI2~|lOHAW&{QXsyo$Y?B^~u]~+ADD\^;j,Jpl$ueCQU;Yj2$[Xa&@Q=#=zV'Q
    X{R,(z9z0?X,Or2;_n1Jk4K+nj$s#n<>7[k5k7-n-[qI#7}vjnWK-BAave}3+op_zB;k>eG2r$+v
    p]as[pTQ}w5wC~A/B=!BB,Z~?+vTh=>^{V]JYmEkK#xi5R;zRz{A~=mv'oGIkZsl@A<-aU\YAMM1
    _lIZ[33n,lT3<Rp@vXt$1O]&=]5-@>VeG}~-WCm2I]YXWBZz~sa5^BK*Ua2zkO<-u+u'ZzzRGUsn
    #V!#N{[U##Q-EDx-Q{Y^Ot$_u1,V1=~nxGjx-WajsJ+*^R$\DonnR5urJDz#=eBZZ^el-H:s{r[9
    ~>av:t6\jpU7eSBysDIsj-^GzEY_<lxeXUU>?GifvBjEnQiriaQ2T]1*']pAXR>XR,s^\3Xonx>v
    2-{B]A-ZDj-D-]AOq^As'B]DHd;Q}>Qrl7LEIUJqwx}$]42nVl+{B\UGDiT[WG1+}{(Q=ZHFs{{_
    @'err*B3;'<Y3ar{>,UoJ[em7V!OxH7;-xvWUT!5^K<;DC,@oa\^#GiCYvID^C\u5YTDp_i@-_j=
    LW7CG>[++Gz_zDOO+\vu\Z]_]DRp1Twajr2ew7OovDKO',tJ7D~[VT=>pzGE_w77o+#;'7^xC,1>
    $2xzp-BW=@Ay!l^J{=!W]+'Heie^IwOVj7~OGUCi96f\?}3LVH@G=HKK@5~xT{!Di][3d;1=]]B-
    a!<\OZs]?8XeV1y],TI=YBTMGQDwV{[<V;3k?CQnjd<sv5xKh]>VI7*]A*r>nw<o+!6k<u@Ar{_U
    T_[72X{^WEm~DXIO]wQyQ>o3|[+!'AB<7!5v$k$=3pKu_~RV~Iun<yv#oV\<${K}k}1a+au'*5Ha
    I]WLSxa2}[3Gj>\}VB,wK$>O'$=jeXw-Tr,B*ri7JG\p=.a}#K_K]j@V1BxKG-|_*T;Q*<-X]pI-
    \H~epI\]zp\\{=[;A[YPOT<@A>{~3'DKa<{el.oRmXejC{^aI*Q\Z[ge;2Al5VQ]UCYOB<r.Vru^
    xX=DU>TojuVaxJp19W{r-a{x\cEQW=#a<'Vp<Cp@vv7#HXb@ECr{v*r\?jH;s~E^a}BGVlIUzB3E
    ZoBos*;7K@3-1UeE1lG+a2$Jr1I~=D+K=C?~],Ak>;kC1^]5k)OVXvu}A]xK~1V?AIoI\u'p,xEE
    vRXIR\exnp+I,-JD3['JR{H5+eGb}<R@Os_{8n}eA>oZEBQ=RY+7eTlR@f=2RZ=%Epoi3G7@l>5s
    u5#r~QsK,]E~
`endprotected
//pragma protect end
//pragma protect
//pragma protect begin
`protected

    MTI!#nAWwTXWV$CoX,KCU}GrRWp^2W,XvCsRw}Z<WaYku25ziG,l?>lexa_HT\D#=3o;Tx+TJp?s
    [XD$OQb}mBz77?@}aJ35/o_n=['CW!Ul$HUlIH-BAIz#^^BU7B3v?~'#ej\e*5{ek/[;^R7Z*_v3
    ~Tsla@D3Y@73olz15IV7)Q=OB({O?Ermjw*oBrxuD}z^_+=WD{]5k2Y}OiV!YX]s1w_EZ1M^4h/2
    RD7?Um_;*BWs,km#>e[-$2u*Y7JeRv\7VIB=1J@>T,JK}VOrJ*k_U^Y*ZEjI+CY}F]sK[3{vm\|Z
    Yz[i<z]2=|Hz@@pTmrXo~U;sm7~T]~aG+l[*_KvTp_BGi[EkxEJn'p}kYi[#JQ\nriB>ooG@zlRV
    ]@k7D}A[{>{szk#]~}=<Qkz{3QVW\WADz]G?CDE>B5eOuz=2[[NwX_,pWxGFzKXV>}Q$Y*V+nw,7
    o-OK7mv->j<}Av{pUwEaDx=,ZE#x'23^^Qae\a*1sBQW]I~]JsVk}2D12se~~al7qBQHu,ZKQ[3Q
    ZolK?;>'@AI@j"'WskG<ps,<
`endprotected
//pragma protect end
`resetall
`timescale 1ns/1ps
//pragma protect
//pragma protect begin
`protected

    MTI!#QZ!eXIs'O5's^=eCpm7#Gj?3Y+-$mY-w[:aDDiri~2jm-;ARIKCkn5i+<]$!~;cm51[=Zn^
    {]nKNxLzGC[EfkQ'Be-e]iXa[zx^QI}VCX$sD72[$N!U'wz,3!-^DU!tK5a=/aok#Na>mIO[T=*;
    V{vKDj^KYV}s#~H}2!mD<\C&t6x5{o#{D1rA)#oDx*w+k[4G+vm6Uj+ee#^Y<X1BY[BuTw*J}is*
    $#OsDve[]\E-i_YTC0s#zZY_eAprKs+jG5%cA9'EK?^zJCOx_=-wx*C]3U:uAz]@Ru?_UB-=;=kg
    R_p}XTlX}RWA2qp_X>HOQ~lXn2_jvxX{ZrBROkHVv!\x?U+SZw{TUwPEcD$HTeCZsG3=x#|RC[@E
    ZEzUrV>]Dn+AC}-X_r{kXl[c"(!1[sk]o?uE#^D{D~CZxW}1X7g>rm@2]QJWo{mZD{}Ixr{=3aU=
    4f5}KrXvE!?s+OD$>'r:g\l<lq%},#@jCRxa{no75X[_};x'n2e{r3XJD1*~'jW!z@JY?}}*a[JK
    eD{is#2QCAeRR(25P^2>sreY[eTTZdloi$(nY^wC!'
`endprotected
//pragma protect end
//pragma protect
//pragma protect begin
`protected

    MTI!#_+[r='rmV;,j{'QI;>,m7'GQ3{aD^3K[N9QH}[L^3'oo5R,t;HAIICwT5?G_,j??u7iTkjw
    E5TvixLzGC[EfkQ'Be-e]iXa[zx^QI}VCX$sD72[$N!U'wz1H>{rD'27@}[*ukN%'nbQ_V\#T7,o
    X>ps+52}Hw{U$VKq"I#1QrGX']W~T1*sJ}'QrNY#Q>yLlek[+XlUuHao^#@K#1'Y}<Wsi_7$z^zO
    OpekP2BtO3_H-$*ZQD@2Y@vo|AXrH[vZ@|#{1Hv)3e\T,1<,BzG;zx@>YBpGW'@]5~GK!s?aR#\[
    H<Ol^e#]EU,$Ox1#3sEJ'VA*O>IT,\Cia}Hv'^+VYm2!}RArrC-V9;svVQ?O^DYD,SA5En@RviD~
    E7rij>_|iR>'$*ZZ<Y+*\n<?=Ze^88CYU${[2~}__v3BJ?\CAppv@?XQ1KIwpEweVxc2{lB6-{DZ
    <}~wkUR,<r^xlo?]}O1nxK,a]-KGj\u;Jn]2BHa!l@s}!O\'z;;erO\_{jE@?}Q!-$U~.rDUX*Hv
    #A\{KYa7<_TY@G[\}5dzH*W7K3Az'ws?NvBx!vB{<TO*sQZ'e7?V~-e#^Kn{]Goe[WY?rm}nvmHv
    Q#YuA^?x,rwWK($j?,~7\+Jn-!*H-ZDR?T>sp~)[\w}xmZ+QH>>}';ll4.e-_]r^]2@Bw=e<$C7K
    OQA,x?e,swn$TW>Ce]&YaE>y3-\R>=>$FET}+nHX[271J<Y<CGeHu}B;#k-=@>5r[v#[G3RJrJ1>
    !$$JE^5XC_<YB4*dYR>I\T<O'OK{G5EoRiv#-w{zWj+an1!roG;n1EV}s?~$5#AaN-aTERB57jEm
    vs'-71?I$Q+*mBTGi,[Cosw*myX$vu5xuTTD$k(Ya;Vms+oi+@Y*wTuR;aXG^Y!sa@KE;XlNZQ<Z
    kXE]~><B]$XCVamCA>7?.=?A<$5_7[A\pmEr}?_Tl?_K$=m@+'-1;a*=RE[Krl!RaE_lRSe}zi7E
    #O#Bu$E~uEIpe;cD>7Rr^Vij[1==\GEYxBHBwI1njm^Kl}^>]Ju]a7OBV=>x~Gi?}[woH}[W>KCn
    'eo'+C#=KD?l2wv1r8D+3$i++o$/"o~+<D1VR'i[E*"pAWw1{msP}D+AI]nG.Ij1G5k=VD>Qe=TQ
    Ij<D+h#D?CRAH@-l$ojsjk-jajDI!=aXjYiX,,Rpm-^*Ho,}_e;<\!={ZT7pX3LT_z73pG=*d+TB
    ]]Ir{#$$Ww]lr<1;[@s!=eK;1i\l7kTG;&h71Ox3<Y2Vy_C3@b[=-w.^QEDZ[3*{GpZH5p;MF\{p
    ,$:F<7p<JOik2I^\{5D~Is]^lBW~3D+AF^Z[?_H[WBE]K,,;X^Ee;'ZlwHwr#/OT$~yR'EW~$^'T
    oa;]>vJslKsQk~>vk]IG6o4m_JnOr]B{}^GmjapUa$>ivlaE*^^ww*wH_s-Dr?^XR[p2[?!vv,'H
    1A_rl=\T}rQ5pIi3{]3_Wems<jW[inkk,$R1yO7^]OA;-Q=~Y[uDX@QD^sHAk^1_+vj^sZlKYAO6
    *AJGmHs1\$nXOEj2-HzV}-<}zaZmC]K2,z*')nO+R1Oi7?C,;\B~Y\'2_HVxYLO{=Ge_Jjc2T[,@
    1]xKn@I=>',iHE>]7==VIrm'geYAD>I5mwvHsHjaQ5Z$Y#\_Tk,[T'\jHrv~v>+GZ+=A#GQ_G@Q>
    p>5R_}G3z2GuaD!3VCYQvi1=j^?!-_up!s7U<+^1Ex\#xVDGp*><B_>Gs_wZre\zv_1jGx<ZxY@u
    [~DBWlTeko2V>-wu@$TnV8\<Au\<7'Qb/%o_3^U\ZWCJDHt]a>K!puD7Dm>eD_^Waw3]MU7*\(wl
    V!maE>YmmX@\a;Q_G^_l>T*;}B*AJ'ral*I~m!zBeE'wjQ:+Q!JGIW!RXoW=pI]lI!^2,@ZGHo_)
    "YY_mJss@ujKW/l,GzojXCrOZ5<5^@-Y=W[^[s,}\R\r^a/@'v[+na5bU]i]Q{-e'7;O5+-U1le=
    !s!QBVin_IUpOi,z+X$CKe-uz_Y>lz\1<$X{kz^ioGX\=DU>RD^G{x\}s;B$*^u?KIkGer@jer}W
    ~_T$[e5nvHEJ?R*T[GVUk<'=1U{pbK]E+!l;1UenlI3_7TQ*kooiaua$[BBZ>BC'*}PEFelXx1@'
`endprotected
//pragma protect end
//pragma protect
//pragma protect begin
`protected

    MTI!#m1#Cn>VGY_Y;mO77EiQpjW7JCi$3[C}CN1~$7|Q?V~L!o=?~x2]<H!=2'?2=>DT\A[;G#R]
    XD$OQb}mBz77?@}aJ35/o_n=['CW!Ul$HUlIH-BAIz#^^BU7p33Z>=i=[?{}XYeBFBF;,!H7B?Tv
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

    MTI!#1{]I:'vp2*ajeL*R-k~B\RGCVZl,Bj-'k=C1e"ij@UevR3pO0J,p[R@TR]OC*!=WaI,+*TY
    HJq$--s~{BBY6+1$'Q,AmOoXA31,['>Kj^-1V-p~]w-~@'2;Oe*rm|"#=QR}y5sR<V<+;eC$*1Y+
    wv>RA}Au2=D2\12_n'EU}&_1TDW]Ae61<mOZR<w&@o[=xa}I<Yj?*VzrP_AX}F[i;ZrGVXv2~sAE
    ^2AR_x6x_I~aswsUUz7z$TB[~R7|EK><1G+]Dj}mg~$nX-6[OTA*{\s2w^K{UT-;tQJ[~qAE?Z_<
    7rs^#V}A-BpxD<e,~$@j,T7Aj!'AR#5n~Zl>2Tij!Wy;pU~(^+A2T7^}JTQ@[1H@$<-3Q-EHhV2~
    $JI1a.2w7a[@{JHap<j5X~x;'z#R*Jv;qj-{*!wwe}}^R'j#]13W]zr[]?rlO,R!THew<v!\Q<vO
    ',<UJKaw}OmalXhguDwuW}J-HT<JL}emwr,V5xTwup?YocE7w$z_@]-7R@TVCr~=K-in$3<AVBZD
    *O*ZOnop#x1faX82=zGJ]_K!Xfj-$]to-Vi6!\@{lJRTH5Wuvb5un+kpI$e7
`endprotected
//pragma protect end
`undef IP_UUID
`undef IP_NAME_CONCAT
`undef IP_MODULE_NAME
