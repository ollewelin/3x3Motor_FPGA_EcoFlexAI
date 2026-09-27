library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_camera_i2c is
  port (
    clk           : in  std_logic;
    rst_n         : in  std_logic;

    -- tie these to your i2c_reg16_master
    i2c_busy      : in  std_logic;
    i2c_done      : in  std_logic;
    i2c_ackerr    : in  std_logic;
    rd_valid      : in  std_logic;
    rd_data       : in  std_logic_vector(31 downto 0);

    start_write16 : out std_logic;
    start_read16  : out std_logic;
    slave_addr7   : out std_logic_vector(6 downto 0);
    reg_addr16    : out std_logic_vector(15 downto 0);
    reg_16bit     : out std_logic;-- 0 = only use LSB byte of reg_addr16. 1= use bothe
    wr_len        : out unsigned(2 downto 0);
    wr_data       : out std_logic_vector(31 downto 0);
    rd_len        : out unsigned(2 downto 0);

    -- status/debug
    cam_setup_cnt : out integer range 0 to 1;
    done          : out std_logic;
    debug_state   : out std_logic_vector(7 downto 0);
    debug_timer   : out unsigned(30 downto 0);

    -- optional: last readbacks
    chip_id_msb   : out std_logic_vector(7 downto 0);
    chip_id_lsb   : out std_logic_vector(7 downto 0);
    roi_w_lsb     : out std_logic_vector(7 downto 0);
    roi_w_msb     : out std_logic_vector(7 downto 0);
    roi_h_lsb     : out std_logic_vector(7 downto 0);
    roi_h_msb     : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of control_camera_i2c is

  ---------------------------------------------------------------------------
  -- Addresses and camera registers (IMX219 typical)
  ---------------------------------------------------------------------------
  -- PCA9542A 7-bit address: 0x70 (you previously used 0xE0 8-bit)
  constant MUX_ADDR7       : std_logic_vector(6 downto 0) := "1110000"; -- 0x70
  constant MUX_CAM0        : std_logic_vector(7 downto 0) := x"04";     -- your board mapping
  constant MUX_CAM1        : std_logic_vector(7 downto 0) := x"05";

  -- IMX219 7-bit I2C address
  constant CAM_ADDR7       : std_logic_vector(6 downto 0) := "0010000"; -- 0x10

  -- Common IMX219 registers used in your tests
  constant REG_SW_RESET    : std_logic_vector(15 downto 0) := x"0103";
 -- constant REG_MODE_SEL    : std_logic_vector(15 downto 0) := x"0100";  -- 0=standby, 1=stream
  constant REG_MODE_SEL    : std_logic_vector(15 downto 0) := x"0100";  -- 0=standby, 1=stream

  -- Output size (typical IMX219 registers; adjust if your mapping differs)
  -- NOTE: many IMX219 maps use 0x016C..0x0171 for output size; verify on your setup.

  --output image size (X-direction) Width of image data output from the sensor module Units: Pixels
  constant REG_OUT_X_SIZE_H : std_logic_vector(15 downto 0) := x"016C";-- 0x016C[3:0]x_output_size[11:8] output image size (X-direction) 
  constant REG_OUT_X_SIZE_L : std_logic_vector(15 downto 0) := x"016D";-- 0x016D[7:0]x_output_size[7:0] output image size (X-direction)
  constant REG_OUT_Y_SIZE_H : std_logic_vector(15 downto 0) := x"016E";
  constant REG_OUT_Y_SIZE_L : std_logic_vector(15 downto 0) := x"016F";

  -- Chip ID (MSB at 0x0000 = 0x02, LSB at 0x0001 = 0x19 typically)
  constant REG_CHIP_ID_MSB : std_logic_vector(15 downto 0) := x"0000";
  constant REG_CHIP_ID_LSB : std_logic_vector(15 downto 0) := x"0001";

  -- desired ROI size = 96 (0x0060)
  --constant ROI_RECT_XY          : std_logic_vector(15 downto 0) := x"03F1";
  constant ROI_RECT_XY          : std_logic_vector(15 downto 0) := x"0060";
  signal debug_ROI_LSB_X : std_logic_vector(7 downto 0) := x"00";

  ---------------------------------------------------------------------------
  -- State machine
  ---------------------------------------------------------------------------
  type st_t is (
    PWRUP,
    -- CAM0
    MUX0_SEL, 
    CAM0_ROI_X_LSB, CAM0_ROI_X_LSB_READ_BACK_S0, CAM0_ROI_X_LSB_READ_BACK_R, CAM0_ROI_X_MSB,
    CAM0_ROI_Y_LSB, CAM0_ROI_Y_MSB,
    CAM0_RESET_W, CAM0_RESET_WWAIT,
    CAM0_ROI_WX0, CAM0_ROI_WX0_W,
    CAM0_ROI_WX1, CAM0_ROI_WX1_W,
    CAM0_ROI_WY0, CAM0_ROI_WY0_W,
    CAM0_ROI_WY1, CAM0_ROI_WY1_W,
    CAM0_RD_ID0_PTR, CAM0_RD_ID0_PTRW, CAM0_RD_ID0_R, CAM0_RD_ID0_WAIT,
    CAM0_RD_ID1_PTR, CAM0_RD_ID1_PTRW, CAM0_RD_ID1_R, CAM0_RD_ID1_WAIT,
    CAM0_RD_W0_PTR,  CAM0_RD_W0_PTRW,  CAM0_RD_W0_R,  CAM0_RD_W0_WAIT,
    CAM0_RD_W1_PTR,  CAM0_RD_W1_PTRW,  CAM0_RD_W1_R,  CAM0_RD_W1_WAIT,
    CAM0_RD_H0_PTR,  CAM0_RD_H0_PTRW,  CAM0_RD_H0_R,  CAM0_RD_H0_WAIT,
    CAM0_RD_H1_PTR,  CAM0_RD_H1_PTRW,  CAM0_RD_H1_R,  CAM0_RD_H1_WAIT,
    CAM0_STREAMON_W, CAM0_STREAMON_WWAIT,

    -- CAM1
    MUX1_SEL, MUX1_WAIT,
    CAM1_RESET_W, CAM1_RESET_WWAIT,
    CAM1_ROI_WX0, CAM1_ROI_WX0_W,
    CAM1_ROI_WX1, CAM1_ROI_WX1_W,
    CAM1_ROI_WY0, CAM1_ROI_WY0_W,
    CAM1_ROI_WY1, CAM1_ROI_WY1_W,
    CAM1_STREAMON_W, CAM1_STREAMON_WWAIT,

    FINISHED
  );
  signal st : st_t := PWRUP;

  -- sticky/bookkeeping
  signal cam_idx        : integer range 0 to 1 := 0;

  -- drive defaults
  signal start_wr_i     : std_logic := '0';
  signal i2c_done_r_and_catch_i : std_logic := '0';
  signal i2c_done_delayed : std_logic := '0';
  signal done_delay_cnt   : unsigned(15 downto 0) := (others=>'0');
  constant default_delay_cnt_set   : unsigned(15 downto 0) := x"3200";
  signal start_rd_i     : std_logic := '0';
  signal slave_i        : std_logic_vector(6 downto 0) := (others=>'0');
  signal reg_i          : std_logic_vector(15 downto 0) := (others=>'0');
  signal wrlen_i        : unsigned(2 downto 0) := (others=>'0');
  signal wrdata_i       : std_logic_vector(31 downto 0) := (others=>'0');
  signal rdlen_i        : unsigned(2 downto 0) := (others=>'0');

  -- small helpers to pack 16-bit value into LSB-first data bytes
  function LSB8(v: std_logic_vector(15 downto 0)) return std_logic_vector is
  begin
    return v(7 downto 0);
  end;
  function MSB8(v: std_logic_vector(15 downto 0)) return std_logic_vector is
  begin
    return v(15 downto 8);
  end;

begin
  -- tie outs
  start_write16 <= start_wr_i;
  start_read16  <= start_rd_i;
  slave_addr7   <= slave_i;
  reg_addr16    <= reg_i;
  wr_len        <= wrlen_i;
  wr_data       <= wrdata_i;
  rd_len        <= rdlen_i;

  cam_setup_cnt <= cam_idx;

  -- debug_state (simple mapping)
  with st select debug_state <=
    x"00" when PWRUP,
    x"01" when MUX0_SEL,
    x"02" when CAM0_ROI_X_LSB,
    x"03" when CAM0_RESET_W,
    x"04" when CAM0_RESET_WWAIT,
    x"05" when CAM0_ROI_WX0,
    x"06" when CAM0_ROI_WX0_W,
    x"07" when CAM0_ROI_WX1,
    x"08" when CAM0_ROI_WX1_W,
    x"09" when CAM0_ROI_WY0,
    x"0A" when CAM0_ROI_WY0_W,
    x"0B" when CAM0_ROI_WY1,
    x"0C" when CAM0_ROI_WY1_W,
    x"0D" when CAM0_RD_ID0_PTR,
    x"0E" when CAM0_RD_ID0_PTRW,
    x"0F" when CAM0_RD_ID0_R,
    x"10" when CAM0_RD_ID0_WAIT,
    x"11" when CAM0_RD_ID1_PTR,
    x"12" when CAM0_RD_ID1_PTRW,
    x"13" when CAM0_RD_ID1_R,
    x"14" when CAM0_RD_ID1_WAIT,
    x"15" when CAM0_RD_W0_PTR,
    x"16" when CAM0_RD_W0_PTRW,
    x"17" when CAM0_RD_W0_R,
    x"18" when CAM0_RD_W0_WAIT,
    x"19" when CAM0_RD_W1_PTR,
    x"1A" when CAM0_RD_W1_PTRW,
    x"1B" when CAM0_RD_W1_R,
    x"1C" when CAM0_RD_W1_WAIT,
    x"1D" when CAM0_RD_H0_PTR,
    x"1E" when CAM0_RD_H0_PTRW,
    x"1F" when CAM0_RD_H0_R,
    x"20" when CAM0_RD_H0_WAIT,
    x"21" when CAM0_RD_H1_PTR,
    x"22" when CAM0_RD_H1_PTRW,
    x"23" when CAM0_RD_H1_R,
    x"24" when CAM0_RD_H1_WAIT,
    x"25" when CAM0_STREAMON_W,
    x"26" when CAM0_STREAMON_WWAIT,
    x"27" when MUX1_SEL,
    x"28" when MUX1_WAIT,
    x"29" when CAM1_RESET_W,
    x"2A" when CAM1_RESET_WWAIT,
    x"2B" when CAM1_ROI_WX0,
    x"2C" when CAM1_ROI_WX0_W,
    x"2D" when CAM1_ROI_WX1,
    x"2E" when CAM1_ROI_WX1_W,
    x"2F" when CAM1_ROI_WY0,
    x"30" when CAM1_ROI_WY0_W,
    x"31" when CAM1_ROI_WY1,
    x"32" when CAM1_ROI_WY1_W,
    x"33" when CAM1_STREAMON_W,
    x"34" when CAM1_STREAMON_WWAIT,
    x"FF" when others;


  -- latch readbacks
  process(clk, rst_n)
  begin
    if rst_n='0' then
      chip_id_msb <= (others=>'0');
      chip_id_lsb <= (others=>'0');
      roi_w_lsb   <= (others=>'0');
      roi_w_msb   <= (others=>'0');
      roi_h_lsb   <= (others=>'0');
      roi_h_msb   <= (others=>'0');
      slave_i     <= (others=>'0');
      reg_i       <= (others=>'0');
      wrlen_i     <= (others=>'0');
      wrdata_i    <= (others=>'0');
      rdlen_i     <= (others=>'0');      
      done        <= '0';
      st          <= PWRUP;
      cam_idx     <= 0;
      i2c_done_r_and_catch_i <= '0';
      done_delay_cnt <= default_delay_cnt_set;
    elsif rising_edge(clk) then
      -- default outs
      done <= '0';
      start_wr_i  <= '0';
      start_rd_i  <= '0';

      i2c_done_delayed <= '0';--default
      if start_wr_i = '1' or start_rd_i = '1' then
        i2c_done_r_and_catch_i <= '0';
      elsif i2c_done = '1' then
        i2c_done_r_and_catch_i <= '1';
      end if;
      if i2c_done_r_and_catch_i = '1' then
        if done_delay_cnt > 0 then 
          done_delay_cnt <= done_delay_cnt - 1;
        else
          i2c_done_r_and_catch_i <= '0';
          done_delay_cnt <= default_delay_cnt_set;
          i2c_done_delayed <= '1';
        end if;
      end if;

      


      case st is
        -------------------------------------------------------------------
        -- CAM0 path
        -------------------------------------------------------------------

--Notes data flow CAM 0 minimal
--state Reset: 0x01, 0x03, 0x01 stop
--state 0B: 0x01, 0x00, 0x00 stop
--state 11: 0x01, 0x6C, 0xF1 stop
--state 19: 0x01, 0x00, 0x01, stop
--

        when PWRUP =>
          -- Select CAM0 on mux (see NOTE: our i2c_reg16_master always sends two "reg bytes"
          -- before data; the PCA9542A will simply accept 0x00,0x00, then our control byte)
          if i2c_busy='0' then
            slave_i   <= MUX_ADDR7;
            reg_i     <= x"00" & MUX_CAM0;
            reg_16bit <= '0';
            wrlen_i   <= to_unsigned(0,3);           -- send 1 control byte (after the two 0x00)
            --wrdata_i  <= x"000000" & MUX_CAM0;
            wrdata_i  <= x"00000000";
            start_wr_i<= '1';
            cam_idx   <= 0;
            st        <= MUX0_SEL;
            debug_timer <= (others => '0'); 
            
          end if;

        when MUX0_SEL =>
          if i2c_done_delayed='1' then
            reg_16bit <= '1';-- do 16bit reg, 2 control bytes
            -- Reset: 0x0103 = 0x01
            if i2c_ackerr='0' then
              null;
            end if;
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_SW_RESET;
            wrlen_i    <= to_unsigned(1,3);
            wrdata_i   <= x"00000001";
            start_wr_i <= '1';
            st         <= CAM0_RESET_W;
            done_delay_cnt <= x"FFFF";
          end if;

        when CAM0_RESET_W =>
          if i2c_done_delayed='1' then
        ---------------------------------------------------------------------
        -- Write 0x0001 (Mode Select) to confirm 0x00 after reset
        --   WRITE reg address (2 bytes)
        ---------------------------------------------------------------------
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_MODE_SEL;
            wrlen_i    <= to_unsigned(1,3);
            wrdata_i   <= x"00000000";
            start_wr_i <= '1';
            st         <= CAM0_ROI_X_LSB;
            done_delay_cnt <= x"FFFF";
          end if;

        when CAM0_ROI_X_LSB =>
          if i2c_done_delayed='1' then
            -- ROI width = example 96 (LSB)
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_OUT_X_SIZE_L;
            wrlen_i    <= to_unsigned(1,3);-- Datasheet say one byte data
            wrdata_i   <= x"000000" & LSB8(ROI_RECT_XY); -- send LSB then MSB via two writes (see note below)
            start_wr_i <= '1';
            st         <= CAM0_ROI_X_LSB_READ_BACK_S0;  
            st         <= CAM0_ROI_X_MSB;
          end if;        
        when CAM0_ROI_X_LSB_READ_BACK_S0 =>
          if i2c_done_delayed='1' then
            slave_i    <= CAM_ADDR7;
            rdlen_i    <= to_unsigned(1,3);
            start_rd_i <= '1';
            st         <= CAM0_ROI_X_LSB_READ_BACK_R;
          end if;
        when CAM0_ROI_X_LSB_READ_BACK_R =>
          if rd_valid='1' then
            debug_ROI_LSB_X <= rd_data(7 downto 0);
            st         <= CAM0_ROI_X_MSB;
        end if;          

        when CAM0_ROI_X_MSB =>
          if i2c_done_delayed='1' then
            -- ROI width = example 96 (LSB)
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_OUT_X_SIZE_H;
            wrlen_i    <= to_unsigned(1,3);-- Datasheet say one byte data
            wrdata_i   <= x"000000" & MSB8(ROI_RECT_XY); -- send LSB then MSB via two writes (see note below)
            start_wr_i <= '1';
            st         <= CAM0_ROI_Y_LSB;          
          end if;            
            
        when CAM0_ROI_Y_LSB =>
          if i2c_done_delayed='1' then
            -- ROI width = example 96 (LSB)
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_OUT_Y_SIZE_L;
            wrlen_i    <= to_unsigned(1,3);-- Datasheet say one byte data
            wrdata_i   <= x"000000" & LSB8(ROI_RECT_XY); -- send LSB then MSB via two writes (see note below)
            start_wr_i <= '1';
            st         <= CAM0_ROI_Y_MSB;
          end if;            

        when CAM0_ROI_Y_MSB =>
          if i2c_done_delayed='1' then
            -- ROI width = example 96 (LSB)
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_OUT_Y_SIZE_H;
            wrlen_i    <= to_unsigned(1,3);-- Datasheet say one byte data
            wrdata_i   <= x"000000" & MSB8(ROI_RECT_XY); -- send LSB then MSB via two writes (see note below)
            start_wr_i <= '1';
  
            st         <=CAM0_STREAMON_W;             
          end if;













        when CAM0_ROI_WX0 =>
          if i2c_done_delayed='1' then
            -- ROI height = 96 (016E,016F)
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_OUT_Y_SIZE_L;
            wrlen_i    <= to_unsigned(2,3);
            wrdata_i   <= x"0000" & MSB8(ROI_RECT_XY) & LSB8(ROI_RECT_XY);
            start_wr_i <= '1';
            st         <= CAM0_ROI_WY0;
          end if;

        when CAM0_ROI_WY0 =>
          if i2c_done_delayed='1' then
            -- Read chip ID MSB @0x0000
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_CHIP_ID_MSB;
            wrlen_i    <= to_unsigned(0,3);  -- write pointer only
            start_wr_i <= '1';
            st         <= CAM0_RD_ID0_PTR;
          end if;

        when CAM0_RD_ID0_PTR =>
          if i2c_done_delayed='1' then
            slave_i     <= CAM_ADDR7;
            rdlen_i     <= to_unsigned(1,3);
            start_rd_i  <= '1';              -- repeated START + read 1
            st          <= CAM0_RD_ID0_R;
          end if;

        when CAM0_RD_ID0_R =>
          if rd_valid='1' then
            chip_id_msb <= rd_data(7 downto 0);
            -- Read chip ID LSB @0x0001
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_CHIP_ID_LSB;
            wrlen_i    <= to_unsigned(0,3);
            start_wr_i <= '1';
            st         <= CAM0_RD_ID1_PTR;
          end if;

        when CAM0_RD_ID1_PTR =>
          if i2c_done_delayed='1' then
            slave_i    <= CAM_ADDR7;
            rdlen_i    <= to_unsigned(1,3);
            start_rd_i <= '1';
            st         <= CAM0_RD_ID1_R;
          end if;

        when CAM0_RD_ID1_R =>
          if rd_valid='1' then
            chip_id_lsb <= rd_data(7 downto 0);
            -- verify ROI width LSB @0x016C
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_OUT_X_SIZE_L;
            wrlen_i    <= to_unsigned(0,3);
            start_wr_i <= '1';
            st         <= CAM0_RD_W0_PTR;
          end if;

        when CAM0_RD_W0_PTR =>
          if i2c_done_delayed='1' then
            slave_i    <= CAM_ADDR7;
            rdlen_i    <= to_unsigned(1,3);
            start_rd_i <= '1';
            st         <= CAM0_RD_W0_R;
          end if;

        when CAM0_RD_W0_R =>
          if rd_valid='1' then
            roi_w_lsb <= rd_data(7 downto 0);
            -- read width MSB @0x016D
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_OUT_X_SIZE_H;
            wrlen_i    <= to_unsigned(0,3);
            start_wr_i <= '1';
            st         <= CAM0_RD_W1_PTR;
          end if;

        when CAM0_RD_W1_PTR =>
          if i2c_done_delayed='1' then
            slave_i    <= CAM_ADDR7;
            rdlen_i    <= to_unsigned(1,3);
            start_rd_i <= '1';
            st         <= CAM0_RD_W1_R;
          end if;

        when CAM0_RD_W1_R =>
          if rd_valid='1' then
            roi_w_msb <= rd_data(7 downto 0);
            -- read height LSB @0x016E
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_OUT_Y_SIZE_L;
            wrlen_i    <= to_unsigned(0,3);
            start_wr_i <= '1';
            st         <= CAM0_RD_H0_PTR;
          end if;

        when CAM0_RD_H0_PTR =>
          if i2c_done_delayed='1' then
            slave_i    <= CAM_ADDR7;
            rdlen_i    <= to_unsigned(1,3);
            start_rd_i <= '1';
            st         <= CAM0_RD_H0_R;
          end if;

        when CAM0_RD_H0_R =>
          if rd_valid='1' then
            roi_h_lsb <= rd_data(7 downto 0);
            -- read height MSB @0x016F
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_OUT_Y_SIZE_H;
            wrlen_i    <= to_unsigned(0,3);
            start_wr_i <= '1';
            st         <= CAM0_RD_H1_PTR;
          end if;

        when CAM0_RD_H1_PTR =>
          if i2c_done_delayed='1' then
            slave_i    <= CAM_ADDR7;
            rdlen_i    <= to_unsigned(1,3);
            start_rd_i <= '1';
            st         <= CAM0_RD_H1_R;
          end if;

        when CAM0_RD_H1_R =>
          if rd_valid='1' then
            roi_h_msb <= rd_data(7 downto 0);
            -- Stream ON 0x0001=0x01
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_MODE_SEL;
            wrlen_i    <= to_unsigned(2,3);
            wrdata_i   <= x"00000001";
            start_wr_i <= '1';
            st         <= CAM0_STREAMON_W;
          end if;

        when CAM0_STREAMON_W =>
          if i2c_done_delayed='1' then
            slave_i   <= CAM_ADDR7;
            -- Stream ON 0x0001=0x01
            reg_i      <= REG_MODE_SEL;
            wrlen_i   <= to_unsigned(1,3);
            wrdata_i   <= x"00000001";
            start_wr_i<= '1';
            st        <= CAM0_STREAMON_WWAIT;
      --      st        <= FINISHED;
      --stop here
          end if;


        when CAM0_STREAMON_WWAIT   =>
          if i2c_done_delayed='1' then
            -- move to CAM1
            cam_idx <= 1;
            -- Set MUX CAM1
            slave_i   <= MUX_ADDR7;
            reg_i     <= x"0000";
            reg_16bit <= '0';
            wrlen_i   <= to_unsigned(1,3);
            wrdata_i  <= x"000000" & MUX_CAM1;
            start_wr_i<= '1';
            st        <= MUX1_SEL;
          end if;
        
        -------------------------------------------------------------------
        -- CAM1 path (same steps but without full readback clutter; add if you want)
        -------------------------------------------------------------------
        when MUX1_SEL =>
          if i2c_done_delayed='1' then
            -- Reset CAM1
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_SW_RESET;
            reg_16bit <= '1';
            wrlen_i    <= to_unsigned(2,3);
            wrdata_i   <= x"00000001";
            start_wr_i <= '1';
            st         <= CAM1_RESET_W;
          end if;

        when CAM1_RESET_W =>
          if i2c_done_delayed='1' then
            -- ROI width
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_OUT_X_SIZE_L;
            wrlen_i    <= to_unsigned(2,3);
            wrdata_i   <= x"0000" & MSB8(ROI_RECT_XY) & LSB8(ROI_RECT_XY);
            start_wr_i <= '1';
            st         <= CAM1_ROI_WX0;
          end if;

        when CAM1_ROI_WX0 =>
          if i2c_done_delayed='1' then
            -- ROI height
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_OUT_Y_SIZE_L;
            wrlen_i    <= to_unsigned(2,3);
            wrdata_i   <= x"0000" & MSB8(ROI_RECT_XY) & LSB8(ROI_RECT_XY);
            start_wr_i <= '1';
            st         <= CAM1_ROI_WY0;
          end if;

        when CAM1_ROI_WY0 =>
          if i2c_done_delayed='1' then
            -- Stream ON
            slave_i    <= CAM_ADDR7;
            reg_i      <= REG_MODE_SEL;
            wrlen_i    <= to_unsigned(1,3);
            wrdata_i   <= x"00000001";
            start_wr_i <= '1';
            st         <= CAM1_STREAMON_W;
          end if;

        when CAM1_STREAMON_W =>
          if i2c_done_delayed='1' then
            st   <= FINISHED;
          end if;

        when FINISHED =>
          done <= '1';

        when others =>
          null;
      end case;
    end if;
  end process;

end architecture;
