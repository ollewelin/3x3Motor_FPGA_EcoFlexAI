// dphy_debug_sniffer.sv
// Samples DPHY lane signals and provides debug bytes directly to ETH TX
// (bypasses BRAM — every UDP packet contains the full debug report)
//
// Connect rd_addr to bram_read_addr, debug_byte to data mux.
// Repeating 32-byte debug report in every packet:
//
//   Byte  Content
//   0     0xDE              Magic byte 1
//   1     0xBF              Magic byte 2
//   2     LP state:         {2'b0, CLK_LP_P, CLK_LP_N, D1_LP_P, D1_LP_N, D0_LP_P, D0_LP_N}
//   3     Flags:            {4'b0, clk_toggling, d0_hs_seen, d1_hs_seen, d0_in_hs_now}
//   4     CLK toggle count [15:8]
//   5     CLK toggle count [7:0]
//   6     D0 LP→HS transition count [15:8]
//   7     D0 LP→HS transition count [7:0]
//   8     D1 LP→HS transition count [15:8]
//   9     D1 LP→HS transition count [7:0]
//  10     D0 HS bytes captured count [15:8]
//  11     D0 HS bytes captured count [7:0]
//  12     D0 last HS byte seen
//  13     D1 last HS byte seen
//  14     D0 first HS byte (after LP→HS)
//  15     D1 first HS byte (after LP→HS)
//  16     Snapshot counter [7:0] (increments each report)
//  17     D0 HS_IN live sample (real-time)
//  18     D1 HS_IN live sample (real-time)
//  19     LP raw: {CLK_LP_P, CLK_LP_N, D0_LP_P, D0_LP_N, D1_LP_P, D1_LP_N, 2'b0}
//  20-31  0xAA padding
//
// tcpdump decode: payload starts at offset 0x002A in -xx output

