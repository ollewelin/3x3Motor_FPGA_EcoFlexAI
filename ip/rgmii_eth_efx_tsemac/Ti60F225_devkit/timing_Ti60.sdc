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

# JTAG Constraints
####################
# create_clock -period <USER_PERIOD> [get_ports {jtag_inst1_TCK}]
# create_clock -period <USER_PERIOD> [get_ports {jtag_inst1_DRCK}]
set_output_delay -clock jtag_inst1_TCK -max 0.117 [get_ports {jtag_inst1_TDO}]
set_output_delay -clock jtag_inst1_TCK -min -0.075 [get_ports {jtag_inst1_TDO}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.280 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.187 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.243 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.162 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.337 [get_ports {jtag_inst1_SHIFT}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.225 [get_ports {jtag_inst1_SHIFT}]

# HSIO GPIO Constraints
#########################
set_input_delay -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~278}] -max 0.414 [get_ports {rgmii_rx_ctl}]
set_input_delay -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~278}] -min 0.276 [get_ports {rgmii_rx_ctl}]
set_input_delay -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~268}] -max 0.414 [get_ports {rgmii_rxd_LO[0] rgmii_rxd_HI[0]}]
set_input_delay -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~268}] -min 0.276 [get_ports {rgmii_rxd_LO[0] rgmii_rxd_HI[0]}]
set_input_delay -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~267}] -max 0.414 [get_ports {rgmii_rxd_LO[1] rgmii_rxd_HI[1]}]
set_input_delay -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~267}] -min 0.276 [get_ports {rgmii_rxd_LO[1] rgmii_rxd_HI[1]}]
set_input_delay -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~255}] -max 0.414 [get_ports {rgmii_rxd_LO[2] rgmii_rxd_HI[2]}]
set_input_delay -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~255}] -min 0.276 [get_ports {rgmii_rxd_LO[2] rgmii_rxd_HI[2]}]
set_input_delay -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~254}] -max 0.414 [get_ports {rgmii_rxd_LO[3] rgmii_rxd_HI[3]}]
set_input_delay -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~254}] -min 0.276 [get_ports {rgmii_rxd_LO[3] rgmii_rxd_HI[3]}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {sw6}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {sw6}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {phy_mdc}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {phy_mdc}]
set_output_delay -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~210}] -max 0.263 [get_ports {rgmii_tx_ctl}]
set_output_delay -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~210}] -min -0.140 [get_ports {rgmii_tx_ctl}]
set_output_delay -clock_fall -clock clk_125m_90deg -reference_pin [get_ports {clk_125m_90deg~CLKOUT~218~225}] -max 0.263 [get_ports {rgmii_txc_LO rgmii_txc_HI}]
set_output_delay -clock_fall -clock clk_125m_90deg -reference_pin [get_ports {clk_125m_90deg~CLKOUT~218~225}] -min -0.140 [get_ports {rgmii_txc_LO rgmii_txc_HI}]
set_output_delay -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~171}] -max 0.263 [get_ports {rgmii_txd_LO[0] rgmii_txd_HI[0]}]
set_output_delay -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~171}] -min -0.140 [get_ports {rgmii_txd_LO[0] rgmii_txd_HI[0]}]
set_output_delay -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~170}] -max 0.263 [get_ports {rgmii_txd_LO[1] rgmii_txd_HI[1]}]
set_output_delay -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~170}] -min -0.140 [get_ports {rgmii_txd_LO[1] rgmii_txd_HI[1]}]
set_output_delay -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~196}] -max 0.263 [get_ports {rgmii_txd_LO[2] rgmii_txd_HI[2]}]
set_output_delay -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~196}] -min -0.140 [get_ports {rgmii_txd_LO[2] rgmii_txd_HI[2]}]
set_output_delay -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~195}] -max 0.263 [get_ports {rgmii_txd_LO[3] rgmii_txd_HI[3]}]
set_output_delay -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~195}] -min -0.140 [get_ports {rgmii_txd_LO[3] rgmii_txd_HI[3]}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {phy_mdi}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {phy_mdi}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {phy_mdo}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {phy_mdo}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {phy_mdo_en}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {phy_mdo_en}]

# Clockout Interface
######################
# rgmii_rx_ctl -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~278}]
# rgmii_rxd[0] -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~268}]
# rgmii_rxd[1] -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~267}]
# rgmii_rxd[2] -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~255}]
# rgmii_rxd[3] -clock rgmii_rxc -reference_pin [get_ports {rgmii_rxc~CLKOUT~218~254}]
# rgmii_tx_ctl -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~210}]
# rgmii_txc -clock clk_125m_90deg -reference_pin [get_ports {clk_125m_90deg~CLKOUT~218~225}]
# rgmii_txd[0] -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~171}]
# rgmii_txd[1] -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~170}]
# rgmii_txd[2] -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~196}]
# rgmii_txd[3] -clock clk_125m -reference_pin [get_ports {clk_125m~CLKOUT~218~195}]
