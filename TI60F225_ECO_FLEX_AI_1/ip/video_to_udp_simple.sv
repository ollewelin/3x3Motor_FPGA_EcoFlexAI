/*
 * video_to_udp_simple.sv - Minimal RGMII 1Gbps test transmitter
 * 
 * Generates continuous 0x55 pattern on RGMII TX to verify DDR output path works
 */

module video_to_udp_simple (
    input  wire clk_125MHz,
    input  wire rst_n,
    input  wire enable,
    
    output wire [3:0] txd_hi,
    output wire [3:0] txd_lo,
    output wire txctl_hi,
    output wire txctl_lo,
    
    output wire frame_active,
    output wire [31:0] frame_count
);

    // Simply output 0x5555... pattern continuously
    // 0x55 = 0101 0101
    // HI nibble = 0101 = 0x5
    // LO nibble = 0101 = 0x5
    
    assign txd_hi = enable ? 4'h5 : 4'h0;
    assign txd_lo = enable ? 4'h5 : 4'h0;
    assign txctl_hi = enable ? 1'b1 : 1'b0;
    assign txctl_lo = enable ? 1'b1 : 1'b0;
    
    logic [31:0] counter;
    always_ff @(posedge clk_125MHz) begin
        if (!rst_n) begin
            counter <= 0;
        end else if (enable) begin
            counter <= counter + 1;
        end
    end
    
    assign frame_count = counter;
    assign frame_active = enable;

endmodule
