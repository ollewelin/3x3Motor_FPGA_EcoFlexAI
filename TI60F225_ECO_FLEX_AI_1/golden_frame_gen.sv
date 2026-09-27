module golden_frame_gen (
    input  wire        clk_125MHz,
    input  wire        rst_n,
    input  wire        enable,
    output reg  [3:0]  txd_hi,    
    output reg  [3:0]  txd_lo,    
    output reg         txctl_hi,  
    output reg         txctl_lo   
);

    reg [7:0] rom [0:71];
    
    initial begin
        // Preamble & SFD
        rom[0]=8'h55; rom[1]=8'h55; rom[2]=8'h55; rom[3]=8'h55;
        rom[4]=8'h55; rom[5]=8'h55; rom[6]=8'h55; rom[7]=8'hD5;
        // MAC & Type   
        rom[8]=8'hA8; rom[9]=8'h5E; rom[10]=8'h45; rom[11]=8'hB9; rom[12]=8'hCB; rom[13]=8'h08;
        rom[14]=8'hA0; rom[15]=8'hA1; rom[16]=8'hA2; rom[17]=8'hA3; rom[18]=8'hA4; rom[19]=8'hA5;
        rom[20]=8'h88; rom[21]=8'hB5;
        // Payload (00 to 2D = 46 bytes)
        for (int i = 0; i < 46; i = i + 1) rom[i+22] = i[7:0];
        // KORREKT CRC32 för ovanstående data
        rom[68]=8'h2A; rom[69]=8'hA3; rom[70]=8'h88; rom[71]=8'h9A;
    end

    reg [6:0] ptr = 0;
    reg [24:0] gap_cnt = 0;
    reg sending = 0;

    always @(posedge clk_125MHz) begin
        if (!rst_n) begin
            ptr <= 0;
            sending <= 0;
            gap_cnt <= 0;
        end else if (!sending) begin
            if (gap_cnt == 12_500_000) begin // 10 paket per sekund
                sending <= 1;
                gap_cnt <= 0;
                ptr <= 0;
            end else gap_cnt <= gap_cnt + 1;
        end else begin
            if (ptr == 71) sending <= 0;
            else ptr <= ptr + 1;
        end
    end

    always @(posedge clk_125MHz) begin
        txd_hi   <= sending ? rom[ptr][3:0] : 4'h0;  // rising edge = low nibble (RGMII spec)
        txd_lo   <= sending ? rom[ptr][7:4] : 4'h0;  // falling edge = high nibble (RGMII spec)
        txctl_hi <= sending;
        txctl_lo <= sending;
    end
endmodule