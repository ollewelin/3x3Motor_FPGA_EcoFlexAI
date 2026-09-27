
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo_out_async_xpm is
    generic(
        DATA_WIDTH      :           integer         :=  256                         ;
        CDC_SYNC        :           integer         :=  4                           ;
        MEMTYPE         :           String          :=  "block"                     ;
        DEPTH           :           integer         :=  16                           
    );
    port(
        CLK             :   in      std_logic                                       ;
        RESET           :   in      std_logic                                       ;        
        OUT_DIN_DATA    :   in      std_logic_Vector ( DATA_WIDTH-1 downto 0 )      ;
        OUT_DIN_KEEP    :   in      std_logic_Vector ( ( DATA_WIDTH/8)-1 downto 0 ) ;
        OUT_DIN_LAST    :   in      std_logic                                       ;
        OUT_WREN        :   in      std_logic                                       ;
        OUT_FULL        :   out     std_logic                                       ;
        OUT_AWFULL      :   out     std_logic                                       ;

        M_AXIS_CLK      :   in      std_logic                                       ;
        M_AXIS_TDATA    :   out     std_logic_Vector ( DATA_WIDTH-1 downto 0 )      ;
        M_AXIS_TKEEP    :   out     std_logic_Vector (( DATA_WIDTH/8)-1 downto 0 )  ;
        M_AXIS_TVALID   :   out     std_logic                                       ;
        M_AXIS_TLAST    :   out     std_logic                                       ;
        M_AXIS_TREADY   :   in      std_logic                                        

    );
end fifo_out_async_xpm;

