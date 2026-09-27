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