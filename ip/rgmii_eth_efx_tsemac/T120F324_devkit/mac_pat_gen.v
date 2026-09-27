/////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2020 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   
//       / / .'     /    
//    __/ /.'      /     
//   __   \       /      
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// *******************************
// Revisions:
// 1.0 Initial rev
//
// *******************************
`timescale 1 ns / 1 ns
module mac_pat_gen
(
//Globle Signals
input                           clk,
input                           rstn,
//Control Interface
input                           pat_gen_en,
input           [15:0]          pat_gen_num,//When value is 0, it's infinite mode
input           [15:0]          pat_gen_ipg,
//MAC Protocol Signals
input           [47:0]          dst_mac,
input           [47:0]          src_mac,
input           [15:0]          mac_dlen,
//AXI4-Stream Interface
input                           rclk,
input                           rrstn,
input           [7:0]           rdata,
input                           rvalid,
input                           rlast,

output  reg     [7:0]           tdata,
output  reg                     tvalid,
output  reg                     tlast,
input                           tready
);

// Parameter Define 
localparam  IDLE     = 2'h0;
localparam  PAT_IPG  = 2'h1;
localparam  PAT_GEN  = 2'h2;

// Register Define 
reg                             pat_gen_en_dl1;
reg                             pat_gen_en_dl2;
reg     [1:0]                   cur_state;
reg     [1:0]                   next_state;
reg                             pat_en;
reg                             infinite_en;
reg     [15:0]                  num_cnt;
reg     [15:0]                  ipg_cnt;
reg     [15:0]                  pat_cnt;

reg     [15:0]                  pat_gen_num_r;
reg     [15:0]                  pat_gen_ipg_r;
reg     [47:0]                  dst_mac_r;
reg     [47:0]                  src_mac_r;
reg     [15:0]                  mac_dlen_r;

// Wire Define

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0) begin
        pat_gen_num_r <= 16'h0;
        pat_gen_ipg_r <= 16'h0;
        dst_mac_r     <= 48'h0;
        src_mac_r     <= 48'h0;
        mac_dlen_r    <= 16'h0;
    end
    else begin
        pat_gen_num_r <= pat_gen_num;
        pat_gen_ipg_r <= pat_gen_ipg;
        dst_mac_r     <= dst_mac;
        src_mac_r     <= src_mac;
        mac_dlen_r    <= mac_dlen;
    end
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        begin
            pat_gen_en_dl1 <= 1'h0;
            pat_gen_en_dl2 <= 1'h0;
        end
    else
        begin
            pat_gen_en_dl1 <= pat_gen_en;
            pat_gen_en_dl2 <= pat_gen_en_dl1;
        end
end

/*----------------------- FSM Region ----------------------------*/
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        cur_state <= IDLE;
    else
		cur_state <= next_state;
end

always @(*)
    begin
		case(cur_state)
        IDLE :
            if(pat_en == 1'b1)
                next_state = PAT_GEN;
            else 
                next_state = IDLE;

        PAT_IPG :
            if((pat_en == 1'b1) || ((ipg_cnt == pat_gen_ipg_r) && (infinite_en == 1'b0) && (num_cnt == 16'h0)))
                next_state = IDLE;
            else if(ipg_cnt == pat_gen_ipg_r)
                next_state = PAT_GEN;
            else 
                next_state = PAT_IPG;

		PAT_GEN :
            if((tlast == 1'b1) && (tready == 1'b1))
                next_state = PAT_IPG;
            else
                next_state = PAT_GEN;

        default :
            next_state = IDLE;
        endcase
  end

/*----------------------- Generator Control Region ----------------------------*/
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        pat_en <= 1'h0;
    else if((pat_gen_en_dl2 == 1'b0) && (pat_gen_en_dl1 == 1'b1))
        pat_en <= 1'h1;
    else if((cur_state == IDLE) && (pat_en == 1'b1))
        pat_en <= 1'h0;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        infinite_en <= 1'h0;
    else if((pat_gen_en_dl2 == 1'b0) && (pat_gen_en_dl1 == 1'b1) && (pat_gen_num_r == 16'h0))
        infinite_en <= 1'h1;
    else if((pat_gen_en_dl2 == 1'b0) && (pat_gen_en_dl1 == 1'b1))
        infinite_en <= 1'h0;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        num_cnt <= 16'h0;
    else if((pat_gen_en_dl2 == 1'b0) && (pat_gen_en_dl1 == 1'b1))
        num_cnt <= pat_gen_num_r;
    else if((cur_state == PAT_GEN) && (tlast == 1'b1) && (tready == 1'b1) && (num_cnt != 16'h0))
        num_cnt <= num_cnt - 1'b1;
end

/*----------------------- Pattern Counter Region ----------------------------*/
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        ipg_cnt <= 16'h0;
    else if(cur_state == PAT_IPG)
        ipg_cnt <= ipg_cnt + 1'b1;
    else
        ipg_cnt <= 8'h0;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        pat_cnt <= 16'h0;
    else if(cur_state != PAT_GEN)
        pat_cnt <= 16'h0;
    else if(tready == 1'b1)
        pat_cnt <= pat_cnt + 1'b1;
end

/*----------------------- Pattern Generator Region ----------------------------*/

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        tvalid <= 1'b0;
    else if((cur_state == PAT_GEN) && (pat_cnt == 16'h0) && (tready == 1'b1))
        tvalid <= 1'b1;
    else if((tready == 1'b1) && (tlast == 1'b1))
        tvalid <= 1'b0;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        tdata <= 8'h0;
    else if((cur_state == PAT_GEN) && (tready == 1'b1) && (pat_cnt <= 16'd14))
        case(pat_cnt[3:0])
        4'd0  : tdata <= dst_mac_r[5*8 +: 8];
        4'd1  : tdata <= dst_mac_r[4*8 +: 8];
        4'd2  : tdata <= dst_mac_r[3*8 +: 8];
        4'd3  : tdata <= dst_mac_r[2*8 +: 8];
        4'd4  : tdata <= dst_mac_r[1*8 +: 8];
        4'd5  : tdata <= dst_mac_r[0*8 +: 8];
        4'd6  : tdata <= src_mac_r[5*8 +: 8];
        4'd7  : tdata <= src_mac_r[4*8 +: 8];
        4'd8  : tdata <= src_mac_r[3*8 +: 8];
        4'd9  : tdata <= src_mac_r[2*8 +: 8];
        4'd10 : tdata <= src_mac_r[1*8 +: 8];
        4'd11 : tdata <= src_mac_r[0*8 +: 8];
        4'd12 : tdata <= mac_dlen_r[15:8];
        4'd13 : tdata <= mac_dlen_r[7:0];
        4'd14 : tdata <= 8'h0;//MAC First Data
        default : tdata <= tdata + 1'b1;
        endcase
    else if((cur_state == PAT_GEN) && (tready == 1'b1))
        tdata <= tdata + 1'b1;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        tlast <= 1'b0;
    else if((tready == 1'b1) && (cur_state == PAT_GEN) && (pat_cnt == mac_dlen_r+16'd13))
        tlast <= 1'b1;
    else if(tready == 1'b1)
        tlast <= 1'b0;
end

endmodule
