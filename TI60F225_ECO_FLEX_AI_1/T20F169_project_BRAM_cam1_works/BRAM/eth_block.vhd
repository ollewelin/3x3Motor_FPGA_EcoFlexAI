library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eth_block is
  generic (
    G_AXI_ADDR_WIDTH : integer := 6;       -- 64B register space räcker för nu
    G_AXI_DATA_WIDTH : integer := 32;
    G_SYS_CLK_HZ     : integer := 50_000_000; -- sys_clk frekvens (Hz)
    G_MDIO_FREQ_HZ   : integer := 400_000      -- MDC målfrekvens (<=2.5 MHz)
  );
  port (
    --------------------------------------------------------------------------
    -- Klockor/Reset
    --------------------------------------------------------------------------
    sys_clk     : in  std_logic;     -- CPU/bussdomän
    sys_aresetn : in  std_logic;     -- aktiv låg

    eth_clk     : in  std_logic;     -- 50 MHz REF_CLK från PHY (RMII domän)

    --------------------------------------------------------------------------
    -- RMII + MDIO mot PHY
    --------------------------------------------------------------------------
    rmii_tx_en  : out std_logic;
    rmii_txd    : out std_logic_vector(1 downto 0);
    rmii_crs_dv : in  std_logic;
    rmii_rxd    : in  std_logic_vector(1 downto 0);
    rmii_rx_er  : in  std_logic;

    mdc         : out std_logic;
    mdio_i      : in  std_logic;   -- tri-state input
    mdio_o      : out std_logic;   -- tri-state output
    mdio_oe     : out std_logic;   -- 1 = drive mdio_o

    phy_rst_n   : out std_logic;   -- till DP83825I RST_N (aktiv låg)
    phy_intr_n  : in  std_logic;   -- från DP83825I INTR/PWRDN (aktiv låg, läses till status)

    --------------------------------------------------------------------------
    -- AXI-Lite slav (styrplan)
    --------------------------------------------------------------------------
    s_axi_aclk    : in  std_logic;
    s_axi_aresetn : in  std_logic;
    s_axi_awaddr  : in  std_logic_vector(G_AXI_ADDR_WIDTH-1 downto 0);
    s_axi_awvalid : in  std_logic;
    s_axi_awready : out std_logic;
    s_axi_wdata   : in  std_logic_vector(G_AXI_DATA_WIDTH-1 downto 0);
    s_axi_wstrb   : in  std_logic_vector((G_AXI_DATA_WIDTH/8)-1 downto 0);
    s_axi_wvalid  : in  std_logic;
    s_axi_wready  : out std_logic;
    s_axi_bresp   : out std_logic_vector(1 downto 0);
    s_axi_bvalid  : out std_logic;
    s_axi_bready  : in  std_logic;
    s_axi_araddr  : in  std_logic_vector(G_AXI_ADDR_WIDTH-1 downto 0);
    s_axi_arvalid : in  std_logic;
    s_axi_arready : out std_logic;
    s_axi_rdata   : out std_logic_vector(G_AXI_DATA_WIDTH-1 downto 0);
    s_axi_rresp   : out std_logic_vector(1 downto 0);
    s_axi_rvalid  : out std_logic;
    s_axi_rready  : in  std_logic;

    --------------------------------------------------------------------------
    -- AXI-Stream dataplan (8-bit)
    --------------------------------------------------------------------------
    -- TX: system -> MAC -> PHY
    s_axis_tvalid : in  std_logic;
    s_axis_tready : out std_logic;
    s_axis_tlast  : in  std_logic;
    s_axis_tdata  : in  std_logic_vector(7 downto 0);

    -- RX: PHY -> MAC -> system
    m_axis_tvalid : out std_logic;
    m_axis_tready : in  std_logic;
    m_axis_tlast  : out std_logic;
    m_axis_tdata  : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of eth_block is

  ----------------------------------------------------------------------------
  -- Register-map (AXI-Lite) adresser
  -- 0x00 VERSION, 0x04 CONTROL, 0x08 STATUS,
  -- 0x1C MDIO_CTRL, 0x20 MDIO_WDATA, 0x24 MDIO_RDATA
  ----------------------------------------------------------------------------
  constant C_REG_VERSION   : unsigned(G_AXI_ADDR_WIDTH-1 downto 0) := to_unsigned(16#00#, G_AXI_ADDR_WIDTH);
  constant C_REG_CONTROL   : unsigned(G_AXI_ADDR_WIDTH-1 downto 0) := to_unsigned(16#04#, G_AXI_ADDR_WIDTH);
  constant C_REG_STATUS    : unsigned(G_AXI_ADDR_WIDTH-1 downto 0) := to_unsigned(16#08#, G_AXI_ADDR_WIDTH);
  constant C_REG_MDIO_CTRL : unsigned(G_AXI_ADDR_WIDTH-1 downto 0) := to_unsigned(16#1C#, G_AXI_ADDR_WIDTH);
  constant C_REG_MDIO_WDAT : unsigned(G_AXI_ADDR_WIDTH-1 downto 0) := to_unsigned(16#20#, G_AXI_ADDR_WIDTH);
  constant C_REG_MDIO_RDAT : unsigned(G_AXI_ADDR_WIDTH-1 downto 0) := to_unsigned(16#24#, G_AXI_ADDR_WIDTH);

  -- CONTROL bits
  signal reg_control      : std_logic_vector(31 downto 0);  -- [0]=tx_en, [1]=rx_en, [4]=phy_rst_n_override(1=release), [8]=mdio_go, [9]=mdio_rw(1=rd)
  signal reg_status       : std_logic_vector(31 downto 0);  -- [0]=link_irq_n (inverterad), [1]=mdio_busy, [2]=mdio_err
  signal reg_version      : std_logic_vector(31 downto 0) := x"45544830"; -- "ETH0"
  -- MDIO ctrl
  -- [4:0] phy_addr, [9:5] reg_addr
  signal reg_mdio_ctrl    : std_logic_vector(31 downto 0);
  signal reg_mdio_wdata   : std_logic_vector(15 downto 0);
  signal reg_mdio_rdata   : std_logic_vector(15 downto 0);

  ----------------------------------------------------------------------------
  -- AXI-Lite enkla signaler
  ----------------------------------------------------------------------------
  signal aw_hs, w_hs, ar_hs : std_logic;
  signal awaddr_r, araddr_r : std_logic_vector(G_AXI_ADDR_WIDTH-1 downto 0);

  ----------------------------------------------------------------------------
  -- MDIO-master (Clause-22) i sys_clk-domänen
  ----------------------------------------------------------------------------
  constant C_MDC_DIV : integer := integer(real(G_SYS_CLK_HZ) / real(2*G_MDIO_FREQ_HZ)); -- toggle => /2
  signal mdc_cnt     : integer range 0 to C_MDC_DIV-1 := 0;
  signal mdc_int     : std_logic := '0';

  type mdio_state_t is (IDLE, PREAMBLE, START, OPCODE, PHYAD, REGAD, TA_W, TA_Z, RD_DATA, WR_DATA, DONE);
  signal mdio_state  : mdio_state_t := IDLE;

  signal mdio_busy   : std_logic := '0';
  signal mdio_rw     : std_logic := '0';  -- 1=read, 0=write (från reg_control(9))
  signal mdio_phyad  : std_logic_vector(4 downto 0) := (others=>'0');
  signal mdio_regad  : std_logic_vector(4 downto 0) := (others=>'0');

  signal mdio_shift  : std_logic_vector(31 downto 0) := (others=>'0'); -- används för header/skriv
  signal rd_shift    : std_logic_vector(15 downto 0) := (others=>'0');
  signal bit_cnt     : integer range 0 to 63 := 0;

  signal mdio_out    : std_logic := '1';
  signal mdio_out_en : std_logic := '0'; -- 1=driva
  signal mdio_in_s   : std_logic := '1';

  ----------------------------------------------------------------------------
  -- FIFO-skal för AXI-Stream (CDC sys_clk <-> eth_clk)
  ----------------------------------------------------------------------------
  -- TX: sys_clk -> eth_clk
  signal tx_fifo_wr_en   : std_logic;
  signal tx_fifo_rd_en   : std_logic;
  signal tx_fifo_din     : std_logic_vector(7 downto 0);
  signal tx_fifo_dout    : std_logic_vector(7 downto 0);
  signal tx_fifo_full    : std_logic;
  signal tx_fifo_empty   : std_logic;

  -- RX: eth_clk -> sys_clk
  signal rx_fifo_wr_en   : std_logic;
  signal rx_fifo_rd_en   : std_logic;
  signal rx_fifo_din     : std_logic_vector(7 downto 0);
  signal rx_fifo_dout    : std_logic_vector(7 downto 0);
  signal rx_fifo_full    : std_logic;
  signal rx_fifo_empty   : std_logic;

begin
  ----------------------------------------------------------------------------
  -- MDIO tri-state ut på topp-portar
  ----------------------------------------------------------------------------
  mdio_o  <= mdio_out;
  mdio_oe <= mdio_out_en;
  mdio_in_s <= mdio_i;
  mdc     <= mdc_int;

  ----------------------------------------------------------------------------
  -- PHY reset-styrning (bit4 i CONTROL: 1 = släpp reset)
  ----------------------------------------------------------------------------
  phy_rst_n <= reg_control(4);

  ----------------------------------------------------------------------------
  -- STATUS[0] = ~phy_intr_n , [1] = mdio_busy
  ----------------------------------------------------------------------------
  reg_status(0) <= not phy_intr_n;
  reg_status(1) <= mdio_busy;
  reg_status(2) <= '0';
  reg_status(31 downto 3) <= (others=>'0');

  ----------------------------------------------------------------------------
  -- AXI-Lite handskakning (minimal, single-beat)
  ----------------------------------------------------------------------------
  aw_hs <= s_axi_awvalid and s_axi_wvalid and s_axi_awready and s_axi_wready;
  w_hs  <= s_axi_wvalid and s_axi_wready;
  ar_hs <= s_axi_arvalid and s_axi_arready;

  process(s_axi_aclk)
  begin
    if rising_edge(s_axi_aclk) then
      if s_axi_aresetn = '0' then
        s_axi_awready <= '1';
        s_axi_wready  <= '1';
        s_axi_bvalid  <= '0';
        s_axi_bresp   <= "00";
        s_axi_arready <= '1';
        s_axi_rvalid  <= '0';
        s_axi_rresp   <= "00";
        reg_control   <= (others=>'0');
        reg_mdio_ctrl <= (others=>'0');
        reg_mdio_wdata<= (others=>'0');
      else
        -- Skriv
        if s_axi_awvalid='1' and s_axi_wvalid='1' and s_axi_awready='1' and s_axi_wready='1' then
          awaddr_r <= s_axi_awaddr;
          case unsigned(s_axi_awaddr) is
            when C_REG_CONTROL =>
              reg_control <= s_axi_wdata;
            when C_REG_MDIO_CTRL =>
              reg_mdio_ctrl <= s_axi_wdata;
            when C_REG_MDIO_WDAT =>
              reg_mdio_wdata <= s_axi_wdata(15 downto 0);
            when others =>
              null;
          end case;
          s_axi_bvalid <= '1';
          s_axi_bresp  <= "00";
        elsif s_axi_bvalid='1' and s_axi_bready='1' then
          s_axi_bvalid <= '0';
        end if;

        -- Läs
        if s_axi_arvalid='1' and s_axi_arready='1' then
          araddr_r <= s_axi_araddr;
          s_axi_rvalid <= '1';
          case unsigned(s_axi_araddr) is
            when C_REG_VERSION   => s_axi_rdata <= reg_version;
            when C_REG_CONTROL   => s_axi_rdata <= reg_control;
            when C_REG_STATUS    => s_axi_rdata <= reg_status;
            when C_REG_MDIO_CTRL => s_axi_rdata <= reg_mdio_ctrl;
            when C_REG_MDIO_WDAT => s_axi_rdata <= (others=>'0'); -- skriv-only
            when C_REG_MDIO_RDAT => s_axi_rdata <= (31 downto 16 => '0') & reg_mdio_rdata;
            when others          => s_axi_rdata <= (others=>'0');
          end case;
          s_axi_rresp <= "00";
        elsif s_axi_rvalid='1' and s_axi_rready='1' then
          s_axi_rvalid <= '0';
        end if;
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- MDIO-master: enkel Clause-22 implementation
  -- Starta operation genom att skriva:
  --   reg_mdio_ctrl: [4:0]=PHYAD, [9:5]=REGAD
  --   reg_control(9)=rw(1=read), reg_control(8)=go(1 startar)
  ----------------------------------------------------------------------------
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_aresetn = '0' then
        mdc_cnt     <= 0;
        mdc_int     <= '0';
      else
        if mdc_cnt = C_MDC_DIV-1 then
          mdc_cnt <= 0;
          mdc_int <= not mdc_int;
        else
          mdc_cnt <= mdc_cnt + 1;
        end if;
      end if;
    end if;
  end process;

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_aresetn='0' then
        mdio_state   <= IDLE;
        mdio_busy    <= '0';
        mdio_out     <= '1';
        mdio_out_en  <= '0';
        reg_mdio_rdata <= (others=>'0');
        bit_cnt      <= 0;
      else
        -- Startvillkor
        if (reg_control(8)='1') and (mdio_busy='0') then
          mdio_busy   <= '1';
          mdio_rw     <= reg_control(9);
          mdio_phyad  <= reg_mdio_ctrl(4 downto 0);
          mdio_regad  <= reg_mdio_ctrl(9 downto 5);
          mdio_state  <= PREAMBLE;
          bit_cnt     <= 31;
          mdio_out_en <= '1';
          mdio_out    <= '1'; -- preamble '1'
        end if;

        -- Kör endast vid ena flanken av MDC (enkelt valt här: när mdc_int går låg -> hög)
        if mdc_int='1' then
          case mdio_state is
            when IDLE =>
              mdio_out_en <= '0';
              mdio_out    <= '1';

            when PREAMBLE =>
              if bit_cnt=0 then
                mdio_state <= START;
                -- ST=01
                mdio_out   <= '0';
                bit_cnt    <= 1; -- 0->1 (två bitar: 0,1)
              else
                bit_cnt <= bit_cnt - 1;
              end if;

            when START =>
              -- vi skickar bitsekvensen 01
              if bit_cnt=1 then
                mdio_out <= '1';
                mdio_state <= OPCODE;
                bit_cnt <= 1; -- två bitar i OPCODE
              else
                -- första av de två start-bitarna var '0' redan
                null;
              end if;

            when OPCODE =>
              -- 10=read, 01=write
              if mdio_rw='1' then
                -- READ: '1','0'
                if bit_cnt=1 then
                  mdio_out <= '0';
                  mdio_state <= PHYAD;
                  bit_cnt <= 4;
                else
                  mdio_out <= '1';
                  bit_cnt <= bit_cnt - 1;
                end if;
              else
                -- WRITE: '0','1'
                if bit_cnt=1 then
                  mdio_out <= '1';
                  mdio_state <= PHYAD;
                  bit_cnt <= 4;
                else
                  mdio_out <= '0';
                  bit_cnt <= bit_cnt - 1;
                end if;
              end if;

            when PHYAD =>
              mdio_out <= mdio_phyad(bit_cnt);
              if bit_cnt=0 then
                mdio_state <= REGAD;
                bit_cnt <= 4;
              else
                bit_cnt <= bit_cnt - 1;
              end if;

            when REGAD =>
              mdio_out <= mdio_regad(bit_cnt);
              if bit_cnt=0 then
                if mdio_rw='1' then
                  mdio_state <= TA_Z;     -- read: Z,1
                  mdio_out_en <= '0';     -- Z
                else
                  mdio_state <= TA_W;     -- write: '1','0'
                  mdio_out_en <= '1';
                  mdio_out <= '1';
                end if;
                bit_cnt <= 1;
              else
                bit_cnt <= bit_cnt - 1;
              end if;

            when TA_W =>
              if bit_cnt=1 then
                mdio_out <= '0';          -- andra TA-biten
                bit_cnt <= 15;
                mdio_state <= WR_DATA;
              else
                -- första TA-biten = '1' redan satt
                null;
              end if;

            when WR_DATA =>
              mdio_out <= reg_mdio_wdata(bit_cnt);
              if bit_cnt=0 then
                mdio_state <= DONE;
              else
                bit_cnt <= bit_cnt - 1;
              end if;

            when TA_Z =>
              if bit_cnt=1 then
                -- andra TA-biten: läsning från PHY; förväntad '0' eller '1'
                bit_cnt <= 15;
                mdio_state <= RD_DATA;
              else
                -- första TA-biten var Z (oe=0), byt till läge att läsa in
                null;
              end if;

            when RD_DATA =>
              -- sample data på varje klock (här på mdc_int='1' kant)
              rd_shift(bit_cnt) <= mdio_in_s;
              if bit_cnt=0 then
                reg_mdio_rdata <= rd_shift;
                mdio_state <= DONE;
              else
                bit_cnt <= bit_cnt - 1;
              end if;

            when DONE =>
              mdio_busy   <= '0';
              mdio_out_en <= '0';
              mdio_state  <= IDLE;
              -- auto-clear GO
              reg_control(8) <= '0';

            when others =>
              mdio_state <= IDLE;
          end case;
        end if; -- mdc gate
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- AXI-Stream till/fån FIFO (skal just nu)
  -- TODO: Nästa steg lägger vi in rmii_tx/rmii_rx som läser/skriv till dessa FIFO:er i eth_clk-domänen.
  ----------------------------------------------------------------------------
  -- TX sys->eth
  tx_fifo_din   <= s_axis_tdata;
  tx_fifo_wr_en <= s_axis_tvalid and (not tx_fifo_full);
  s_axis_tready <= not tx_fifo_full;

  -- RX eth->sys
  m_axis_tdata  <= rx_fifo_dout;
  m_axis_tvalid <= not rx_fifo_empty;
  rx_fifo_rd_en <= m_axis_tready and (not rx_fifo_empty);
  m_axis_tlast  <= '0'; -- TODO: sätts av RX-MAC när den kommer

  ----------------------------------------------------------------------------
  -- Enkla små asynk-FIFO-skal (implementera eller byt mot din befintliga)
  ----------------------------------------------------------------------------
  -- NOTE: Första versionen kan du ersätta med Efinix RAM-FIFO IP om du vill.
  -- Här deklarerar vi dem som blackboxes tills vidare (för att snabbt integrera).
  ----------------------------------------------------------------------------

  -- pragma translate_off
  -- (dummy generisk FIFO-modell för sim)
  -- pragma translate_on

  -- Blackbox-deklaration (byt mot riktig FIFO i nästa steg)
  -- TX FIFO
  -- synthesis translate_off
  -- (Här kan du lägga en enkel behavioral FIFO för sim)
  -- synthesis translate_on

  -- För att hålla koden kompilerbar utan riktig FIFO-IP:
  tx_fifo_full  <= '0';
  tx_fifo_empty <= '1';
  rx_fifo_full  <= '0';
  rx_fifo_empty <= '1';

  rmii_tx_en <= '0';
  rmii_txd   <= (others=>'0');

end architecture;
