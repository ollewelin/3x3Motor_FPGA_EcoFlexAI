library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_reg16_master_tb is
end entity;

architecture sim of i2c_reg16_master_tb is
  -- clock/reset
  signal clk    : std_logic := '0';
  signal rst_n  : std_logic := '0';

  -- I2C wired-AND lines (pull-ups antas i testbench)
  signal scl_line  : std_logic := '1';
  signal sda_line  : std_logic := '1';

  -- DUT I/O (ändra namn/bredd så de matchar din i2c_reg16_master.vhd)
  signal start_write16 : std_logic := '0';
  signal start_read16  : std_logic := '0';
  signal slave_addr7   : std_logic_vector(6 downto 0) := (others=>'0');
  signal reg_addr16    : std_logic_vector(15 downto 0) := (others=>'0');
  signal wr_len        : unsigned(2 downto 0) := (others=>'0');
  signal wr_data       : std_logic_vector(31 downto 0) := (others=>'0');
  signal rd_len        : unsigned(2 downto 0) := (others=>'0');
  signal rd_data       : std_logic_vector(31 downto 0);
  signal rd_valid      : std_logic;

  signal busy          : std_logic;
  signal done          : std_logic;
  signal ack_error     : std_logic;

  -- bitbanged pins från DUT (justera namn om din modul heter annorlunda)
  signal scl_out : std_logic;
  signal scl_oe  : std_logic;
  signal sda_out : std_logic;
  signal sda_oe  : std_logic;
  signal sda_in  : std_logic;

  -- TB:s slavmodell (PCA9542A)
  constant MUX_ADDR7 : std_logic_vector(6 downto 0) := "1110000"; -- 0x70
  signal mux_sda_drv : std_logic := '1';  -- slavens drivning (0=drive low, 1=release)
  signal ctrl_reg    : std_logic_vector(7 downto 0) := (others=>'0'); -- [7:6]=0, [5:4]=INT, [2:0]=B2..B0

  -- hjälpsignaler till slavens FSM
  type SSTATE is (S_IDLE, S_ADDR, S_ACK_ADDR, S_WR_BYTE, S_ACK_WR,
                  S_RD_BYTE, S_MACK_RD, S_STOP);
  signal ss           : SSTATE := S_IDLE;
  signal bit_cnt      : integer range 0 to 7 := 0;
  signal byte_shift   : std_logic_vector(7 downto 0) := (others=>'0');
  signal rw_read      : std_logic := '0';    -- 0=write, 1=read
  signal byte_num     : integer range 0 to 3 := 0; -- vi bryr oss om: [0]=reg_hi (ign), [1]=reg_lo (ign), [2]=control
  signal last_scl     : std_logic := '1';
  signal last_sda     : std_logic := '1';


  -- I2C bus wires (pull-ups modelleras bara som '1' när ingen drar lågt)





  
