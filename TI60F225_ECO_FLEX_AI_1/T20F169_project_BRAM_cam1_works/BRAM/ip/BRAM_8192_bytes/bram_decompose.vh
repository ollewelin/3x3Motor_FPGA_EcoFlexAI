localparam TOTAL_SIZE_A = 8192;
localparam TOTAL_SIZE_B = 8192;
localparam GROUP_COLUMNS       = 1;
localparam bram_table_size = 2;
localparam bram_table_loop_mode = 1;
localparam bram_mapping_size = 16;
localparam rMux_mapping_A_size = 1;
localparam rMux_mapping_B_size = 1;
localparam wen_sel_mapping_A_size = 1;
localparam wen_sel_mapping_B_size = 1;
localparam data_mapping_table_A_size = 0;
localparam data_mapping_table_B_size = 0;
localparam address_mapping_table_A_size = 0;
localparam address_mapping_table_B_size = 0;


function integer bram_feature_table;
input integer index;//Mode type 
input integer val_; //Address_width, data_width, en_width, reserved 
case (index)
0: bram_feature_table=(val_==0)?8:(val_==1)?20:(val_==2)?2:(val_==3)?0:(val_==4)?0:0;
1: bram_feature_table=(val_==0)?9:(val_==1)?10:(val_==2)?1:(val_==3)?0:(val_==4)?0:0;
2: bram_feature_table=(val_==0)?10:(val_==1)?5:(val_==2)?1:(val_==3)?0:(val_==4)?0:0;
3: bram_feature_table=(val_==0)?8:(val_==1)?16:(val_==2)?2:(val_==3)?0:(val_==4)?1:0;
4: bram_feature_table=(val_==0)?9:(val_==1)?8:(val_==2)?1:(val_==3)?0:(val_==4)?1:0;
5: bram_feature_table=(val_==0)?10:(val_==1)?4:(val_==2)?1:(val_==3)?0:(val_==4)?1:0;
6: bram_feature_table=(val_==0)?11:(val_==1)?2:(val_==2)?1:(val_==3)?0:(val_==4)?1:0;
7: bram_feature_table=(val_==0)?12:(val_==1)?1:(val_==2)?1:(val_==3)?0:(val_==4)?1:0;
   endcase
endfunction  


function integer bram_decompose_table;
input integer index;//Mode type 
input integer val_; //Port A index, Port B Index, Number of Items in Loop, Port A Start, Port B Start, reserved 
case (index)
   0: bram_decompose_table=(val_==0)?   7:(val_==1)?   7:(val_==2)?   8:(val_==3)?   0:(val_==4)?   0:0;
   1: bram_decompose_table=(val_==0)?   7:(val_==1)?   7:(val_==2)?   8:(val_==3)?   0:(val_==4)?   0:0;
   endcase
endfunction  


