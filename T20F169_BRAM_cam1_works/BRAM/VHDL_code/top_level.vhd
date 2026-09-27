library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
  port (
    --------------------------------------------------------------------------
    -- Clocks / resets / misc
    --------------------------------------------------------------------------
    clk                    : in  std_logic;       -- fabric clk
    pll_clk                : in  std_logic;
    pll_clk_lock           : in  std_logic;
    IO12_manual_reset_n    : in  std_logic;

    --------------------------------------------------------------------------
    -- LEDs / GPIO
    --------------------------------------------------------------------------
    led2                   : out std_logic;
    led4                   : in  std_logic;
    led4_OE                : out std_logic;
    led4_OUT               : out std_logic;
    RJ45_led               : out std_logic;

    --------------------------------------------------------------------------
    -- Camera enables
    --------------------------------------------------------------------------
    CAM0_EN                : out std_logic := '0';
    CAM1_EN                : out std_logic := '0';

    --------------------------------------------------------------------------
    -- I2C (3v3 side ? PCA9306 ? cameras)
    -- Separate OUT/OE for SDA matches your level-shifter/open-drain scheme.
    --------------------------------------------------------------------------
    I2C_SCL_IN             : in std_logic;    
    I2C_SCL_OUT            : out std_logic;
    I2C_SCL_OE             : out std_logic;    
    I2C_SDA_IN             : in  std_logic;
    I2C_SDA_OUT            : out std_logic;
    I2C_SDA_OE             : out std_logic;

    --------------------------------------------------------------------------
    -- Strap / aux pins shown in CSV
    --------------------------------------------------------------------------
    FPGA_IO0_A0            : out std_logic;
    FPGA_IO0_A1            : out std_logic;
    FPGA_IO0_A2            : out std_logic;

    --------------------------------------------------------------------------
    -- Ethernet RMII (current board)
    --------------------------------------------------------------------------
    rmii_crs_dv            : in  std_logic;
    rmii_rx_er             : in  std_logic;
    rmii_rxd               : in  std_logic_vector(1 downto 0);
    rmii_tx_en             : out std_logic;
    rmii_txd               : out std_logic_vector(1 downto 0);

    -- MDIO/MDC + PHY control
    mdc                    : out std_logic;
    mdio_i                 : in  std_logic;
    mdio_o                 : out std_logic;
    mdio_oe                : out std_logic;
    phy_intr_n             : in  std_logic;
    phy_rst_n              : out std_logic;

    --------------------------------------------------------------------------
    -- MIPI CSI-2 Receiver instance 1 (CAM0)
    -- NOTE: these are fabric-side signals from the RX IP.
    --------------------------------------------------------------------------
    mipi_rx_inst1_DATA     : in  std_logic_vector(63 downto 0);
    mipi_rx_inst1_VALID    : in  std_logic;
    mipi_rx_inst1_TYPE     : in  std_logic_vector(5 downto 0);
    mipi_rx_inst1_VC       : in  std_logic_vector(1 downto 0);
    mipi_rx_inst1_CNT      : in  std_logic_vector(3 downto 0);
    mipi_rx_inst1_HSYNC    : in  std_logic_vector(3 downto 0);
    mipi_rx_inst1_VSYNC    : in  std_logic_vector(3 downto 0);

    -- Control / enables (fabric ? IP)
    mipi_rx_inst1_DPHY_RSTN: out std_logic;       -- required
    mipi_rx_inst1_RSTN     : out std_logic;       -- required
    mipi_rx_inst1_VC_ENA   : out std_logic_vector(3 downto 0);
    mipi_rx_inst1_LANES    : out std_logic_vector(1 downto 0);

    --------------------------------------------------------------------------
    -- MIPI CSI-2 Receiver instance 2 (CAM1)
    --------------------------------------------------------------------------
    mipi_rx_inst2_DATA     : in  std_logic_vector(63 downto 0);
    mipi_rx_inst2_VALID    : in  std_logic;
    mipi_rx_inst2_TYPE     : in  std_logic_vector(5 downto 0);
    mipi_rx_inst2_VC       : in  std_logic_vector(1 downto 0);
    mipi_rx_inst2_CNT      : in  std_logic_vector(3 downto 0);
    mipi_rx_inst2_HSYNC    : in  std_logic_vector(3 downto 0);
    mipi_rx_inst2_VSYNC    : in  std_logic_vector(3 downto 0);

    -- Control / enables (fabric ? IP)
    mipi_rx_inst2_DPHY_RSTN: out std_logic;       -- required
    mipi_rx_inst2_RSTN     : out std_logic;       -- required
    mipi_rx_inst2_VC_ENA   : out std_logic_vector(3 downto 0);
    mipi_rx_inst2_LANES    : out std_logic_vector(1 downto 0)

    --------------------------------------------------------------------------
    -- Optional: If you expose the Interface Designer ?clkout? nets at top,
    -- add them here; otherwise keep them inside your clocking wrapper.
    --------------------------------------------------------------------------
    -- ,clkout0            : out std_logic;
    -- ,clkout1            : out std_logic;
    -- ,clkout2            : out std_logic;
    -- ,clkout3            : out std_logic;
    -- ,clkout4            : out std_logic

  );
