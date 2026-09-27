library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_camera_i2c is
  port (
    clk                : in  std_logic;
    rst_n              : in  std_logic;

    -- interface from I2C_32_MASTER
    i2c_busy           : in  std_logic;
    mst_write_done     : in  std_logic;
    mst_data_out_valid : in  std_logic;
    mst_data_out       : in  std_logic_vector(31 downto 0);  -- widened to 32b

    -- interface to I2C_32_MASTER
    i2c_soft_rst       : out std_logic;
    i2c_slave_addr     : out std_logic_vector(7 downto 0);
    mst_command_byte   : out std_logic_vector(7 downto 0);
    mst_num_bytes      : out std_logic_vector(7 downto 0);
    mst_din            : out std_logic_vector(31 downto 0);
    mst_write          : out std_logic;
    mst_read           : out std_logic;

    -- control outputs
    cam_setup_cnt      : out integer range 0 to 1;
    done               : out std_logic
  );
end entity;

architecture rtl of control_camera_i2c is
  type state_t is (
    IDLE, SET_MUX, WAIT1,
    CAM_INIT1, WAIT2,
    CAM_INIT2, WAIT3,
    NEXT_CAM, FINISHED
  );
  signal state       : state_t := IDLE;
  signal cam_idx     : integer range 0 to 1 := 0;

  constant MUX_ADDR_8B  : std_logic_vector(7 downto 0) := x"E0"; -- 0x70<<1
  constant CAM_ADDR_8B  : std_logic_vector(7 downto 0) := x"20"; -- 0x10<<1 (placeholder)

  -- If/when you use reads: take the low byte as needed
  alias mst_data_out_low8 : std_logic_vector(7 downto 0) is mst_data_out(7 downto 0);

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
      done             <= '0';

    elsif rising_edge(clk) then
      -- defaults each cycle
      mst_write        <= '0';
      mst_read         <= '0';
      mst_command_byte <= x"00";   -- no sub-address byte used

      case state is
        when IDLE =>
          if i2c_busy = '0' then
            -- Select MUX channel (0x01 or 0x02)
            i2c_slave_addr <= MUX_ADDR_8B;
            mst_num_bytes  <= x"01";
            if cam_idx = 0 then
              mst_din     <= x"00000001";
            else
              mst_din     <= x"00000002";
            end if;
            mst_write     <= '1';
            state         <= WAIT1;
          end if;

        when WAIT1 =>
          if mst_write_done = '1' then
            state <= CAM_INIT1;
          end if;

        when CAM_INIT1 =>
          if i2c_busy = '0' then
            -- Reset: 0x0103 = 0x01
            i2c_slave_addr <= CAM_ADDR_8B;
            mst_num_bytes  <= x"03";       -- 16-bit reg + 8-bit data
            mst_din        <= x"00010301";   -- {addr_hi, addr_lo, data}
            mst_write      <= '1';
            state          <= WAIT2;
          end if;

        when WAIT2 =>
          if mst_write_done = '1' then
            state <= CAM_INIT2;
          end if;

        when CAM_INIT2 =>
          if i2c_busy = '0' then
            -- Stream on: 0x0100 = 0x01
            i2c_slave_addr <= CAM_ADDR_8B;
            mst_num_bytes  <= x"03";
            mst_din        <= x"00010001";
            mst_write      <= '1';
            state          <= WAIT3;
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

      -- Example placeholder if you later do reads:
      -- if mst_data_out_valid = '1' then
      --   -- use mst_data_out_low8 or full 32b word as needed
      -- end if;

    end if;
  end process;
end architecture;
