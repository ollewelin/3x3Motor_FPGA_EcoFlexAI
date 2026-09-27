library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_camera_i2c is
  port (
    clk               : in  std_logic;
    rst_n             : in  std_logic;

    -- I2C master interface (I2C_32_MASTER)
    i2c_busy          : in  std_logic;
    mst_write_done     : in  std_logic;
    mst_data_out_valid: in  std_logic;
    mst_data_out      : in  std_logic_vector(31 downto 0);
    i2c_soft_rst      : out std_logic;
    i2c_slave_addr    : out std_logic_vector(7 downto 0);
    mst_command_byte  : out std_logic_vector(7 downto 0);
    mst_num_bytes     : out std_logic_vector(7 downto 0);
    mst_din           : out std_logic_vector(31 downto 0);
    mst_write         : out std_logic;
    mst_read          : out std_logic;
    mux_ok             : out std_logic;
    mux_val            : out std_logic_vector(7 downto 0);    

    -- status / progress
    cam_setup_cnt     : out integer range 0 to 1;
    done              : out std_logic
  );
end entity;

architecture rtl of control_camera_i2c is

  ---------------------------------------------------------------------------
  -- CONFIG (adjust as needed)
  ---------------------------------------------------------------------------
  constant CLK_HZ     : natural := 50_000_000;      -- << adjust to your system clock
  constant PAUSE_US   : natural := 30;              -- guard time before checking busy edges
  constant RESET_MS   : natural := 20;              -- conservative wait after 0x0103=0x01

  constant PAUSE_CYC  : natural := (CLK_HZ / 1_000_000) * PAUSE_US;
  constant RESET_CYC  : natural := (CLK_HZ / 1_000)    * RESET_MS;

  -- PCA9542A on your board (8-bit address byte)
  constant MUX_WR_8B  : std_logic_vector(7 downto 0) := x"E0"; -- write
  constant MUX_RD_8B  : std_logic_vector(7 downto 0) := x"E1"; -- read (unused here)
  constant MUX_CAM0   : std_logic_vector(7 downto 0) := x"04"; -- per your mapped channels
  constant MUX_CAM1   : std_logic_vector(7 downto 0) := x"05";

  -- IMX219 addresses (7-bit 0x10 => 8-bit)
  constant CAM_WR_8B  : std_logic_vector(7 downto 0) := x"20";
  constant CAM_RD_8B  : std_logic_vector(7 downto 0) := x"21";

  -- IMX219 registers (16-bit)
  constant REG_MODE_SEL_H  : std_logic_vector(7 downto 0) := x"01"; -- 0x0100
  constant REG_MODE_SEL_L  : std_logic_vector(7 downto 0) := x"00";
  constant REG_SW_RESET_H  : std_logic_vector(7 downto 0) := x"01"; -- 0x0103
  constant REG_SW_RESET_L  : std_logic_vector(7 downto 0) := x"03";
  constant REG_X_OUT_H     : std_logic_vector(7 downto 0) := x"01"; -- 0x016C/0x016D
  constant REG_X_OUT_L     : std_logic_vector(7 downto 0) := x"6C";
  constant REG_Y_OUT_H     : std_logic_vector(7 downto 0) := x"01"; -- 0x016E/0x016F
  constant REG_Y_OUT_L     : std_logic_vector(7 downto 0) := x"6E";

  -- Values
  constant V_STREAM_OFF    : std_logic_vector(7 downto 0) := x"00";
  constant V_STREAM_ON     : std_logic_vector(7 downto 0) := x"01";
