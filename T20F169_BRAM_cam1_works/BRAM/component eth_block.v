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