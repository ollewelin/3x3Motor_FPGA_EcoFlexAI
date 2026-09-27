library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity record_frame_bram_counted is
  generic (
    CLOCK_HZ        : integer := 100_000_000;  -- fabric clock
    BAUD            : integer := 115200;    -- UART baud
    WIDTH_PIX       : integer := 96;           -- ROI width (pixels)
    HEIGHT_LINES    : integer := 96;           -- ROI height (lines)
    PIXELS_PER_BEAT : integer := 4;            -- RAW10 on 64-bit bus => 4 px / beat
    GAP_MIN_CYCLES  : integer := 128;          -- idle VALID=0 cycles to separate lines
    CLEAR_CYCLES    : integer := 128;          -- CLEAR pulse length after frame
    AUTO_DUMP_UART  : boolean := true          -- dump BRAM after capture
  );
  port (
    clk         : in  std_logic;
    rst_n       : in  std_logic;

    -- MIPI RX (fabric side, CAM0)
    data64      : in  std_logic_vector(63 downto 0);
    valid       : in  std_logic;
    dtype       : in  std_logic_vector(5 downto 0);   -- should be 0x2B (RAW10) or 0x2A
    cnt         : in  std_logic_vector(3 downto 0);   -- pixels in this beat (we accept it but we *count* beats)

    -- optional flags (not required by this counted version)
    hsync       : in  std_logic_vector(3 downto 0);
    vsync       : in  std_logic_vector(3 downto 0);
    error_bus   : in  std_logic_vector(17 downto 0);

    -- control/status
    arm_i       : in  std_logic;                      -- pulse: arm for 1 frame
    armed_o     : out std_logic;
    capturing_o : out std_logic;
    done_o      : out std_logic;
    clear_o     : out std_logic;

    -- debug
    beats_line_o: out unsigned(15 downto 0);
    line_idx_o  : out unsigned(15 downto 0);
    words_used_o: out unsigned(31 downto 0);

    -- UART to FT2232 (TTL 3v3)
    uart_tx     : out std_logic
  );
end entity;

architecture rtl of record_frame_bram_counted is
  -- accept RAW8/RAW10
  constant DT_RAW8  : std_logic_vector(5 downto 0) := "101010"; -- 0x2A
  constant DT_RAW10 : std_logic_vector(5 downto 0) := "101011"; -- 0x2B

  -- computed sizes
  function ceil_div(a,b:integer)return integer is begin return (a+b-1)/b; end;
  constant BEATS_PER_LINE : integer := ceil_div(WIDTH_PIX, PIXELS_PER_BEAT);
  constant TOTAL_BEATS    : integer := BEATS_PER_LINE * HEIGHT_LINES;

  -- BRAM
  type ram_t is array(0 to TOTAL_BEATS-1) of std_logic_vector(63 downto 0);
  signal ram : ram_t;
  signal ram_data_debug : std_logic_vector(63 downto 0) := (others=>'0');

  -- FSM
  type st_t is (IDLE, ARMED, CAP_LINE, LINE_GAP, FRAME_DONE, DUMP);
  signal st : st_t := IDLE;

  -- counters
  signal px_in_line     : unsigned(15 downto 0) := (others=>'0');
  signal beat_in_line   : unsigned(15 downto 0) := (others=>'0');
  signal line_idx       : unsigned(15 downto 0) := (others=>'0');
  signal wr_addr        : unsigned(31 downto 0) := (others=>'0');
  signal gap_cnt        : unsigned(15 downto 0) := (others=>'0');

  -- clear pulse
  signal clear_cnt      : unsigned(15 downto 0) := (others=>'0');
  signal clear_pulse    : std_logic := '0';

  -- start condition: first good VALID beat starts capture
  signal good_dt        : std_logic;
  signal tx_busy_q  : std_logic := '1';               -- last-cycle copy
  signal tx_send_S : std_logic := '0'; 
  signal kick_first : std_logic := '0';               -- start-of-dump one-shot

  -- UART
  constant BAUD_DIV     : integer := integer(real(CLOCK_HZ)/real(BAUD) + 0.5);
  signal tx_busy_i        : std_logic := '0';
  signal tx_start_i       : std_logic := '0';
  signal tx_byte_i        : std_logic_vector(7 downto 0) := (others=>'0');
  signal dump_addr      : unsigned(31 downto 0) := (others=>'0');
  signal dump_byte_idx  : unsigned(2 downto 0)  := (others=>'0');
  signal dumping        : std_logic := '0';
  signal TEST_MODE : std_logic := '1';-- 1 =  Send only test pattern from addres
  signal ram_fill : std_logic := '1';--

  -- tiny UART TX
  component uart_tx_simple is
    generic ( CLOCK_HZ:integer; BAUD:integer );
    port (
      clk     : in  std_logic;
      rst_n   : in  std_logic;
      tx_start   : in  std_logic;
      tx_send_S : in  std_logic;      
      tx_data    : in  std_logic_vector(7 downto 0);
      tx_busy    : out std_logic;
      tx_busy_q : out std_logic;--pre tx_busy to detect edges
      txd      : out std_logic
    );
  end component;