architecture fifo_out_async_xpm_arch of fifo_out_async_xpm is

    constant FIFO_WIDTH : integer := DATA_WIDTH + ((DATA_WIDTH/8) + 1);

    -- Address width assumes DEPTH is power-of-two
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

    type ram_t is array (0 to (2**ADDR_W)-1) of std_logic_vector(FIFO_WIDTH-1 downto 0);
    signal ram : ram_t := (others => (others => '0'));

    -- Write domain (CLK)
    signal wptr_bin   : unsigned(ADDR_W downto 0) := (others => '0');
    signal wptr_gray  : unsigned(ADDR_W downto 0) := (others => '0');
    signal rptr_gray_w: unsigned(ADDR_W downto 0) := (others => '0');
    signal full_i     : std_logic := '0';
    signal awfull_i   : std_logic := '0'; -- simple approx (assert near full threshold)

    -- Read domain (M_AXIS_CLK)
    signal rptr_bin   : unsigned(ADDR_W downto 0) := (others => '0');
    signal rptr_gray  : unsigned(ADDR_W downto 0) := (others => '0');
    signal wptr_gray_r: unsigned(ADDR_W downto 0) := (others => '0');
    signal empty_i    : std_logic := '1';

    -- Data
    signal din  : std_logic_vector(FIFO_WIDTH-1 downto 0);
    signal dout : std_logic_vector(FIFO_WIDTH-1 downto 0) := (others => '0');

    -- rden from AXIS
    signal rden : std_logic := '0';

    -- synchronizers
    function to_nat(s : integer) return integer is
    begin
        if s < 2 then return 2; else return s; end if;
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

    din <= OUT_DIN_LAST & OUT_DIN_KEEP & OUT_DIN_DATA;
    rden <= '1' when (empty_i = '0' and M_AXIS_TREADY = '1') else '0';

    M_AXIS_TDATA  <= dout(DATA_WIDTH-1 downto 0);
    M_AXIS_TKEEP  <= dout((DATA_WIDTH + (DATA_WIDTH/8)) - 1 downto DATA_WIDTH);
    M_AXIS_TLAST  <= dout(DATA_WIDTH + (DATA_WIDTH/8));
    M_AXIS_TVALID <= not empty_i;

    OUT_FULL  <= full_i;
    OUT_AWFULL <= awfull_i;

    -- WRITE DOMAIN
    process (CLK)
        variable waddr : integer;
        variable nxt_wptr_bin  : unsigned(ADDR_W downto 0);
        variable nxt_wptr_gray : unsigned(ADDR_W downto 0);
        variable rptr_gray_w_local : unsigned(ADDR_W downto 0);
        variable rptr_bin_synced : unsigned(ADDR_W downto 0);
        function inc_when(b : std_logic) return unsigned is
        begin
            if b = '1' then
                return to_unsigned(1, ADDR_W+1);
            else
                return (others => '0');
            end if;
        end function;
        variable fill_level : integer;
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                wptr_bin  <= (others => '0');
                wptr_gray <= (others => '0');
                rptr_sync_regs <= (others => (others => '0'));
                full_i    <= '0';
                awfull_i  <= '0';
            else
                -- sync read ptr into write domain
                rptr_sync_regs(0) <= rptr_gray;
                for i in 1 to SYNC_STAGES-1 loop
                    rptr_sync_regs(i) <= rptr_sync_regs(i-1);
                end loop;
                rptr_gray_w <= rptr_sync_regs(SYNC_STAGES-1);

                -- write when enabled and not full
                if (OUT_WREN = '1') and (full_i = '0') then
                    waddr := to_integer(wptr_bin(ADDR_W-1 downto 0));
                    ram(waddr) <= din;
                    wptr_bin   <= wptr_bin + 1;
                end if;

                wptr_gray <= bin2gray(wptr_bin);

                -- full detection
                rptr_gray_w_local := rptr_gray_w;
                nxt_wptr_bin  := wptr_bin + inc_when(OUT_WREN and (not full_i));
                nxt_wptr_gray := bin2gray(nxt_wptr_bin);

                if (nxt_wptr_gray(ADDR_W) = not rptr_gray_w_local(ADDR_W)) and
                   (nxt_wptr_gray(ADDR_W-1) = not rptr_gray_w_local(ADDR_W-1)) and
                   (nxt_wptr_gray(ADDR_W-2 downto 0) = rptr_gray_w_local(ADDR_W-2 downto 0)) then
                    full_i <= '1';
                else
                    full_i <= '0';
                end if;

                -- approx almost-full: set when fill >= depth - 2
                -- compute fill from binary pointers (write domain view of read ptr)
                rptr_bin_synced := gray2bin(rptr_gray_w);
                fill_level := to_integer(wptr_bin(ADDR_W-1 downto 0)) - to_integer(rptr_bin_synced(ADDR_W-1 downto 0));
                if fill_level < 0 then
                    fill_level := fill_level + (2**ADDR_W);
                end if;
                if fill_level >= (2**ADDR_W - 2) then
                    awfull_i <= '1';
                else
                    awfull_i <= '0';
                end if;
            end if;
        end if;
    end process;

    -- READ DOMAIN
    process (M_AXIS_CLK)
        variable raddr : integer;
        variable wptr_gray_r_local : unsigned(ADDR_W downto 0);
        variable fifo_empty : std_logic;
        variable have_data  : std_logic;
    begin
        if rising_edge(M_AXIS_CLK) then
            if RESET = '1' then
                rptr_bin   <= (others => '0');
                rptr_gray  <= (others => '0');
                wptr_sync_regs <= (others => (others => '0'));
                empty_i    <= '1';
                dout       <= (others => '0');
            else
                -- sync write ptr into read domain
                wptr_sync_regs(0) <= wptr_gray;
                for i in 1 to SYNC_STAGES-1 loop
                    wptr_sync_regs(i) <= wptr_sync_regs(i-1);
                end loop;
                wptr_gray_r <= wptr_sync_regs(SYNC_STAGES-1);

                wptr_gray_r_local := wptr_gray_r;
                fifo_empty := '1' when rptr_gray = wptr_gray_r_local else '0';
                have_data  := not fifo_empty;

                -- FWFT
                if have_data = '1' then
                    raddr := to_integer(rptr_bin(ADDR_W-1 downto 0));
                    dout <= ram(raddr);
                end if;

                if (rden = '1') and (have_data = '1') then
                    rptr_bin  <= rptr_bin + 1;
                    rptr_gray <= bin2gray(rptr_bin + 1);
                end if;

                empty_i <= fifo_empty;
            end if;
        end if;
    end process;

end fifo_out_async_xpm_arch;
