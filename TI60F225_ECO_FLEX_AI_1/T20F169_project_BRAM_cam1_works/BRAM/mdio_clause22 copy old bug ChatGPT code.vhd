-- mdio_clause22.vhd
-- Simple MDIO master for IEEE 802.3 Clause 22 (DP83825 etc.)
-- Single clock domain; generates MDC; MSB-first; proper TA; open-drain MDIO.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mdio_clause22 is
  generic (
    CLK_FREQ_HZ : natural := 50_000_000;  -- FPGA clock (Hz)
    MDC_FREQ_HZ : natural := 2_500_000;   -- target MDC (Hz), <= ~24-25 MHz for DP83825
    USE_PREAMBLE: boolean := true         -- send 32 x '1' before each frame
  );
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;                         -- sync reset, active=1

    -- Command interface
    start   : in  std_logic;                         -- pulse to start a transaction
    op_read : in  std_logic;                         -- '1' = READ, '0' = WRITE (Clause-22)
    phyad   : in  std_logic_vector(4 downto 0);
    regad   : in  std_logic_vector(4 downto 0);
    wr_data : in  std_logic_vector(15 downto 0);     -- used for WRITE
    rd_data : out std_logic_vector(15 downto 0);     -- latched after READ completes
    busy    : out std_logic;                         -- high while a transaction is in progress
    done    : out std_logic;                         -- 1-cycle pulse when transaction ends (ok)

    -- MDIO pins (open-drain behavior)
    mdc     : out std_logic;
    mdio_i  : in  std_logic;                         -- sample from pin
    mdio_o  : out std_logic;                         -- connect to pin; ALWAYS drive '0' when enabled
    mdio_oe : out std_logic                          -- '1' = drive mdio_o (low); '0' = Hi-Z (pulled high)
  );
end entity;

architecture rtl of mdio_clause22 is
  -- MDC divider: toggle MDC every DIV ticks -> full period = 2*DIV
  constant DIV       : natural := integer(real(CLK_FREQ_HZ) / real(2*MDC_FREQ_HZ));
  subtype div_t      is unsigned(31 downto 0);
  signal divcnt      : div_t := (others => '0');

  signal mdc_r       : std_logic := '0';
  signal mdc_r_prev  : std_logic := '0';
  signal tick        : std_logic := '0';  -- high for one clk when MDC toggles

  -- rising edge detect for MDC inside this clock domain
  signal mdc_rise    : std_logic := '0';
  signal mdc_fall    : std_logic := '0';

  -- FSM
  type state_t is (S_IDLE, S_PREAMBLE, S_ST, S_OP, S_PHY, S_REG, S_TA, S_DATA, S_DONE);
  signal s           : state_t := S_IDLE;

  -- bit counters (MSB-first)
  signal cnt32       : integer range 0 to 32 := 0;  -- preamble count
  signal cnt2        : integer range 0 to 2  := 0;  -- 2-bit fields
  signal cnt5        : integer range 0 to 5  := 0;  -- 5-bit fields
  signal cnt16       : integer range 0 to 16 := 0;  -- 16 data bits

  -- latched inputs / outputs
  signal op_is_read  : std_logic := '0';
  signal phyad_r     : std_logic_vector(4 downto 0) := (others => '0');
  signal regad_r     : std_logic_vector(4 downto 0) := (others => '0');
  signal wr_data_r   : std_logic_vector(15 downto 0) := (others => '0');
  signal rd_data_r   : std_logic_vector(15 downto 0) := (others => '0');

  -- open-drain drive control
  -- We ONLY ever drive the line low; '1' bits are produced by releasing the line.
  signal drive_low   : std_logic := '0';  -- mdio_oe follows this; mdio_o always '0'

  -- helper: current bit to send (when we are the driver)
  signal cur_bit     : std_logic := '1';  -- default high (released)

  -- convenience constants
  constant ST_BITS   : std_logic_vector(1 downto 0) := "01";
  constant OP_RD     : std_logic_vector(1 downto 0) := "11";
  constant OP_WR     : std_logic_vector(1 downto 0) := "10";
