library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity fifo_in_async_xpm is
    generic(
        DATA_WIDTH      :           integer         :=  16                          ;
        CDC_SYNC        :           integer         :=  4                           ;
        MEMTYPE         :           String          :=  "block"                     ;
        DEPTH           :           integer         :=  16                           
    );
    port(
        S_AXIS_CLK      :   in      std_logic                                       ;
        S_AXIS_RESET    :   in      std_logic                                       ;
        M_AXIS_CLK      :   in      std_logic                                       ;
        
        S_AXIS_TDATA    :   in      std_logic_Vector ( DATA_WIDTH-1 downto 0 )      ;
        S_AXIS_TKEEP    :   in      std_logic_Vector (( DATA_WIDTH/8)-1 downto 0 )  ;
        S_AXIS_TVALID   :   in      std_logic                                       ;
        S_AXIS_TLAST    :   in      std_logic                                       ;
        S_AXIS_TREADY   :   out     std_logic                                       ;

        IN_DOUT_DATA    :   out     std_logic_Vector ( DATA_WIDTH-1 downto 0 )      ;
        IN_DOUT_KEEP    :   out     std_logic_Vector ( ( DATA_WIDTH/8)-1 downto 0 ) ;
        IN_DOUT_LAST    :   out     std_logic                                       ;
        IN_RDEN         :   in      std_logic                                       ;
        IN_EMPTY        :   out     std_logic                                   
    );
end fifo_in_async_xpm;

architecture fifo_in_async_xpm_arch of fifo_in_async_xpm is
    constant FIFO_WIDTH : integer := DATA_WIDTH + ((DATA_WIDTH/8) + 1);

    -- Address width assumes DEPTH is a power of two (matches typical use like 16, 32, 64).
    -- If you set DEPTH to a non-power-of-two, round it up to the next power-of-two.
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

    -- Memory
    type ram_t is array (0 to (2**ADDR_W)-1) of std_logic_vector(FIFO_WIDTH-1 downto 0);
    signal ram : ram_t := (others => (others => '0'));

    -- Write domain signals
    signal w_full        : std_logic := '0';
    signal w_en_i        : std_logic;
    signal wptr_bin      : unsigned(ADDR_W downto 0) := (others => '0'); -- extra bit for full detection
    signal wptr_gray     : unsigned(ADDR_W downto 0) := (others => '0');
    signal rptr_gray_w   : unsigned(ADDR_W downto 0) := (others => '0'); -- read pointer synced into write domain

    -- Read domain signals
    signal r_empty       : std_logic := '1';
    signal rptr_bin      : unsigned(ADDR_W downto 0) := (others => '0');
    signal rptr_gray     : unsigned(ADDR_W downto 0) := (others => '0');
    signal wptr_gray_r   : unsigned(ADDR_W downto 0) := (others => '0'); -- write pointer synced into read domain

    -- Data path
    signal din  : std_logic_vector(FIFO_WIDTH-1 downto 0);
    signal dout : std_logic_vector(FIFO_WIDTH-1 downto 0) := (others => '0');

    -- CDC synchronizers (depth = CDC_SYNC, min 2)
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

    -- Helpers
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

    -- Pack AXIS side into FIFO data bus
    din( DATA_WIDTH-1 downto 0 )                      <= S_AXIS_TDATA;
    din( DATA_WIDTH + (DATA_WIDTH/8) - 1 downto DATA_WIDTH ) <= S_AXIS_TKEEP;
    din( DATA_WIDTH + (DATA_WIDTH/8) )                <= S_AXIS_TLAST;

    -- Handshake: ready is deasserted when full
    S_AXIS_TREADY <= not w_full;

    -- Unpack from FIFO
    IN_DOUT_DATA <= dout( DATA_WIDTH-1 downto 0 );
    IN_DOUT_KEEP <= dout( DATA_WIDTH + (DATA_WIDTH/8) - 1 downto DATA_WIDTH );
    IN_DOUT_LAST <= dout( DATA_WIDTH + (DATA_WIDTH/8) );

    -- Write enable when valid & ready
    w_en_i <= S_AXIS_TVALID and (not w_full);

    ---------------------------------
    -- WRITE DOMAIN (S_AXIS_CLK)
    ---------------------------------
    
