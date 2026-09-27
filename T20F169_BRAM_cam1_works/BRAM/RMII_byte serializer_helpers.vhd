-- ===== RMII byte serializer helpers (correct order) =====
-- Send one byte over RMII: (b1:b0) -> (b3:b2) -> (b5:b4) -> (b7:b6) on consecutive clk50 edges
type nidx_t is (N0, N1, N2, N3);

signal rmii_tx_en : std_logic := '0';
signal rmii_txd   : std_logic_vector(1 downto 0) := "00";
signal nidx       : nidx_t := N0;
signal sending    : std_logic := '0';
signal byte_out   : std_logic_vector(7 downto 0) := (others=>'0');

-- CRC32 (reflected), init all 1s
signal crc : std_logic_vector(31 downto 0) := (others => '1');

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

-- ===== State machine sketch =====
type TSTATE is (IDLE, PREAMBLE, SFD, FRAME, CRC0, CRC1, CRC2, CRC3, IFG);
signal st : TSTATE := IDLE;
signal pre_cnt : integer range 0 to 6 := 0;
signal frame_idx : integer := 0;  -- index into your frame bytes buffer
signal frame_len : integer := 0;  -- set to total bytes from DestMAC .. last UDP payload byte (no CRC)

process(clk50)
  variable final_crc : std_logic_vector(31 downto 0);
begin
  if rising_edge(clk50) then
    case st is
      when IDLE =>
        -- prepare your frame bytes, compute IP header checksum into the buffer, set frame_len
        crc      <= (others => '1');    -- CRC init
        pre_cnt  <= 0;
        rmii_tx_en <= '1';
        byte_out <= x"55";
        nidx     <= N0;
        st       <= PREAMBLE;

      when PREAMBLE =>
        -- send 0x55 as 01,01,01,01 (LSB-first)
        case nidx is
          when N0 => rmii_txd <= byte_out(1 downto 0); nidx <= N1;
          when N1 => rmii_txd <= byte_out(3 downto 2); nidx <= N2;
          when N2 => rmii_txd <= byte_out(5 downto 4); nidx <= N3;
          when N3 =>
            rmii_txd <= byte_out(7 downto 6); nidx <= N0;
            if pre_cnt = 6 then
              byte_out <= x"D5";        -- SFD next
              st <= SFD;
            else
              pre_cnt <= pre_cnt + 1;
            end if;
        end case;

      when SFD =>
        -- 0xD5 = 1101_0101 -> LSB-first pairs: 01,01,01,11
        case nidx is
          when N0 => rmii_txd <= byte_out(1 downto 0); nidx <= N1;
          when N1 => rmii_txd <= byte_out(3 downto 2); nidx <= N2;
          when N2 => rmii_txd <= byte_out(5 downto 4); nidx <= N3;
          when N3 =>
            rmii_txd <= byte_out(7 downto 6); nidx <= N0;
            -- first frame byte (Dest MAC byte 0)
            frame_idx <= 0;
            byte_out  <= frame_bytes(0);     -- your const/ROM buffer
            crc       <= crc32_next_ref(crc, frame_bytes(0));
            st        <= FRAME;
        end case;

      when FRAME =>
        case nidx is
          when N0 => rmii_txd <= byte_out(1 downto 0); nidx <= N1;
          when N1 => rmii_txd <= byte_out(3 downto 2); nidx <= N2;
          when N2 => rmii_txd <= byte_out(5 downto 4); nidx <= N3;
          when N3 =>
            rmii_txd <= byte_out(7 downto 6); nidx <= N0;
            if frame_idx = frame_len-1 then
              -- all bytes done -> move to CRC (finalize)
              final_crc := not crc;            -- FINAL XOR
              -- send LSB-first, low byte first
              byte_out  <= final_crc(7 downto 0);  st <= CRC0;
            else
              frame_idx <= frame_idx + 1;
              byte_out  <= frame_bytes(frame_idx + 1);
              crc       <= crc32_next_ref(crc, frame_bytes(frame_idx + 1));
            end if;
        end case;

      when CRC0 | CRC1 | CRC2 | CRC3 =>
        case nidx is
          when N0 => rmii_txd <= byte_out(1 downto 0); nidx <= N1;
          when N1 => rmii_txd <= byte_out(3 downto 2); nidx <= N2;
          when N2 => rmii_txd <= byte_out(5 downto 4); nidx <= N3;
          when N3 =>
            rmii_txd <= byte_out(7 downto 6); nidx <= N0;
            -- advance to next CRC byte
            if    st = CRC0 then byte_out <= (not crc)(15 downto 8);  st <= CRC1;
            elsif st = CRC1 then byte_out <= (not crc)(23 downto 16); st <= CRC2;
            elsif st = CRC2 then byte_out <= (not crc)(31 downto 24); st <= CRC3;
            else
              rmii_tx_en <= '0';
              rmii_txd   <= "00";
              st         <= IFG;
              ifg_cnt    <= 0;
            end if;
        end case;

      when IFG =>
        -- leave idle for a bit, then stop or repeat
        if ifg_cnt = SOME_COUNT then
          st <= IDLE;  -- or stay idle if you only want one packet
        else
          ifg_cnt <= ifg_cnt + 1;
        end if;
    end case;
  end if;
end process;
