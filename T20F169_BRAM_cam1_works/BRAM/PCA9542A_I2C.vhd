-- i2c_write1_byte.vhd : send one byte to 8b address (addr already includes R/W)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_write1_byte is
  generic (
    CLK_HZ  : natural := 50_000_000;
    I2C_HZ  : natural := 100_000
  );
  port (
    clk       : in  std_logic;
    rst_n     : in  std_logic;

    -- command
    start     : in  std_logic;                          -- pulse 1 clk to launch
    addr8     : in  std_logic_vector(7 downto 0);       -- e.g. x"E0" (write)
    data8     : in  std_logic_vector(7 downto 0);       -- payload byte

    busy      : out std_logic;
    ack_addr  : out std_logic;                          -- '0' = ACK, '1' = NACK
    ack_data  : out std_logic;                          -- '0' = ACK, '1' = NACK
    done      : out std_logic;

    -- open-drain pads (triad style)
    sda_in    : in  std_logic;
    sda_out   : out std_logic;  -- always '0' when driving
    sda_oe    : out std_logic;  -- 1=drive low, 0=release
    scl_out   : out std_logic;  -- always '0' when driving
    scl_oe    : out std_logic   -- 1=drive low, 0=release
  );
end entity;

architecture rtl of i2c_write1_byte is
  -- 4 phases per SCL bit: hold-SDA, drive-low, sample, release-high
  constant TQ      : natural := (CLK_HZ / (I2C_HZ * 4));
  type st_t is (IDLE, START_A, START_B,
                ADDR_BIT, ADDR_ACK,
                DATA_BIT, DATA_ACK,
                STOP_A, STOP_B, DONE);
  signal st        : st_t := IDLE;
  signal q         : natural := 0;
  signal bit_cnt   : integer range 0 to 7 := 7;
  signal sh        : std_logic_vector(7 downto 0) := (others=>'0');

  -- drive helpers
  procedure drive_scl_low is begin scl_out <= '0'; scl_oe <= '1'; end;
  procedure release_scl   is begin scl_out <= '0'; scl_oe <= '0'; end;
  procedure drive_sda_low is begin sda_out <= '0'; sda_oe <= '1'; end;
  procedure release_sda   is begin sda_out <= '0'; sda_oe <= '0'; end;

begin
  busy <= '1' when st /= IDLE and st /= DONE else '0';

  process(clk, rst_n)
  begin
    if rst_n='0' then
      st <= IDLE; q <= 0; bit_cnt <= 7;
      sh <= (others=>'0'); done <= '0';
      ack_addr <= '1'; ack_data <= '1';
      release_scl; release_sda;
    elsif rising_edge(clk) then
      done <= '0';
      case st is
        when IDLE =>
          release_scl; release_sda;
          if start='1' then
            sh      <= addr8; bit_cnt <= 7;
            st      <= START_A;
          end if;

        when START_A =>  -- SDA falls while SCL high
          release_scl; drive_sda_low;
          q <= 0; st <= START_B;

        when START_B =>
          if q = TQ then drive_scl_low; q <= 0; st <= ADDR_BIT;
          else q <= q + 1; end if;

        when ADDR_BIT =>
          -- put MSB first while SCL low
          if sh(bit_cnt)='0' then drive_sda_low; else release_sda; end if;
          if q = TQ then
            release_scl;                 -- SCL high: receiver samples
            q <= 0; st <= (bit_cnt=0) ? ADDR_ACK : ADDR_BIT;
            if bit_cnt>0 then bit_cnt <= bit_cnt-1; end if;
          else
            q <= q + 1;
          end if;
          -- fall back to low half
          if q = 0 then drive_scl_low; end if;

        when ADDR_ACK =>
          release_sda;                   -- release SDA for ACK
          if q = TQ then release_scl; q <= 0;
          elsif q = 2*TQ then ack_addr <= sda_in; drive_scl_low; q <= 0;  -- sample ACK
                            sh <= data8; bit_cnt <= 7; st <= DATA_BIT;
          else q <= q + 1; end if;

        when DATA_BIT =>
          if sh(bit_cnt)='0' then drive_sda_low; else release_sda; end if;
          if q = TQ then
            release_scl; q <= 0; st <= (bit_cnt=0) ? DATA_ACK : DATA_BIT;
            if bit_cnt>0 then bit_cnt <= bit_cnt-1; end if;
          else
            q <= q + 1;
          end if;
          if q = 0 then drive_scl_low; end if;

        when DATA_ACK =>
          release_sda;
          if q = TQ then release_scl; q <= 0;
          elsif q = 2*TQ then ack_data <= sda_in; drive_scl_low; q <= 0; st <= STOP_A;
          else q <= q + 1; end if;

        when STOP_A =>
          drive_sda_low;                 -- ensure SDA low
          if q = TQ then release_scl; q <= 0; st <= STOP_B;
          else q <= q + 1; end if;

        when STOP_B =>
          release_sda;                   -- SDA rises while SCL high
          done <= '1'; st <= DONE;

        when DONE =>
          -- hold one cycle for 'done' then go idle
          st <= IDLE;

      end case;
    end if;
  end process;
end architecture;
