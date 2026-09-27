
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
  port (
    clk : in  std_logic;   -- 50Mhz external clock oscillator from ETH PHY
    pll_clk : in  std_logic; --128MHz PLL clock
    led2 : out std_logic;    -- drives LED0
    phy_intr_n : in std_logic; -- ETH INTR/PWRDN
    IO12_manual_reset_n : in std_logic; -- ETH INTR/PWRDN
    phy_rst_n : out std_logic; -- Need to be pulsed by hardware if clk comes from 50Mhz PYH clk output
  -- FPGA could not reset this phy_rst_n if it not have any clk from begining. fornatly it seems like 50Mhz clk work if phy_rst_n is not connected or input
    rmii_tx_en : out std_logic; --
    rmii_crs_dv : in std_logic; --
    rmii_rx_er : in std_logic; --
    rmii_rxd : in std_logic_vector(1 downto 0);
    rmii_txd : out std_logic_vector(1 downto 0);
    mdc : out std_logic;
    mdio_i : in std_logic;
    mdio_o : out std_logic;
    mdio_oe : out std_logic; 
    CAM0_EN : out std_logic; --    
    CAM1_EN : out std_logic; --    
    RJ45_led : out std_logic; --    
    jtag_dummy_TDI : in std_logic; 
    jtag_dummy_TCK : in std_logic; 
    jtag_dummy_TMS : in std_logic;
    jtag_dummy_SEL : in std_logic;
    jtag_dummy_DRCK : in std_logic;
    jtag_dummy_RESET : in std_logic; 
    jtag_dummy_RUNTEST : in std_logic;
    jtag_dummy_CAPTURE : in std_logic;
    jtag_dummy_SHIFT : in std_logic;
    jtag_dummy_UPDATE : in std_logic;
    jtag_dummy_TDO : out std_logic; 
    led4 : in std_logic;
    led4_OUT : out std_logic;
    led4_OE : out std_logic
    
  );

end top_level;



architecture behavior of top_level is


------------- Begin Cut here for COMPONENT Declaration ------
component micro_risc_v1 is
port (
    io_systemClk : in std_logic;
    jtagCtrl_enable : in std_logic;
    jtagCtrl_tdi : in std_logic;
    jtagCtrl_capture : in std_logic;
    jtagCtrl_shift : in std_logic;
    jtagCtrl_update : in std_logic;
    jtagCtrl_reset : in std_logic;
    jtagCtrl_tdo : out std_logic;
    jtagCtrl_tck : in std_logic;
    io_asyncReset : in std_logic;
    io_systemReset : out std_logic;
    system_uart_0_io_txd : out std_logic;
    system_uart_0_io_rxd : in std_logic;
    system_gpio_0_io_writeEnable : out std_logic_vector(0 to 0);
    system_gpio_0_io_write : out std_logic_vector(0 to 0);
    system_gpio_0_io_read : in std_logic_vector(0 to 0)
);
end component micro_risc_v1;

component rmii_tx_udp_min
  port (
    clk : in std_logic;
    rst_n : in std_logic;
    rmii_txd : out std_logic_vector(1 downto 0);
    rmii_tx_en : out std_logic
  );
end component;



------------- Begin Cut here for COMPONENT Declaration ------
  signal div : unsigned(25 downto 0) := (others => '0');  -- ~1 s at 128 MHz test counter
  signal io_asyncReset_sig : std_logic := '1';
  signal rst_n : std_logic := '0';
  signal msb_cnt_o : std_logic := '1';
  signal io_systemReset : std_logic := '0';
  signal system_uart_0_io_txd : std_logic := '0';
  signal system_uart_0_io_rxd : std_logic := '0';
  signal system_gpio_0_io_writeEnable : std_logic_vector(0 to 0);
  signal system_gpio_0_io_write : std_logic_vector(0 to 0);
  signal system_gpio_0_io_read : std_logic_vector(0 to 0);
  signal pre_system_uart_0_io_txd : std_logic := '0';
  signal led4_in : std_logic := '0'; --tri-state
  signal led_link : std_logic := '0';



begin


   
------------- Begin Cut here for INSTANTIATION Template -----

u_micro_risc_v1 : micro_risc_v1
port map (
    io_systemClk => pll_clk,
    jtagCtrl_enable => '1',
    jtagCtrl_tdi => jtag_dummy_TDI,
    jtagCtrl_capture => jtag_dummy_CAPTURE,
    jtagCtrl_shift => jtag_dummy_SHIFT,
    jtagCtrl_update => jtag_dummy_UPDATE,
    jtagCtrl_reset => jtag_dummy_RESET,
    jtagCtrl_tdo => jtag_dummy_TDO,
    jtagCtrl_tck => jtag_dummy_TCK,
    io_asyncReset => io_asyncReset_sig,
    io_systemReset => io_systemReset,
    system_uart_0_io_txd => system_uart_0_io_txd,
    system_uart_0_io_rxd => system_uart_0_io_rxd,
    system_gpio_0_io_writeEnable => system_gpio_0_io_writeEnable,
    system_gpio_0_io_write => system_gpio_0_io_write,
    system_gpio_0_io_read => system_gpio_0_io_read
);

rmii_tx_udp_min_inst : rmii_tx_udp_min
  port map (
    clk => clk,
    rst_n => not io_asyncReset_sig,
    rmii_txd => rmii_txd,
    rmii_tx_en => rmii_tx_en
  );

------------------------ End INSTANTIATION Template ---------
   
   
  process(pll_clk)
  begin
    if rising_edge(pll_clk) then
      div   <= div + 1;
      if div(24) = '1' then 
        io_asyncReset_sig <= '0';
      end if;
        pre_system_uart_0_io_txd <= system_uart_0_io_txd;
      end if;
  end process;
  

    --led2 <= eth_clk_cnt(25);
    led4_OUT <= system_gpio_0_io_write(0);
    led4_OE <= system_gpio_0_io_writeEnable(0);
    led4_in <= led4;
    --RJ45_led <= led_link;
    phy_rst_n <= IO12_manual_reset_n;
    rst_n <= IO12_manual_reset_n and (not io_asyncReset_sig);

end behavior;

