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
module reg_apb3#(
    parameter                       ADDR_WTH = 10
)
(
//Globle Signals
//
//APB3 Slave Interface
input                           s_apb3_clk,
input                           s_apb3_rstn,
input           [ADDR_WTH-1:0]  s_apb3_paddr,
input                           s_apb3_psel,
input                           s_apb3_penable,
output  reg                     s_apb3_pready,
input                           s_apb3_pwrite,//0:rd; 1:wr;
input           [31:0]          s_apb3_pwdata,
output  reg     [31:0]          s_apb3_prdata,
output  wire                    s_apb3_pslverror,
//Cfg Space Registers
//--Example Registers Field
output  reg                     mac_sw_rst,
output  reg                     axi4_st_mux_select,
output  reg                     pat_mux_select,
output  reg                     udp_pat_gen_en,
output  reg                     mac_pat_gen_en,
output  reg     [15:0]          pat_gen_num,
output  reg     [15:0]          pat_gen_ipg,
output  reg     [47:0]          pat_dst_mac,
output  reg     [47:0]          pat_src_mac,
output  reg     [15:0]          pat_mac_dlen,
output  reg     [31:0]          pat_src_ip,
output  reg     [31:0]          pat_dst_ip,
output  reg     [15:0]          pat_src_port,
output  reg     [15:0]          pat_dst_port,
output  reg     [15:0]          pat_udp_dlen
);
// Parameter Define 

// Register Define
reg     [ADDR_WTH-3:0]          loc_addr;
reg                             loc_wr_vld;
reg                             loc_rd_vld;

// Wire Define

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
//apb3 interface
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        loc_addr <= {ADDR_WTH-2{1'b0}};
	else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0))
		loc_addr <= s_apb3_paddr[2+:ADDR_WTH-2];
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        loc_wr_vld <= 1'b0;
	else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b1))
		loc_wr_vld <= 1'b1;
    else
        loc_wr_vld <= 1'b0;
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        loc_rd_vld <= 1'b0;
	else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b0))
		loc_rd_vld <= 1'b1;
    else
        loc_rd_vld <= 1'b0;
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        s_apb3_pready <= 1'b0;
	else if((loc_wr_vld == 1'b1) || (loc_rd_vld == 1'b1))
		s_apb3_pready <= 1'b1;
    else
        s_apb3_pready <= 1'b0;
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        s_apb3_prdata <= 32'h0;
	else if(loc_rd_vld == 1'b1)
        begin
            case(loc_addr)
            //Example Registers Field
            'h080 : s_apb3_prdata <= {31'h0,mac_sw_rst};
            'h081 : s_apb3_prdata <= {30'h0,pat_mux_select,axi4_st_mux_select};
            'h082 : s_apb3_prdata <= {30'h0,mac_pat_gen_en,udp_pat_gen_en};
            'h083 : s_apb3_prdata <= {pat_gen_ipg,pat_gen_num};
            'h084 : s_apb3_prdata <= pat_dst_mac[31:0];
            'h085 : s_apb3_prdata <= {16'h0,pat_dst_mac[47:32]};
            'h086 : s_apb3_prdata <= pat_src_mac[31:0];
            'h087 : s_apb3_prdata <= {16'h0,pat_src_mac[47:32]};
            'h088 : s_apb3_prdata <= {16'h0,pat_mac_dlen};
            'h089 : s_apb3_prdata <= pat_src_ip;
            'h08a : s_apb3_prdata <= pat_dst_ip;
            'h08b : s_apb3_prdata <= {pat_dst_port,pat_src_port};
            'h08c : s_apb3_prdata <= {16'h0,pat_udp_dlen};
            endcase
        end
end

assign s_apb3_pslverror = 1'b0;

/*----------------------------------------------------------------------------------*\
    Register Space -- Example Registers Field
\*----------------------------------------------------------------------------------*/
//loc_addr = 0x080; axi_addr = 0x200; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            mac_sw_rst <= 1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h080))
        begin
            mac_sw_rst <= s_apb3_pwdata[0];
        end
end

//loc_addr = 0x081; axi_addr = 0x204; RW;
//[axi4_st_mux_select] 0:pat tx mode; 1:rx2tx loopback mode;
//[pat_mux_select] 0:udp pat; 1:mac pat;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            axi4_st_mux_select <= 1'h0;
            pat_mux_select <= 1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h081))
        begin
            axi4_st_mux_select <= s_apb3_pwdata[0];
            pat_mux_select <= s_apb3_pwdata[1];
        end
end

//loc_addr = 0x082; axi_addr = 0x208; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            udp_pat_gen_en <= 1'h0;
            mac_pat_gen_en <= 1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h082))
        begin
            udp_pat_gen_en <= s_apb3_pwdata[0];
            mac_pat_gen_en <= s_apb3_pwdata[1];
        end
end

//loc_addr = 0x083; axi_addr = 0x20c; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_gen_num <= 16'h0;
            pat_gen_ipg <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h083))
        begin
            pat_gen_num <= s_apb3_pwdata[15:0];
            pat_gen_ipg <= s_apb3_pwdata[31:16];
        end
end

//loc_addr = 0x084; axi_addr = 0x210; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_dst_mac[31:0] <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h084))
        begin
            pat_dst_mac[31:0] <= s_apb3_pwdata[31:0];
        end
end

//loc_addr = 0x085; axi_addr = 0x214; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_dst_mac[47:32] <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h085))
        begin
            pat_dst_mac[47:32] <= s_apb3_pwdata[15:0];
        end
end

//loc_addr = 0x086; axi_addr = 0x218; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_src_mac[31:0] <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h086))
        begin
            pat_src_mac[31:0] <= s_apb3_pwdata[31:0];
        end
end

//loc_addr = 0x087; axi_addr = 0x21c; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_src_mac[47:32] <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h087))
        begin
            pat_src_mac[47:32] <= s_apb3_pwdata[15:0];
        end
end

//loc_addr = 0x088; axi_addr = 0x220; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_mac_dlen <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h088))
        begin
            pat_mac_dlen <= s_apb3_pwdata[15:0];
        end
end

//loc_addr = 0x089; axi_addr = 0x224; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_src_ip <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h089))
        begin
            pat_src_ip <= s_apb3_pwdata[31:0];
        end
end

//loc_addr = 0x08a; axi_addr = 0x228; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_dst_ip <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h08a))
        begin
            pat_dst_ip <= s_apb3_pwdata[31:0];
        end
end

//loc_addr = 0x08b; axi_addr = 0x22c; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_src_port <= 16'h0;
            pat_dst_port <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h08b))
        begin
            pat_src_port <= s_apb3_pwdata[15:0];
            pat_dst_port <= s_apb3_pwdata[31:16];
        end
end

//loc_addr = 0x08c; axi_addr = 0x230; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_udp_dlen <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h08c))
        begin
            pat_udp_dlen <= s_apb3_pwdata[15:0];
        end
end

/*----------------------------------------------------------------------------------*\
    Register Space -- The End
\*----------------------------------------------------------------------------------*/

endmodule