begin
  ---------------------------------------------------------------------------
  -- Klocka & reset
  ---------------------------------------------------------------------------
  clk <= not clk after 10 ns;  -- 50 MHz tb-klocka

  process
  begin
    rst_n <= '0';
    wait for 200 ns;
    rst_n <= '1';
    wait;
  end process;

  ---------------------------------------------------------------------------
  -- Koppla DUT till "bussen" (wired-AND med pull-up)
  -- scl_line drivs bara av master (slaven observerar).
  ---------------------------------------------------------------------------
  scl_line <= '0' when scl_oe='1' and scl_out='0' else '1';

  -- SDA är bidirektionell: master eller slav kan dra låg.
  sda_line <= '0' when ( (sda_oe='1' and sda_out='0') or (mux_sda_drv='0') ) else '1';

  -- mata tillbaka SDA till DUT
  sda_in <= sda_line;

  ---------------------------------------------------------------------------
  -- DUT-instans (ADJUST port map till dina portnamn)
  ---------------------------------------------------------------------------
  dut_inst : entity work.i2c_reg16_master
    port map (
      clk          => clk,
      rst_n        => rst_n,

      -- kommandogränssnitt
      start_write16 => start_write16,
      start_read16  => start_read16,
      slave_addr7   => slave_addr7,
      reg_addr16    => reg_addr16,
      wr_len        => wr_len,
      wr_data       => wr_data,
      rd_len        => rd_len,
      rd_data       => rd_data,
      rd_valid      => rd_valid,
      busy          => busy,
      done          => done,
      ack_error     => ack_error,

      -- fysiska linor
      scl_in => scl_line,     
      scl_out => scl_out,
      scl_oe  => scl_oe,
      sda_out => sda_out,
      sda_oe  => sda_oe,
      sda_in  => sda_line
    );

  ---------------------------------------------------------------------------
  -- SLAVMODELL: PCA9542A (mkt förenklad, bara det vi behöver)
  --  - Detekterar START/STOP (SDA-fall/rise medan SCL=1)
  --  - Skiftar in adress + data på SCL-rising
  --  - ACKar på 9:e klocken genom att dra SDA lågt
  --  - Vid write: tar emot 3 bytes: reg_hi (ign), reg_lo (ign), control(B2..B0)
  --  - Vid read: skickar ut ctrl_reg på SDA, släpper SDA för master-NACK
  ---------------------------------------------------------------------------
  slave_proc : process(clk)
    variable start_cond, stop_cond : boolean;
  begin
    if rising_edge(clk) then
      -- detektera nivåer på den riktiga bussen
      start_cond := (last_sda='1' and sda_line='0' and scl_line='1');
      stop_cond  := (last_sda='0' and sda_line='1' and scl_line='1');
      last_scl   <= scl_line;
      last_sda   <= sda_line;

      -- default: släpp SDA om vi inte explicit drar den låg
      if ss /= S_ACK_ADDR and ss /= S_ACK_WR and ss /= S_MACK_RD then
        mux_sda_drv <= '1';
      end if;

      case ss is
        when S_IDLE =>
          byte_num   <= 0;
          if start_cond then
            ss      <= S_ADDR;
            bit_cnt <= 7;
          end if;

        when S_ADDR =>
          -- skifta in på SCL rising
          if (last_scl='0' and scl_line='1') then
            byte_shift(bit_cnt) <= sda_line;
            if bit_cnt = 0 then
              -- färdig adressbyte (7b addr + R/W)
              rw_read <= byte_shift(0);
              if byte_shift(7 downto 1) = MUX_ADDR7 then
                ss <= S_ACK_ADDR;            -- ACK korrekt adress
              else
                -- fel adress: ignorera tills STOP
                ss <= S_STOP;
              end if;
            else
              bit_cnt <= bit_cnt - 1;
            end if;
          end if;

        when S_ACK_ADDR =>
          -- dra SDA låg under ACK-klocken
          mux_sda_drv <= '0';
          -- efter 9:e pulsen (SCL high->low): gå vidare
          if (last_scl='1' and scl_line='0') then
            if rw_read='0' then
              ss      <= S_WR_BYTE;
            else
              -- READ: förbered byte som ska skickas
              byte_shift <= ctrl_reg;       -- returnera kontrollregistret
              bit_cnt    <= 7;
              ss         <= S_RD_BYTE;
            end if;
          end if;

        when S_WR_BYTE =>
          if (last_scl='0' and scl_line='1') then
            byte_shift(bit_cnt) <= sda_line;
            if bit_cnt=0 then
              ss <= S_ACK_WR;
            else
              bit_cnt <= bit_cnt - 1;
            end if;
          end if;

        when S_ACK_WR =>
          mux_sda_drv <= '0'; -- ACKa mottagen byte
          if (last_scl='1' and scl_line='0') then
            -- latcha in vid slutet av ACK-cykeln
            if byte_num = 2 then
              -- detta är CONTROL-byten -> lagra B2..B0
              -- Vi speglar exakt vad som skrevs (INT-bitar hålls 0 i modellen)
              ctrl_reg <= (7=>'0',6=>'0',5=>'0',4=>'0',3=>'0',
                           2=>byte_shift(2), 1=>byte_shift(1), 0=>byte_shift(0));
            end if;
            byte_num <= byte_num + 1;
            if stop_cond then
              ss <= S_IDLE;
            else
              -- ta nästa byte (vi accepterar hur många som helst, men master sänder 3)
              bit_cnt <= 7;
              ss      <= S_WR_BYTE;
            end if;
          end if;

        when S_RD_BYTE =>
          -- skicka ut bitar MSB->LSB på SCL falling->rising (SDA stabil högperioden)
          if (last_scl='0' and scl_line='1') then
            -- håll SDA under HIGH-perioden
            mux_sda_drv <= '0' when byte_shift(bit_cnt) = '0' else '1';
            if bit_cnt=0 then
              ss <= S_MACK_RD;  -- vänta på master-ACK/NACK
            else
              bit_cnt <= bit_cnt - 1;
            end if;
          end if;

        when S_MACK_RD =>
          -- släpp SDA så master kan ACK/NACK:a
          mux_sda_drv <= '1';
          -- när SCL går low efter 9:e pulsen är transaktionen klar (vi stödjer endast 1 byte)
          if (last_scl='1' and scl_line='0') then
            ss <= S_STOP;
          end if;

        when S_STOP =>
          if stop_cond then
            ss <= S_IDLE;
          end if;
      end case;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- STIMULI: välj CAM0 via muxen (skriv B2..B0=100), läs tillbaka kontrollregistret
  ---------------------------------------------------------------------------
  stim : process
  begin
    wait until rst_n='1';
    wait for 500 ns;

    -- 1) Skriv mux kontroll = 0b100 (CH0 enable)
    slave_addr7 <= MUX_ADDR7;
    reg_addr16  <= x"0000";                 -- vår master skickar alltid 2 reg-bytes, mux ignorerar dem
    wr_len      <= to_unsigned(1, wr_len'length);  -- 1 databyte (kontroll)
    wr_data     <= x"000000" & x"04";       -- B2..B0 = 100 -> kanal 0
    start_write16 <= '1';
    wait until rising_edge(clk);
    start_write16 <= '0';

    -- vänta tills master är klar
    wait until busy='1';
    wait until busy='0';
    assert ack_error='0' report "Unexpected ACK error on MUX write" severity failure;

    -- 2) Läs tillbaka kontrollregistret (ska bli 0x04)
    rd_len       <= to_unsigned(1, rd_len'length);
    start_read16 <= '1';
    wait until rising_edge(clk);
    start_read16 <= '0';

    wait until rd_valid='1';
    assert rd_data(7 downto 0)=x"04"
      report "MUX readback mismatch (expected 0x04)" severity failure;

    -- DONE
    report "TB finished OK." severity note;
    wait;
  end process;

end architecture;