begin
  mdc     <= mdc_r;
  mdio_o  <= '0';          -- open-drain: we only pull low when enabled
  mdio_oe <= drive_low;

  -- export read data & flags
  rd_data <= rd_data_r;

  -- MDC generator (toggle at DIV)
  process(clk)
  begin
    if rising_edge(clk) then
      mdc_r_prev <= mdc_r;

      if rst = '1' then
        divcnt   <= (others => '0');
        mdc_r    <= '0';
        tick     <= '0';
      else
        if divcnt = to_unsigned(DIV-1, divcnt'length) then
          divcnt <= (others => '0');
          mdc_r  <= not mdc_r;
          tick   <= '1';
        else
          divcnt <= divcnt + 1;
          tick   <= '0';
        end if;
      end if;
    end if;
  end process;

  mdc_rise <= '1' when (tick = '1' and mdc_r = '1' and mdc_r_prev = '0') else '0';
  mdc_fall <= '1' when (tick = '1' and mdc_r = '0' and mdc_r_prev = '1') else '0';

  -- Main FSM
  process(clk)
    -- helpers to fetch MSB-first bits by index
    impure function bit_of(v : std_logic_vector; msb_index_from_left : integer) return std_logic is
      -- msb_index_from_left = 0 => MSB
      variable idx : integer := v'left - msb_index_from_left;
    begin
      return v(idx);
    end function;
  begin
    if rising_edge(clk) then
      done   <= '0';
      busy   <= '1';

      if rst = '1' then
        s          <= S_IDLE;
        drive_low  <= '0';
        cur_bit    <= '1';
        cnt32      <= 0;
        cnt2       <= 0;
        cnt5       <= 0;
        cnt16      <= 0;
        rd_data_r  <= (others => '0');
        op_is_read <= '0';
        phyad_r    <= (others => '0');
        regad_r    <= (others => '0');
        wr_data_r  <= (others => '0');
        busy       <= '0';
      else
        case s is
          when S_IDLE =>
            busy <= '0';
            drive_low <= '0';
            if start = '1' then
              op_is_read <= op_read;
              phyad_r    <= phyad;
              regad_r    <= regad;
              wr_data_r  <= wr_data;

              if USE_PREAMBLE then
                cnt32 <= 32;
                s     <= S_PREAMBLE;
              else
                cnt2  <= 2;        -- ST
                s     <= S_ST;
              end if;
            end if;

          -- ===== PREAMBLE: 32 ones (we RELEASE the line for '1') =====
          when S_PREAMBLE =>
            -- Set up output during MDC low; latch/advance on MDC rising edge
            if mdc_fall = '1' then
              cur_bit   <= '1';    -- '1' => release line (no pull-down)
              drive_low <= '0';
            end if;
            if mdc_rise = '1' then
              cnt32 <= cnt32 - 1;
              if cnt32 = 1 then
                cnt2 <= 2;         -- next: ST
                s    <= S_ST;
              end if;
            end if;

          -- ===== ST field: "01" (MSB first => '0' then '1') =====
            when S_ST =>
            if mdc_fall = '1' then
                if cnt2 = 2 then           -- first ST bit (MSB)
                cur_bit   <= '0';
                drive_low <= '1';        -- open-drain: drive low for '0'
                else                       -- second ST bit (LSB)
                cur_bit   <= '1';
                drive_low <= '0';        -- release for '1'
                end if;
            end if;

            if mdc_rise = '1' then
                cnt2 <= cnt2 - 1;
                if cnt2 = 1 then
                cnt2 <= 2;
                s    <= S_OP;
                end if;
            end if;


          -- ===== OP field: "11" for READ, "10" for WRITE =====
          when S_OP =>
            if mdc_fall = '1' then
              if op_is_read = '1' then
                -- READ: "10"
                if cnt2 = 2 then cur_bit <= '1'; else cur_bit <= '0'; end if;
              else
                -- WRITE: "01"
                if cnt2 = 2 then cur_bit <= '0'; else cur_bit <= '1'; end if;
              end if;
              drive_low <= (not cur_bit) and '1';
            end if;
            if mdc_rise = '1' then
              cnt2 <= cnt2 - 1;
              if cnt2 = 1 then
                cnt5 <= 5; s <= S_PHY;
              end if;
            end if;

          -- ===== PHYAD (5 bits, MSB first) =====
          when S_PHY =>
            if mdc_fall = '1' then
              -- MSB first: bit index (4 downto 0)
              cur_bit   <= phyad_r(4 - (5 - cnt5));
              drive_low <= (not cur_bit) and '1';
            end if;
            if mdc_rise = '1' then
              cnt5 <= cnt5 - 1;
              if cnt5 = 1 then
                cnt5 <= 5; s <= S_REG;
              end if;
            end if;

          -- ===== REGAD (5 bits, MSB first) =====
          when S_REG =>
            if mdc_fall = '1' then
              cur_bit   <= regad_r(4 - (5 - cnt5));
              drive_low <= (not cur_bit) and '1';
            end if;
            if mdc_rise = '1' then
              cnt5 <= cnt5 - 1;
              if cnt5 = 1 then
                cnt2 <= 2; s <= S_TA;
              end if;
            end if;

          -- ===== TA (turnaround) =====
          -- WRITE: drive "10"
          -- READ : TA[0] = Z (release), TA[1] = 0 driven by PHY (we keep released)
          when S_TA =>
            if op_is_read = '1' then
              -- READ: release for both TA cycles
              if mdc_fall = '1' then
                drive_low <= '0';  -- Hi-Z
              end if;
              if mdc_rise = '1' then
                cnt2 <= cnt2 - 1;
                if cnt2 = 1 then
                  cnt16 <= 16; s <= S_DATA;  -- PHY will now drive data
                end if;
              end if;
            else
              -- WRITE: drive "10" (MSB first => '1' then '0')
              if mdc_fall = '1' then
                if cnt2 = 2 then cur_bit <= '1'; else cur_bit <= '0'; end if;
                drive_low <= (not cur_bit) and '1';
              end if;
              if mdc_rise = '1' then
                cnt2 <= cnt2 - 1;
                if cnt2 = 1 then
                  cnt16 <= 16; s <= S_DATA;
                end if;
              end if;
            end if;

          -- ===== DATA (16 bits, MSB first) =====
          when S_DATA =>
            if op_is_read = '1' then
              -- We sample MDIO on MDC rising edge (PHY drives)
              if mdc_rise = '1' then
                rd_data_r <= rd_data_r(14 downto 0) & mdio_i; -- shift left; MSB-first input
                cnt16 <= cnt16 - 1;
                if cnt16 = 1 then
                  s <= S_DONE;
                end if;
              end if;
              -- keep released (Hi-Z) throughout read data
              if mdc_fall = '1' then
                drive_low <= '0';
              end if;
            else
              -- WRITE: we drive each bit MSB-first
              if mdc_fall = '1' then
                cur_bit <= wr_data_r(15 - (16 - cnt16));
                drive_low <= (not cur_bit) and '1';
              end if;
              if mdc_rise = '1' then
                cnt16 <= cnt16 - 1;
                if cnt16 = 1 then
                  s <= S_DONE;
                end if;
              end if;
            end if;

          when S_DONE =>
            drive_low <= '0';   -- release line
            done      <= '1';
            s         <= S_IDLE;

        end case;
      end if;
    end if;
  end process;
end architecture;
