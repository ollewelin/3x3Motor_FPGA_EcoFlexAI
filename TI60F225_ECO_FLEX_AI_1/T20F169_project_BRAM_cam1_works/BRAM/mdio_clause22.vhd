-- mdio_clause22.vhd
-- IEEE 802.3 Clause 22 MDIO master (DP83825-compatible)
-- READ=10, WRITE=01 (MSB-first), proper TA (READ Z,0 / WRITE 1,0),
-- preamble (optional), outputs change on MDC low, sample on MDC rising.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mdio_clause22 is
  generic (
    CLK_FREQ_HZ  : natural := 50_000_000;  -- system clock (Hz)
    MDC_FREQ_HZ  : natural := 2_500_000;   -- target MDC (Hz)
    USE_PREAMBLE : boolean := true         -- send 32 ones before each frame
  );
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;                         -- sync, active-high

    -- command
    start   : in  std_logic;                         -- 1-clk pulse
    op_read : in  std_logic;                         -- 1=READ, 0=WRITE
    phyad   : in  std_logic_vector(4 downto 0);
    regad   : in  std_logic_vector(4 downto 0);
    wr_data : in  std_logic_vector(15 downto 0);
    rd_data : out std_logic_vector(15 downto 0);

    busy    : out std_logic;
    done    : out std_logic;                         -- 1-clk pulse

    -- MDIO pins (open-drain behavior)
    mdc     : out std_logic;
    mdio_i  : in  std_logic;                         -- from pad
    mdio_o  : out std_logic;                         -- always '0' (pull low only)
    mdio_oe : out std_logic                          -- 1=pull low, 0=Hi-Z
  );
end entity;

architecture rtl of mdio_clause22 is
  -- ===== MDC generator =====
  constant DIV : natural := integer(real(CLK_FREQ_HZ) / real(2*MDC_FREQ_HZ));
  signal divcnt     : unsigned(31 downto 0) := (others => '0');
  signal mdc_r      : std_logic := '0';
  signal mdc_r_prev : std_logic := '0';
  signal tick       : std_logic := '0';
  signal mdc_rise   : std_logic := '0';
  signal mdc_fall   : std_logic := '0';

  -- ===== FSM =====
  type state_t is (S_IDLE, S_PREAMBLE, S_ST, S_OP, S_PHY, S_REG, S_TA, S_DATA, S_DONE);
  signal s : state_t := S_IDLE;

  -- latched command
  signal op_is_read : std_logic := '0';
  signal phyad_r    : std_logic_vector(4 downto 0) := (others => '0');
  signal regad_r    : std_logic_vector(4 downto 0) := (others => '0');
  signal wr_data_r  : std_logic_vector(15 downto 0) := (others => '0');

  -- counters
  signal cnt32 : integer range 0 to 32 := 0;
  signal cnt2  : integer range 0 to 2  := 0;
  signal cnt5  : integer range 0 to 5  := 0;
  signal cnt16 : integer range 0 to 16 := 0;

  -- outputs / data
  signal rd_data_r : std_logic_vector(15 downto 0) := (others => '0');
  signal drive_low : std_logic := '0';              -- 1 = pull MDIO low (open-drain)
  signal busy_r    : std_logic := '0';
  signal done_r    : std_logic := '0';
