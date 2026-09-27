library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rmii_tx_udp_min is
  port (
    clk       : in  std_logic;  -- 50 MHz reference clock
    rst_n     : in  std_logic;  -- active low reset
    rmii_tx_en: out std_logic;
    rmii_txd  : out std_logic_vector(1 downto 0)
  );
end entity;

architecture rtl of rmii_tx_udp_min is

  -- ========== Ethernet/IP/UDP parameters ==========
  constant DST_MAC : std_logic_vector(47 downto 0) := x"a85e45b9cb08"; -- PC NIC
  constant SRC_MAC : std_logic_vector(47 downto 0) := x"02123456789a"; -- FPGA MAC (locally administered)
  constant SRC_IP  : std_logic_vector(31 downto 0) := x"c0a8010a"; -- 192.168.1.10
  constant DST_IP  : std_logic_vector(31 downto 0) := x"c0a80114"; -- 192.168.1.20
  constant SRC_PORT: std_logic_vector(15 downto 0) := x"04d2"; -- 1234
  constant DST_PORT: std_logic_vector(15 downto 0) := x"162e"; -- 5678

  -- Payload
  constant PAYLOAD : string := "HELLO FPGA";
  constant PAYLOAD_LEN : integer := PAYLOAD'length;

  -- Ethernet type
  constant ETH_TYPE_IP : std_logic_vector(15 downto 0) := x"0800";

  -- IP header length (20 bytes) + UDP header (8 bytes) + payload
  constant IP_LEN  : integer := 20 + 8 + PAYLOAD_LEN;

  -- Ethernet frame total length (without preamble/SFD, with CRC)
  constant FRAME_LEN : integer := 14 + IP_LEN + 4;

  -- Offsets
  constant IP_OFF : integer := 14; -- start of IP header
  constant UDP_OFF: integer := IP_OFF + 20;

  -- Frame buffer
  type byte_array is array (0 to FRAME_LEN-1) of std_logic_vector(7 downto 0);
  signal rom : byte_array := (others => (others => '0'));

  -- TX state machine
  type state_t is (S_IDLE, S_PREAMBLE, S_FRAME, S_CRC, S_DONE);
  signal s : state_t := S_IDLE;

  signal tx_idx : integer := 0;
  signal nibble_sel : std_logic := '0';

  -- CRC register
  signal crc_val : std_logic_vector(31 downto 0) := (others => '1');

  -- IP checksum
  signal ip_chksum : std_logic_vector(15 downto 0);

  -- RMII outputs
  signal txd_int  : std_logic_vector(1 downto 0) := "00";
  signal txen_int : std_logic := '0';

  -- Local helper variables
  signal started : std_logic := '0';

  -- ========== Functions ==========
-- IPv4 header checksum (20 bytes, checksum field must be 0 when called)
function ip_checksum(b : byte_array; start : integer) return std_logic_vector is
  variable sum : unsigned(17 downto 0) := (others => '0');
  variable hi  : unsigned(7 downto 0);
  variable lo  : unsigned(7 downto 0);
  variable w16 : unsigned(15 downto 0);
begin
  for i in 0 to 9 loop
    -- form big-endian 16-bit word without using "&"
    hi  := unsigned(b(start + 2*i    ));
    lo  := unsigned(b(start + 2*i + 1));
    w16 := (resize(hi, 16) sll 8) + resize(lo, 16);

    sum := sum + resize(w16, 18);
    -- fold any carry (keeps it bounded)
    sum := resize(sum(15 downto 0), 18) + resize(sum(17 downto 16), 18);
  end loop;
  -- final fold (in case one more carry)
  sum := resize(sum(15 downto 0), 18) + resize(sum(17 downto 16), 18);
  -- one's complement
  return std_logic_vector(not sum(15 downto 0));
end function;


  function crc32_next(crc : std_logic_vector(31 downto 0);
                      d   : std_logic_vector(7 downto 0))
         return std_logic_vector is
    variable c : std_logic_vector(31 downto 0) := crc;
  begin
    for i in 0 to 7 loop
      if (c(0) xor d(i)) = '1' then
        c := ('0' & c(31 downto 1)) xor x"EDB88320";
      else
        c := ('0' & c(31 downto 1));
      end if;
    end loop;
    return c;
  end function;