begin
  good_dt <= '1' when (dtype=DT_RAW10 or dtype=DT_RAW8) else '0';

  -- exports
  beats_line_o <= beat_in_line;
  line_idx_o   <= line_idx;
  words_used_o <= wr_addr;
  armed_o      <= '1' when st=ARMED else '0';
  capturing_o  <= '1' when (st=CAP_LINE or st=LINE_GAP) else '0';
  clear_o      <= clear_pulse;

  -- MAIN FSM
  process(clk)
    variable w : std_logic_vector(63 downto 0);
  begin
    if rising_edge(clk) then
      kick_first     <= '0'; --default
      if rst_n='0' then
        st           <= IDLE;
        beat_in_line <= (others=>'0');
        line_idx     <= (others=>'0');
        wr_addr      <= (others=>'0');
        gap_cnt      <= (others=>'0');
        clear_cnt    <= (others=>'0');
        clear_pulse  <= '0';
        dumping      <= '0';
        dump_addr    <= (others=>'0');
        dump_byte_idx<= (others=>'0');
        tx_start_i     <= '0';
      else
        tx_start_i    <= '0';
        clear_pulse <= '0';

        case st is
          when IDLE =>
            if arm_i='1' and ram_fill = '0' then
              -- arm and wait for first good VALID beat
              beat_in_line <= (others=>'0');
              line_idx     <= (others=>'0');
              wr_addr      <= (others=>'0');
              st           <= ARMED;
            else
              if to_integer(wr_addr) < TOTAL_BEATS then
              ram(to_integer(wr_addr)) <= x"00000000" & std_logic_vector(wr_addr);
              wr_addr <= wr_addr + 1;
              else
                ram_fill <= '0';
                st           <= IDLE;
              end if;
            end if;

          when ARMED =>
            if valid='1' and good_dt='1' then
              -- first beat starts first line
              if to_integer(wr_addr) < TOTAL_BEATS then
          --      ram(to_integer(wr_addr)) <= data64;
           --     wr_addr                  <= wr_addr + 1;
              end if;
              beat_in_line <= beat_in_line + 1;
              st           <= CAP_LINE;
            end if;



            -- =============== CAP_LINE ===============
          when CAP_LINE =>
            -- valid payload only if VALID=1 AND CNT>0 AND type is RAW
            if valid='1' and good_dt='1' and unsigned(cnt) > 0 then
                if to_integer(wr_addr) < TOTAL_BEATS then

                    
