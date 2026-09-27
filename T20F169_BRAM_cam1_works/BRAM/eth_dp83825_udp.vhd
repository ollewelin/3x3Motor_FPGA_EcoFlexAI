
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eth_dp83825_udp is
  port (
    clk : in  std_logic;   -- 50Mhz external clock oscillator from ETH PHY
    pll_clk : in  std_logic; --128MHz PLL clock
    phy_intr_n : in std_logic; -- ETH INTR/PWRDN
    rst_n : in std_logic; -- manual reset or pll_clc counted reset pulse combined.
    --phy_rst_n : out std_logic; -- Need to be pulsed by hardware if clk comes from 50Mhz PYH clk output
    -- phy_rst_n for now reseted Only by manual direct manual reset to not lock the 50MHz clk how are the main incomming gclk to the FPGA for the now 
    -- could be changed later when two clk source are avalabel one FPGA clk and antoher separe ETH clk generator to not stuck the FPGA
    rmii_tx_en : out std_logic; --
    rmii_crs_dv : in std_logic; --
    rmii_rx_er : in std_logic; --
    rmii_rxd : in std_logic_vector(1 downto 0);
    rmii_txd : out std_logic_vector(1 downto 0);
    mdc : out std_logic;
    mdio_i : in std_logic;
    mdio_o : out std_logic;
    mdio_oe : out std_logic; 
    RJ45_led : out std_logic
  );

end eth_dp83825_udp;

architecture behavior of eth_dp83825_udp is
  signal led_link : std_logic := '0';

  -- Reset synchronizer (convert rst_n -> rst, active-high, 2FF sync)
  signal rst_sync_0 : std_logic := '1';
  signal rst_sync_1 : std_logic := '1';
  signal rst        : std_logic := '1';

  -- MDIO control interface signals
  signal mdio_start   : std_logic := '0';
  signal mdio_is_read : std_logic := '1';
  signal mdio_phyad   : std_logic_vector(4 downto 0) := (others => '0');  -- PHYAD=0
  signal mdio_reg     : std_logic_vector(4 downto 0) := (others => '0');
  signal mdio_wr_data : std_logic_vector(15 downto 0) := (others => '0');
  signal mdio_rd_data : std_logic_vector(15 downto 0);
  signal mdio_busy    : std_logic;
  signal mdio_done    : std_logic;
  signal phyad_cnt : unsigned(4 downto 0) := (others => '0');
  signal vio_step_debug : std_logic := '0'; 
  signal step_cnt : unsigned(18 downto 0) := (others => '0');

  type state_t is (S_RESET, S_WAIT_RST_FALL, S_START, S_START_LOW, S_WAIT_DONE, S_DONE_INC_ADR, S_VIO_STEP_1_WAIT, S_VIO_STEP_0_WAIT);
  signal state_machine_1           : state_t := S_RESET;

  
  constant CLK_FREQ_HZ : natural := 50_000_000;  -- FPGA clock (Hz)
  constant MDC_FREQ_HZ : natural := 2_500_000;   -- target MDC (Hz), <= ~24-25 MHz for DP83825
  constant USE_PREAMBLE: boolean := true;         -- send 32 x '1' before each frame
  
component mdio_clause22
  generic (
    CLK_FREQ_HZ : natural;
    MDC_FREQ_HZ : natural;
    USE_PREAMBLE : boolean
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    start : in std_logic;
    op_read : in std_logic;
    phyad : in std_logic_vector(4 downto 0);
    regad : in std_logic_vector(4 downto 0);
    wr_data : in std_logic_vector(15 downto 0);
    rd_data : out std_logic_vector(15 downto 0);
    busy : out std_logic;
    done : out std_logic;
    mdc : out std_logic;
    mdio_i : in std_logic;
    mdio_o : out std_logic;
    mdio_oe : out std_logic
  );
end component;  

begin

 -- simple output defaults (avoid 'U')
  rmii_tx_en <= '0';
  rmii_txd   <= (others => '0');
  RJ45_led   <= '0';

  -- Reset synchronizer: async assert (rst_n=0), sync deassert
  process(clk)
  begin
    if rising_edge(clk) then
      step_cnt <= step_cnt + 1;
      vio_step_debug <= step_cnt(18);
      rst_sync_0 <= not rst_n;
      rst_sync_1 <= rst_sync_0;
      rst        <= rst_sync_1;
    end if;
  end process;

  -- Instantiate MDIO core (no component decl needed)
  mdio_clause22_inst : mdio_clause22
    generic map (
      CLK_FREQ_HZ  => CLK_FREQ_HZ,
      MDC_FREQ_HZ  => MDC_FREQ_HZ,
      USE_PREAMBLE => USE_PREAMBLE
    )
    port map (
      clk     => clk,
      rst     => rst,
      start   => mdio_start,
      op_read => mdio_is_read,
      phyad   => mdio_phyad,
      regad   => mdio_reg,
      wr_data => mdio_wr_data,
      rd_data => mdio_rd_data,
      busy    => mdio_busy,
      done    => mdio_done,
      mdc     => mdc,
      mdio_i  => mdio_i,
      mdio_o  => mdio_o,     -- core always drives '0' when mdio_oe=1
      mdio_oe => mdio_oe
    );

  -- Tiny "bring-up poke": issue one READ of reg 2 (PHYIDR1) after reset releases
  process(clk)-- 50MHz ETH phy clock 
  begin
    if rising_edge(clk) then
      case state_machine_1 is
        when S_RESET =>
          if rst = '1' then
            state_machine_1 <= S_WAIT_RST_FALL;
          end if;
        when S_WAIT_RST_FALL =>
          if rst = '0' then -- Wait until Reset gow low
            state_machine_1 <= S_START;
          end if;

        when S_START =>
            --mdio_phyad   <= "00000";
            mdio_phyad   <= STD_LOGIC_VECTOR(phyad_cnt);
            mdio_reg     <= "00010";         -- reg 2
            mdio_is_read <= '1';
            mdio_start   <= '1';
            state_machine_1 <= S_WAIT_DONE;
        when S_START_LOW =>
            mdio_start   <= '0';
            if vio_step_debug = '1' then
              state_machine_1 <= S_WAIT_DONE;
            end if;
        when S_WAIT_DONE =>

        --  if mdio_done = '1' and vio_step_debug = '0' then
            if vio_step_debug = '0' then
            -- mdio_rd_data now has PHYIDR1 (expect 0x2000)
            state_machine_1 <= S_DONE_INC_ADR;
          end if;

        when S_DONE_INC_ADR =>
          if rst = '1' then
            phyad_cnt <= "00000";
          --state_machine_1 <= S_START;
          else
            if phyad_cnt /= "11111" then
               phyad_cnt <= phyad_cnt + 1;

            end if;
          end if;  
          state_machine_1 <= S_VIO_STEP_1_WAIT;              
        when S_VIO_STEP_1_WAIT =>            
            if vio_step_debug = '1' then
              state_machine_1 <= S_VIO_STEP_0_WAIT;
            end if;   
        when S_VIO_STEP_0_WAIT =>   
            if vio_step_debug = '0' then
              state_machine_1 <= S_START;
            end if;           
      end case;
    end if;
  end process;

  process(pll_clk) --128Mhz PLL clk
  begin
    if rising_edge(pll_clk) then

    end if;
  end process;
end behavior;