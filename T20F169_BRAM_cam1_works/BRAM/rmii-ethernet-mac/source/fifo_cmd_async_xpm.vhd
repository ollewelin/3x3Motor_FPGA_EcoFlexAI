library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo_cmd_async_xpm is
    generic(
        DATA_WIDTH      :           integer         :=  64                          ;
        CDC_SYNC        :           integer         :=  4                           ;
        MEMTYPE         :           String          :=  "block"                     ;
        DEPTH           :           integer         :=  16                           
    );
    port(
        CLK_WR          :   in      std_logic                                       ;
        RESET_WR        :   in      std_logic                                       ;
        CLK_RD          :   in      std_logic                                       ;
        
        DIN             :   in      std_logic_vector ( DATA_WIDTH-1 downto 0 )      ;
        WREN            :   in      std_logic                                       ;
        FULL            :   out     std_logic                                       ;
        DOUT            :   out     std_logic_Vector ( DATA_WIDTH-1 downto 0 )      ;
        RDEN            :   IN      std_logic                                       ;
        EMPTY           :   out     std_logic                                        

    );
end fifo_cmd_async_xpm;

architecture fifo_cmd_async_xpm_arch of fifo_cmd_async_xpm is

    function clog2(n : integer) return integer is
        variable i : integer := 0;
        variable v : integer := 1;
    begin
        while v < n loop
            v := v * 2;
            i := i + 1;
        end loop;
        return i;
    end function;

    constant ADDR_W : integer := clog2(DEPTH);

    type ram_t is array (0 to (2**ADDR_W)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ram : ram_t := (others => (others => '0'));

    -- Write domain
    signal wptr_bin   : unsigned(ADDR_W downto 0) := (others => '0');
    signal wptr_gray  : unsigned(ADDR_W downto 0) := (others => '0');
    signal rptr_gray_w: unsigned(ADDR_W downto 0) := (others => '0');
    signal full_i     : std_logic := '0';

    -- Read domain
    signal rptr_bin   : unsigned(ADDR_W downto 0) := (others => '0');
    signal rptr_gray  : unsigned(ADDR_W downto 0) := (others => '0');
    signal wptr_gray_r: unsigned(ADDR_W downto 0) := (others => '0');
    signal empty_i    : std_logic := '1';
    signal dout_i     : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

    -- Synchronizers
    function to_nat(s : integer) return integer is
    begin
        if s < 2 then
            return 2;
        else
            return s;
        end if;
    end function;
    constant SYNC_STAGES : integer := to_nat(CDC_SYNC);

    type reg_arr is array (natural range <>) of unsigned(ADDR_W downto 0);
    signal rptr_sync_regs : reg_arr(0 to SYNC_STAGES-1) := (others => (others => '0'));
    signal wptr_sync_regs : reg_arr(0 to SYNC_STAGES-1) := (others => (others => '0'));

    -- helpers
    function bin2gray(b : unsigned) return unsigned is
    begin
        return b xor unsigned('0' & std_logic_vector(b(b'high downto 1)));
    end function;

    function gray2bin(g : unsigned) return unsigned is
        variable b : unsigned(g'range) := (others => '0');
        variable hi : integer := g'left;
    begin
        b(hi) := g(hi);
        for i in hi-1 downto 0 loop
            b(i) := b(i+1) xor g(i);
        end loop;
        return b;
    end function;

begin

    FULL  <= full_i;
    EMPTY <= empty_i;
    DOUT  <= dout_i;

    ----------------------------
    -- WRITE CLOCK DOMAIN
    ----------------------------
    process (CLK_WR)
        variable waddr : integer;
        variable nxt_wptr_bin  : unsigned(ADDR_W downto 0);
        variable nxt_wptr_gray : unsigned(ADDR_W downto 0);
        variable rptr_gray_w_local : unsigned(ADDR_W downto 0);
        function inc_when(b : std_logic) return unsigned is
        begin
            if b = '1' then
                return to_unsigned(1, ADDR_W+1);
            else
                return (others => '0');
            end if;
        end function;
    begin
        if rising_edge(CLK_WR) then
            if RESET_WR = '1' then
                wptr_bin  <= (others => '0');
                wptr_gray <= (others => '0');
                rptr_sync_regs <= (others => (others => '0'));
                full_i    <= '0';
            else
                -- sync read pointer into write domain
                rptr_sync_regs(0) <= rptr_gray;
                for i in 1 to SYNC_STAGES-1 loop
                    rptr_sync_regs(i) <= rptr_sync_regs(i-1);
                end loop;
                rptr_gray_w <= rptr_sync_regs(SYNC_STAGES-1);

                -- write when enabled and not full
                if (WREN = '1') and (full_i = '0') then
                    waddr := to_integer(wptr_bin(ADDR_W-1 downto 0));
                    ram(waddr) <= DIN;
                    wptr_bin   <= wptr_bin + 1;
                end if;

                wptr_gray <= bin2gray(wptr_bin);

                rptr_gray_w_local := rptr_gray_w;
                nxt_wptr_bin  := wptr_bin + inc_when((WREN and (not full_i)));
                nxt_wptr_gray := bin2gray(nxt_wptr_bin);

                -- full when next write ptr equals read ptr with MSBs inverted
                if (nxt_wptr_gray(ADDR_W) = not rptr_gray_w_local(ADDR_W)) and
                   (nxt_wptr_gray(ADDR_W-1) = not rptr_gray_w_local(ADDR_W-1)) and
                   (nxt_wptr_gray(ADDR_W-2 downto 0) = rptr_gray_w_local(ADDR_W-2 downto 0)) then
                    full_i <= '1';
                else
                    full_i <= '0';
                end if;
            end if;
        end if;
    end process;

    ----------------------------
    -- READ CLOCK DOMAIN
    ----------------------------
    process (CLK_RD)
        variable raddr : integer;
        variable wptr_gray_r_local : unsigned(ADDR_W downto 0);
        variable fifo_empty : std_logic;
        variable have_data  : std_logic;
    begin
        if rising_edge(CLK_RD) then
            if RESET_WR = '1' then  -- keep same reset wiring as original XPM instantiation
                rptr_bin   <= (others => '0');
                rptr_gray  <= (others => '0');
                wptr_sync_regs <= (others => (others => '0'));
                empty_i    <= '1';
                dout_i     <= (others => '0');
            else
                -- sync write pointer into read domain
                wptr_sync_regs(0) <= wptr_gray;
                for i in 1 to SYNC_STAGES-1 loop
                    wptr_sync_regs(i) <= wptr_sync_regs(i-1);
                end loop;
                wptr_gray_r <= wptr_sync_regs(SYNC_STAGES-1);

                wptr_gray_r_local := wptr_gray_r;
                fifo_empty := '1' when rptr_gray = wptr_gray_r_local else '0';
                have_data  := not fifo_empty;

                -- FWFT read
                if have_data = '1' then
                    raddr := to_integer(rptr_bin(ADDR_W-1 downto 0));
                    dout_i <= ram(raddr);
                end if;

                if (RDEN = '1') and (have_data = '1') then
                    rptr_bin  <= rptr_bin + 1;
                    rptr_gray <= bin2gray(rptr_bin + 1);
                end if;

                empty_i <= fifo_empty;
            end if;
        end if;
    end process;

end fifo_cmd_async_xpm_arch;
