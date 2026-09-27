// golden_frame_gen_pipeline.sv
// Fixar "Nibble-shift" genom att introducera ett stabilt mellanlager för DDIO

module golden_frame_gen_pipeline (
    input  wire        clk_125MHz,
    input  wire        rst_n,
    input  wire        enable,
    output reg  [3:0]  txd_hi,    // Kopplas till DDIO HI i Interface Designer
    output reg  [3:0]  txd_lo,    // Kopplas till DDIO LO i Interface Designer
    output reg         txctl_hi,  
    output reg         txctl_lo   
);

    // ROM med 68 bytes (Preamble, MAC, Type, Payload) – CRC beräknas dynamiskt
    reg [7:0] rom [0:67];
    
    initial begin
        // Preamble & SFD (8 bytes)
        rom[0]=8'h55; rom[1]=8'h55; rom[2]=8'h55; rom[3]=8'h55;
        rom[4]=8'h55; rom[5]=8'h55; rom[6]=8'h55; rom[7]=8'hD5;
        
        // Destination MAC (A5:58:4E:B5:C9:0B)
        rom[8]=8'hA5; rom[9]=8'h58; rom[10]=8'h4E; rom[11]=8'hB5; rom[12]=8'hC9; rom[13]=8'h0B;
        
        // Source MAC (A8:A0:A1:A2:A3:A4)
        rom[14]=8'hA8; rom[15]=8'hA0; rom[16]=8'hA1; rom[17]=8'hA2; rom[18]=8'hA3; rom[19]=8'hA4;
        
        // EtherType (0x88B5)
        rom[20]=8'h88; rom[21]=8'hB5;
        
        // Payload (00 till 2D = 46 bytes)
        for (int i = 0; i < 46; i = i + 1) rom[i+22] = i[7:0];
    end

    reg [6:0]  ptr = 0;
    reg [24:0] gap_cnt = 0;
    reg        sending = 0;
    
    // --- PIPELINE REGISTER ---
    reg [7:0] current_payload_byte;
        // --- PIPELINE REGISTER ---
    reg [7:0] current_payload_byte_B;
    reg       is_sending_reg;
    reg       is_sending_reg_B;

    // --- CRC32: beräknas över dst MAC, src MAC, ethertype, payload (ptr 8–67) ---
    wire        crc_reset  = !sending;
    wire        crc_data_en = sending && (ptr >= 7'd8) && (ptr <= 7'd67);
    wire [7:0]  crc_data_in = rom[ptr];
    wire [31:0] crc_out;

    eth_crc32 u_crc (
        .clk     (clk_125MHz),
        .reset   (crc_reset),
        .data_en (crc_data_en),
        .data_in (crc_data_in),
        .crc_out (crc_out)
    );

    // Mux: ROM bytes for ptr 0-67, computed FCS for ptr 68-71 //B2 40 85 39
    wire [7:0] next_byte = (ptr <= 7'd67) ? rom[ptr] :
                           (ptr == 7'd68) ? crc_out[7:0]   :
                           (ptr == 7'd69) ? crc_out[15:8]  :
                           (ptr == 7'd70) ? crc_out[23:16] :
                                            crc_out[31:24];

    // Logik-block: Hanterar vad som ska skickas och när
    always @(posedge clk_125MHz) begin
        if (!rst_n) begin
            ptr <= 0;
            sending <= 0;
            gap_cnt <= 0;
            current_payload_byte <= 8'h00;
            is_sending_reg <= 1'b0;
        end else begin
            if (!sending) begin
                if (enable && gap_cnt >= 12_500_000) begin 
                    sending <= 1;
                    gap_cnt <= 0;
                    ptr <= 0;
                end else begin
                    gap_cnt <= gap_cnt + 1;
                end
                is_sending_reg <= 1'b0;
                current_payload_byte <= 8'h00;
            end else begin
                // MELLANLAGRING: Här fryser vi byten för denna klockcykel
                current_payload_byte <= next_byte;
                is_sending_reg <= 1'b1;

                if (ptr == 71) begin
                    sending <= 0;
                end else begin
                    ptr <= ptr + 1;
                end
            end
        end
    end
    always @(posedge clk_125MHz) begin  
                // --- PIPELINE REGISTER ---
        current_payload_byte_B <= current_payload_byte; // Extra register för att säkerställa stabil data till DDIO
        is_sending_reg_B <= is_sending_reg;
    end
    // DDIO-matningsblock: Endast enkel tilldelning av den frysta byten
    // Detta block garanterar att hi/lo nibbles kommer från exakt samma ROM-access
    always @(posedge clk_125MHz) begin
        if (is_sending_reg_B) begin
            txd_hi   <= current_payload_byte_B[3:0]; // Low nibble -> Rising Edge
            txd_lo   <= current_payload_byte_B[7:4]; // High nibble -> Falling Edge
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