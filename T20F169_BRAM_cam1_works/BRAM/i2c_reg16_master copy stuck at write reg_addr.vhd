library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ==========================================================
--  i2c_reg16_master.vhd
--  - Efinix-style pins (IN/OUT/OE), open-drain
--  - START/STOP, byte write/read with ACK/NACK
--  - Repeated-START 16-bit register read (reg_hi, reg_lo)
--  - Handles clock stretching by waiting for SCL_IN='1'
-- ==========================================================
entity i2c_reg16_master is
  generic (
    CLK_FREQ_HZ : integer := 128_000_000;     -- FPGA clk
    I2C_FREQ_HZ : integer := 100_000         -- 100kHz or 400kHz
  );
  port (
    clk     : in  std_logic;
    rst_n   : in  std_logic;

    -- Efinix tri-pin style I/O
    SCL_IN  : in  std_logic;
    SCL_OUT : out std_logic;                 -- drive '0' only
    SCL_OE  : out std_logic;                 -- '1' = drive, '0' = release
    SDA_IN  : in  std_logic;
    SDA_OUT : out std_logic;                 -- drive '0' only
    SDA_OE  : out std_logic;                 -- '1' = drive, '0' = release

    -- Command interface
    start_write16 : in  std_logic;           -- pulse 1 clk to start
    start_read16  : in  std_logic;           -- pulse 1 clk to start
    slave_addr7   : in  std_logic_vector(6 downto 0); -- e.g. IMX219 = "0010000" (0x10)
    reg_addr16    : in  std_logic_vector(15 downto 0);-- MSB first on bus

    wr_len        : in  unsigned(2 downto 0); -- 0..4 data bytes to write
    wr_data       : in  std_logic_vector(31 downto 0);-- [7:0] first data byte

    rd_len        : in  unsigned(2 downto 0); -- 1..4 data bytes to read
    rd_data       : out std_logic_vector(31 downto 0);
    rd_valid      : out std_logic;           -- pulses when transaction done and rd_data valid

    busy          : out std_logic;
    done          : out std_logic;           -- pulses 1 clk at end
    ack_error     : out std_logic            -- latched if any NACK seen
  );
end entity;

architecture rtl of i2c_reg16_master is
  -- timing
  constant DIV : integer := integer(CLK_FREQ_HZ / (I2C_FREQ_HZ * 4)); -- 4 phases per SCL
  signal tick         : std_logic := '0';
  signal div_cnt      : integer range 0 to DIV := 0;

  -- open-drain helpers: we only ever drive '0' (SDA_OUT/SCL_OUT='0')
  -- release = *_OE='0'
  -- pull low = *_OE='1'

  signal sda_pull_low : std_logic := '0';
  signal scl_pull_low : std_logic := '0';
  type st_t is (
    IDLE,
    -- start/stop
    GEN_START_A, GEN_START_B,
    GEN_STOP_A,  GEN_STOP_B,

    -- byte write with ACK sample
    BYTEW_SETUP, BYTEW_BITL, BYTEW_BITH, BYTEW_ACKL, BYTEW_ACKH,

    -- byte read with ACK/NACK drive
    BYTER_SETUP, BYTER_BITL, BYTER_BITH, BYTER_ACKL, BYTER_ACKH,

    -- high-level sequences
    W16_START, W16_ADDRW, W16_REGHI, W16_REGLO, W16_WBYTES, W16_STOP, W16_DONE,
    R16_START, R16_ADDRW, R16_REGHI, R16_REGLO,
    R16_REPSTART, R16_ADDRR, R16_RBYTES, R16_STOP, R16_DONE
  );

  signal st : st_t := IDLE;

  -- shared byte machinery
  signal tx_byte       : std_logic_vector(7 downto 0) := (others=>'0');
  signal rx_byte       : std_logic_vector(7 downto 0) := (others=>'0');
  signal bit_idx       : integer range 0 to 7 := 7;
  signal want_ack_out  : std_logic := '1'; -- '1' send ACK (SDA low) after read byte, '0' send NACK
  signal ack_sample    : std_logic := '1'; -- sampled ACK bit (0=ACK)

  -- command latches
  signal go_w, go_r    : std_logic := '0';
  signal slave_addr    : std_logic_vector(6 downto 0) := (others=>'0');
  signal reg_msb, reg_lsb : std_logic_vector(7 downto 0) := (others=>'0');
  signal wlen          : unsigned(2 downto 0) := (others=>'0');
  signal wdata         : std_logic_vector(31 downto 0) := (others=>'0');
  signal rlen          : unsigned(2 downto 0) := (others=>'0');

  -- progress counters
  signal wpos          : integer range 0 to 3 := 0;
  signal rpos          : integer range 0 to 3 := 0;

  -- outputs
  signal busy_i        : std_logic := '0';
  signal done_i        : std_logic := '0';
  signal ack_err_i     : std_logic := '0';
  signal rd_data_i     : std_logic_vector(31 downto 0) := (others=>'0');
  signal rd_valid_i    : std_logic := '0';

  -- helper flags
  signal scl_high      : std_logic;

  
