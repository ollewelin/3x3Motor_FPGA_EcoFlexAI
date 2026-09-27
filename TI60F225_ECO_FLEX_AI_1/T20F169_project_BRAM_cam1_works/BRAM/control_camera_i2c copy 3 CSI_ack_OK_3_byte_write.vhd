library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_camera_i2c is
  generic (
    CLK_HZ        : natural := 50_000_000;  -- fabric clk
    TIMEOUT_US    : natural := 2000;        -- 2 ms timeout per phase
    PAUSE_US : natural := 30; 
    SOFTRST_US    : natural := 50           -- 50 us soft reset pulse
  );
  port (
    clk                : in  std_logic;
    rst_n              : in  std_logic;

    -- from I2C_32_MASTER
    i2c_busy           : in  std_logic;
    mst_write_done     : in  std_logic;
    mst_data_out_valid : in  std_logic;
    mst_data_out       : in  std_logic_vector(31 downto 0);  -- 32b bus

    -- to I2C_32_MASTER
    i2c_soft_rst       : out std_logic;
    i2c_slave_addr     : out std_logic_vector(7 downto 0);   -- 7-bit address in [6:0]
    mst_command_byte   : out std_logic_vector(7 downto 0);
    mst_num_bytes      : out std_logic_vector(7 downto 0);
    mst_din            : out std_logic_vector(31 downto 0);
    mst_write          : out std_logic;
    mst_read           : out std_logic;

    -- status / control
    cam_setup_cnt      : out integer range 0 to 1;
    mux_ok             : out std_logic;
    mux_val            : out std_logic_vector(7 downto 0);
    done               : out std_logic
  );
end entity;

architecture rtl of control_camera_i2c is
  ---------------------------------------------------------------------------
  -- Addressing
  -- Most Efinix masters use 7-bit I2C address; R/W comes from write/read.
  -- If your core expects 8-bit (addr<<1 | RW), change the two *_ADDR_7B
  -- constants to x"E0"/x"E1" (mux) and x"20" (cam write) accordingly.
  ---------------------------------------------------------------------------
  constant MUX_ADDR_7B_W  : std_logic_vector(7 downto 0) := x"E0"; -- 8-bit: 0xE0 LSB is ignored write
  constant MUX_ADDR_7B_R  : std_logic_vector(7 downto 0) := x"E1"; -- 8-bit: 0xE1 LSB is ignored read
  constant CAM_ADDR_7B  : std_logic_vector(7 downto 0) := x"20"; -- 8-bit: 0x10 (placeholder)
--  constant CAM_ADDR_7B  : std_logic_vector(7 downto 0) := x"10"; -- 8-bit: 0x10 (placeholder)
  --constant CAM_ADDR_7B  : std_logic_vector(7 downto 0) := x"20"; -- 8-bit: 0x10 (placeholder)
constant CAM_ADDR_WR  : std_logic_vector(7 downto 0) := x"20"; -- (0x10<<1)|0
constant CAM_ADDR_RD  : std_logic_vector(7 downto 0) := x"21"; -- (0x10<<1)|1
  ---------------------------------------------------------------------------
  -- Timing helpers
  ---------------------------------------------------------------------------
  -- Integer-safe timing math (no reals, no underscores)
  constant TICKS_PER_US : natural := CLK_HZ / 1000000;  -- truncates if not exact
  constant TIMEOUT_CYC  : natural := TICKS_PER_US * TIMEOUT_US;
  constant PAUSE_CYC  : natural := TICKS_PER_US * PAUSE_US;
  constant SOFTRST_CYC  : natural := TICKS_PER_US * SOFTRST_US;


  type state_t is (
    PWRUP_RST, PWRUP_WAIT,

    IDLE,
    MUX_PREP, MUX_W_PULSE, MUX_W_WAIT_BUSY, MUX_W_WAIT_DONE, MUX_PAUSE_TO_READBACK,
    MUX_R_PULSE, MUX_R_WAIT_BUSY, MUX_R_WAIT_VALID, MUX_CHECK,

    CAM_W1_PULSE, CAM_W1_WAIT_BUSY, CAM_W1_WAIT_DONE, CAM_W1_PAUSE,   -- 0x0103=0x01
    CAM_W2_PULSE, CAM_W2_WAIT_BUSY, CAM_W2_WAIT_DONE, CAM_W2_PAUSE,   -- 0x0100=0x01

    NEXT_CAM, FINISHED,
    RECOVER_RST, RECOVER_WAIT
  );
  signal state       : state_t := PWRUP_RST;
  signal cam_idx     : integer range 0 to 1 := 0;
  signal debug_state: std_logic_vector(7 downto 0) := (others => '0');
  signal test_cam_addr : unsigned(6 downto 0) := (others => '0');     
  signal want_mux_byte : std_logic_vector(7 downto 0) := (others => '0');
  alias  rb_data       : std_logic_vector(7 downto 0) is mst_data_out(7 downto 0);

  signal to_cnt      : natural := 0;     -- timeout counter
  signal sr_cnt      : natural := 0;     -- soft reset counter

