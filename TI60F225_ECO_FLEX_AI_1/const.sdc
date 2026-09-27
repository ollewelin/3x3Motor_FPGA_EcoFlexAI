# Timing constraints for TI60F225_ECO_FLEX_AI_1
#
# NOTE: PLL clocks (PLL_100MHZ, PLL_125MHZ, PLL_125_TXC, PLL_25MHZ) are
# auto-constrained by Efinity via the generated .pt.sdc from the .peri.xml.
# Do NOT redefine them here — it causes "No nets matched" warnings.

# External 50 MHz oscillator (not auto-constrained — define it here)
create_clock -name clk -period 20.0 [get_ports {clk}]

# RGMII RX clock from PHY (125 MHz)
create_clock -name ETH2_RXC -period 8.0 [get_ports {ETH2_RXC}]
#PLL_125MHZ
create_clock -name PLL_125MHZ -period 8.0 [get_ports {PLL_125MHZ}]
create_clock -name PLL_100MHZ -period 10.0 [get_ports {PLL_100MHZ}]
# --- RGMII pipeline timing (commented out — get_registers is not valid Efinix SDC) ---
# These used Intel/Altera SDC syntax.  Efinity timing engine does not support
# get_registers.  If cross-clock-domain timing needs tightening, use
# set_max_delay with get_ports / get_pins or constrain via clock relationships.
#
# set_max_delay -from {*current_payload_byte_B[*]} -to {*txd_hi[*]} 4.0
# set_max_delay -from {*current_payload_byte_B[*]} -to {*txd_lo[*]} 4.0
# set_max_delay -from {*is_sending_reg_B} -to {*txctl_hi} 4.0
# set_max_delay -from {*is_sending_reg_B} -to {*txctl_lo} 4.0