end entity top_level;



architecture behavior of top_level is


------------- Begin Cut here for COMPONENT Declaration ------
component micro_risc_v1 is
port (
    io_systemClk : in std_logic;
    jtagCtrl_enable : in std_logic;
    jtagCtrl_tdi : in std_logic;
    jtagCtrl_capture : in std_logic;
    jtagCtrl_shift : in std_logic;
    jtagCtrl_update : in std_logic;
    jtagCtrl_reset : in std_logic;
    jtagCtrl_tdo : out std_logic;
    jtagCtrl_tck : in std_logic;
    io_asyncReset : in std_logic;
    io_systemReset : out std_logic;
    system_uart_0_io_txd : out std_logic;
    system_uart_0_io_rxd : in std_logic;
    system_gpio_0_io_writeEnable : out std_logic_vector(0 to 0);
    system_gpio_0_io_write : out std_logic_vector(0 to 0);
    system_gpio_0_io_read : in std_logic_vector(0 to 0)
);
end component micro_risc_v1;



component i2c_reg16_master
  generic (
    CLK_FREQ_HZ : integer;
    I2C_FREQ_HZ : integer
    
  );
  port (
    clk : in std_logic;
    rst_n : in std_logic;
    SCL_IN : in std_logic;
    SCL_OUT : out std_logic;
    SCL_OE : out std_logic;
    SDA_IN : in std_logic;
    SDA_OUT : out std_logic;
    SDA_OE : out std_logic;
    start_write16 : in std_logic;
    start_read16 : in std_logic;
    slave_addr7 : in std_logic_vector(6 downto 0);
    reg_addr16 : in std_logic_vector(15 downto 0);
    reg_16bit : in std_logic;
    wr_len : in unsigned(2 downto 0);
    wr_data : in std_logic_vector(31 downto 0);
    rd_len : in unsigned(2 downto 0);
    rd_data : out std_logic_vector(31 downto 0);
    rd_valid : out std_logic;
    busy : out std_logic;
    done : out std_logic;
    ack_error : out std_logic
  );
end component;



component control_camera_i2c
  port (
    clk : in std_logic;
    rst_n : in std_logic;
    i2c_busy : in std_logic;
    i2c_done : in std_logic;
    i2c_ackerr : in std_logic;
    rd_valid : in std_logic;
    rd_data : in std_logic_vector(31 downto 0);
    start_write16 : out std_logic;
    start_read16 : out std_logic;
    slave_addr7 : out std_logic_vector(6 downto 0);
    reg_addr16 : out std_logic_vector(15 downto 0);
    reg_16bit : out std_logic;
    wr_len : out unsigned(2 downto 0);
    wr_data : out std_logic_vector(31 downto 0);
    rd_len : out unsigned(2 downto 0);
    cam_setup_cnt : out integer range 0 to 1;
    done : out std_logic;
    debug_state : out std_logic_vector(7 downto 0);
    chip_id_msb : out std_logic_vector(7 downto 0);
    chip_id_lsb : out std_logic_vector(7 downto 0);
    roi_w_lsb : out std_logic_vector(7 downto 0);
    roi_w_msb : out std_logic_vector(7 downto 0);
    roi_h_lsb : out std_logic_vector(7 downto 0);
    roi_h_msb : out std_logic_vector(7 downto 0)
  );