function integer bram_mapping_table;
input integer index;//Mode type 
input integer val_;//            Y,              X,              DataA [MSB],    DataA [LSB],    DataA Repeat,   Read MuxA,      Wen0 SelA,      Wen1 SelA,      Byteen A,       DataB [MSB],    DataB [LSB],    DataB Repeat,   Read MuxB,      Wen0 SelB,      Wen1 SelB,      Byteen B,       Addr Width A    Data Width A    Addr Width B    Data Width B    
case (index)
   0: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   0:(val_== 2)?   0:(val_== 3)?   0:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   0:(val_== 7)?   0:(val_== 8)?   0:(val_== 9)?   0:(val_==10)?   0:(val_==11)?   0:(val_==12)?   0:(val_==13)?   0:(val_==14)?   0:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
   1: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   1:(val_== 2)?   1:(val_== 3)?   1:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   0:(val_== 7)?   0:(val_== 8)?   0:(val_== 9)?   1:(val_==10)?   1:(val_==11)?   0:(val_==12)?   0:(val_==13)?   0:(val_==14)?   0:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
   2: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   2:(val_== 2)?   2:(val_== 3)?   2:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   0:(val_== 7)?   0:(val_== 8)?   0:(val_== 9)?   2:(val_==10)?   2:(val_==11)?   0:(val_==12)?   0:(val_==13)?   0:(val_==14)?   0:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
   3: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   3:(val_== 2)?   3:(val_== 3)?   3:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   0:(val_== 7)?   0:(val_== 8)?   0:(val_== 9)?   3:(val_==10)?   3:(val_==11)?   0:(val_==12)?   0:(val_==13)?   0:(val_==14)?   0:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
   4: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   4:(val_== 2)?   4:(val_== 3)?   4:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   0:(val_== 7)?   0:(val_== 8)?   0:(val_== 9)?   4:(val_==10)?   4:(val_==11)?   0:(val_==12)?   0:(val_==13)?   0:(val_==14)?   0:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
   5: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   5:(val_== 2)?   5:(val_== 3)?   5:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   0:(val_== 7)?   0:(val_== 8)?   0:(val_== 9)?   5:(val_==10)?   5:(val_==11)?   0:(val_==12)?   0:(val_==13)?   0:(val_==14)?   0:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
   6: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   6:(val_== 2)?   6:(val_== 3)?   6:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   0:(val_== 7)?   0:(val_== 8)?   0:(val_== 9)?   6:(val_==10)?   6:(val_==11)?   0:(val_==12)?   0:(val_==13)?   0:(val_==14)?   0:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
   7: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   7:(val_== 2)?   7:(val_== 3)?   7:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   0:(val_== 7)?   0:(val_== 8)?   0:(val_== 9)?   7:(val_==10)?   7:(val_==11)?   0:(val_==12)?   0:(val_==13)?   0:(val_==14)?   0:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
   8: bram_mapping_table=(val_== 0)?   1:(val_== 1)?   0:(val_== 2)?   0:(val_== 3)?   0:(val_== 4)?   0:(val_== 5)?   1:(val_== 6)?   1:(val_== 7)?   1:(val_== 8)?   0:(val_== 9)?   0:(val_==10)?   0:(val_==11)?   0:(val_==12)?   1:(val_==13)?   1:(val_==14)?   1:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
   9: bram_mapping_table=(val_== 0)?   1:(val_== 1)?   1:(val_== 2)?   1:(val_== 3)?   1:(val_== 4)?   0:(val_== 5)?   1:(val_== 6)?   1:(val_== 7)?   1:(val_== 8)?   0:(val_== 9)?   1:(val_==10)?   1:(val_==11)?   0:(val_==12)?   1:(val_==13)?   1:(val_==14)?   1:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
  10: bram_mapping_table=(val_== 0)?   1:(val_== 1)?   2:(val_== 2)?   2:(val_== 3)?   2:(val_== 4)?   0:(val_== 5)?   1:(val_== 6)?   1:(val_== 7)?   1:(val_== 8)?   0:(val_== 9)?   2:(val_==10)?   2:(val_==11)?   0:(val_==12)?   1:(val_==13)?   1:(val_==14)?   1:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
  11: bram_mapping_table=(val_== 0)?   1:(val_== 1)?   3:(val_== 2)?   3:(val_== 3)?   3:(val_== 4)?   0:(val_== 5)?   1:(val_== 6)?   1:(val_== 7)?   1:(val_== 8)?   0:(val_== 9)?   3:(val_==10)?   3:(val_==11)?   0:(val_==12)?   1:(val_==13)?   1:(val_==14)?   1:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
  12: bram_mapping_table=(val_== 0)?   1:(val_== 1)?   4:(val_== 2)?   4:(val_== 3)?   4:(val_== 4)?   0:(val_== 5)?   1:(val_== 6)?   1:(val_== 7)?   1:(val_== 8)?   0:(val_== 9)?   4:(val_==10)?   4:(val_==11)?   0:(val_==12)?   1:(val_==13)?   1:(val_==14)?   1:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
  13: bram_mapping_table=(val_== 0)?   1:(val_== 1)?   5:(val_== 2)?   5:(val_== 3)?   5:(val_== 4)?   0:(val_== 5)?   1:(val_== 6)?   1:(val_== 7)?   1:(val_== 8)?   0:(val_== 9)?   5:(val_==10)?   5:(val_==11)?   0:(val_==12)?   1:(val_==13)?   1:(val_==14)?   1:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
  14: bram_mapping_table=(val_== 0)?   1:(val_== 1)?   6:(val_== 2)?   6:(val_== 3)?   6:(val_== 4)?   0:(val_== 5)?   1:(val_== 6)?   1:(val_== 7)?   1:(val_== 8)?   0:(val_== 9)?   6:(val_==10)?   6:(val_==11)?   0:(val_==12)?   1:(val_==13)?   1:(val_==14)?   1:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
  15: bram_mapping_table=(val_== 0)?   1:(val_== 1)?   7:(val_== 2)?   7:(val_== 3)?   7:(val_== 4)?   0:(val_== 5)?   1:(val_== 6)?   1:(val_== 7)?   1:(val_== 8)?   0:(val_== 9)?   7:(val_==10)?   7:(val_==11)?   0:(val_==12)?   1:(val_==13)?   1:(val_==14)?   1:(val_==15)?   0:(val_==16)?  12:(val_==17)?   1:(val_==18)?  12:(val_==19)?   1:0;
   endcase
