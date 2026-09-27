library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rmii_udp_tx_top is
  port (
    clk50      : in  std_logic;                    -- 50 MHz RMII reference clock (from PHY)
    rst_n      : in  std_logic;                    -- active-low reset
    rmii_tx_en : out std_logic;                    -- to PHY
    rmii_txd   : out std_logic_vector(1 downto 0)  -- to PHY
  );
end entity;

architecture rtl of rmii_udp_tx_top is

  --------------------------------------------------------------------
  -- User-editable constants (put your PC MAC/IP here)
  --------------------------------------------------------------------
  -- PC NIC MAC (from: ip link show enp2s0)
  constant DST_MAC  : std_logic_vector(47 downto 0) := x"A85E45B9CB08";
  -- FPGA source MAC (locally administered; pick anything with bit1 of first byte = 1)
  constant SRC_MAC  : std_logic_vector(47 downto 0) := x"02123456789A";

  -- Source/Destination IPs (match your setup)
  constant SRC_IP   : std_logic_vector(31 downto 0) := x"C0A8010A"; -- 192.168.1.10
  constant DST_IP   : std_logic_vector(31 downto 0) := x"C0A80114"; -- 192.168.1.20

  -- UDP ports
  constant SRC_PORT : std_logic_vector(15 downto 0) := x"04D2";     -- 1234
  constant DST_PORT : std_logic_vector(15 downto 0) := x"162E";     -- 5678

  -- Payload string (printable)
  constant PAYLOAD_STR : string := "HELLO FPGA";
  constant PLEN        : integer := PAYLOAD_STR'length;

  --------------------------------------------------------------------
  -- Frame sizing (enforce Ethernet minimum 60B before CRC)
  --------------------------------------------------------------------
  constant ETH_HDR_LEN : integer := 14;      -- dst(6)+src(6)+type(2)
  constant IP_HDR_LEN  : integer := 20;      -- no options
  constant UDP_HDR_LEN : integer := 8;

  constant IP_TLEN     : integer := IP_HDR_LEN + UDP_HDR_LEN + PLEN;

  -- helper max() for integers (VHDL-compatible)
  function max_i(a, b : integer) return integer is
  begin
    if a > b then return a; else return b; end if;
  end function;

  constant DATA_NOCRC  : integer := ETH_HDR_LEN + IP_TLEN;  -- what we actually populate
  constant MIN_NOCRC   : integer := 60;                     -- Ethernet minimum (no FCS)
  constant FRAME_NOCRC : integer := max_i(DATA_NOCRC, MIN_NOCRC); -- what we send before CRC
  constant PAD_BYTES   : integer := FRAME_NOCRC - DATA_NOCRC;     -- zeros appended after payload
  constant FRAME_LEN   : integer := FRAME_NOCRC + 4;              -- include CRC32

  subtype byte is std_logic_vector(7 downto 0);
  type byte_array is array (natural range <>) of byte;

  -- Frame buffer (everything after SFD; preamble/SFD are streamed separately)
  signal frame : byte_array(0 to FRAME_NOCRC-1) := (others => (others => '0'));

  -- IP header checksum location (bytes 14+10..11)
  constant IP_OFF  : integer := 14;
  constant UDP_OFF : integer := IP_OFF + IP_HDR_LEN;

  --------------------------------------------------------------------
  -- RMII TX signals
  --------------------------------------------------------------------
  signal tx_en     : std_logic := '0';
  signal txd       : std_logic_vector(1 downto 0) := "00";

  -- Byte streaming state
  type NIBIDX is (N0, N1, N2, N3);  -- which 2-bit slice of the current byte
  type TSTATE is (IDLE, PREAMBLE, SFD, FRAME_S, PAD, CRC0, CRC1, CRC2, CRC3, IFG);

  signal st        : TSTATE := IDLE;
  signal nidx      : NIBIDX := N0;

  signal pre_cnt   : integer range 0 to 6 := 0;     -- 7 bytes of 0x55
  signal bidx      : integer range 0 to FRAME_NOCRC := 0; -- current byte index into 'frame'
  signal cur_byte  : byte := (others => '0');

  -- CRC32 (reflected, Ethernet)
  signal crc       : std_logic_vector(31 downto 0) := (others => '1'); -- init 0xFFFFFFFF
  signal crc_final : std_logic_vector(31 downto 0);

  -- Periodic trigger (~50 ms)
  signal start_pulse : std_logic := '0';
  signal per_cnt     : unsigned(23 downto 0) := (others => '0');  -- 24-bit is plenty
  constant PERIOD    : unsigned(23 downto 0) := to_unsigned(2_500_000, 24); -- ~50 ms @ 50 MHz

  -- Inter-frame gap
  signal ifg_cnt : unsigned(6 downto 0) := (others => '0');  -- 7 bits is plenty
  constant IFG_CYCLES : unsigned(6 downto 0) := to_unsigned(24, 7);  -- 96 bit-times @100M -> 24 RMII clocks

  -- padding counter
  signal pad_cnt : integer range 0 to MIN_NOCRC := 0;

  -- Reset (active-high internal)
  signal rst       : std_logic;

  --------------------------------------------------------------------
  -- Functions
  --------------------------------------------------------------------
  -- IPv4 header checksum over 20 bytes at 'start' (checksum field zeroed beforehand)
  function ip_checksum(b : byte_array; start : integer) return std_logic_vector is
    variable sum  : unsigned(17 downto 0) := (others => '0');
    variable hi   : unsigned(7 downto 0);
    variable lo   : unsigned(7 downto 0);
    variable w16  : unsigned(15 downto 0);
  begin
    for i in 0 to 9 loop
      hi  := unsigned(b(start + 2*i));
      lo  := unsigned(b(start + 2*i + 1));
      w16 := (resize(hi, 16) sll 8) + resize(lo, 16);
      sum := sum + resize(w16, 18);
      -- fold carry
      sum := resize(sum(15 downto 0), 18) + resize(sum(17 downto 16), 18);
    end loop;
    -- final fold
    sum := resize(sum(15 downto 0), 18) + resize(sum(17 downto 16), 18);
    return std_logic_vector(not sum(15 downto 0));
  end function;

  -- Reflected Ethernet CRC32, byte-wise, LSB-first in, poly 0xEDB88320; no final XOR here
  function crc32_next_ref(crc_in : std_logic_vector(31 downto 0);
                          d      : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable c : std_logic_vector(31 downto 0) := crc_in;
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
  rmii_tx_en <= tx_en;
  rmii_txd   <= txd;
  rst        <= not rst_n;

  --------------------------------------------------------------------
  -- Build/refresh the fixed frame just before each transmission
  --------------------------------------------------------------------
  process(clk50)
    variable b    : byte_array(0 to FRAME_NOCRC-1);
    variable csum : std_logic_vector(15 downto 0);
  begin
    if rising_edge(clk50) then
      -- periodic one-shot (about every 50 ms)
      if rst = '1' then
        per_cnt     <= PERIOD;           -- wait one period after reset
        start_pulse <= '0';
      else
        if per_cnt = 0 then
          start_pulse <= '1';            -- fire once
          per_cnt     <= PERIOD;         -- reload for next time
        else
          start_pulse <= '0';
          per_cnt     <= per_cnt - 1;
        end if;
      end if;

      if rst = '1' then
        frame <= (others => (others => '0'));
      else
        -- Update the frame contents only right before a send
        if (st = IDLE) and (start_pulse = '1') then
          -- Ethernet header
          b( 0) := DST_MAC(47 downto 40);
          b( 1) := DST_MAC(39 downto 32);
          b( 2) := DST_MAC(31 downto 24);
          b( 3) := DST_MAC(23 downto 16);
          b( 4) := DST_MAC(15 downto 8);
          b( 5) := DST_MAC(7  downto 0);
          b( 6) := SRC_MAC(47 downto 40);
          b( 7) := SRC_MAC(39 downto 32);
          b( 8) := SRC_MAC(31 downto 24);
          b( 9) := SRC_MAC(23 downto 16);
          b(10) := SRC_MAC(15 downto 8);
          b(11) := SRC_MAC(7  downto 0);
          b(12) := x"08";  -- Ethertype IPv4 = 0x0800
          b(13) := x"00";

          -- IPv4 header (20 bytes), checksum field zero for now
          b(IP_OFF+ 0) := x"45";                -- Version(4), IHL(5)
          b(IP_OFF+ 1) := x"00";                -- TOS
          b(IP_OFF+ 2) := std_logic_vector(to_unsigned(IP_TLEN/256, 8));
          b(IP_OFF+ 3) := std_logic_vector(to_unsigned(IP_TLEN mod 256, 8));
          b(IP_OFF+ 4) := x"00";  b(IP_OFF+ 5) := x"01"; -- ID
          b(IP_OFF+ 6) := x"00";  b(IP_OFF+ 7) := x"00"; -- flags/frag
          b(IP_OFF+ 8) := x"40";                -- TTL = 64
          b(IP_OFF+ 9) := x"11";                -- Protocol = UDP (17)
          b(IP_OFF+10) := x"00";  b(IP_OFF+11) := x"00"; -- checksum (to be filled)
          b(IP_OFF+12) := SRC_IP(31 downto 24);
          b(IP_OFF+13) := SRC_IP(23 downto 16);
          b(IP_OFF+14) := SRC_IP(15 downto 8);
          b(IP_OFF+15) := SRC_IP(7  downto 0);
          b(IP_OFF+16) := DST_IP(31 downto 24);
          b(IP_OFF+17) := DST_IP(23 downto 16);
          b(IP_OFF+18) := DST_IP(15 downto 8);
          b(IP_OFF+19) := DST_IP(7  downto 0);

          -- UDP header
          b(UDP_OFF+0) := SRC_PORT(15 downto 8);
          b(UDP_OFF+1) := SRC_PORT(7  downto 0);
          b(UDP_OFF+2) := DST_PORT(15 downto 8);
          b(UDP_OFF+3) := DST_PORT(7  downto 0);
          b(UDP_OFF+4) := std_logic_vector(to_unsigned((UDP_HDR_LEN+PLEN)/256, 8));
          b(UDP_OFF+5) := std_logic_vector(to_unsigned((UDP_HDR_LEN+PLEN) mod 256, 8));
          b(UDP_OFF+6) := x"00";  b(UDP_OFF+7) := x"00"; -- UDP checksum = 0 (optional)

          -- Payload (ASCII)
          for i in 1 to PLEN loop
            b(UDP_OFF+7+i) := std_logic_vector(to_unsigned(character'pos(PAYLOAD_STR(i)), 8));
          end loop;

          -- Zero any padding region in the buffer (safety)
          if PAD_BYTES > 0 then
            for k in DATA_NOCRC to FRAME_NOCRC-1 loop
              b(k) := x"00";
            end loop;
          end if;

          -- IP header checksum
          csum := ip_checksum(b, IP_OFF);
          b(IP_OFF+10) := csum(15 downto 8);
          b(IP_OFF+11) := csum(7  downto 0);

          frame <= b;
        end if;
      end if;
    end if;
  end process;

  --------------------------------------------------------------------
  -- Periodic sender and RMII serialization (preamble/SFD/bytes/CRC/pad/IFG)
  --------------------------------------------------------------------
  process(clk50)
    variable cf : std_logic_vector(31 downto 0);
  begin
    if rising_edge(clk50) then
      if rst = '1' then
        st       <= IDLE;
        nidx     <= N0;
        pre_cnt  <= 0;
        bidx     <= 0;
        cur_byte <= (others => '0');
        tx_en    <= '0';
        txd      <= "00";
        crc      <= (others => '1');
        pad_cnt  <= 0;
      else
        -- State machine
        case st is
          when IDLE =>
            tx_en <= '0';
            txd   <= "00";

          when PREAMBLE =>
            case nidx is
              when N0 => txd <= "01"; nidx <= N1;
              when N1 => txd <= "01"; nidx <= N2;
              when N2 => txd <= "01"; nidx <= N3;
              when N3 =>
                txd   <= "01"; nidx <= N0;
                if pre_cnt = 6 then
                  cur_byte <= x"D5";
                  st       <= SFD;
                else
                  pre_cnt  <= pre_cnt + 1;
                end if;
            end case;

          when SFD =>
            case nidx is
              when N0 => txd <= cur_byte(1 downto 0); nidx <= N1;
              when N1 => txd <= cur_byte(3 downto 2); nidx <= N2;
              when N2 => txd <= cur_byte(5 downto 4); nidx <= N3;
              when N3 =>
                txd   <= cur_byte(7 downto 6); nidx <= N0;
                bidx     <= 0;
                cur_byte <= frame(0);
                crc      <= crc32_next_ref(crc, frame(0));
                st       <= FRAME_S;
            end case;

          when FRAME_S =>
            case nidx is
              when N0 => txd <= cur_byte(1 downto 0); nidx <= N1;
              when N1 => txd <= cur_byte(3 downto 2); nidx <= N2;
              when N2 => txd <= cur_byte(5 downto 4); nidx <= N3;
              when N3 =>
                txd   <= cur_byte(7 downto 6); nidx <= N0;

                if bidx = DATA_NOCRC-1 then          -- payload done (not min-size adjusted)
                  if PAD_BYTES > 0 then
                    pad_cnt  <= 0;
                    cur_byte <= x"00";
                    crc      <= crc32_next_ref(crc, x"00");
                    st       <= PAD;
                  else
                    cf := not crc;         -- final XOR
                    crc_final <= cf;
                    cur_byte  <= cf(7 downto 0);
                    st        <= CRC0;
                  end if;
                else
                  bidx     <= bidx + 1;
                  cur_byte <= frame(bidx + 1);
                  crc      <= crc32_next_ref(crc, frame(bidx + 1));
                end if;
            end case;

          when PAD =>
            case nidx is
              when N0 => txd <= "00"; nidx <= N1;
              when N1 => txd <= "00"; nidx <= N2;
              when N2 => txd <= "00"; nidx <= N3;
              when N3 =>
                txd   <= "00"; nidx <= N0;
                if pad_cnt = PAD_BYTES-1 then
                  cf := not crc;        -- finalize after last pad byte
                  crc_final <= cf;
                  cur_byte  <= cf(7 downto 0);
                  st        <= CRC0;
                else
                  pad_cnt <= pad_cnt + 1;
                  crc     <= crc32_next_ref(crc, x"00");
                end if;
            end case;

          when CRC0 | CRC1 | CRC2 | CRC3 =>
            case nidx is
              when N0 => txd <= cur_byte(1 downto 0); nidx <= N1;
              when N1 => txd <= cur_byte(3 downto 2); nidx <= N2;
              when N2 => txd <= cur_byte(5 downto 4); nidx <= N3;
              when N3 =>
                txd  <= cur_byte(7 downto 6); nidx <= N0;
                if    st = CRC0 then cur_byte <= crc_final(15 downto 8);  st <= CRC1;
                elsif st = CRC1 then cur_byte <= crc_final(23 downto 16); st <= CRC2;
                elsif st = CRC2 then cur_byte <= crc_final(31 downto 24); st <= CRC3;
                else
                  tx_en   <= '0';
                  txd     <= "00";
                  ifg_cnt <= IFG_CYCLES;
                  st      <= IFG;
                end if;
            end case;

          when IFG =>
            tx_en <= '0';
            txd   <= "00";
            if ifg_cnt = 0 then
              ifg_cnt <= IFG_CYCLES;
              st      <= IDLE;
            else
              ifg_cnt <= ifg_cnt - 1;
            end if;
        end case;

        -- Kick LAST so it overrides IDLE defaults above
        if (st = IDLE) and (start_pulse = '1') then
          tx_en   <= '1';
          txd     <= "01";        -- first 0x55 nibble
          pre_cnt <= 0;
          nidx    <= N0;
          crc     <= (others => '1');
          st      <= PREAMBLE;
        end if;
      end if;
    end if;
  end process;

end architecture;
