library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_camera_i2c is
  port (
    clk                : in  std_logic;
    rst_n              : in  std_logic;

    -- from I2C_32_MASTER
    i2c_busy           : in  std_logic;
    mst_write_done     : in  std_logic;
    mst_data_out_valid : in  std_logic;
    mst_data_out       : in  std_logic_vector(31 downto 0);  -- 32b (master's width)

    -- to I2C_32_MASTER
    i2c_soft_rst       : out std_logic;
    i2c_slave_addr     : out std_logic_vector(7 downto 0);   -- 8-bit addr (includes R/W)
    mst_command_byte   : out std_logic_vector(7 downto 0);
    mst_num_bytes      : out std_logic_vector(7 downto 0);
    mst_din            : out std_logic_vector(31 downto 0);
    mst_write          : out std_logic;
    mst_read           : out std_logic;

    -- status / control
    cam_setup_cnt      : out integer range 0 to 1;
    mux_ok             : out std_logic;                       -- NEW: 1 if readback matched
    mux_val            : out std_logic_vector(7 downto 0);    -- NEW: readback value
    done               : out std_logic
  );
end entity;

architecture rtl of control_camera_i2c is
  type state_t is (
    IDLE,
    SET_MUX, WAIT_WMUX, READ_MUX, WAIT_RMUX, CHECK_MUX,
    CAM_INIT1, WAIT_W1,
    CAM_INIT2, WAIT_W2,
    NEXT_CAM, FINISHED
  );
  signal state       : state_t := IDLE;
  signal cam_idx     : integer range 0 to 1 := 0;

  constant MUX_ADDR_WR : std_logic_vector(7 downto 0) := x"E0"; -- 0x70<<1 | W
  constant MUX_ADDR_RD : std_logic_vector(7 downto 0) := x"E1"; -- 0x70<<1 | R
  constant CAM_ADDR_WR : std_logic_vector(7 downto 0) := x"20"; -- 0x10<<1 | W (placeholder)

  signal want_mux_byte : std_logic_vector(7 downto 0) := (others => '0'); -- what we wrote
  alias rb_data        : std_logic_vector(7 downto 0) is mst_data_out(7 downto 0);

begin
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      state            <= IDLE;
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

    elsif rising_edge(clk) then
      -- defaults each cycle
      mst_write        <= '0';
      mst_read         <= '0';
      mst_command_byte <= x"00";  -- no subaddr for mux

      case state is
        when IDLE =>
          if i2c_busy = '0' then
            -- Prepare mux selection byte
            if cam_idx = 0 then
              want_mux_byte <= x"01";   -- CAM0
            else
              want_mux_byte <= x"02";   -- CAM1
            end if;

            -- Write MUX control register (1 byte)
            i2c_slave_addr <= MUX_ADDR_WR;
            mst_num_bytes  <= x"01";
            mst_din        <= x"000000" & want_mux_byte;   -- pack at [7:0]
            mst_write      <= '1';
            state          <= WAIT_WMUX;
          end if;

        when WAIT_WMUX =>
          if mst_write_done = '1' then
            -- Now read back the same control byte from MUX
            i2c_slave_addr <= MUX_ADDR_RD;
            mst_num_bytes  <= x"01";
            mst_read       <= '1';
            state          <= WAIT_RMUX;
          end if;

        when WAIT_RMUX =>
          if mst_data_out_valid = '1' then
            mux_val <= rb_data;                   -- capture what we read
            state   <= CHECK_MUX;
          end if;

        when CHECK_MUX =>
          -- Compare readback with what we wrote
          if rb_data = want_mux_byte then
            mux_ok <= '1';
          else
            mux_ok <= '0';
          end if;
          -- proceed to camera writes anyway (you can gate on mux_ok if you prefer)
          state <= CAM_INIT1;

        when CAM_INIT1 =>
          if i2c_busy = '0' then
            -- Reset: 0x0103 = 0x01
            i2c_slave_addr <= CAM_ADDR_WR;
            mst_num_bytes  <= x"03";            -- 16b address + 8b data
            mst_din        <= x"00010301";      -- {00, 0x01, 0x03, 0x01}
            mst_write      <= '1';
            state          <= WAIT_W1;
          end if;

        when WAIT_W1 =>
          if mst_write_done = '1' then
            state <= CAM_INIT2;
          end if;

        when CAM_INIT2 =>
          if i2c_busy = '0' then
            -- Stream on: 0x0100 = 0x01
            i2c_slave_addr <= CAM_ADDR_WR;
            mst_num_bytes  <= x"03";
            mst_din        <= x"00010001";      -- {00, 0x01, 0x00, 0x01}
            mst_write      <= '1';
            state          <= WAIT_W2;
          end if;

        when WAIT_W2 =>
          if mst_write_done = '1' then
            state <= NEXT_CAM;
          end if;

        when NEXT_CAM =>
          if cam_idx = 0 then
            cam_idx       <= 1;
            cam_setup_cnt <= 1;
            state         <= IDLE;
          else
            state         <= FINISHED;
          end if;

        when FINISHED =>
          done <= '1';

        when others =>
          state <= IDLE;
      end case;
    end if;
  end process;
end architecture;
