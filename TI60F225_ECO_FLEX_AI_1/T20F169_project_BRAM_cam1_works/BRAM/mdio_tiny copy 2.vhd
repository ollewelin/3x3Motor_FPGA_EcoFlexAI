-- mdio_tiny.vhd : Minimal Clause-22 MDIO master
-- sys_clk domain; generates MDC <= 2.5 MHz and drives MDIO (tri-state)
-- start: one-cycle pulse to begin a transaction
-- rw   : 1=read, 0=write
-- phy_addr/reg_addr: 5-bit addresses
-- wdata: data to write on a write
-- busy : 1 while transaction is running
-- done : 1-cycle pulse when transaction finishes
-- rdata: valid when done='1' (for reads)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mdio_tiny is
  generic (
    G_SYS_CLK_HZ : integer := 50_000_000;
    G_MDC_HZ     : integer := 1_000_000          -- must be <= 2_500_000
  );
  port (
    sys_clk   : in  std_logic;
    rst_n     : in  std_logic;

    -- control
    start     : in  std_logic;                          -- 1-clk pulse
    rw        : in  std_logic;                          -- 1=read, 0=write
    phy_addr  : in  std_logic_vector(4 downto 0);
    reg_addr  : in  std_logic_vector(4 downto 0);
    wdata     : in  std_logic_vector(15 downto 0);

    busy      : out std_logic;
    done      : out std_logic;
    rdata     : out std_logic_vector(15 downto 0);

    -- MDIO pins (tri-state on top level)
    mdc       : out std_logic;
    mdio_i    : in  std_logic;
    mdio_o    : out std_logic;
    mdio_oe   : out std_logic
  );
end entity;

architecture rtl of mdio_tiny is
  ---------------------------------------------------------------------------
  -- MDC generator (toggle -> /2)
  ---------------------------------------------------------------------------
  function max(a, b : integer) return integer is
  begin
    if a > b then return a; else return b; end if;
  end function;

  constant C_DIV       : integer := max(1, integer(real(G_SYS_CLK_HZ) / real(2*G_MDC_HZ)));
  signal   div_cnt     : integer range 0 to C_DIV-1 := 0;
  signal   mdc_int     : std_logic := '0';
  signal   mdc_int_d   : std_logic := '0';
  signal   mdc_rise    : std_logic := '0';

  ---------------------------------------------------------------------------
  -- State machine
  ---------------------------------------------------------------------------
  type st_t is (
    S_IDLE,       -- waiting for start
    S_PREAMBLE,   -- 32 times '1'
    S_START,      -- '01'
    S_OPCODE,     -- read=10, write=01
    S_PHYAD,      -- 5 bits
    S_REGAD,      -- 5 bits
    S_TA_W,       -- write: '10'
    S_TA_Z,       -- read : Z,1
    S_WR,         -- 16-bit data out
    S_RD,         -- 16-bit data in
    S_DONE
  );

  signal st            : st_t := S_IDLE;

  -- Latched command fields
  signal rw_i          : std_logic := '0';
  signal phy_i         : std_logic_vector(4 downto 0) := (others=>'0');
  signal reg_i         : std_logic_vector(4 downto 0) := (others=>'0');
  signal wdat_i        : std_logic_vector(15 downto 0) := (others=>'0');

  -- Bit counter for fields
  signal bitc          : integer range 0 to 63 := 0;

  -- MDIO drive & data capture
  signal mdio_out_bit  : std_logic := '1';
  signal mdio_out_en   : std_logic := '0';
  signal rd_shift      : std_logic_vector(15 downto 0) := (others=>'0');

  -- handshake
  signal busy_i        : std_logic := '0';
  signal done_pulse    : std_logic := '0';
  
  -- add a request latch
  signal req : std_logic := '0';

begin
-- request capture (sys_clk domain)
process(sys_clk)
begin
  if rising_edge(sys_clk) then
    if rst_n='0' then
      req <= '0';
    else
      -- one-cycle 'start' sets a sticky request, only if idle
      if start='1' and st = S_IDLE then
        req <= '1';
      end if;
      -- cleared when FSM consumes it
      if (mdc_rise='1') and (st = S_PREAMBLE) then
        req <= '0';
      end if;
    end if;
  end if;
