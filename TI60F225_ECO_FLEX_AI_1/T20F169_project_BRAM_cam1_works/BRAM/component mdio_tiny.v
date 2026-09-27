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