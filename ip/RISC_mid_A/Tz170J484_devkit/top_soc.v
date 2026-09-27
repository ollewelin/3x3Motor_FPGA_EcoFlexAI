/////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2013-2023 Efinix Inc. All rights reserved.
//
// Description:
// Example top file for EfxSapphireSoc
//
// Language:  Verilog 2001
//
// ------------------------------------------------------------------------------
// REVISION:
//  $Snapshot: $
//  $Id:$
//
// History:
// 1.0 Initial Release. 
/////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module top_soc (
output		system_i2c_0_io_sda_writeEnable,
output		system_i2c_0_io_sda_write,
input		system_i2c_0_io_sda_read,
output		system_i2c_0_io_scl_writeEnable,
output		system_i2c_0_io_scl_write,
input		system_i2c_0_io_scl_read,
input [3:0] system_gpio_0_io_read,
output [3:0] system_gpio_0_io_write,
output [3:0] system_gpio_0_io_writeEnable,
input		jtag_inst1_TCK,
input		jtag_inst1_TDI,
output		jtag_inst1_TDO,
input		jtag_inst1_SEL,
input		jtag_inst1_CAPTURE,
input		jtag_inst1_SHIFT,
input		jtag_inst1_UPDATE,
input		jtag_inst1_RESET,
output		system_spi_0_io_sclk_write,
output		system_spi_0_io_data_0_writeEnable,
input		system_spi_0_io_data_0_read,
output		system_spi_0_io_data_0_write,
output		system_spi_0_io_data_1_writeEnable,
input		system_spi_0_io_data_1_read,
output		system_spi_0_io_data_1_write,
output		system_spi_0_io_ss,

output      systemClk_rstn,
input       systemClk_locked,
input       io_systemClk,
input       io_asyncResetn_in

);
/////////////////////////////////////////////////////////////////////////////
			
//Reset and PLL
wire 		reset;
wire        w_io_asyncReset;
wire		io_systemReset;
wire        io_asyncResetn;
wire userInterrupt_0;
wire [15:0] io_apbSlave_0_PADDR;
wire		io_apbSlave_0_PSEL;
wire		io_apbSlave_0_PENABLE;
wire		io_apbSlave_0_PREADY;
wire		io_apbSlave_0_PWRITE;
wire [31:0] io_apbSlave_0_PWDATA;
wire [31:0] io_apbSlave_0_PRDATA;
wire		io_apbSlave_0_PSLVERROR;
wire		start;
wire [31:0] iaddr;
wire [31:0] idata;
wire [7:0]  ilen;
wire [1:0]  status;
wire axi4Interrupt;
wire [7:0] axi_awid;
wire [31:0] axi_awaddr;
wire [7:0]  axi_awlen;
wire [2:0]  axi_awsize;
wire [1:0]  axi_awburst;
wire		axi_awlock;
wire [3:0]  axi_awcache;
wire [2:0]  axi_awprot;
wire [3:0]  axi_awqos;
wire [3:0]  axi_awregion;
wire		axi_awvalid;
wire		axi_awready;
wire [31:0] axi_wdata;
wire [3:0] axi_wstrb;
wire		axi_wvalid;
wire		axi_wlast;
wire		axi_wready;
wire [7:0] axi_bid;
wire [1:0] axi_bresp;
wire		axi_bvalid;
wire		axi_bready;
wire [7:0]  axi_arid;
wire [31:0] axi_araddr;
wire [7:0]  axi_arlen;
wire [2:0]  axi_arsize;
wire [1:0]  axi_arburst;
wire		axi_arlock;
wire [3:0]  axi_arcache;
wire [2:0]  axi_arprot;
wire [3:0]  axi_arqos;
wire [3:0]  axi_arregion;
wire		axi_arvalid;
wire		axi_arready;
wire [7:0]  axi_rid;
wire [31:0] axi_rdata;
wire [1:0]  axi_rresp;
wire		axi_rlast;
wire		axi_rvalid;
wire		axi_rready;


