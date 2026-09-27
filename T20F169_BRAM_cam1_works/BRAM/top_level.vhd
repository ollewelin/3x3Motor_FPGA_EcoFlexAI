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
    mipi_rx_inst1_ERROR    : in  std_logic_vector(17 downto 0);
    mipi_rx_inst1_ULPS_CLK : in  std_logic;
    mipi_rx_inst1_ULPS     : in  std_logic_vector(3 downto 0);

    -- Control / enables (fabric ? IP)
    mipi_rx_inst1_DPHY_RSTN: out std_logic;       -- required
    mipi_rx_inst1_RSTN     : out std_logic;       -- required
    mipi_rx_inst1_VC_ENA   : out std_logic_vector(3 downto 0);
    mipi_rx_inst1_LANES    : out std_logic_vector(1 downto 0);
    mipi_rx_inst1_CLEAR : out std_logic;

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
    mipi_rx_inst2_ERROR    : in  std_logic_vector(17 downto 0);
    mipi_rx_inst2_ULPS_CLK : in  std_logic;
    mipi_rx_inst2_ULPS     : in  std_logic_vector(3 downto 0);    

    -- Control / enables (fabric ? IP)
    mipi_rx_inst2_DPHY_RSTN: out std_logic;       -- required
    mipi_rx_inst2_RSTN     : out std_logic;       -- required
    mipi_rx_inst2_VC_ENA   : out std_logic_vector(3 downto 0);
    mipi_rx_inst2_LANES    : out std_logic_vector(1 downto 0);
    mipi_rx_inst2_CLEAR : out std_logic;

    --------------------------------------------------------------------------
    -- JTAG to RISC-V debug
    --------------------------------------------------------------------------
    jtag_inst1_CAPTURE : in  std_logic;
    jtag_inst1_DRCK : in  std_logic;
    jtag_inst1_RESET : in  std_logic;
    jtag_inst1_RUNTEST : in  std_logic;
    jtag_inst1_SEL : in  std_logic;
    jtag_inst1_SHIFT : in  std_logic;
    jtag_inst1_TCK : in  std_logic;
    jtag_inst1_TDI : in  std_logic;
    jtag_inst1_TMS : in  std_logic;
    jtag_inst1_UPDATE: in  std_logic;
    jtag_inst1_TDO : out std_logic

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
    system_i2c_0_io_scl_read : in std_logic;
    system_i2c_0_io_scl_write : out std_logic;
    system_i2c_0_io_sda_read : in std_logic;
    system_i2c_0_io_sda_write : out std_logic;
    system_gpio_0_io_writeEnable : out std_logic_vector(0 to 0);
    system_gpio_0_io_write : out std_logic_vector(0 to 0);
    system_gpio_0_io_read : in std_logic_vector(0 to 0)
);
end component micro_risc_v1;





component record_frame_bram_counted
  generic (
    CLOCK_HZ : integer;
    BAUD : integer;
    WIDTH_PIX : integer;
    HEIGHT_LINES : integer;
    PIXELS_PER_BEAT : integer;
    GAP_MIN_CYCLES : integer;
    CLEAR_CYCLES : integer;
    AUTO_DUMP_UART : boolean
  );
  port (
    clk : in std_logic;
    rst_n : in std_logic;
    data64 : in std_logic_vector(63 downto 0);
    valid : in std_logic;
    dtype : in std_logic_vector(5 downto 0);
    cnt : in std_logic_vector(3 downto 0);
    hsync : in std_logic_vector(3 downto 0);
    vsync : in std_logic_vector(3 downto 0);
    error_bus : in std_logic_vector(17 downto 0);
    arm_i : in std_logic;
    armed_o : out std_logic;
    capturing_o : out std_logic;
    done_o : out std_logic;
    clear_o : out std_logic;
    beats_line_o : out unsigned(15 downto 0);
    line_idx_o : out unsigned(15 downto 0);
    words_used_o : out unsigned(31 downto 0);
    uart_tx : out std_logic
  );