--  constant V_ROI_PIX        : std_logic_vector(15 downto 0) := x"0060"; -- 96 decimal
  constant V_ROI_PIX        : std_logic_vector(15 downto 0) := x"00F1"; -- 241 decimal

  ---------------------------------------------------------------------------
  -- State machine
  ---------------------------------------------------------------------------
  type state_t is (
    PWRUP_RST, PWRUP_WAIT,

    MUX_SEL, MUX_WAIT_START, MUX_WAIT_DONE, MUX_GUARD,

    CAM_RESET_W, CAM_RESET_WAIT_START, CAM_RESET_WAIT_DONE, CAM_RESET_POST,

    CAM_RD0100_ADDRW, CAM_RD0100_WAIT_START, CAM_RD0100_WAIT_DONE,
    CAM_RD0100_RPULSE, CAM_RD0100_WAIT_DATA, CAM_RD0100_GUARD,

    CAM_ROI_WX, CAM_ROI_WX_WAIT_START, CAM_ROI_WX_WAIT_DONE, CAM_ROI_WX_GUARD,
    CAM_ROI_WY, CAM_ROI_WY_WAIT_START, CAM_ROI_WY_WAIT_DONE, CAM_ROI_WY_GUARD,

    CAM_STREAM_ON_W, CAM_STREAM_ON_WAIT_START, CAM_STREAM_ON_WAIT_DONE, CAM_STREAM_ON_GUARD,

    CAM_RD0100_ADDRW2, CAM_RD0100_WAIT_START2, CAM_RD0100_WAIT_DONE2,
    CAM_RD0100_RPULSE2, CAM_RD0100_WAIT_DATA2, CAM_RD0100_GUARD2,

    NEXT_CAM, FINISHED, READ_BACK_ROI_a, READ_BACK_ROI_b, READ_BACK_ROI_1, READ_BACK_ROI_2, READ_BACK_ROI_3, READ_BACK_ROI_4, READ_BACK_ROI_5
  );

  signal state        : state_t := PWRUP_RST;
  signal cam_idx      : integer range 0 to 1 := 0;

  -- timing guards
  signal tcnt         : natural := 0;

  -- latched read data
  signal last_mode    : std_logic_vector(7 downto 0) := (others => '0');
  signal last_mode_all_32_bits    : std_logic_vector(31 downto 0) := (others => '0');

  -- convenience
  function to_slv8(i: integer) return std_logic_vector is
  begin
    return std_logic_vector(to_unsigned(i, 8));
  end;

