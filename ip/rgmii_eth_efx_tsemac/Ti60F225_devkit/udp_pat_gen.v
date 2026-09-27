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
module udp_pat_gen
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
//IP Protocol Signals
input           [31:0]          src_ip,
input           [31:0]          dst_ip,
//UDP Protocol Signals
input           [15:0]          udp_dlen,
input           [15:0]          src_port,
input           [15:0]          dst_port,
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
localparam  VER = 4'h4;//IPv4
localparam  IHL = 4'h5;//Internet Header Length
localparam  TOS = 8'h0;//Type Of Service
localparam  FLG = 3'h0;//Flags
localparam  TTL	= 8'h40;//Time To Live
localparam  PTC	= 8'h11;//UDP Protocol

localparam  IDLE       = 3'h0;
localparam  UDP_CHKSUM = 3'h1;
localparam  IP_CHKSUM  = 3'h2;
localparam  PAT_IPG    = 3'h3;
localparam  PAT_GEN    = 3'h4;

// Register Define 
reg     [2:0]                   cur_state;
reg     [2:0]                   next_state;
reg                             pat_gen_en_dl1;
reg                             pat_gen_en_dl2;
reg     [31:0]                  src_ip_r;
reg     [31:0]                  dst_ip_r;
reg     [15:0]                  src_port_r;
reg     [15:0]                  dst_port_r;
reg                             pat_en;
reg                             infinite_en;
reg     [15:0]                  num_cnt;
reg     [15:0]                  udp_chksum_cnt;
reg     [3:0]                   ip_chksum_cnt;
reg     [15:0]                  ipg_cnt;
reg     [15:0]                  pat_cnt;
reg     [15:0]                  udp_len;
reg     [15:0]                  udp_chksum_num;
reg     [7:0]                   udp_data_h;
reg     [7:0]                   udp_data_l;
reg     [16:0]                  udp_chksum_r;
reg     [15:0]                  udp_chksum;
reg     [15:0]                  ip_len;
reg     [15:0]                  ip_id;
reg     [12:0]                  ip_ofs;
reg     [16:0]                  ip_chksum_r;
reg     [15:0]                  ip_chksum;

