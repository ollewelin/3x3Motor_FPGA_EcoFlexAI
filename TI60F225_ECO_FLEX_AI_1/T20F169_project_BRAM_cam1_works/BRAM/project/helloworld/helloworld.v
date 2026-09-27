/////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2013-2018 Efinix Inc. All rights reserved.
//
// helloworld.v
//
// *******************************
// Revisions:
// 0.0 Initial rev
// 1.0 Updated to use the Trion T8 board
// *******************************
/////////////////////////////////////////////////////////////////////////////

module helloworld (led, clk, rstn, reverse);
   parameter DELAY_SIZE = 9;
   parameter WIDTH = 5;
   
   /**
	* DWIDTH is the width of the LED outputs.
	* NUM_PATTERNS is 2xWIDTH.
	* AWIDTH is log2(NUM_PATTERNS).
	* MAX_COUNT is the value where the pattern counter should reset
	**/
   localparam DWIDTH = WIDTH;
   localparam AWIDTH = 4;
   localparam NUM_PATTERNS = 2 * WIDTH;
   localparam MAX_COUNT = NUM_PATTERNS * (2 ** DELAY_SIZE);
   localparam COUNTER_SIZE = AWIDTH + DELAY_SIZE;
         
   (* syn_peri_port = 0 *) output [DWIDTH-1:0] led;
   (* syn_peri_port = 0 *) input 			  clk;
   (* syn_peri_port = 0 *) input        rstn;
   (* syn_peri_port = 0 *) input reverse;
		
   wire [AWIDTH-1:0] raddr;
   reg [DWIDTH-1:0]  rdata;

   reg [DWIDTH-1:0]  mem [NUM_PATTERNS-1:0];
   reg [COUNTER_SIZE-1:0] counter = 0;

   integer 			 i;
   reg [DWIDTH-1:0]  init_data;
   initial begin
	  //$monitor("led=%b, raddr=%d, counter=%d", led, raddr, counter);
	  
	  // Initialize the memory with the LED pattern
	  init_data = 0;
      for (i=0;i<NUM_PATTERNS;i=i+1) begin
		 mem[i] = init_data;
		 init_data = {init_data[DWIDTH-2:0], ~init_data[DWIDTH-1]};
	  end
   end 

   // LED ROM
   always @(posedge clk) begin
	  rdata <= mem[raddr];
   end

   // Use the high-order counter bits as the ROM address
   assign raddr = counter[COUNTER_SIZE-1:DELAY_SIZE];

   // Delay counter
   always @(posedge clk) begin
	  if(~rstn)
		counter <= 0;
	  else if(reverse)
		if (counter == 0) counter <= MAX_COUNT-1;
		else counter <= counter - 1;
	  else
		if (counter == MAX_COUNT-1) counter <= 0;
		else counter <= counter + 1;
   end

   // Assign LED values, invert since low enables LED
   assign led = ~rdata;

endmodule // helloworld

//////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2018 Efinix Inc. All rights reserved.
//
// This   document  contains  proprietary information  which   is
// protected by  copyright. All rights  are reserved.  This notice
// refers to original work by Efinix, Inc. which may be derivitive
// of other work distributed under license of the authors.  In the
// case of derivative work, nothing in this notice overrides the
// original author's license agreement.  Where applicable, the 
// original license agreement is included in it's original 
// unmodified form immediately below this header.
//
// WARRANTY DISCLAIMER.  
//     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND 
//     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH 
//     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES, 
//     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF 
//     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR 
//     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED 
//     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.
//
// LIMITATION OF LIABILITY.  
//     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY 
//     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT 
//     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY 
//     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT, 
//     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY 
//     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF 
//     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR 
//     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN 
//     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER 
//     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
//     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
//     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR 
//     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT 
//     APPLY TO LICENSEE.
//
/////////////////////////////////////////////////////////////////////////////


    
