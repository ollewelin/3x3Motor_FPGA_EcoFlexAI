// eth_tx_1gbit_udp.sv
// EXACT SAME PIPELINE STRUCTURE as golden_frame_gen_pipeline.sv (proven working)
// Sends a full-MTU IPv4/UDP broadcast frame: 1472 bytes payload, 1526 bytes on wire
// Header from ROM, payload from BRAM, CRC on-the-fly
// ~1000 frames/sec (125k cycle gap at 125MHz)
// Dest: 255.255.255.255:5000, Src: 192.168.1.200:5000
// Payload efficiency: 96.5%

module eth_tx_1gbit_udp (
    input  wire        clk_125MHz,
    input  wire        rst_n,
    input  wire        enable,
    output reg  [3:0]  txd_hi,
    output reg  [3:0]  txd_lo,
    output reg         txctl_hi,
    output reg         txctl_lo,

    // BRAM read interface (payload source)
    output reg  [15:0] bram_rd_addr,
    input  wire [7:0]  bram_rd_data,
    output wire        bram_rd_en
);

    // Frame layout:
    //   ptr 0-7:      Preamble & SFD (8 bytes)
    //   ptr 8-21:     Dest MAC + Src MAC + EtherType (14 bytes)
    //   ptr 22-41:    IPv4 Header (20 bytes)
    //   ptr 42-49:    UDP Header (8 bytes)
    //   ptr 50-1521:  Payload (1472 bytes)
    //   ptr 1522-1525: CRC32 (4 bytes, computed on-the-fly)
    //   Total: 1526 bytes on wire

    localparam HDR_LEN     = 50;   // preamble + MAC + IP + UDP
    localparam PAYLOAD_LEN = 1472; // max UDP payload for 1500-byte IP
    localparam PAYLOAD_END = HDR_LEN + PAYLOAD_LEN - 1; // ptr 1521
    localparam CRC_START   = PAYLOAD_END + 1;            // ptr 1522
    localparam FRAME_END   = CRC_START + 3;              // ptr 1525

    // Header ROM (50 bytes: preamble + MAC + IP + UDP)
    reg [7:0] hdr [0:49];

    initial begin
        // Preamble & SFD (8 bytes)
        hdr[0]=8'h55; hdr[1]=8'h55; hdr[2]=8'h55; hdr[3]=8'h55;
        hdr[4]=8'h55; hdr[5]=8'h55; hdr[6]=8'h55; hdr[7]=8'hD5;

        // Dest MAC: FF:FF:FF:FF:FF:FF (broadcast)
        hdr[8]=8'hFF;  hdr[9]=8'hFF;  hdr[10]=8'hFF; hdr[11]=8'hFF; hdr[12]=8'hFF; hdr[13]=8'hFF;
        // Src MAC: A8:A0:A1:A2:A3:A4 (same as golden_frame_gen_pipeline)
        hdr[14]=8'hA8; hdr[15]=8'hA0; hdr[16]=8'hA1; hdr[17]=8'hA2; hdr[18]=8'hA3; hdr[19]=8'hA4;
        // EtherType: 0x0800 (IPv4)
        hdr[20]=8'h08; hdr[21]=8'h00;

        // IPv4 Header (20 bytes)
        hdr[22]=8'h45; hdr[23]=8'h00;                 // Version/IHL, DSCP
        hdr[24]=8'h05; hdr[25]=8'hDC;                 // Total Length = 1500
        hdr[26]=8'h00; hdr[27]=8'h00;                 // Identification
        hdr[28]=8'h40; hdr[29]=8'h00;                 // Flags=DF, Fragment Offset
        hdr[30]=8'h40; hdr[31]=8'h11;                 // TTL=64, Protocol=UDP
        hdr[32]=8'h72; hdr[33]=8'hA1;                 // IP Checksum (verified)
        hdr[34]=8'hC0; hdr[35]=8'hA8; hdr[36]=8'h01; hdr[37]=8'hC8; // Src: 192.168.1.200
        hdr[38]=8'hFF; hdr[39]=8'hFF; hdr[40]=8'hFF; hdr[41]=8'hFF; // Dst: 255.255.255.255

        // UDP Header (8 bytes)
        hdr[42]=8'h13; hdr[43]=8'h88;                 // Src Port: 5000
        hdr[44]=8'h13; hdr[45]=8'h88;                 // Dst Port: 5000
        hdr[46]=8'h05; hdr[47]=8'hC8;                 // UDP Length: 1480
        hdr[48]=8'h00; hdr[49]=8'h00;                 // UDP Checksum: disabled
    end

    reg [10:0] ptr = 0;      // 0-1525 needs 11 bits
    reg [24:0] gap_cnt = 0;
    reg        sending = 0;

    // --- PIPELINE REGISTERS (same as golden_frame_gen_pipeline) ---
    reg [7:0] current_payload_byte;
    reg [7:0] current_payload_byte_B;
    reg       is_sending_reg;
    reg       is_sending_reg_B;

    // --- CRC32: computed over ptr 8-1521 (MAC+IP+UDP+Payload) ---
    wire        crc_reset   = !sending;
    wire        crc_data_en = sending && (ptr >= 11'd8) && (ptr <= PAYLOAD_END[10:0]);
    wire [31:0] crc_out;

    // BRAM read: address tracks payload offset, enable during payload region
    // BRAM has 1-cycle read latency, so we pre-fetch by driving addr one cycle early.
    // bram_rd_addr is registered (output reg), updated in the state machine below.
    assign bram_rd_en = sending && (ptr >= 11'd49) && (ptr < PAYLOAD_END[10:0]);

    // Byte mux: header ROM / BRAM data / CRC
    wire [7:0] next_byte = (ptr < HDR_LEN[10:0])    ? hdr[ptr[5:0]] :
                           (ptr <= PAYLOAD_END[10:0]) ? bram_rd_data :
                           (ptr == CRC_START[10:0])   ? crc_out[7:0]   :
                           (ptr == CRC_START[10:0]+1) ? crc_out[15:8]  :
                           (ptr == CRC_START[10:0]+2) ? crc_out[23:16] :
                                                        crc_out[31:24];

    eth_crc32 u_crc (
        .clk     (clk_125MHz),
        .reset   (crc_reset),
        .data_en (crc_data_en),
        .data_in (next_byte),
        .crc_out (crc_out)
    );

    // Main state machine (identical structure to golden_frame_gen_pipeline)
    always @(posedge clk_125MHz) begin
        if (!rst_n) begin
            ptr <= 0;
            sending <= 0;
            gap_cnt <= 0;
            current_payload_byte <= 8'h00;
            is_sending_reg <= 1'b0;
            bram_rd_addr <= 16'd0;
        end else begin
            if (!sending) begin
                if (enable && gap_cnt >= 125_000) begin
                    sending <= 1;
                    gap_cnt <= 0;
                    ptr <= 0;
                    // NOTE: bram_rd_addr NOT reset here — it auto-increments
                    // across frames to stream the full BRAM contents sequentially
                end else begin
                    gap_cnt <= gap_cnt + 1;
                end
                is_sending_reg <= 1'b0;
                current_payload_byte <= 8'h00;
            end else begin
                current_payload_byte <= next_byte;
                is_sending_reg <= 1'b1;

                // Advance BRAM read address during payload region
                if (ptr >= 11'd50 && ptr <= PAYLOAD_END[10:0]) begin
                    bram_rd_addr <= bram_rd_addr + 1;
                end

                if (ptr == FRAME_END[10:0]) begin
                    sending <= 0;
                end else begin
                    ptr <= ptr + 1;
                end
            end
        end
    end

    // Pipeline stage B (identical to golden_frame_gen_pipeline)
    always @(posedge clk_125MHz) begin
        current_payload_byte_B <= current_payload_byte;
        is_sending_reg_B <= is_sending_reg;
    end

    // DDIO output (identical to golden_frame_gen_pipeline)
    always @(posedge clk_125MHz) begin
        if (is_sending_reg_B) begin
            txd_hi   <= current_payload_byte_B[3:0];
            txd_lo   <= current_payload_byte_B[7:4];
            txctl_hi <= 1'b1;
            txctl_lo <= 1'b1;
        end else begin
            txd_hi   <= 4'h0;
            txd_lo   <= 4'h0;
            txctl_hi <= 1'b0;
            txctl_lo <= 1'b0;
        end
    end

endmodule