reg     [15:0]                  pat_gen_num_r;
reg     [15:0]                  pat_gen_ipg_r;
reg     [47:0]                  dst_mac_r;
reg     [47:0]                  src_mac_r;
reg     [15:0]                  udp_dlen_r;

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
        udp_dlen_r    <= 16'h0;
    end
    else begin
        pat_gen_num_r <= pat_gen_num;
        pat_gen_ipg_r <= pat_gen_ipg;
        dst_mac_r     <= dst_mac;
        src_mac_r     <= src_mac;
        udp_dlen_r    <= udp_dlen;
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
                next_state = UDP_CHKSUM;
            else 
                next_state = IDLE;

        UDP_CHKSUM :
            if(udp_chksum_cnt == udp_chksum_num)
                next_state = IP_CHKSUM;
            else 
                next_state = UDP_CHKSUM;

        IP_CHKSUM :
            if(ip_chksum_cnt == 4'd9)
                next_state = PAT_GEN;
            else 
                next_state = IP_CHKSUM;

        PAT_IPG :
            if((pat_en == 1'b1) || ((ipg_cnt == pat_gen_ipg_r) && (infinite_en == 1'b0) && (num_cnt == 16'h0)))
                next_state = IDLE;
            else if(ipg_cnt == pat_gen_ipg_r)
                next_state = IP_CHKSUM;
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

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        begin
            src_ip_r <= 32'h0;
            dst_ip_r <= 32'h0;
            src_port_r <= 16'h0;
            dst_port_r <= 16'h0;
        end
    else
        begin
            src_ip_r <= src_ip;
            dst_ip_r <= dst_ip;
            src_port_r <= src_port;
            dst_port_r <= dst_port;
        end
end

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

/*----------------------- UDP Protocol Region ----------------------------*/ 

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        udp_len <= 16'h0;
    else
        udp_len <= udp_dlen_r + 16'd8;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        udp_chksum_num <= 16'h0;
    else if(udp_dlen_r[0] == 1'b1)
        udp_chksum_num <= udp_dlen_r[15:1] + 16'd10;
    else
        udp_chksum_num <= udp_dlen_r[15:1] + 16'd9;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        begin
            udp_data_h <= 8'h0;
            udp_data_l <= 8'h0;
        end
    else if(cur_state == IDLE)
        begin
            udp_data_h <= 8'h0;
            udp_data_l <= 8'h1;
        end
    else if((cur_state == UDP_CHKSUM) && (udp_chksum_cnt >= 16'h9))
        begin
            udp_data_h <= udp_data_h + 8'h2;
            udp_data_l <= udp_data_l + 8'h2;
        end
end

//udp checksum calculate
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        udp_chksum_r <= 17'h0;
    else if(cur_state == IDLE)
        udp_chksum_r <= 17'h0;
    else if(cur_state == UDP_CHKSUM) begin
        if (udp_chksum_cnt <= 16'd8) begin
            case(udp_chksum_cnt[3:0])
                4'd0 : udp_chksum_r <= udp_chksum_r[15:0] + src_ip_r[31:16] + udp_chksum_r[16];
                4'd1 : udp_chksum_r <= udp_chksum_r[15:0] + src_ip_r[15:0] + udp_chksum_r[16];
                4'd2 : udp_chksum_r <= udp_chksum_r[15:0] + dst_ip_r[31:16] + udp_chksum_r[16];
                4'd3 : udp_chksum_r <= udp_chksum_r[15:0] + dst_ip_r[15:0] + udp_chksum_r[16];
                4'd4 : udp_chksum_r <= udp_chksum_r[15:0] + 16'h11 + udp_chksum_r[16];
                4'd5 : udp_chksum_r <= udp_chksum_r[15:0] + udp_len + udp_chksum_r[16];
                4'd6 : udp_chksum_r <= udp_chksum_r[15:0] + src_port_r + udp_chksum_r[16];
                4'd7 : udp_chksum_r <= udp_chksum_r[15:0] + dst_port_r + udp_chksum_r[16];
                4'd8 : udp_chksum_r <= udp_chksum_r[15:0] + udp_len + udp_chksum_r[16];
                default : udp_chksum_r <= 17'h0;
            endcase
        end
        else begin
            if(udp_chksum_cnt == udp_chksum_num)
                udp_chksum_r <= udp_chksum_r[15:0] + udp_chksum_r[16];
            else if((udp_chksum_cnt == udp_chksum_num-1) && (udp_dlen_r[0] == 1'b1))
                udp_chksum_r <= udp_chksum_r[15:0] + {udp_data_h,8'h0} + udp_chksum_r[16];
            else
                udp_chksum_r <= udp_chksum_r[15:0] + {udp_data_h,udp_data_l} + udp_chksum_r[16];
        end
    end
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        udp_chksum <= 16'h0;
    else
        udp_chksum <= ~udp_chksum_r[15:0];
end

/*----------------------- IP Protocol Region ----------------------------*/
//IP Frame Total Length
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        ip_len <= 16'h0;
    else
        ip_len <= udp_len + 16'd20;
end

//IP Frame Identification
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        ip_id <= 16'h0;
    else if((cur_state == PAT_GEN) && (tlast == 1'b1) && (tready == 1'b1))
        ip_id <= ip_id + 1'b1;
end

//IP Frame Fragment Offset
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        ip_chksum <= 16'h0;
    else
        ip_chksum <= ~ip_chksum_r[15:0];
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        ip_ofs <= 13'h0;
end

//ip checksum calculate
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        ip_chksum_r <= 16'h0;
    else if(cur_state == IDLE)
        ip_chksum_r <= 16'h0;
    else if(cur_state == IP_CHKSUM) begin
        case(ip_chksum_cnt)
        4'd0  : ip_chksum_r <= ip_chksum_r[15:0] + {VER,IHL,TOS} + ip_chksum_r[16];
        4'd1  : ip_chksum_r <= ip_chksum_r[15:0] + ip_len + ip_chksum_r[16];
        4'd2  : ip_chksum_r <= ip_chksum_r[15:0] + ip_id + ip_chksum_r[16];
        4'd3  : ip_chksum_r <= ip_chksum_r[15:0] + {FLG,ip_ofs} + ip_chksum_r[16];
        4'd4  : ip_chksum_r <= ip_chksum_r[15:0] + {TTL,PTC} + ip_chksum_r[16];
        4'd5  : ip_chksum_r <= ip_chksum_r[15:0] + src_ip_r[31:16] + ip_chksum_r[16];
        4'd6  : ip_chksum_r <= ip_chksum_r[15:0] + src_ip_r[15:0] + ip_chksum_r[16];
        4'd7  : ip_chksum_r <= ip_chksum_r[15:0] + dst_ip_r[31:16] + ip_chksum_r[16];
        4'd8  : ip_chksum_r <= ip_chksum_r[15:0] + dst_ip_r[15:0] + ip_chksum_r[16];
        4'd9  : ip_chksum_r <= ip_chksum_r[15:0] + ip_chksum_r[16];
        endcase
    end
    else if(cur_state == PAT_IPG)
    	ip_chksum_r <= 16'h0;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        ip_chksum <= 16'h0;
    else
        ip_chksum <= ~ip_chksum_r[15:0];
end

/*----------------------- Pattern Counter Region ----------------------------*/
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        udp_chksum_cnt <= 16'h0;
    else if(cur_state == UDP_CHKSUM)
        udp_chksum_cnt <= udp_chksum_cnt + 1'b1;
    else
        udp_chksum_cnt <= 16'h0;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        ip_chksum_cnt <= 4'h0;
    else if(cur_state == IP_CHKSUM)
        ip_chksum_cnt <= ip_chksum_cnt + 1'b1;
    else
        ip_chksum_cnt <= 4'h0;
end

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
    else if((cur_state == PAT_GEN) && (tready == 1'b1) && (pat_cnt <= 16'd42))
        case(pat_cnt[5:0])
        6'd0  : tdata <= dst_mac_r[5*8 +: 8];
        6'd1  : tdata <= dst_mac_r[4*8 +: 8];
        6'd2  : tdata <= dst_mac_r[3*8 +: 8];
        6'd3  : tdata <= dst_mac_r[2*8 +: 8];
        6'd4  : tdata <= dst_mac_r[1*8 +: 8];
        6'd5  : tdata <= dst_mac_r[0*8 +: 8];
        6'd6  : tdata <= src_mac_r[5*8 +: 8];
        6'd7  : tdata <= src_mac_r[4*8 +: 8];
        6'd8  : tdata <= src_mac_r[3*8 +: 8];
        6'd9  : tdata <= src_mac_r[2*8 +: 8];
        6'd10 : tdata <= src_mac_r[1*8 +: 8];
        6'd11 : tdata <= src_mac_r[0*8 +: 8];
        6'd12 : tdata <= 8'h08;
        6'd13 : tdata <= 8'h00;
        6'd14 : tdata <= {VER,IHL};
        6'd15 : tdata <= TOS;
        6'd16 : tdata <= ip_len[15:8];
        6'd17 : tdata <= ip_len[7:0];
        6'd18 : tdata <= ip_id[15:8];
        6'd19 : tdata <= ip_id[7:0];
        6'd20 : tdata <= {FLG,ip_ofs[12:8]};
        6'd21 : tdata <= ip_ofs[7:0];
        6'd22 : tdata <= TTL;
        6'd23 : tdata <= PTC;
        6'd24 : tdata <= ip_chksum[15:8];
        6'd25 : tdata <= ip_chksum[7:0];
        6'd26 : tdata <= src_ip_r[3*8 +: 8];
        6'd27 : tdata <= src_ip_r[2*8 +: 8];
        6'd28 : tdata <= src_ip_r[1*8 +: 8];
        6'd29 : tdata <= src_ip_r[0*8 +: 8];
        6'd30 : tdata <= dst_ip_r[3*8 +: 8];
        6'd31 : tdata <= dst_ip_r[2*8 +: 8];
        6'd32 : tdata <= dst_ip_r[1*8 +: 8];
        6'd33 : tdata <= dst_ip_r[0*8 +: 8];
        6'd34 : tdata <= src_port_r[15:8];
        6'd35 : tdata <= src_port_r[7:0];
        6'd36 : tdata <= dst_port_r[15:8];
        6'd37 : tdata <= dst_port_r[7:0];
        6'd38 : tdata <= udp_len[15:8];
        6'd39 : tdata <= udp_len[7:0];
        6'd40 : tdata <= udp_chksum[15:8];
        6'd41 : tdata <= udp_chksum[7:0];
        6'd42 : tdata <= 8'h0;//UDP First Data
        default : tdata <= tdata + 1'b1;
        endcase
    else if((cur_state == PAT_GEN) && (tready == 1'b1))
        tdata <= tdata + 1'b1;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        tlast <= 1'b0;
    else if((tready == 1'b1) && (cur_state == PAT_GEN) && (pat_cnt == ip_len+16'd13))
        tlast <= 1'b1;
    else if(tready == 1'b1)
        tlast <= 1'b0;
end

endmodule
