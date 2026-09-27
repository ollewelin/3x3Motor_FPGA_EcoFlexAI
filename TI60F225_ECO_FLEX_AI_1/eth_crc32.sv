module eth_crc32 (
    input  wire        clk,
    input  wire        reset,    // Synkron reset
    input  wire        data_en,  // Hög när vi matar in MAC, IP, UDP och Payload
    input  wire [7:0]  data_in,
    output wire [31:0] crc_out
);
    reg [31:0] crc_reg;

    // Ethernet CRC32 polynom: 0x04C11DB7 (reverserat blir det 0xEDB88320)
    function [31:0] next_crc;
        input [7:0]  d;
        input [31:0] c;
        reg   [31:0] v;
        begin
            v = c ^ {d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7], 24'h0};
            repeat (8) begin
                if (v[31]) v = (v << 1) ^ 32'h04C11DB7;
                else       v = (v << 1);
            end
            next_crc = v;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            crc_reg <= 32'hFFFFFFFF; // Ethernet startvärde
        end else if (data_en) begin
            crc_reg <= next_crc(data_in, crc_reg);
        end
    end

    // Slutresultatet ska inverteras och bit-reverseras
    // Här skapar vi den färdiga 4-bytes FCS:en
    assign crc_out = ~{crc_reg[0],  crc_reg[1],  crc_reg[2],  crc_reg[3],  crc_reg[4],  crc_reg[5],  crc_reg[6],  crc_reg[7],
                       crc_reg[8],  crc_reg[9],  crc_reg[10], crc_reg[11], crc_reg[12], crc_reg[13], crc_reg[14], crc_reg[15],
                       crc_reg[16], crc_reg[17], crc_reg[18], crc_reg[19], crc_reg[20], crc_reg[21], crc_reg[22], crc_reg[23],
                       crc_reg[24], crc_reg[25], crc_reg[26], crc_reg[27], crc_reg[28], crc_reg[29], crc_reg[30], crc_reg[31]};
endmodule