library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity test_cnt is
  port (
    clk : in  std_logic;   -- 50Mhz external clock oscillator from ETH PHY
    pll_clk : in  std_logic; --128MHz PLL clock
    cnt : out STD_LOGIC_VECTOR(26 downto 0)
    
  );

end test_cnt;

architecture behavior of test_cnt is
    signal s_cnt : unsigned(26 downto 0) := (others => '0'); 
begin
      process(pll_clk)
  begin
    if rising_edge(pll_clk) then
        s_cnt <= s_cnt + 1;
    end if;
    cnt <= STD_LOGIC_VECTOR(s_cnt);
end process;
end behavior;