begin
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      state            <= PWRUP_RST;
      cam_idx          <= 0;
      cam_setup_cnt    <= 0;

      i2c_soft_rst     <= '0';
      mst_write        <= '0';
      mst_read         <= '0';
      i2c_slave_addr   <= (others => '0');
      mst_command_byte <= (others => '0');
      mst_num_bytes    <= (others => '0');
      mst_din          <= (others => '0');

      mux_ok           <= '0';
      mux_val          <= (others => '0');
      done             <= '0';
      to_cnt           <= 0;
      sr_cnt           <= 0;

    elsif rising_edge(clk) then
      -- defaults


    if state = PWRUP_RST then
      debug_state <= x"00";
    end if;
    if state = PWRUP_WAIT then
      debug_state <= x"01";
    end if;
    if state = IDLE then
      debug_state <= x"02";
    end if;    
    if state = MUX_PREP then
      debug_state <= x"03";
    end if;
    if state = MUX_W_PULSE then
      debug_state <= x"04";
    end if;
    if state = MUX_W_WAIT_BUSY then
      debug_state <= x"05";
    end if;
    if state = MUX_W_WAIT_DONE then
      debug_state <= x"06";
    end if;
    if state = MUX_PAUSE_TO_READBACK then
      debug_state <= x"07";
    end if;
    if state = MUX_R_PULSE then
      debug_state <= x"08";
    end if;
    if state = MUX_R_WAIT_BUSY then
      debug_state <= x"09";
    end if;
    if state = MUX_R_WAIT_VALID then
      debug_state <= x"0A";
    end if;
    if state = MUX_CHECK then
      debug_state <= x"0B";
    end if;
    if state = CAM_W1_PULSE then
      debug_state <= x"0C";
    end if;
    if state = CAM_W1_WAIT_BUSY then
      debug_state <= x"0D";
    end if;
    if state = CAM_W1_WAIT_DONE then
      debug_state <= x"0E";
    end if;
    if state = CAM_W1_PAUSE then
      debug_state <= x"0F";
    end if;
    if state = CAM_W2_PULSE then
      debug_state <= x"10";
    end if;
    if state = CAM_W2_WAIT_BUSY then
      debug_state <= x"11";
    end if;
    if state = CAM_W2_WAIT_DONE then
      debug_state <= x"12";
    end if;
    if state = CAM_W2_PAUSE then
      debug_state <= x"13";
    end if;
    if state = NEXT_CAM then
      debug_state <= x"14";
    end if;
    if state = FINISHED then
      debug_state <= x"15";
    end if;
    if state = RECOVER_RST then
      debug_state <= x"16";
    end if;
    if state = RECOVER_WAIT then
      debug_state <= x"17";
    end if;



      mst_write        <= '0';
      mst_read         <= '0';
      -- === Impotant comment 1. below
      --mst_command_byte <= x"00";   -- no subaddr for mux or these cam regs. Note I remove this because otherwise I lost the settings information
      -- If I set mst_command_byte = x"04"; in the prepare state I will lose this when the next state occure where the execution mat_write pulse sets

      case state is
        ---------------------------------------------------------------------
        -- Power-up soft reset to the master
        ---------------------------------------------------------------------
        when PWRUP_RST =>
          i2c_soft_rst <= '1';
          sr_cnt       <= 0;
          state        <= PWRUP_WAIT;

        when PWRUP_WAIT =>
          if sr_cnt >= SOFTRST_CYC then
            i2c_soft_rst <= '0';
            state        <= IDLE;
          else
            sr_cnt <= sr_cnt + 1;
          end if;

        ---------------------------------------------------------------------
        -- MUX write then read-back
        ---------------------------------------------------------------------
        when IDLE =>
          if i2c_busy = '0' then
            want_mux_byte <= (others => '0');
            if cam_idx = 0 then
              want_mux_byte <= x"04";  -- CAM0
            else
              want_mux_byte <= x"05";  -- CAM1
            end if;
            state   <= MUX_PREP;
          end if;

        when MUX_PREP =>
          if i2c_busy = '0' then
            i2c_slave_addr <= MUX_ADDR_7B_W;
            --mst_num_bytes  <= x"01"; -- removed this set to 0 use the command byte instead for the MUX settings
            mst_num_bytes  <= x"04";
            mst_command_byte <= want_mux_byte;-- 
            mst_din        <= x"000000" & want_mux_byte ;  --Sends the want_mux_byte twice ieve if the PCA9542A onle need one byte (the control byte) Twice send bvecause the I2C_32_MASTER seems to stuck the SCL if mst_num_bytes < 2 .Dummy 32 bytes not used when mst_num_bytes = 0 or 1
            to_cnt         <= 0;
            state          <= MUX_W_PULSE;
          end if;

        when MUX_W_PULSE => --state = (4)
          mst_write <= '1';
          state     <= MUX_W_WAIT_BUSY;

        when MUX_W_WAIT_BUSY => --state = (5)
          if i2c_busy = '1' then
            to_cnt <= 0;
            state  <= MUX_W_WAIT_DONE;
          elsif to_cnt >= TIMEOUT_CYC then
            state  <= RECOVER_RST;
          else
            to_cnt <= to_cnt + 1;
          end if;

        when MUX_W_WAIT_DONE => --state = (6)
          if i2c_busy = '0' then
            -- start readback
            i2c_slave_addr <= MUX_ADDR_7B_R;
            mst_num_bytes  <= x"02";
            to_cnt         <= 0;
            state          <= MUX_PAUSE_TO_READBACK;
          elsif to_cnt >= TIMEOUT_CYC then
            state          <= RECOVER_RST;
          else
            to_cnt <= to_cnt + 1;
          end if;

        when MUX_PAUSE_TO_READBACK => --state = (7)        
          if to_cnt >= PAUSE_CYC then
            state          <= MUX_R_PULSE;
          else
            to_cnt <= to_cnt + 1;
          end if;
        when MUX_R_PULSE =>--state = (8) 
          mst_read <= '1';
          state    <= MUX_R_WAIT_BUSY;

        when MUX_R_WAIT_BUSY =>--state = (0x0A) 
          if i2c_busy = '1' then
            to_cnt <= 0;
            state  <= MUX_R_WAIT_VALID;
          elsif to_cnt >= TIMEOUT_CYC then
            state  <= RECOVER_RST;
          else
            to_cnt <= to_cnt + 1;
          end if;

        when MUX_R_WAIT_VALID =>--state = (0x0B) 
          if mst_data_out_valid = '1' then
            mux_val <= rb_data;
            state   <= MUX_CHECK;
          elsif to_cnt >= TIMEOUT_CYC then
            state   <= RECOVER_RST;
          else
            to_cnt <= to_cnt + 1;
          end if;

        when MUX_CHECK =>--state = (0x0C) 
          mux_ok <= '1' when rb_data = want_mux_byte else '0';
          -- proceed to camera init regardless (or gate on mux_ok if you want)
         state  <= CAM_W1_PULSE;
          --stop here

        ---------------------------------------------------------------------
        -- Camera writes: 0x0103=0x01 then 0x0100=0x01
        ---------------------------------------------------------------------
        when CAM_W1_PULSE =>--state = (0x0D) 
          if i2c_busy = '0' then
            i2c_slave_addr <= CAM_ADDR_7B;
            --i2c_slave_addr <= '0' & std_logic_vector(test_cam_addr);
            --mst_num_bytes  <= x"02";-- Get the ack worked
            mst_num_bytes  <= x"03";
            --mst_din        <= x"00010301";   -- {00, 0x01, 0x03, 0x01} note only last 2 byte used at mst_din here
            mst_din        <= x"00000103";   -- {00, 0x01, 0x03, 0x01} note only last 2 byte used at mst_din here
            mst_command_byte <= x"01";-- Note first of the 3 bytes are set here
            to_cnt         <= 0;
            mst_write      <= '1';
            state          <= CAM_W1_WAIT_BUSY;
          end if;

        when CAM_W1_WAIT_BUSY =>--state = (0x0D) 
          if i2c_busy = '1' then
            to_cnt <= 0;
            state  <= CAM_W1_PAUSE;
          elsif to_cnt >= TIMEOUT_CYC then
            state  <= RECOVER_RST;
          else
            to_cnt <= to_cnt + 1;
          end if;