endfunction  


function integer rMux_mapping_table_A;
input integer index;//Mode type 
input integer val_;//            PortA Addr MSB, PortA Addr LSB, DataA[MSB],     DataA[LSB],     MuxSelA[MSB],   MuxSelA[LSB],   Bypass,         
case (index)
   0: rMux_mapping_table_A=(val_== 0)?  12:(val_== 1)?  12:(val_== 2)?   7:(val_== 3)?   0:(val_== 4)?   1:(val_== 5)?   0:(val_== 6)?   0:0;
   endcase
endfunction  


function integer rMux_mapping_table_B;
input integer index;//Mode type 
input integer val_;//            PortB Addr MSB, PortB Addr LSB, DataB[MSB],     DataB[LSB],     MuxSelB[MSB],   MuxSelB[LSB],   Bypass,         
case (index)
   0: rMux_mapping_table_B=(val_== 0)?  12:(val_== 1)?  12:(val_== 2)?   7:(val_== 3)?   0:(val_== 4)?   1:(val_== 5)?   0:(val_== 6)?   0:0;
   endcase
endfunction  


function integer wen_sel_mapping_table_A;
input integer index;//Mode type 
input integer val_;//              PortA Addr MSB,   PortA Addr LSB,   WenSelA[MSB],     WenSelA[LSB],     Bypass,         
case (index)
   0: wen_sel_mapping_table_A=(val_== 0)?  12:(val_== 1)?  12:(val_== 2)?   1:(val_== 3)?   0:(val_== 4)?   0:0;
   endcase
endfunction  


function integer wen_sel_mapping_table_B;
input integer index;//Mode type 
input integer val_;//            PortB Addr MSB, PortB Addr LSB, WenSelB[MSB],   WenSelB[LSB],   Bypass,         
case (index)
   0: wen_sel_mapping_table_B=(val_== 0)?  12:(val_== 1)?  12:(val_== 2)?   1:(val_== 3)?   0:(val_== 4)?   0:0;
   endcase
endfunction  


function integer data_mapping_table_A;
input integer index;// 
data_mapping_table_A = 0; 
endfunction  


function integer data_mapping_table_B;
input integer index;// 
data_mapping_table_B = 0; 
endfunction  


function integer address_mapping_table_A;
input integer index;// 
address_mapping_table_A = 0; 
endfunction  


function integer address_mapping_table_B;
input integer index;// 
address_mapping_table_B = 0; 
endfunction  
