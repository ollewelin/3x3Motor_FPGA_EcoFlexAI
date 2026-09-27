-- mdio_tiny.vhd : minimal Clause-22 MDIO master @ sys_clk
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mdio_tiny is
  generic (
    G_SYS_CLK_HZ  : integer := 50_000_000;
    G_MDC_HZ      : integer := 400_000        -- <= 2.5 MHz
  );
  port (
    sys_clk   : in  std_logic;
    rst_n     : in  std_logic;

    -- control
    start     : in  std_logic;              -- pulse 1 clk to start
    rw        : in  std_logic;              -- 1=read, 0=write
    phy_addr  : in  std_logic_vector(4 downto 0);
    reg_addr  : in  std_logic_vector(4 downto 0);
    wdata     : in  std_logic_vector(15 downto 0);

    busy      : out std_logic;
    done      : out std_logic;
    rdata     : out std_logic_vector(15 downto 0);

    -- MDIO pins (tri-state via top)
    mdc       : out std_logic;
    mdio_i    : in  std_logic;
    mdio_o    : out std_logic;
    mdio_oe   : out std_logic
  );
end entity;

architecture rtl of mdio_tiny is
  constant C_MDC_DIV : integer := integer(real(G_SYS_CLK_HZ) / real(2*G_MDC_HZ)); -- toggle -> /2
  signal mdc_cnt     : integer range 0 to C_MDC_DIV-1 := 0;
  signal mdc_i       : std_logic := '0';

  type st_t is (IDLE, PRE, ST, OP, PHYAD, REGAD, TA_W, TA_Z, WR, RD, DONE);
  signal st          : st_t := IDLE;

  signal go          : std_logic := '0';
  signal rw_i        : std_logic := '0';
  signal phy_i       : std_logic_vector(4 downto 0);
  signal reg_i       : std_logic_vector(4 downto 0);
  signal wdat_i      : std_logic_vector(15 downto 0);

  signal out_bit     : std_logic := '1';
  signal out_ena     : std_logic := '0';
  signal rd_shift    : std_logic_vector(15 downto 0) := (others=>'0');
  signal bitc        : integer range 0 to 63 := 0;

begin
  mdc   <= mdc_i;
  mdio_o  <= out_bit;
  mdio_oe <= out_ena;
  busy  <= '1' when st/=IDLE else '0';

  -- latch command on start
  process(sys_clk) begin
    if rising_edge(sys_clk) then
      if rst_n='0' then
        go   <= '0';
      else
        if start='1' and st=IDLE then
          go    <= '1';
          rw_i  <= rw;
          phy_i <= phy_addr;
          reg_i <= reg_addr;
          wdat_i<= wdata;
        elsif st/=IDLE then
          go    <= '0';
        end if;
      end if;
    end if;
  end process;

  -- MDC generator
  process(sys_clk) begin
    if rising_edge(sys_clk) then
      if rst_n='0' then
        mdc_cnt <= 0;  mdc_i <= '0';
      else
        if mdc_cnt=C_MDC_DIV-1 then
          mdc_cnt <= 0;  mdc_i <= not mdc_i;
        else
          mdc_cnt <= mdc_cnt+1;
        end if;
      end if;
    end if;
  end process;

  done <= '1' when st=DONE else '0';
  rdata<= rd_shift;

  -- State machine: step on rising edges of MDC
  process(sys_clk) begin
    if rising_edge(sys_clk) then
      if rst_n='0' then
        st <= IDLE; out_ena<='0'; out_bit<='1'; bitc<=0; rd_shift<=(others=>'0');
      else
        if mdc_i='1' then
          case st is
            when IDLE =>
              out_ena<='0'; out_bit<='1';
              if go='1' then
                st   <= PRE; out_ena<='1'; out_bit<='1'; bitc<=31;
              end if;

            when PRE =>
              if bitc=0 then st<=ST; out_bit<='0'; bitc<=1;  -- send '0','1'
              else            bitc<=bitc-1; end if;

            when ST =>
              if bitc=1 then out_bit<='1'; st<=OP; bitc<=1;
              end if;

            when OP => -- read=10, write=01
              if rw_i='1' then
                if bitc=1 then out_bit<='0'; st<=PHYAD; bitc<=4;
                else out_bit<='1'; bitc<=bitc-1; end if;
              else
                if bitc=1 then out_bit<='1'; st<=PHYAD; bitc<=4;
                else out_bit<='0'; bitc<=bitc-1; end if;
              end if;

            when PHYAD =>
              out_bit <= phy_i(bitc);
              if bitc=0 then st<=REGAD; bitc<=4; else bitc<=bitc-1; end if;

            when REGAD =>
              out_bit <= reg_i(bitc);
              if bitc=0 then
                if rw_i='1' then st<=TA_Z; out_ena<='0'; bitc<=1; -- Z,1
                else st<=TA_W; out_ena<='1'; out_bit<='1'; bitc<=1; end if;
              else bitc<=bitc-1; end if;

            when TA_W =>
              if bitc=1 then out_bit<='0'; st<=WR; bitc<=15; end if;

            when WR =>
              out_bit <= wdat_i(bitc);
              if bitc=0 then st<=DONE; else bitc<=bitc-1; end if;

            when TA_Z =>
              if bitc=1 then st<=RD; bitc<=15; end if;

            when RD =>
              rd_shift(bitc) <= mdio_i;
              if bitc=0 then st<=DONE; else bitc<=bitc-1; end if;

            when DONE =>
              st <= IDLE; out_ena<='0'; out_bit<='1';
          end case;
        end if;
      end if;
    end if;
  end process;
end architecture;
