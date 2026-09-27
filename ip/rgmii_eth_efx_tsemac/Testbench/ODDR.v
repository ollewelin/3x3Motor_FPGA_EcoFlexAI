`timescale 1 ps / 1 ps

`celldefine

module ODDR (Q, C, CE, D1, D2, R, S);
    
    output Q;
    
    input C;
    input CE;
    input D1;
    input D2;    
    input R;
    input S;

    parameter DDR_CLK_EDGE = "OPPOSITE_EDGE";    
    parameter INIT = 1'b0;
    parameter [0:0] IS_C_INVERTED = 1'b0;
    parameter [0:0] IS_D1_INVERTED = 1'b0;
    parameter [0:0] IS_D2_INVERTED = 1'b0;

    parameter SRTYPE = "SYNC";
    parameter ROC_WIDTH = 100000;

    localparam MODULE_NAME = "ODDR";

    pulldown P1 (R);
    pulldown P2 (S);

    reg GSR;
    reg q_out = INIT, qd2_posedge_int;    
    
    wire c_in,delay_c;
    wire ce_in,delay_ce;
    wire d1_in,delay_d1;
    wire d2_in,delay_d2;
    wire gsr_in;
    wire r_in,delay_r;
    wire s_in,delay_s;

    assign gsr_in = GSR;
    assign Q = q_out;
    
    initial begin
	GSR = 1'b1;
	#(ROC_WIDTH)
	GSR = 1'b0;
    end

    initial begin

   if ((INIT != 0) && (INIT != 1)) begin
       $display("Attribute Syntax Error : The attribute INIT on %s instance %m is set to %d.  Legal values for this attribute are 0 or 1.", MODULE_NAME, INIT);
       #1 $finish;
   end
   
       if ((DDR_CLK_EDGE != "OPPOSITE_EDGE") && (DDR_CLK_EDGE != "SAME_EDGE")) begin
       $display("Attribute Syntax Error : The attribute DDR_CLK_EDGE on %s instance %m is set to %s.  Legal values for this attribute are OPPOSITE_EDGE or SAME_EDGE.", MODULE_NAME, DDR_CLK_EDGE);
       #1 $finish;
   end
   
   if ((SRTYPE != "ASYNC") && (SRTYPE != "SYNC")) begin
       $display("Attribute Syntax Error : The attribute SRTYPE on %s instance %m is set to %s.  Legal values for this attribute are ASYNC or SYNC.", MODULE_NAME, SRTYPE);
       #1 $finish;
   end

    end // initial begin
    

    always @(gsr_in or r_in or s_in) begin
   if (gsr_in == 1'b1) begin
       assign q_out = INIT;
       assign qd2_posedge_int = INIT;
   end
   else if (gsr_in == 1'b0) begin
       if (r_in == 1'b1 && SRTYPE == "ASYNC") begin
      assign q_out = 1'b0;
      assign qd2_posedge_int = 1'b0;
       end
       else if (r_in == 1'b0 && s_in == 1'b1 && SRTYPE == "ASYNC") begin
      assign q_out = 1'b1;
      assign qd2_posedge_int = 1'b1;
       end
       else if ((r_in == 1'b1 || s_in == 1'b1) && SRTYPE == "SYNC") begin
      deassign q_out;
      deassign qd2_posedge_int;
       end       
       else if (r_in == 1'b0 && s_in == 1'b0) begin
      deassign q_out;
      deassign qd2_posedge_int;
       end
   end // if (gsr_in == 1'b0)
    end // always @ (gsr_in or r_in or s_in)

       
    always @(posedge c_in) begin
    if (r_in == 1'b1) begin
       q_out <= 1'b0;
       qd2_posedge_int <= 1'b0;
   end
   else if (r_in == 1'b0 && s_in == 1'b1) begin
       q_out <= 1'b1;
       qd2_posedge_int <= 1'b1;
   end
   else if (ce_in == 1'b1 && r_in == 1'b0 && s_in == 1'b0) begin
       q_out <= d1_in;
       qd2_posedge_int <= d2_in;
   end
// CR 527698 
   else if (ce_in == 1'b0 && r_in == 1'b0 && s_in == 1'b0) begin
       qd2_posedge_int <= q_out;
   end
    end // always @ (posedge c_in)
    
   
    always @(negedge c_in) begin
   if (r_in == 1'b1)
       q_out <= 1'b0;
   else if (r_in == 1'b0 && s_in == 1'b1)
       q_out <= 1'b1;
   else if (ce_in == 1'b1 && r_in == 1'b0 && s_in == 1'b0) begin
       if (DDR_CLK_EDGE == "SAME_EDGE")
      q_out <= qd2_posedge_int;
       else if (DDR_CLK_EDGE == "OPPOSITE_EDGE")
      q_out <= d2_in;
   end
    end // always @ (negedge c_in)

    assign delay_c = C;
    assign delay_ce = CE;
    assign delay_d1 =  D1;
    assign delay_d2 =  D2;
    assign delay_r = R;
    assign delay_s = S;

    assign c_in = IS_C_INVERTED ^ delay_c;
    assign ce_in = delay_ce;
    assign d1_in = IS_D1_INVERTED ^ delay_d1;
    assign d2_in = IS_D2_INVERTED ^ delay_d2;
    assign r_in = delay_r;
    assign s_in = delay_s;


//*** Timing Checks Start here

   specify

   (C => Q) = (100:100:100, 100:100:100);
    (posedge R => (Q +: 0)) = (0:0:0, 0:0:0);
    (posedge S => (Q +: 0)) = (0:0:0, 0:0:0);

   specparam PATHPULSE$ = 0;
   
   endspecify

endmodule // ODDR

`endcelldefine

