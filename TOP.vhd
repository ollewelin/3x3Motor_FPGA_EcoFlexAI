library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_test is
  port (
    T120_GCLK : in  std_logic;
    CAM3_SCL             : out std_logic
  );
end clk_test;

architecture rtl of clk_test is
  signal div     : unsigned(24 downto 0) := (others => '1');  -- räknarsignal
begin
  -- Räknar-process på den buffrade klockan
  --process(clk_buf)
  process(T120_GCLK)
  begin
    --if rising_edge(clk_buf) then
    if rising_edge(T120_GCLK) then
      div <= div + 1;
    end if;
  end process;
  CAM3_SCL <= div(23);
end rtl;