begin

  ---------------------------------------------------------------------------
  -- Main FSM
  ---------------------------------------------------------------------------
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      state           <= PWRUP_RST;
      cam_idx         <= 0;
      cam_setup_cnt   <= 0;
      done            <= '0';
      tcnt            <= 0;

      -- I2C defaults
      i2c_soft_rst    <= '0';
      i2c_slave_addr  <= (others => '0');
      mst_command_byte<= (others => '0');
      mst_num_bytes   <= (others => '0');
      mst_din         <= (others => '0');
      mst_write       <= '0';
      mst_read        <= '0';

      last_mode       <= (others => '0');

    elsif rising_edge(clk) then
      -- one-cycle pulses default low
      mst_write <= '0';
      mst_read  <= '0';

      case state is

        ---------------------------------------------------------------------
        -- Power-up soft reset of the I2C core (optional) + settle
        ---------------------------------------------------------------------
        when PWRUP_RST =>
          i2c_soft_rst <= '1';
          tcnt         <= 0;
          state        <= PWRUP_WAIT;

        when PWRUP_WAIT =>--state x"01"
          i2c_soft_rst <= '0';
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            state <= MUX_SEL;
          end if;

        ---------------------------------------------------------------------
        -- Select mux channel for CAM0/1
        ---------------------------------------------------------------------
        when MUX_SEL =>--state x"02"
          -- Write 1 byte to PCA9542A: control = 0x04 or 0x05
          i2c_slave_addr   <= MUX_WR_8B;
          --mst_command_byte <= (cam_idx = 0) ? MUX_CAM0 : MUX_CAM1;
          if cam_idx = 0 then
            mst_command_byte <= MUX_CAM0;
            mst_din        <= x"000000" & MUX_CAM0 ;
          else
            mst_command_byte <= MUX_CAM1;
            mst_din        <= x"000000" & MUX_CAM1 ;
          end if;          
          mst_num_bytes    <= x"02";               -- x"02" to x"04" working But notice x"01" or x"00" do'n't work out then the IP master will stuck
          mst_write        <= '1';
          tcnt             <= 0;
          state            <= MUX_WAIT_START;

        when MUX_WAIT_START =>--state x"03"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;                      -- guard before checking busy
          else
            if i2c_busy = '1' then                 -- started
              state <= MUX_WAIT_DONE;
            end if;
          end if;

        when MUX_WAIT_DONE =>--state x"04"
          if i2c_busy = '0' then                   -- finished
            tcnt  <= 0;
            state <= MUX_GUARD;
          end if;

        when MUX_GUARD =>--state x"05"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            state <= CAM_RESET_W;
          end if;

        ---------------------------------------------------------------------
        -- Sensor soft-reset: 0x0103 = 0x01
        ---------------------------------------------------------------------
        when CAM_RESET_W =>--state x"06"
          i2c_slave_addr   <= CAM_WR_8B;
          -- payload order: cmd, din[7:0], din[15:8]
          mst_command_byte <= REG_SW_RESET_H;         -- 0x01
          mst_din(7 downto 0)  <= REG_SW_RESET_L;     -- 0x03
          mst_din(15 downto 8) <= V_STREAM_ON;        -- 0x01
          mst_din(31 downto 16)<= (others => '0');
          mst_num_bytes    <= x"03";                  -- 3 payload bytes total
          mst_write        <= '1';
          tcnt             <= 0;
          state            <= CAM_RESET_WAIT_START;

        when CAM_RESET_WAIT_START =>--state x"07"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            if i2c_busy = '1' then
              state <= CAM_RESET_WAIT_DONE;
            end if;
          end if;

        when CAM_RESET_WAIT_DONE =>--state x"08"
          if i2c_busy = '0' then
            tcnt  <= 0;
            state <= CAM_RESET_POST;
          end if;

        when CAM_RESET_POST =>--state x"09"
          -- generous post-reset wait
          if tcnt < RESET_CYC then
            tcnt <= tcnt + 1;
          else
            state <= CAM_RD0100_ADDRW;
          end if;

        ---------------------------------------------------------------------
        -- Read 0x0100 (Mode Select) to confirm 0x00 after reset
        --   WRITE reg address (2 bytes), then READ 1 byte
        ---------------------------------------------------------------------
        when CAM_RD0100_ADDRW =>--state x"0A"
          i2c_slave_addr   <= CAM_WR_8B;
          mst_command_byte <= REG_MODE_SEL_H;        -- 0x01
          mst_din(7 downto 0)  <= REG_MODE_SEL_L;    -- 0x00
          mst_din(31 downto 8) <= (others => '0');
          mst_num_bytes    <= x"03";                 -- reg_hi + reg_lo
          mst_write        <= '1';
          tcnt             <= 0;
          state            <= CAM_RD0100_WAIT_START;

        when CAM_RD0100_WAIT_START =>--state x"0B"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            if i2c_busy = '1' then
              state <= CAM_RD0100_WAIT_DONE;
            end if;
          end if;

        when CAM_RD0100_WAIT_DONE =>--state x"0C"
          if i2c_busy = '0' then
            tcnt  <= 0;
            state <= CAM_RD0100_RPULSE;
          end if;

        when CAM_RD0100_RPULSE =>--state x"0D"
          i2c_slave_addr   <= CAM_RD_8B;
          mst_num_bytes    <= x"03";                 -- read 2 byte Note mst_num_bytes < 2 don't work 
          mst_read         <= '1';
          tcnt             <= 0;
          state            <= CAM_RD0100_WAIT_DATA;

        when CAM_RD0100_WAIT_DATA =>--state x"0E"
          if mst_data_out_valid = '1' then
            last_mode <= mst_data_out(7 downto 0);   -- expect 0x00
            tcnt      <= 0;
            state     <= CAM_RD0100_GUARD;
          end if;

        when CAM_RD0100_GUARD =>--state x"0F"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            state <= CAM_ROI_WX;
          end if;

        ---------------------------------------------------------------------
        -- Minimal ROI: set X/Y output size to 96 (0x0060)
        -- X: 0x016C (MSB), 0x016D (LSB)
        ---------------------------------------------------------------------
        when CAM_ROI_WX =>--state x"10"
          i2c_slave_addr   <= CAM_WR_8B;
          mst_command_byte <= REG_X_OUT_H;           -- 0x01
          mst_din(7 downto 0)  <= REG_X_OUT_L;       -- 0x6C
          mst_din(15 downto 8) <= V_ROI_PIX(7 downto 0); -- LSB 0x60
          mst_din(23 downto 16)<= V_ROI_PIX(15 downto 8);  -- MSB 0x00
          mst_din(31 downto 24)<= (others => '0');
          mst_num_bytes    <= x"03";                 -- 3 payload bytes: reg_hi, reg_lo, data_hi
          --mst_num_bytes    <= x"04";                 -- 3 payload bytes: reg_hi, reg_lo, data_hi
          -- NOTE: IMX219 expects two bytes of data for 16-bit registers.
          -- If your IP needs 4 payload bytes to get a clean STOP, set x"04"
          -- and put data_lo in mst_din(23:16), else keep x"03" and send as two writes.
          mst_write        <= '1';
          tcnt             <= 0;
          state            <= CAM_ROI_WX_WAIT_START;

        when CAM_ROI_WX_WAIT_START =>--state x"11"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            if i2c_busy = '1' then
              state <= CAM_ROI_WX_WAIT_DONE;
            end if;
          end if;

        when CAM_ROI_WX_WAIT_DONE =>--state x"12"
          if i2c_busy = '0' then
            tcnt  <= 0;
            state <= CAM_ROI_WX_GUARD;
          end if;

        when CAM_ROI_WX_GUARD =>--state x"13"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            state <= CAM_ROI_WY;
          end if;

        -- Y: 0x016E/0x016F = 96
        when CAM_ROI_WY =>--state x"14"
          i2c_slave_addr   <= CAM_WR_8B;
          mst_command_byte <= REG_Y_OUT_H;           -- 0x01
          mst_din(7 downto 0)  <= REG_Y_OUT_L;       -- 0x6E
          mst_din(15 downto 8) <= V_ROI_PIX(7 downto 0);
          mst_din(23 downto 16)<= V_ROI_PIX(15 downto 8);
          mst_din(31 downto 24)<= (others => '0');
          mst_num_bytes    <= x"03";
          mst_write        <= '1';
          tcnt             <= 0;
          state            <= CAM_ROI_WY_WAIT_START;

        when CAM_ROI_WY_WAIT_START =>--state x"15"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            if i2c_busy = '1' then
              state <= CAM_ROI_WY_WAIT_DONE;
            end if;
          end if;

        when CAM_ROI_WY_WAIT_DONE =>--state x"16"
          if i2c_busy = '0' then
            tcnt  <= 0;
            state <= CAM_ROI_WY_GUARD;
          end if;

        when CAM_ROI_WY_GUARD =>--state x"17"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            tcnt  <= 0;
            state <= READ_BACK_ROI_a;
          end if;