begin
  -- pins
  mdc     <= mdc_r;
  mdio_o  <= '0';          -- we only ever pull low
  mdio_oe <= drive_low;

  rd_data <= rd_data_r;
  busy    <= busy_r;
  done    <= done_r;

  -- ===== MDC generator =====
  process(clk)
  begin
    if rising_edge(clk) then
      mdc_r_prev <= mdc_r;
      if rst = '1' then
        divcnt <= (others => '0');
        mdc_r  <= '0';
        tick   <= '0';
      else
        if divcnt = to_unsigned(DIV-1, divcnt'length) then
        --if divcnt = to_unsigned(40, 32) then
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

  mdc_rise <= '1' when (tick='1' and mdc_r='1' and mdc_r_prev='0') else '0';
  mdc_fall <= '1' when (tick='1' and mdc_r='0' and mdc_r_prev='1') else '0';

  -- ===== Main FSM =====
  process(clk)
    -- use variables so we can compute and commit within the cycle
    variable v_cnt32 : integer;
    variable v_cnt2  : integer;
    variable v_cnt5  : integer;
    variable v_cnt16 : integer;
    variable next_bit : std_logic;
  begin
    if rising_edge(clk) then
      done_r <= '0';

      if rst = '1' then
        s         <= S_IDLE;
        drive_low <= '0';
        busy_r    <= '0';
        rd_data_r <= (others => '0');
        cnt32 <= 0; cnt2 <= 0; cnt5 <= 0; cnt16 <= 0;
      else
        -- copy counters locally
        v_cnt32 := cnt32; v_cnt2 := cnt2; v_cnt5 := cnt5; v_cnt16 := cnt16;

        case s is
          when S_IDLE =>
            drive_low <= '0';
            busy_r    <= '0';
            if start = '1' then
              op_is_read <= op_read;
              phyad_r    <= phyad;
              regad_r    <= regad;
              wr_data_r  <= wr_data;

              busy_r     <= '1';
              if USE_PREAMBLE then
                v_cnt32 := 32;  s <= S_PREAMBLE;
              else
                v_cnt2  := 2;   s <= S_ST;
              end if;
            end if;

          -- PREAMBLE: 32 ones (release line)
          when S_PREAMBLE =>
            if mdc_fall = '1' then
              drive_low <= '0';
            end if;
            if mdc_rise = '1' then
              v_cnt32 := v_cnt32 - 1;
              if v_cnt32 = 0 then
                v_cnt2 := 2; s <= S_ST;
              end if;
            end if;

          -- START "01" (MSB-first: 0 then 1)
          when S_ST =>
            if mdc_fall = '1' then
              if v_cnt2 = 2 then next_bit := '0'; else next_bit := '1'; end if;
              if next_bit = '0' then drive_low <= '1'; else drive_low <= '0'; end if;
            end if;
            if mdc_rise = '1' then
              v_cnt2 := v_cnt2 - 1;
              if v_cnt2 = 0 then
                v_cnt2 := 2; s <= S_OP;
              end if;
            end if;

          -- OPCODE: READ="10" (1 then 0), WRITE="01" (0 then 1)
          when S_OP =>
            if mdc_fall = '1' then
              if op_is_read = '1' then
                if v_cnt2 = 2 then next_bit := '1'; else next_bit := '0'; end if;
              else
                if v_cnt2 = 2 then next_bit := '0'; else next_bit := '1'; end if;
              end if;
              if next_bit = '0' then drive_low <= '1'; else drive_low <= '0'; end if;
            end if;
            if mdc_rise = '1' then
              v_cnt2 := v_cnt2 - 1;
              if v_cnt2 = 0 then
                v_cnt5 := 5; s <= S_PHY;
              end if;
            end if;

          -- PHYAD (5 bits MSB-first)
          when S_PHY =>
            if mdc_fall = '1' then
              case v_cnt5 is
                when 5 => next_bit := phyad_r(4);
                when 4 => next_bit := phyad_r(3);
                when 3 => next_bit := phyad_r(2);
                when 2 => next_bit := phyad_r(1);
                when others => next_bit := phyad_r(0);
              end case;
              if next_bit = '0' then drive_low <= '1'; else drive_low <= '0'; end if;
            end if;
            if mdc_rise = '1' then
              v_cnt5 := v_cnt5 - 1;
              if v_cnt5 = 0 then
                v_cnt5 := 5; s <= S_REG;
              end if;
            end if;

          -- REGAD (5 bits MSB-first)
          when S_REG =>
            if mdc_fall = '1' then
              case v_cnt5 is
                when 5 => next_bit := regad_r(4);
                when 4 => next_bit := regad_r(3);
                when 3 => next_bit := regad_r(2);
                when 2 => next_bit := regad_r(1);
                when others => next_bit := regad_r(0);
              end case;
              if next_bit = '0' then drive_low <= '1'; else drive_low <= '0'; end if;
            end if;
            if mdc_rise = '1' then
              v_cnt5 := v_cnt5 - 1;
              if v_cnt5 = 0 then
                v_cnt2 := 2; s <= S_TA;
              end if;
            end if;

          -- TA: READ = Z,0 (we keep released both cycles). WRITE = "10" (1 then 0)
          when S_TA =>
            if op_is_read = '1' then
              if mdc_fall = '1' then
                drive_low <= '0';           -- release both TA bits
              end if;
              if mdc_rise = '1' then
                v_cnt2 := v_cnt2 - 1;
                if v_cnt2 = 0 then
                  v_cnt16 := 16; s <= S_DATA;
                end if;
              end if;
            else
              if mdc_fall = '1' then
                if v_cnt2 = 2 then next_bit := '1'; else next_bit := '0'; end if; -- "10"
                if next_bit = '0' then drive_low <= '1'; else drive_low <= '0'; end if;
              end if;
              if mdc_rise = '1' then
                v_cnt2 := v_cnt2 - 1;
                if v_cnt2 = 0 then
                  v_cnt16 := 16; s <= S_DATA;
                end if;
              end if;
            end if;

          -- DATA (16 bits MSB-first)
          when S_DATA =>
            if op_is_read = '1' then
              if mdc_rise = '1' then
                rd_data_r <= rd_data_r(14 downto 0) & mdio_i; -- D15 first
                v_cnt16 := v_cnt16 - 1;
                if v_cnt16 = 0 then
                  s <= S_DONE;
                end if;
              end if;
              if mdc_fall = '1' then
                drive_low <= '0';           -- keep released
              end if;
            else
              if mdc_fall = '1' then
                case v_cnt16 is
                  when 16 => next_bit := wr_data_r(15);
                  when 15 => next_bit := wr_data_r(14);
                  when 14 => next_bit := wr_data_r(13);
                  when 13 => next_bit := wr_data_r(12);
                  when 12 => next_bit := wr_data_r(11);
                  when 11 => next_bit := wr_data_r(10);
                  when 10 => next_bit := wr_data_r(9);
                  when 9  => next_bit := wr_data_r(8);
                  when 8  => next_bit := wr_data_r(7);
                  when 7  => next_bit := wr_data_r(6);
                  when 6  => next_bit := wr_data_r(5);
                  when 5  => next_bit := wr_data_r(4);
                  when 4  => next_bit := wr_data_r(3);
                  when 3  => next_bit := wr_data_r(2);
                  when 2  => next_bit := wr_data_r(1);
                  when others => next_bit := wr_data_r(0);
                end case;
                if next_bit = '0' then drive_low <= '1'; else drive_low <= '0'; end if;
              end if;
              if mdc_rise = '1' then
                v_cnt16 := v_cnt16 - 1;
                if v_cnt16 = 0 then
                  s <= S_DONE;
                end if;
              end if;
            end if;

          when S_DONE =>
            drive_low <= '0';
            busy_r    <= '0';
            done_r    <= '1';
            s         <= S_IDLE;

        end case;

        -- write back counters
        cnt32 <= v_cnt32; cnt2 <= v_cnt2; cnt5 <= v_cnt5; cnt16 <= v_cnt16;
      end if;
    end if;
  end process;

end architecture;
