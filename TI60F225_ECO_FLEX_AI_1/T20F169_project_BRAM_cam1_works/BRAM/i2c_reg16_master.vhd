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
    reg_16bit     : in std_logic;-- 0 = only use LSB byte of reg_addr16. 1= use bothe

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
-- timing
constant DIV : integer := integer(CLK_FREQ_HZ / (I2C_FREQ_HZ*4));
signal div_cnt  : integer range 0 to DIV := 0;
signal tick     : std_logic := '0';
signal SCL_IN_SYNC0 : std_logic := '0'; 
signal SDA_IN_SYNC0 : std_logic := '0'; 
signal SCL_IN_SYNCED : std_logic := '0'; 
signal SDA_IN_SYNCED : std_logic := '0'; 
signal scl_high : std_logic;
-- control latches
signal go_w, go_r     : std_logic := '0';
-- byte machinery
signal tx_byte  : std_logic_vector(7 downto 0) := (others=>'0');
signal rx_byte  : std_logic_vector(7 downto 0) := (others=>'0');
signal bit_idx  : integer range 0 to 7 := 7;      -- 7..0
signal ack_bit  : std_logic := '1';
--signal want_ack : std_logic := '1';               -- ACK to slave after read (0=NACK last)
-- progress counters
signal wpos     : integer range 0 to 3 := 0;      -- written data bytes so far
signal rpos     : integer range 0 to 3 := 0;      -- read data bytes so far
signal byte_idx : unsigned(2 downto 0);
signal rw_read  : std_logic := '0';               -- 0=write flow, 1=read flow
-- status/outputs


type st_t is (
  IDLE,
  START_L, START_H,
  BYTEW_BITL, BYTEW_BITH, BYTEW_ACKL, BYTEW_ACKH,
  BYTER_BITL, BYTER_BITH, BYTER_ACKL, BYTER_ACKH,
  REPSTART_L, REPSTART_H,
  STOP_L, STOP_H, STOP_END, STOP_END_P1
);
signal st : st_t := IDLE;

function wr_byte_at(d : std_logic_vector(31 downto 0); i : integer)
  return std_logic_vector is
begin
  case i is
    when 0 => return d(7 downto 0);
    when 1 => return d(15 downto 8);
    when 2 => return d(23 downto 16);
    when 3 => return d(31 downto 24);
    when others => return (7 downto 0 => '0');
  end case;
end;


