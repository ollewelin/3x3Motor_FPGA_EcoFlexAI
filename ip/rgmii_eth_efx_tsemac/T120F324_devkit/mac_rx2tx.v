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
module mac_rx2tx
(
//Globle Signals
//
//Receive AXI4-Stream Interface
input                           rx_axis_clk,
input                           rx_axis_rstn,
input           [7:0]           rx_axis_mac_tdata,
input                           rx_axis_mac_tvalid,
input                           rx_axis_mac_tlast,
input                           rx_axis_mac_tuser,
output  reg                     rx_axis_mac_tready,
//Transmit AXI4-Stream Interface
input                           tx_axis_clk,
input                           tx_axis_rstn,
output  reg     [7:0]           tx_axis_mac_tdata,
output  reg                     tx_axis_mac_tvalid,
output  reg                     tx_axis_mac_tlast,
output  reg                     tx_axis_mac_tuser,
input                           tx_axis_mac_tready
);
// Parameter Define 

// Register Define 

// Wire Define
wire    [9:0]                   u1_data;
wire                            u1_wrreq;
wire                            u1_rdreq;
wire    [9:0]                   u1_q;
wire                            u1_empty;
wire                            u1_almfull;
wire    [10:0]                  u1_wrcnt;

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/

/*----------------------- Rx Clock Region ----------------------------*/
assign u1_almfull = (u1_wrcnt >= 2045);

always @(posedge rx_axis_clk or negedge rx_axis_rstn)
begin
    if(rx_axis_rstn == 1'b0)
        rx_axis_mac_tready <= 1'b0;
    else if(u1_almfull == 1'b1)
        rx_axis_mac_tready <= 1'b0;
	else
        rx_axis_mac_tready <= 1'b1;
end

/*----------------------- Fifo 1 Region ----------------------------*/
DC_FIFO #(
    .FIFO_MODE                          ("ShowAhead"                        ),
    .DATA_WIDTH                         (10                                 ),
    .FIFO_DEPTH                         (2048                               )
)
u1
(   
  //System Signal
    .Reset                              (!rx_axis_rstn                      ),
  //Write Signal                             
    .WrClk                              (rx_axis_clk                        ),
    .WrEn                               (u1_wrreq                           ),
    .WrDNum                             (u1_wrcnt                           ),
    .WrFull                             (                                   ),
    .WrData                             (u1_data                            ),
  //Read Signal                            
    .RdClk                              (tx_axis_clk                        ),
    .RdEn                               (u1_rdreq                           ),
    .RdDNum                             (                                   ),
    .RdEmpty                            (u1_empty                           ),
    .RdData                             (u1_q                               )
);

assign u1_data = {rx_axis_mac_tuser,rx_axis_mac_tlast,rx_axis_mac_tdata};
assign u1_wrreq = (rx_axis_mac_tvalid == 1'b1) && (rx_axis_mac_tready == 1'b1);
assign u1_rdreq = (u1_empty == 1'b0) && ((tx_axis_mac_tvalid == 1'b0) || (tx_axis_mac_tready == 1'b1));

/*----------------------- Tx Clock Region ----------------------------*/

always @(posedge tx_axis_clk or negedge tx_axis_rstn)
begin
    if(tx_axis_rstn == 1'b0)
        tx_axis_mac_tvalid <= 1'b0;
	else if(u1_rdreq == 1'b1)
        tx_axis_mac_tvalid <= 1'b1;
    else if(tx_axis_mac_tready == 1'b1)
        tx_axis_mac_tvalid <= 1'b0;
end

always @(posedge tx_axis_clk or negedge tx_axis_rstn)
begin
    if(tx_axis_rstn == 1'b0)
        tx_axis_mac_tdata <= 8'h0;
    else if(u1_rdreq == 1'b1)
        tx_axis_mac_tdata <= u1_q[7:0];
	else if(tx_axis_mac_tready == 1'b1)
        tx_axis_mac_tdata <= 8'h0;
end

always @(posedge tx_axis_clk or negedge tx_axis_rstn)
begin
    if(tx_axis_rstn == 1'b0)
        tx_axis_mac_tlast <= 1'b0;
    else if(u1_rdreq == 1'b1)
        tx_axis_mac_tlast <= u1_q[8];
	else if(tx_axis_mac_tready == 1'b1)
        tx_axis_mac_tlast <= 1'b0;
end

always @(posedge tx_axis_clk or negedge tx_axis_rstn)
begin
    if(tx_axis_rstn == 1'b0)
        tx_axis_mac_tuser <= 1'b0;
    else if((u1_rdreq == 1'b1) && (u1_q[8] == 1'b1))
        tx_axis_mac_tuser <= u1_q[9];
	else if(tx_axis_mac_tready == 1'b1)
        tx_axis_mac_tuser <= 1'b0;
end

endmodule
