
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
  port (
    clk : in  std_logic;   -- 32 MHz external clock oscillator
    pll_clk : in  std_logic; --128MHz PLL clock
    led2 : out std_logic;    -- drives LED0
    jtag_inst1_TDI : in std_logic; 
    jtag_inst1_TDO : out std_logic; 
    jtag_inst1_TMS : in std_logic; 
    jtag_inst1_TCK : in std_logic; 
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
    io_jtag_tms : in std_logic;
    io_jtag_tdi : in std_logic;
    io_jtag_tdo : out std_logic;
    io_jtag_tck : in std_logic;
    io_asyncReset : in std_logic;
    io_systemReset : out std_logic;
    system_uart_0_io_txd : out std_logic;
    system_uart_0_io_rxd : in std_logic;
    system_gpio_0_io_writeEnable : out std_logic_vector(0 to 0);
    system_gpio_0_io_write : out std_logic_vector(0 to 0);
    system_gpio_0_io_read : in std_logic_vector(0 to 0)
);
end component micro_risc_v1;

------------- Begin Cut here for COMPONENT Declaration ------
component BRAM_8192_bytes is
port (
    re : in std_logic;
    we : in std_logic;
    waddr : in std_logic_vector(12 downto 0);
    wdata_a : in std_logic_vector(7 downto 0);
    rdata_b : out std_logic_vector(7 downto 0);
    raddr : in std_logic_vector(12 downto 0);
    clk : in std_logic
);
end component BRAM_8192_bytes;


  signal div : unsigned(25 downto 0) := (others => '0');  -- ~1 s at 128 MHz test counter
  signal uart_b_cnt : unsigned(25 downto 0) := (others => '0'); 
  signal io_asyncReset_sig : std_logic := '1';
  signal msb_cnt_o : std_logic := '1';
  signal io_systemReset : std_logic := '0';
  signal system_uart_0_io_txd : std_logic := '0';
  signal system_uart_0_io_rxd : std_logic := '0';
  signal system_gpio_0_io_writeEnable : std_logic_vector(0 to 0);
  signal system_gpio_0_io_write : std_logic_vector(0 to 0);
  signal system_gpio_0_io_read : std_logic_vector(0 to 0);
  signal BRAM_8k_re : std_logic := '0';
  signal BRAM_8k_we : std_logic := '0';
  signal BRAM_8k_waddr : std_logic_vector(12 downto 0) := (others => '0');
  signal BRAM_8k_raddr : std_logic_vector(12 downto 0) := (others => '0');
  signal BRAM_8k_wdata_a : std_logic_vector(7 downto 0) := (others => '0');
  signal BRAM_8k_rdata_b : std_logic_vector(7 downto 0);
  signal BRAM_bit0_read : std_logic := '0';
  signal pre_system_uart_0_io_txd : std_logic := '0';
  signal led4_in : std_logic := '0'; --tri-state
  
 
begin

   
   u_BRAM_8192_bytes : BRAM_8192_bytes
port map (
    re => BRAM_8k_re,
    we => BRAM_8k_we,
    waddr => BRAM_8k_waddr,
    wdata_a => BRAM_8k_wdata_a,
    rdata_b => BRAM_8k_rdata_b,
    raddr => BRAM_8k_raddr,
    clk => pll_clk
);
   
------------- Begin Cut here for INSTANTIATION Template -----
u_micro_risc_v1 : micro_risc_v1
port map (
    io_systemClk => pll_clk,
    io_jtag_tms => jtag_inst1_TMS,
    io_jtag_tdi => jtag_inst1_TDI,
    io_jtag_tdo => jtag_inst1_TDO,
    io_jtag_tck => jtag_inst1_TCK,
    io_asyncReset => io_asyncReset_sig,
    io_systemReset => io_systemReset,
    system_uart_0_io_txd => system_uart_0_io_txd,
    system_uart_0_io_rxd => system_uart_0_io_rxd,
    system_gpio_0_io_writeEnable => system_gpio_0_io_writeEnable,
    system_gpio_0_io_write => system_gpio_0_io_write,
    system_gpio_0_io_read => system_gpio_0_io_read
);

------------------------ End INSTANTIATION Template ---------
   
   
  process(pll_clk)
  begin
    if rising_edge(pll_clk) then
    
      if system_uart_0_io_txd /= pre_system_uart_0_io_txd then
        uart_b_cnt <= uart_b_cnt + 1;
      end if;
      div   <= div + 1;
      if div(24) = '1' then 
        io_asyncReset_sig <= '0';
      end if;
        BRAM_8k_raddr <= STD_LOGIC_VECTOR(div(12 downto 0));
        if div(0) = '0' then 
            BRAM_8k_re <= '0';
            BRAM_bit0_read <= BRAM_8k_rdata_b(1);
        else
            BRAM_8k_re <= '1';
          --  BRAM_bit0_read <= BRAM_8k_rdata_b(0);
        end if;
        pre_system_uart_0_io_txd <= system_uart_0_io_txd;
      end if;
  end process;
  

  led2 <= BRAM_bit0_read;
  --led4 <= msb_cnt_o;
  --connect the led4 from system_gpio_0_io_write(0)
  --led4 <= system_gpio_0_io_write(0) ;-- two state
  
--Y <= A when EN = (others => '1') else (others => 'Z');
  --led4 <= system_gpio_0_io_write(0) when system_gpio_0_io_writeEnable(0) = (others => '1')  else (others => 'Z');--tri-state

    led4_OUT <= system_gpio_0_io_write(0);
    led4_OE <= system_gpio_0_io_writeEnable(0);
    led4_in <= led4;
  --led4 <= uart_b_cnt(7);
end behavior;