end process;

  ---------------------------------------------------------------------------
  -- Outputs
  ---------------------------------------------------------------------------
  mdc     <= mdc_int;
  mdio_o  <= mdio_out_bit;
  mdio_oe <= mdio_out_en;

  busy    <= busy_i;
  done    <= done_pulse;
  rdata   <= rd_shift;

  ---------------------------------------------------------------------------
  -- MDC clock (divide sys_clk)
  ---------------------------------------------------------------------------
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if rst_n = '0' then
        div_cnt   <= 0;
        mdc_int   <= '0';
        mdc_int_d <= '0';
      else
        if div_cnt = C_DIV-1 then
          div_cnt <= 0;
          mdc_int <= not mdc_int;
        else
          div_cnt <= div_cnt + 1;
        end if;
        mdc_int_d <= mdc_int;
      end if;
    end if;
  end process;

  mdc_rise <= '1' when (mdc_int = '1' and mdc_int_d = '0') else '0';

  ---------------------------------------------------------------------------
  -- Latch command on start in IDLE
  ---------------------------------------------------------------------------
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if rst_n = '0' then
        rw_i   <= '0';
        phy_i  <= (others=>'0');
        reg_i  <= (others=>'0');
        wdat_i <= (others=>'0');
      else
        if start = '1' and st = S_IDLE then
          rw_i   <= rw;
          phy_i  <= phy_addr;
          reg_i  <= reg_addr;
          wdat_i <= wdata;
        end if;
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- MDIO state machine (advances on MDC rising edges)
  ---------------------------------------------------------------------------
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if rst_n = '0' then
        st            <= S_IDLE;
        mdio_out_en   <= '0';
        mdio_out_bit  <= '1';
        rd_shift      <= (others=>'0');
        bitc          <= 0;
        busy_i        <= '0';
        done_pulse    <= '0';
      else
        done_pulse <= '0'; -- default

        if mdc_rise = '1' then
          case st is
         --   when S_IDLE =>
         --     mdio_out_en  <= '0';
         --     mdio_out_bit <= '1';
         --     busy_i       <= '0';
        --    if start = '1' then
                -- begin preamble of 32 ones
        --        st           <= S_PREAMBLE;
        --        mdio_out_en  <= '1';
        --        mdio_out_bit <= '1';
        --        bitc         <= 31;
        --        busy_i       <= '1';
        --      end if;


-- in the FSM, in S_IDLE, use 'req' instead of 'start'
when S_IDLE =>
  mdio_out_en  <= '0';
  mdio_out_bit <= '1';
  busy_i       <= '0';
  if req = '1' then
    -- begin preamble
    st           <= S_PREAMBLE;
    mdio_out_en  <= '1';
    mdio_out_bit <= '1';
    bitc         <= 31;
    busy_i       <= '1';
  end if;

            when S_PREAMBLE =>
              if bitc = 0 then
                st           <= S_START;
                mdio_out_bit <= '0';  -- first of '01'
                bitc         <= 1;
              else
                bitc <= bitc - 1;
              end if;

            when S_START =>
              if bitc = 1 then
                mdio_out_bit <= '1';  -- second of '01'
                st           <= S_OPCODE;
                bitc         <= 1;     -- two bits in opcode
              end if;

            when S_OPCODE =>
              if rw_i = '1' then
                -- READ: '10'
                if bitc = 1 then
                  mdio_out_bit <= '0';
                  st           <= S_PHYAD;
                  bitc         <= 4;
                else
                  mdio_out_bit <= '1';
                  bitc         <= bitc - 1;
                end if;
              else
                -- WRITE: '01'
                if bitc = 1 then
                  mdio_out_bit <= '1';
                  st           <= S_PHYAD;
                  bitc         <= 4;
                else
                  mdio_out_bit <= '0';
                  bitc         <= bitc - 1;
                end if;
              end if;

            when S_PHYAD =>
              mdio_out_bit <= phy_i(bitc);
              if bitc = 0 then
                st   <= S_REGAD;
                bitc <= 4;
              else
                bitc <= bitc - 1;
              end if;

            when S_REGAD =>
              mdio_out_bit <= reg_i(bitc);
              if bitc = 0 then
                if rw_i = '1' then
                  -- read: TA = Z,1
                  st           <= S_TA_Z;
                  mdio_out_en  <= '0'; -- Z
                  bitc         <= 1;
                else
                  -- write: TA = 1,0
                  st           <= S_TA_W;
                  mdio_out_en  <= '1';
                  mdio_out_bit <= '1';
                  bitc         <= 1;
                end if;
              else
                bitc <= bitc - 1;
              end if;

            when S_TA_W =>
              if bitc = 1 then
                mdio_out_bit <= '0';
                st           <= S_WR;
                bitc         <= 15;
              end if;

            when S_WR =>
              mdio_out_bit <= wdat_i(bitc);
              if bitc = 0 then
                st           <= S_DONE;
                mdio_out_en  <= '0';
              else
                bitc <= bitc - 1;
              end if;

            when S_TA_Z =>
              if bitc = 1 then
                st   <= S_RD;
                bitc <= 15;
              end if;

            when S_RD =>
              rd_shift(bitc) <= mdio_i;
              if bitc = 0 then
                st          <= S_DONE;
              else
                bitc        <= bitc - 1;
              end if;

            when S_DONE =>
              done_pulse   <= '1';   -- one sys_clk cycle pulse
              st           <= S_IDLE;
              busy_i       <= '0';
              mdio_out_en  <= '0';
              mdio_out_bit <= '1';

          end case;
        end if; -- mdc_rise
      end if;
    end if;
  end process;

end architecture;
