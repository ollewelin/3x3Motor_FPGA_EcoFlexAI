-- phy_bringup.vhd : reset -> post-reset wait -> read ID -> poll link (with retry)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phy_bringup is
  generic (
    G_SYS_CLK_HZ    : integer := 50_000_000; -- sys clock driving this logic
    G_POST_RESET_US : integer := 20000       -- wait (us) after releasing PHY reset before MDIO
  );
  port (
    sys_clk     : in  std_logic;
    rst_n       : in  std_logic;

    -- MDIO tiny master interface
    mdio_start  : out std_logic;
    mdio_rw     : out std_logic;                          -- 1=read
    mdio_phyad  : out std_logic_vector(4 downto 0);
    mdio_regad  : out std_logic_vector(4 downto 0);
    mdio_wdata  : out std_logic_vector(15 downto 0);
    mdio_busy   : in  std_logic;
    mdio_done   : in  std_logic;
    mdio_rdata  : in  std_logic_vector(15 downto 0);

    -- PHY side pins
    phy_rst_n   : out std_logic;
    phy_intr_n  : in  std_logic;

    -- Debug / status
    led_link    : out std_logic;
    id_hi       : out std_logic_vector(15 downto 0);
    id_lo       : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of phy_bringup is
  -- NOTE: don't use reserved word WAIT as a state literal
  type st_t is (S_RST_HOLD, S_RST_RELEASE, S_POST_WAIT, S_READ_ID1, S_READ_ID2, S_POLL_BMSR, S_WAIT);
  signal st : st_t := S_RST_HOLD;

  -- Post reset wait target in sys_clk cycles
  constant C_POST_WAIT_CYCLES : integer := integer(real(G_SYS_CLK_HZ) * real(G_POST_RESET_US) / 1_000_000.0);

  signal cnt       : integer range 0 to integer'high := 0;
  signal go        : std_logic := '0';
  signal id1       : std_logic_vector(15 downto 0) := (others=>'0');
  signal id2       : std_logic_vector(15 downto 0) := (others=>'0');

  -- Mirror 'out' ports to internal signals so we can read them locally (VHDL-93 safe)
  signal mdio_rw_s    : std_logic := '1';
  signal mdio_phyad_s : std_logic_vector(4 downto 0) := "00001"; -- try address 1 by default
  signal mdio_regad_s : std_logic_vector(4 downto 0) := (others=>'0');
  signal mdio_wdata_s : std_logic_vector(15 downto 0) := (others=>'0');

  -- Simple timeout so S_WAIT can't stick forever: ~2^16 cycles
  signal wait_cnt     : unsigned(15 downto 0) := (others=>'0');

begin
  -- Drive outputs from internal mirrors
  mdio_start <= go;
  mdio_rw    <= mdio_rw_s;      -- read
  mdio_phyad <= mdio_phyad_s;
  mdio_regad <= mdio_regad_s;
  mdio_wdata <= mdio_wdata_s;   -- not used for reads

  id_hi <= id1;
  id_lo <= id2;

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if rst_n = '0' then
        st           <= S_RST_HOLD;
        phy_rst_n    <= '0';
        cnt          <= 0;
        go           <= '0';
        id1          <= (others=>'0');
        id2          <= (others=>'0');
        led_link     <= '0';
        mdio_regad_s <= (others=>'0');
        wait_cnt     <= (others=>'0');
      else
        go <= '0';  -- default: pulse only when (re)starting an MDIO read

        case st is
          when S_RST_HOLD =>
            -- Hold PHY reset low for ~20ms
            phy_rst_n <= '0';
            if cnt >= integer(real(G_SYS_CLK_HZ) / 50.0) then -- ~20ms
              cnt <= 0;
              st  <= S_RST_RELEASE;
            else
              cnt <= cnt + 1;
            end if;

          when S_RST_RELEASE =>
            phy_rst_n <= '1';
            cnt       <= 0;
            st        <= S_POST_WAIT;

          when S_POST_WAIT =>
            -- Wait extra time after reset release before MDIO
            if cnt >= C_POST_WAIT_CYCLES then
              cnt <= 0;
              st  <= S_READ_ID1;
            else
              cnt <= cnt + 1;
            end if;

          when S_READ_ID1 =>
            mdio_regad_s <= "00010"; -- reg 2 (PHY ID1)
            if mdio_busy = '0' then
              go       <= '1';              -- kick off MDIO read
              wait_cnt <= (others=>'0');
              st       <= S_WAIT;
            end if;

          when S_READ_ID2 =>
            mdio_regad_s <= "00011"; -- reg 3 (PHY ID2)
            if mdio_busy = '0' then
              go       <= '1';
              wait_cnt <= (others=>'0');
              st       <= S_WAIT;
            end if;

          when S_POLL_BMSR =>
            mdio_regad_s <= "00001"; -- reg 1 (BMSR)
            if mdio_busy = '0' then
              go       <= '1';
              wait_cnt <= (others=>'0');
              st       <= S_WAIT;
            end if;

          when S_WAIT =>
            if mdio_done = '1' then
              wait_cnt <= (others=>'0');
              case mdio_regad_s is
                when "00010" =>                           -- ID1
                  id1 <= mdio_rdata;
                  st  <= S_READ_ID2;

                when "00011" =>                           -- ID2
                  id2 <= mdio_rdata;
                  st  <= S_POLL_BMSR;

                when "00001" =>                           -- BMSR
                  led_link <= mdio_rdata(2);              -- Link Status bit
                  st       <= S_POLL_BMSR;                -- keep polling

                when others =>
                  st <= S_POLL_BMSR;
              end case;
            else
              -- Timeout/retry so we don't stick forever if the bus is silent
              wait_cnt <= wait_cnt + 1;
              if wait_cnt = not to_unsigned(0, wait_cnt'length) then
                wait_cnt <= (others=>'0');
                if mdio_busy = '0' then
                  go <= '1'; -- re-issue last read
                end if;
              end if;
            end if;

        end case;
      end if;
    end if;
  end process;

end architecture;
