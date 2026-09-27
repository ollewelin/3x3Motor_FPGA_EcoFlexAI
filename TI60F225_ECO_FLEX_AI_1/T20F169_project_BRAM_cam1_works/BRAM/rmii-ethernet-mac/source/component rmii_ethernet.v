component rmii_ethernet
  port (
    PHY_CLK : in std_logic;
    PHY_TXD : out std_logic_vector (1 downto 0);
    PHY_TXEN : out std_logic;
    PHY_RXD : in std_logic_vector (1 downto 0);
    PHY_RXER : in std_logic;
    PHY_RST : out std_logic;
    PHY_CRS_DV : in std_logic;
    TH_RX_AXIS_CLK : in std_logic;
    ETH_RX_AXIS_RESET : in std_logic;
    ETH_RX_AXIS_TDATA : out std_logic_vector (7 downto 0);
    ETH_RX_AXIS_TVALID : out std_logic;
    ETH_RX_AXIS_TLAST : out std_logic;
    ETH_RX_AXIS_TREADY : in std_logic;
    ETH_TX_AXIS_CLK : in std_logic;
    ETH_TX_AXIS_RESET : in std_logic;
    ETH_TX_AXIS_TDATA : in std_logic_vector (7 downto 0);
    ETH_TX_AXIS_TVALID : in std_logic;
    ETH_TX_AXIS_TLAST : in std_logic;
    ETH_TX_AXIS_TREADY : out std_logic;
    CRC_BAD : out std_logic;
    CRC_GOOD : out std_logic
  );
end component;