begin
  busy      <= busy_i;
  done      <= done_i;
  ack_error <= ack_err_i;
  rd_data   <= rd_data_i;
  rd_valid  <= rd_valid_i;

  -- tick generator: 4 ticks per SCL period (low->high->sample->low)
  process(clk, rst_n)
  begin
    if rst_n='0' then
      tick    <= '0';
      div_cnt <= 0;
    elsif rising_edge(clk) then
      if div_cnt = DIV then
        div_cnt <= 0;
        tick    <= '1';
      else
        div_cnt <= div_cnt + 1;
        tick    <= '0';
      end if;
    end if;
  end process;

  scl_high <= SCL_IN; -- when released, slave can stretch; we wait for high
  SCL_OUT <= '0'; --Always 0 this gow high when SCL_OE = '0'
  SDA_OUT <= '0'; --Always 0 this gow high when SDA_OE = '0'

  -- ==========================================================
  --  Byte write / read sub-sequences (driven by 'st' states)
  -- ==========================================================
  process(clk, rst_n)
  begin
    if rst_n='0' then
      st <= IDLE;
      busy_i   <= '0';
      done_i   <= '0';
      ack_err_i<= '0';
      rd_valid_i <= '0';

      SDA_OE <= '0'; SCL_OE <= '0';
      tx_byte <= (others=>'0'); rx_byte <= (others=>'0');
      bit_idx <= 7; want_ack_out <= '1'; ack_sample <= '1';

      go_w <= '0'; go_r <= '0';
    elsif rising_edge(clk) then
      done_i     <= '0';
      rd_valid_i <= '0';

      case st is
        when IDLE =>
          SDA_OE <= '0'; SCL_OE <= '0';
          busy_i <= '0';
          if start_write16='1' then
            -- latch command
            slave_addr      <= slave_addr7;
            reg_msb  <= reg_addr16(15 downto 8);
            reg_lsb  <= reg_addr16(7 downto 0);
            wlen     <= wr_len;
            wdata    <= wr_data;
            rlen     <= (others=>'0');
            ack_err_i<= '0';
            busy_i   <= '1';
            st       <= W16_START;
          elsif start_read16='1' then
            slave_addr      <= slave_addr7;
            reg_msb  <= reg_addr16(15 downto 8);
            reg_lsb  <= reg_addr16(7 downto 0);
            wlen     <= (others=>'0');
            wdata    <= (others=>'0');
            rlen     <= rd_len;
            ack_err_i<= '0';
            busy_i   <= '1';
            st       <= R16_START;
          end if;

        -- ---------- START ----------
        when GEN_START_A =>
          -- while SCL high, pull SDA low
          if tick='1' then
            SCL_OE <= '0';
            SDA_OE <= '0';
            if scl_high='1' then
              SDA_OE <= '1';
              st <= GEN_START_B;
            end if;
          end if;

        when GEN_START_B =>
          if tick='1' then
            SCL_OE <= '1';   -- after START, pull SCL low to start bit clocking
            st <= BYTEW_SETUP; -- caller will set tx_byte beforehand
          end if;

        -- ---------- STOP ----------
        when GEN_STOP_A =>
          if tick='1' then
            -- ensure SDA low, then release SCL and wait high
            SDA_OE <= '1';
            SCL_OE <= '0';
            if scl_high='1' then
              st <= GEN_STOP_B;
            end if;
          end if;

        when GEN_STOP_B =>
          if tick='1' then
            -- with SCL high, release SDA to generate STOP
            SDA_OE <= '0';
            st <= IDLE;
            busy_i <= '0';
            done_i <= '1';
          end if;

        -- ---------- Write one byte then ACK sample ----------
        when BYTEW_SETUP =>
          if tick='1' then
            -- drive MSB first while SCL low
            if tx_byte(bit_idx)='0' then SDA_OE <= '1'; else SDA_OE <= '0'; end if;
            st <= BYTEW_BITL;
          end if;

        when BYTEW_BITL =>
          if tick='1' then
            SCL_OE <= '0';            -- rising edge (slave may stretch)
            if scl_high='1' then
              st <= BYTEW_BITH;
            end if;
          end if;

        when BYTEW_BITH =>
          if tick='1' then
            SCL_OE <= '1';                -- finish this bit
            if bit_idx=0 then
              -- prepare ACK cycle
              SDA_OE <= '0';          -- release SDA for slave ACK
              st <= BYTEW_ACKL;
            else
              bit_idx <= bit_idx-1;
              st <= BYTEW_SETUP;
            end if;
          end if;

        when BYTEW_ACKL =>
          if tick='1' then
            SCL_OE <= '0';
            if scl_high='1' then
              -- sample ACK while SCL high
              ack_sample <= SDA_IN;
              st <= BYTEW_ACKH;
            end if;
          end if;

        when BYTEW_ACKH =>
          if tick='1' then
            SCL_OE <= '1';
            -- ack_sample='0' means ACK (good)
            if ack_sample='1' then ack_err_i <= '1'; end if;
            -- return to caller: they move 'st' to next phase
            -- (we don't change state here)
          end if;

        -- ---------- Read one byte then we drive ACK/NACK ----------
        when BYTER_SETUP =>
          if tick='1' then
            SDA_OE <= '0';            -- we don't drive data during read
            bit_idx <= 7;
            st <= BYTER_BITL;
          end if;

        when BYTER_BITL =>
          if tick='1' then
            SCL_OE <= '0';
            if scl_high='1' then
              rx_byte(bit_idx) <= SDA_IN; -- sample
              st <= BYTER_BITH;
            end if;
          end if;

        when BYTER_BITH =>
          if tick='1' then
            SCL_OE <= '1';
            if bit_idx=0 then
              st <= BYTER_ACKL;
            else
              bit_idx <= bit_idx-1;
              st <= BYTER_BITL;
            end if;
          end if;

        when BYTER_ACKL =>
          if tick='1' then
            -- drive ACK(0) for more bytes, NACK(1) for last
            if want_ack_out='1' then SDA_OE <= '1'; else SDA_OE <= '1'; end if;
            SCL_OE <= '0';
            if scl_high='1' then
              st <= BYTER_ACKH;
            end if;
          end if;

        when BYTER_ACKH =>
          if tick='1' then
            SCL_OE <= '1';
            SDA_OE <= '0';
            -- return to caller
          end if;

        -- ======================================================
        --  High-level: WRITE 16 (addr MSB, addr LSB, data...)
        -- ======================================================
        when W16_START =>
          -- load first byte: SLA+W
          tx_byte <= std_logic_vector(slave_addr) & '0';
          bit_idx <= 7;
          st <= GEN_START_A;

        when W16_ADDRW =>
          if st=BYTEW_ACKH and tick='1' then
            tx_byte <= reg_msb; bit_idx<=7; st<=BYTEW_SETUP;
          elsif st=GEN_START_B then
            st <= BYTEW_SETUP; -- fallthrough from START
          end if;

        when W16_REGHI =>
          if st=BYTEW_ACKH and tick='1' then
            tx_byte <= reg_lsb; bit_idx<=7; st<=BYTEW_SETUP;
          end if;

        when W16_REGLO =>
          if st=BYTEW_ACKH and tick='1' then
            if wlen=0 then
              st <= W16_STOP;
            else
              -- first data byte is wdata[7:0]
              case wpos is
                when 0 => tx_byte <= wdata(7 downto 0);
                when 1 => tx_byte <= wdata(15 downto 8);
                when 2 => tx_byte <= wdata(23 downto 16);
                when others => tx_byte <= wdata(31 downto 24);
              end case;
              bit_idx<=7;
              st <= W16_WBYTES;
            end if;
          end if;

        when W16_WBYTES =>
          if st=BYTEW_ACKH and tick='1' then
            if wpos+1 < to_integer(wlen) then
              wpos   <= wpos + 1;
              case wpos+1 is
                when 1 => tx_byte <= wdata(15 downto 8);
                when 2 => tx_byte <= wdata(23 downto 16);
                when 3 => tx_byte <= wdata(31 downto 24);
                when others => tx_byte <= (others=>'0');
              end case;
              bit_idx<=7;
              st <= BYTEW_SETUP;
            else
              st <= W16_STOP;
            end if;
          end if;

        when W16_STOP =>
          if tick='1' then
            st <= GEN_STOP_A;
          end if;

        when W16_DONE =>
          null;

        -- ======================================================
        --  High-level: READ 16 (addr MSB/LSB, repeated START, read N)
        -- ======================================================
        when R16_START =>
          tx_byte <= std_logic_vector(slave_addr) & '0'; -- SLA+W
          bit_idx<=7;
          st <= GEN_START_A;

        when R16_ADDRW =>
          if st=BYTEW_ACKH and tick='1' then
            tx_byte <= reg_msb; bit_idx<=7; st<=BYTEW_SETUP;
          elsif st=GEN_START_B then
            st <= BYTEW_SETUP;
          end if;

        when R16_REGHI =>
          if st=BYTEW_ACKH and tick='1' then
            tx_byte <= reg_lsb; bit_idx<=7; st<=BYTEW_SETUP;
          end if;

        when R16_REGLO =>
          if st=BYTEW_ACKH and tick='1' then
            -- repeated START
            st <= R16_REPSTART;
          end if;

        when R16_REPSTART =>
          if tick='1' then
            -- generate START, then SLA+R
            st <= GEN_START_A;
            tx_byte <= std_logic_vector(slave_addr) & '1'; -- SLA+R
            bit_idx<=7;
          end if;

        when R16_ADDRR =>
          if st=BYTEW_ACKH and tick='1' then
            -- begin reading rlen bytes
            rpos <= 0;
            want_ack_out <= '1'; -- ACK all but last
            st <= BYTER_SETUP;
          elsif st=GEN_START_B then
            st <= BYTEW_SETUP;
          end if;

        when R16_RBYTES =>
          -- after BYTER_ACKH we?ve captured rx_byte
          if (st=BYTER_ACKH and tick='1') then
            -- store into rd_data_i (LSB-first packing)
            case rpos is
              when 0 => rd_data_i(7 downto 0)    <= rx_byte;
              when 1 => rd_data_i(15 downto 8)   <= rx_byte;
              when 2 => rd_data_i(23 downto 16)  <= rx_byte;
              when others => rd_data_i(31 downto 24) <= rx_byte;
            end case;

            if rpos+1 < to_integer(rlen) then
              rpos <= rpos + 1;
              want_ack_out <= '1';                     -- ACK
              st <= BYTER_SETUP;
            else
              -- last byte was just read, we NACKed it
              rd_valid_i <= '1';
              st <= R16_STOP;
            end if;
          end if;

        when R16_STOP =>
          if tick='1' then
            st <= GEN_STOP_A;
          end if;

        when R16_DONE =>
          null;

        -- ------------- state steering -------------
        when others =>
          st <= IDLE;
      end case;

      -- State chaining based on where we came from:
      -- (We steer to the right next state when sub-sequences finish)
      if tick='1' then
        case st is
          when GEN_START_B =>
            -- after START, BYTEW_SETUP will send whatever tx_byte holds,
            -- the caller?s next should be a *_ADDR/_REG/_DATA state
            null;

          when BYTEW_ACKH =>
            -- decide which high-level phase we?re in by looking at 'st'
            if busy_i = '1' then
              case st is
                -- write 16-bit register address (MSB then LSB)
                when W16_ADDRW      => st <= W16_REGHI;
                when W16_REGHI      => st <= W16_REGLO;
                when W16_REGLO      => st <= W16_WBYTES;   -- next we send data bytes
                when W16_WBYTES     => null;               -- handled elsewhere (stay until count done)

                -- read: first write the 16-bit register, then repeated-start and read
                when R16_ADDRW      => st <= R16_REGHI;
                when R16_REGHI      => st <= R16_REGLO;
                when R16_REGLO      => st <= R16_ADDRR;    -- issue repeated START + addr+R
                when R16_ADDRR      => null;               -- handled elsewhere

                -- anything else: do nothing here
                when others         => null;
              end case;
            end if;


          when GEN_STOP_B =>
            if busy_i='1' then
              done_i  <= '1';
              busy_i  <= '0';
              -- fall back to IDLE in next cycle
            end if;

          when BYTER_ACKH =>
            -- handled in R16_RBYTES
            null;

          when others => null;
        end case;
      end if;

      -- Drive defaults each cycle unless states change them
      if st=IDLE then
        SDA_OE <= '0'; SCL_OE <= '0';
      end if;
    end if;
  end process;
end architecture;