end component;
------------- Begin Cut here for COMPONENT Declaration ------
  signal div : unsigned(25 downto 0) := (others => '0');  -- ~1 s at 128 MHz test counter
  signal cnt_from_clk : unsigned(31 downto 0) := (others => '0');
  signal io_asyncReset_sig : std_logic := '1';
  signal rst_n : std_logic := '0';
  signal msb_cnt_o : std_logic := '1';
  signal io_systemReset : std_logic := '0';
  signal system_uart_0_io_txd : std_logic := '0';
  signal system_uart_0_io_rxd : std_logic := '0';
  signal system_gpio_0_io_writeEnable : std_logic_vector(0 to 0);
  signal system_gpio_0_io_write : std_logic_vector(0 to 0);
  signal system_gpio_0_io_read : std_logic_vector(0 to 0);
  signal pre_system_uart_0_io_txd : std_logic := '0';
  signal led4_in : std_logic := '0'; --tri-state
  signal led_link : std_logic := '0';

    signal jtag_dummy_TDI : std_logic := '0'; 
    signal jtag_dummy_TCK :  std_logic := '0'; 
    signal jtag_dummy_TMS :  std_logic := '0';
    signal jtag_dummy_SEL :  std_logic := '0';
    signal jtag_dummy_DRCK :  std_logic := '0';
    signal jtag_dummy_RESET :  std_logic := '0'; 
    signal jtag_dummy_RUNTEST :  std_logic := '0';
    signal jtag_dummy_CAPTURE :  std_logic := '0';
    signal jtag_dummy_SHIFT :  std_logic := '0';
    signal jtag_dummy_UPDATE :  std_logic := '0';
    signal jtag_dummy_TDO : std_logic; --out

  -- I2C master <-> controller interconnect and SCL/SDA lines
  -- Control ? Master signals
  signal start_write16 : std_logic := '0';
  signal start_read16  : std_logic := '0';
  signal slave_addr7   : std_logic_vector(6 downto 0) := (others => '0');
  signal reg_addr16    : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_16bit : std_logic := '0';
  signal wr_len        : unsigned(2 downto 0) := (others => '0');
  signal wr_data       : std_logic_vector(31 downto 0) := (others => '0');
  signal rd_len        : unsigned(2 downto 0) := (others => '0');
  signal rd_data       : std_logic_vector(31 downto 0) := (others => '0');
  signal rd_valid      : std_logic := '0';
  signal i2c_busy          : std_logic := '0';
  signal i2c_done          : std_logic := '0';
  signal camsetup_done  : std_logic := '1';
  signal i2c_ackerr     : std_logic := '0';

  -- Optional debug signals from control_camera_i2c
  signal cam_setup_cnt : unsigned(7 downto 0) := (others => '0');
  signal debug_state   : std_logic_vector(7 downto 0) := (others => '0');
  signal chip_id_msb   : std_logic_vector(7 downto 0) := (others => '0');
  signal chip_id_lsb   : std_logic_vector(7 downto 0) := (others => '0');
  signal roi_w_lsb     : std_logic_vector(7 downto 0) := (others => '0');
  signal roi_w_msb     : std_logic_vector(7 downto 0) := (others => '0');
  signal roi_h_lsb     : std_logic_vector(7 downto 0) := (others => '0');
  signal roi_h_msb     : std_logic_vector(7 downto 0) := (others => '0');

  signal mst_scl_out : std_logic := '0';
  signal mst_scl_oe : std_logic := '0';


  
  signal cam_i2c_done        : std_logic := '0';
  signal debug_div_part      : std_logic_vector(4 downto 0) := (others => '0');

  signal i2c_scl_line        : std_logic := '1';

begin


   
------------- Begin Cut here for INSTANTIATION Template -----

--u_micro_risc_v1 : micro_risc_v1
--port map (
--    io_systemClk => pll_clk,
--    jtagCtrl_enable => '1',
--    jtagCtrl_tdi => jtag_dummy_TDI,
--    jtagCtrl_capture => jtag_dummy_CAPTURE,
--    jtagCtrl_shift => jtag_dummy_SHIFT,
--    jtagCtrl_update => jtag_dummy_UPDATE,
--    jtagCtrl_reset => jtag_dummy_RESET,
--    jtagCtrl_tdo => jtag_dummy_TDO,
--    jtagCtrl_tck => jtag_dummy_TCK,
--    io_asyncReset => io_asyncReset_sig,
--    io_systemReset => io_systemReset,
--    system_uart_0_io_txd => system_uart_0_io_txd,
--    system_uart_0_io_rxd => system_uart_0_io_rxd,
--    system_gpio_0_io_writeEnable => system_gpio_0_io_writeEnable,
--    system_gpio_0_io_write => system_gpio_0_io_write,
--    system_gpio_0_io_read => system_gpio_0_io_read
--);



  --fit this control_camera_i2c and I2C_32_MASTER proper together with the signals as well


  -- Camera I2C controller instance