--                ram(to_integer(wr_addr)) <= data64;


                if TEST_MODE='1' then
                  --ram(to_integer(wr_addr)) <= std_logic_vector(resize(wr_addr, 64));
           --       ram(to_integer(wr_addr)) <= x"00000000" & std_logic_vector(wr_addr);
                else
           --       ram(to_integer(wr_addr)) <= data64;
                end if;



          --      wr_addr                  <= wr_addr + 1;
                end if;
                beat_in_line <= beat_in_line + 1;
                px_in_line   <= px_in_line   + unsigned(cnt);
                gap_cnt      <= (others=>'0');  -- reset gap while data flows
            else
                -- treat VALID=0 or CNT=0 as idle for the gap detector
                if gap_cnt < to_unsigned(GAP_MIN_CYCLES, gap_cnt'length) then
                gap_cnt <= gap_cnt + 1;
                end if;
            end if;

            -- line âcompleteâ once we've ingested the requested pixels
            if px_in_line >= to_unsigned(WIDTH_PIX, px_in_line'length) then
                -- stop counting pixels; now wait a small idle gap so
                -- the next line won't glue to this one
                if gap_cnt >= to_unsigned(GAP_MIN_CYCLES, gap_cnt'length) then
                -- finalize line
                px_in_line   <= (others=>'0');
                beat_in_line <= (others=>'0');
                line_idx     <= line_idx + 1;
                gap_cnt      <= (others=>'0');

                if to_integer(line_idx)+1 >= HEIGHT_LINES then
                    st <= FRAME_DONE;
                else
                    st <= CAP_LINE;  -- continue with next line; first good beat re-enters logic above
                end if;
                end if;
            end if;

            -- =============== (no separate LINE_GAP state needed) ===============            


          when LINE_GAP =>
            -- wait for a small VALID=0 gap so next line won't glue
            if valid='0' then
              if to_integer(gap_cnt) < GAP_MIN_CYCLES then
                gap_cnt <= gap_cnt + 1;
              else
                st <= CAP_LINE; -- next line begins with next good VALID
              end if;
            else
              gap_cnt <= (others=>'0');
            end if;

          when FRAME_DONE =>
            -- optional CLEAR pulse to keep RX happy
            if to_integer(clear_cnt) < CLEAR_CYCLES then
              clear_cnt   <= clear_cnt + 1;
              clear_pulse <= '1';
            end if;

            if AUTO_DUMP_UART then
              dumping       <= '1';
              dump_addr     <= (others=>'0');
              dump_byte_idx <= (others=>'0');
              kick_first     <= '1';             -- arm the very first strobe
              st            <= DUMP;
            else
              st <= IDLE;
            end if;

          when DUMP =>
            if dumping='1' then
              if (tx_busy_q = '1' and tx_busy_i = '0') or (kick_first = '1') then
                tx_start_i <= '1';
                if kick_first = '1' then
                  tx_send_S <= '1';
                else
                  tx_send_S <= '0';
                  w := ram(to_integer(dump_addr));
                  ram_data_debug <= ram(to_integer(dump_addr));
                  case to_integer(dump_byte_idx) is
                    when 0 => tx_byte_i <= w(7  downto 0);
                    when 1 => tx_byte_i <= w(15 downto 8);
                    when 2 => tx_byte_i <= w(23 downto 16);
                    when 3 => tx_byte_i <= w(31 downto 24);
                    when 4 => tx_byte_i <= w(39 downto 32);
                    when 5 => tx_byte_i <= w(47 downto 40);
                    when 6 => tx_byte_i <= w(55 downto 48);
                    when others => tx_byte_i<= w(63 downto 56);
                  end case;
                  if dump_byte_idx = "111" then
                    dump_byte_idx <= (others=>'0');
                    if dump_addr + 1 = to_unsigned(TOTAL_BEATS, dump_addr'length) then
                      dumping <= '0';
                      st      <= IDLE;
                    else
                      dump_addr <= dump_addr + 1;
                    end if;
                  else
                    dump_byte_idx <= dump_byte_idx + 1;
                  end if;
                end if;
              end if;
            end if;


          when others =>
            st <= IDLE;
        end case;
      end if;
    end if;
  end process;

  -- "done" goes high during FRAME_DONE and DUMP (until IDLE)
  done_o <= '1' when (st=FRAME_DONE or st=DUMP) else '0';

  ------------------------------------------------------------------------------
  -- Tiny UART TX (8N1)
  ------------------------------------------------------------------------------
  uart_core: uart_tx_simple
    generic map ( CLOCK_HZ => CLOCK_HZ, BAUD => BAUD )
    port map   ( clk=>clk, rst_n=>rst_n, tx_start=>tx_start_i, tx_data=>tx_byte_i,
                 tx_busy=>tx_busy_i, tx_busy_q=>tx_busy_q, tx_send_S=>tx_send_S, txd=>uart_tx );
end architecture;


-- ========================================================================
-- UART TX (8N1) with ASCII-HEX formatter
--  - tx_start (1 clk pulse when tx_busy='0') kicks a transfer
--  - if tx_send_S='1'  => send 'S'
--  - else               => send ASCII hex of tx_data (two chars: HI then LO)
-- ========================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx_simple is
  generic (
    CLOCK_HZ  : integer := 100_000_000;
    BAUD      : integer := 115200;
    GAP_BITS  : integer := 0           -- extra idle bit-times between bytes (usually 0)
  );
  port (
    clk        : in  std_logic;
    rst_n      : in  std_logic;

    tx_start   : in  std_logic;                 -- 1-cycle strobe (only valid when tx_busy='0')
    tx_send_S  : in  std_logic;                 -- when '1' at tx_start, send 'S' instead of hex(data)
    tx_data    : in  std_logic_vector(7 downto 0);

    tx_busy    : out std_logic;                 -- high while sending 1 or 2 chars
    tx_busy_q  : out std_logic;                 -- 1-cycle delayed copy (for your upstream FSMs)
    txd        : out std_logic                  -- UART line (idle '1')
  );
end entity;

architecture rtl of uart_tx_simple is
  -- ---------------- Timing ----------------
  constant TICKS_PER_BIT : integer := (CLOCK_HZ + (BAUD/2)) / BAUD;   -- round nearest
  constant GAP_TICKS     : integer := GAP_BITS * TICKS_PER_BIT;

  -- ---------------- Helpers ----------------
  function hex_ascii(nib : std_logic_vector(3 downto 0)) return std_logic_vector is
    variable c : std_logic_vector(7 downto 0);
  begin
    case nib is
      when "0000" => c := x"30"; -- '0'
      when "0001" => c := x"31";
      when "0010" => c := x"32";
      when "0011" => c := x"33";
      when "0100" => c := x"34";
      when "0101" => c := x"35";
      when "0110" => c := x"36";
      when "0111" => c := x"37";
      when "1000" => c := x"38";
      when "1001" => c := x"39";
      when "1010" => c := x"41"; -- 'A'
      when "1011" => c := x"42"; -- 'B'
      when "1100" => c := x"43"; -- 'C'
      when "1101" => c := x"44"; -- 'D'
      when "1110" => c := x"45"; -- 'E'
      when others => c := x"46"; -- 'F'
    end case;
    return c;
  end function;

  -- ---------------- Byte sequencer ----------------
  type seq_t is array(0 to 1) of std_logic_vector(7 downto 0);  -- up to 2 bytes to send
  signal seq       : seq_t := (others => (others => '0'));
  signal seq_len   : integer range 0 to 2 := 0;  -- 1 or 2
  signal seq_idx   : integer range 0 to 2 := 0;

  -- ---------------- Bit engine (8N1) ----------------
  type st_t is (IDLE, PREPARE, GAP, START, DATA, STOP);
  signal st        : st_t := IDLE;

  signal shreg     : std_logic_vector(9 downto 0) := (others=>'1'); -- [stop(1) | data[7:0] | start(0)]
  signal bit_idx   : integer range 0 to 9 := 0;
  signal tick_cnt  : integer range 0 to TICKS_PER_BIT := 0;
  signal gap_cnt   : integer range 0 to GAP_TICKS := 0;

  signal busy_i    : std_logic := '0';
  signal busy_q_i  : std_logic := '1';
begin
  txd       <= shreg(0);
  tx_busy   <= busy_i;
  tx_busy_q <= busy_q_i;

  process(clk)
    variable hi : std_logic_vector(3 downto 0);
    variable lo : std_logic_vector(3 downto 0);
  begin
    if rising_edge(clk) then
      -- 1-cycle delayed busy for upstream logic (oscilloscope-friendly)
      busy_q_i <= busy_i;

      if rst_n = '0' then
        st       <= IDLE;
        shreg    <= (others=>'1');
        bit_idx  <= 0;
        tick_cnt <= 0;
        gap_cnt  <= 0;
        seq_len  <= 0;
        seq_idx  <= 0;
        busy_i   <= '0';

      else
        case st is
          when IDLE =>
            busy_i <= '0';
            if tx_start = '1' then
              -- Build the byte sequence to send
              if tx_send_S = '1' then
                seq(0)  <= x"53";  -- 'S'
                seq_len <= 1;
              else
                hi := tx_data(7 downto 4);
                lo := tx_data(3 downto 0);
                seq(0)  <= hex_ascii(hi);     -- first: high nibble
                seq(1)  <= hex_ascii(lo);     -- second: low nibble
                seq_len <= 2;
              end if;
              seq_idx  <= 0;
              busy_i   <= '1';
              st       <= PREPARE;
            end if;

          when PREPARE =>
            -- Optional inter-byte gap before each character (usually zero)
            if GAP_TICKS > 0 then
              gap_cnt  <= GAP_TICKS;
              st       <= GAP;
            else
              -- load first frame immediately
              shreg    <= '1' & seq(seq_idx) & '0';  -- stop + data + start
              bit_idx  <= 0;
              tick_cnt <= 0;
              st       <= START;
            end if;

          when GAP =>
            if gap_cnt = 0 then
              shreg    <= '1' & seq(seq_idx) & '0';
              bit_idx  <= 0;
              tick_cnt <= 0;
              st       <= START;
            else
              gap_cnt <= gap_cnt - 1;
            end if;

          when START =>
            -- hold start bit (LSB of shreg) for 1 bit time
            if tick_cnt = TICKS_PER_BIT-1 then
              tick_cnt <= 0;
              -- advance to first data bit next cycle
              shreg   <= '1' & shreg(9 downto 1);  -- shift right by 1 bit
              bit_idx <= 1;                        -- bit 0 already on the line
              st      <= DATA;
            else
              tick_cnt <= tick_cnt + 1;
            end if;

          when DATA =>
            if tick_cnt = TICKS_PER_BIT-1 then
              tick_cnt <= 0;
              if bit_idx = 9 then
                -- last shift put the stop bit on LSB
                st <= STOP;
              else
                shreg   <= '1' & shreg(9 downto 1);
                bit_idx <= bit_idx + 1;
              end if;
            else
              tick_cnt <= tick_cnt + 1;
            end if;

          when STOP =>
            if tick_cnt = TICKS_PER_BIT-1 then
              tick_cnt <= 0;
              -- finished one character
              if seq_idx + 1 < seq_len then
                seq_idx <= seq_idx + 1;
                -- optional inter-character gap
                if GAP_TICKS > 0 then
                  gap_cnt <= GAP_TICKS;
                  st      <= GAP;
                else
                  shreg    <= '1' & seq(seq_idx + 1) & '0';
                  bit_idx  <= 0;
                  st       <= START;
                end if;
              else
                -- whole request done
                busy_i <= '0';
                st     <= IDLE;
              end if;
            else
              tick_cnt <= tick_cnt + 1;
            end if;

        end case;
      end if;
    end if;
  end process;
end architecture;



-- ========================================================================
-- Minimal UART TX: 8N1
-- ========================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx_simple_byte is
  generic ( CLOCK_HZ:integer := 100_000_000; BAUD:integer := 115200 );
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    tx_start : in  std_logic;
    tx_data  : in  std_logic_vector(7 downto 0);
    tx_busy  : out std_logic;
    tx_busy_q : out std_logic;
    txd    : out std_logic
  );
end entity;

architecture rtl of uart_tx_simple_byte is
  constant DIV : integer := integer(real(CLOCK_HZ)/real(BAUD) + 0.5);
  signal divcnt : integer range 0 to DIV-1 := 0;
  signal bitcnt : integer range 0 to 9 := 0;
  signal shreg  : std_logic_vector(9 downto 0) := (others=>'1'); -- idle high
  signal busy_i : std_logic := '0';
  signal tx_hex_hi_char : std_logic_vector(7 downto 0);
  signal tx_hex_low_char : std_logic_vector(7 downto 0);

  signal uart_pause_cnt : unsigned(15 downto 0) := x"07FF";
begin
  tx_busy <= busy_i; 
  txd <= shreg(0);

  process(clk)
  begin
    if rising_edge(clk) then
      tx_busy_q <= busy_i;
      if rst_n='0' then
        divcnt <= 0; bitcnt <= 0; busy_i <= '0'; shreg <= (others=>'1');
        tx_busy_q <= '1';
      else
        if busy_i='0' then
          if tx_start='1' then
            shreg  <= '1' & tx_data & '0';  -- stop + data + start
            busy_i <= '1';
            divcnt <= 0; bitcnt <= 0;
            uart_pause_cnt <= x"07FF";
          end if;
        else
          if uart_pause_cnt > 0 then
            uart_pause_cnt <= uart_pause_cnt - 1;
          else
            if divcnt=DIV-1 then
              divcnt <= 0;
              shreg  <= '1' & shreg(9 downto 1);
              if bitcnt=9 then busy_i<='0'; bitcnt<=0; else bitcnt<=bitcnt+1; end if;
            else
              divcnt <= divcnt + 1;
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;