--================

        when READ_BACK_ROI_a =>--
          i2c_slave_addr   <= CAM_WR_8B;
          mst_command_byte <= REG_Y_OUT_H;           -- 0x01
          mst_din(7 downto 0)  <= REG_Y_OUT_L;       -- 0x6E
          mst_din(15 downto 8) <= V_ROI_PIX(7 downto 0);
          mst_din(23 downto 16)<= V_ROI_PIX(15 downto 8);
          mst_din(31 downto 24)<= (others => '0');
          mst_num_bytes    <= x"02";
          mst_write        <= '1';
          tcnt             <= 0;
          state            <= READ_BACK_ROI_b;

        when READ_BACK_ROI_b =>--
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            if i2c_busy = '1' then
              state <= READ_BACK_ROI_1;
            end if;
          end if;

        when READ_BACK_ROI_1 =>--state
          if i2c_busy = '0' then
            tcnt  <= 0;
            state <= READ_BACK_ROI_2;
          end if;

        when READ_BACK_ROI_2 =>--state
          i2c_slave_addr   <= CAM_RD_8B;
          --i2c_slave_addr   <= CAM_WR_8B;
          mst_din(15 downto 8) <= REG_Y_OUT_H;       -- 0x01
          mst_din(7 downto 0)  <= REG_Y_OUT_L;       -- 0x6E
          
          mst_num_bytes    <= x"03";                 -- read 2 byte Note mst_num_bytes < 2 don't work
          mst_read         <= '1';
          tcnt             <= 0;
          state            <= READ_BACK_ROI_3;

        when READ_BACK_ROI_3 =>--state
          if mst_data_out_valid = '1' then
            last_mode <= mst_data_out(7 downto 0);   -- expect 
            last_mode_all_32_bits <= mst_data_out(31 downto 0);
            tcnt      <= 0;
            state     <= READ_BACK_ROI_4;
          end if;

        when READ_BACK_ROI_4 =>--state x"17"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            state <= READ_BACK_ROI_5;
          end if;        
        when READ_BACK_ROI_5 =>--state x"17"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            state <= CAM_STREAM_ON_W;
          end if;  

