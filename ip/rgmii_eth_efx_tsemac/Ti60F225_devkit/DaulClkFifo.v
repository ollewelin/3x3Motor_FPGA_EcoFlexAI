
`timescale 1ns/100ps

module DC_FIFO
# (
  	parameter     FIFO_MODE     = "Normal"        , //"Normal"; //"ShowAhead"
    parameter     DATA_WIDTH    = 8               ,
    parameter     FIFO_DEPTH    = 512             ,
                              
    parameter     AW_C          = $clog2(FIFO_DEPTH),   
    parameter     DW_C          = DATA_WIDTH      ,
    parameter     DD_C          = 2**AW_C         
  )
(   
  //System Signal
  input                 Reset   , //System Reset
  //Write Signal                             
  input                 WrClk   , //(I)Wirte Clock
  input                 WrEn    , //(I)Write Enable
  output  [AW_C-1:0]    WrDNum  , //(O)Write Data Number In Fifo
  output                WrFull  , //(I)Write Full 
  input   [DW_C -1:0]   WrData  , //(I)Write Data
  //Read Signal                            
  input                 RdClk   , //(I)Read Clock
  input                 RdEn    , //(I)Read Enable
  output  [AW_C-1:0]    RdDNum  , //(O)Radd Data Number In Fifo
  output                RdEmpty , //(O)Read FifoEmpty
  output  [DW_C-1 :0]   RdData    //(O)Read Data
);

//Define  Parameter
///////////////////////////////////////////////////////////////
  localparam    TCo_C       = 0  ;    

  reg   [1:0]         WrClkRstGen   = 2'h3;
  reg   [1:0]         RdClkRstGen   = 2'h3;
  
  always @( posedge   WrClk or posedge Reset)
  begin
    if (Reset)        WrClkRstGen   <= # TCo_C 2'h3;
    else
    begin
      WrClkRstGen[0]  <= # TCo_C 1'h0;
      WrClkRstGen[1]  <= # TCo_C (&RdClkRstGen);
    end
  end
  
  wire    WrClkRst =  WrClkRstGen[1];
  
  /////////////////////////////////////////////////// 
  always @( posedge   RdClk or posedge Reset)
  begin
    if (Reset)        RdClkRstGen   <= # TCo_C 2'h3;
    else
    begin
      RdClkRstGen[0]  <= # TCo_C 1'h0;
      RdClkRstGen[1]  <= # TCo_C (&WrClkRstGen);
    end
  end
  
  wire    RdClkRst =  RdClkRstGen[1];
      
  /////////////////////////////////////////////////// 
  wire                FifoWrEn    = WrEn;
  wire  [AW_C :0]     WrAddrCnt   ;   
  wire  [AW_C :0]     FifoWrAddr  ;   
  wire                FifoWrFull  ;   

  FifoAddrCnt     # ( .CounterWidth_C (AW_C))
  U1_WrAddrCnt
  (   
    //System Signal
    .Reset          ( WrClkRst    ) , //System Reset
    .SysClk         ( WrClk       ) , //System Clock
    //Counter Signal            
    .ClkEn          ( FifoWrEn    ) , //(I)Clock Enable 
    .FifoFlag       ( FifoWrFull  ) , //(I)Fifo Flag
    .AddrCnt        ( WrAddrCnt   ) , //(O)Address Counter 
    .Addess         ( FifoWrAddr  )   //(O)Address Output
  );

  /////////////////////////////////////////////////// 
  reg [DW_C-1:0]      FifoBuff [DD_C-1:0];

  always @( posedge   WrClk)  
  begin
    if (WrEn & (~WrFull))   
    begin
      FifoBuff[FifoWrAddr[AW_C-1:0]]  <= # TCo_C WrData;
    end
  end
 
  /////////////////////////////////////////////////// 
 
  /////////////////////////////////////////////////// 
  wire                FifoEmpty   ;  
  wire                FifoRdEn    ;
                                  
  wire  [AW_C :0]     RdAddrCnt   ;
  wire  [AW_C :0]     FifoRdAddr  ;

  FifoAddrCnt     #(  .CounterWidth_C (AW_C))
  U2_RdAddrCnt
  (   
    //System Signal
    .Reset          ( RdClkRst    ) , //System Reset
    .SysClk         ( RdClk       ) , //System Clock
    //Counter Signal              
    .ClkEn          ( FifoRdEn    ) , //(I)Clock Enable 
    .FifoFlag       ( FifoEmpty   ) , //(I)Fifo Flag
    .AddrCnt        ( RdAddrCnt   ) , //(O)Address Counter 
    .Addess         ( FifoRdAddr  )   //(O)Address Output
  );

  ///////////////////////////////////////////////////   
  reg   [DW_C-1 :0]   FifoRdData  ;  

  always @( posedge   RdClk) 
  begin
    if (FifoRdEn)     FifoRdData  <= # TCo_C FifoBuff[FifoRdAddr[AW_C-1:0]];
  end

  ///////////////////////////////////////////////////  
  assign RdData   =   FifoRdData  ; //(O)Read Data
 
  reg   [AW_C:0]      WrRdAddr    = {AW_C+1{1'h0}}; 

  always @( posedge   WrClk)   
  begin
    if (WrClkRst)     WrRdAddr <= # TCo_C {AW_C+1{1'h0}}      ;
    else              WrRdAddr <= # TCo_C FifoRdAddr [AW_C:0] ;
  end

  ///////////////////////////////////////////////////////////   
  wire  [AW_C-1:0]    WrRdAHex;
  wire  [AW_C-1:0]    WrWrAHex;

  GrayDecode #(AW_C)  WRAGray2Hex (WrRdAddr   [AW_C-1:0] , WrRdAHex[AW_C-1:0]);
  GrayDecode #(AW_C)  WWAGray2Hex (FifoWrAddr [AW_C-1:0] , WrWrAHex[AW_C-1:0]);

  ///////////////////////////////////////////////////////////   
  reg   [AW_C-1:0]    WrAddrDiff;

  always @( posedge   WrClk)  
  begin
    if (WrFull)       WrAddrDiff <= # TCo_C {AW_C{1'h1}}          ;
    else              WrAddrDiff <= # TCo_C (WrWrAHex - WrRdAHex) ;
  end

  ///////////////////////////////////////////////////////////   
  assign  WrDNum  =   WrAddrDiff[AW_C-1:0];  //(O)Data Number In Fifo
 
  reg   [AW_C:0]      WrRdAddrReg = {AW_C+1{1'h0}}; 
                                  
  always @( posedge   WrClk)      
  begin                           
    if (  WrClkRst)   WrRdAddrReg <= # TCo_C {AW_C+1{1'h0}}     ;    
    else              WrRdAddrReg <= # TCo_C WrRdAddr[AW_C : 0] ;   
  end                             
                                    
  ///////////////////////////////////////////////////////////   
  reg                 RdAddrChg   = 1'h0;
  reg                 WrFullClr   = 1'h0;   
                      
  always @( posedge   WrClk)      
  begin                           
    if (  WrClkRst)   RdAddrChg   <= # TCo_C 1'h0         ;    
    else              RdAddrChg   <= # TCo_C (FifoWrFull  & (WrRdAddr[AW_C-1:0] != WrRdAddrReg[AW_C-1:0]));
  end                             
                                  
  always @( posedge   WrClk)      
  begin                           
    if (  WrClkRst)   WrFullClr   <= # TCo_C 1'h0         ;   
    else              WrFullClr   <= # TCo_C (FifoWrFull  &  RdAddrChg);
  end
  
  ///////////////////////////////////////////////////////////   
  reg   RdAHighNext   = 1'h0;
                      
  wire  RdAHighRise   = (~WrRdAddrReg[AW_C-1]) &  WrRdAddr[AW_C-1];  
                      
  always @( posedge   WrClk)  
  begin
    if (WrClkRst  )         RdAHighNext <= # TCo_C 1'h0 ;
    else if (RdAHighRise)   RdAHighNext <= # TCo_C (~WrRdAddr[AW_C])  ;
  end
  
  ///////////////////////////////////////////////////      
  wire  FullCalc = (WrAddrCnt[AW_C-1:0] ==  WrRdAddr[AW_C-1:0]) 
                && (WrAddrCnt[AW_C    ] != (WrRdAddr[AW_C-1] ? WrRdAddrReg[AW_C] : RdAHighNext) );
                
  /////////////////////////////////////////////////// 
  reg   FullFlag        = 1'h0;
                        
  always @( posedge     WrClk)
  begin
    if (WrClkRst)       FullFlag  <= # TCo_C 1'h0;
    else if (FullFlag)  FullFlag  <= # TCo_C (~WrFullClr);
    else if (FifoWrEn)  FullFlag  <= # TCo_C FullCalc;
  end
    
  assign FifoWrFull     = FullFlag;
   
  /////////////////////////////////////////////////// 
  assign  WrFull        = FifoWrFull  ; //(I)Write Full 
  
  reg   [AW_C :0]     RdWrAddr  = {AW_C+1{1'h0}}; 
  
  always @( posedge   RdClk)    
  begin
    if (RdClkRst )    RdWrAddr  <= # TCo_C {AW_C+1{1'h0}}       ;   
    else              RdWrAddr  <= # TCo_C FifoWrAddr [AW_C:0]  ;   
  end  

  ///////////////////////////////////////////////////////////   
  wire  [AW_C-1:0]    RdWrAHex;
  wire  [AW_C-1:0]    RdRdAHex;

  GrayDecode # (AW_C) RWAGray2Hex (RdWrAddr   [AW_C-1:0] , RdWrAHex[AW_C-1:0] );
  GrayDecode # (AW_C) RRAGray2Hex (FifoRdAddr [AW_C-1:0] , RdRdAHex[AW_C-1:0] );

  ///////////////////////////////////////////////////////////   
  reg   [AW_C-1:0]    RdAddrDiff;

  always @( posedge   RdClk)  
  begin
    if (RdEmpty )     RdAddrDiff <= # TCo_C {AW_C{1'h0}}          ; 
    else              RdAddrDiff <= # TCo_C (RdWrAHex - RdRdAHex) ;   
  end

  ///////////////////////////////////////////////////////////   
  assign  RdDNum    = RdAddrDiff[AW_C-1:0];   //(O)Data Number In Fifo
 
  reg   [AW_C:0]      RdWrAddrReg = {AW_C+1{1'h0}}; 
                      
  always @( posedge   RdClk)    
  begin               
    if (RdClkRst)     RdWrAddrReg <= # TCo_C {AW_C+1{1'h0}}     ;
    else              RdWrAddrReg <= # TCo_C RdWrAddr [AW_C:0]  ;
  end                 
  
  ///////////////////////////////////////////////////////////   
  reg                 WrAddrChg   = 1'h0;
  reg                 EmptyClr    = 1'h0;
                      
  always @( posedge   RdClk)   
  begin               
    if (RdClkRst)     WrAddrChg   <= # TCo_C 1'h0 ;
    else              WrAddrChg   <= # TCo_C FifoEmpty & (RdWrAddr[AW_C-1:0] != RdWrAddrReg[AW_C-1:0]);
  end                 
  always @( posedge   RdClk)       
  begin               
    if (RdClkRst)     EmptyClr    <= # TCo_C 1'h0;
    else              EmptyClr    <= # TCo_C (FifoEmpty & WrAddrChg);
  end
  
  ///////////////////////////////////////////////////////////   
  reg   WrAHighNext   = 1'h0;  
  
  wire  WrAHighRise   = (~RdWrAddrReg[AW_C-1]) &  RdWrAddr[AW_C-1];  
  
  always @( posedge   RdClk)  
  begin
    if (RdClkRst)           WrAHighNext   <= # TCo_C  1'h0 ;
    else if (WrAHighRise)   WrAHighNext   <= # TCo_C (~RdWrAddr[AW_C]);
  end
    
  ///////////////////////////////////////////////////////////                
  wire  EmptyCalc   = (RdAddrCnt[AW_C-1:0] == RdWrAddr[AW_C-1:0]) 
                   && (RdAddrCnt[AW_C    ] == (RdWrAddr[AW_C-1] ? RdWrAddrReg[AW_C] : WrAHighNext));
                                       
  /////////////////////////////////////////////////////////// 
  reg     EmptyFlag     = 1'h1;

  always @( posedge     RdClk)
  begin
    if (RdClkRst)       EmptyFlag   <= # TCo_C 1'h1;
    else if (EmptyFlag) EmptyFlag   <= # TCo_C (~EmptyClr);
    else if (FifoRdEn)  EmptyFlag   <= # TCo_C  EmptyCalc;
  end

  assign FifoEmpty    = EmptyFlag;
    
  /////////////////////////////////////////////////////////// 
  reg   EmptyReg      = 1'h0;

  always @( posedge     RdClk )
  begin
    if (RdClkRst)       EmptyReg  <= # TCo_C 1'h1;
    else  if (FifoRdEn) EmptyReg  <= # TCo_C FifoEmpty;
  end

  /////////////////////////////////////////////////////////// 
  assign RdEmpty = (FIFO_MODE == "ShowAhead") ? EmptyReg : FifoEmpty; //(O)Read FifoEmpty

  reg   RdFirst     = 1'h0;
    
  always @( posedge   RdClk)
  begin
    if (FIFO_MODE == "ShowAhead")
    begin
      if (RdClkRst)       RdFirst <= # TCo_C 1'h0     ;  
    	else if (RdFirst)	  RdFirst <= # TCo_C 1'h0     ;
    	else if (EmptyClr)	RdFirst <= # TCo_C RdEmpty  ;
    end
    else                  RdFirst <= # TCo_C 1'h0     ;
  end
    
  /////////////////////////////////////////////////////////// 
  assign FifoRdEn   =   RdEn ||  RdFirst ;

  /////////////////////////////////////////////////////////// 
  
//666666666666666666666666666666666666666666666666666666666

endmodule 

//////////////// DaulClkFifo //////////////////////////////

///////////////// FifoAddrCnt /////////////////////////////

module FifoAddrCnt
# (
    parameter CounterWidth_C  = 9   ,
    parameter CW_C            = CounterWidth_C
  )
(   
  //System Signal
  input             Reset     , //System Reset
  input             SysClk    , //System Clock
  //Counter Signal            
  input             ClkEn     , //(I)Clock Enable 
  input             FifoFlag  , //(I)Fifo Flag
  output  [CW_C:0]  AddrCnt   , //(O)Address Counter
  output  [CW_C:0]  Addess      //(O)Address Output
);

//Define  Parameter
///////////////////////////////////////////////////////////
localparam    TCo_C       = 1;    

  wire [CW_C-1:0]   GrayAddrCnt;
  wire              CarryOut;

  GrayCnt #(.CounterWidth_C (CW_C))
  U1_AddrCnt
  (   
    //System Signal
    .Reset    ( Reset       ),  //System Reset
    .SysClk   ( SysClk      ),  //System Clock
    //Counter Signal            
    .SyncClr  ( 1'h0        ),  //(I)Sync Clear
    .ClkEn    ( ClkEn       ),  //(I)Clock Enable 
    .CarryIn  ( ~FifoFlag   ),  //(I)Carry input
    .CarryOut ( CarryOut    ),  //(O)Carry output
    .Count    ( GrayAddrCnt )   //(O)Counter Value Output
  );
        
///////////////////////////////////////////////////////////
  reg   CntHighBit;

  always @( posedge SysClk )
  begin
    if (Reset)      CntHighBit <= # TCo_C 1'h0;
    else if (ClkEn) CntHighBit <= # TCo_C CntHighBit + CarryOut;
  end

///////////////////////////////////////////////////////////
  reg  [CW_C:0]  AddrOut;    //(O)Address Output

  always @(posedge SysClk)
  begin
    if (Reset)        AddrOut <= # TCo_C {CW_C{1'h0}};
    else if (ClkEn)   AddrOut <= # TCo_C FifoFlag ? AddrOut : AddrCnt;
  end    

///////////////////////////////////////////////////////////
  assign  AddrCnt  = {CntHighBit , GrayAddrCnt} ; //(O)Address Counter            
  assign  Addess   =  AddrOut                   ; //(O)Address Output    

//111111111111111111111111111111111111111111111111111111111

endmodule

/////////////////// FifoAddrCnt //////////////////////////

module GrayCnt
# (
    parameter   CounterWidth_C    = 9   ,
    parameter   CW_C              = CounterWidth_C
  )
( 
  //System Signal
  input                 Reset     , //System Reset
  input                 SysClk    , //System Clock
  //Counter Signal
  input                 SyncClr   , //(I)Sync Clear
  input                 ClkEn     , //(I)Clock Enable 
  input                 CarryIn   , //(I)Carry input
  output                CarryOut  , //(O)Carry output
  output  [CW_C-1:0]    Count       //(O)Counter Value Output
);

//Define  Parameter
///////////////////////////////////////////////////////////
localparam    TCo_C       = 1;    

  wire  [CW_C:0  ]  CryIn  ;
  wire  [CW_C-1:0]  CryOut ;

  reg   [CW_C-1:0]  GrayCnt;

  assign CryIn[0] = CarryIn;

  genvar i;
  generate
    for(i=0;i<CW_C;i=i+1)
    begin : GrayCnt_CrayCntUnit
      //////////////   
      always @( posedge SysClk )
      begin
        if (Reset)        GrayCnt[i]  <= # TCo_C (i>1) ? 1'h0: 1'h1  ;
        else if (SyncClr) GrayCnt[i]  <= # TCo_C (i>1) ? 1'h0: 1'h1  ;
        else if (ClkEn)   GrayCnt[i]  <= # TCo_C GrayCnt[i] + CryIn[i];
      end
      
      //////////////   
      if (i==0)    
      begin
        assign CryOut[0]  =  GrayCnt[0] && CarryIn;
        assign CryIn [1]  = ~GrayCnt[0] && CarryIn;
      end
      else    
      begin
        assign CryOut[i  ]  =  CryOut[  0] && (~|GrayCnt[i:1]);
        assign CryIn [i+1]  =  CryOut[i-1] &&    GrayCnt[i  ] ;  
      end
    end
    
  endgenerate

  wire GrayCarry = CryOut[CW_C-2];
  
///////////////////////////////////////////////////////////
  reg  CntHigh = 1'h0;

  always @( posedge SysClk)
  begin
    if (Reset)      CntHigh   <= # TCo_C 1'h0;
    else if (ClkEn) CntHigh   <= # TCo_C (CntHigh + GrayCarry);
  end

///////////////////////////////////////////////////////////
  assign Count    = {CntHigh  , GrayCnt[CW_C-1:1]}  ; //(O)Counter Value Output
  assign CarryOut =  CntHigh  & GrayCarry           ; //(O)Carry output
  
///////////////////////////////////////////////////////////

//111111111111111111111111111111111111111111111111111111111

endmodule

////////////////////// GrayCnt ////////////////////////////

module GrayDecode
# (
    parameter DataWidht_C = 8
  )
(   
  input   [DataWidht_C-1:0]  GrayIn,
  output  [DataWidht_C-1:0]  HexOut
);

 	//Define  Parameter
	///////////////////////////////////////////////////////////////
	parameter		TCo_C   		= 1;    
		
	localparam DW_C = DataWidht_C;
	
	///////////////////////////////////////////////////////////////
  reg [DW_C-1:0] Hex; 

  integer i;

  always @ (GrayIn)
  begin        
    Hex[DW_C-1]=GrayIn[DW_C-1];        
    for(i=DW_C-2;i>=0;i=i-1)   Hex[i]=Hex[i+1]^GrayIn[i];
  end
  	
  assign HexOut = Hex;

	///////////////////////////////////////////////////////////////

endmodule 
	
		
		
