
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eth_block_tb is
end;

architecture bench of eth_block_tb is
  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  constant G_AXI_ADDR_WIDTH : integer := 6;
  constant G_AXI_DATA_WIDTH : integer := 32;
  constant G_SYS_CLK_HZ : integer := 50_000_000;
  constant G_MDIO_FREQ_HZ : integer := 400_000;
  -- Ports
  signal sys_clk : std_logic;
  signal sys_aresetn : std_logic;
  signal eth_clk : std_logic;
  signal rmii_tx_en : std_logic;
  signal rmii_txd : std_logic_vector(1 downto 0);
  signal rmii_crs_dv : std_logic;
  signal rmii_rxd : std_logic_vector(1 downto 0);
  signal rmii_rx_er : std_logic;
  signal mdc : std_logic;
  signal mdio_i : std_logic;
  signal mdio_o : std_logic;
  signal mdio_oe : std_logic;
  signal phy_rst_n : std_logic;
  signal phy_intr_n : std_logic;
  signal s_axi_aclk : std_logic;
  signal s_axi_aresetn : std_logic;
  signal s_axi_awaddr : std_logic_vector(G_AXI_ADDR_WIDTH-1 downto 0);
  signal s_axi_awvalid : std_logic;
  signal s_axi_awready : std_logic;
  signal s_axi_wdata : std_logic_vector(G_AXI_DATA_WIDTH-1 downto 0);
  signal s_axi_wstrb : std_logic_vector((G_AXI_DATA_WIDTH/8)-1 downto 0);
  signal s_axi_wvalid : std_logic;
  signal s_axi_wready : std_logic;
  signal s_axi_bresp : std_logic_vector(1 downto 0);
  signal s_axi_bvalid : std_logic;
  signal s_axi_bready : std_logic;
  signal s_axi_araddr : std_logic_vector(G_AXI_ADDR_WIDTH-1 downto 0);
  signal s_axi_arvalid : std_logic;
  signal s_axi_arready : std_logic;
  signal s_axi_rdata : std_logic_vector(G_AXI_DATA_WIDTH-1 downto 0);
  signal s_axi_rresp : std_logic_vector(1 downto 0);
  signal s_axi_rvalid : std_logic;
  signal s_axi_rready : std_logic;
  signal s_axis_tvalid : std_logic;
  signal s_axis_tready : std_logic;
  signal s_axis_tlast : std_logic;
  signal s_axis_tdata : std_logic_vector(7 downto 0);
  signal m_axis_tvalid : std_logic;
  signal m_axis_tready : std_logic;
  signal m_axis_tlast : std_logic;
  signal m_axis_tdata : std_logic_vector(7 downto 0);
begin

  eth_block_inst : entity work.eth_block
  generic map (
    G_AXI_ADDR_WIDTH => G_AXI_ADDR_WIDTH,
    G_AXI_DATA_WIDTH => G_AXI_DATA_WIDTH,
    G_SYS_CLK_HZ => G_SYS_CLK_HZ,
    G_MDIO_FREQ_HZ => G_MDIO_FREQ_HZ
  )
  port map (
    sys_clk => sys_clk,
    sys_aresetn => sys_aresetn,
    eth_clk => eth_clk,
    rmii_tx_en => rmii_tx_en,
    rmii_txd => rmii_txd,
    rmii_crs_dv => rmii_crs_dv,
    rmii_rxd => rmii_rxd,
    rmii_rx_er => rmii_rx_er,
    mdc => mdc,
    mdio_i => mdio_i,
    mdio_o => mdio_o,
    mdio_oe => mdio_oe,
    phy_rst_n => phy_rst_n,
    phy_intr_n => phy_intr_n,
    s_axi_aclk => s_axi_aclk,
    s_axi_aresetn => s_axi_aresetn,
    s_axi_awaddr => s_axi_awaddr,
    s_axi_awvalid => s_axi_awvalid,
    s_axi_awready => s_axi_awready,
    s_axi_wdata => s_axi_wdata,
    s_axi_wstrb => s_axi_wstrb,
    s_axi_wvalid => s_axi_wvalid,
    s_axi_wready => s_axi_wready,
    s_axi_bresp => s_axi_bresp,
    s_axi_bvalid => s_axi_bvalid,
    s_axi_bready => s_axi_bready,
    s_axi_araddr => s_axi_araddr,
    s_axi_arvalid => s_axi_arvalid,
    s_axi_arready => s_axi_arready,
    s_axi_rdata => s_axi_rdata,
    s_axi_rresp => s_axi_rresp,
    s_axi_rvalid => s_axi_rvalid,
    s_axi_rready => s_axi_rready,
    s_axis_tvalid => s_axis_tvalid,
    s_axis_tready => s_axis_tready,
    s_axis_tlast => s_axis_tlast,
    s_axis_tdata => s_axis_tdata,
    m_axis_tvalid => m_axis_tvalid,
    m_axis_tready => m_axis_tready,
    m_axis_tlast => m_axis_tlast,
    m_axis_tdata => m_axis_tdata
  );
-- clk <= not clk after clk_period/2;

end;