begin
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

  scl_high <= SCL_IN_SYNCED; -- when released, slave can stretch; we wait for high
  SCL_OUT <= '0'; --Always 0 this gow high when SCL_OE = '0'
  SDA_OUT <= '0'; --Always 0 this gow high when SDA_OE = '0'

  -- ==========================================================
  --  Byte write / read sub-sequences (driven by 'st' states)
  -- ==========================================================
  process(clk, rst_n)
  begin
    if rst_n='0' then
      st <= IDLE;
      busy   <= '0';
      done   <= '0';
      ack_error<= '0';
      rd_valid <= '0';
      byte_idx <= (others=>'0'); 
      SDA_OE <= '0'; 
      SCL_OE <= '0';
      tx_byte <= (others=>'0'); rx_byte <= (others=>'0');
      bit_idx <= 7; 
      --want_ack <= '1'; 
      ack_bit <= '1';
      go_w <= '0'; 
      go_r <= '0';
    elsif rising_edge(clk) then
      SCL_IN_SYNC0 <= SCL_IN;
      SDA_IN_SYNC0 <= SDA_IN;
      SCL_IN_SYNCED <= SCL_IN_SYNC0;
      SDA_IN_SYNCED <= SDA_IN_SYNC0;
      done     <= '0';
      rd_valid <= '0';

      case st is
        when IDLE =>
          -- bus released, nothing driving
          SDA_OE <= '0';
          SCL_OE <= '0';
          busy   <= '0';
          byte_idx <= (others=>'0'); 

          -- default per-cycle pulses
          if start_write16='1' then
            -- Latch command
            busy    <= '1';
            ack_error <= '0';
            rw_read   <= '0';
            wpos      <= 0;
            rpos      <= 0;
            -- First byte to send: address + W
            tx_byte    <= std_logic_vector(slave_addr7) & '0';
            bit_idx    <= 7;
            st         <= START_L;

          elsif start_read16='1' then
            busy    <= '1';
            ack_error <= '0';
            rw_read   <= '1';
            wpos      <= 0;
            rpos      <= 0;

            -- First pass is write: address + W (to send reg_msb/reg_lsb)
            tx_byte    <= std_logic_vector(slave_addr7) & '0';
            bit_idx    <= 7;
            st         <= START_L;
          end if;

        --------------------------------------------------------------------
        -- START condition
        --------------------------------------------------------------------
        when START_L =>
          if tick='1' then
            -- Ensure SCL released high first, then pull SDA low
            SCL_OE <= '0';-- release SCL = '1'
            SDA_OE <= '1';--SDA '0'
            st     <= START_H;
          end if;

        when START_H =>
          if tick='1' and scl_high='1' then
            -- drive START (SDA low while SCL high), then pull SCL low
            SDA_OE <= '1';--SDA '0'--SDA_OUT <= '0';
            SCL_OE  <= '1';
            st      <= BYTEW_BITL;
          end if;

        --------------------------------------------------------------------
        -- WRITE BYTE (address/reg/data) + ACK sample
        --------------------------------------------------------------------
        when BYTEW_BITL =>
          if tick='1' then
            SCL_OE  <= '1';               -- keep SCL low
            --SDA_OE  <= '1';               -- master drives SDA
            SDA_OE <= not(tx_byte(bit_idx));  -- present next bit
            st      <= BYTEW_BITH;
          end if;

        when BYTEW_BITH =>
          if tick='1' then
            SCL_OE <= '0';                -- release SCL -> goes high when not stretched
            if scl_high='1' then
              if bit_idx = 0 then
                st <= BYTEW_ACKL;
              else
                bit_idx <= bit_idx - 1;
                st      <= BYTEW_BITL;
              end if;
            end if;
          end if;

        when BYTEW_ACKL =>
          if tick='1' then
            SCL_OE <= '1';                -- pull SCL low
            SDA_OE <= '0';                -- release SDA so slave can ACK
            st     <= BYTEW_ACKH;
          end if;

        when BYTEW_ACKH =>
          if tick='1' then
            SCL_OE <= '0';                -- release SCL to sample ACK while high
            if scl_high='1' then
              ack_bit <= SDA_IN_SYNCED;          -- 0 = ACK, 1 = NACK
              if SDA_IN_SYNCED='1' then          -- any NACK -> flag
                ack_error <= '1';
             end if;

              bit_idx <= 7;
              byte_idx <= byte_idx + 1;
              st <= BYTEW_BITL;--default write bytes (if not st <= BYTER_BITL;--read bytes below)
              -- Chip address already done above with addr
              -- put out the reg_addr16
              -- then write bytes or read bytes
              if byte_idx = 0 then
                if reg_16bit = '1' then                
                  tx_byte <= reg_addr16(15 downto 8);--put out first byte in serie
                else
                  tx_byte <= reg_addr16(7 downto 0);--put out the single byte reg 
                end if;
              else
                --byte_idx = 1
                tx_byte <= reg_addr16(7 downto 0);--put out LSB 
              end if;   
              
              if (reg_16bit = '0' and byte_idx > 0) or (reg_16bit = '1' and byte_idx > 1) then
                -- Case C: write flow after reg_addr16(7 downto 0) -> payload or STOP
                if rw_read='0' then -- 0=write flow, 1=read flow
                  if to_integer(wr_len)=0 then
                    st <= STOP_L;
                  else
                    tx_byte <= wr_byte_at(wr_data, 0);
                    wpos    <= 0;
                    if wpos < to_integer(wr_len) then
                      wpos    <= wpos + 1;
                      tx_byte <= wr_byte_at(wr_data, wpos);
                      st      <= BYTEW_BITL;
                    else
                      st <= STOP_L;
                    end if;                  
                  end if;
                else
                  st <= BYTER_BITL;           
                end if;
              end if;
            end if;
          end if;
        --------------------------------------------------------------------
        -- Repeated START then address(R)
        --------------------------------------------------------------------
        when REPSTART_L =>
          if tick='1' then
            SCL_OE <= '0';                -- release SCL high
            SDA_OE <= '0';-- SDA_OUT <= '1';
            st     <= REPSTART_H;
          end if;

        when REPSTART_H =>
          if tick='1' and scl_high='1' then
            SDA_OE <= '1';--SDA_OUT <= '0';               -- repeated START (SDA low while SCL high)
            SCL_OE  <= '1';               -- pull SCL low for next byte
            tx_byte <= std_logic_vector(slave_addr7) & '1'; -- address + R
            bit_idx <= 7;
            st      <= BYTEW_BITL;        -- reuse writer to send addr(R) + ACK
          end if;

        --------------------------------------------------------------------
        -- READ BYTE (slave drives) + master ACK/NACK
        --------------------------------------------------------------------
        when BYTER_BITL =>
          if tick='1' then
            SCL_OE <= '1';                -- keep SCL low
            SDA_OE <= '0';                -- release; slave drives SDA
            st     <= BYTER_BITH;
          end if;

        when BYTER_BITH =>
          if tick='1' then
            SCL_OE <= '0';
            if scl_high='1' then
              rx_byte(bit_idx) <= SDA_IN_SYNCED;
              if bit_idx = 0 then
                st <= BYTER_ACKL;
              else
                bit_idx <= bit_idx - 1;
                st      <= BYTER_BITL;
              end if;
            end if;
          end if;

        when BYTER_ACKL =>
          if tick='1' then
            SCL_OE <= '1';
            -- ACK all but last, NACK the last
            if (rpos + 1) = to_integer(rd_len) then
              SDA_OE <= '0';              -- NACK (release)
            else
              SDA_OE <= '1'; --SDA_OUT <= '0'; -- ACK (drive 0)
            end if;
            st <= BYTER_ACKH;
          end if;

        when BYTER_ACKH =>
          if tick='1' then
            SCL_OE <= '0';
            if scl_high='1' then
              -- store byte into rd_data
              case rpos is
                when 0 => rd_data(7  downto 0 ) <= rx_byte;
                when 1 => rd_data(15 downto 8 ) <= rx_byte;
                when 2 => rd_data(23 downto 16) <= rx_byte;
                when 3 => rd_data(31 downto 24) <= rx_byte;
                when others => null;
              end case;

              if (rpos + 1) = to_integer(rd_len) then
                rd_valid <= '1';
                st <= STOP_L;
              else
                rpos    <= rpos + 1;
                bit_idx <= 7;
                st      <= BYTER_BITL;
              end if;
            end if;
          end if;

        --------------------------------------------------------------------
        -- STOP condition and finish
        --------------------------------------------------------------------
        when STOP_L =>--x"D"
          if tick='1' then
            -- SCL high, SDA low
            SCL_OE <= '1';
            SDA_OE <= '1'; 
            st     <= STOP_H;
          end if;

        when STOP_H =>--x"E"
          if tick='1' then
            SCL_OE  <= '0';-- SCL_OUT <= '0';
            SDA_OE <= '1'; --SDA_OUT <= '0';
            st      <= STOP_END;
          end if;
        when STOP_END =>--x"F"
          if tick='1' and scl_high='1' then
            -- release SDA high while SCL high => STOP
            SDA_OE <= '0';
            st      <= STOP_END_P1;
          end if;          
        when STOP_END_P1 =>--x"10"
          if tick='1' and SDA_IN_SYNCED='1' then
            busy  <= '0';
            done  <= '1';            
            st      <= IDLE;
          end if;               
        when others =>
          st <= IDLE;
        end case;
    end if;
  end process;
end architecture;
