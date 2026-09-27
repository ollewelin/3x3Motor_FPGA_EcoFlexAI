
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

component eth_block
  generic (
    G_AXI_ADDR_WIDTH : integer;
    G_AXI_DATA_WIDTH : integer;
    G_SYS_CLK_HZ : integer;
    G_MDIO_FREQ_HZ : integer
  );
  port (
    sys_clk : in std_logic;
    sys_aresetn : in std_logic;
    eth_clk : in std_logic;
    rmii_tx_en : out std_logic;
    rmii_txd : out std_logic_vector(1 downto 0);
    rmii_crs_dv : in std_logic;
    rmii_rxd : in std_logic_vector(1 downto 0);
    rmii_rx_er : in std_logic;
    mdc : out std_logic;
    mdio_i : in std_logic;
    mdio_o : out std_logic;
    mdio_oe : out std_logic;
    phy_rst_n : out std_logic;
    phy_intr_n : in std_logic;
    s_axi_aclk : in std_logic;
    s_axi_aresetn : in std_logic;
    s_axi_awaddr : in std_logic_vector(G_AXI_ADDR_WIDTH-1 downto 0);
    s_axi_awvalid : in std_logic;
    s_axi_awready : out std_logic;
    s_axi_wdata : in std_logic_vector(G_AXI_DATA_WIDTH-1 downto 0);
    s_axi_wstrb : in std_logic_vector((G_AXI_DATA_WIDTH/8)-1 downto 0);
    s_axi_wvalid : in std_logic;
    s_axi_wready : out std_logic;
    s_axi_bresp : out std_logic_vector(1 downto 0);
    s_axi_bvalid : out std_logic;
    s_axi_bready : in std_logic;
    s_axi_araddr : in std_logic_vector(G_AXI_ADDR_WIDTH-1 downto 0);
    s_axi_arvalid : in std_logic;
    s_axi_arready : out std_logic;
    s_axi_rdata : out std_logic_vector(G_AXI_DATA_WIDTH-1 downto 0);
    s_axi_rresp : out std_logic_vector(1 downto 0);
    s_axi_rvalid : out std_logic;
    s_axi_rready : in std_logic;
    s_axis_tvalid : in std_logic;
    s_axis_tready : out std_logic;
    s_axis_tlast : in std_logic;
    s_axis_tdata : in std_logic_vector(7 downto 0);
    m_axis_tvalid : out std_logic;
    m_axis_tready : in std_logic;
    m_axis_tlast : out std_logic;
    m_axis_tdata : out std_logic_vector(7 downto 0)
  );
end component;

component mdio_tiny
  generic (
    G_SYS_CLK_HZ : integer;
    G_MDC_HZ : integer
  );
  port (
    sys_clk : in std_logic;
    rst_n : in std_logic;
    start : in std_logic;
    rw : in std_logic;
    phy_addr : in std_logic_vector(4 downto 0);
    reg_addr : in std_logic_vector(4 downto 0);
    wdata : in std_logic_vector(15 downto 0);
    busy : out std_logic;
    done : out std_logic;
    rdata : out std_logic_vector(15 downto 0);
    mdc : out std_logic;
    mdio_i : in std_logic;
    mdio_o : out std_logic;
    mdio_oe : out std_logic
  );
end component;
component phy_bringup
  generic (
    G_SYS_CLK_HZ : integer
  );
  port (
    sys_clk : in std_logic;
    rst_n : in std_logic;
    mdio_start : out std_logic;
    mdio_rw : out std_logic;
    mdio_phyad : out std_logic_vector(4 downto 0);
    mdio_regad : out std_logic_vector(4 downto 0);
    mdio_wdata : out std_logic_vector(15 downto 0);
    mdio_busy : in std_logic;
    mdio_done : in std_logic;
    mdio_rdata : in std_logic_vector(15 downto 0);
    phy_rst_n : out std_logic;
    phy_intr_n : in std_logic;
    led_link : out std_logic;
    id_hi : out std_logic_vector(15 downto 0);
    id_lo : out std_logic_vector(15 downto 0)
  );
end component;

  constant  G_AXI_ADDR_WIDTH : integer := 6;         -- 64B register space
  constant  G_AXI_DATA_WIDTH : integer := 32;        -- CPU-bredd
  constant G_SYS_CLK_HZ : integer := 128_000_000; -- CPU/buss
  constant G_MDC_HZ     : integer := 1_000_000;   -- MDIO klockfrekvens
  signal div : unsigned(25 downto 0) := (others => '0');  -- ~1 s at 128 MHz test counter
  
  
  signal eth_clk_cnt : unsigned(25 downto 0) := (others => '0'); 
  signal io_asyncReset_sig : std_logic := '1';
  signal rst_n : std_logic := '0';
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


  -- MDIO styrsignaler (fr�n bringup ? tiny)
signal mdio_start  : std_logic;                -- triggar MDIO-transaktion
signal mdio_rw     : std_logic;                -- 1=read, 0=write
signal mdio_phyad  : std_logic_vector(4 downto 0);  -- PHY-adress (ofta 00001)
signal mdio_regad  : std_logic_vector(4 downto 0);  -- registeradress
signal mdio_wdata  : std_logic_vector(15 downto 0); -- data att skriva

-- Status/retur (fr�n tiny ? bringup)
signal mdio_busy   : std_logic;                -- 1 = transaktion p�g�r
signal mdio_done   : std_logic;                -- puls n�r klar
signal mdio_rdata  : std_logic_vector(15 downto 0); -- l�st data

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

mdio_tiny_inst : mdio_tiny
  generic map (
    G_SYS_CLK_HZ => G_SYS_CLK_HZ,
    G_MDC_HZ => G_MDC_HZ
  )
  port map (
    sys_clk => pll_clk,
    rst_n => rst_n,
    start => mdio_start,
    rw => mdio_rw,
    phy_addr => mdio_phyad,
    reg_addr => mdio_regad,
    wdata => mdio_wdata,
    busy => mdio_busy,
    done => mdio_done,
    rdata => mdio_rdata,
    mdc => mdc,
    mdio_i => mdio_i,
    mdio_o => mdio_o,
    mdio_oe => mdio_oe
  );

phy_bringup_inst : phy_bringup
  generic map (
    G_SYS_CLK_HZ => G_SYS_CLK_HZ
  )
  port map (
    sys_clk => pll_clk,
    rst_n => rst_n,
    mdio_start => mdio_start,
    mdio_rw => mdio_rw,
    mdio_phyad => mdio_phyad,
    mdio_regad => mdio_regad,
    mdio_wdata => mdio_wdata,
    mdio_busy => mdio_busy,
    mdio_done => mdio_done,
    mdio_rdata => mdio_rdata,
    phy_rst_n => open,
    phy_intr_n => '1',
    led_link => RJ45_led,
    id_hi => open,
    id_lo => open
  );


------------------------ End INSTANTIATION Template ---------
   
   
  process(pll_clk)
  begin
    if rising_edge(pll_clk) then
    

      div   <= div + 1;
      if div(24) = '1' then 
        io_asyncReset_sig <= '0';

      end if;
      --inv_c <= not io_asyncReset_sig;
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
  
  process(clk)
  begin
    if rising_edge(clk) then
        eth_clk_cnt <= eth_clk_cnt + 1;
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

