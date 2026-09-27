#32Mhz external clk
create_clock -name clk -period 30.0 [get_nets {clk}] 
#100Mhz internal pll_clk
create_clock -name pll_clk -period 10.0 [get_nets {pll_clk}]