--CAM_W1_PAUSE
        when CAM_W1_PAUSE => --state = (0x0F)         
          if to_cnt >= PAUSE_CYC then
            to_cnt <= 0;            
            state          <= CAM_W1_WAIT_DONE;
          else
            to_cnt <= to_cnt + 1;
          end if;

        when CAM_W1_WAIT_DONE =>--state = (0x0E) 
          if i2c_busy = '0' then
            state <= CAM_W2_PULSE;
          elsif to_cnt >= TIMEOUT_CYC then
            state <= RECOVER_RST;
          else
            to_cnt <= to_cnt + 1;
          end if;

        when CAM_W2_PULSE =>--state = (0x10)
         if i2c_busy = '0' then
            i2c_soft_rst <= '1';
            test_cam_addr <= test_cam_addr + 1;
            to_cnt         <= 0;
            state          <= CAM_W2_WAIT_BUSY;
          end if;

        --  if i2c_busy = '0' then
        --    i2c_slave_addr <= CAM_ADDR_7B;
        --    mst_num_bytes  <= x"04";
        --    --mst_din        <= x"00010001";   -- {00, 0x01, 0x00, 0x01} note only last 2 byte used at mst_din here
        --    mst_din        <= x"00000100";   -- {00, 0x01, 0x00, 0x01} note only last 2 byte used at mst_din here
        --    mst_command_byte <= x"01";-- Note first of the 3 bytes are set here            
        --    to_cnt         <= 0;
        --    mst_write      <= '1';
        --    state          <= CAM_W2_WAIT_BUSY;
        --  end if;

        when CAM_W2_WAIT_BUSY =>--state = (0x11)
          i2c_soft_rst <= '0';  
          if to_cnt >= PAUSE_CYC then
            to_cnt <= 0;
            state          <= CAM_W1_PULSE;
          else
            to_cnt <= to_cnt + 1;
          end if;

        --if i2c_busy = '1' then
          --  to_cnt <= 0;
          --  state  <= CAM_W2_PAUSE;
          --elsif to_cnt >= TIMEOUT_CYC then
          --  state  <= RECOVER_RST;
          --else
          --  to_cnt <= to_cnt + 1;
          --end if;