end component;
---------------------- End COMPONENT Declaration ------------
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

  signal system_i2c_0_io_scl_read : std_logic;
  signal system_i2c_0_io_sda_read : std_logic;
  signal system_i2c_0_io_scl_write : std_logic;
  signal system_i2c_0_io_sda_write : std_logic;

  signal mipi_rx_inst1_MASKED_ERROR    : std_logic_vector(17 downto 0);-- mask out remove x"00C0" bits
  signal mipi_rx_inst2_MASKED_ERROR    : std_logic_vector(17 downto 0);-- mask out remove x"00C0" bits

  signal one_extra_clear_MIPI_reset : std_logic := '0';
  signal IO12_manual_reset_n_detatched : std_logic := '1';
  signal MIPI_test_reset_n : std_logic := '1';
  signal bl_led4 : std_logic := '0';


  signal debug_div_part      : std_logic_vector(4 downto 0) := (others => '0');


-- ==========================================================
-- MIPI RX reset / clear helper for inst1 (CAM0)
-- Assumes 'clk' is the fabric/pixel clock for the RX outputs
-- ==========================================================
signal rst_cnt1             : unsigned(19 downto 0) := (others=>'0');
signal dphy_rstn_1, csi_rstn_1 : std_logic := '0';
signal clear_cnt1           : unsigned(7 downto 0) := (others=>'0');
signal clear_pulse_1        : std_logic := '0';

begin


------------- Begin Cut here for INSTANTIATION Template -----

u_micro_risc_v1 : micro_risc_v1
port map (
    io_systemClk => pll_clk,
    jtagCtrl_enable => '1',

    --jtagCtrl_tdi => jtag_dummy_TDI,
    --jtagCtrl_capture => jtag_dummy_CAPTURE,
    --jtagCtrl_shift =>  jtag_dummy_SHIFT,
    --jtagCtrl_update => jtag_dummy_UPDATE,
    --jtagCtrl_reset => jtag_dummy_RESET ,
    --jtagCtrl_tck => jtag_dummy_TCK,
    --jtagCtrl_tdo => jtag_dummy_TDO,

    jtagCtrl_tdi => jtag_inst1_TDI,
    jtagCtrl_capture => jtag_inst1_CAPTURE,    
    jtagCtrl_shift =>  jtag_inst1_SHIFT,
    jtagCtrl_update => jtag_inst1_UPDATE,
    jtagCtrl_reset => jtag_inst1_RESET ,
    jtagCtrl_tck => jtag_inst1_TCK,
    jtagCtrl_tdo => jtag_inst1_TDO,

    io_asyncReset => io_asyncReset_sig,
    io_systemReset => io_systemReset,
    system_uart_0_io_txd => system_uart_0_io_txd,
    system_uart_0_io_rxd => system_uart_0_io_rxd,
    system_i2c_0_io_scl_read => system_i2c_0_io_scl_read,
    system_i2c_0_io_scl_write => system_i2c_0_io_scl_write,
    system_i2c_0_io_sda_read => system_i2c_0_io_sda_read,
    system_i2c_0_io_sda_write => system_i2c_0_io_sda_write,
    system_gpio_0_io_writeEnable => system_gpio_0_io_writeEnable,
    system_gpio_0_io_write => system_gpio_0_io_write,
    system_gpio_0_io_read => system_gpio_0_io_read
);




