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
`timescale 1 ns/100ps

`define SIM_MODE
`define RXFIFO_EN 1
`define RXFIFO_DTH 2048
`define TXFIFO_EN 1
`define TXFIFO_DTH 2048

module tb_top(
);

`include "rgmii_eth_efx_tsemac_define.svh"
// Parameter Define 
parameter TSET_CASE = 1;//Values range from "1" to "9"
parameter MAC_SPEED = 2;//4:1000M; 2:100M; 1:10M;
parameter PAT_TYPE = 1;//0:UDP Pattern; 1:MAC Pattern;
parameter DST_MAC_H = 16'habcd;
parameter DST_MAC_L = 32'hef22_1100;
parameter SRC_MAC_H = 16'heae8;
parameter SRC_MAC_L = 32'h5e00_60c8;
parameter MAC_DLEN = 16'd64;
parameter SRC_IP = 32'hc0a80164;        
parameter DST_IP = 32'hc0a80165;
parameter SRC_PORT = 16'h0521;
parameter DST_PORT = 16'h2715;
parameter UDP_DLEN = 16'h64;

// Register Define 
reg                             Reset;
reg                             clk_50m=0;
reg                             clk_125m=0;
reg                             clk_25m=0;
reg                             clk_2m5=0;
reg                             err_ins=0;
//--mac_reg command_config
reg                             tx_ena=0;
reg                             rx_ena=0;
reg                             xon_gen=0;
reg                             promis_en=0;
reg                             pad_en=0;
reg                             crc_fwd=0;
reg                             pause_ignore=0;
reg                             tx_addr_ins=0;
reg                             sw_reset=0;
reg                             loop_ena=0;
reg     [2:0]                   eth_speed=0;
reg                             xoff_gen=0;
reg                             cnt_reset=0;
//--APB3 Interface
reg     [9:0]                   m_apb3_paddr=0;
reg                             m_apb3_psel=0;
reg                             m_apb3_penable=0;
reg                             m_apb3_pwrite=0;
reg     [31:0]                  m_apb3_pwdata=0;

// Wire Define 
wire    [31:0]                  mac_command_config;
//--Transmit AXI4-Stream Interface
wire                            tx_axis_clk;
wire    [7:0]                   tx_axis_mac_tdata;
wire                            tx_axis_mac_tvalid;
wire                            tx_axis_mac_tlast;
wire                            tx_axis_mac_tuser;
wire                            tx_axis_mac_tready;
//--APB3 Interface
wire                            m_apb3_pready;
wire    [31:0]                  m_apb3_prdata;
wire                            m_apb3_pslverror;
//--AXI4-Lite Interface
wire    [9:0]                   axi_awaddr;
wire                            axi_awvalid;
wire                            axi_awready;
wire    [31:0]                  axi_wdata;
wire                            axi_wvalid;
wire                            axi_wready;
wire    [1:0]                   axi_bresp;
wire                            axi_bvalid;
wire                            axi_bready;
wire    [9:0]                   axi_araddr;
wire                            axi_arvalid;
wire                            axi_arready;
wire    [1:0]                   axi_rresp;
wire    [31:0]                  axi_rdata;
wire                            axi_rvalid;
wire                            axi_rready;
//--RGMII Interface
wire    [3:0]                   rgmii_txd_HI;
wire    [3:0]                   rgmii_txd_LO;
wire                            rgmii_tx_ctl;
wire                            rgmii_txc_HI;
wire                            rgmii_txc_LO;
wire                            rgmii_txc;
wire    [3:0]                   rgmii_rxd_HI;
wire    [3:0]                   rgmii_rxd_LO;
wire                            rgmii_rx_ctl;
wire                            rgmii_rxc;

wire                            rx_data_rlast;
wire                            udp_rx_data_rlast;
wire                            rx_data_ruser;
integer i;
//-----------------------------------------------------------------------------------//
//                                  THE Sim Behavior
//-----------------------------------------------------------------------------------//

initial
    begin
    	//$shm_open("test.shm");
        //$shm_probe(tb_top,"ACMTF");
     
		Reset	<=1;
	    #20		
        Reset	<=0;
        
        init_task();
        if(TSET_CASE == 1)
            test_case_1_task();
        else if(TSET_CASE == 2)
            test_case_2_task();
        else if(TSET_CASE == 3)
            test_case_3_task();
        else if(TSET_CASE == 4)
            test_case_4_task();
        else if(TSET_CASE == 5)
            test_case_5_task();
        else if(TSET_CASE == 6)
            test_case_6_task();
        else if(TSET_CASE == 7)
            test_case_7_task();
        else if(TSET_CASE == 8)
            test_case_8_task();
        else if(TSET_CASE == 9)
            test_case_9_task();
            
        #5000
        $display("TEST PASSED");
        $finish(1);
    end
    
//-----------------------------------------------------------------------------------//
//                                  THE Clock Generate
//-----------------------------------------------------------------------------------//
always clk_50m  = #(10)   ~clk_50m;
always clk_2m5  = #(200)  ~clk_2m5;
always clk_25m  = #(20)   ~clk_25m;
always clk_125m = #(4)    ~clk_125m;

//-----------------------------------------------------------------------------------//
//                                  THE Sim Condition
//-----------------------------------------------------------------------------------//
assign u_temac_ex.apb3_paddr = m_apb3_paddr;
assign u_temac_ex.apb3_psel = m_apb3_psel;
assign u_temac_ex.apb3_penable = m_apb3_penable;
assign m_apb3_pready = u_temac_ex.apb3_pready;
assign u_temac_ex.apb3_pwrite = m_apb3_pwrite;
assign u_temac_ex.apb3_pwdata = m_apb3_pwdata;
assign m_apb3_prdata = u_temac_ex.apb3_prdata;
assign m_apb3_pslverror = u_temac_ex.apb3_pslverror;
assign rx_data_rlast = u_temac_ex.u_mac_pat_gen.rlast;
assign rx_data_ruser = u_temac_ex.rx_axis_mac_tlast;
assign udp_rx_data_rlast = u_temac_ex.u_udp_pat_gen.rlast;

assign mac_command_config = {cnt_reset,7'h0,
                             1'h0,xoff_gen,3'h0,eth_speed[2:0],
                             loop_ena,1'h0,sw_reset,3'h0,tx_addr_ins,pause_ignore,
                             1'h0,crc_fwd,pad_en,promis_en,1'h0,xon_gen,rx_ena,tx_ena};

assign rgmii_rxd_HI = (err_ins) ? 4'h0 : rgmii_txd_LO;
assign rgmii_rxd_LO = (err_ins) ? 4'h0 : rgmii_txd_HI;
assign rgmii_rx_ctl = rgmii_tx_ctl;

assign rgmii_rxc = rgmii_txc;

reg [7:0] rx_data_cnt;
reg rdata_mismatch;

always @(posedge clk_125m or negedge Reset)
begin
    if(Reset == 1'b0)
        rx_data_cnt <= 8'h0;
    else if(u_temac_ex.rx_axis_mac_tlast)
        rx_data_cnt <= 8'h0;
    else if(u_temac_ex.rx_axis_mac_tvalid)
        rx_data_cnt <= rx_data_cnt + 1'b1;
end

always @(posedge clk_125m or negedge Reset)
begin
    if(Reset == 1'b0)
        rdata_mismatch <= 1'b0;
    else if (u_temac_ex.rx_axis_mac_tlast)
        rdata_mismatch <= 1'b0;
    else if(u_temac_ex.rx_axis_mac_tvalid && rx_data_cnt >= 8'd42) begin
        if ((rx_data_cnt - u_temac_ex.rx_axis_mac_tdata) != 8'd42)
            rdata_mismatch <= 1'b1;	
    end
end

//-----------------------------------------------------------------------------------//
//                                  THE DUT RX
//-----------------------------------------------------------------------------------//
temac_ex u_temac_ex
(
//Globle Signals
//----pll_0
//output  wire                    pll_0_reset,
    .clk                        (clk_50m                    ),
    .clk_125m                   (clk_125m                   ),
    .pll_0_locked               (!Reset                     ),
    .sw6                        (),
//TEMAC PHY RGMII Interface
    .rgmii_txd_HI               (rgmii_txd_HI               ),
    .rgmii_txd_LO               (rgmii_txd_LO               ),
    .rgmii_tx_ctl               (rgmii_tx_ctl               ),
    .rgmii_txc_HI               (rgmii_txc_HI               ),
    .rgmii_txc_LO               (rgmii_txc_LO               ),
    .rgmii_rxd_HI               (rgmii_rxd_HI               ),
    .rgmii_rxd_LO               (rgmii_rxd_LO               ),
    .rgmii_rx_ctl               (rgmii_rx_ctl               ),
    .rgmii_rxc                  (rgmii_rxc                  ),
//TEMAC PHY MDIO Interface
    .phy_mdi                    (1'b0                       ),
    .phy_mdo                    (                           ),
    .phy_mdo_en                 (                           ),
    .phy_mdc                    (                           )
);

/*----------------------- ODDR Region ----------------------------*/
//rgmii_txc
ODDR #(
    .DDR_CLK_EDGE               ("SAME_EDGE"                )// "OPPOSITE_EDGE" or "SAME_EDGE" 
) rgmii_txc_ddr (
    .Q                          (rgmii_txc                  ),// 1-bit DDR output
    .C                          (clk_125m                   ),// 1-bit clock input
    .CE                         (1'b1                       ),// 1-bit clock enable input
    .D1                         (rgmii_txc_HI               ),// 1-bit data input (positive edge)
    .D2                         (rgmii_txc_LO               ),// 1-bit data input (negative edge)
    .R                          (1'b0                       ),// 1-bit reset
    .S                          (1'b0                       )// 1-bit set
);

//-----------------------------------------------------------------------------------//
//                                  THE Base Task
//-----------------------------------------------------------------------------------//

//apb3 bus wr task
task apb3_wr;
    input [9:0] awaddr;
    input [31:0] wdata;

    begin
    @(posedge clk_50m);
        m_apb3_paddr <= awaddr;
        m_apb3_pwrite <= 1'b1;
        m_apb3_psel <= 1'b1;
        m_apb3_pwdata <= wdata;
    @(posedge clk_50m);
        m_apb3_penable <= 1;
    wait(m_apb3_pready);
    @(posedge clk_50m);
        m_apb3_paddr <= 0;
        m_apb3_pwrite <= 0;
        m_apb3_psel <= 0;
        m_apb3_pwdata <= 1'b0;
        m_apb3_penable <= 0;
    @(posedge clk_50m);
    end
endtask

//apb3 bus rd task
task apb3_rd;
    input [9:0] araddr;

    begin
    @(posedge clk_50m);
        m_apb3_paddr <= araddr;
        m_apb3_pwrite <= 1'b0;
        m_apb3_psel <= 1'b1;
    @(posedge clk_50m);
        m_apb3_penable <= 1;
    wait(m_apb3_pready);
    @(posedge clk_50m);
        m_apb3_paddr <= 0;
        m_apb3_pwrite <= 0;
        m_apb3_psel <= 0;
        m_apb3_penable <= 0;
    @(posedge clk_50m);
    end
endtask

//initial task
task init_task;
    begin
        //initial mac_reg 
        tx_ena <= 1'h1;
        rx_ena <= 1'h1;
        xon_gen <= 1'h0;
        promis_en <= 1'h0;
        pad_en <= 1'h0;
        crc_fwd <= 1'h0;
        pause_ignore <= 1'h0;
        tx_addr_ins <= 1'h0;
        sw_reset <= 1'h0;
        loop_ena <= 1'h0;
        eth_speed[2:0] <= MAC_SPEED;
        xoff_gen <= 1'h0;
        cnt_reset <= 1'h0;
        @(posedge clk_50m);
        $display("---- Configure TSE MAC IP register setting ----");
        apb3_wr('h2*4,mac_command_config);//mac_reg command_config

        //initial ex_reg 
        apb3_wr('h84*4,DST_MAC_L);//ex_reg pat_dst_mac[31:0]
        apb3_wr('h85*4,DST_MAC_H);//ex_reg pat_dst_mac[47:32]
        apb3_wr('h86*4,SRC_MAC_L);//ex_reg pat_src_mac[31:0]
        apb3_wr('h87*4,SRC_MAC_H);//ex_reg pat_src_mac[47:32]
        apb3_wr('h89*4,SRC_IP);//ex_reg pat_src_ip 
        apb3_wr('h8a*4,DST_IP);//ex_reg pat_dst_ip 
        apb3_wr('h8b*4,{DST_PORT,SRC_PORT});//ex_reg pat_dst_port & pat_src_port
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h81*4,32'h0);//ex_reg pat_mux_select & axi4_st_mux_select
            end
        else
            begin
                apb3_wr('h81*4,32'h2);//ex_reg pat_mux_select & axi4_st_mux_select
            end
    end
endtask

//pause frame generator task
task pause_gen_task;
    input [15:0] pause_quant;

    begin
        apb3_wr('h6*4,pause_quant);//mac_reg pause_quant
        
        xoff_gen <= 1'h1;
        @(posedge clk_50m);
        apb3_wr('h2*4,mac_command_config);//mac_reg command_config
        wait(u_temac_ex.u_tsemac.u_tsemac.u_tse_mac.u_tx_engine.u_tx_ctr.cur_state == 4'd4);
        xoff_gen <= 1'h0;
        @(posedge clk_50m);
        apb3_wr('h2*4,mac_command_config);//mac_reg command_config
    end
endtask

task check_rdata_task;
	input integer i;
	input [1:0] check_error_bit;
	begin
	
    while (rx_data_rlast == 0) @(posedge clk_125m);
    
    if (check_error_bit == 2'b01) begin
    	apb3_rd('h22*4);   // read ifInErrors
        if (|m_apb3_prdata == 0) begin
            $display("%t - Error: Expecting MAC packet ifInErrors to go high, ifInErrors = %h", $time, m_apb3_prdata);
            $fatal("FAIL: simulation fail");
        end
        else begin
            $display("%t - Correct MAC packet %d, received", $time, i);
        end
    end
    else if (check_error_bit == 2'b10) begin
        if (rx_data_ruser == 0) begin
            $display("%t - Error: Expecting MAC packet rx_data_ruser to go high, rx_data_ruser = %h", $time, rx_data_ruser);
            $fatal("FAIL: simulation fail");
        end
        else begin
            $display("%t - MAC packet %d is filtered", $time, i);
        end
    end
    else begin
    	apb3_rd('h22*4);   // read ifInErrors
        if (rdata_mismatch != 0) begin
            $display("%t - Error: Received data mismatch", $time);
            $fatal("FAIL: simulation fail");
        end
    	
        if (|m_apb3_prdata != 0) begin
            $display("%t - Error: There is an Error in the MAC received packet, ifInErrors = %h", $time, m_apb3_prdata);
            $fatal("FAIL: simulation fail");
        end
        else begin
            $display("%t - Correct MAC packet %d, received", $time, i);
        end
    end
	end
endtask

task check_udp_rdata_task;
	input integer i;
	input [1:0] check_error_bit;
	begin
	
    while (rx_data_rlast == 0) @(posedge clk_125m);
    
    if (check_error_bit == 2'b01) begin
    	apb3_rd('h22*4);   // read ifInErrors
        if (|m_apb3_prdata == 0) begin
            $display("%t - Error: Expecting UDP packet ifInErrors to go high, ifInErrors = %h", $time, m_apb3_prdata);
            $fatal("FAIL: simulation fail");
        end
        else begin
            $display("%t - Correct UDP packet %d, received", $time, i);
        end
    end
    else if (check_error_bit == 2'b10) begin
        if (rx_data_ruser == 0) begin
            $display("%t - Error: Expecting UDP packet rx_data_ruser to go high, rx_data_ruser = %h", $time, rx_data_ruser);
            $fatal("FAIL: simulation fail");
        end
        else begin
            $display("%t - UDP packet %d is filtered", $time, i);
        end
    end
    else begin
    	apb3_rd('h22*4);   // read ifInErrors
        if (rdata_mismatch != 0) begin
            $display("%t - Error: Received data mismatch", $time);
            $fatal("FAIL: simulation fail");
        end
    	
        if (|m_apb3_prdata != 0) begin
            $display("%t - Error: There is an Error in the UDP received packet, ifInErrors = %h", $time, m_apb3_prdata);
            $fatal("FAIL: simulation fail");
        end
        else begin
            $display("%t - Correct UDP packet %d, received", $time, i);
        end
    end
	end
endtask

//-----------------------------------------------------------------------------------//
//                                  THE Test Case Task
//-----------------------------------------------------------------------------------//
task test_case_1_task;
    begin
        apb3_wr('h81*4,32'h2);//ex_reg pat_mux_select & axi4_st_mux_select
        apb3_wr('h88*4,MAC_DLEN);//ex_reg pat_mac_dlen
        apb3_wr('h83*4,{16'h10,16'h3E8});//ex_reg pat_gen_ipg & pat_gen_num
        apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
        apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
        
        for (i=0; i<16'h3E8; i = i + 1) begin
            check_rdata_task(i, 2'b00);
        end
    end
endtask

task test_case_2_task;
    begin
        apb3_wr('h81*4,32'h0);//ex_reg pat_mux_select & axi4_st_mux_select
        apb3_wr('h8c*4,UDP_DLEN);//ex_reg pat_udp_dlen 
        apb3_wr('h83*4,{16'hff,16'h3E8});//ex_reg pat_gen_ipg & pat_gen_num
        apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
        apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
        
        for (i=0; i<16'h3E8; i = i + 1) begin
            check_udp_rdata_task(i, 2'b00);
        end
    end
endtask

task test_case_3_task;
begin
    begin   // to transmit tx packet after rx pause frame finished processed 
        apb3_wr('h88*4,16'd100);//ex_reg pat_mac_dlen
        apb3_wr('h8c*4,16'd100);//ex_reg pat_udp_dlen 
        apb3_wr('h83*4,{16'hf,16'h2});//ex_reg pat_gen_ipg & pat_gen_num
        
        //Send 2 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_udp_rdata_task(0, 2'b00);
                check_udp_rdata_task(1, 2'b00);
            end
        else
            begin
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_rdata_task(0, 2'b00);
                check_rdata_task(1, 2'b00);
            end

        //send 1 pause frames
        pause_gen_task(16'd8);
        
        while (rx_data_rlast == 0) @(posedge clk_125m);
        
        #1000  // to have some buffer to make sure the core process rx pause frame entirely
        
        //Send 2 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_udp_rdata_task(2, 2'b00);
                check_udp_rdata_task(3, 2'b00);
            end
        else
            begin
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en

                check_rdata_task(2, 2'b00);
                check_rdata_task(3, 2'b00);
            end
    end
    
    begin        
        //Send 2 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_udp_rdata_task(4, 2'b00);
                check_udp_rdata_task(5, 2'b00);
            end
        else
            begin
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_rdata_task(4, 2'b00);
                check_rdata_task(5, 2'b00);
            end

        //send 1 pause frames
        pause_gen_task(16'd8);

        //Send 2 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                // check to make sure entire pause frame is received
                while (rx_data_rlast == 0) @(posedge clk_125m);
                repeat(1) @(posedge clk_125m);
                
                check_udp_rdata_task(6, 2'b00);
                check_udp_rdata_task(7, 2'b00);
            end
        else
            begin
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                // check to make sure entire pause frame is received
                while (rx_data_rlast == 0) @(posedge clk_125m);
                repeat(1) @(posedge clk_125m);

                check_rdata_task(8, 2'b00);
                check_rdata_task(9, 2'b00);
            end
    end
end
endtask

task test_case_4_task;
    begin
        apb3_wr('h83*4,{16'hf,16'h1});//ex_reg pat_gen_ipg & pat_gen_num
        //Send 1 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h5*4,16'd9000+46);//mac_reg frm_length
                apb3_wr('h8c*4,16'd9000);//ex_reg pat_udp_dlen
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_udp_rdata_task(0, 2'b00);
            end
        else
            begin
                apb3_wr('h5*4,16'd9000+18);//mac_reg frm_length
                apb3_wr('h88*4,16'd9000);//ex_reg pat_mac_dlen
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_rdata_task(0, 2'b00);
            end
        //Send 1 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h8c*4,16'd9001);//ex_reg pat_udp_dlen
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_udp_rdata_task(1, 2'b01);
            end
        else
            begin
                apb3_wr('h88*4,16'd9001);//ex_reg pat_mac_dlen
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_rdata_task(1, 2'b01);
            end
    end
endtask

task test_case_5_task;
    begin
    	apb3_wr('h83*4,{16'hf,16'd20});//ex_reg pat_gen_ipg & pat_gen_num
    	
    	for (i=0; i<20; i = i + 1) begin
            apb3_wr('h88*4,i);//ex_reg pat_mac_dlen
            apb3_wr('h8c*4,i);//ex_reg pat_udp_dlen 
            
            //Send 1 mac frames
            if(PAT_TYPE == 1'b0)
                begin
                    apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                    apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                    
                    check_udp_rdata_task(i, 2'b00);
                end
            else
                begin
                    apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                    apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                    
                    check_rdata_task(i, 2'b00);
                end
         end
    end
endtask

task test_case_6_task;
    begin
        apb3_wr('h88*4,16'd64);//ex_reg pat_mac_dlen
        apb3_wr('h8c*4,16'd64);//ex_reg pat_udp_dlen 
        apb3_wr('h83*4,{16'hf,16'h1});//ex_reg pat_gen_ipg & pat_gen_num
        //Send 1 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_udp_rdata_task(0, 2'b00);
            end
        else
            begin
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_rdata_task(0, 2'b00);
            end
        //Send 1 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_udp_rdata_task(1, 2'b00);
            end
        else
            begin
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_rdata_task(1, 2'b00);
            end

        //Send 1 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h8c*4,16'd200);//ex_reg pat_udp_dlen 
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                $display("%t Wait for rgmii_rx_ctl to go high", $time);
                wait(u_temac_ex.u_tsemac.u_tsemac.rgmii_rx_ctl_HI == 1); 
                repeat(20) @(posedge rgmii_rxc);
                
                err_ins <= 1'b1;
                $display("%t - insert error", $time);
                repeat(4) @(posedge rgmii_rxc);
                err_ins <= 1'b0;
                $display("%t - deassert error", $time);
                
                check_udp_rdata_task(2, 2'b01);
            end
        else
            begin
                apb3_wr('h88*4,16'd200);//ex_reg pat_mac_dlen
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                $display("%t Wait for rgmii_rx_ctl to go high", $time);
                wait(u_temac_ex.u_tsemac.u_tsemac.rgmii_rx_ctl_HI == 1); 
                repeat(20) @(posedge rgmii_rxc);
                
                err_ins <= 1'b1;
                $display("%t - insert error", $time);
                repeat(4) @(posedge rgmii_rxc);
                err_ins <= 1'b0;
                $display("%t - deassert error", $time);
                
                check_rdata_task(2, 2'b01);
            end
    end
endtask

task test_case_7_task;
    begin
        apb3_wr('h88*4,16'd64);//ex_reg pat_mac_dlen
        apb3_wr('h8c*4,16'd64);//ex_reg pat_udp_dlen 
        apb3_wr('h83*4,{16'hf,16'h1});//ex_reg pat_gen_ipg & pat_gen_num
        //Send 1 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_udp_rdata_task(0, 2'b00);
            end
        else
            begin
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_rdata_task(0, 2'b00);
            end
        apb3_wr('h51*4,32'hffffffff);//mac_reg mac_addr_mask[31:0]
        apb3_wr('h52*4,16'hffff);//mac_reg mac_addr_mask[47:32]
        //Send 1 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_udp_rdata_task(1, 2'b10);
            end
        else
            begin
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_rdata_task(1, 2'b10);
            end
        apb3_wr('h84*4,32'hffffffff);//ex_reg pat_dst_mac[31:0]
        apb3_wr('h85*4,16'hffff);//ex_reg pat_dst_mac[47:32]
        //Send 1 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_udp_rdata_task(2, 2'b01);
            end
        else
            begin
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_rdata_task(2, 2'b01);
            end
        apb3_wr('h50*4,32'h1);//mac_reg broadcast_filter_en
        //Send 1 mac frames
        if(PAT_TYPE == 1'b0)
            begin
                apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_udp_rdata_task(3, 2'b10);
            end
        else
            begin
                apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
                
                check_rdata_task(3, 2'b10);
            end
    end
endtask

task test_case_8_task;   // small packet length & small inter-gap
    begin
        apb3_wr('h81*4,32'h2);//ex_reg pat_mux_select & axi4_st_mux_select
        apb3_wr('h88*4,MAC_DLEN);//ex_reg pat_mac_dlen
        apb3_wr('h83*4,{16'd12,16'd100});//ex_reg pat_gen_ipg & pat_gen_num
        apb3_wr('h82*4,32'h2);//ex_reg mac_pat_gen_en & udp_pat_gen_en
        apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
        
        for (i=0; i<16'd100; i = i + 1) begin
            check_rdata_task(i, 2'b00);
        end
    end
endtask

task test_case_9_task;   // small packet length & small inter-gap
    begin
        apb3_wr('h81*4,32'h0);//ex_reg pat_mux_select & axi4_st_mux_select
        apb3_wr('h8c*4,UDP_DLEN);//ex_reg pat_udp_dlen 
        apb3_wr('h83*4,{16'd12,16'd100});//ex_reg pat_gen_ipg & pat_gen_num
        apb3_wr('h82*4,32'h1);//ex_reg mac_pat_gen_en & udp_pat_gen_en
        apb3_wr('h82*4,32'h0);//ex_reg mac_pat_gen_en & udp_pat_gen_en
        
        for (i=0; i<16'd100; i = i + 1) begin
            check_udp_rdata_task(i, 2'b00);
        end
    end
endtask

endmodule