--==========
        ---------------------------------------------------------------------
        -- Stream ON: 0x0100 = 0x01
        ---------------------------------------------------------------------
        when CAM_STREAM_ON_W =>--state x"18"
          i2c_slave_addr   <= CAM_WR_8B;
          mst_command_byte <= REG_MODE_SEL_H;        -- 0x01
          mst_din(7 downto 0)  <= REG_MODE_SEL_L;    -- 0x00
          mst_din(15 downto 8) <= V_STREAM_ON;       -- 0x01
          mst_din(31 downto 16)<= (others => '0');
          mst_num_bytes    <= x"03";                 -- reg_hi, reg_lo, data
          mst_write        <= '1';
          tcnt             <= 0;
          state            <= CAM_STREAM_ON_WAIT_START;

        when CAM_STREAM_ON_WAIT_START =>--state x"19"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            if i2c_busy = '1' then
              state <= CAM_STREAM_ON_WAIT_DONE;
            end if;
          end if;

        when CAM_STREAM_ON_WAIT_DONE =>--state x"1A"
          if i2c_busy = '0' then
            tcnt  <= 0;
            state <= CAM_STREAM_ON_GUARD;
          end if;

        when CAM_STREAM_ON_GUARD =>--state x"1B"
          if tcnt < (PAUSE_CYC * 4) then -- small extra settle
            tcnt <= tcnt + 1;
          else
            state <= CAM_RD0100_ADDRW2;
          end if;

        ---------------------------------------------------------------------
        -- Verify 0x0001 == 0x19
        ---------------------------------------------------------------------
        when CAM_RD0100_ADDRW2 =>--state x"1C"
          i2c_slave_addr   <= CAM_WR_8B;
          mst_command_byte <= x"00";
          mst_din(7 downto 0)  <= x"00";
          mst_din(31 downto 8) <= (others => '0');
          mst_num_bytes    <= x"02";
          mst_write        <= '1';
          tcnt             <= 0;
          state            <= CAM_RD0100_WAIT_START2;

        when CAM_RD0100_WAIT_START2 =>--state x"1D"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            if i2c_busy = '1' then
              state <= CAM_RD0100_WAIT_DONE2;
            end if;
          end if;

        when CAM_RD0100_WAIT_DONE2 =>--state x"1E"
          if i2c_busy = '0' then
            tcnt  <= 0;
            state <= CAM_RD0100_RPULSE2;
          end if;

        when CAM_RD0100_RPULSE2 =>--state x"1F"
          i2c_slave_addr   <= CAM_RD_8B;
          mst_num_bytes    <= x"03";                 -- read 2 byte Note mst_num_bytes < 2 don't work
          mst_read         <= '1';
          tcnt             <= 0;
          state            <= CAM_RD0100_WAIT_DATA2;

        when CAM_RD0100_WAIT_DATA2 =>--state x"20"
          if mst_data_out_valid = '1' then
            last_mode <= mst_data_out(7 downto 0);   -- expect 0x01
         --   last_mode_all_32_bits <= mst_data_out(31 downto 0);
            tcnt      <= 0;
            state     <= CAM_RD0100_GUARD2;
          end if;

        when CAM_RD0100_GUARD2 =>--state x"21"
          if tcnt < PAUSE_CYC then
            tcnt <= tcnt + 1;
          else
            state <= NEXT_CAM;
          end if;

        ---------------------------------------------------------------------
        -- Next camera (CAM0 -> CAM1) or finish
        ---------------------------------------------------------------------
        when NEXT_CAM =>
          if cam_idx = 0 then
            cam_idx       <= 1;
            cam_setup_cnt <= 1;
            state         <= MUX_SEL;
          else
            state         <= FINISHED;
          end if;

        when FINISHED =>
          done <= '1';

        when others =>
          state <= FINISHED;

      end case;
    end if;
  end process;

end architecture;