process (S_AXIS_CLK)
    variable waddr : integer;
    variable nxt_wptr_bin  : unsigned(ADDR_W downto 0);
    variable nxt_wptr_gray : unsigned(ADDR_W downto 0);
    variable rptr_gray_w_local : unsigned(ADDR_W downto 0);
    function u(b : std_logic) return unsigned is
    begin
        if b = '1' then
            return to_unsigned(1, ADDR_W+1);
        else
            return (others => '0');
        end if;
    end function;
begin
    if rising_edge(S_AXIS_CLK) then
        if S_AXIS_RESET = '1' then
            wptr_bin   <= (others => '0');
            wptr_gray  <= (others => '0');
            rptr_sync_regs <= (others => (others => '0'));
            w_full     <= '0';
        else
            -- Synchronize read pointer into write clock domain
            rptr_sync_regs(0) <= rptr_gray;
            for i in 1 to SYNC_STAGES-1 loop
                rptr_sync_regs(i) <= rptr_sync_regs(i-1);
            end loop;
            rptr_gray_w <= rptr_sync_regs(SYNC_STAGES-1);

            -- Write
            if w_en_i = '1' then
                waddr := to_integer(wptr_bin(ADDR_W-1 downto 0));
                ram(waddr) <= din;
                wptr_bin   <= wptr_bin + 1;
            end if;

            -- Update gray-coded pointer
            wptr_gray <= bin2gray(wptr_bin);

            -- Full detection
            rptr_gray_w_local := rptr_gray_w;
            nxt_wptr_bin  := wptr_bin + u(w_en_i);
            nxt_wptr_gray := bin2gray(nxt_wptr_bin);

            -- Full when next write pointer equals read pointer with MSBs inverted
            if (nxt_wptr_gray(ADDR_W) = not rptr_gray_w_local(ADDR_W)) and
               (nxt_wptr_gray(ADDR_W-1) = not rptr_gray_w_local(ADDR_W-1)) and
               nxt_wptr_gray(ADDR_W-2 downto 0)     = rptr_gray_w_local(ADDR_W-2 downto 0) then
                w_full <= '1';
            else
                w_full <= '0';
            end if;
        end if;
    end if;
end process;


    ---------------------------------
    -- READ DOMAIN (M_AXIS_CLK)
    ---------------------------------
    process (M_AXIS_CLK)
        variable raddr : integer;
        variable nxt_rptr_bin  : unsigned(ADDR_W downto 0);
        variable nxt_rptr_gray : unsigned(ADDR_W downto 0);
        variable wptr_gray_r_local : unsigned(ADDR_W downto 0);
        variable fifo_empty : std_logic;
        variable have_data  : std_logic;
    begin
        if rising_edge(M_AXIS_CLK) then
            if S_AXIS_RESET = '1' then
                rptr_bin   <= (others => '0');
                rptr_gray  <= (others => '0');
                wptr_sync_regs <= (others => (others => '0'));
                r_empty    <= '1';
                dout       <= (others => '0');
            else
                -- Synchronize write pointer into read clock domain
                wptr_sync_regs(0) <= wptr_gray;
                for i in 1 to SYNC_STAGES-1 loop
                    wptr_sync_regs(i) <= wptr_sync_regs(i-1);
                end loop;
                wptr_gray_r <= wptr_sync_regs(SYNC_STAGES-1);

                -- Empty test
                wptr_gray_r_local := wptr_gray_r;
                fifo_empty := '1' when rptr_gray = wptr_gray_r_local else '0';

                -- First-word-fall-through behavior:
                -- Drive dout with current location when data exists.
                have_data := (not fifo_empty);

                if have_data = '1' then
                    raddr := to_integer(rptr_bin(ADDR_W-1 downto 0));
                    dout <= ram(raddr);
                end if;

                -- Advance read pointer only when consumer asserts IN_RDEN and data is available
                if (IN_RDEN = '1') and (have_data = '1') then
                    rptr_bin  <= rptr_bin + 1;
                    rptr_gray <= bin2gray(rptr_bin + 1);
                end if;

                r_empty <= fifo_empty;
            end if;
        end if;
    end process;

    -- Outputs
    IN_EMPTY <= r_empty;
    
end fifo_in_async_xpm_arch;