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
//`include "header.v"  // use JTAG hard block
module temac_ex
(
//Globle Signals
//----pll_0
input                           clk,
input                           clk_125m,
input                           pll_0_locked,
input                           sw6,
output wire                     pll_rstn,
 
//TEMAC PHY RGMII Interface
output  wire    [3:0]           rgmii_txd_HI,
output  wire    [3:0]           rgmii_txd_LO,
output  wire                    rgmii_tx_ctl,
output  wire                    rgmii_txc_HI,
output  wire                    rgmii_txc_LO,
input           [3:0]           rgmii_rxd_HI,
input           [3:0]           rgmii_rxd_LO,
input                           rgmii_rx_ctl,
input                           rgmii_rxc,
//TEMAC PHY Ctr Interface
output  wire                    phy_rstn,
//hardware Jtag Interface
`ifndef SIM_MODE
`ifndef SOFT_TAP
input                           jtag_inst1_TCK,
input                           jtag_inst1_TDI,
output  wire                    jtag_inst1_TDO,
input                           jtag_inst1_SEL,
input                           jtag_inst1_CAPTURE,
input                           jtag_inst1_SHIFT,
input                           jtag_inst1_UPDATE,
input                           jtag_inst1_RESET,
`else
//software Jtag Interface
input                           io_jtag_tms,
input                           io_jtag_tdi,
output  wire                    io_jtag_tdo,
input                           io_jtag_tck,
`endif

//Debug Signals
//output  wire    [1:0]           debug_led
output  wire                    system_uart_0_io_txd,
input                           system_uart_0_io_rxd,
`endif

output         		    system_spi_0_io_sclk_write,
output              	system_spi_0_io_data_0_writeEnable,
input          		    system_spi_0_io_data_0_read,
output         		    system_spi_0_io_data_0_write,
output              	system_spi_0_io_data_1_writeEnable,
input          	    	system_spi_0_io_data_1_read,
output         	    	system_spi_0_io_data_1_write,
output         	    	system_spi_0_io_ss,
    
//TEMAC PHY MDIO Interface
input                           phy_mdi,
output  wire                    phy_mdo,
output  wire                    phy_mdo_en,
output  wire                    phy_mdc
);
// Parameter Define 
`include "rgmii_eth_efx_tsemac_define.svh"

// Register Define

// Wire Define
wire                            clk_50m;
wire                            clk_50m_rstn;
wire                            mac_reset;
wire                            proto_reset;
wire                            mac_rstn;
//AXI4-Stream Interface
wire                            rx_axis_clk;
wire    [7:0]                   rx_axis_mac_tdata;
wire                            rx_axis_mac_tvalid;
wire                            rx_axis_mac_tlast;
wire                            rx_axis_mac_tuser;
wire                            rx_axis_mac_tready;
wire                            tx_axis_clk;
wire    [7:0]                   tx_axis_mac_tdata;
wire                            tx_axis_mac_tvalid;
wire                            tx_axis_mac_tlast;
wire                            tx_axis_mac_tuser;
wire                            tx_axis_mac_tready;
wire    [7:0]                   udp_tx_axis_mac_tdata;
wire                            udp_tx_axis_mac_tvalid;
wire                            udp_tx_axis_mac_tlast;
wire                            udp_tx_axis_mac_tready;
wire    [7:0]                   mac_tx_axis_mac_tdata;
wire                            mac_tx_axis_mac_tvalid;
wire                            mac_tx_axis_mac_tlast;
wire                            mac_tx_axis_mac_tready;
wire    [7:0]                   pat_tx_axis_mac_tdata;
wire                            pat_tx_axis_mac_tvalid;
wire                            pat_tx_axis_mac_tlast;
wire                            pat_tx_axis_mac_tuser;
wire                            pat_tx_axis_mac_tready;
wire    [7:0]                   loop_tx_axis_mac_tdata;
wire                            loop_tx_axis_mac_tvalid;
wire                            loop_tx_axis_mac_tlast;
wire                            loop_tx_axis_mac_tuser;
wire                            loop_tx_axis_mac_tready;
//RiscV APB3 Interface
wire    [15:0]                  apb3_paddr;
wire                            apb3_psel;
wire                            apb3_penable;
wire                            apb3_pready;
wire                            apb3_pwrite;
wire    [31:0]                  apb3_pwdata;
wire    [31:0]                  apb3_prdata;
wire                            apb3_pslverror;
//Mac APB3 Interface
wire    [9:0]                   mac_apb3_paddr;
wire                            mac_apb3_psel;
wire                            mac_apb3_penable;
wire                            mac_apb3_pready;
wire                            mac_apb3_pwrite;
wire    [31:0]                  mac_apb3_pwdata;
wire    [31:0]                  mac_apb3_prdata;
wire                            mac_apb3_pslverror;
//Ex APB3 Interface
wire    [9:0]                   ex_apb3_paddr;
wire                            ex_apb3_psel;
wire                            ex_apb3_penable;
wire                            ex_apb3_pready;
wire                            ex_apb3_pwrite;
wire    [31:0]                  ex_apb3_pwdata;
wire    [31:0]                  ex_apb3_prdata;
wire                            ex_apb3_pslverror;
//AXI4-Lite Interface
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
//Cfg Space Registers
wire                            mac_sw_rst;
wire                            axi4_st_mux_select;
wire                            pat_mux_select;
wire                            udp_pat_gen_en;
wire                            mac_pat_gen_en;
wire    [15:0]                  pat_gen_num;
wire    [15:0]                  pat_gen_ipg;
wire    [47:0]                  pat_dst_mac;
wire    [47:0]                  pat_src_mac;
wire    [15:0]                  pat_mac_dlen;
wire    [31:0]                  pat_src_ip;
wire    [31:0]                  pat_dst_ip;
wire    [15:0]                  pat_src_port;
wire    [15:0]                  pat_dst_port;
wire    [15:0]                  pat_udp_dlen;

//TSE DDIO
wire                            rgmii_rx_ctl_LO;
wire                            rgmii_rx_ctl_HI;
wire                            rgmii_tx_ctl_LO;
wire                            rgmii_tx_ctl_HI;
/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
assign pll_rstn = 1;
/*----------------------- Clock Region -----------------------*/
//In full throughput usecase, rx_axis_clk and tx_axis_clk should be set to 125Mhz or above.
//In this example design, these clocks are set to 50Mhz because the UDP/MAC pattern generator has
//high combi logic and couldn't meet timing at 125Mhz. 
assign rx_axis_clk = clk;//clk_125m;
assign tx_axis_clk = clk;//clk_125m;


/*----------------------- Reset Region -----------------------*/
//assign pll_0_reset = 1'b0;
assign clk_50m = clk;
assign phy_rstn = sw6;
assign clk_50m_rstn = pll_0_locked;
assign mac_reset = ~pll_0_locked;
assign proto_reset = mac_sw_rst;
assign mac_rstn = ~(mac_reset || proto_reset);

/*----------------------- MCU Module ----------------------------*/
`ifndef SIM_MODE
sapphire u_mcu
(
//user custom ports
	//SOC
    .io_systemClk               (clk_50m                    ),
    .io_asyncReset              (1'b0                       ),
    .system_uart_0_io_txd       (system_uart_0_io_txd       ),
    .system_uart_0_io_rxd       (system_uart_0_io_rxd       ),
    .system_spi_0_io_sclk_write		        (system_spi_0_io_sclk_write         ),
    .system_spi_0_io_data_0_writeEnable	    (system_spi_0_io_data_0_writeEnable ),
    .system_spi_0_io_data_0_read		    (system_spi_0_io_data_0_read        ),
    .system_spi_0_io_data_0_write		    (system_spi_0_io_data_0_write       ),
    .system_spi_0_io_data_1_writeEnable	    (system_spi_0_io_data_1_writeEnable ),
    .system_spi_0_io_data_1_read		    (system_spi_0_io_data_1_read        ),
    .system_spi_0_io_data_1_write		    (system_spi_0_io_data_1_write       ),
    .system_spi_0_io_ss			            (system_spi_0_io_ss                 ),
    .jtagCtrl_tck               (jtag_inst1_TCK             ),
    .jtagCtrl_tdi               (jtag_inst1_TDI             ),
    .jtagCtrl_tdo               (jtag_inst1_TDO             ),
    .jtagCtrl_enable            (jtag_inst1_SEL             ),
    .jtagCtrl_capture           (jtag_inst1_CAPTURE         ),
    .jtagCtrl_shift             (jtag_inst1_SHIFT           ),
    .jtagCtrl_update            (jtag_inst1_UPDATE          ),
    .jtagCtrl_reset             (jtag_inst1_RESET           ),
//APB3 Master Interface
    .io_apbSlave_0_PADDR        (apb3_paddr                 ),
    .io_apbSlave_0_PSEL         (apb3_psel                  ),
    .io_apbSlave_0_PENABLE      (apb3_penable               ),
    .io_apbSlave_0_PREADY       (apb3_pready                ),
    .io_apbSlave_0_PWRITE       (apb3_pwrite                ),
    .io_apbSlave_0_PWDATA       (apb3_pwdata                ),
    .io_apbSlave_0_PRDATA       (apb3_prdata                ),
    .io_apbSlave_0_PSLVERROR    (apb3_pslverror             )
);
`endif

assign apb3_pready = (apb3_paddr[9] == 1'b0) ? mac_apb3_pready : ex_apb3_pready;
assign apb3_prdata = (apb3_paddr[9] == 1'b0) ? mac_apb3_prdata : ex_apb3_prdata;
assign apb3_pslverror = (apb3_paddr[9] == 1'b0) ? mac_apb3_pslverror : ex_apb3_pslverror;

assign mac_apb3_paddr = apb3_paddr[9:0];
assign mac_apb3_psel = (apb3_paddr[9] == 1'b0) ? apb3_psel : 1'b0;
assign mac_apb3_penable = apb3_penable;
assign mac_apb3_pwrite = apb3_pwrite;
assign mac_apb3_pwdata = apb3_pwdata;

assign ex_apb3_paddr = apb3_paddr[9:0];
assign ex_apb3_psel = (apb3_paddr[9] == 1'b1) ? apb3_psel : 1'b0;
assign ex_apb3_penable = apb3_penable;
assign ex_apb3_pwrite = apb3_pwrite;
assign ex_apb3_pwdata = apb3_pwdata;

apb3_2_axi4_lite#(
    .ADDR_WTH                   (10                         )
)
u_apb3_2_axi4_lite
(
//Globle Signals
    .clk                        (clk_50m                    ),
    .rstn                       (clk_50m_rstn               ),
//APB3 Slave Interface
    .s_apb3_paddr               (mac_apb3_paddr             ),
    .s_apb3_psel                (mac_apb3_psel              ),
    .s_apb3_penable             (mac_apb3_penable           ),
    .s_apb3_pready              (mac_apb3_pready            ),
    .s_apb3_pwrite              (mac_apb3_pwrite            ),
    .s_apb3_pwdata              (mac_apb3_pwdata            ),
    .s_apb3_prdata              (mac_apb3_prdata            ),
    .s_apb3_pslverror           (mac_apb3_pslverror         ),
//AXI4-Lite Master Interface
    .m_axi_awaddr               (axi_awaddr                 ),
    .m_axi_awvalid              (axi_awvalid                ),
    .m_axi_awready              (axi_awready                ),
    .m_axi_wdata                (axi_wdata                  ),
    .m_axi_wvalid               (axi_wvalid                 ),
    .m_axi_wready               (axi_wready                 ),
    .m_axi_bresp                (axi_bresp                  ),
    .m_axi_bvalid               (axi_bvalid                 ),
    .m_axi_bready               (axi_bready                 ),
    .m_axi_araddr               (axi_araddr                 ),
    .m_axi_arvalid              (axi_arvalid                ),
    .m_axi_arready              (axi_arready                ),
    .m_axi_rresp                (axi_rresp                  ),
    .m_axi_rdata                (axi_rdata                  ),
    .m_axi_rvalid               (axi_rvalid                 ),
    .m_axi_rready               (axi_rready                 )
);

reg_apb3#(
    .ADDR_WTH                   (10                         )
)
u_reg_apb3
(
//Globle Signals
//
//APB3 Slave Interface
    .s_apb3_clk                 (clk_50m                    ),
    .s_apb3_rstn                (clk_50m_rstn               ),
    .s_apb3_paddr               (ex_apb3_paddr              ),
    .s_apb3_psel                (ex_apb3_psel               ),
    .s_apb3_penable             (ex_apb3_penable            ),
    .s_apb3_pready              (ex_apb3_pready             ),
    .s_apb3_pwrite              (ex_apb3_pwrite             ),
    .s_apb3_pwdata              (ex_apb3_pwdata             ),
    .s_apb3_prdata              (ex_apb3_prdata             ),
    .s_apb3_pslverror           (ex_apb3_pslverror          ),
//Cfg Space Registers
//--Example Registers Field
    .mac_sw_rst                 (mac_sw_rst                 ),
    .axi4_st_mux_select         (axi4_st_mux_select         ),
    .pat_mux_select             (pat_mux_select             ),
    .udp_pat_gen_en             (udp_pat_gen_en             ),
    .mac_pat_gen_en             (mac_pat_gen_en             ),
    .pat_gen_num                (pat_gen_num                ),
    .pat_gen_ipg                (pat_gen_ipg                ),
    .pat_dst_mac                (pat_dst_mac                ),
    .pat_src_mac                (pat_src_mac                ),
    .pat_mac_dlen               (pat_mac_dlen               ),
    .pat_src_ip                 (pat_src_ip                 ),
    .pat_dst_ip                 (pat_dst_ip                 ),
    .pat_src_port               (pat_src_port               ),
    .pat_dst_port               (pat_dst_port               ),
    .pat_udp_dlen               (pat_udp_dlen               )
);

//generate if (PATTERN_TYPE == 0) begin  //UDP
//	
//assign mac_tx_axis_mac_tdata = 8'h0;
//assign mac_tx_axis_mac_tvalid = 1'b0;
//assign mac_tx_axis_mac_tlast = 1'b0;

/*----------------------- The Ethernet Pattern Module -----------------------*/
udp_pat_gen u_udp_pat_gen
(
//Globle Signals
    .clk                        (tx_axis_clk                ),
    .rstn                       (mac_rstn                   ),
//Control Interface
    .pat_gen_en                 (udp_pat_gen_en             ),
    .pat_gen_num                (pat_gen_num                ),
    .pat_gen_ipg                (pat_gen_ipg                ),
//MAC Protocol Signals
    .dst_mac                    (pat_dst_mac                ),
    .src_mac                    (pat_src_mac                ),
//IP Protocol Signals
    .src_ip                     (pat_src_ip                 ),
    .dst_ip                     (pat_dst_ip                 ),
//UDP Protocol Signals
    .src_port                   (pat_src_port               ),
    .dst_port                   (pat_dst_port               ),
    .udp_dlen                   (pat_udp_dlen               ),
//AXI4-Stream Interface
    .rclk                       (rx_axis_clk                ),
    .rrstn                      (mac_rstn                   ),
    .rdata                      (rx_axis_mac_tdata          ),
    .rvalid                     (rx_axis_mac_tvalid         ),
    .rlast                      (rx_axis_mac_tlast          ),
    .tdata                      (udp_tx_axis_mac_tdata      ),
    .tvalid                     (udp_tx_axis_mac_tvalid     ),
    .tlast                      (udp_tx_axis_mac_tlast      ),
    .tready                     (udp_tx_axis_mac_tready     )
);
//end
//else begin  //MAC
//
//assign udp_tx_axis_mac_tdata = 8'h0;
//assign udp_tx_axis_mac_tvalid = 1'b0;
//assign udp_tx_axis_mac_tlast = 1'b0;
	
mac_pat_gen u_mac_pat_gen
(
//Globle Signals
    .clk                        (tx_axis_clk                ),
    .rstn                       (mac_rstn                   ),
//Control Interface
    .pat_gen_en                 (mac_pat_gen_en             ),
    .pat_gen_num                (pat_gen_num                ),
    .pat_gen_ipg                (pat_gen_ipg                ),
//MAC Protocol Signals
    .dst_mac                    (pat_dst_mac                ),
    .src_mac                    (pat_src_mac                ),
    .mac_dlen                   (pat_mac_dlen               ),
//AXI4-Stream Interface
    .rclk                       (rx_axis_clk                ),
    .rrstn                      (mac_rstn                   ),
    .rdata                      (rx_axis_mac_tdata          ),
    .rvalid                     (rx_axis_mac_tvalid         ),
    .rlast                      (rx_axis_mac_tlast          ),
    .tdata                      (mac_tx_axis_mac_tdata      ),
    .tvalid                     (mac_tx_axis_mac_tvalid     ),
    .tlast                      (mac_tx_axis_mac_tlast      ),
    .tready                     (mac_tx_axis_mac_tready     )
);
//end
//endgenerate

axi4_st_mux u_pat_mux
(
//Globle Signals
    .mux_select                 (pat_mux_select             ),//0:udp pat; 1:mac pat;
//Mux In 0 Interface
    .tdata0                     (udp_tx_axis_mac_tdata      ),
    .tvalid0                    (udp_tx_axis_mac_tvalid     ),
    .tlast0                     (udp_tx_axis_mac_tlast      ),
    .tuser0                     (1'b0                       ),
    .tready0                    (udp_tx_axis_mac_tready     ),
//Mux In 1 Interface
    .tdata1                     (mac_tx_axis_mac_tdata      ),
    .tvalid1                    (mac_tx_axis_mac_tvalid     ),
    .tlast1                     (mac_tx_axis_mac_tlast      ),
    .tuser1                     (1'b0                       ),
    .tready1                    (mac_tx_axis_mac_tready     ),
//Mux Out Interface
    .tdata                      (pat_tx_axis_mac_tdata      ),
    .tvalid                     (pat_tx_axis_mac_tvalid     ),
    .tlast                      (pat_tx_axis_mac_tlast      ),
    .tuser                      (pat_tx_axis_mac_tuser      ),
    .tready                     (pat_tx_axis_mac_tready     )
);

/*----------------------- The Tx AXI4 St Mux Module -----------------------*/
axi4_st_mux u_tx_axi4st_mux
(
//Globle Signals
    .mux_select                 (axi4_st_mux_select         ),//0:pat; 1:rx2tx loopback;
//Mux In 0 Interface
    .tdata0                     (pat_tx_axis_mac_tdata      ),
    .tvalid0                    (pat_tx_axis_mac_tvalid     ),
    .tlast0                     (pat_tx_axis_mac_tlast      ),
    .tuser0                     (pat_tx_axis_mac_tuser      ),
    .tready0                    (pat_tx_axis_mac_tready     ),
//Mux In 1 Interface
    .tdata1                     (loop_tx_axis_mac_tdata     ),
    .tvalid1                    (loop_tx_axis_mac_tvalid    ),
    .tlast1                     (loop_tx_axis_mac_tlast     ),
    .tuser1                     (loop_tx_axis_mac_tuser     ),
    .tready1                    (loop_tx_axis_mac_tready    ),
//Mux Out Interface
    .tdata                      (tx_axis_mac_tdata          ),
    .tvalid                     (tx_axis_mac_tvalid         ),
    .tlast                      (tx_axis_mac_tlast          ),
    .tuser                      (tx_axis_mac_tuser          ),
    .tready                     (tx_axis_mac_tready         )
);

/*----------------------- The Tri-mode Ethernet MAC core -----------------------*/
assign rgmii_tx_ctl = rgmii_tx_ctl_HI | rgmii_tx_ctl_LO ;
assign rgmii_rx_ctl_HI = rgmii_rx_ctl ;
assign rgmii_rx_ctl_LO = rgmii_rx_ctl ;

rgmii_eth_efx_tsemac u_tsemac
(
//Globle Signals
    .mac_reset                  (mac_reset                  ),
    .proto_reset                (proto_reset                ),
    .tx_mac_aclk                (clk_125m                   ),
    .rx_mac_aclk                (                           ),
    .eth_speed                  (                           ),
//Receive AXI4-Stream Interface
    .rx_axis_clk                (rx_axis_clk                ),
    .rx_axis_mac_tdata          (rx_axis_mac_tdata          ),
    .rx_axis_mac_tvalid         (rx_axis_mac_tvalid         ),
    .rx_axis_mac_tlast          (rx_axis_mac_tlast          ),
    .rx_axis_mac_tstrb          (),
    .rx_axis_mac_tuser          (rx_axis_mac_tuser          ),
    .rx_axis_mac_tready         (rx_axis_mac_tready         ),
//Transmit AXI4-Stream Interface
    .tx_axis_clk                (tx_axis_clk                ),
    .tx_axis_mac_tdata          (tx_axis_mac_tdata          ),
    .tx_axis_mac_tvalid         (tx_axis_mac_tvalid         ),
    .tx_axis_mac_tlast          (tx_axis_mac_tlast          ),
    .tx_axis_mac_tstrb          (1'b1                       ),
    .tx_axis_mac_tuser          (tx_axis_mac_tuser          ),
    .tx_axis_mac_tready         (tx_axis_mac_tready         ), 
    //--RGMII Interface
    .rgmii_txd_HI               (rgmii_txd_HI               ),
    .rgmii_txd_LO               (rgmii_txd_LO               ),
    .rgmii_tx_ctl_HI            (rgmii_tx_ctl_HI            ),
    .rgmii_tx_ctl_LO            (rgmii_tx_ctl_LO            ),
    .rgmii_txc_HI               (rgmii_txc_HI               ),
    .rgmii_txc_LO               (rgmii_txc_LO               ),
    .rgmii_rxd_HI               (rgmii_rxd_HI               ),
    .rgmii_rxd_LO               (rgmii_rxd_LO               ),
    .rgmii_rx_ctl_HI            (rgmii_rx_ctl_HI            ),
    .rgmii_rx_ctl_LO            (rgmii_rx_ctl_LO            ),
    .rgmii_rxc                  (rgmii_rxc                  ),
    //AXI4-Lite Interface
    .s_axi_aclk                 (clk_50m                    ),
    .s_axi_awaddr               (axi_awaddr                 ),
    .s_axi_awvalid              (axi_awvalid                ),
    .s_axi_awready              (axi_awready                ),
    .s_axi_wdata                (axi_wdata                  ),
    .s_axi_wvalid               (axi_wvalid                 ),
    .s_axi_wready               (axi_wready                 ),
    .s_axi_bresp                (axi_bresp                  ),
    .s_axi_bvalid               (axi_bvalid                 ),
    .s_axi_bready               (axi_bready                 ),
    .s_axi_araddr               (axi_araddr                 ),
    .s_axi_arvalid              (axi_arvalid                ),
    .s_axi_arready              (axi_arready                ),
    .s_axi_rresp                (axi_rresp                  ),
    .s_axi_rdata                (axi_rdata                  ),
    .s_axi_rvalid               (axi_rvalid                 ),
    .s_axi_rready               (axi_rready                 ),
    //MDIO Interface
    .Mdo                        (phy_mdo                    ),
    .MdoEn                      (phy_mdo_en                 ),
    .Mdi                        (phy_mdi                    ),
    .Mdc                        (phy_mdc                    )
);

/*----------------------- User Interface Loopback Module ----------------------------*/
mac_rx2tx u_mac_rx2tx
(
//Globle Signals
//
//Receive AXI4-Stream Interface
    .rx_axis_clk                (rx_axis_clk                ),
    .rx_axis_rstn               (mac_rstn                   ),
    .rx_axis_mac_tdata          (rx_axis_mac_tdata          ),
    .rx_axis_mac_tvalid         (rx_axis_mac_tvalid         ),
    .rx_axis_mac_tlast          (rx_axis_mac_tlast          ),
    .rx_axis_mac_tuser          (rx_axis_mac_tuser          ),
    .rx_axis_mac_tready         (rx_axis_mac_tready         ),
//Transmit AXI4-Stream Interface
    .tx_axis_clk                (tx_axis_clk                ),
    .tx_axis_rstn               (mac_rstn                   ),
    .tx_axis_mac_tdata          (loop_tx_axis_mac_tdata     ),
    .tx_axis_mac_tvalid         (loop_tx_axis_mac_tvalid    ),
    .tx_axis_mac_tlast          (loop_tx_axis_mac_tlast     ),
    .tx_axis_mac_tuser          (loop_tx_axis_mac_tuser     ),
    .tx_axis_mac_tready         (loop_tx_axis_mac_tready    )
);

endmodule

