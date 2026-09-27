# =============================================================================
# Timing Constraints for T120F324_A — Multi-Clock Domain Architecture
# =============================================================================

# -----------------------------------------------------------------------------
# Primary system clock: 50 MHz from external oscillator
# Driving: RISC_mini SoC, uart_mini, MDIO master, Ethernet bridge
# -----------------------------------------------------------------------------
create_clock -name T120_GCLK -period 20.0 [get_ports {T120_GCLK}]

# -----------------------------------------------------------------------------
# MIPI PLL clock: 60 MHz from Efinix internal PLL
# Driving: MIPI RX IP fabric interface, record_video (frame capture)
# Period = 16.667 ns for 60 MHz
# Available from T120F324_A.peri.xml EfxSapphireSoc pll_clk_60Mhz output
# -----------------------------------------------------------------------------
# pll_clk_50Mhz
create_clock -name pll_clk_50Mhz -period 20.0 [get_ports {pll_clk_50Mhz}]
create_clock -name pll_clk_60Mhz -period 16.667 [get_ports {pll_clk_60Mhz}]
create_clock -name pll_clk_75Mhz -period 13.333 [get_ports {pll_clk_75Mhz}]
create_clock -name pll_clk_80Mhz -period 12.5 [get_ports {pll_clk_80Mhz}]
create_clock -name pll_clk_100Mhz -period 10.0 [get_ports {pll_clk_100Mhz}]

# -----------------------------------------------------------------------------
# PHY RX clock: declared for timing analysis even though we treat it as data
# F2_RXC frequency varies: 2.5 MHz (10M), 25 MHz (100M), 125 MHz (1G)
# Use worst case = 125 MHz = 8 ns period
# Driven by PHY in RGMII mode, in independent clock domain
# -----------------------------------------------------------------------------
create_clock -name F2_RXC -period 8.0 [get_ports {F2_RXC}]

# =============================================================================
# Asynchronous clock groups:
#  - T120_GCLK (50 MHz): external system oscillator
#  - pll_clk_50Mhz (50 MHz): internal Efinix PLL (MIPI frame capture)
#  - pll_clk_60Mhz (60 MHz): internal Efinix PLL (MIPI frame capture)
#  - pll_clk_75Mhz (75 MHz): internal Efinix PLL (MIPI frame capture)
#  - pll_clk_80Mhz (80 MHz): internal Efinix PLL (MIPI frame capture)
#  - pll_clk_100Mhz (100 MHz): internal Efinix PLL (MIPI frame capture)
#  - F2_RXC (125 MHz worst case): PHY RGMII RX clock
# All are independent oscillators with no phase relationship.
# CDC synchronizers in RTL (always_ff with reset or Gray-code FIFOs) handle
# clock domain crossings. Tell timing tool to NOT check paths between domains.
# =============================================================================
set_clock_groups -asynchronous \
    -group [get_clocks {T120_GCLK}] \
    -group [get_clocks {pll_clk_50Mhz}] \
    -group [get_clocks {pll_clk_60Mhz}] \
    -group [get_clocks {pll_clk_75Mhz}] \
    -group [get_clocks {pll_clk_80Mhz}] \
    -group [get_clocks {pll_clk_100Mhz}] \
    -group [get_clocks {F2_RXC}]

# -----------------------------------------------------------------------------
# False paths on 2-FF synchronizer inputs (async PHY signals → sys_clk domain)
# These signals go through 2-stage synchronizers in top_level.sv and
# mdio_master.sv — setup/hold timing is meaningless for metastability FFs.
# -----------------------------------------------------------------------------
set_false_path -from [get_ports {F2_MDIO_IN}]
set_false_path -from [get_ports {F2_RXCTL}]
set_false_path -from [get_ports {F2_RXD0}]
set_false_path -from [get_ports {F2_RXD1}]
set_false_path -from [get_ports {F2_RXD2}]
set_false_path -from [get_ports {F2_RXD3}]
set_false_path -from [get_ports {F2_INTB}]
