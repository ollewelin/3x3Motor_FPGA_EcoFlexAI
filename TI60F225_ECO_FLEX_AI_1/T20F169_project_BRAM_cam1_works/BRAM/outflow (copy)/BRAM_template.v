
// Efinity Top-level template
// Version: 2025.1.110.2.15
// Date: 2025-09-07 19:06

// Copyright (C) 2013 - 2025 Efinix Inc. All rights reserved.

// This file may be used as a starting point for Efinity synthesis top-level target.
// The port list here matches what is expected by Efinity constraint files generated
// by the Efinity Interface Designer.

// To use this:
//     #1)  Save this file with a different name to a different directory, where source files are kept.
//              Example: you may wish to save as BRAM.v
//     #2)  Add the newly saved file into Efinity project as design file
//     #3)  Edit the top level entity in Efinity project to:  BRAM
//     #4)  Insert design content.


module BRAM
(
  (* syn_peri_port = 0 *) input mdio_i,
  (* syn_peri_port = 0 *) input rmii_crs_dv,
  (* syn_peri_port = 0 *) input [1:0] rmii_rxd,
  (* syn_peri_port = 0 *) input pll_clk_lock,
  (* syn_peri_port = 0 *) input IO12_manual_reset_n,
  (* syn_peri_port = 0 *) input led4,
  (* syn_peri_port = 0 *) input phy_intr_n,
  (* syn_peri_port = 0 *) input rmii_rx_er,
  (* syn_peri_port = 0 *) input I2C_SCL_IN,
  (* syn_peri_port = 0 *) input I2C_SDA_IN,
  (* syn_peri_port = 0 *) input [3:0] mipi_rx_inst1_CNT,
  (* syn_peri_port = 0 *) input [63:0] mipi_rx_inst1_DATA,
  (* syn_peri_port = 0 *) input [3:0] mipi_rx_inst1_HSYNC,
  (* syn_peri_port = 0 *) input [5:0] mipi_rx_inst1_TYPE,
  (* syn_peri_port = 0 *) input mipi_rx_inst1_VALID,
  (* syn_peri_port = 0 *) input [1:0] mipi_rx_inst1_VC,
  (* syn_peri_port = 0 *) input [3:0] mipi_rx_inst1_VSYNC,
  (* syn_peri_port = 0 *) input [3:0] mipi_rx_inst2_CNT,
  (* syn_peri_port = 0 *) input [63:0] mipi_rx_inst2_DATA,
  (* syn_peri_port = 0 *) input [3:0] mipi_rx_inst2_HSYNC,
  (* syn_peri_port = 0 *) input [5:0] mipi_rx_inst2_TYPE,
  (* syn_peri_port = 0 *) input mipi_rx_inst2_VALID,
  (* syn_peri_port = 0 *) input [1:0] mipi_rx_inst2_VC,
  (* syn_peri_port = 0 *) input [3:0] mipi_rx_inst2_VSYNC,
  (* syn_peri_port = 0 *) input pll_clk,
  (* syn_peri_port = 0 *) input clk,
  (* syn_peri_port = 0 *) input jtag_inst1_CAPTURE,
  (* syn_peri_port = 0 *) input jtag_inst1_DRCK,
  (* syn_peri_port = 0 *) input jtag_inst1_RESET,
  (* syn_peri_port = 0 *) input jtag_inst1_RUNTEST,
  (* syn_peri_port = 0 *) input jtag_inst1_SEL,
  (* syn_peri_port = 0 *) input jtag_inst1_SHIFT,
  (* syn_peri_port = 0 *) input jtag_inst1_TCK,
  (* syn_peri_port = 0 *) input jtag_inst1_TDI,
  (* syn_peri_port = 0 *) input jtag_inst1_TMS,
  (* syn_peri_port = 0 *) input jtag_inst1_UPDATE,
  (* syn_peri_port = 0 *) output CAM0_EN,
  (* syn_peri_port = 0 *) output CAM1_EN,
  (* syn_peri_port = 0 *) output mdc,
  (* syn_peri_port = 0 *) output mdio_o,
  (* syn_peri_port = 0 *) output mdio_oe,
  (* syn_peri_port = 0 *) output rmii_tx_en,
  (* syn_peri_port = 0 *) output [1:0] rmii_txd,
  (* syn_peri_port = 0 *) output RJ45_led,
  (* syn_peri_port = 0 *) output led2,
  (* syn_peri_port = 0 *) output led4_OUT,
  (* syn_peri_port = 0 *) output led4_OE,
  (* syn_peri_port = 0 *) output phy_rst_n,
  (* syn_peri_port = 0 *) output FPGA_IO0_A0,
  (* syn_peri_port = 0 *) output FPGA_IO0_A1,
  (* syn_peri_port = 0 *) output FPGA_IO0_A2,
  (* syn_peri_port = 0 *) output I2C_SCL_OUT,
  (* syn_peri_port = 0 *) output I2C_SCL_OE,
  (* syn_peri_port = 0 *) output I2C_SDA_OUT,
  (* syn_peri_port = 0 *) output I2C_SDA_OE,
  (* syn_peri_port = 0 *) output mipi_rx_inst1_DPHY_RSTN,
  (* syn_peri_port = 0 *) output [1:0] mipi_rx_inst1_LANES,
  (* syn_peri_port = 0 *) output mipi_rx_inst1_RSTN,
  (* syn_peri_port = 0 *) output [3:0] mipi_rx_inst1_VC_ENA,
  (* syn_peri_port = 0 *) output mipi_rx_inst2_DPHY_RSTN,
  (* syn_peri_port = 0 *) output [1:0] mipi_rx_inst2_LANES,
  (* syn_peri_port = 0 *) output mipi_rx_inst2_RSTN,
  (* syn_peri_port = 0 *) output [3:0] mipi_rx_inst2_VC_ENA,
  (* syn_peri_port = 0 *) output jtag_inst1_TDO
);


endmodule