/////////////////////////////////////////////////////////////////////////////
//Reset and PLL
assign systemClk_rstn 	= 1'b1;


assign w_io_asyncReset = reset ;
assign system_i2c_0_io_sda_writeEnable = !system_i2c_0_io_sda_write;
assign system_i2c_0_io_scl_writeEnable = !system_i2c_0_io_scl_write;
assign reset = ~( io_asyncResetn & systemClk_locked );


/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
reset_synchronizer io_asyncResetn_sync
(
 .reset_in(io_asyncResetn_in),
 .reset_out(io_asyncResetn),
 .clk(io_systemClk)
);

timer_start #(
.MHZ(50),
.SECOND(10),
.PULSE(1)
) intr_s0 (
.clk(io_systemClk),
.rst_n(~io_systemReset),
.start(userInterrupt_0));

axi4_slave #(
.ADDR_WIDTH(32),
.DATA_WIDTH(32)
) axi_slave_0 (
.axi_interrupt(axi4Interrupt),
.axi_aclk(io_systemClk),
.axi_resetn(~io_systemReset),
.axi_awid(axi_awid),
.axi_awaddr(axi_awaddr),
.axi_awlen(axi_awlen),
.axi_awsize(axi_awsize),
.axi_awburst(axi_awburst),
.axi_awlock(axi_awlock),
.axi_awcache(axi_awcache),
.axi_awprot(axi_awprot),
.axi_awqos(axi_awqos),
.axi_awregion(axi_awregion),
.axi_awvalid(axi_awvalid),
.axi_awready(axi_awready),
.axi_wdata(axi_wdata),
.axi_wstrb(axi_wstrb),
.axi_wlast(axi_wlast),
.axi_wvalid(axi_wvalid),
.axi_wready(axi_wready),
.axi_bid(axi_bid),
.axi_bresp(axi_bresp),
.axi_bvalid(axi_bvalid),
.axi_bready(axi_bready),
.axi_arid(axi_arid),
.axi_araddr(axi_araddr),
.axi_arlen(axi_arlen),
.axi_arsize(axi_arsize),
.axi_arburst(axi_arburst),
.axi_arlock(axi_arlock),
.axi_arcache(axi_arcache),
.axi_arprot(axi_arprot),
.axi_arqos(axi_arqos),
.axi_arregion(axi_arregion),
.axi_arvalid(axi_arvalid),
.axi_arready(axi_arready),
.axi_rid(axi_rid),
.axi_rdata(axi_rdata),
.axi_rresp(axi_rresp),
.axi_rlast(axi_rlast),
.axi_rvalid(axi_rvalid),
.axi_rready(axi_rready));

apb3_slave #(
.ADDR_WIDTH(16)) apb_slave_0 (
.clk(io_systemClk),
.resetn(~io_systemReset),
.PADDR(io_apbSlave_0_PADDR),
.PSEL(io_apbSlave_0_PSEL),
.PENABLE(io_apbSlave_0_PENABLE),
.PREADY(io_apbSlave_0_PREADY),
.PWRITE(io_apbSlave_0_PWRITE),
.PWDATA(io_apbSlave_0_PWDATA),
.PRDATA(io_apbSlave_0_PRDATA),
.PSLVERROR(io_apbSlave_0_PSLVERROR),
.start(start),
.iaddr(iaddr),
.ilen(ilen),
.idata(idata),
.status(status));



/////////////////////////////////////////////////////////////////////////////