record_frame_bram_counted_inst : entity work.record_frame_bram_counted
  port map (
    clk => pll_clk,
    rst_n => rst_n,
    data64 => mipi_rx_inst1_DATA,
    valid => mipi_rx_inst1_VALID,
    dtype => mipi_rx_inst1_TYPE,
    cnt => mipi_rx_inst1_CNT,
    hsync => mipi_rx_inst1_HSYNC,
    vsync => mipi_rx_inst1_VSYNC,
    error_bus => mipi_rx_inst1_ERROR,
    arm_i => not clear_pulse_1,
    armed_o => open,
    capturing_o => open,
    done_o => open,
    clear_o => open,
    beats_line_o => open,
    line_idx_o => open,
    words_used_o => open,
    uart_tx => led2
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
      
      debug_div_part <= div(6) & div(5) & div(4) & div(3) & div(2) ;      
      if div(24) = '1' then 
        io_asyncReset_sig <= '0';
      end if;
        pre_system_uart_0_io_txd <= system_uart_0_io_txd;
      end if;
  end process;






    CAM0_EN <= '0';
    CAM1_EN <= '0';  

    --==========================================
    -- I2C I/O acccording to the two I2C INOUT pins
    I2C_SCL_OUT <= '0';-- Let the _OE control the 1 or 0 External pull up will set the tri-state pin to high when _OE = 0
    I2C_SCL_OE  <= not system_i2c_0_io_scl_write;  -- drive only when core says "low"
    I2C_SDA_OUT <= '0';-- Let the _OE control the 1 or 0 External pull up will set the tri-state pin to high when _OE = 0
    I2C_SDA_OE  <= not system_i2c_0_io_sda_write;
    system_i2c_0_io_scl_read <= I2C_SCL_IN;
    system_i2c_0_io_sda_read <= I2C_SDA_IN;

    --==========================================
    led4_OUT <= system_gpio_0_io_write(0);
    led4_OE <= system_gpio_0_io_writeEnable(0);

    phy_rst_n <= IO12_manual_reset_n_detatched;
    rst_n <= IO12_manual_reset_n_detatched and (not io_asyncReset_sig);




process(pll_clk)
begin
  if rising_edge(pll_clk) then
    if pll_clk_lock = '0' then
      rst_cnt1      <= (others=>'0');
      dphy_rstn_1   <= '0';
      csi_rstn_1    <= '0';
      clear_cnt1    <= (others=>'0');
      cnt_from_clk <= (others=>'0');
      clear_pulse_1 <= '0';
    else
        cnt_from_clk <= cnt_from_clk + 1;
        MIPI_test_reset_n <= '1';
        if cnt_from_clk(29) = '1' then
            cnt_from_clk <= (others=>'0');
            MIPI_test_reset_n <= '0';
            bl_led4 <= not bl_led4;-- toggle led4
           -- led4_OUT <= bl_led4;
        end if;


      -- stretch reset for ~1 ms @100 MHz; then release DPHY, then CSI
      if rst_cnt1 < to_unsigned(100000, rst_cnt1'length) then
        rst_cnt1    <= rst_cnt1 + 1;
        dphy_rstn_1 <= '0';
        csi_rstn_1  <= '0';
      elsif rst_cnt1 < to_unsigned(110000, rst_cnt1'length) then
        rst_cnt1    <= rst_cnt1 + 1;
        dphy_rstn_1 <= '1';   -- release D-PHY first
        csi_rstn_1  <= '0';
      else
        dphy_rstn_1 <= '1';
        csi_rstn_1  <= '1';   -- release CSI wrapper
        -- one-shot CLEAR pulse for a few cycles after reset completes
        if clear_cnt1 < "01111111" then
          clear_cnt1    <= clear_cnt1 + 1;
          clear_pulse_1 <= '1';
        else
          clear_pulse_1 <= '0';
        end if;
      end if;
    end if;
  end if;
end process;

    --MIPI setup output CAM0 
    mipi_rx_inst1_VC_ENA    <= "0001";   -- VC0 only
    mipi_rx_inst1_LANES     <= "01";     -- 2 lanes
    
mipi_rx_inst2_MASKED_ERROR <= mipi_rx_inst2_ERROR and "111111111111111111";


 mipi_rx_inst1_DPHY_RSTN <= dphy_rstn_1;
 mipi_rx_inst1_RSTN      <= csi_rstn_1 and MIPI_test_reset_n;   
 mipi_rx_inst1_CLEAR     <= clear_pulse_1 or (not MIPI_test_reset_n) or (not IO12_manual_reset_n);    

    mipi_rx_inst2_VC_ENA    <= "0001";   -- VC0 only
    mipi_rx_inst2_LANES     <= "01";     -- 2 lanes 0, 1
   

 mipi_rx_inst2_DPHY_RSTN <= dphy_rstn_1;
 mipi_rx_inst2_RSTN      <= csi_rstn_1 and MIPI_test_reset_n;
 mipi_rx_inst2_CLEAR     <= clear_pulse_1 or (not MIPI_test_reset_n) or (not IO12_manual_reset_n);    
    --
end behavior;