module dphy_debug_sniffer (
    input  wire        clk,          // System clock (PLL_125MHZ)
    input  wire        rst_n,

    // DPHY signals (directly from top-level ports)
    input  wire        cam_clk_clkout,    // Recovered byte clock
    input  wire        cam_clk_lp_p,
    input  wire        cam_clk_lp_n,
    input  wire [7:0]  cam_d0_hs_in,
    input  wire        cam_d0_lp_p,
    input  wire        cam_d0_lp_n,
    input  wire [7:0]  cam_d1_hs_in,
    input  wire        cam_d1_lp_p,
    input  wire        cam_d1_lp_n,

    // Direct byte output for ETH TX (no BRAM needed)
    input  wire [15:0] rd_addr,       // From bram_read_addr (byte address)
    output reg  [7:0]  debug_byte     // Muxed debug byte for ETH TX
);

    // =========================================================================
    // 2-stage synchronizers (DPHY signals are async to clk)
    // =========================================================================
    reg [1:0] clk_lp_p_sync, clk_lp_n_sync;
    reg [1:0] d0_lp_p_sync,  d0_lp_n_sync;
    reg [1:0] d1_lp_p_sync,  d1_lp_n_sync;
    reg [1:0] clkout_sync;
    reg [7:0] d0_hs_sync1, d0_hs_sync2;
    reg [7:0] d1_hs_sync1, d1_hs_sync2;

    always @(posedge clk) begin
        clk_lp_p_sync <= {clk_lp_p_sync[0], cam_clk_lp_p};
        clk_lp_n_sync <= {clk_lp_n_sync[0], cam_clk_lp_n};
        d0_lp_p_sync  <= {d0_lp_p_sync[0],  cam_d0_lp_p};
        d0_lp_n_sync  <= {d0_lp_n_sync[0],  cam_d0_lp_n};
        d1_lp_p_sync  <= {d1_lp_p_sync[0],  cam_d1_lp_p};
        d1_lp_n_sync  <= {d1_lp_n_sync[0],  cam_d1_lp_n};
        clkout_sync   <= {clkout_sync[0],    cam_clk_clkout};
        d0_hs_sync1   <= cam_d0_hs_in;  d0_hs_sync2 <= d0_hs_sync1;
        d1_hs_sync1   <= cam_d1_hs_in;  d1_hs_sync2 <= d1_hs_sync1;
    end

    // Synced signals
    wire clk_lp_p = clk_lp_p_sync[1];
    wire clk_lp_n = clk_lp_n_sync[1];
    wire d0_lp_p  = d0_lp_p_sync[1];
    wire d0_lp_n  = d0_lp_n_sync[1];
    wire d1_lp_p  = d1_lp_p_sync[1];
    wire d1_lp_n  = d1_lp_n_sync[1];
    wire clkout   = clkout_sync[1];
    wire [7:0] d0_hs = d0_hs_sync2;
    wire [7:0] d1_hs = d1_hs_sync2;

    // =========================================================================
    // Edge / event detection
    // =========================================================================
    reg clkout_prev;
    reg d0_lp_p_prev, d1_lp_p_prev;
    reg [7:0] d0_hs_prev, d1_hs_prev;

    wire clkout_edge = (clkout != clkout_prev);
    wire d0_lp_to_hs = (d0_lp_p_prev && !d0_lp_p);
    wire d1_lp_to_hs = (d1_lp_p_prev && !d1_lp_p);
    wire d0_in_hs = (!d0_lp_p && !d0_lp_n);
    wire d1_in_hs = (!d1_lp_p && !d1_lp_n);

    always @(posedge clk) begin
        clkout_prev   <= clkout;
        d0_lp_p_prev  <= d0_lp_p;
        d1_lp_p_prev  <= d1_lp_p;
        d0_hs_prev    <= d0_hs;
        d1_hs_prev    <= d1_hs;
    end

    // =========================================================================
    // Counters & state tracking
    // =========================================================================
    reg [15:0] clk_toggle_cnt;
    reg [15:0] d0_lp_hs_cnt;
    reg [15:0] d1_lp_hs_cnt;
    reg [15:0] d0_hs_byte_cnt;
    reg [7:0]  d0_last_hs, d1_last_hs;
    reg [7:0]  d0_first_hs, d1_first_hs;
    reg        d0_hs_seen, d1_hs_seen;
    reg        clk_toggling;
    reg [7:0]  snapshot_cnt;
    reg        d0_first_captured, d1_first_captured;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_toggle_cnt <= 0;
            d0_lp_hs_cnt   <= 0;
            d1_lp_hs_cnt   <= 0;
            d0_hs_byte_cnt <= 0;
            d0_last_hs     <= 0;
            d1_last_hs     <= 0;
            d0_first_hs    <= 0;
            d1_first_hs    <= 0;
            d0_hs_seen     <= 0;
            d1_hs_seen     <= 0;
            clk_toggling   <= 0;
            snapshot_cnt   <= 0;
            d0_first_captured <= 0;
            d1_first_captured <= 0;
        end else begin
            if (clkout_edge) begin
                clk_toggle_cnt <= clk_toggle_cnt + 1;
                clk_toggling   <= 1;
            end

            if (d0_lp_to_hs) begin
                d0_lp_hs_cnt <= d0_lp_hs_cnt + 1;
                d0_first_captured <= 0;
            end

            if (d1_lp_to_hs) begin
                d1_lp_hs_cnt <= d1_lp_hs_cnt + 1;
                d1_first_captured <= 0;
            end

            if (d0_in_hs && (d0_hs != d0_hs_prev || !d0_hs_seen)) begin
                d0_last_hs     <= d0_hs;
                d0_hs_seen     <= 1;
                d0_hs_byte_cnt <= d0_hs_byte_cnt + 1;
                if (!d0_first_captured) begin
                    d0_first_hs <= d0_hs;
                    d0_first_captured <= 1;
                end
            end

            if (d1_in_hs && (d1_hs != d1_hs_prev || !d1_hs_seen)) begin
                d1_last_hs <= d1_hs;
                d1_hs_seen <= 1;
                if (!d1_first_captured) begin
                    d1_first_hs <= d1_hs;
                    d1_first_captured <= 1;
                end
            end

            // Snapshot counter increments slowly for "is it live?" check
            // (increments once per ~1M clocks = ~8ms)
            snapshot_cnt <= snapshot_cnt + 1;
        end
    end

    // =========================================================================
    // Direct byte output: repeating 32-byte debug report
    // ETH TX reads this by address — every packet gets the same report
    // =========================================================================
    always @(*) begin
        case (rd_addr[4:0])   // 32-byte repeating pattern
            5'd0:  debug_byte = 8'hDE;
            5'd1:  debug_byte = 8'hBF;
            5'd2:  debug_byte = {2'b0, clk_lp_p, clk_lp_n, d1_lp_p, d1_lp_n, d0_lp_p, d0_lp_n};
            5'd3:  debug_byte = {4'b0, clk_toggling, d0_hs_seen, d1_hs_seen, d0_in_hs};
            5'd4:  debug_byte = clk_toggle_cnt[15:8];
            5'd5:  debug_byte = clk_toggle_cnt[7:0];
            5'd6:  debug_byte = d0_lp_hs_cnt[15:8];
            5'd7:  debug_byte = d0_lp_hs_cnt[7:0];
            5'd8:  debug_byte = d1_lp_hs_cnt[15:8];
            5'd9:  debug_byte = d1_lp_hs_cnt[7:0];
            5'd10: debug_byte = d0_hs_byte_cnt[15:8];
            5'd11: debug_byte = d0_hs_byte_cnt[7:0];
            5'd12: debug_byte = d0_last_hs;
            5'd13: debug_byte = d1_last_hs;
            5'd14: debug_byte = d0_first_hs;
            5'd15: debug_byte = d1_first_hs;
            5'd16: debug_byte = snapshot_cnt;
            5'd17: debug_byte = d0_hs;   // live D0 HS sample
            5'd18: debug_byte = d1_hs;   // live D1 HS sample
            5'd19: debug_byte = {clk_lp_p, clk_lp_n, d0_lp_p, d0_lp_n, d1_lp_p, d1_lp_n, 2'b0};
            default: debug_byte = 8'hAA; // padding (easy to spot)
        endcase
    end

endmodule
