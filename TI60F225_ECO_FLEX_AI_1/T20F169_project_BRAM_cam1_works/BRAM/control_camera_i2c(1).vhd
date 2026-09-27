library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_camera_i2c is
  port (
    clk              : in  std_logic;
    rst_n            : in  std_logic;

    -- interface to I2C_32_MASTER
    i2c_busy         : in  std_logic;
    mst_write_done   : in  std_logic;
    mst_data_out_valid : in std_logic;
    mst_data_out     : in std_logic_vector(7 downto 0);

    i2c_soft_rst     : out std_logic;
    i2c_slave_addr   : out std_logic_vector(7 downto 0);
    mst_command_byte : out std_logic_vector(7 downto 0);
    mst_num_bytes    : out std_logic_vector(7 downto 0);
    mst_din          : out std_logic_vector(31 downto 0);
    mst_write        : out std_logic;
    mst_read         : out std_logic;

    -- control outputs
    cam_setup_cnt    : out integer range 0 to 1;
    done             : out std_logic
  );
end entity;

architecture rtl of control_camera_i2c is
  type state_t is (IDLE, SET_MUX, WAIT1, CAM_INIT1, WAIT2, CAM_INIT2, WAIT3, NEXT_CAM, FINISHED);
  signal state       : state_t := IDLE;
  signal cam_idx     : integer range 0 to 1 := 0;

  constant MUX_ADDR_8B  : std_logic_vector(7 downto 0) := x"E0"; -- 0x70<<1
  constant CAM_ADDR_8B  : std_logic_vector(7 downto 0) := x"20"; -- 0x10<<1 (placeholder)

  procedure start_write(constant slave: in std_logic_vector(7 downto 0);
                        constant n    : in std_logic_vector(7 downto 0);
                        constant din  : in std_logic_vector(31 downto 0)) is
  begin
    i2c_slave_addr   <= slave;
    mst_command_byte <= x"00";
    mst_num_bytes    <= n;
    mst_din          <= din;
    mst_write        <= '1';
  end procedure;

begin
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      state          <= IDLE;
      cam_idx        <= 0;
      cam_setup_cnt  <= 0;
      mst_write      <= '0';
      mst_read       <= '0';
      i2c_soft_rst   <= '0';
      done           <= '0';
    elsif rising_edge(clk) then
      mst_write <= '0';
      mst_read  <= '0';

      case state is
        when IDLE =>
          if i2c_busy = '0' then
            -- Select MUX channel (0x01 or 0x02)
            if cam_idx = 0 then
              start_write(MUX_ADDR_8B, x"01", x"00000001");
            else
              start_write(MUX_ADDR_8B, x"01", x"00000002");
            end if;
            state <= WAIT1;
          end if;

        when WAIT1 =>
          if mst_write_done = '1' then
            state <= CAM_INIT1;
          end if;

        when CAM_INIT1 =>
          if i2c_busy = '0' then
            -- Reset example: 0x0103 = 0x01
            start_write(CAM_ADDR_8B, x"03", x"010301");
            state <= WAIT2;
          end if;

        when WAIT2 =>
          if mst_write_done = '1' then
            state <= CAM_INIT2;
          end if;

        when CAM_INIT2 =>
          if i2c_busy = '0' then
            -- Stream on: 0x0100 = 0x01
            start_write(CAM_ADDR_8B, x"03", x"010001");
            state <= WAIT3;
          end if;

        when WAIT3 =>
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