--CAM_W2_PAUSE
        when CAM_W2_PAUSE => --state = (0x13)         
          if to_cnt >= PAUSE_CYC then
            to_cnt <= 0;
            state          <= CAM_W2_WAIT_DONE;
          else
            to_cnt <= to_cnt + 1;
          end if;

        when CAM_W2_WAIT_DONE =>--state = (0x12)
          if i2c_busy = '0' then
            to_cnt <= 0;
            state <= NEXT_CAM;
          elsif to_cnt >= TIMEOUT_CYC then
            state <= RECOVER_RST;
          else
            to_cnt <= to_cnt + 1;
          end if;

        ---------------------------------------------------------------------
        -- Cam0 -> Cam1 -> Done
        ---------------------------------------------------------------------
        when NEXT_CAM =>--state = (0x14)
          if cam_idx = 0 then
            cam_idx       <= 1;
            cam_setup_cnt <= 1;
            state         <= IDLE;
          else
            state         <= FINISHED;
          end if;

        when FINISHED =>--state = (0x15)
          done <= '1';

        ---------------------------------------------------------------------
        -- Recovery path on any timeout: pulse soft reset to the I2C master
        -- and restart the sequence.
        ---------------------------------------------------------------------
        when RECOVER_RST =>--state = (0x16)
          i2c_soft_rst <= '1';
          sr_cnt       <= 0;
          state        <= RECOVER_WAIT;

        when RECOVER_WAIT =>--state = (0x17)
          if sr_cnt >= SOFTRST_CYC then
            i2c_soft_rst <= '0';
            state        <= IDLE;     -- retry from beginning
          else
            sr_cnt <= sr_cnt + 1;
          end if;

        when others =>
          state <= IDLE;
      end case;
    end if;
  end process;
end architecture;
