
//
// Verific Verilog Description of module top_level
//

module top_level (clk, pll_clk, pll_clk_lock, IO12_manual_reset_n, led2, 
            led4, led4_OE, led4_OUT, RJ45_led, CAM0_EN, CAM1_EN, 
            I2C_SCL_IN, I2C_SCL_OUT, I2C_SCL_OE, I2C_SDA_IN, I2C_SDA_OUT, 
            I2C_SDA_OE, FPGA_IO0_A0, FPGA_IO0_A1, FPGA_IO0_A2, rmii_crs_dv, 
            rmii_rx_er, rmii_rxd, rmii_tx_en, rmii_txd, mdc, mdio_i, 
            mdio_o, mdio_oe, phy_intr_n, phy_rst_n, mipi_rx_inst1_DATA, 
            mipi_rx_inst1_VALID, mipi_rx_inst1_TYPE, mipi_rx_inst1_VC, 
            mipi_rx_inst1_CNT, mipi_rx_inst1_HSYNC, mipi_rx_inst1_VSYNC, 
            mipi_rx_inst1_DPHY_RSTN, mipi_rx_inst1_RSTN, mipi_rx_inst1_VC_ENA, 
            mipi_rx_inst1_LANES, mipi_rx_inst2_DATA, mipi_rx_inst2_VALID, 
            mipi_rx_inst2_TYPE, mipi_rx_inst2_VC, mipi_rx_inst2_CNT, mipi_rx_inst2_HSYNC, 
            mipi_rx_inst2_VSYNC, mipi_rx_inst2_DPHY_RSTN, mipi_rx_inst2_RSTN, 
            mipi_rx_inst2_VC_ENA, mipi_rx_inst2_LANES) /* verific EFX_ATTRIBUTE_NETLIST__TOP_IS_VHDL=TRUE */ ;
    input clk /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(10)
    input pll_clk /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(11)
    input pll_clk_lock /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(12)
    input IO12_manual_reset_n /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(13)
    output led2 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(18)
    input led4 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(19)
    output led4_OE /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(20)
    output led4_OUT /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(21)
    output RJ45_led /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(22)
    output CAM0_EN /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(27)
    output CAM1_EN /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(28)
    input I2C_SCL_IN /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(34)
    output I2C_SCL_OUT /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(35)
    output I2C_SCL_OE /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(36)
    input I2C_SDA_IN /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(37)
    output I2C_SDA_OUT /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(38)
    output I2C_SDA_OE /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(39)
    output FPGA_IO0_A0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(44)
    output FPGA_IO0_A1 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(45)
    output FPGA_IO0_A2 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(46)
    input rmii_crs_dv /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(51)
    input rmii_rx_er /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(52)
    input [1:0]rmii_rxd /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(53)
    output rmii_tx_en /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(54)
    output [1:0]rmii_txd /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(55)
    output mdc /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(58)
    input mdio_i /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(59)
    output mdio_o /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(60)
    output mdio_oe /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(61)
    input phy_intr_n /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(62)
    output phy_rst_n /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(63)
    input [63:0]mipi_rx_inst1_DATA /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(69)
    input mipi_rx_inst1_VALID /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(70)
    input [5:0]mipi_rx_inst1_TYPE /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(71)
    input [1:0]mipi_rx_inst1_VC /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(72)
    input [3:0]mipi_rx_inst1_CNT /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(73)
    input [3:0]mipi_rx_inst1_HSYNC /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(74)
    input [3:0]mipi_rx_inst1_VSYNC /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(75)
    output mipi_rx_inst1_DPHY_RSTN /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(78)
    output mipi_rx_inst1_RSTN /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(79)
    output [3:0]mipi_rx_inst1_VC_ENA /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(80)
    output [1:0]mipi_rx_inst1_LANES /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(81)
    input [63:0]mipi_rx_inst2_DATA /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(86)
    input mipi_rx_inst2_VALID /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(87)
    input [5:0]mipi_rx_inst2_TYPE /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(88)
    input [1:0]mipi_rx_inst2_VC /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(89)
    input [3:0]mipi_rx_inst2_CNT /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(90)
    input [3:0]mipi_rx_inst2_HSYNC /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(91)
    input [3:0]mipi_rx_inst2_VSYNC /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(92)
    output mipi_rx_inst2_DPHY_RSTN /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(95)
    output mipi_rx_inst2_RSTN /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(96)
    output [3:0]mipi_rx_inst2_VC_ENA /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(97)
    output [1:0]mipi_rx_inst2_LANES /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(98)
    
    wire [31:0]n302_2;
    wire [31:0]n302_31;
    wire [31:0]n302_29;
    wire [31:0]n302_27;
    wire [31:0]n302_25;
    wire [31:0]n302_23;
    wire [31:0]n302_21;
    wire [31:0]n302_19;
    wire [31:0]n302_18;
    wire [31:0]n302_17;
    wire [31:0]n302_16;
    wire [31:0]n302_15;
    wire [31:0]n302_14;
    wire [31:0]n302_13;
    wire [31:0]n302_12;
    wire [31:0]n302_11;
    wire [31:0]n302_10;
    wire [31:0]n302_9;
    wire [31:0]n302_8;
    wire [31:0]n302_7;
    wire [31:0]n302_6;
    wire [31:0]n302_5;
    wire [31:0]n302_4;
    wire [31:0]n302_3;
    
    wire \add_59/n2 ;
    wire [8:0]\i2c_reg16_master_inst/n8 ;
    
    wire \i2c_reg16_master_inst/add_298/n2 ;
    wire [31:0]cnt_from_clk;   // /home/olle/efinity_p2/BRAM/top_level.vhd(205)
    
    wire io_asyncReset_sig;
    wire [15:0]reg_addr16;   // /home/olle/efinity_p2/BRAM/top_level.vhd(236)
    wire [2:0]wr_len;   // /home/olle/efinity_p2/BRAM/top_level.vhd(238)
    wire [31:0]wr_data;   // /home/olle/efinity_p2/BRAM/top_level.vhd(239)
    wire [2:0]rd_len;   // /home/olle/efinity_p2/BRAM/top_level.vhd(240)
    
    wire \control_camera_i2c_inst/st[0] , \control_camera_i2c_inst/i2c_done_r_and_catch_i , 
        start_write16, start_read16, \control_camera_i2c_inst/i2c_done_delayed , 
        reg_16bit;
    wire [15:0]\control_camera_i2c_inst/done_delay_cnt ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(114)
    wire [6:0]slave_addr7;   // /home/olle/efinity_p2/BRAM/top_level.vhd(235)
    
    wire \control_camera_i2c_inst/st[1] , \control_camera_i2c_inst/st[2] , 
        \control_camera_i2c_inst/st[3] ;
    wire [7:0]debug_state;   // /home/olle/efinity_p2/BRAM/top_level.vhd(250)
    wire [8:0]\i2c_reg16_master_inst/div_cnt ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(54)
    wire [4:0]\i2c_reg16_master_inst/st ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(85)
    wire [2:0]\i2c_reg16_master_inst/byte_idx ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(72)
    
    wire i2c_busy, i2c_done, rd_valid;
    wire [7:0]\i2c_reg16_master_inst/tx_byte ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(64)
    wire [1:0]\i2c_reg16_master_inst/wpos ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(70)
    
    wire \i2c_reg16_master_inst/SCL_IN_SYNC0 , \i2c_reg16_master_inst/SDA_IN_SYNC0 , 
        \i2c_reg16_master_inst/SCL_IN_SYNCED , \i2c_reg16_master_inst/SDA_IN_SYNCED , 
        \i2c_reg16_master_inst/rw_read ;
    wire [1:0]\i2c_reg16_master_inst/rpos ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(71)
    
    wire \i2c_reg16_master_inst/bit_idx[0] , \i2c_reg16_master_inst/tick , 
        \i2c_reg16_master_inst/bit_idx[1] , \i2c_reg16_master_inst/bit_idx[2] , 
        \i2c_reg16_master_inst/add_298/n14 , \i2c_reg16_master_inst/add_298/n12 , 
        \i2c_reg16_master_inst/add_298/n10 , \i2c_reg16_master_inst/add_298/n8 , 
        \i2c_reg16_master_inst/add_298/n6 , \i2c_reg16_master_inst/add_298/n4 ;
    wire [31:0]n302_30;
    
    wire \add_59/n58 , \add_59/n56 ;
    wire [31:0]n302_28;
    
    wire \add_59/n54 , \add_59/n52 ;
    wire [31:0]n302_26;
    
    wire \add_59/n50 , \add_59/n48 ;
    wire [31:0]n302_24;
    
    wire \add_59/n46 , \add_59/n44 ;
    wire [31:0]n302_22;
    
    wire \add_59/n42 , \add_59/n40 ;
    wire [31:0]n302_20;
    
    wire \add_59/n38 , \add_59/n36 , \add_59/n34 , \add_59/n32 , \add_59/n30 , 
        \add_59/n28 , \add_59/n26 , \add_59/n24 , \add_59/n22 , \add_59/n20 , 
        \add_59/n18 , \add_59/n16 , \add_59/n14 , \add_59/n12 , \add_59/n10 , 
        \add_59/n8 , \add_59/n6 , \add_59/n4 ;
    wire [15:0]\control_camera_i2c_inst/n1468 ;
    
    wire ceg_net451, rst_n;
    wire [2:0]\control_camera_i2c_inst/n1486 ;
    wire [31:0]\control_camera_i2c_inst/n1490 ;
    
    wire ceg_net584, \control_camera_i2c_inst/n10280 ;
    wire [5:0]\control_camera_i2c_inst/n1526 ;
    
    wire \control_camera_i2c_inst/n2061 , ceg_net26, \control_camera_i2c_inst/n1523 , 
        \~control_camera_i2c_inst/n2059 , \control_camera_i2c_inst/n1485 , 
        ceg_net444;
    wire [15:0]\control_camera_i2c_inst/n1565 ;
    
    wire \control_camera_i2c_inst/n7280 ;
    wire [6:0]\control_camera_i2c_inst/n1460 ;
    
    wire ceg_net580, ceg_net586, ceg_net590, ceg_net591, ceg_net592;
    wire [8:0]\i2c_reg16_master_inst/n18 ;
    wire [4:0]\i2c_reg16_master_inst/n703 ;
    
    wire ceg_net593, ceg_net594, ceg_net595, ceg_net596, \i2c_reg16_master_inst/n1920 , 
        ceg_net325, \i2c_reg16_master_inst/n677 , ceg_net318, \i2c_reg16_master_inst/n753 , 
        \i2c_reg16_master_inst/n752 , \i2c_reg16_master_inst/n1946 , ceg_net473, 
        \i2c_reg16_master_inst/n1117 , ceg_net597, \i2c_reg16_master_inst/n1132 , 
        ceg_net177, \i2c_reg16_master_inst/n1927 , ceg_net334, \pll_clk~O , 
        ceg_net179, \i2c_reg16_master_inst/n1936 , ceg_net335, \i2c_reg16_master_inst/n1960 , 
        ceg_net600, \i2c_reg16_master_inst/equal_5/n15 , \i2c_reg16_master_inst/n1307 , 
        \i2c_reg16_master_inst/n1314 , \i2c_reg16_master_inst/n1346 , \i2c_reg16_master_inst/n1356 , 
        \i2c_reg16_master_inst/n1366 , \i2c_reg16_master_inst/n1386 , \i2c_reg16_master_inst/n1396 , 
        \i2c_reg16_master_inst/n1406 , \i2c_reg16_master_inst/n1327 , \i2c_reg16_master_inst/n1336 , 
        \i2c_reg16_master_inst/n1420 , \i2c_reg16_master_inst/n1434 , n485, 
        n486, n487, n488, n489, n490, n491, n492, n493, n494, 
        n495, n496, n497, n498, n499, n500, n501, n502, n503, 
        n504, n505, n506, n507, n508, n509, n510, n511, n512, 
        n513, n514, n515, n516, n517, n518, n519, n520, n521, 
        n522, n523, n524, n525, n526, n527, n528, n529, n530, 
        n531, n532, n533, n534, n535, n536, n537, n538, n539, 
        n540, n541, n542, n543, n544, n545, n546, n547, n548, 
        n549, n550, n551, n552, n553, n554, n555, n556, n557, 
        n558, n559, n560, n561, n562, n563, n564, n565, n566, 
        n567, n568, n569, n570, n571, n572, n573, n574, n575, 
        n576, n577, n578, n579, n580, n581, n582, n583, n584, 
        n585, n586, n587, n588, n589, n590, n591, n592, n593, 
        n594, n595, n596, n597, n598, n599, n600, n601, n602, 
        n603, n604, n605, n606, n607, n608, n609, n610, n611, 
        n612, n613, n614, n615, n616, n617, n618, n619, n620, 
        n621, n622, n623, n624, n625, n626, n627, n628, n629, 
        n630, n631, n632, n633, n634, n635, n636, n637, n638, 
        n639, n640, n641, n642, n643, n644, n645, n646, n647, 
        n648, n649, n650, n651, n652, n653, n654, n655, n656, 
        n657, n658, n659, n660, n661, n662, n663, n664, n665, 
        n666, n667, n668, n669, n670, n671, n672, n673, n674, 
        n675, n676, n677, n678, n679, n680, n681, n682, n683, 
        n684, n685, n686, n687, n688, n689, n690, n691, n692, 
        n693, n694, n695, n696, n697, n698, n699, n700, n701, 
        n703, n704, n705, n706;
    
    assign phy_rst_n = IO12_manual_reset_n /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(13)
    assign RJ45_led = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(22)
    assign CAM0_EN = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(27)
    assign CAM1_EN = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(28)
    assign I2C_SCL_OUT = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(35)
    assign I2C_SDA_OUT = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(38)
    assign FPGA_IO0_A0 = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(44)
    assign FPGA_IO0_A1 = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(45)
    assign FPGA_IO0_A2 = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(46)
    assign rmii_tx_en = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(54)
    assign rmii_txd[1] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(55)
    assign rmii_txd[0] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(55)
    assign mdio_o = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(60)
    assign mdio_oe = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(61)
    assign mipi_rx_inst1_DPHY_RSTN = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(78)
    assign mipi_rx_inst1_RSTN = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(79)
    assign mipi_rx_inst1_VC_ENA[3] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(80)
    assign mipi_rx_inst1_VC_ENA[2] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(80)
    assign mipi_rx_inst1_VC_ENA[1] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(80)
    assign mipi_rx_inst1_VC_ENA[0] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(80)
    assign mipi_rx_inst1_LANES[1] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(81)
    assign mipi_rx_inst1_LANES[0] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(81)
    assign mipi_rx_inst2_DPHY_RSTN = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(95)
    assign mipi_rx_inst2_RSTN = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(96)
    assign mipi_rx_inst2_VC_ENA[3] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(97)
    assign mipi_rx_inst2_VC_ENA[2] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(97)
    assign mipi_rx_inst2_VC_ENA[1] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(97)
    assign mipi_rx_inst2_VC_ENA[0] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(97)
    assign mipi_rx_inst2_LANES[1] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(98)
    assign mipi_rx_inst2_LANES[0] = 1'b0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__IS_VHDL_PORT_NAME=TRUE */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(98)
    assign led4_OE = 1'b1 /* verific EFX_ATTRIBUTE_CELL_NAME=VCC */ ;
    assign mdc = 1'b0 /* verific EFX_ATTRIBUTE_CELL_NAME=GND */ ;
    EFX_LUT4 LUT__1013 (.I0(debug_state[4]), .I1(\control_camera_i2c_inst/st[3] ), 
            .O(n486)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;
    defparam LUT__1013.LUTMASK = 16'h4444;
    EFX_FF \cnt_from_clk[0]~FF  (.D(cnt_from_clk[0]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[0]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[0]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[0]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[0]~FF .D_POLARITY = 1'b0;
    defparam \cnt_from_clk[0]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[0]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \io_asyncReset_sig~FF  (.D(1'b0), .CE(cnt_from_clk[24]), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(io_asyncReset_sig)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \io_asyncReset_sig~FF .CLK_POLARITY = 1'b1;
    defparam \io_asyncReset_sig~FF .CE_POLARITY = 1'b1;
    defparam \io_asyncReset_sig~FF .SR_POLARITY = 1'b1;
    defparam \io_asyncReset_sig~FF .D_POLARITY = 1'b0;
    defparam \io_asyncReset_sig~FF .SR_SYNC = 1'b1;
    defparam \io_asyncReset_sig~FF .SR_VALUE = 1'b0;
    defparam \io_asyncReset_sig~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \reg_addr16[0]~FF  (.D(\control_camera_i2c_inst/n1468 [0]), .CE(ceg_net451), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(reg_addr16[0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \reg_addr16[0]~FF .CLK_POLARITY = 1'b1;
    defparam \reg_addr16[0]~FF .CE_POLARITY = 1'b0;
    defparam \reg_addr16[0]~FF .SR_POLARITY = 1'b0;
    defparam \reg_addr16[0]~FF .D_POLARITY = 1'b1;
    defparam \reg_addr16[0]~FF .SR_SYNC = 1'b0;
    defparam \reg_addr16[0]~FF .SR_VALUE = 1'b0;
    defparam \reg_addr16[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \wr_len[0]~FF  (.D(\control_camera_i2c_inst/n1486 [0]), .CE(ceg_net451), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(wr_len[0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \wr_len[0]~FF .CLK_POLARITY = 1'b1;
    defparam \wr_len[0]~FF .CE_POLARITY = 1'b0;
    defparam \wr_len[0]~FF .SR_POLARITY = 1'b0;
    defparam \wr_len[0]~FF .D_POLARITY = 1'b1;
    defparam \wr_len[0]~FF .SR_SYNC = 1'b0;
    defparam \wr_len[0]~FF .SR_VALUE = 1'b0;
    defparam \wr_len[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \wr_data[0]~FF  (.D(\control_camera_i2c_inst/n1490 [0]), .CE(ceg_net584), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(wr_data[0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \wr_data[0]~FF .CLK_POLARITY = 1'b1;
    defparam \wr_data[0]~FF .CE_POLARITY = 1'b0;
    defparam \wr_data[0]~FF .SR_POLARITY = 1'b0;
    defparam \wr_data[0]~FF .D_POLARITY = 1'b1;
    defparam \wr_data[0]~FF .SR_SYNC = 1'b0;
    defparam \wr_data[0]~FF .SR_VALUE = 1'b0;
    defparam \wr_data[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \rd_len[0]~FF  (.D(1'b1), .CE(\control_camera_i2c_inst/n10280 ), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(rd_len[0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \rd_len[0]~FF .CLK_POLARITY = 1'b1;
    defparam \rd_len[0]~FF .CE_POLARITY = 1'b1;
    defparam \rd_len[0]~FF .SR_POLARITY = 1'b0;
    defparam \rd_len[0]~FF .D_POLARITY = 1'b1;
    defparam \rd_len[0]~FF .SR_SYNC = 1'b0;
    defparam \rd_len[0]~FF .SR_VALUE = 1'b0;
    defparam \rd_len[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/st[0]~FF  (.D(\control_camera_i2c_inst/n1526 [0]), 
           .CE(ceg_net584), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/st[0] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/st[0]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/st[0]~FF .CE_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/st[0]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/st[0]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/st[0]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/st[0]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/st[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/i2c_done_r_and_catch_i~FF  (.D(\control_camera_i2c_inst/n2061 ), 
           .CE(ceg_net26), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/i2c_done_r_and_catch_i )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/i2c_done_r_and_catch_i~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/i2c_done_r_and_catch_i~FF .CE_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/i2c_done_r_and_catch_i~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/i2c_done_r_and_catch_i~FF .D_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/i2c_done_r_and_catch_i~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/i2c_done_r_and_catch_i~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/i2c_done_r_and_catch_i~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \start_write16~FF  (.D(\control_camera_i2c_inst/n1523 ), .CE(rst_n), 
           .CLK(\pll_clk~O ), .SR(1'b0), .Q(start_write16)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \start_write16~FF .CLK_POLARITY = 1'b1;
    defparam \start_write16~FF .CE_POLARITY = 1'b1;
    defparam \start_write16~FF .SR_POLARITY = 1'b1;
    defparam \start_write16~FF .D_POLARITY = 1'b1;
    defparam \start_write16~FF .SR_SYNC = 1'b1;
    defparam \start_write16~FF .SR_VALUE = 1'b0;
    defparam \start_write16~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \start_read16~FF  (.D(\control_camera_i2c_inst/n10280 ), .CE(rst_n), 
           .CLK(\pll_clk~O ), .SR(1'b0), .Q(start_read16)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \start_read16~FF .CLK_POLARITY = 1'b1;
    defparam \start_read16~FF .CE_POLARITY = 1'b1;
    defparam \start_read16~FF .SR_POLARITY = 1'b1;
    defparam \start_read16~FF .D_POLARITY = 1'b1;
    defparam \start_read16~FF .SR_SYNC = 1'b1;
    defparam \start_read16~FF .SR_VALUE = 1'b0;
    defparam \start_read16~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/i2c_done_delayed~FF  (.D(\~control_camera_i2c_inst/n2059 ), 
           .CE(rst_n), .CLK(\pll_clk~O ), .SR(1'b0), .Q(\control_camera_i2c_inst/i2c_done_delayed )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/i2c_done_delayed~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/i2c_done_delayed~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/i2c_done_delayed~FF .SR_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/i2c_done_delayed~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/i2c_done_delayed~FF .SR_SYNC = 1'b1;
    defparam \control_camera_i2c_inst/i2c_done_delayed~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/i2c_done_delayed~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \reg_16bit~FF  (.D(\control_camera_i2c_inst/n1485 ), .CE(ceg_net444), 
           .CLK(\pll_clk~O ), .SR(1'b0), .Q(reg_16bit)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \reg_16bit~FF .CLK_POLARITY = 1'b1;
    defparam \reg_16bit~FF .CE_POLARITY = 1'b1;
    defparam \reg_16bit~FF .SR_POLARITY = 1'b1;
    defparam \reg_16bit~FF .D_POLARITY = 1'b1;
    defparam \reg_16bit~FF .SR_SYNC = 1'b1;
    defparam \reg_16bit~FF .SR_VALUE = 1'b0;
    defparam \reg_16bit~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[0]~FF  (.D(\control_camera_i2c_inst/n1565 [0]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[0]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[0]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[0]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[0]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[0]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[0]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \slave_addr7[4]~FF  (.D(1'b1), .CE(\control_camera_i2c_inst/n7280 ), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(slave_addr7[4])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \slave_addr7[4]~FF .CLK_POLARITY = 1'b1;
    defparam \slave_addr7[4]~FF .CE_POLARITY = 1'b1;
    defparam \slave_addr7[4]~FF .SR_POLARITY = 1'b0;
    defparam \slave_addr7[4]~FF .D_POLARITY = 1'b1;
    defparam \slave_addr7[4]~FF .SR_SYNC = 1'b0;
    defparam \slave_addr7[4]~FF .SR_VALUE = 1'b0;
    defparam \slave_addr7[4]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \slave_addr7[5]~FF  (.D(\control_camera_i2c_inst/n1460 [5]), .CE(ceg_net584), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(slave_addr7[5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \slave_addr7[5]~FF .CLK_POLARITY = 1'b1;
    defparam \slave_addr7[5]~FF .CE_POLARITY = 1'b0;
    defparam \slave_addr7[5]~FF .SR_POLARITY = 1'b0;
    defparam \slave_addr7[5]~FF .D_POLARITY = 1'b1;
    defparam \slave_addr7[5]~FF .SR_SYNC = 1'b0;
    defparam \slave_addr7[5]~FF .SR_VALUE = 1'b0;
    defparam \slave_addr7[5]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \reg_addr16[1]~FF  (.D(\control_camera_i2c_inst/n1468 [1]), .CE(ceg_net580), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(reg_addr16[1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \reg_addr16[1]~FF .CLK_POLARITY = 1'b1;
    defparam \reg_addr16[1]~FF .CE_POLARITY = 1'b0;
    defparam \reg_addr16[1]~FF .SR_POLARITY = 1'b0;
    defparam \reg_addr16[1]~FF .D_POLARITY = 1'b1;
    defparam \reg_addr16[1]~FF .SR_SYNC = 1'b0;
    defparam \reg_addr16[1]~FF .SR_VALUE = 1'b0;
    defparam \reg_addr16[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \reg_addr16[2]~FF  (.D(\control_camera_i2c_inst/n1468 [2]), .CE(ceg_net451), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(reg_addr16[2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \reg_addr16[2]~FF .CLK_POLARITY = 1'b1;
    defparam \reg_addr16[2]~FF .CE_POLARITY = 1'b0;
    defparam \reg_addr16[2]~FF .SR_POLARITY = 1'b0;
    defparam \reg_addr16[2]~FF .D_POLARITY = 1'b1;
    defparam \reg_addr16[2]~FF .SR_SYNC = 1'b0;
    defparam \reg_addr16[2]~FF .SR_VALUE = 1'b0;
    defparam \reg_addr16[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \reg_addr16[3]~FF  (.D(\control_camera_i2c_inst/n1468 [3]), .CE(ceg_net584), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(reg_addr16[3])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \reg_addr16[3]~FF .CLK_POLARITY = 1'b1;
    defparam \reg_addr16[3]~FF .CE_POLARITY = 1'b0;
    defparam \reg_addr16[3]~FF .SR_POLARITY = 1'b0;
    defparam \reg_addr16[3]~FF .D_POLARITY = 1'b1;
    defparam \reg_addr16[3]~FF .SR_SYNC = 1'b0;
    defparam \reg_addr16[3]~FF .SR_VALUE = 1'b0;
    defparam \reg_addr16[3]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \reg_addr16[8]~FF  (.D(\control_camera_i2c_inst/n1468 [8]), .CE(ceg_net451), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(reg_addr16[8])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \reg_addr16[8]~FF .CLK_POLARITY = 1'b1;
    defparam \reg_addr16[8]~FF .CE_POLARITY = 1'b0;
    defparam \reg_addr16[8]~FF .SR_POLARITY = 1'b0;
    defparam \reg_addr16[8]~FF .D_POLARITY = 1'b1;
    defparam \reg_addr16[8]~FF .SR_SYNC = 1'b0;
    defparam \reg_addr16[8]~FF .SR_VALUE = 1'b0;
    defparam \reg_addr16[8]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \reg_addr16[9]~FF  (.D(\control_camera_i2c_inst/n1468 [9]), .CE(ceg_net584), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(reg_addr16[9])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \reg_addr16[9]~FF .CLK_POLARITY = 1'b1;
    defparam \reg_addr16[9]~FF .CE_POLARITY = 1'b0;
    defparam \reg_addr16[9]~FF .SR_POLARITY = 1'b0;
    defparam \reg_addr16[9]~FF .D_POLARITY = 1'b1;
    defparam \reg_addr16[9]~FF .SR_SYNC = 1'b0;
    defparam \reg_addr16[9]~FF .SR_VALUE = 1'b0;
    defparam \reg_addr16[9]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \wr_len[1]~FF  (.D(\control_camera_i2c_inst/n1486 [1]), .CE(ceg_net584), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(wr_len[1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \wr_len[1]~FF .CLK_POLARITY = 1'b1;
    defparam \wr_len[1]~FF .CE_POLARITY = 1'b0;
    defparam \wr_len[1]~FF .SR_POLARITY = 1'b0;
    defparam \wr_len[1]~FF .D_POLARITY = 1'b1;
    defparam \wr_len[1]~FF .SR_SYNC = 1'b0;
    defparam \wr_len[1]~FF .SR_VALUE = 1'b0;
    defparam \wr_len[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \wr_data[2]~FF  (.D(\control_camera_i2c_inst/n1490 [2]), .CE(ceg_net586), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(wr_data[2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \wr_data[2]~FF .CLK_POLARITY = 1'b1;
    defparam \wr_data[2]~FF .CE_POLARITY = 1'b0;
    defparam \wr_data[2]~FF .SR_POLARITY = 1'b0;
    defparam \wr_data[2]~FF .D_POLARITY = 1'b1;
    defparam \wr_data[2]~FF .SR_SYNC = 1'b0;
    defparam \wr_data[2]~FF .SR_VALUE = 1'b0;
    defparam \wr_data[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \wr_data[5]~FF  (.D(\control_camera_i2c_inst/n1490 [5]), .CE(ceg_net584), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(wr_data[5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \wr_data[5]~FF .CLK_POLARITY = 1'b1;
    defparam \wr_data[5]~FF .CE_POLARITY = 1'b0;
    defparam \wr_data[5]~FF .SR_POLARITY = 1'b0;
    defparam \wr_data[5]~FF .D_POLARITY = 1'b1;
    defparam \wr_data[5]~FF .SR_SYNC = 1'b0;
    defparam \wr_data[5]~FF .SR_VALUE = 1'b0;
    defparam \wr_data[5]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/st[1]~FF  (.D(\control_camera_i2c_inst/n1526 [1]), 
           .CE(ceg_net451), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/st[1] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/st[1]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/st[1]~FF .CE_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/st[1]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/st[1]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/st[1]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/st[1]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/st[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/st[2]~FF  (.D(\control_camera_i2c_inst/n1526 [2]), 
           .CE(ceg_net584), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/st[2] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/st[2]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/st[2]~FF .CE_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/st[2]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/st[2]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/st[2]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/st[2]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/st[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/st[3]~FF  (.D(\control_camera_i2c_inst/n1526 [3]), 
           .CE(ceg_net590), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/st[3] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/st[3]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/st[3]~FF .CE_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/st[3]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/st[3]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/st[3]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/st[3]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/st[3]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \debug_state[4]~FF  (.D(\control_camera_i2c_inst/n1526 [4]), .CE(ceg_net591), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(debug_state[4])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \debug_state[4]~FF .CLK_POLARITY = 1'b1;
    defparam \debug_state[4]~FF .CE_POLARITY = 1'b0;
    defparam \debug_state[4]~FF .SR_POLARITY = 1'b0;
    defparam \debug_state[4]~FF .D_POLARITY = 1'b1;
    defparam \debug_state[4]~FF .SR_SYNC = 1'b0;
    defparam \debug_state[4]~FF .SR_VALUE = 1'b0;
    defparam \debug_state[4]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \debug_state[5]~FF  (.D(\control_camera_i2c_inst/n1526 [5]), .CE(ceg_net592), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(debug_state[5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \debug_state[5]~FF .CLK_POLARITY = 1'b1;
    defparam \debug_state[5]~FF .CE_POLARITY = 1'b0;
    defparam \debug_state[5]~FF .SR_POLARITY = 1'b0;
    defparam \debug_state[5]~FF .D_POLARITY = 1'b1;
    defparam \debug_state[5]~FF .SR_SYNC = 1'b0;
    defparam \debug_state[5]~FF .SR_VALUE = 1'b0;
    defparam \debug_state[5]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[1]~FF  (.D(\control_camera_i2c_inst/n1565 [1]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[1]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[1]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[1]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[1]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[1]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[1]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[2]~FF  (.D(\control_camera_i2c_inst/n1565 [2]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[2]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[2]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[2]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[2]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[2]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[2]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[3]~FF  (.D(\control_camera_i2c_inst/n1565 [3]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [3])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[3]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[3]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[3]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[3]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[3]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[3]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[3]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[4]~FF  (.D(\control_camera_i2c_inst/n1565 [4]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [4])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[4]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[4]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[4]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[4]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[4]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[4]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[4]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[5]~FF  (.D(\control_camera_i2c_inst/n1565 [5]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[5]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[5]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[5]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[5]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[5]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[5]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[5]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[6]~FF  (.D(\control_camera_i2c_inst/n1565 [6]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [6])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[6]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[6]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[6]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[6]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[6]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[6]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[6]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[7]~FF  (.D(\control_camera_i2c_inst/n1565 [7]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [7])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[7]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[7]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[7]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[7]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[7]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[7]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[7]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[8]~FF  (.D(\control_camera_i2c_inst/n1565 [8]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [8])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[8]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[8]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[8]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[8]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[8]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[8]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[8]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[9]~FF  (.D(\control_camera_i2c_inst/n1565 [9]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [9])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b1, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[9]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[9]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[9]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[9]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[9]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[9]~FF .SR_VALUE = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[9]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[10]~FF  (.D(\control_camera_i2c_inst/n1565 [10]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [10])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[10]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[10]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[10]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[10]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[10]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[10]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[10]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[11]~FF  (.D(\control_camera_i2c_inst/n1565 [11]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [11])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[11]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[11]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[11]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[11]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[11]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[11]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[11]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[12]~FF  (.D(\control_camera_i2c_inst/n1565 [12]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [12])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b1, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[12]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[12]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[12]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[12]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[12]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[12]~FF .SR_VALUE = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[12]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[13]~FF  (.D(\control_camera_i2c_inst/n1565 [13]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [13])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b1, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[13]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[13]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[13]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[13]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[13]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[13]~FF .SR_VALUE = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[13]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[14]~FF  (.D(\control_camera_i2c_inst/n1565 [14]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [14])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[14]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[14]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[14]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[14]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[14]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[14]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[14]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \control_camera_i2c_inst/done_delay_cnt[15]~FF  (.D(\control_camera_i2c_inst/n1565 [15]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\control_camera_i2c_inst/done_delay_cnt [15])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(548)
    defparam \control_camera_i2c_inst/done_delay_cnt[15]~FF .CLK_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[15]~FF .CE_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[15]~FF .SR_POLARITY = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[15]~FF .D_POLARITY = 1'b1;
    defparam \control_camera_i2c_inst/done_delay_cnt[15]~FF .SR_SYNC = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[15]~FF .SR_VALUE = 1'b0;
    defparam \control_camera_i2c_inst/done_delay_cnt[15]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/div_cnt[0]~FF  (.D(\i2c_reg16_master_inst/n18 [0]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/div_cnt [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(115)
    defparam \i2c_reg16_master_inst/div_cnt[0]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[0]~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[0]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[0]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[0]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[0]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/st[0]~FF  (.D(\i2c_reg16_master_inst/n703 [0]), 
           .CE(ceg_net593), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/st [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/st[0]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/st[0]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/st[0]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/st[0]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/st[0]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/st[0]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/st[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/st[4]~FF  (.D(\i2c_reg16_master_inst/n703 [4]), 
           .CE(ceg_net594), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/st [4])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/st[4]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/st[4]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/st[4]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/st[4]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/st[4]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/st[4]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/st[4]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/st[3]~FF  (.D(\i2c_reg16_master_inst/n703 [3]), 
           .CE(ceg_net595), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/st [3])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/st[3]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/st[3]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/st[3]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/st[3]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/st[3]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/st[3]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/st[3]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/st[2]~FF  (.D(\i2c_reg16_master_inst/n703 [2]), 
           .CE(ceg_net596), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/st [2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/st[2]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/st[2]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/st[2]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/st[2]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/st[2]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/st[2]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/st[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/st[1]~FF  (.D(\i2c_reg16_master_inst/n703 [1]), 
           .CE(ceg_net593), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/st [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/st[1]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/st[1]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/st[1]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/st[1]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/st[1]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/st[1]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/st[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/div_cnt[8]~FF  (.D(\i2c_reg16_master_inst/n18 [8]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/div_cnt [8])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(115)
    defparam \i2c_reg16_master_inst/div_cnt[8]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[8]~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[8]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[8]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[8]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[8]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[8]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/div_cnt[7]~FF  (.D(\i2c_reg16_master_inst/n8 [7]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/div_cnt [7])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(115)
    defparam \i2c_reg16_master_inst/div_cnt[7]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[7]~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[7]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[7]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[7]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[7]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[7]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/div_cnt[6]~FF  (.D(\i2c_reg16_master_inst/n18 [6]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/div_cnt [6])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(115)
    defparam \i2c_reg16_master_inst/div_cnt[6]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[6]~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[6]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[6]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[6]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[6]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[6]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/div_cnt[5]~FF  (.D(\i2c_reg16_master_inst/n8 [5]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/div_cnt [5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(115)
    defparam \i2c_reg16_master_inst/div_cnt[5]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[5]~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[5]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[5]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[5]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[5]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[5]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/div_cnt[4]~FF  (.D(\i2c_reg16_master_inst/n8 [4]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/div_cnt [4])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(115)
    defparam \i2c_reg16_master_inst/div_cnt[4]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[4]~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[4]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[4]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[4]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[4]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[4]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/div_cnt[3]~FF  (.D(\i2c_reg16_master_inst/n8 [3]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/div_cnt [3])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(115)
    defparam \i2c_reg16_master_inst/div_cnt[3]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[3]~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[3]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[3]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[3]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[3]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[3]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/div_cnt[2]~FF  (.D(\i2c_reg16_master_inst/n8 [2]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/div_cnt [2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(115)
    defparam \i2c_reg16_master_inst/div_cnt[2]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[2]~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[2]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[2]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[2]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[2]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/div_cnt[1]~FF  (.D(\i2c_reg16_master_inst/n18 [1]), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/div_cnt [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(115)
    defparam \i2c_reg16_master_inst/div_cnt[1]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[1]~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[1]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[1]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/div_cnt[1]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[1]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/div_cnt[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/byte_idx[0]~FF  (.D(\i2c_reg16_master_inst/n1920 ), 
           .CE(ceg_net325), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/byte_idx [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/byte_idx[0]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/byte_idx[0]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/byte_idx[0]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/byte_idx[0]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/byte_idx[0]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/byte_idx[0]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/byte_idx[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_busy~FF  (.D(\i2c_reg16_master_inst/n677 ), .CE(ceg_net318), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(i2c_busy)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_busy~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_busy~FF .CE_POLARITY = 1'b0;
    defparam \i2c_busy~FF .SR_POLARITY = 1'b0;
    defparam \i2c_busy~FF .D_POLARITY = 1'b1;
    defparam \i2c_busy~FF .SR_SYNC = 1'b0;
    defparam \i2c_busy~FF .SR_VALUE = 1'b0;
    defparam \i2c_busy~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_done~FF  (.D(\i2c_reg16_master_inst/n753 ), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(rst_n), .Q(i2c_done)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_done~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_done~FF .CE_POLARITY = 1'b1;
    defparam \i2c_done~FF .SR_POLARITY = 1'b0;
    defparam \i2c_done~FF .D_POLARITY = 1'b1;
    defparam \i2c_done~FF .SR_SYNC = 1'b0;
    defparam \i2c_done~FF .SR_VALUE = 1'b0;
    defparam \i2c_done~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \rd_valid~FF  (.D(\i2c_reg16_master_inst/n752 ), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(rst_n), .Q(rd_valid)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \rd_valid~FF .CLK_POLARITY = 1'b1;
    defparam \rd_valid~FF .CE_POLARITY = 1'b1;
    defparam \rd_valid~FF .SR_POLARITY = 1'b0;
    defparam \rd_valid~FF .D_POLARITY = 1'b1;
    defparam \rd_valid~FF .SR_SYNC = 1'b0;
    defparam \rd_valid~FF .SR_VALUE = 1'b0;
    defparam \rd_valid~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/tx_byte[0]~FF  (.D(\i2c_reg16_master_inst/n1946 ), 
           .CE(ceg_net473), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/tx_byte [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/tx_byte[0]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[0]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[0]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[0]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[0]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[0]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \I2C_SDA_OE~FF  (.D(\i2c_reg16_master_inst/n1117 ), .CE(ceg_net597), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(I2C_SDA_OE)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \I2C_SDA_OE~FF .CLK_POLARITY = 1'b1;
    defparam \I2C_SDA_OE~FF .CE_POLARITY = 1'b0;
    defparam \I2C_SDA_OE~FF .SR_POLARITY = 1'b0;
    defparam \I2C_SDA_OE~FF .D_POLARITY = 1'b1;
    defparam \I2C_SDA_OE~FF .SR_SYNC = 1'b0;
    defparam \I2C_SDA_OE~FF .SR_VALUE = 1'b0;
    defparam \I2C_SDA_OE~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \I2C_SCL_OE~FF  (.D(\i2c_reg16_master_inst/n1132 ), .CE(ceg_net177), 
           .CLK(\pll_clk~O ), .SR(rst_n), .Q(I2C_SCL_OE)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \I2C_SCL_OE~FF .CLK_POLARITY = 1'b1;
    defparam \I2C_SCL_OE~FF .CE_POLARITY = 1'b0;
    defparam \I2C_SCL_OE~FF .SR_POLARITY = 1'b0;
    defparam \I2C_SCL_OE~FF .D_POLARITY = 1'b1;
    defparam \I2C_SCL_OE~FF .SR_SYNC = 1'b0;
    defparam \I2C_SCL_OE~FF .SR_VALUE = 1'b0;
    defparam \I2C_SCL_OE~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/wpos[0]~FF  (.D(\i2c_reg16_master_inst/n1927 ), 
           .CE(ceg_net334), .CLK(\pll_clk~O ), .SR(1'b0), .Q(\i2c_reg16_master_inst/wpos [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/wpos[0]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/wpos[0]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/wpos[0]~FF .SR_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/wpos[0]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/wpos[0]~FF .SR_SYNC = 1'b1;
    defparam \i2c_reg16_master_inst/wpos[0]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/wpos[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/SCL_IN_SYNC0~FF  (.D(I2C_SCL_IN), .CE(rst_n), 
           .CLK(\pll_clk~O ), .SR(1'b0), .Q(\i2c_reg16_master_inst/SCL_IN_SYNC0 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/SCL_IN_SYNC0~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SCL_IN_SYNC0~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SCL_IN_SYNC0~FF .SR_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SCL_IN_SYNC0~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SCL_IN_SYNC0~FF .SR_SYNC = 1'b1;
    defparam \i2c_reg16_master_inst/SCL_IN_SYNC0~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/SCL_IN_SYNC0~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/SDA_IN_SYNC0~FF  (.D(I2C_SDA_IN), .CE(rst_n), 
           .CLK(\pll_clk~O ), .SR(1'b0), .Q(\i2c_reg16_master_inst/SDA_IN_SYNC0 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/SDA_IN_SYNC0~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SDA_IN_SYNC0~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SDA_IN_SYNC0~FF .SR_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SDA_IN_SYNC0~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SDA_IN_SYNC0~FF .SR_SYNC = 1'b1;
    defparam \i2c_reg16_master_inst/SDA_IN_SYNC0~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/SDA_IN_SYNC0~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/SCL_IN_SYNCED~FF  (.D(\i2c_reg16_master_inst/SCL_IN_SYNC0 ), 
           .CE(rst_n), .CLK(\pll_clk~O ), .SR(1'b0), .Q(\i2c_reg16_master_inst/SCL_IN_SYNCED )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/SCL_IN_SYNCED~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SCL_IN_SYNCED~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SCL_IN_SYNCED~FF .SR_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SCL_IN_SYNCED~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SCL_IN_SYNCED~FF .SR_SYNC = 1'b1;
    defparam \i2c_reg16_master_inst/SCL_IN_SYNCED~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/SCL_IN_SYNCED~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/SDA_IN_SYNCED~FF  (.D(\i2c_reg16_master_inst/SDA_IN_SYNC0 ), 
           .CE(rst_n), .CLK(\pll_clk~O ), .SR(1'b0), .Q(\i2c_reg16_master_inst/SDA_IN_SYNCED )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/SDA_IN_SYNCED~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SDA_IN_SYNCED~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SDA_IN_SYNCED~FF .SR_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SDA_IN_SYNCED~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/SDA_IN_SYNCED~FF .SR_SYNC = 1'b1;
    defparam \i2c_reg16_master_inst/SDA_IN_SYNCED~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/SDA_IN_SYNCED~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/rw_read~FF  (.D(start_write16), .CE(ceg_net179), 
           .CLK(\pll_clk~O ), .SR(1'b0), .Q(\i2c_reg16_master_inst/rw_read )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/rw_read~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/rw_read~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/rw_read~FF .SR_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/rw_read~FF .D_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/rw_read~FF .SR_SYNC = 1'b1;
    defparam \i2c_reg16_master_inst/rw_read~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/rw_read~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/rpos[0]~FF  (.D(\i2c_reg16_master_inst/n1936 ), 
           .CE(ceg_net335), .CLK(\pll_clk~O ), .SR(1'b0), .Q(\i2c_reg16_master_inst/rpos [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/rpos[0]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/rpos[0]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/rpos[0]~FF .SR_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/rpos[0]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/rpos[0]~FF .SR_SYNC = 1'b1;
    defparam \i2c_reg16_master_inst/rpos[0]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/rpos[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/bit_idx[0]~FF  (.D(\i2c_reg16_master_inst/n1960 ), 
           .CE(ceg_net600), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/bit_idx[0] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/bit_idx[0]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/bit_idx[0]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[0]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[0]~FF .D_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[0]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[0]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/tick~FF  (.D(\i2c_reg16_master_inst/equal_5/n15 ), 
           .CE(1'b1), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/tick )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(115)
    defparam \i2c_reg16_master_inst/tick~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tick~FF .CE_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tick~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tick~FF .D_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tick~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/tick~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/tick~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/byte_idx[1]~FF  (.D(\i2c_reg16_master_inst/n1307 ), 
           .CE(ceg_net325), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/byte_idx [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/byte_idx[1]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/byte_idx[1]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/byte_idx[1]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/byte_idx[1]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/byte_idx[1]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/byte_idx[1]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/byte_idx[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/byte_idx[2]~FF  (.D(\i2c_reg16_master_inst/n1314 ), 
           .CE(ceg_net325), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/byte_idx [2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/byte_idx[2]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/byte_idx[2]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/byte_idx[2]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/byte_idx[2]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/byte_idx[2]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/byte_idx[2]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/byte_idx[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/tx_byte[1]~FF  (.D(\i2c_reg16_master_inst/n1346 ), 
           .CE(ceg_net473), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/tx_byte [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/tx_byte[1]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[1]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[1]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[1]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[1]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[1]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/tx_byte[2]~FF  (.D(\i2c_reg16_master_inst/n1356 ), 
           .CE(ceg_net473), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/tx_byte [2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/tx_byte[2]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[2]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[2]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[2]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[2]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[2]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/tx_byte[3]~FF  (.D(\i2c_reg16_master_inst/n1366 ), 
           .CE(ceg_net473), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/tx_byte [3])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/tx_byte[3]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[3]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[3]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[3]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[3]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[3]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[3]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/tx_byte[5]~FF  (.D(\i2c_reg16_master_inst/n1386 ), 
           .CE(ceg_net473), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/tx_byte [5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/tx_byte[5]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[5]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[5]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[5]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[5]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[5]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[5]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/tx_byte[6]~FF  (.D(\i2c_reg16_master_inst/n1396 ), 
           .CE(ceg_net473), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/tx_byte [6])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/tx_byte[6]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[6]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[6]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[6]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[6]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[6]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[6]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/tx_byte[7]~FF  (.D(\i2c_reg16_master_inst/n1406 ), 
           .CE(ceg_net473), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/tx_byte [7])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/tx_byte[7]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[7]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[7]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[7]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/tx_byte[7]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[7]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/tx_byte[7]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/wpos[1]~FF  (.D(\i2c_reg16_master_inst/n1327 ), 
           .CE(ceg_net334), .CLK(\pll_clk~O ), .SR(1'b0), .Q(\i2c_reg16_master_inst/wpos [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/wpos[1]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/wpos[1]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/wpos[1]~FF .SR_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/wpos[1]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/wpos[1]~FF .SR_SYNC = 1'b1;
    defparam \i2c_reg16_master_inst/wpos[1]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/wpos[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/rpos[1]~FF  (.D(\i2c_reg16_master_inst/n1336 ), 
           .CE(ceg_net335), .CLK(\pll_clk~O ), .SR(1'b0), .Q(\i2c_reg16_master_inst/rpos [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/rpos[1]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/rpos[1]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/rpos[1]~FF .SR_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/rpos[1]~FF .D_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/rpos[1]~FF .SR_SYNC = 1'b1;
    defparam \i2c_reg16_master_inst/rpos[1]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/rpos[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/bit_idx[1]~FF  (.D(\i2c_reg16_master_inst/n1420 ), 
           .CE(ceg_net600), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/bit_idx[1] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/bit_idx[1]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/bit_idx[1]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[1]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[1]~FF .D_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[1]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[1]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i2c_reg16_master_inst/bit_idx[2]~FF  (.D(\i2c_reg16_master_inst/n1434 ), 
           .CE(ceg_net600), .CLK(\pll_clk~O ), .SR(rst_n), .Q(\i2c_reg16_master_inst/bit_idx[2] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(391)
    defparam \i2c_reg16_master_inst/bit_idx[2]~FF .CLK_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/bit_idx[2]~FF .CE_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[2]~FF .SR_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[2]~FF .D_POLARITY = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[2]~FF .SR_SYNC = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[2]~FF .SR_VALUE = 1'b0;
    defparam \i2c_reg16_master_inst/bit_idx[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[1]~FF  (.D(n302_2[1]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[1]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[1]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[1]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[1]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[1]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[1]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[2]~FF  (.D(n302_3[2]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[2]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[2]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[2]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[2]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[2]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[2]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[3]~FF  (.D(n302_4[3]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[3])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[3]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[3]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[3]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[3]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[3]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[3]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[3]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[4]~FF  (.D(n302_5[4]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[4])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[4]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[4]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[4]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[4]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[4]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[4]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[4]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[5]~FF  (.D(n302_6[5]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[5]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[5]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[5]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[5]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[5]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[5]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[5]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[6]~FF  (.D(n302_7[6]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[6])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[6]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[6]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[6]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[6]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[6]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[6]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[6]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \led2~FF  (.D(n302_8[7]), .CE(1'b1), .CLK(\pll_clk~O ), .SR(1'b0), 
           .Q(led2)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \led2~FF .CLK_POLARITY = 1'b1;
    defparam \led2~FF .CE_POLARITY = 1'b1;
    defparam \led2~FF .SR_POLARITY = 1'b1;
    defparam \led2~FF .D_POLARITY = 1'b1;
    defparam \led2~FF .SR_SYNC = 1'b1;
    defparam \led2~FF .SR_VALUE = 1'b0;
    defparam \led2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[8]~FF  (.D(n302_9[8]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[8])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[8]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[8]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[8]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[8]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[8]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[8]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[8]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[9]~FF  (.D(n302_10[9]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[9])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[9]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[9]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[9]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[9]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[9]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[9]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[9]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[10]~FF  (.D(n302_11[10]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[10])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[10]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[10]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[10]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[10]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[10]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[10]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[10]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[11]~FF  (.D(n302_12[11]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[11])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[11]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[11]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[11]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[11]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[11]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[11]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[11]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[12]~FF  (.D(n302_13[12]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[12])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[12]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[12]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[12]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[12]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[12]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[12]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[12]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[13]~FF  (.D(n302_14[13]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[13])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[13]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[13]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[13]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[13]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[13]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[13]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[13]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[14]~FF  (.D(n302_15[14]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[14])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[14]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[14]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[14]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[14]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[14]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[14]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[14]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[15]~FF  (.D(n302_16[15]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[15])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[15]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[15]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[15]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[15]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[15]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[15]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[15]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[16]~FF  (.D(n302_17[16]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[16])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[16]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[16]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[16]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[16]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[16]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[16]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[16]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[17]~FF  (.D(n302_18[17]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[17])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[17]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[17]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[17]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[17]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[17]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[17]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[17]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[18]~FF  (.D(n302_19[18]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[18])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[18]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[18]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[18]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[18]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[18]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[18]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[18]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[19]~FF  (.D(n302_20[19]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[19])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[19]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[19]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[19]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[19]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[19]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[19]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[19]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[20]~FF  (.D(n302_21[20]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[20])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[20]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[20]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[20]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[20]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[20]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[20]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[20]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[21]~FF  (.D(n302_22[21]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[21])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[21]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[21]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[21]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[21]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[21]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[21]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[21]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[22]~FF  (.D(n302_23[22]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[22])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[22]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[22]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[22]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[22]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[22]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[22]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[22]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[23]~FF  (.D(n302_24[23]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[23])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[23]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[23]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[23]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[23]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[23]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[23]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[23]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[24]~FF  (.D(n302_25[24]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[24])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[24]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[24]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[24]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[24]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[24]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[24]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[24]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[25]~FF  (.D(n302_26[25]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[25])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[25]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[25]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[25]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[25]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[25]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[25]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[25]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[26]~FF  (.D(n302_27[26]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[26])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[26]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[26]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[26]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[26]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[26]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[26]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[26]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[27]~FF  (.D(n302_28[27]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[27])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[27]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[27]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[27]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[27]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[27]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[27]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[27]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[28]~FF  (.D(n302_29[28]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[28])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[28]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[28]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[28]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[28]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[28]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[28]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[28]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \cnt_from_clk[29]~FF  (.D(n302_30[29]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(cnt_from_clk[29])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \cnt_from_clk[29]~FF .CLK_POLARITY = 1'b1;
    defparam \cnt_from_clk[29]~FF .CE_POLARITY = 1'b1;
    defparam \cnt_from_clk[29]~FF .SR_POLARITY = 1'b1;
    defparam \cnt_from_clk[29]~FF .D_POLARITY = 1'b1;
    defparam \cnt_from_clk[29]~FF .SR_SYNC = 1'b1;
    defparam \cnt_from_clk[29]~FF .SR_VALUE = 1'b0;
    defparam \cnt_from_clk[29]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \led4_OUT~FF  (.D(n302_31[30]), .CE(1'b1), .CLK(\pll_clk~O ), 
           .SR(1'b0), .Q(led4_OUT)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(382)
    defparam \led4_OUT~FF .CLK_POLARITY = 1'b1;
    defparam \led4_OUT~FF .CE_POLARITY = 1'b1;
    defparam \led4_OUT~FF .SR_POLARITY = 1'b1;
    defparam \led4_OUT~FF .D_POLARITY = 1'b1;
    defparam \led4_OUT~FF .SR_SYNC = 1'b1;
    defparam \led4_OUT~FF .SR_VALUE = 1'b0;
    defparam \led4_OUT~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_ADD \add_59/i1  (.I0(cnt_from_clk[1]), .I1(cnt_from_clk[0]), .CI(1'b0), 
            .O(n302_2[1]), .CO(\add_59/n2 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i1 .I0_POLARITY = 1'b1;
    defparam \add_59/i1 .I1_POLARITY = 1'b1;
    EFX_ADD \i2c_reg16_master_inst/add_298/i1  (.I0(\i2c_reg16_master_inst/div_cnt [1]), 
            .I1(\i2c_reg16_master_inst/div_cnt [0]), .CI(1'b0), .O(\i2c_reg16_master_inst/n8 [1]), 
            .CO(\i2c_reg16_master_inst/add_298/n2 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(112)
    defparam \i2c_reg16_master_inst/add_298/i1 .I0_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/add_298/i1 .I1_POLARITY = 1'b1;
    EFX_ADD \i2c_reg16_master_inst/add_298/i8  (.I0(\i2c_reg16_master_inst/div_cnt [8]), 
            .I1(1'b0), .CI(\i2c_reg16_master_inst/add_298/n14 ), .O(\i2c_reg16_master_inst/n8 [8])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(112)
    defparam \i2c_reg16_master_inst/add_298/i8 .I0_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/add_298/i8 .I1_POLARITY = 1'b1;
    EFX_ADD \i2c_reg16_master_inst/add_298/i7  (.I0(\i2c_reg16_master_inst/div_cnt [7]), 
            .I1(1'b0), .CI(\i2c_reg16_master_inst/add_298/n12 ), .O(\i2c_reg16_master_inst/n8 [7]), 
            .CO(\i2c_reg16_master_inst/add_298/n14 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(112)
    defparam \i2c_reg16_master_inst/add_298/i7 .I0_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/add_298/i7 .I1_POLARITY = 1'b1;
    EFX_ADD \i2c_reg16_master_inst/add_298/i6  (.I0(\i2c_reg16_master_inst/div_cnt [6]), 
            .I1(1'b0), .CI(\i2c_reg16_master_inst/add_298/n10 ), .O(\i2c_reg16_master_inst/n8 [6]), 
            .CO(\i2c_reg16_master_inst/add_298/n12 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(112)
    defparam \i2c_reg16_master_inst/add_298/i6 .I0_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/add_298/i6 .I1_POLARITY = 1'b1;
    EFX_ADD \i2c_reg16_master_inst/add_298/i5  (.I0(\i2c_reg16_master_inst/div_cnt [5]), 
            .I1(1'b0), .CI(\i2c_reg16_master_inst/add_298/n8 ), .O(\i2c_reg16_master_inst/n8 [5]), 
            .CO(\i2c_reg16_master_inst/add_298/n10 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(112)
    defparam \i2c_reg16_master_inst/add_298/i5 .I0_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/add_298/i5 .I1_POLARITY = 1'b1;
    EFX_ADD \i2c_reg16_master_inst/add_298/i4  (.I0(\i2c_reg16_master_inst/div_cnt [4]), 
            .I1(1'b0), .CI(\i2c_reg16_master_inst/add_298/n6 ), .O(\i2c_reg16_master_inst/n8 [4]), 
            .CO(\i2c_reg16_master_inst/add_298/n8 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(112)
    defparam \i2c_reg16_master_inst/add_298/i4 .I0_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/add_298/i4 .I1_POLARITY = 1'b1;
    EFX_ADD \i2c_reg16_master_inst/add_298/i3  (.I0(\i2c_reg16_master_inst/div_cnt [3]), 
            .I1(1'b0), .CI(\i2c_reg16_master_inst/add_298/n4 ), .O(\i2c_reg16_master_inst/n8 [3]), 
            .CO(\i2c_reg16_master_inst/add_298/n6 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(112)
    defparam \i2c_reg16_master_inst/add_298/i3 .I0_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/add_298/i3 .I1_POLARITY = 1'b1;
    EFX_ADD \i2c_reg16_master_inst/add_298/i2  (.I0(\i2c_reg16_master_inst/div_cnt [2]), 
            .I1(1'b0), .CI(\i2c_reg16_master_inst/add_298/n2 ), .O(\i2c_reg16_master_inst/n8 [2]), 
            .CO(\i2c_reg16_master_inst/add_298/n4 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(112)
    defparam \i2c_reg16_master_inst/add_298/i2 .I0_POLARITY = 1'b1;
    defparam \i2c_reg16_master_inst/add_298/i2 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i30  (.I0(led4_OUT), .I1(1'b0), .CI(\add_59/n58 ), 
            .O(n302_31[30])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i30 .I0_POLARITY = 1'b1;
    defparam \add_59/i30 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i29  (.I0(cnt_from_clk[29]), .I1(1'b0), .CI(\add_59/n56 ), 
            .O(n302_30[29]), .CO(\add_59/n58 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i29 .I0_POLARITY = 1'b1;
    defparam \add_59/i29 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i28  (.I0(cnt_from_clk[28]), .I1(1'b0), .CI(\add_59/n54 ), 
            .O(n302_29[28]), .CO(\add_59/n56 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i28 .I0_POLARITY = 1'b1;
    defparam \add_59/i28 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i27  (.I0(cnt_from_clk[27]), .I1(1'b0), .CI(\add_59/n52 ), 
            .O(n302_28[27]), .CO(\add_59/n54 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i27 .I0_POLARITY = 1'b1;
    defparam \add_59/i27 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i26  (.I0(cnt_from_clk[26]), .I1(1'b0), .CI(\add_59/n50 ), 
            .O(n302_27[26]), .CO(\add_59/n52 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i26 .I0_POLARITY = 1'b1;
    defparam \add_59/i26 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i25  (.I0(cnt_from_clk[25]), .I1(1'b0), .CI(\add_59/n48 ), 
            .O(n302_26[25]), .CO(\add_59/n50 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i25 .I0_POLARITY = 1'b1;
    defparam \add_59/i25 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i24  (.I0(cnt_from_clk[24]), .I1(1'b0), .CI(\add_59/n46 ), 
            .O(n302_25[24]), .CO(\add_59/n48 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i24 .I0_POLARITY = 1'b1;
    defparam \add_59/i24 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i23  (.I0(cnt_from_clk[23]), .I1(1'b0), .CI(\add_59/n44 ), 
            .O(n302_24[23]), .CO(\add_59/n46 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i23 .I0_POLARITY = 1'b1;
    defparam \add_59/i23 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i22  (.I0(cnt_from_clk[22]), .I1(1'b0), .CI(\add_59/n42 ), 
            .O(n302_23[22]), .CO(\add_59/n44 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i22 .I0_POLARITY = 1'b1;
    defparam \add_59/i22 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i21  (.I0(cnt_from_clk[21]), .I1(1'b0), .CI(\add_59/n40 ), 
            .O(n302_22[21]), .CO(\add_59/n42 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i21 .I0_POLARITY = 1'b1;
    defparam \add_59/i21 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i20  (.I0(cnt_from_clk[20]), .I1(1'b0), .CI(\add_59/n38 ), 
            .O(n302_21[20]), .CO(\add_59/n40 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i20 .I0_POLARITY = 1'b1;
    defparam \add_59/i20 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i19  (.I0(cnt_from_clk[19]), .I1(1'b0), .CI(\add_59/n36 ), 
            .O(n302_20[19]), .CO(\add_59/n38 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i19 .I0_POLARITY = 1'b1;
    defparam \add_59/i19 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i18  (.I0(cnt_from_clk[18]), .I1(1'b0), .CI(\add_59/n34 ), 
            .O(n302_19[18]), .CO(\add_59/n36 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i18 .I0_POLARITY = 1'b1;
    defparam \add_59/i18 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i17  (.I0(cnt_from_clk[17]), .I1(1'b0), .CI(\add_59/n32 ), 
            .O(n302_18[17]), .CO(\add_59/n34 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i17 .I0_POLARITY = 1'b1;
    defparam \add_59/i17 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i16  (.I0(cnt_from_clk[16]), .I1(1'b0), .CI(\add_59/n30 ), 
            .O(n302_17[16]), .CO(\add_59/n32 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i16 .I0_POLARITY = 1'b1;
    defparam \add_59/i16 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i15  (.I0(cnt_from_clk[15]), .I1(1'b0), .CI(\add_59/n28 ), 
            .O(n302_16[15]), .CO(\add_59/n30 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i15 .I0_POLARITY = 1'b1;
    defparam \add_59/i15 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i14  (.I0(cnt_from_clk[14]), .I1(1'b0), .CI(\add_59/n26 ), 
            .O(n302_15[14]), .CO(\add_59/n28 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i14 .I0_POLARITY = 1'b1;
    defparam \add_59/i14 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i13  (.I0(cnt_from_clk[13]), .I1(1'b0), .CI(\add_59/n24 ), 
            .O(n302_14[13]), .CO(\add_59/n26 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i13 .I0_POLARITY = 1'b1;
    defparam \add_59/i13 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i12  (.I0(cnt_from_clk[12]), .I1(1'b0), .CI(\add_59/n22 ), 
            .O(n302_13[12]), .CO(\add_59/n24 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i12 .I0_POLARITY = 1'b1;
    defparam \add_59/i12 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i11  (.I0(cnt_from_clk[11]), .I1(1'b0), .CI(\add_59/n20 ), 
            .O(n302_12[11]), .CO(\add_59/n22 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i11 .I0_POLARITY = 1'b1;
    defparam \add_59/i11 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i10  (.I0(cnt_from_clk[10]), .I1(1'b0), .CI(\add_59/n18 ), 
            .O(n302_11[10]), .CO(\add_59/n20 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i10 .I0_POLARITY = 1'b1;
    defparam \add_59/i10 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i9  (.I0(cnt_from_clk[9]), .I1(1'b0), .CI(\add_59/n16 ), 
            .O(n302_10[9]), .CO(\add_59/n18 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i9 .I0_POLARITY = 1'b1;
    defparam \add_59/i9 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i8  (.I0(cnt_from_clk[8]), .I1(1'b0), .CI(\add_59/n14 ), 
            .O(n302_9[8]), .CO(\add_59/n16 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i8 .I0_POLARITY = 1'b1;
    defparam \add_59/i8 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i7  (.I0(led2), .I1(1'b0), .CI(\add_59/n12 ), .O(n302_8[7]), 
            .CO(\add_59/n14 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i7 .I0_POLARITY = 1'b1;
    defparam \add_59/i7 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i6  (.I0(cnt_from_clk[6]), .I1(1'b0), .CI(\add_59/n10 ), 
            .O(n302_7[6]), .CO(\add_59/n12 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i6 .I0_POLARITY = 1'b1;
    defparam \add_59/i6 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i5  (.I0(cnt_from_clk[5]), .I1(1'b0), .CI(\add_59/n8 ), 
            .O(n302_6[5]), .CO(\add_59/n10 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i5 .I0_POLARITY = 1'b1;
    defparam \add_59/i5 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i4  (.I0(cnt_from_clk[4]), .I1(1'b0), .CI(\add_59/n6 ), 
            .O(n302_5[4]), .CO(\add_59/n8 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i4 .I0_POLARITY = 1'b1;
    defparam \add_59/i4 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i3  (.I0(cnt_from_clk[3]), .I1(1'b0), .CI(\add_59/n4 ), 
            .O(n302_4[3]), .CO(\add_59/n6 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i3 .I0_POLARITY = 1'b1;
    defparam \add_59/i3 .I1_POLARITY = 1'b1;
    EFX_ADD \add_59/i2  (.I0(cnt_from_clk[2]), .I1(1'b0), .CI(\add_59/n2 ), 
            .O(n302_3[2]), .CO(\add_59/n4 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // ../vhdl_packages/vhdl_2008/src/numeric_std-body.vhdl(482)
    defparam \add_59/i2 .I0_POLARITY = 1'b1;
    defparam \add_59/i2 .I1_POLARITY = 1'b1;
    EFX_LUT4 LUT__1014 (.I0(n485), .I1(n486), .I2(\control_camera_i2c_inst/st[2] ), 
            .O(n487)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hd4d4 */ ;
    defparam LUT__1014.LUTMASK = 16'hd4d4;
    EFX_LUT4 LUT__1015 (.I0(\control_camera_i2c_inst/st[0] ), .I1(\control_camera_i2c_inst/st[1] ), 
            .I2(\control_camera_i2c_inst/st[2] ), .I3(rd_valid), .O(n488)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8000 */ ;
    defparam LUT__1015.LUTMASK = 16'h8000;
    EFX_LUT4 LUT__1016 (.I0(\control_camera_i2c_inst/st[2] ), .I1(\control_camera_i2c_inst/st[0] ), 
            .O(n489)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;
    defparam LUT__1016.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__1017 (.I0(debug_state[4]), .I1(debug_state[5]), .O(n490)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1111 */ ;
    defparam LUT__1017.LUTMASK = 16'h1111;
    EFX_LUT4 LUT__1018 (.I0(n489), .I1(n488), .I2(\control_camera_i2c_inst/st[3] ), 
            .I3(n490), .O(n491)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h3500 */ ;
    defparam LUT__1018.LUTMASK = 16'h3500;
    EFX_LUT4 LUT__1019 (.I0(\control_camera_i2c_inst/i2c_done_delayed ), .I1(\control_camera_i2c_inst/st[1] ), 
            .I2(\control_camera_i2c_inst/st[2] ), .I3(\control_camera_i2c_inst/st[3] ), 
            .O(n492)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h007f */ ;
    defparam LUT__1019.LUTMASK = 16'h007f;
    EFX_LUT4 LUT__1020 (.I0(n492), .I1(reg_addr16[0]), .I2(debug_state[4]), 
            .I3(debug_state[5]), .O(n493)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h37f0 */ ;
    defparam LUT__1020.LUTMASK = 16'h37f0;
    EFX_LUT4 LUT__1021 (.I0(\control_camera_i2c_inst/st[0] ), .I1(\control_camera_i2c_inst/i2c_done_delayed ), 
            .I2(\control_camera_i2c_inst/st[1] ), .O(n494)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8080 */ ;
    defparam LUT__1021.LUTMASK = 16'h8080;
    EFX_LUT4 LUT__1022 (.I0(\control_camera_i2c_inst/st[2] ), .I1(\control_camera_i2c_inst/i2c_done_delayed ), 
            .I2(\control_camera_i2c_inst/st[0] ), .O(n495)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1022.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1023 (.I0(reg_addr16[0]), .I1(n494), .I2(n495), .I3(n486), 
            .O(n496)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0e00 */ ;
    defparam LUT__1023.LUTMASK = 16'h0e00;
    EFX_LUT4 LUT__1024 (.I0(\control_camera_i2c_inst/st[0] ), .I1(\control_camera_i2c_inst/st[1] ), 
            .I2(rd_valid), .O(n497)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8080 */ ;
    defparam LUT__1024.LUTMASK = 16'h8080;
    EFX_LUT4 LUT__1025 (.I0(reg_addr16[0]), .I1(\control_camera_i2c_inst/st[2] ), 
            .I2(debug_state[5]), .I3(n497), .O(n498)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0c0a */ ;
    defparam LUT__1025.LUTMASK = 16'h0c0a;
    EFX_LUT4 LUT__1026 (.I0(\control_camera_i2c_inst/st[0] ), .I1(\control_camera_i2c_inst/i2c_done_delayed ), 
            .O(n499)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__1026.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1027 (.I0(\control_camera_i2c_inst/st[3] ), .I1(debug_state[4]), 
            .O(n500)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1111 */ ;
    defparam LUT__1027.LUTMASK = 16'h1111;
    EFX_LUT4 LUT__1028 (.I0(n497), .I1(n499), .I2(\control_camera_i2c_inst/st[2] ), 
            .I3(n500), .O(n501)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hca00 */ ;
    defparam LUT__1028.LUTMASK = 16'hca00;
    EFX_LUT4 LUT__1029 (.I0(n496), .I1(n498), .I2(n501), .I3(n493), 
            .O(n502)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0100 */ ;
    defparam LUT__1029.LUTMASK = 16'h0100;
    EFX_LUT4 LUT__1030 (.I0(reg_addr16[0]), .I1(n487), .I2(n491), .I3(n502), 
            .O(\control_camera_i2c_inst/n1468 [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h008f */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1030.LUTMASK = 16'h008f;
    EFX_LUT4 LUT__1031 (.I0(i2c_busy), .I1(\control_camera_i2c_inst/i2c_done_delayed ), 
            .I2(\control_camera_i2c_inst/st[0] ), .I3(\control_camera_i2c_inst/st[1] ), 
            .O(n503)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h333a */ ;
    defparam LUT__1031.LUTMASK = 16'h333a;
    EFX_LUT4 LUT__1032 (.I0(\control_camera_i2c_inst/st[3] ), .I1(debug_state[4]), 
            .I2(debug_state[5]), .O(n504)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0101 */ ;
    defparam LUT__1032.LUTMASK = 16'h0101;
    EFX_LUT4 LUT__1033 (.I0(\control_camera_i2c_inst/st[2] ), .I1(n503), 
            .I2(n504), .O(ceg_net451)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1033.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1034 (.I0(phy_rst_n), .I1(io_asyncReset_sig), .O(rst_n)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(399)
    defparam LUT__1034.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1035 (.I0(\control_camera_i2c_inst/st[1] ), .I1(\control_camera_i2c_inst/st[0] ), 
            .I2(\control_camera_i2c_inst/i2c_done_delayed ), .I3(\control_camera_i2c_inst/st[2] ), 
            .O(n505)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'he000 */ ;
    defparam LUT__1035.LUTMASK = 16'he000;
    EFX_LUT4 LUT__1036 (.I0(n505), .I1(n500), .I2(wr_len[0]), .O(n506)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0707 */ ;
    defparam LUT__1036.LUTMASK = 16'h0707;
    EFX_LUT4 LUT__1037 (.I0(\control_camera_i2c_inst/st[3] ), .I1(\control_camera_i2c_inst/st[2] ), 
            .I2(debug_state[4]), .O(n507)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0707 */ ;
    defparam LUT__1037.LUTMASK = 16'h0707;
    EFX_LUT4 LUT__1038 (.I0(n494), .I1(n497), .I2(\control_camera_i2c_inst/st[2] ), 
            .I3(n507), .O(n508)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hac00 */ ;
    defparam LUT__1038.LUTMASK = 16'hac00;
    EFX_LUT4 LUT__1039 (.I0(wr_len[0]), .I1(n494), .I2(n486), .O(n509)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'he0e0 */ ;
    defparam LUT__1039.LUTMASK = 16'he0e0;
    EFX_LUT4 LUT__1040 (.I0(rd_valid), .I1(\control_camera_i2c_inst/st[1] ), 
            .I2(\control_camera_i2c_inst/st[0] ), .I3(debug_state[4]), .O(n510)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7f00 */ ;
    defparam LUT__1040.LUTMASK = 16'h7f00;
    EFX_LUT4 LUT__1041 (.I0(n486), .I1(n495), .I2(debug_state[5]), .I3(n510), 
            .O(n511)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h008f */ ;
    defparam LUT__1041.LUTMASK = 16'h008f;
    EFX_LUT4 LUT__1042 (.I0(n508), .I1(n506), .I2(n509), .I3(n511), 
            .O(n512)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h00f1 */ ;
    defparam LUT__1042.LUTMASK = 16'h00f1;
    EFX_LUT4 LUT__1043 (.I0(\control_camera_i2c_inst/st[3] ), .I1(n488), 
            .I2(wr_len[0]), .I3(n490), .O(n513)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7000 */ ;
    defparam LUT__1043.LUTMASK = 16'h7000;
    EFX_LUT4 LUT__1044 (.I0(n487), .I1(n513), .O(n514)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__1044.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1045 (.I0(n504), .I1(n489), .I2(n512), .I3(n514), 
            .O(\control_camera_i2c_inst/n1486 [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hfff8 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1045.LUTMASK = 16'hfff8;
    EFX_LUT4 LUT__1046 (.I0(\control_camera_i2c_inst/st[2] ), .I1(n497), 
            .I2(n505), .O(n515)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0b0b */ ;
    defparam LUT__1046.LUTMASK = 16'h0b0b;
    EFX_LUT4 LUT__1047 (.I0(n486), .I1(n494), .O(n516)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__1047.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1048 (.I0(n500), .I1(n515), .I2(n516), .O(n517)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0d0d */ ;
    defparam LUT__1048.LUTMASK = 16'h0d0d;
    EFX_LUT4 LUT__1049 (.I0(n486), .I1(n495), .I2(debug_state[5]), .O(n518)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7070 */ ;
    defparam LUT__1049.LUTMASK = 16'h7070;
    EFX_LUT4 LUT__1050 (.I0(\control_camera_i2c_inst/st[1] ), .I1(n489), 
            .O(n519)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;
    defparam LUT__1050.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__1051 (.I0(wr_data[0]), .I1(n519), .I2(debug_state[5]), 
            .I3(n500), .O(n520)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0c0a */ ;
    defparam LUT__1051.LUTMASK = 16'h0c0a;
    EFX_LUT4 LUT__1052 (.I0(wr_data[0]), .I1(n517), .I2(n518), .I3(n520), 
            .O(\control_camera_i2c_inst/n1490 [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hffb0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1052.LUTMASK = 16'hffb0;
    EFX_LUT4 LUT__1053 (.I0(\control_camera_i2c_inst/st[1] ), .I1(\control_camera_i2c_inst/i2c_done_delayed ), 
            .I2(\control_camera_i2c_inst/st[0] ), .I3(\control_camera_i2c_inst/st[2] ), 
            .O(n521)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbf00 */ ;
    defparam LUT__1053.LUTMASK = 16'hbf00;
    EFX_LUT4 LUT__1054 (.I0(n503), .I1(n521), .I2(n504), .O(ceg_net584)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'he0e0 */ ;
    defparam LUT__1054.LUTMASK = 16'he0e0;
    EFX_LUT4 LUT__1055 (.I0(debug_state[5]), .I1(n500), .I2(n485), .O(n522)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hd0d0 */ ;
    defparam LUT__1055.LUTMASK = 16'hd0d0;
    EFX_LUT4 LUT__1056 (.I0(n500), .I1(n490), .I2(\control_camera_i2c_inst/st[2] ), 
            .I3(n522), .O(\control_camera_i2c_inst/n10280 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h5300 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(447)
    defparam LUT__1056.LUTMASK = 16'h5300;
    EFX_LUT4 LUT__1057 (.I0(n515), .I1(debug_state[5]), .I2(n500), .I3(\control_camera_i2c_inst/st[0] ), 
            .O(n523)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h008f */ ;
    defparam LUT__1057.LUTMASK = 16'h008f;
    EFX_LUT4 LUT__1058 (.I0(\control_camera_i2c_inst/st[1] ), .I1(n489), 
            .I2(n504), .I3(n523), .O(\control_camera_i2c_inst/n1526 [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h007f */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1058.LUTMASK = 16'h007f;
    EFX_LUT4 LUT__1059 (.I0(\control_camera_i2c_inst/done_delay_cnt [3]), 
            .I1(\control_camera_i2c_inst/done_delay_cnt [4]), .I2(\control_camera_i2c_inst/done_delay_cnt [5]), 
            .I3(\control_camera_i2c_inst/done_delay_cnt [6]), .O(n524)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0001 */ ;
    defparam LUT__1059.LUTMASK = 16'h0001;
    EFX_LUT4 LUT__1060 (.I0(\control_camera_i2c_inst/done_delay_cnt [2]), 
            .I1(\control_camera_i2c_inst/done_delay_cnt [7]), .I2(\control_camera_i2c_inst/done_delay_cnt [8]), 
            .I3(\control_camera_i2c_inst/done_delay_cnt [9]), .O(n525)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0001 */ ;
    defparam LUT__1060.LUTMASK = 16'h0001;
    EFX_LUT4 LUT__1061 (.I0(\control_camera_i2c_inst/done_delay_cnt [0]), 
            .I1(\control_camera_i2c_inst/done_delay_cnt [1]), .O(n526)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1111 */ ;
    defparam LUT__1061.LUTMASK = 16'h1111;
    EFX_LUT4 LUT__1062 (.I0(\control_camera_i2c_inst/done_delay_cnt [10]), 
            .I1(n524), .I2(n525), .I3(n526), .O(n527)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4000 */ ;
    defparam LUT__1062.LUTMASK = 16'h4000;
    EFX_LUT4 LUT__1063 (.I0(\control_camera_i2c_inst/done_delay_cnt [12]), 
            .I1(\control_camera_i2c_inst/done_delay_cnt [13]), .O(n528)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1111 */ ;
    defparam LUT__1063.LUTMASK = 16'h1111;
    EFX_LUT4 LUT__1064 (.I0(\control_camera_i2c_inst/done_delay_cnt [14]), 
            .I1(\control_camera_i2c_inst/done_delay_cnt [15]), .I2(n528), 
            .O(n529)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__1064.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1065 (.I0(\control_camera_i2c_inst/done_delay_cnt [11]), 
            .I1(n527), .I2(\control_camera_i2c_inst/i2c_done_r_and_catch_i ), 
            .I3(n529), .O(\~control_camera_i2c_inst/n2059 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4000 */ ;
    defparam LUT__1065.LUTMASK = 16'h4000;
    EFX_LUT4 LUT__1066 (.I0(start_write16), .I1(start_read16), .O(n530)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1111 */ ;
    defparam LUT__1066.LUTMASK = 16'h1111;
    EFX_LUT4 LUT__1067 (.I0(\~control_camera_i2c_inst/n2059 ), .I1(n530), 
            .O(\control_camera_i2c_inst/n2061 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbbbb */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(300)
    defparam LUT__1067.LUTMASK = 16'hbbbb;
    EFX_LUT4 LUT__1068 (.I0(\~control_camera_i2c_inst/n2059 ), .I1(i2c_done), 
            .I2(n530), .O(ceg_net26)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(244)
    defparam LUT__1068.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1069 (.I0(n521), .I1(n503), .O(n531)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1111 */ ;
    defparam LUT__1069.LUTMASK = 16'h1111;
    EFX_LUT4 LUT__1070 (.I0(\control_camera_i2c_inst/st[1] ), .I1(n495), 
            .I2(n488), .O(n532)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0b0b */ ;
    defparam LUT__1070.LUTMASK = 16'h0b0b;
    EFX_LUT4 LUT__1071 (.I0(n532), .I1(n531), .I2(\control_camera_i2c_inst/st[3] ), 
            .I3(n490), .O(n533)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'ha300 */ ;
    defparam LUT__1071.LUTMASK = 16'ha300;
    EFX_LUT4 LUT__1072 (.I0(n511), .I1(n517), .I2(n533), .O(\control_camera_i2c_inst/n1523 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0b0b */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1072.LUTMASK = 16'h0b0b;
    EFX_LUT4 LUT__1073 (.I0(debug_state[5]), .I1(\control_camera_i2c_inst/st[0] ), 
            .I2(\control_camera_i2c_inst/i2c_done_delayed ), .I3(reg_16bit), 
            .O(\control_camera_i2c_inst/n1485 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hcec0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1073.LUTMASK = 16'hcec0;
    EFX_LUT4 LUT__1074 (.I0(\control_camera_i2c_inst/st[0] ), .I1(i2c_busy), 
            .O(n534)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;
    defparam LUT__1074.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__1075 (.I0(n534), .I1(\control_camera_i2c_inst/st[1] ), 
            .I2(\control_camera_i2c_inst/st[2] ), .I3(debug_state[5]), .O(n535)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h3ffe */ ;
    defparam LUT__1075.LUTMASK = 16'h3ffe;
    EFX_LUT4 LUT__1076 (.I0(n535), .I1(n500), .I2(rst_n), .O(ceg_net444)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;   // /home/olle/efinity_p2/BRAM/top_level.vhd(207)
    defparam LUT__1076.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1077 (.I0(\control_camera_i2c_inst/done_delay_cnt [11]), 
            .I1(n527), .I2(n529), .O(n536)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1077.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1078 (.I0(n495), .I1(n504), .O(n537)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__1078.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1079 (.I0(n536), .I1(n537), .I2(\control_camera_i2c_inst/done_delay_cnt [0]), 
            .I3(\control_camera_i2c_inst/i2c_done_r_and_catch_i ), .O(\control_camera_i2c_inst/n1565 [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hcdfc */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1079.LUTMASK = 16'hcdfc;
    EFX_LUT4 LUT__1080 (.I0(n485), .I1(debug_state[5]), .O(n538)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1111 */ ;
    defparam LUT__1080.LUTMASK = 16'h1111;
    EFX_LUT4 LUT__1081 (.I0(n488), .I1(n486), .I2(n538), .I3(ceg_net584), 
            .O(ceg_net591)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hff40 */ ;
    defparam LUT__1081.LUTMASK = 16'hff40;
    EFX_LUT4 LUT__1082 (.I0(n511), .I1(n522), .I2(n517), .I3(ceg_net591), 
            .O(\control_camera_i2c_inst/n7280 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h00ef */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(535)
    defparam LUT__1082.LUTMASK = 16'h00ef;
    EFX_LUT4 LUT__1083 (.I0(\control_camera_i2c_inst/st[3] ), .I1(\control_camera_i2c_inst/st[2] ), 
            .I2(n497), .I3(debug_state[4]), .O(n539)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0fbb */ ;
    defparam LUT__1083.LUTMASK = 16'h0fbb;
    EFX_LUT4 LUT__1084 (.I0(\control_camera_i2c_inst/st[0] ), .I1(\control_camera_i2c_inst/st[1] ), 
            .I2(n500), .I3(n488), .O(n540)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h001f */ ;
    defparam LUT__1084.LUTMASK = 16'h001f;
    EFX_LUT4 LUT__1085 (.I0(n495), .I1(n494), .I2(n486), .I3(debug_state[5]), 
            .O(n541)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1f00 */ ;
    defparam LUT__1085.LUTMASK = 16'h1f00;
    EFX_LUT4 LUT__1086 (.I0(n540), .I1(n538), .I2(n539), .I3(n541), 
            .O(n542)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h007f */ ;
    defparam LUT__1086.LUTMASK = 16'h007f;
    EFX_LUT4 LUT__1087 (.I0(\control_camera_i2c_inst/st[1] ), .I1(\control_camera_i2c_inst/st[2] ), 
            .O(n543)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__1087.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1088 (.I0(\control_camera_i2c_inst/i2c_done_delayed ), .I1(n543), 
            .I2(debug_state[5]), .I3(n500), .O(n544)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8f00 */ ;
    defparam LUT__1088.LUTMASK = 16'h8f00;
    EFX_LUT4 LUT__1089 (.I0(n500), .I1(n485), .I2(n544), .I3(slave_addr7[5]), 
            .O(n545)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7770 */ ;
    defparam LUT__1089.LUTMASK = 16'h7770;
    EFX_LUT4 LUT__1090 (.I0(n542), .I1(n501), .I2(n545), .O(\control_camera_i2c_inst/n1460 [5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1090.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1091 (.I0(rd_valid), .I1(\control_camera_i2c_inst/st[0] ), 
            .I2(\control_camera_i2c_inst/st[1] ), .I3(reg_addr16[1]), .O(n546)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h007f */ ;
    defparam LUT__1091.LUTMASK = 16'h007f;
    EFX_LUT4 LUT__1092 (.I0(\control_camera_i2c_inst/st[2] ), .I1(n546), 
            .I2(\control_camera_i2c_inst/st[3] ), .I3(debug_state[4]), .O(n547)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hcff5 */ ;
    defparam LUT__1092.LUTMASK = 16'hcff5;
    EFX_LUT4 LUT__1093 (.I0(\control_camera_i2c_inst/st[2] ), .I1(n516), 
            .I2(n547), .I3(debug_state[5]), .O(n548)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbbf0 */ ;
    defparam LUT__1093.LUTMASK = 16'hbbf0;
    EFX_LUT4 LUT__1094 (.I0(reg_addr16[1]), .I1(n517), .I2(n518), .I3(n548), 
            .O(\control_camera_i2c_inst/n1468 [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h80ff */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1094.LUTMASK = 16'h80ff;
    EFX_LUT4 LUT__1095 (.I0(\control_camera_i2c_inst/st[3] ), .I1(debug_state[5]), 
            .I2(n510), .I3(n533), .O(ceg_net580)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hff10 */ ;
    defparam LUT__1095.LUTMASK = 16'hff10;
    EFX_LUT4 LUT__1096 (.I0(debug_state[4]), .I1(\control_camera_i2c_inst/i2c_done_delayed ), 
            .I2(\control_camera_i2c_inst/st[0] ), .O(n549)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1096.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1097 (.I0(n543), .I1(n549), .O(n550)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__1097.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1098 (.I0(n500), .I1(n515), .I2(n490), .I3(n550), 
            .O(n551)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h000d */ ;
    defparam LUT__1098.LUTMASK = 16'h000d;
    EFX_LUT4 LUT__1099 (.I0(n521), .I1(reg_addr16[2]), .I2(n486), .I3(n489), 
            .O(n552)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hc0cd */ ;
    defparam LUT__1099.LUTMASK = 16'hc0cd;
    EFX_LUT4 LUT__1100 (.I0(n497), .I1(n485), .I2(\control_camera_i2c_inst/st[2] ), 
            .I3(n486), .O(n553)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hac00 */ ;
    defparam LUT__1100.LUTMASK = 16'hac00;
    EFX_LUT4 LUT__1101 (.I0(debug_state[5]), .I1(n553), .I2(n552), .O(n554)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__1101.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1102 (.I0(n511), .I1(reg_addr16[2]), .I2(n551), .I3(n554), 
            .O(\control_camera_i2c_inst/n1468 [2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'heee0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1102.LUTMASK = 16'heee0;
    EFX_LUT4 LUT__1103 (.I0(n497), .I1(n485), .I2(\control_camera_i2c_inst/st[2] ), 
            .I3(reg_addr16[3]), .O(n555)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h5300 */ ;
    defparam LUT__1103.LUTMASK = 16'h5300;
    EFX_LUT4 LUT__1104 (.I0(\control_camera_i2c_inst/st[1] ), .I1(\control_camera_i2c_inst/st[0] ), 
            .I2(\control_camera_i2c_inst/st[2] ), .O(n556)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0d0d */ ;
    defparam LUT__1104.LUTMASK = 16'h0d0d;
    EFX_LUT4 LUT__1105 (.I0(n556), .I1(n555), .I2(debug_state[5]), .I3(\control_camera_i2c_inst/st[3] ), 
            .O(n557)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0c05 */ ;
    defparam LUT__1105.LUTMASK = 16'h0c05;
    EFX_LUT4 LUT__1106 (.I0(n511), .I1(reg_addr16[3]), .I2(n551), .I3(n557), 
            .O(\control_camera_i2c_inst/n1468 [3])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'heee0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1106.LUTMASK = 16'heee0;
    EFX_LUT4 LUT__1107 (.I0(\control_camera_i2c_inst/st[0] ), .I1(\control_camera_i2c_inst/st[1] ), 
            .O(n558)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h6666 */ ;
    defparam LUT__1107.LUTMASK = 16'h6666;
    EFX_LUT4 LUT__1108 (.I0(\control_camera_i2c_inst/i2c_done_delayed ), .I1(n558), 
            .I2(n497), .I3(\control_camera_i2c_inst/st[2] ), .O(n559)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h770f */ ;
    defparam LUT__1108.LUTMASK = 16'h770f;
    EFX_LUT4 LUT__1109 (.I0(\control_camera_i2c_inst/st[2] ), .I1(\control_camera_i2c_inst/st[3] ), 
            .I2(n549), .I3(debug_state[5]), .O(n560)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h6000 */ ;
    defparam LUT__1109.LUTMASK = 16'h6000;
    EFX_LUT4 LUT__1110 (.I0(n550), .I1(reg_addr16[8]), .I2(debug_state[5]), 
            .I3(n560), .O(n561)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h00bf */ ;
    defparam LUT__1110.LUTMASK = 16'h00bf;
    EFX_LUT4 LUT__1111 (.I0(\control_camera_i2c_inst/st[2] ), .I1(\control_camera_i2c_inst/st[1] ), 
            .I2(\control_camera_i2c_inst/st[0] ), .O(n562)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4141 */ ;
    defparam LUT__1111.LUTMASK = 16'h4141;
    EFX_LUT4 LUT__1112 (.I0(reg_addr16[8]), .I1(n521), .I2(n562), .I3(n500), 
            .O(n563)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf400 */ ;
    defparam LUT__1112.LUTMASK = 16'hf400;
    EFX_LUT4 LUT__1113 (.I0(n510), .I1(n486), .I2(reg_addr16[8]), .O(n564)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0e0e */ ;
    defparam LUT__1113.LUTMASK = 16'h0e0e;
    EFX_LUT4 LUT__1114 (.I0(n553), .I1(n563), .I2(n564), .I3(debug_state[5]), 
            .O(n565)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0001 */ ;
    defparam LUT__1114.LUTMASK = 16'h0001;
    EFX_LUT4 LUT__1115 (.I0(n559), .I1(n500), .I2(n561), .I3(n565), 
            .O(\control_camera_i2c_inst/n1468 [8])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hff0b */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1115.LUTMASK = 16'hff0b;
    EFX_LUT4 LUT__1116 (.I0(\control_camera_i2c_inst/st[2] ), .I1(n499), 
            .I2(debug_state[5]), .I3(n500), .O(n566)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8f00 */ ;
    defparam LUT__1116.LUTMASK = 16'h8f00;
    EFX_LUT4 LUT__1117 (.I0(debug_state[5]), .I1(debug_state[4]), .I2(n497), 
            .I3(reg_addr16[9]), .O(n567)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbf00 */ ;
    defparam LUT__1117.LUTMASK = 16'hbf00;
    EFX_LUT4 LUT__1118 (.I0(\control_camera_i2c_inst/st[1] ), .I1(\control_camera_i2c_inst/st[2] ), 
            .I2(\control_camera_i2c_inst/st[3] ), .I3(\control_camera_i2c_inst/st[0] ), 
            .O(n568)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4bf7 */ ;
    defparam LUT__1118.LUTMASK = 16'h4bf7;
    EFX_LUT4 LUT__1119 (.I0(\control_camera_i2c_inst/st[2] ), .I1(n497), 
            .I2(\control_camera_i2c_inst/i2c_done_delayed ), .I3(n568), 
            .O(n569)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbb0f */ ;
    defparam LUT__1119.LUTMASK = 16'hbb0f;
    EFX_LUT4 LUT__1120 (.I0(n569), .I1(debug_state[4]), .I2(debug_state[5]), 
            .O(n570)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__1120.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1121 (.I0(n532), .I1(n519), .I2(\control_camera_i2c_inst/st[3] ), 
            .I3(n490), .O(n571)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h5300 */ ;
    defparam LUT__1121.LUTMASK = 16'h5300;
    EFX_LUT4 LUT__1122 (.I0(n567), .I1(n566), .I2(n570), .I3(n571), 
            .O(\control_camera_i2c_inst/n1468 [9])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h000e */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1122.LUTMASK = 16'h000e;
    EFX_LUT4 LUT__1123 (.I0(n497), .I1(n494), .I2(n486), .I3(wr_len[1]), 
            .O(n572)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h3500 */ ;
    defparam LUT__1123.LUTMASK = 16'h3500;
    EFX_LUT4 LUT__1124 (.I0(debug_state[5]), .I1(n495), .I2(n572), .I3(n486), 
            .O(n573)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0305 */ ;
    defparam LUT__1124.LUTMASK = 16'h0305;
    EFX_LUT4 LUT__1125 (.I0(debug_state[4]), .I1(n505), .I2(wr_len[1]), 
            .O(n574)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hb0b0 */ ;
    defparam LUT__1125.LUTMASK = 16'hb0b0;
    EFX_LUT4 LUT__1126 (.I0(n508), .I1(n574), .I2(n486), .O(n575)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0101 */ ;
    defparam LUT__1126.LUTMASK = 16'h0101;
    EFX_LUT4 LUT__1127 (.I0(n532), .I1(wr_len[1]), .I2(n556), .I3(n486), 
            .O(n576)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h77f0 */ ;
    defparam LUT__1127.LUTMASK = 16'h77f0;
    EFX_LUT4 LUT__1128 (.I0(n575), .I1(n573), .I2(n576), .I3(n490), 
            .O(\control_camera_i2c_inst/n1486 [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0f11 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1128.LUTMASK = 16'h0f11;
    EFX_LUT4 LUT__1129 (.I0(\control_camera_i2c_inst/i2c_done_delayed ), .I1(wr_data[2]), 
            .I2(\control_camera_i2c_inst/st[0] ), .I3(n543), .O(n577)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4f00 */ ;
    defparam LUT__1129.LUTMASK = 16'h4f00;
    EFX_LUT4 LUT__1130 (.I0(wr_data[2]), .I1(n577), .I2(n500), .I3(n541), 
            .O(\control_camera_i2c_inst/n1490 [2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hca00 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1130.LUTMASK = 16'hca00;
    EFX_LUT4 LUT__1131 (.I0(n543), .I1(\control_camera_i2c_inst/st[0] ), 
            .I2(n505), .I3(n497), .O(n578)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0007 */ ;
    defparam LUT__1131.LUTMASK = 16'h0007;
    EFX_LUT4 LUT__1132 (.I0(n578), .I1(n531), .I2(n500), .I3(debug_state[5]), 
            .O(ceg_net586)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'ha03f */ ;
    defparam LUT__1132.LUTMASK = 16'ha03f;
    EFX_LUT4 LUT__1133 (.I0(wr_data[5]), .I1(n556), .I2(debug_state[5]), 
            .I3(n500), .O(n579)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0c05 */ ;
    defparam LUT__1133.LUTMASK = 16'h0c05;
    EFX_LUT4 LUT__1134 (.I0(n517), .I1(wr_data[5]), .I2(n518), .I3(n579), 
            .O(\control_camera_i2c_inst/n1490 [5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h008f */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1134.LUTMASK = 16'h008f;
    EFX_LUT4 LUT__1135 (.I0(debug_state[4]), .I1(\control_camera_i2c_inst/st[3] ), 
            .I2(\control_camera_i2c_inst/st[1] ), .I3(n495), .O(n580)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hd5f0 */ ;
    defparam LUT__1135.LUTMASK = 16'hd5f0;
    EFX_LUT4 LUT__1136 (.I0(n507), .I1(n499), .I2(n500), .I3(\control_camera_i2c_inst/st[1] ), 
            .O(n581)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h000b */ ;
    defparam LUT__1136.LUTMASK = 16'h000b;
    EFX_LUT4 LUT__1137 (.I0(n543), .I1(n489), .I2(n500), .O(n582)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__1137.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1138 (.I0(n507), .I1(n497), .O(n583)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;
    defparam LUT__1138.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__1139 (.I0(n581), .I1(n582), .I2(n583), .I3(debug_state[5]), 
            .O(n584)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0001 */ ;
    defparam LUT__1139.LUTMASK = 16'h0001;
    EFX_LUT4 LUT__1140 (.I0(n501), .I1(debug_state[5]), .I2(n580), .I3(n584), 
            .O(\control_camera_i2c_inst/n1526 [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hff40 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1140.LUTMASK = 16'hff40;
    EFX_LUT4 LUT__1141 (.I0(\control_camera_i2c_inst/st[3] ), .I1(rd_valid), 
            .I2(debug_state[4]), .I3(\control_camera_i2c_inst/st[0] ), .O(n585)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h3ffa */ ;
    defparam LUT__1141.LUTMASK = 16'h3ffa;
    EFX_LUT4 LUT__1142 (.I0(n585), .I1(\control_camera_i2c_inst/st[2] ), 
            .I2(\control_camera_i2c_inst/st[1] ), .O(n586)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__1142.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1143 (.I0(\control_camera_i2c_inst/st[1] ), .I1(n549), 
            .I2(\control_camera_i2c_inst/st[2] ), .I3(n500), .O(n587)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h00f4 */ ;
    defparam LUT__1143.LUTMASK = 16'h00f4;
    EFX_LUT4 LUT__1144 (.I0(n497), .I1(n587), .O(n588)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;
    defparam LUT__1144.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__1145 (.I0(n497), .I1(n494), .I2(\control_camera_i2c_inst/st[3] ), 
            .I3(debug_state[4]), .O(n589)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf335 */ ;
    defparam LUT__1145.LUTMASK = 16'hf335;
    EFX_LUT4 LUT__1146 (.I0(\control_camera_i2c_inst/st[2] ), .I1(n589), 
            .I2(n550), .O(n590)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0b0b */ ;
    defparam LUT__1146.LUTMASK = 16'h0b0b;
    EFX_LUT4 LUT__1147 (.I0(n588), .I1(n586), .I2(n590), .I3(debug_state[5]), 
            .O(\control_camera_i2c_inst/n1526 [2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf0ee */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1147.LUTMASK = 16'hf0ee;
    EFX_LUT4 LUT__1148 (.I0(debug_state[4]), .I1(\control_camera_i2c_inst/st[2] ), 
            .I2(n497), .I3(\control_camera_i2c_inst/st[3] ), .O(n591)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h3fc4 */ ;
    defparam LUT__1148.LUTMASK = 16'h3fc4;
    EFX_LUT4 LUT__1149 (.I0(n591), .I1(n550), .I2(\control_camera_i2c_inst/st[3] ), 
            .I3(debug_state[5]), .O(\control_camera_i2c_inst/n1526 [3])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h3caa */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1149.LUTMASK = 16'h3caa;
    EFX_LUT4 LUT__1150 (.I0(n543), .I1(n486), .I2(n538), .I3(ceg_net584), 
            .O(ceg_net590)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hff40 */ ;
    defparam LUT__1150.LUTMASK = 16'hff40;
    EFX_LUT4 LUT__1151 (.I0(n499), .I1(debug_state[5]), .I2(\control_camera_i2c_inst/st[3] ), 
            .I3(\control_camera_i2c_inst/st[1] ), .O(n592)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4ff7 */ ;
    defparam LUT__1151.LUTMASK = 16'h4ff7;
    EFX_LUT4 LUT__1152 (.I0(debug_state[5]), .I1(\control_camera_i2c_inst/st[3] ), 
            .I2(n488), .O(n593)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1152.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1153 (.I0(n592), .I1(\control_camera_i2c_inst/st[2] ), 
            .I2(n593), .I3(debug_state[4]), .O(\control_camera_i2c_inst/n1526 [4])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0f44 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1153.LUTMASK = 16'h0f44;
    EFX_LUT4 LUT__1154 (.I0(n488), .I1(\control_camera_i2c_inst/st[3] ), 
            .I2(debug_state[4]), .I3(debug_state[5]), .O(\control_camera_i2c_inst/n1526 [5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hff80 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(547)
    defparam LUT__1154.LUTMASK = 16'hff80;
    EFX_LUT4 LUT__1155 (.I0(\control_camera_i2c_inst/st[3] ), .I1(n543), 
            .I2(n510), .O(n594)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7070 */ ;
    defparam LUT__1155.LUTMASK = 16'h7070;
    EFX_LUT4 LUT__1156 (.I0(n538), .I1(n594), .I2(ceg_net591), .O(ceg_net592)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf8f8 */ ;
    defparam LUT__1156.LUTMASK = 16'hf8f8;
    EFX_LUT4 LUT__1157 (.I0(\control_camera_i2c_inst/done_delay_cnt [0]), 
            .I1(\control_camera_i2c_inst/i2c_done_r_and_catch_i ), .I2(\control_camera_i2c_inst/done_delay_cnt [1]), 
            .O(n595)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hb4b4 */ ;
    defparam LUT__1157.LUTMASK = 16'hb4b4;
    EFX_LUT4 LUT__1158 (.I0(\~control_camera_i2c_inst/n2059 ), .I1(n595), 
            .I2(n537), .O(\control_camera_i2c_inst/n1565 [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf4f4 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1158.LUTMASK = 16'hf4f4;
    EFX_LUT4 LUT__1159 (.I0(\control_camera_i2c_inst/done_delay_cnt [0]), 
            .I1(\control_camera_i2c_inst/done_delay_cnt [1]), .I2(\control_camera_i2c_inst/i2c_done_r_and_catch_i ), 
            .I3(\control_camera_i2c_inst/done_delay_cnt [2]), .O(n596)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hef10 */ ;
    defparam LUT__1159.LUTMASK = 16'hef10;
    EFX_LUT4 LUT__1160 (.I0(\~control_camera_i2c_inst/n2059 ), .I1(n596), 
            .I2(n537), .O(\control_camera_i2c_inst/n1565 [2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf4f4 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1160.LUTMASK = 16'hf4f4;
    EFX_LUT4 LUT__1161 (.I0(\control_camera_i2c_inst/done_delay_cnt [0]), 
            .I1(\control_camera_i2c_inst/done_delay_cnt [1]), .I2(\control_camera_i2c_inst/done_delay_cnt [2]), 
            .I3(\control_camera_i2c_inst/i2c_done_r_and_catch_i ), .O(n597)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0100 */ ;
    defparam LUT__1161.LUTMASK = 16'h0100;
    EFX_LUT4 LUT__1162 (.I0(n537), .I1(\~control_camera_i2c_inst/n2059 ), 
            .I2(n597), .I3(\control_camera_i2c_inst/done_delay_cnt [3]), 
            .O(\control_camera_i2c_inst/n1565 [3])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'habba */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1162.LUTMASK = 16'habba;
    EFX_LUT4 LUT__1163 (.I0(\control_camera_i2c_inst/done_delay_cnt [3]), 
            .I1(n597), .O(n598)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;
    defparam LUT__1163.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__1164 (.I0(n536), .I1(n537), .I2(\control_camera_i2c_inst/done_delay_cnt [4]), 
            .I3(n598), .O(\control_camera_i2c_inst/n1565 [4])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hcdfc */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1164.LUTMASK = 16'hcdfc;
    EFX_LUT4 LUT__1165 (.I0(\control_camera_i2c_inst/done_delay_cnt [4]), 
            .I1(n598), .I2(\control_camera_i2c_inst/done_delay_cnt [5]), 
            .O(n599)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hb4b4 */ ;
    defparam LUT__1165.LUTMASK = 16'hb4b4;
    EFX_LUT4 LUT__1166 (.I0(n536), .I1(n599), .I2(n537), .O(\control_camera_i2c_inst/n1565 [5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf4f4 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1166.LUTMASK = 16'hf4f4;
    EFX_LUT4 LUT__1167 (.I0(\control_camera_i2c_inst/done_delay_cnt [4]), 
            .I1(\control_camera_i2c_inst/done_delay_cnt [5]), .I2(n598), 
            .O(n600)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__1167.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1168 (.I0(n537), .I1(\~control_camera_i2c_inst/n2059 ), 
            .I2(n600), .I3(\control_camera_i2c_inst/done_delay_cnt [6]), 
            .O(\control_camera_i2c_inst/n1565 [6])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'habba */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1168.LUTMASK = 16'habba;
    EFX_LUT4 LUT__1169 (.I0(n524), .I1(n597), .I2(\control_camera_i2c_inst/done_delay_cnt [7]), 
            .O(n601)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7878 */ ;
    defparam LUT__1169.LUTMASK = 16'h7878;
    EFX_LUT4 LUT__1170 (.I0(\~control_camera_i2c_inst/n2059 ), .I1(n601), 
            .I2(n537), .O(\control_camera_i2c_inst/n1565 [7])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf4f4 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1170.LUTMASK = 16'hf4f4;
    EFX_LUT4 LUT__1171 (.I0(\control_camera_i2c_inst/done_delay_cnt [7]), 
            .I1(n597), .I2(n524), .O(n602)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1171.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1172 (.I0(n537), .I1(\~control_camera_i2c_inst/n2059 ), 
            .I2(n602), .I3(\control_camera_i2c_inst/done_delay_cnt [8]), 
            .O(\control_camera_i2c_inst/n1565 [8])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'habba */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1172.LUTMASK = 16'habba;
    EFX_LUT4 LUT__1173 (.I0(\control_camera_i2c_inst/done_delay_cnt [8]), 
            .I1(n602), .I2(n537), .I3(\control_camera_i2c_inst/done_delay_cnt [9]), 
            .O(\control_camera_i2c_inst/n1565 [9])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hfbf4 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1173.LUTMASK = 16'hfbf4;
    EFX_LUT4 LUT__1174 (.I0(\control_camera_i2c_inst/done_delay_cnt [8]), 
            .I1(\control_camera_i2c_inst/done_delay_cnt [9]), .I2(n602), 
            .O(n603)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__1174.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1175 (.I0(n537), .I1(\~control_camera_i2c_inst/n2059 ), 
            .I2(n603), .I3(\control_camera_i2c_inst/done_delay_cnt [10]), 
            .O(\control_camera_i2c_inst/n1565 [10])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'habba */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1175.LUTMASK = 16'habba;
    EFX_LUT4 LUT__1176 (.I0(n527), .I1(\control_camera_i2c_inst/i2c_done_r_and_catch_i ), 
            .O(n604)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__1176.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1177 (.I0(n529), .I1(n537), .I2(\control_camera_i2c_inst/done_delay_cnt [11]), 
            .I3(n604), .O(\control_camera_i2c_inst/n1565 [11])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hcdfc */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1177.LUTMASK = 16'hcdfc;
    EFX_LUT4 LUT__1178 (.I0(\control_camera_i2c_inst/done_delay_cnt [11]), 
            .I1(n604), .I2(n537), .I3(\control_camera_i2c_inst/done_delay_cnt [12]), 
            .O(\control_camera_i2c_inst/n1565 [12])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hfbf4 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1178.LUTMASK = 16'hfbf4;
    EFX_LUT4 LUT__1179 (.I0(\control_camera_i2c_inst/done_delay_cnt [11]), 
            .I1(\control_camera_i2c_inst/done_delay_cnt [12]), .I2(n527), 
            .I3(\control_camera_i2c_inst/i2c_done_r_and_catch_i ), .O(n605)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1000 */ ;
    defparam LUT__1179.LUTMASK = 16'h1000;
    EFX_LUT4 LUT__1180 (.I0(n537), .I1(n605), .I2(\control_camera_i2c_inst/done_delay_cnt [13]), 
            .O(\control_camera_i2c_inst/n1565 [13])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbebe */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1180.LUTMASK = 16'hbebe;
    EFX_LUT4 LUT__1181 (.I0(\control_camera_i2c_inst/done_delay_cnt [11]), 
            .I1(n528), .I2(\control_camera_i2c_inst/i2c_done_r_and_catch_i ), 
            .I3(n527), .O(n606)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4000 */ ;
    defparam LUT__1181.LUTMASK = 16'h4000;
    EFX_LUT4 LUT__1182 (.I0(\control_camera_i2c_inst/done_delay_cnt [15]), 
            .I1(n537), .I2(\control_camera_i2c_inst/done_delay_cnt [14]), 
            .I3(n606), .O(\control_camera_i2c_inst/n1565 [14])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hcefc */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1182.LUTMASK = 16'hcefc;
    EFX_LUT4 LUT__1183 (.I0(\control_camera_i2c_inst/done_delay_cnt [14]), 
            .I1(n606), .I2(\control_camera_i2c_inst/done_delay_cnt [15]), 
            .I3(n537), .O(\control_camera_i2c_inst/n1565 [15])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hffb0 */ ;   // /home/olle/efinity_p2/BRAM/control_camera_i2c.vhd(298)
    defparam LUT__1183.LUTMASK = 16'hffb0;
    EFX_LUT4 LUT__1184 (.I0(\i2c_reg16_master_inst/div_cnt [7]), .I1(\i2c_reg16_master_inst/div_cnt [8]), 
            .I2(\i2c_reg16_master_inst/div_cnt [6]), .O(\i2c_reg16_master_inst/equal_5/n15 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbfbf */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(108)
    defparam LUT__1184.LUTMASK = 16'hbfbf;
    EFX_LUT4 LUT__1185 (.I0(\i2c_reg16_master_inst/div_cnt [0]), .I1(\i2c_reg16_master_inst/equal_5/n15 ), 
            .O(\i2c_reg16_master_inst/n18 [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(114)
    defparam LUT__1185.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__1186 (.I0(\i2c_reg16_master_inst/tick ), .I1(\i2c_reg16_master_inst/SDA_IN_SYNCED ), 
            .I2(\i2c_reg16_master_inst/st [4]), .O(n607)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7070 */ ;
    defparam LUT__1186.LUTMASK = 16'h7070;
    EFX_LUT4 LUT__1187 (.I0(\i2c_reg16_master_inst/SCL_IN_SYNCED ), .I1(\i2c_reg16_master_inst/st [2]), 
            .I2(\i2c_reg16_master_inst/st [1]), .I3(\i2c_reg16_master_inst/st [3]), 
            .O(n608)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4000 */ ;
    defparam LUT__1187.LUTMASK = 16'h4000;
    EFX_LUT4 LUT__1188 (.I0(\i2c_reg16_master_inst/st [0]), .I1(\i2c_reg16_master_inst/st [1]), 
            .O(n609)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1111 */ ;
    defparam LUT__1188.LUTMASK = 16'h1111;
    EFX_LUT4 LUT__1189 (.I0(\i2c_reg16_master_inst/st [0]), .I1(\i2c_reg16_master_inst/SCL_IN_SYNCED ), 
            .I2(\i2c_reg16_master_inst/tick ), .O(n610)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1189.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1190 (.I0(\i2c_reg16_master_inst/st [2]), .I1(\i2c_reg16_master_inst/st [3]), 
            .I2(\i2c_reg16_master_inst/tick ), .I3(\i2c_reg16_master_inst/st [0]), 
            .O(n611)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0e00 */ ;
    defparam LUT__1190.LUTMASK = 16'h0e00;
    EFX_LUT4 LUT__1191 (.I0(\i2c_reg16_master_inst/st [3]), .I1(n609), .I2(n610), 
            .I3(n611), .O(n612)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h000b */ ;
    defparam LUT__1191.LUTMASK = 16'h000b;
    EFX_LUT4 LUT__1192 (.I0(n608), .I1(\i2c_reg16_master_inst/tick ), .I2(n612), 
            .I3(\i2c_reg16_master_inst/st [4]), .O(n613)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h008f */ ;
    defparam LUT__1192.LUTMASK = 16'h008f;
    EFX_LUT4 LUT__1193 (.I0(n607), .I1(\i2c_reg16_master_inst/st [0]), .I2(n613), 
            .O(\i2c_reg16_master_inst/n703 [0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf8f8 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1193.LUTMASK = 16'hf8f8;
    EFX_LUT4 LUT__1194 (.I0(\i2c_reg16_master_inst/SCL_IN_SYNCED ), .I1(\i2c_reg16_master_inst/tick ), 
            .O(n614)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__1194.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1195 (.I0(\i2c_reg16_master_inst/st [3]), .I1(\i2c_reg16_master_inst/st [2]), 
            .O(n615)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;
    defparam LUT__1195.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__1196 (.I0(\i2c_reg16_master_inst/st [0]), .I1(\i2c_reg16_master_inst/st [4]), 
            .O(n616)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1111 */ ;
    defparam LUT__1196.LUTMASK = 16'h1111;
    EFX_LUT4 LUT__1197 (.I0(\i2c_reg16_master_inst/st [1]), .I1(n615), .I2(n616), 
            .O(n617)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1197.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1198 (.I0(\i2c_reg16_master_inst/st [3]), .I1(\i2c_reg16_master_inst/st [2]), 
            .I2(n609), .O(n618)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__1198.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1199 (.I0(\i2c_reg16_master_inst/st [3]), .I1(\i2c_reg16_master_inst/st [2]), 
            .I2(\i2c_reg16_master_inst/tick ), .I3(\i2c_reg16_master_inst/st [0]), 
            .O(n619)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0100 */ ;
    defparam LUT__1199.LUTMASK = 16'h0100;
    EFX_LUT4 LUT__1200 (.I0(n530), .I1(n618), .I2(n619), .I3(\i2c_reg16_master_inst/st [4]), 
            .O(n620)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h00f8 */ ;
    defparam LUT__1200.LUTMASK = 16'h00f8;
    EFX_LUT4 LUT__1201 (.I0(n614), .I1(n617), .I2(n620), .O(ceg_net593)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf4f4 */ ;
    defparam LUT__1201.LUTMASK = 16'hf4f4;
    EFX_LUT4 LUT__1202 (.I0(\i2c_reg16_master_inst/st [0]), .I1(\i2c_reg16_master_inst/st [1]), 
            .O(n621)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__1202.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1203 (.I0(\i2c_reg16_master_inst/st [4]), .I1(n621), .I2(n614), 
            .I3(\i2c_reg16_master_inst/st [3]), .O(n622)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4000 */ ;
    defparam LUT__1203.LUTMASK = 16'h4000;
    EFX_LUT4 LUT__1204 (.I0(n622), .I1(\i2c_reg16_master_inst/st [2]), .I2(n607), 
            .O(\i2c_reg16_master_inst/n703 [4])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf8f8 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1204.LUTMASK = 16'hf8f8;
    EFX_LUT4 LUT__1205 (.I0(\i2c_reg16_master_inst/SCL_IN_SYNCED ), .I1(\i2c_reg16_master_inst/st [0]), 
            .I2(\i2c_reg16_master_inst/tick ), .I3(\i2c_reg16_master_inst/st [4]), 
            .O(n623)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h001f */ ;
    defparam LUT__1205.LUTMASK = 16'h001f;
    EFX_LUT4 LUT__1206 (.I0(n620), .I1(\i2c_reg16_master_inst/st [3]), .I2(\i2c_reg16_master_inst/st [2]), 
            .I3(n623), .O(ceg_net594)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbeaa */ ;
    defparam LUT__1206.LUTMASK = 16'hbeaa;
    EFX_LUT4 LUT__1207 (.I0(\i2c_reg16_master_inst/byte_idx [0]), .I1(reg_16bit), 
            .I2(\i2c_reg16_master_inst/byte_idx [1]), .I3(\i2c_reg16_master_inst/byte_idx [2]), 
            .O(n624)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h000d */ ;
    defparam LUT__1207.LUTMASK = 16'h000d;
    EFX_LUT4 LUT__1208 (.I0(wr_len[1]), .I1(\i2c_reg16_master_inst/wpos [1]), 
            .I2(\i2c_reg16_master_inst/wpos [0]), .I3(wr_len[0]), .O(n625)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hd4dd */ ;
    defparam LUT__1208.LUTMASK = 16'hd4dd;
    EFX_LUT4 LUT__1209 (.I0(n624), .I1(\i2c_reg16_master_inst/rw_read ), 
            .I2(n625), .I3(\i2c_reg16_master_inst/st [0]), .O(n626)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h00ef */ ;
    defparam LUT__1209.LUTMASK = 16'h00ef;
    EFX_LUT4 LUT__1210 (.I0(\i2c_reg16_master_inst/tick ), .I1(\i2c_reg16_master_inst/st [0]), 
            .I2(\i2c_reg16_master_inst/st [4]), .I3(\i2c_reg16_master_inst/st [1]), 
            .O(n627)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0b00 */ ;
    defparam LUT__1210.LUTMASK = 16'h0b00;
    EFX_LUT4 LUT__1211 (.I0(\i2c_reg16_master_inst/rpos [0]), .I1(\i2c_reg16_master_inst/rpos [1]), 
            .I2(rd_len[0]), .O(n628)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__1211.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1212 (.I0(\i2c_reg16_master_inst/bit_idx[0] ), .I1(\i2c_reg16_master_inst/bit_idx[1] ), 
            .I2(\i2c_reg16_master_inst/bit_idx[2] ), .O(n629)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8080 */ ;
    defparam LUT__1212.LUTMASK = 16'h8080;
    EFX_LUT4 LUT__1213 (.I0(\i2c_reg16_master_inst/st [0]), .I1(\i2c_reg16_master_inst/st [2]), 
            .I2(\i2c_reg16_master_inst/SCL_IN_SYNCED ), .I3(\i2c_reg16_master_inst/tick ), 
            .O(n630)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1000 */ ;
    defparam LUT__1213.LUTMASK = 16'h1000;
    EFX_LUT4 LUT__1214 (.I0(n629), .I1(n628), .I2(\i2c_reg16_master_inst/st [1]), 
            .I3(n630), .O(n631)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h3500 */ ;
    defparam LUT__1214.LUTMASK = 16'h3500;
    EFX_LUT4 LUT__1215 (.I0(\i2c_reg16_master_inst/st [2]), .I1(\i2c_reg16_master_inst/SCL_IN_SYNCED ), 
            .I2(\i2c_reg16_master_inst/tick ), .O(n632)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8080 */ ;
    defparam LUT__1215.LUTMASK = 16'h8080;
    EFX_LUT4 LUT__1216 (.I0(n632), .I1(\i2c_reg16_master_inst/st [0]), .I2(\i2c_reg16_master_inst/st [1]), 
            .I3(\i2c_reg16_master_inst/st [4]), .O(n633)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h007d */ ;
    defparam LUT__1216.LUTMASK = 16'h007d;
    EFX_LUT4 LUT__1217 (.I0(n631), .I1(n633), .I2(n607), .I3(\i2c_reg16_master_inst/st [3]), 
            .O(n634)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf400 */ ;
    defparam LUT__1217.LUTMASK = 16'hf400;
    EFX_LUT4 LUT__1218 (.I0(n626), .I1(n615), .I2(n627), .I3(n634), 
            .O(\i2c_reg16_master_inst/n703 [3])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hff40 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1218.LUTMASK = 16'hff40;
    EFX_LUT4 LUT__1219 (.I0(n621), .I1(n615), .I2(n623), .I3(n620), 
            .O(ceg_net595)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hff40 */ ;
    defparam LUT__1219.LUTMASK = 16'hff40;
    EFX_LUT4 LUT__1220 (.I0(n625), .I1(\i2c_reg16_master_inst/rw_read ), 
            .I2(n624), .I3(n614), .O(n635)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf100 */ ;
    defparam LUT__1220.LUTMASK = 16'hf100;
    EFX_LUT4 LUT__1221 (.I0(\i2c_reg16_master_inst/tick ), .I1(\i2c_reg16_master_inst/st [0]), 
            .I2(\i2c_reg16_master_inst/st [1]), .I3(\i2c_reg16_master_inst/st [2]), 
            .O(n636)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7000 */ ;
    defparam LUT__1221.LUTMASK = 16'h7000;
    EFX_LUT4 LUT__1222 (.I0(n629), .I1(\i2c_reg16_master_inst/st [0]), .I2(\i2c_reg16_master_inst/st [2]), 
            .I3(\i2c_reg16_master_inst/st [1]), .O(n637)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf31f */ ;
    defparam LUT__1222.LUTMASK = 16'hf31f;
    EFX_LUT4 LUT__1223 (.I0(n636), .I1(n635), .I2(\i2c_reg16_master_inst/st [3]), 
            .I3(n637), .O(n638)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0d00 */ ;
    defparam LUT__1223.LUTMASK = 16'h0d00;
    EFX_LUT4 LUT__1224 (.I0(\i2c_reg16_master_inst/tick ), .I1(\i2c_reg16_master_inst/st [2]), 
            .I2(\i2c_reg16_master_inst/st [1]), .I3(\i2c_reg16_master_inst/st [0]), 
            .O(n639)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h2c00 */ ;
    defparam LUT__1224.LUTMASK = 16'h2c00;
    EFX_LUT4 LUT__1225 (.I0(n629), .I1(\i2c_reg16_master_inst/st [2]), .I2(\i2c_reg16_master_inst/st [1]), 
            .I3(n610), .O(n640)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf100 */ ;
    defparam LUT__1225.LUTMASK = 16'hf100;
    EFX_LUT4 LUT__1226 (.I0(\i2c_reg16_master_inst/st [2]), .I1(n614), .I2(\i2c_reg16_master_inst/st [3]), 
            .O(n641)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hd0d0 */ ;
    defparam LUT__1226.LUTMASK = 16'hd0d0;
    EFX_LUT4 LUT__1227 (.I0(n640), .I1(n639), .I2(n641), .I3(\i2c_reg16_master_inst/st [4]), 
            .O(n642)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h00ef */ ;
    defparam LUT__1227.LUTMASK = 16'h00ef;
    EFX_LUT4 LUT__1228 (.I0(n607), .I1(\i2c_reg16_master_inst/st [2]), .I2(n638), 
            .I3(n642), .O(\i2c_reg16_master_inst/n703 [2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8f88 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1228.LUTMASK = 16'h8f88;
    EFX_LUT4 LUT__1229 (.I0(\i2c_reg16_master_inst/st [1]), .I1(n623), .I2(n615), 
            .I3(n620), .O(ceg_net596)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hff40 */ ;
    defparam LUT__1229.LUTMASK = 16'hff40;
    EFX_LUT4 LUT__1230 (.I0(\i2c_reg16_master_inst/st [2]), .I1(\i2c_reg16_master_inst/st [1]), 
            .I2(\i2c_reg16_master_inst/tick ), .O(n643)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1230.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1231 (.I0(n628), .I1(\i2c_reg16_master_inst/SCL_IN_SYNCED ), 
            .I2(\i2c_reg16_master_inst/st [0]), .I3(n643), .O(n644)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf800 */ ;
    defparam LUT__1231.LUTMASK = 16'hf800;
    EFX_LUT4 LUT__1232 (.I0(n621), .I1(n614), .I2(\i2c_reg16_master_inst/st [4]), 
            .I3(\i2c_reg16_master_inst/st [3]), .O(n645)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0700 */ ;
    defparam LUT__1232.LUTMASK = 16'h0700;
    EFX_LUT4 LUT__1233 (.I0(n607), .I1(\i2c_reg16_master_inst/st [1]), .I2(n644), 
            .I3(n645), .O(n646)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7077 */ ;
    defparam LUT__1233.LUTMASK = 16'h7077;
    EFX_LUT4 LUT__1234 (.I0(n629), .I1(\i2c_reg16_master_inst/SCL_IN_SYNCED ), 
            .I2(\i2c_reg16_master_inst/st [0]), .I3(\i2c_reg16_master_inst/tick ), 
            .O(n647)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf400 */ ;
    defparam LUT__1234.LUTMASK = 16'hf400;
    EFX_LUT4 LUT__1235 (.I0(n647), .I1(n632), .I2(\i2c_reg16_master_inst/st [1]), 
            .O(n648)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0101 */ ;
    defparam LUT__1235.LUTMASK = 16'h0101;
    EFX_LUT4 LUT__1236 (.I0(\i2c_reg16_master_inst/st [0]), .I1(n632), .I2(\i2c_reg16_master_inst/st [1]), 
            .O(n649)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1236.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1237 (.I0(n624), .I1(\i2c_reg16_master_inst/rw_read ), 
            .I2(n649), .I3(n625), .O(n650)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1000 */ ;
    defparam LUT__1237.LUTMASK = 16'h1000;
    EFX_LUT4 LUT__1238 (.I0(\i2c_reg16_master_inst/tick ), .I1(\i2c_reg16_master_inst/st [2]), 
            .I2(\i2c_reg16_master_inst/st [1]), .I3(\i2c_reg16_master_inst/st [0]), 
            .O(n651)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hb400 */ ;
    defparam LUT__1238.LUTMASK = 16'hb400;
    EFX_LUT4 LUT__1239 (.I0(n651), .I1(\i2c_reg16_master_inst/st [4]), .I2(\i2c_reg16_master_inst/st [3]), 
            .O(n652)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0101 */ ;
    defparam LUT__1239.LUTMASK = 16'h0101;
    EFX_LUT4 LUT__1240 (.I0(n629), .I1(\i2c_reg16_master_inst/st [2]), .I2(n609), 
            .I3(n652), .O(n653)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4f00 */ ;
    defparam LUT__1240.LUTMASK = 16'h4f00;
    EFX_LUT4 LUT__1241 (.I0(n650), .I1(n653), .I2(n646), .I3(n648), 
            .O(\i2c_reg16_master_inst/n703 [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h444f */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1241.LUTMASK = 16'h444f;
    EFX_LUT4 LUT__1242 (.I0(\i2c_reg16_master_inst/equal_5/n15 ), .I1(\i2c_reg16_master_inst/n8 [8]), 
            .O(\i2c_reg16_master_inst/n18 [8])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(114)
    defparam LUT__1242.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1243 (.I0(\i2c_reg16_master_inst/equal_5/n15 ), .I1(\i2c_reg16_master_inst/n8 [6]), 
            .O(\i2c_reg16_master_inst/n18 [6])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(114)
    defparam LUT__1243.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1244 (.I0(\i2c_reg16_master_inst/equal_5/n15 ), .I1(\i2c_reg16_master_inst/n8 [1]), 
            .O(\i2c_reg16_master_inst/n18 [1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(114)
    defparam LUT__1244.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1245 (.I0(\i2c_reg16_master_inst/byte_idx [0]), .I1(\i2c_reg16_master_inst/st [2]), 
            .O(\i2c_reg16_master_inst/n1920 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1245.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__1246 (.I0(\i2c_reg16_master_inst/st [3]), .I1(n649), .I2(n618), 
            .I3(\i2c_reg16_master_inst/st [4]), .O(ceg_net325)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hff0b */ ;
    defparam LUT__1246.LUTMASK = 16'hff0b;
    EFX_LUT4 LUT__1247 (.I0(n530), .I1(\i2c_reg16_master_inst/st [4]), .O(\i2c_reg16_master_inst/n677 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1111 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1247.LUTMASK = 16'h1111;
    EFX_LUT4 LUT__1248 (.I0(\i2c_reg16_master_inst/st [4]), .I1(\i2c_reg16_master_inst/SDA_IN_SYNCED ), 
            .I2(\i2c_reg16_master_inst/tick ), .O(\i2c_reg16_master_inst/n753 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8080 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1248.LUTMASK = 16'h8080;
    EFX_LUT4 LUT__1249 (.I0(\i2c_reg16_master_inst/st [4]), .I1(n618), .I2(\i2c_reg16_master_inst/n753 ), 
            .O(ceg_net318)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0b0b */ ;
    defparam LUT__1249.LUTMASK = 16'h0b0b;
    EFX_LUT4 LUT__1250 (.I0(\i2c_reg16_master_inst/st [2]), .I1(\i2c_reg16_master_inst/st [3]), 
            .I2(n628), .O(n654)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1250.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1251 (.I0(n654), .I1(n610), .I2(\i2c_reg16_master_inst/st [1]), 
            .O(\i2c_reg16_master_inst/n752 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8080 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(356)
    defparam LUT__1251.LUTMASK = 16'h8080;
    EFX_LUT4 LUT__1252 (.I0(wr_len[1]), .I1(wr_len[0]), .I2(\i2c_reg16_master_inst/rw_read ), 
            .O(n655)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0e0e */ ;
    defparam LUT__1252.LUTMASK = 16'h0e0e;
    EFX_LUT4 LUT__1253 (.I0(\i2c_reg16_master_inst/byte_idx [1]), .I1(\i2c_reg16_master_inst/byte_idx [2]), 
            .O(n656)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1111 */ ;
    defparam LUT__1253.LUTMASK = 16'h1111;
    EFX_LUT4 LUT__1254 (.I0(\i2c_reg16_master_inst/byte_idx [0]), .I1(reg_16bit), 
            .I2(n655), .I3(n656), .O(n657)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h75f0 */ ;
    defparam LUT__1254.LUTMASK = 16'h75f0;
    EFX_LUT4 LUT__1255 (.I0(wr_len[0]), .I1(\i2c_reg16_master_inst/wpos [0]), 
            .I2(\i2c_reg16_master_inst/wpos [1]), .I3(wr_len[1]), .O(n658)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h2c00 */ ;
    defparam LUT__1255.LUTMASK = 16'h2c00;
    EFX_LUT4 LUT__1256 (.I0(\i2c_reg16_master_inst/byte_idx [0]), .I1(\i2c_reg16_master_inst/byte_idx [1]), 
            .I2(\i2c_reg16_master_inst/byte_idx [2]), .O(n659)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0101 */ ;
    defparam LUT__1256.LUTMASK = 16'h0101;
    EFX_LUT4 LUT__1257 (.I0(n658), .I1(wr_data[0]), .I2(reg_addr16[0]), 
            .I3(n659), .O(n660)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0fbb */ ;
    defparam LUT__1257.LUTMASK = 16'h0fbb;
    EFX_LUT4 LUT__1258 (.I0(n657), .I1(n660), .O(n661)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__1258.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1259 (.I0(n656), .I1(n655), .O(n662)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1111 */ ;
    defparam LUT__1259.LUTMASK = 16'h1111;
    EFX_LUT4 LUT__1260 (.I0(n657), .I1(reg_addr16[8]), .I2(\i2c_reg16_master_inst/tx_byte [0]), 
            .I3(n662), .O(n663)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf0ee */ ;
    defparam LUT__1260.LUTMASK = 16'hf0ee;
    EFX_LUT4 LUT__1261 (.I0(n661), .I1(n663), .I2(\i2c_reg16_master_inst/st [2]), 
            .I3(\i2c_reg16_master_inst/st [3]), .O(\i2c_reg16_master_inst/n1946 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hff40 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1261.LUTMASK = 16'hff40;
    EFX_LUT4 LUT__1262 (.I0(\i2c_reg16_master_inst/st [3]), .I1(\i2c_reg16_master_inst/st [1]), 
            .O(n664)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h9999 */ ;
    defparam LUT__1262.LUTMASK = 16'h9999;
    EFX_LUT4 LUT__1263 (.I0(n616), .I1(n632), .O(n665)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__1263.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1264 (.I0(n664), .I1(n665), .I2(n618), .I3(\i2c_reg16_master_inst/n677 ), 
            .O(ceg_net473)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0bbb */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(85)
    defparam LUT__1264.LUTMASK = 16'h0bbb;
    EFX_LUT4 LUT__1265 (.I0(\i2c_reg16_master_inst/tx_byte [0]), .I1(\i2c_reg16_master_inst/tx_byte [2]), 
            .I2(\i2c_reg16_master_inst/bit_idx[0] ), .I3(\i2c_reg16_master_inst/bit_idx[1] ), 
            .O(n666)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h503f */ ;
    defparam LUT__1265.LUTMASK = 16'h503f;
    EFX_LUT4 LUT__1266 (.I0(\i2c_reg16_master_inst/tx_byte [1]), .I1(\i2c_reg16_master_inst/tx_byte [3]), 
            .I2(\i2c_reg16_master_inst/bit_idx[0] ), .I3(n666), .O(n667)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf305 */ ;
    defparam LUT__1266.LUTMASK = 16'hf305;
    EFX_LUT4 LUT__1267 (.I0(\i2c_reg16_master_inst/tx_byte [7]), .I1(\i2c_reg16_master_inst/tx_byte [5]), 
            .I2(\i2c_reg16_master_inst/bit_idx[0] ), .I3(\i2c_reg16_master_inst/bit_idx[1] ), 
            .O(n668)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf305 */ ;
    defparam LUT__1267.LUTMASK = 16'hf305;
    EFX_LUT4 LUT__1268 (.I0(\i2c_reg16_master_inst/tx_byte [6]), .I1(\i2c_reg16_master_inst/bit_idx[0] ), 
            .I2(n668), .I3(\i2c_reg16_master_inst/bit_idx[2] ), .O(n669)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h000b */ ;
    defparam LUT__1268.LUTMASK = 16'h000b;
    EFX_LUT4 LUT__1269 (.I0(n667), .I1(\i2c_reg16_master_inst/bit_idx[2] ), 
            .I2(n669), .I3(\i2c_reg16_master_inst/st [0]), .O(n670)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf400 */ ;
    defparam LUT__1269.LUTMASK = 16'hf400;
    EFX_LUT4 LUT__1270 (.I0(\i2c_reg16_master_inst/tick ), .I1(\i2c_reg16_master_inst/SCL_IN_SYNCED ), 
            .I2(\i2c_reg16_master_inst/st [0]), .I3(I2C_SDA_OE), .O(n671)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0007 */ ;
    defparam LUT__1270.LUTMASK = 16'h0007;
    EFX_LUT4 LUT__1271 (.I0(n671), .I1(\i2c_reg16_master_inst/st [3]), .I2(\i2c_reg16_master_inst/st [2]), 
            .I3(\i2c_reg16_master_inst/st [1]), .O(n672)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0100 */ ;
    defparam LUT__1271.LUTMASK = 16'h0100;
    EFX_LUT4 LUT__1272 (.I0(\i2c_reg16_master_inst/tick ), .I1(I2C_SDA_OE), 
            .I2(n628), .I3(\i2c_reg16_master_inst/st [1]), .O(n673)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbbf0 */ ;
    defparam LUT__1272.LUTMASK = 16'hbbf0;
    EFX_LUT4 LUT__1273 (.I0(\i2c_reg16_master_inst/SCL_IN_SYNCED ), .I1(\i2c_reg16_master_inst/st [0]), 
            .I2(\i2c_reg16_master_inst/st [1]), .I3(\i2c_reg16_master_inst/tick ), 
            .O(n674)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h3e00 */ ;
    defparam LUT__1273.LUTMASK = 16'h3e00;
    EFX_LUT4 LUT__1274 (.I0(I2C_SDA_OE), .I1(n614), .I2(n674), .I3(\i2c_reg16_master_inst/st [2]), 
            .O(n675)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0d00 */ ;
    defparam LUT__1274.LUTMASK = 16'h0d00;
    EFX_LUT4 LUT__1275 (.I0(\i2c_reg16_master_inst/st [2]), .I1(n673), .I2(n675), 
            .I3(\i2c_reg16_master_inst/st [3]), .O(n676)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0b00 */ ;
    defparam LUT__1275.LUTMASK = 16'h0b00;
    EFX_LUT4 LUT__1276 (.I0(\i2c_reg16_master_inst/st [1]), .I1(\i2c_reg16_master_inst/st [0]), 
            .I2(\i2c_reg16_master_inst/tick ), .I3(\i2c_reg16_master_inst/st [2]), 
            .O(n677)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf0bb */ ;
    defparam LUT__1276.LUTMASK = 16'hf0bb;
    EFX_LUT4 LUT__1277 (.I0(\i2c_reg16_master_inst/tick ), .I1(I2C_SDA_OE), 
            .I2(n677), .I3(\i2c_reg16_master_inst/st [3]), .O(n678)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h000e */ ;
    defparam LUT__1277.LUTMASK = 16'h000e;
    EFX_LUT4 LUT__1278 (.I0(n672), .I1(n670), .I2(n676), .I3(n678), 
            .O(\i2c_reg16_master_inst/n1117 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hfff2 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1278.LUTMASK = 16'hfff2;
    EFX_LUT4 LUT__1279 (.I0(\i2c_reg16_master_inst/st [2]), .I1(\i2c_reg16_master_inst/tick ), 
            .I2(\i2c_reg16_master_inst/st [0]), .O(n679)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__1279.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1280 (.I0(\i2c_reg16_master_inst/st [0]), .I1(\i2c_reg16_master_inst/st [3]), 
            .I2(\i2c_reg16_master_inst/st [2]), .O(n680)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1414 */ ;
    defparam LUT__1280.LUTMASK = 16'h1414;
    EFX_LUT4 LUT__1281 (.I0(n679), .I1(n664), .I2(n680), .I3(\i2c_reg16_master_inst/st [4]), 
            .O(ceg_net597)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hfff2 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(85)
    defparam LUT__1281.LUTMASK = 16'hfff2;
    EFX_LUT4 LUT__1282 (.I0(n664), .I1(n615), .I2(n680), .O(n681)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0d0d */ ;
    defparam LUT__1282.LUTMASK = 16'h0d0d;
    EFX_LUT4 LUT__1283 (.I0(\i2c_reg16_master_inst/SCL_IN_SYNCED ), .I1(\i2c_reg16_master_inst/st [0]), 
            .I2(\i2c_reg16_master_inst/tick ), .I3(I2C_SCL_OE), .O(n682)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h001f */ ;
    defparam LUT__1283.LUTMASK = 16'h001f;
    EFX_LUT4 LUT__1284 (.I0(\i2c_reg16_master_inst/tick ), .I1(n681), .I2(n682), 
            .I3(n618), .O(\i2c_reg16_master_inst/n1132 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h000d */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1284.LUTMASK = 16'h000d;
    EFX_LUT4 LUT__1285 (.I0(\i2c_reg16_master_inst/st [2]), .I1(n621), .I2(\i2c_reg16_master_inst/st [3]), 
            .I3(\i2c_reg16_master_inst/st [4]), .O(ceg_net177)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hff80 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(85)
    defparam LUT__1285.LUTMASK = 16'hff80;
    EFX_LUT4 LUT__1286 (.I0(n625), .I1(\i2c_reg16_master_inst/wpos [0]), 
            .I2(\i2c_reg16_master_inst/st [2]), .O(\i2c_reg16_master_inst/n1927 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(272)
    defparam LUT__1286.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1287 (.I0(n624), .I1(n655), .O(n683)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;
    defparam LUT__1287.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__1288 (.I0(n530), .I1(\i2c_reg16_master_inst/st [2]), .I2(n609), 
            .O(n684)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__1288.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1289 (.I0(\i2c_reg16_master_inst/st [4]), .I1(\i2c_reg16_master_inst/st [3]), 
            .I2(rst_n), .O(n685)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__1289.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1290 (.I0(n683), .I1(n649), .I2(n684), .I3(n685), 
            .O(ceg_net334)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h07ff */ ;
    defparam LUT__1290.LUTMASK = 16'h07ff;
    EFX_LUT4 LUT__1291 (.I0(n618), .I1(\i2c_reg16_master_inst/n677 ), .I2(rst_n), 
            .O(ceg_net179)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7f7f */ ;
    defparam LUT__1291.LUTMASK = 16'h7f7f;
    EFX_LUT4 LUT__1292 (.I0(\i2c_reg16_master_inst/rpos [0]), .I1(\i2c_reg16_master_inst/st [3]), 
            .O(\i2c_reg16_master_inst/n1936 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1292.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__1293 (.I0(n628), .I1(n614), .I2(\i2c_reg16_master_inst/st [3]), 
            .O(n686)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1293.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1294 (.I0(n530), .I1(\i2c_reg16_master_inst/st [3]), .I2(n686), 
            .I3(\i2c_reg16_master_inst/st [1]), .O(n687)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0fee */ ;
    defparam LUT__1294.LUTMASK = 16'h0fee;
    EFX_LUT4 LUT__1295 (.I0(n687), .I1(\i2c_reg16_master_inst/st [2]), .I2(n616), 
            .I3(rst_n), .O(ceg_net335)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hefff */ ;
    defparam LUT__1295.LUTMASK = 16'hefff;
    EFX_LUT4 LUT__1296 (.I0(\i2c_reg16_master_inst/st [1]), .I1(\i2c_reg16_master_inst/st [3]), 
            .I2(\i2c_reg16_master_inst/st [2]), .O(n688)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1414 */ ;
    defparam LUT__1296.LUTMASK = 16'h1414;
    EFX_LUT4 LUT__1297 (.I0(n628), .I1(\i2c_reg16_master_inst/st [1]), .I2(\i2c_reg16_master_inst/st [2]), 
            .I3(n610), .O(n689)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hc8fc */ ;
    defparam LUT__1297.LUTMASK = 16'hc8fc;
    EFX_LUT4 LUT__1298 (.I0(n689), .I1(\i2c_reg16_master_inst/st [3]), .O(n690)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__1298.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1299 (.I0(n629), .I1(n688), .I2(n690), .I3(\i2c_reg16_master_inst/bit_idx[0] ), 
            .O(\i2c_reg16_master_inst/n1960 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0733 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1299.LUTMASK = 16'h0733;
    EFX_LUT4 LUT__1300 (.I0(\i2c_reg16_master_inst/st [0]), .I1(n632), .I2(n684), 
            .O(n691)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0b0b */ ;
    defparam LUT__1300.LUTMASK = 16'h0b0b;
    EFX_LUT4 LUT__1301 (.I0(n610), .I1(\i2c_reg16_master_inst/st [2]), .I2(\i2c_reg16_master_inst/st [1]), 
            .O(n692)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0101 */ ;
    defparam LUT__1301.LUTMASK = 16'h0101;
    EFX_LUT4 LUT__1302 (.I0(n692), .I1(n691), .I2(\i2c_reg16_master_inst/st [4]), 
            .I3(\i2c_reg16_master_inst/st [3]), .O(ceg_net600)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hfafc */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(85)
    defparam LUT__1302.LUTMASK = 16'hfafc;
    EFX_LUT4 LUT__1303 (.I0(\i2c_reg16_master_inst/byte_idx [0]), .I1(\i2c_reg16_master_inst/byte_idx [1]), 
            .I2(\i2c_reg16_master_inst/st [2]), .O(\i2c_reg16_master_inst/n1307 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h6060 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1303.LUTMASK = 16'h6060;
    EFX_LUT4 LUT__1304 (.I0(\i2c_reg16_master_inst/byte_idx [0]), .I1(\i2c_reg16_master_inst/byte_idx [1]), 
            .I2(\i2c_reg16_master_inst/byte_idx [2]), .I3(\i2c_reg16_master_inst/st [2]), 
            .O(\i2c_reg16_master_inst/n1314 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7800 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1304.LUTMASK = 16'h7800;
    EFX_LUT4 LUT__1305 (.I0(reg_addr16[9]), .I1(reg_addr16[1]), .I2(\i2c_reg16_master_inst/byte_idx [0]), 
            .O(n693)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hacac */ ;
    defparam LUT__1305.LUTMASK = 16'hacac;
    EFX_LUT4 LUT__1306 (.I0(\i2c_reg16_master_inst/tx_byte [1]), .I1(n693), 
            .I2(n656), .O(n694)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h3535 */ ;
    defparam LUT__1306.LUTMASK = 16'h3535;
    EFX_LUT4 LUT__1307 (.I0(n683), .I1(n694), .I2(n615), .O(\i2c_reg16_master_inst/n1346 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(273)
    defparam LUT__1307.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1308 (.I0(\i2c_reg16_master_inst/byte_idx [0]), .I1(reg_addr16[2]), 
            .I2(\i2c_reg16_master_inst/tx_byte [2]), .I3(n656), .O(n695)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbb0f */ ;
    defparam LUT__1308.LUTMASK = 16'hbb0f;
    EFX_LUT4 LUT__1309 (.I0(n658), .I1(wr_data[2]), .I2(n695), .I3(n683), 
            .O(n696)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbbf0 */ ;
    defparam LUT__1309.LUTMASK = 16'hbbf0;
    EFX_LUT4 LUT__1310 (.I0(n696), .I1(n615), .O(\i2c_reg16_master_inst/n1356 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1310.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__1311 (.I0(\i2c_reg16_master_inst/byte_idx [0]), .I1(reg_addr16[3]), 
            .I2(\i2c_reg16_master_inst/tx_byte [3]), .I3(n656), .O(n697)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbb0f */ ;
    defparam LUT__1311.LUTMASK = 16'hbb0f;
    EFX_LUT4 LUT__1312 (.I0(n683), .I1(n697), .I2(n615), .O(\i2c_reg16_master_inst/n1366 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(273)
    defparam LUT__1312.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__1313 (.I0(\i2c_reg16_master_inst/tx_byte [5]), .I1(n656), 
            .I2(n615), .O(n698)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hd0d0 */ ;
    defparam LUT__1313.LUTMASK = 16'hd0d0;
    EFX_LUT4 LUT__1314 (.I0(wr_data[5]), .I1(n658), .I2(n683), .I3(n615), 
            .O(n699)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hd000 */ ;
    defparam LUT__1314.LUTMASK = 16'hd000;
    EFX_LUT4 LUT__1315 (.I0(reg_addr16[3]), .I1(n659), .I2(slave_addr7[4]), 
            .I3(n615), .O(n700)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbbf0 */ ;
    defparam LUT__1315.LUTMASK = 16'hbbf0;
    EFX_LUT4 LUT__1316 (.I0(n698), .I1(n657), .I2(n699), .I3(n700), 
            .O(\i2c_reg16_master_inst/n1386 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0d00 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1316.LUTMASK = 16'h0d00;
    EFX_LUT4 LUT__1317 (.I0(\i2c_reg16_master_inst/tx_byte [6]), .I1(n656), 
            .I2(n615), .O(n701)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hd0d0 */ ;
    defparam LUT__1317.LUTMASK = 16'hd0d0;
    EFX_LUT4 LUT__1319 (.I0(reg_addr16[3]), .I1(n659), .I2(slave_addr7[5]), 
            .I3(n615), .O(n703)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbbf0 */ ;
    defparam LUT__1319.LUTMASK = 16'hbbf0;
    EFX_LUT4 LUT__1012 (.I0(\control_camera_i2c_inst/st[1] ), .I1(\control_camera_i2c_inst/i2c_done_delayed ), 
            .I2(\control_camera_i2c_inst/st[0] ), .O(n485)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__1012.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__1320 (.I0(n701), .I1(n657), .I2(n699), .I3(n703), 
            .O(\i2c_reg16_master_inst/n1396 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0d00 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1320.LUTMASK = 16'h0d00;
    EFX_LUT4 LUT__1321 (.I0(n662), .I1(\i2c_reg16_master_inst/tx_byte [7]), 
            .I2(slave_addr7[5]), .I3(n615), .O(\i2c_reg16_master_inst/n1406 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h88f0 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1321.LUTMASK = 16'h88f0;
    EFX_LUT4 LUT__1322 (.I0(n658), .I1(\i2c_reg16_master_inst/st [2]), .O(\i2c_reg16_master_inst/n1327 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(272)
    defparam LUT__1322.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__1323 (.I0(\i2c_reg16_master_inst/rpos [0]), .I1(\i2c_reg16_master_inst/rpos [1]), 
            .I2(\i2c_reg16_master_inst/st [3]), .O(\i2c_reg16_master_inst/n1336 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h6060 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1323.LUTMASK = 16'h6060;
    EFX_LUT4 LUT__1324 (.I0(\i2c_reg16_master_inst/bit_idx[2] ), .I1(\i2c_reg16_master_inst/bit_idx[0] ), 
            .I2(\i2c_reg16_master_inst/bit_idx[1] ), .I3(n688), .O(n704)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hbc00 */ ;
    defparam LUT__1324.LUTMASK = 16'hbc00;
    EFX_LUT4 LUT__1325 (.I0(\i2c_reg16_master_inst/bit_idx[1] ), .I1(n690), 
            .I2(n704), .O(\i2c_reg16_master_inst/n1420 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0707 */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1325.LUTMASK = 16'h0707;
    EFX_LUT4 LUT__1326 (.I0(\i2c_reg16_master_inst/st [1]), .I1(n628), .I2(\i2c_reg16_master_inst/st [2]), 
            .I3(n610), .O(n705)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h5300 */ ;
    defparam LUT__1326.LUTMASK = 16'h5300;
    EFX_LUT4 LUT__1327 (.I0(\i2c_reg16_master_inst/bit_idx[0] ), .I1(\i2c_reg16_master_inst/bit_idx[1] ), 
            .I2(\i2c_reg16_master_inst/bit_idx[2] ), .I3(n688), .O(n706)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hf800 */ ;
    defparam LUT__1327.LUTMASK = 16'hf800;
    EFX_LUT4 LUT__1328 (.I0(n705), .I1(\i2c_reg16_master_inst/st [3]), .I2(\i2c_reg16_master_inst/bit_idx[2] ), 
            .I3(n706), .O(\i2c_reg16_master_inst/n1434 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h00bf */ ;   // /home/olle/efinity_p2/BRAM/i2c_reg16_master.vhd(390)
    defparam LUT__1328.LUTMASK = 16'h00bf;
    EFX_GBUFCE CLKBUF__0 (.CE(1'b1), .I(pll_clk), .O(\pll_clk~O )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_GBUFCE, CE_POLARITY=1'b1 */ ;
    defparam CLKBUF__0.CE_POLARITY = 1'b1;
    
endmodule

//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_0
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_fc9fcb20_0
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_fc9fcb20_1
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_fc9fcb20_2
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_fc9fcb20_3
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_fc9fcb20_4
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_fc9fcb20_5
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_fc9fcb20_6
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_fc9fcb20_7
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_fc9fcb20_8
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_ADD_fc9fcb20_0
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_1
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_2
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_3
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_4
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_5
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_6
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_7
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_8
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_9
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_10
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_11
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_12
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_13
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_14
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_15
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_16
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_17
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_18
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_19
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_20
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_21
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_22
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_23
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_24
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_25
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_26
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_27
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_28
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_29
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_30
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_31
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_32
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_33
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_34
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_35
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_36
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_37
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_38
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_39
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_40
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_41
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_42
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_43
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_44
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_45
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_46
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_47
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_48
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_49
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_50
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_51
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_52
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_53
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_54
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_55
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_56
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_57
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_58
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_59
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_60
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_61
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_62
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_63
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_64
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_65
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_66
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_67
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_68
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_69
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_70
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_71
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_72
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_73
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_74
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_75
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_76
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_77
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_78
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_79
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_80
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_81
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_82
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_83
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_84
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_85
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_86
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_87
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_88
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_89
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_90
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_91
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_92
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_93
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_94
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_95
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_96
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_97
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_98
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_99
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_100
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_101
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_102
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_103
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_104
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_105
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_106
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_107
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_108
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_109
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_110
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_111
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_112
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_113
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_114
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_115
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_116
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_117
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_118
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_119
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_120
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_121
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_122
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_123
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_124
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_125
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_126
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_127
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_128
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_129
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_130
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_131
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_fc9fcb20_132
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_GBUFCE_fc9fcb20_0
// module not written out since it is a black box. 
//