control_camera_i2c_inst : control_camera_i2c
  port map (
    clk => pll_clk,
    rst_n => rst_n,
    i2c_busy => i2c_busy,
    i2c_done => i2c_done,
    i2c_ackerr => i2c_ackerr,
    rd_valid => rd_valid,
    rd_data => rd_data,
    start_write16 => start_write16,
    start_read16 => start_read16,
    slave_addr7 => slave_addr7,
    reg_addr16 => reg_addr16,
    reg_16bit => reg_16bit,
    wr_len => wr_len,
    wr_data => wr_data,
    rd_len => rd_len,
    cam_setup_cnt => open,
    done => camsetup_done,
    debug_state => debug_state,
    chip_id_msb => chip_id_msb,
    chip_id_lsb => chip_id_lsb,
    roi_w_lsb => roi_w_lsb,
    roi_w_msb => roi_w_msb,
    roi_h_lsb => roi_h_lsb,
    roi_h_msb => roi_h_msb
  );


  i2c_reg16_master_inst : entity work.i2c_reg16_master
  generic map (
    CLK_FREQ_HZ => 128_000_000,
    I2C_FREQ_HZ => 100_000
    
  )
  port map (
    clk => pll_clk,
    rst_n => rst_n,
    SCL_IN => I2C_SCL_IN,
    SCL_OUT => mst_scl_out,-- Let the _OE control the 1 or 0 External pull up will set the tri-state pin to high when _OE = 0
    SCL_OE => mst_scl_oe,
    SDA_IN => I2C_SDA_IN,
    SDA_OUT => open,-- Let the _OE control the 1 or 0 External pull up will set the tri-state pin to high when _OE = 0
    SDA_OE => I2C_SDA_OE,
    start_write16 => start_write16,
    start_read16 => start_read16,
    slave_addr7 => slave_addr7,
    reg_addr16 => reg_addr16,
    reg_16bit => reg_16bit,
    wr_len => wr_len,
    wr_data => wr_data,
    rd_len => rd_len,
    rd_data => rd_data,
    rd_valid => rd_valid,
    busy => i2c_busy,
    done => i2c_done,
    ack_error => i2c_ackerr
  );


------------------------ End INSTANTIATION Template ---------



-- simple rising-edge detector: generate a 1-cycle clear pulse
process(clk)
begin
  if rising_edge(clk) then
    --Nothing will belong to this incoming clk all clock connect to pll_clk 128Mhz instead
  end if;
end process;
   
  process(pll_clk)
  begin
    if rising_edge(pll_clk) then
      div   <= div + 1;
      cnt_from_clk <= cnt_from_clk + 1;
      debug_div_part <= div(6) & div(5) & div(4) & div(3) & div(2) ;      
      if div(24) = '1' then 
        io_asyncReset_sig <= '0';
      end if;
        pre_system_uart_0_io_txd <= system_uart_0_io_txd;
      end if;
  end process;
        CAM0_EN <= '0';
        CAM1_EN <= '0';  
    I2C_SCL_OUT <= '0';-- Let the _OE control the 1 or 0 External pull up will set the tri-state pin to high when _OE = 0
    I2C_SCL_OE  <= mst_scl_oe and (not mst_scl_out);  -- drive only when core says "low"
    I2C_SDA_OUT <= '0';-- Let the _OE control the 1 or 0 External pull up will set the tri-state pin to high when _OE = 0
    --led2 <= camsetup_done;
    led2 <= cnt_from_clk(7);
--    led4_OUT <= system_gpio_0_io_write(0);
--    led4_OE <= system_gpio_0_io_writeEnable(0);
    led4_OUT <= cnt_from_clk(30);
    led4_OE <= '1';

    --led4_in <= led4;
    --RJ45_led <= led_link;
    phy_rst_n <= IO12_manual_reset_n;
    rst_n <= IO12_manual_reset_n and (not io_asyncReset_sig);

end behavior;

