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
module axi4_st_mux
(
//Globle Signals
input                           mux_select,
//Mux In 0 Interface
input           [7:0]           tdata0,
input                           tvalid0,
input                           tlast0,
input                           tuser0,
output  wire                    tready0,
//Mux In 1 Interface
input           [7:0]           tdata1,
input                           tvalid1,
input                           tlast1,
input                           tuser1,
output  wire                    tready1,
//Mux Out Interface
output  wire    [7:0]           tdata,
output  wire                    tvalid,
output  wire                    tlast,
output  wire                    tuser,
input                           tready
);

// Parameter Define 

// Register Define

// Wire Define 

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/

assign tdata = (mux_select) ? tdata1 : tdata0;
assign tvalid = (mux_select) ? tvalid1 : tvalid0;
assign tlast = (mux_select) ? tlast1 : tlast0;
assign tuser = (mux_select) ? tuser1 : tuser0;

assign tready0 = (mux_select) ? 1'b1 : tready;
assign tready1 = (mux_select) ? tready : 1'b1;


endmodule