RISC_mid_A soc_inst
(
.userInterruptA(userInterrupt_0),
.system_i2c_0_io_sda_write(system_i2c_0_io_sda_write),
.system_i2c_0_io_sda_read(system_i2c_0_io_sda_read),
.system_i2c_0_io_scl_write(system_i2c_0_io_scl_write),
.system_i2c_0_io_scl_read(system_i2c_0_io_scl_read),
.jtagCtrl_tck(jtag_inst1_TCK),
.jtagCtrl_tdi(jtag_inst1_TDI),
.jtagCtrl_tdo(jtag_inst1_TDO),
.jtagCtrl_enable(jtag_inst1_SEL),
.jtagCtrl_capture(jtag_inst1_CAPTURE),
.jtagCtrl_shift(jtag_inst1_SHIFT),
.jtagCtrl_update(jtag_inst1_UPDATE),
.jtagCtrl_reset(jtag_inst1_RESET),
.system_gpio_0_io_read(system_gpio_0_io_read),
.system_gpio_0_io_write(system_gpio_0_io_write),
.system_gpio_0_io_writeEnable(system_gpio_0_io_writeEnable),
.system_spi_0_io_sclk_write(system_spi_0_io_sclk_write),
.system_spi_0_io_data_0_writeEnable(system_spi_0_io_data_0_writeEnable),
.system_spi_0_io_data_0_read(system_spi_0_io_data_0_read),
.system_spi_0_io_data_0_write(system_spi_0_io_data_0_write),
.system_spi_0_io_data_1_writeEnable(system_spi_0_io_data_1_writeEnable),
.system_spi_0_io_data_1_read(system_spi_0_io_data_1_read),
.system_spi_0_io_data_1_write(system_spi_0_io_data_1_write),
.system_spi_0_io_data_2_writeEnable(),
.system_spi_0_io_data_2_read(),
.system_spi_0_io_data_2_write(),
.system_spi_0_io_data_3_writeEnable(),
.system_spi_0_io_data_3_read(),
.system_spi_0_io_data_3_write(),
.system_spi_0_io_ss(system_spi_0_io_ss),
.axiA_awvalid(axi_awvalid),
.axiA_awready(axi_awready),
.axiA_awaddr(axi_awaddr),
.axiA_awid(axi_awid),
.axiA_awregion(axi_awregion),
.axiA_awlen(axi_awlen),
.axiA_awsize(axi_awsize),
.axiA_awburst(axi_awburst),
.axiA_awlock(axi_awlock),
.axiA_awcache(axi_awcache),
.axiA_awqos(axi_awqos),
.axiA_awprot(axi_awprot),
.axiA_wvalid(axi_wvalid),
.axiA_wready(axi_wready),
.axiA_wdata(axi_wdata),
.axiA_wstrb(axi_wstrb),
.axiA_wlast(axi_wlast),
.axiA_bvalid(axi_bvalid),
.axiA_bready(axi_bready),
.axiA_bid(axi_bid),
.axiA_bresp(axi_bresp),
.axiA_arvalid(axi_arvalid),
.axiA_arready(axi_arready),
.axiA_araddr(axi_araddr),
.axiA_arid(axi_arid),
.axiA_arregion(axi_arregion),
.axiA_arlen(axi_arlen),
.axiA_arsize(axi_arsize),
.axiA_arburst(axi_arburst),
.axiA_arlock(axi_arlock),
.axiA_arcache(axi_arcache),
.axiA_arqos(axi_arqos),
.axiA_arprot(axi_arprot),
.axiA_rvalid(axi_rvalid),
.axiA_rready(axi_rready),
.axiA_rdata(axi_rdata),
.axiA_rid(axi_rid),
.axiA_rresp(axi_rresp),
.axiA_rlast(axi_rlast),
.axiAInterrupt(axi4Interrupt),
.io_apbSlave_0_PADDR(io_apbSlave_0_PADDR),
.io_apbSlave_0_PSEL(io_apbSlave_0_PSEL),
.io_apbSlave_0_PENABLE(io_apbSlave_0_PENABLE),
.io_apbSlave_0_PREADY(io_apbSlave_0_PREADY),
.io_apbSlave_0_PWRITE(io_apbSlave_0_PWRITE),
.io_apbSlave_0_PWDATA(io_apbSlave_0_PWDATA),
.io_apbSlave_0_PRDATA(io_apbSlave_0_PRDATA),
.io_apbSlave_0_PSLVERROR(io_apbSlave_0_PSLVERROR),

.io_systemClk(io_systemClk),
.io_asyncReset(w_io_asyncReset),
.io_systemReset(io_systemReset)		
);

endmodule

//////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2023 Efinix Inc. All rights reserved.
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
