module rgmii_minimal_tx (
    input  wire        clk125,
    output reg  [3:0]  txd_hi,
    output reg  [3:0]  txd_lo,
    output reg         txctl_hi,
    output reg         txctl_lo
);

    // Vi skickar 72 bytes för att vara helt säkra: 8 (Pre) + 60 (Data) + 4 (CRC)
    reg [7:0] frame [0:71];
    reg [6:0] ptr = 0;
    reg [23:0] gap_cnt = 0;
    reg sending = 1;

    initial begin
        // Preamble + SFD
        frame[0]=8'h55; frame[1]=8'h55; frame[2]=8'h55; frame[3]=8'h55;
        frame[4]=8'h55; frame[5]=8'h55; frame[6]=8'h55; frame[7]=8'hD5;
        // Dest MAC: Broadcast (Alla ser denna)
        frame[8]=8'hFF; frame[9]=8'hFF; frame[10]=8'hFF; 
        frame[11]=8'hFF; frame[12]=8'hFF; frame[13]=8'hFF;
        // Source MAC: 12:34:56:78:9A:BC
        frame[14]=8'h12; frame[15]=8'h34; frame[16]=8'h56; 
        frame[17]=8'h78; frame[18]=8'h9A; frame[19]=8'hBC;
        // Type: 0800 (IPv4)
        frame[20]=8'h08; frame[21]=8'h00;
        // Payload: Fyll ut till 60 bytes data (index 22 till 67)
        for (int i = 22; i < 68; i = i + 1) frame[i] = i[7:0];
        // Fake CRC (Wireshark måste ha validering AV)
        frame[68]=8'hDE; frame[69]=8'hAD; frame[70]=8'hBE; frame[71]=8'hEF;
    end

    always @(posedge clk125) begin
        if (sending) begin
            if (ptr == 71) begin
                sending <= 0;
                ptr <= 0;
            end else ptr <= ptr + 1;
        end else begin
            // Skapa en rejäl paus mellan paketen (ca 0.1 sekund)
            if (gap_cnt == 12_500_000) begin
                gap_cnt <= 0;
                sending <= 1;
            end else gap_cnt <= gap_cnt + 1;
        end
    end

    always @(posedge clk125) begin
        txd_hi   <= sending ? frame[ptr][3:0] : 4'h0;
        txd_lo   <= sending ? frame[ptr][7:4] : 4'h0;
        txctl_hi <= sending;
        txctl_lo <= sending;
    end
endmodule