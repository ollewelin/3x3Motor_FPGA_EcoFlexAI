/*
 * video_to_udp.sv – RGMII 1 Gbps UDP transmitter (DDR interface)
 *
 * Generates valid Ethernet/IPv4/UDP frames continuously at 1 Gbps.
 *
 *  - IEEE 802.3 CRC-32 for FCS
 *  - Correct RGMII nibble ordering (rising = lo nibble, falling = hi nibble)
 *  - Pre-computed IP header checksum
 *  - 12-byte inter-frame gap
 */
module video_to_udp #(
    parameter PAYLOAD_SIZE = 1472
)(
    input  wire        clk_125MHz,
    input  wire        rst_n,
    input  wire        enable,
    output wire [3:0]  txd_hi,       // rising-edge nibble  = byte[3:0]
    output wire [3:0]  txd_lo,       // falling-edge nibble = byte[7:4]
    output wire        txctl_hi,
    output wire        txctl_lo,
    output wire        frame_active,
    output wire [31:0] frame_count
);

    /* ------------------------------------------------------------------ */
    /*  Frame constants                                                   */
    /* ------------------------------------------------------------------ */
    localparam [47:0] MAC_DA = 48'hA8_5E_45_B9_CB_08;   // PC
    localparam [47:0] MAC_SA = 48'hA0_A1_A2_A3_A4_A5;   // FPGA
    localparam [15:0] ETYPE  = 16'h0800;                 // IPv4

    localparam [31:0] IP_SRC = 32'hC0A8_01C8;           // 192.168.1.200
    localparam [31:0] IP_DST = 32'hC0A8_0164;           // 192.168.1.100

    localparam [15:0] UDP_SP = 16'd4660;                 // src port  (decimal 4660 = 0x1234)
    localparam [15:0] UDP_DP = 16'd4660;                 // dst port

    /* derived lengths */
    localparam [15:0] IP_TOT = 16'd28 + PAYLOAD_SIZE;   // 20 + 8 + payload
    localparam [15:0] UDP_LN = 16'd8  + PAYLOAD_SIZE;   // 8 + payload

    /* IP header checksum – ones-complement sum, then invert */
    localparam [31:0] _C0 = 32'h4500 + {16'd0, IP_TOT} + 32'h4000 +
                            32'h4011 +
                            {16'd0, IP_SRC[31:16]} + {16'd0, IP_SRC[15:0]} +
                            {16'd0, IP_DST[31:16]} + {16'd0, IP_DST[15:0]};
    localparam [31:0] _C1 = _C0[15:0] + _C0[31:16];
    localparam [31:0] _C2 = _C1[15:0] + _C1[31:16];
    localparam [15:0] IP_CS = ~_C2[15:0];

    localparam HDR_LEN = 42;   // 6+6+2+20+8
    localparam IFG_LEN = 12;

    /* ------------------------------------------------------------------ */
    /*  State machine                                                      */
    /* ------------------------------------------------------------------ */
    typedef enum logic [2:0] {
        S_IDLE  = 3'd0,
        S_PRE   = 3'd1,   // preamble + SFD
        S_HDR   = 3'd2,   // MAC DA/SA + EtherType + IPv4 + UDP headers
        S_PAY   = 3'd3,   // payload
        S_FCS   = 3'd4,   // CRC-32
        S_IFG   = 3'd5    // inter-frame gap
    } st_t;

    st_t         state, nxt;
    logic [15:0] bcnt;
    logic [31:0] fcnt;
    logic        tx_en;
    logic [7:0]  tbyte;
    wire  [31:0] crc_out_wire;   // FCS from eth_crc32 (already inverted + bit-reversed)

    logic [3:0]  dhi, dlo;
    logic        chi, clo;

    /* ------------------------------------------------------------------ */
    /*  42-byte header look-up                                             */
    /* ------------------------------------------------------------------ */
    function automatic [7:0] hdr (input [5:0] idx);
        case (idx)
            /* MAC DA */
            6'd0 : hdr = MAC_DA[47:40];  6'd1 : hdr = MAC_DA[39:32];
            6'd2 : hdr = MAC_DA[31:24];  6'd3 : hdr = MAC_DA[23:16];
            6'd4 : hdr = MAC_DA[15:8];   6'd5 : hdr = MAC_DA[7:0];
            /* MAC SA */
            6'd6 : hdr = MAC_SA[47:40];  6'd7 : hdr = MAC_SA[39:32];
            6'd8 : hdr = MAC_SA[31:24];  6'd9 : hdr = MAC_SA[23:16];
            6'd10: hdr = MAC_SA[15:8];   6'd11: hdr = MAC_SA[7:0];
            /* EtherType */
            6'd12: hdr = ETYPE[15:8];    6'd13: hdr = ETYPE[7:0];
            /* IPv4 — 20 bytes */
            6'd14: hdr = 8'h45;          6'd15: hdr = 8'h00;          // ver/ihl, dscp
            6'd16: hdr = IP_TOT[15:8];   6'd17: hdr = IP_TOT[7:0];   // total len
            6'd18: hdr = 8'h00;          6'd19: hdr = 8'h00;          // ident
            6'd20: hdr = 8'h40;          6'd21: hdr = 8'h00;          // flags/frag
            6'd22: hdr = 8'h40;          6'd23: hdr = 8'h11;          // ttl=64, proto=UDP
            6'd24: hdr = IP_CS[15:8];    6'd25: hdr = IP_CS[7:0];     // IP checksum
            6'd26: hdr = IP_SRC[31:24];  6'd27: hdr = IP_SRC[23:16];
            6'd28: hdr = IP_SRC[15:8];   6'd29: hdr = IP_SRC[7:0];
            6'd30: hdr = IP_DST[31:24];  6'd31: hdr = IP_DST[23:16];
            6'd32: hdr = IP_DST[15:8];   6'd33: hdr = IP_DST[7:0];
            /* UDP — 8 bytes */
            6'd34: hdr = UDP_SP[15:8];   6'd35: hdr = UDP_SP[7:0];
            6'd36: hdr = UDP_DP[15:8];   6'd37: hdr = UDP_DP[7:0];
            6'd38: hdr = UDP_LN[15:8];   6'd39: hdr = UDP_LN[7:0];
            6'd40: hdr = 8'h00;          6'd41: hdr = 8'h00;          // UDP cksum=0
            default: hdr = 8'h00;
        endcase
    endfunction

    /* ------------------------------------------------------------------ */
    /*  Byte selection (combinational)                                     */
    /* ------------------------------------------------------------------ */
    always_comb begin
        tbyte = 8'h00;
        case (state)
            S_PRE:  tbyte = (bcnt < 16'd7) ? 8'h55 : 8'hD5;
            S_HDR:  tbyte = hdr(bcnt[5:0]);
            S_PAY:  tbyte = bcnt[7:0];                     // simple test pattern
            S_FCS: begin                                    // FCS from eth_crc32 (already inverted+reflected)
                case (bcnt[1:0])
                    2'd0: tbyte = crc_out_wire[7:0];
                    2'd1: tbyte = crc_out_wire[15:8];
                    2'd2: tbyte = crc_out_wire[23:16];
                    2'd3: tbyte = crc_out_wire[31:24];
                endcase
            end
            default: tbyte = 8'h00;
        endcase
    end

    /* ------------------------------------------------------------------ */
    /*  CRC-32 via eth_crc32 module (trusted implementation)               */
    /* ------------------------------------------------------------------ */
    eth_crc32 u_eth_crc32 (
        .clk     (clk_125MHz),
        .reset   (!rst_n || state == S_PRE),           // reset during preamble
        .data_en (state == S_HDR || state == S_PAY),   // feed header + payload
        .data_in (tbyte),
        .crc_out (crc_out_wire)
    );

    /* ------------------------------------------------------------------ */
    /*  State + counters                                                   */
    /* ------------------------------------------------------------------ */
    always_ff @(posedge clk_125MHz) begin
        if (!rst_n) begin
            state <= S_IDLE;
            bcnt  <= 16'd0;
            fcnt  <= 32'd0;
            tx_en <= 1'b0;
        end else begin
            state <= nxt;

            if (state != nxt)
                bcnt <= 16'd0;
            else if (state != S_IDLE)
                bcnt <= bcnt + 16'd1;

            if (state == S_FCS && nxt == S_IFG)
                fcnt <= fcnt + 32'd1;

            tx_en <= (nxt != S_IDLE) && (nxt != S_IFG);
        end
    end

    /* next-state */
    always_comb begin
        nxt = state;
        case (state)
            S_IDLE: if (enable)              nxt = S_PRE;
            S_PRE:  if (bcnt == 16'd7)       nxt = S_HDR;
            S_HDR:  if (bcnt == HDR_LEN-1)   nxt = S_PAY;
            S_PAY:  if (bcnt == PAYLOAD_SIZE-1) nxt = S_FCS;
            S_FCS:  if (bcnt == 16'd3)       nxt = S_IFG;
            S_IFG:  if (bcnt == IFG_LEN-1)   nxt = enable ? S_PRE : S_IDLE;
            default: nxt = S_IDLE;
        endcase
    end

    /* ------------------------------------------------------------------ */
    /*  DDR output registers                                               */
    /*  RGMII: rising edge = low nibble, falling edge = high nibble        */
    /* ------------------------------------------------------------------ */
    // tx_active: aligned with tbyte (both derived from current state, not nxt)
    logic tx_active;
    always_ff @(posedge clk_125MHz) begin
        if (!rst_n)
            tx_active <= 1'b0;
        else
            tx_active <= (state != S_IDLE) && (state != S_IFG);
    end

    always_ff @(posedge clk_125MHz) begin
        if (!rst_n) begin
            dhi <= 4'd0;  dlo <= 4'd0;
            chi <= 1'b0;  clo <= 1'b0;
        end else begin
            dhi <= tx_active ? tbyte[3:0] : 4'd0;   // low nibble on rising edge
            dlo <= tx_active ? tbyte[7:4] : 4'd0;   // high nibble on falling edge
            chi <= tx_active;
            clo <= tx_active;
        end
    end

    /* output wiring */
    assign txd_hi      = dhi;
    assign txd_lo      = dlo;
    assign txctl_hi    = chi;
    assign txctl_lo    = clo;
    assign frame_active = tx_en;
    assign frame_count  = fcnt;

endmodule
