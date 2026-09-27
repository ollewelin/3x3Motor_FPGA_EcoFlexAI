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
module rgmii_2_rmii (
    input              clk_50m,	  //50Mhz refclock
	input              rst_n,
	//conduit
	input       [2:0]  eth_speed,
	//rgmii interface      
	input       [3:0]  rgmii_txd,
	input              rgmii_tx_ctl,
	output wire [3:0]  rgmii_rxd,
	output wire        rgmii_rx_ctl,
	output reg         rgmii_rxc,
	//rmii interface
	output wire        rmii_clk,
	output reg  [1:0]  rmii_txd,
	output reg         rmii_txen,
	input       [1:0]  rmii_rxd,
	input              rmii_crsdv
); 

wire [3:0] rxd_c;
wire       rx_ctl_c;
reg  [3:0] rxd_r;
reg        rx_ctl_r;
reg        rmii_crsdv_r, shift_en;
reg [4:0]  txd_cnt, rxd_cnt;
reg [3:0]  rxd_shiftreg;
reg [1:0]  shift2;
reg [19:0] shift20;
reg [1:0]  rx_ctl_p2;
reg [19:0] rx_ctl_p20;

assign rmii_clk = ~clk_50m;  //create 180deg phaseshift

/*--------------- TX path ---------------------*/
always @(posedge clk_50m or negedge rst_n) 
begin
    if (!rst_n) begin
        txd_cnt    <= 5'd0;
	end
    else if (rgmii_tx_ctl) begin
	    if (((eth_speed == 3'h2) && txd_cnt == 5'd1) ||
		    ((eth_speed == 3'h1) && txd_cnt == 5'd19)) begin
			txd_cnt    <= 5'd0; 
		end
		else begin
		    txd_cnt    <= txd_cnt + 5'd1;
		end
    end
end

always @(posedge clk_50m or negedge rst_n) 
begin
    if (!rst_n) begin
		rmii_txen   <= 1'b0;
	end
    else begin
		rmii_txen   <= rgmii_tx_ctl;
    end
end

always @(posedge clk_50m or negedge rst_n) 
begin
    if (!rst_n) begin
        rmii_txd    <= 2'b00;
	end
    else begin
	    if ((eth_speed == 3'h2) && txd_cnt == 5'd0) begin
		    rmii_txd    <= rgmii_txd[1:0];
		end
		else if ((eth_speed == 3'h2) && txd_cnt == 5'd1) begin
		    rmii_txd    <= rgmii_txd[3:2]; 
		end
		
	    if ((eth_speed == 3'h1) && txd_cnt == 5'd0) begin
		    rmii_txd    <= rgmii_txd[1:0]; 
		end
		else if ((eth_speed == 3'h1) && txd_cnt == 5'd10) begin
		    rmii_txd    <= rgmii_txd[3:2]; 
		end
    end
end
/*------------------ end of TX path ------------------------*/

/*------------ RX path ------------------*/
always @(posedge clk_50m or negedge rst_n) 
begin
    if (!rst_n) begin
        rxd_cnt       <= 5'd0;
	end
    else if (rmii_crsdv) begin
	    if (((eth_speed == 3'h2) && rxd_cnt == 5'd1) || ((eth_speed == 3'h1) && rxd_cnt == 5'd19)) begin
			rxd_cnt    <= 5'd0; 
		end
		else begin
		    rxd_cnt    <= rxd_cnt + 5'd1;
		end
    end
end

always @(posedge clk_50m or negedge rst_n) 
begin
    if (!rst_n) begin
        rxd_shiftreg       <= 4'd0;
	end
    else if (rmii_crsdv) begin
	    if (eth_speed == 3'h2 || ((eth_speed == 3'h1) && (rxd_cnt == 5'd0 || rxd_cnt == 5'd10))) begin
		    rxd_shiftreg    <= {rmii_rxd, rxd_shiftreg[3:2]};
		end
    end
end

always @(posedge clk_50m or negedge rst_n)
begin
    if (!rst_n) begin
        shift2  <= 2'b1;
        shift20 <= 20'b1;
    end 
    else begin
        shift2 <= {shift2[0],shift2[1]};
        shift20 <= {shift20[18:0],shift20[19]};
	end
end

always @(posedge clk_50m or negedge rst_n)
begin
    if (!rst_n) begin
		rgmii_rxc    <= 1'b0;
    end 
    else begin
		if ((eth_speed == 3'h2 && shift2[1]) || (eth_speed == 3'h1 && (shift20[10]))) begin
	        rgmii_rxc    <= 1'b1;
		end
		else if ((eth_speed == 3'h2 && shift2[0]) || (eth_speed == 3'h1 && (shift20[0]))) begin
	        rgmii_rxc    <= 1'b0;
		end
	end
end

always @(posedge clk_50m or negedge rst_n)
begin
    if (!rst_n) begin
        rx_ctl_p2  <= 2'd0;
        rx_ctl_p20 <= 20'd0;
    end 
    else begin
        rx_ctl_p2  <= {rmii_crsdv , rx_ctl_p2[1]};
        rx_ctl_p20 <= {rmii_crsdv, rx_ctl_p20[19:1]};
	end
end

/*---- shift rxd & rx_ctl so that they are not edge align with rgmii_rxc ----*/
assign rxd_c = (rxd_cnt == 5'd0) ? rxd_shiftreg : rxd_r;
assign rx_ctl_c = (eth_speed == 3'h2) ? rx_ctl_p2[0] : rx_ctl_p20[0];

always @(posedge clk_50m or negedge rst_n)
begin
    if (!rst_n) begin
        rxd_r         <= 4'd0;
        rx_ctl_r      <= 1'd0;
		rmii_crsdv_r  <= 1'd0;
    end 
    else begin
        rxd_r         <= rxd_c;
        rx_ctl_r      <= rx_ctl_c;
		rmii_crsdv_r  <= rmii_crsdv;
	end
end

always @(posedge clk_50m or negedge rst_n)
begin
    if (!rst_n) begin
        shift_en     <= 1'd0;
    end   // to detect if rmii_crsdv assert at the posedge of rgmii_rxc, delay rgmii_rxd & rgmii_rx_ctl if they are aligned with rgmii_rxc
    else if (rmii_crsdv && ~rmii_crsdv_r) begin
	    if (((eth_speed == 3'h2) && shift2[0]) || ((eth_speed == 3'h1) && shift20[11])) begin
            shift_en     <= 1'd1;
	    end
		else begin
            shift_en     <= 1'd0;
		end
	end
end

assign rgmii_rxd = shift_en ? rxd_r : rxd_c;
assign rgmii_rx_ctl = shift_en ? rx_ctl_r : rx_ctl_c;
/*--------------------------------------------------------*/
/*------------------ end of RX path ------------------------*/
endmodule