begin

  rmii_tx_en <= txen_int;
  rmii_txd   <= txd_int;

  process(clk, rst_n)
    variable b : byte_array;
    variable chksum_v : std_logic_vector(15 downto 0);
  begin
    if rst_n = '0' then
      s        <= S_IDLE;
      tx_idx   <= 0;
      nibble_sel <= '0';
      txen_int <= '0';
      txd_int  <= "00";
      started  <= '0';
      crc_val  <= (others => '1');

    elsif rising_edge(clk) then

      case s is

        when S_IDLE =>
          if started = '0' then
            -- Build the frame
            b := (others => (others => '0'));
            -- Ethernet header
            b(0) := DST_MAC(47 downto 40);
            b(1) := DST_MAC(39 downto 32);
            b(2) := DST_MAC(31 downto 24);
            b(3) := DST_MAC(23 downto 16);
            b(4) := DST_MAC(15 downto 8);
            b(5) := DST_MAC(7 downto 0);
            b(6) := SRC_MAC(47 downto 40);
            b(7) := SRC_MAC(39 downto 32);
            b(8) := SRC_MAC(31 downto 24);
            b(9) := SRC_MAC(23 downto 16);
            b(10):= SRC_MAC(15 downto 8);
            b(11):= SRC_MAC(7 downto 0);
            b(12):= ETH_TYPE_IP(15 downto 8);
            b(13):= ETH_TYPE_IP(7 downto 0);

            -- IP header
            b(IP_OFF+0) := x"45";
            b(IP_OFF+1) := x"00";
            b(IP_OFF+2) := std_logic_vector(to_unsigned(IP_LEN/256, 8));
            b(IP_OFF+3) := std_logic_vector(to_unsigned(IP_LEN mod 256, 8));
            b(IP_OFF+4) := x"00"; b(IP_OFF+5) := x"01";
            b(IP_OFF+6) := x"00"; b(IP_OFF+7) := x"00";
            b(IP_OFF+8) := x"40";
            b(IP_OFF+9) := x"11";
            b(IP_OFF+10):= x"00"; b(IP_OFF+11):= x"00"; -- checksum
            b(IP_OFF+12):= SRC_IP(31 downto 24);
            b(IP_OFF+13):= SRC_IP(23 downto 16);
            b(IP_OFF+14):= SRC_IP(15 downto 8);
            b(IP_OFF+15):= SRC_IP(7 downto 0);
            b(IP_OFF+16):= DST_IP(31 downto 24);
            b(IP_OFF+17):= DST_IP(23 downto 16);
            b(IP_OFF+18):= DST_IP(15 downto 8);
            b(IP_OFF+19):= DST_IP(7 downto 0);

            -- UDP header
            b(UDP_OFF+0) := SRC_PORT(15 downto 8);
            b(UDP_OFF+1) := SRC_PORT(7 downto 0);
            b(UDP_OFF+2) := DST_PORT(15 downto 8);
            b(UDP_OFF+3) := DST_PORT(7 downto 0);
            b(UDP_OFF+4) := std_logic_vector(to_unsigned((8+PAYLOAD_LEN)/256, 8));
            b(UDP_OFF+5) := std_logic_vector(to_unsigned((8+PAYLOAD_LEN) mod 256, 8));
            b(UDP_OFF+6) := x"00"; b(UDP_OFF+7):= x"00";

            -- Payload
            for i in 1 to PAYLOAD_LEN loop
              b(UDP_OFF+7+i) := std_logic_vector(to_unsigned(character'pos(PAYLOAD(i)),8));
            end loop;

            -- IP checksum
            chksum_v := ip_checksum(b, IP_OFF);
            b(IP_OFF+10) := chksum_v(15 downto 8);
            b(IP_OFF+11) := chksum_v(7 downto 0);
            ip_chksum    <= chksum_v;
            rom          <= b;

            -- start transmission
            s <= S_PREAMBLE;
            tx_idx <= 0;
            nibble_sel <= '0';
            txen_int <= '1';
            txd_int <= "01"; -- preamble nibble
            started <= '1';
            crc_val <= (others => '1');
          end if;

        when S_PREAMBLE =>
          if nibble_sel = '0' then
            nibble_sel <= '1';
            txd_int <= "01";
          else
            nibble_sel <= '0';
            tx_idx <= tx_idx + 1;
            if tx_idx = 6 then
              txd_int <= "11"; -- SFD
              s <= S_FRAME;
              tx_idx <= 0;
            else
              txd_int <= "01";
            end if;
          end if;

        when S_FRAME =>
          if nibble_sel = '0' then
            txd_int <= rom(tx_idx)(3 downto 2);
            nibble_sel <= '1';
          else
            txd_int <= rom(tx_idx)(1 downto 0);
            nibble_sel <= '0';
            crc_val <= crc32_next(crc_val, rom(tx_idx));
            tx_idx <= tx_idx + 1;
            if tx_idx = FRAME_LEN-5 then
              s <= S_CRC;
              tx_idx <= 0;
            end if;
          end if;

        when S_CRC =>
          if nibble_sel = '0' then
            txd_int <= crc_val(7 downto 6);
            nibble_sel <= '1';
          else
            txd_int <= crc_val(5 downto 4);
            nibble_sel <= '0';
            tx_idx <= tx_idx + 1;
            crc_val <= x"00" & crc_val(31 downto 8);
            if tx_idx = 3 then
              s <= S_DONE;
            end if;
          end if;

        when S_DONE =>
          txen_int <= '0';
          txd_int  <= "00";

      end case;
    end if;
  end process;

end architecture;
