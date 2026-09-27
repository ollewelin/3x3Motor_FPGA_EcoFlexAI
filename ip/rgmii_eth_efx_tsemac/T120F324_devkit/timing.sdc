################################## Clock Constraints ##########################
create_clock -period 20.00 clk
create_clock -period 8.00 clk_125m
create_clock -waveform {2.00 6.00} -period 8.00 clk_125m_90deg
create_clock -period 8.00 rgmii_rxc
create_clock -period 100.00 [get_ports {jtag_inst1_TCK}]

####################################################################################################################################
# Timing Mode Constrains
####################################################################################################################################
set_clock_groups -exclusive -group {clk} -group {clk_125m} -group {clk_125m_90deg} -group {rgmii_rxc} -group {jtag_inst1_TCK}

# GPIO Constraints
####################
set_input_delay -clock rgmii_rxc -max 6.168 [get_ports {rgmii_rxd_LO[0] rgmii_rxd_HI[0]}]
set_input_delay -clock rgmii_rxc -min 3.084 [get_ports {rgmii_rxd_LO[0] rgmii_rxd_HI[0]}]
set_input_delay -clock rgmii_rxc -max 6.168 [get_ports {rgmii_rxd_LO[1] rgmii_rxd_HI[1]}]
set_input_delay -clock rgmii_rxc -min 3.084 [get_ports {rgmii_rxd_LO[1] rgmii_rxd_HI[1]}]
set_input_delay -clock rgmii_rxc -max 6.168 [get_ports {rgmii_rxd_LO[2] rgmii_rxd_HI[2]}]
set_input_delay -clock rgmii_rxc -min 3.084 [get_ports {rgmii_rxd_LO[2] rgmii_rxd_HI[2]}]
set_input_delay -clock rgmii_rxc -max 6.168 [get_ports {rgmii_rxd_LO[3] rgmii_rxd_HI[3]}]
set_input_delay -clock rgmii_rxc -min 3.084 [get_ports {rgmii_rxd_LO[3] rgmii_rxd_HI[3]}]
set_output_delay -clock_fall -clock clk_125m_90deg -max -4.700 [get_ports {rgmii_txc_LO rgmii_txc_HI}]
set_output_delay -clock_fall -clock clk_125m_90deg -min -2.571 [get_ports {rgmii_txc_LO rgmii_txc_HI}]
set_output_delay -clock clk_125m -max -4.700 [get_ports {rgmii_txd_LO[0] rgmii_txd_HI[0]}]
set_output_delay -clock clk_125m -min -2.571 [get_ports {rgmii_txd_LO[0] rgmii_txd_HI[0]}]
set_output_delay -clock clk_125m -max -4.700 [get_ports {rgmii_txd_LO[1] rgmii_txd_HI[1]}]
set_output_delay -clock clk_125m -min -2.571 [get_ports {rgmii_txd_LO[1] rgmii_txd_HI[1]}]
set_output_delay -clock clk_125m -max -4.700 [get_ports {rgmii_txd_LO[2] rgmii_txd_HI[2]}]
set_output_delay -clock clk_125m -min -2.571 [get_ports {rgmii_txd_LO[2] rgmii_txd_HI[2]}]
set_output_delay -clock clk_125m -max -4.700 [get_ports {rgmii_txd_LO[3] rgmii_txd_HI[3]}]
set_output_delay -clock clk_125m -min -2.571 [get_ports {rgmii_txd_LO[3] rgmii_txd_HI[3]}]

# LVDS RX GPIO Constraints
############################
set_input_delay -clock rgmii_rxc -max 6.100 [get_ports {rgmii_rx_ctl}]
set_input_delay -clock rgmii_rxc -min 3.050 [get_ports {rgmii_rx_ctl}]
set_output_delay -clock clk_125m -max -5.210 [get_ports {rgmii_tx_ctl}]
set_output_delay -clock clk_125m -min -2.480 [get_ports {rgmii_tx_ctl}]

# LVDS Rx Constraints
####################

# JTAG Constraints
####################
set_output_delay -clock jtag_inst1_TCK -max 0.111 [get_ports {jtag_inst1_TDO}]
set_output_delay -clock jtag_inst1_TCK -min 0.053 [get_ports {jtag_inst1_TDO}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.267 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.134 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.231 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.116 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.321 [get_ports {jtag_inst1_SHIFT}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.161 [get_ports {jtag_inst1_SHIFT}]
