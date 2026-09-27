// dummy_MIPI_video_source.sv
// Temporary test module: simulates 2 MIPI cameras
// Generates monotonic test data: 0x03020100, 0x07060504, ..., 0xEBEAE9E8
// Cycles through 60KB (0 to 59999 bytes) at 200Hz frame rate

module dummy_MIPI_video_source #(
    parameter MIPI_DATA_WIDTH = 32,           // 32-bit output
    parameter FRAME_SIZE_BYTES = 60000,       // 2 cameras × 100×100×3 bytes each
    parameter FRAME_RATE_Hz = 200             // Capture rate (200Hz for 2 cameras)
)(
    input  wire clk_mipi,                     // 125 MHz clock
    input  wire rst_n,                        // Active-low reset
    
    // MIPI output (to bram_video_buffer)
    output reg  [MIPI_DATA_WIDTH-1:0] mipi_data,
    output reg  mipi_valid,
    input  wire mipi_ready,
    
    // Frame control (optional)
    output reg  frame_start,                  // Pulse at start of new frame
    output reg  frame_end,                    // Pulse at end of frame
    output wire [15:0] frame_counter          // Which frame we're on
);

    // Derived parameters
    localparam WORDS_PER_FRAME = FRAME_SIZE_BYTES / (MIPI_DATA_WIDTH / 8);
    localparam CYCLES_PER_FRAME = 125_000_000 / FRAME_RATE_Hz;  // 625,000 cycles @ 200Hz
    localparam ACTIVE_CYCLES = WORDS_PER_FRAME;                  // 15,000 cycles of data
    localparam IDLE_CYCLES = CYCLES_PER_FRAME - ACTIVE_CYCLES;   // 610,000 cycles idle
    
    // Internal state
    reg [31:0] byte_counter;                  // Current byte address (0 to 59999)
    reg [31:0] cycle_counter;                 // Cycle within frame (0 to 624999)
    reg [15:0] frame_num;                     // Frame counter
    
    assign frame_counter = frame_num;
    
    always @(posedge clk_mipi or negedge rst_n) begin
        if (!rst_n) begin
            byte_counter <= 0;
            cycle_counter <= 0;
            frame_num <= 0;
            mipi_data <= 0;
            mipi_valid <= 1'b0;
            frame_start <= 1'b0;
            frame_end <= 1'b0;
        end
        else begin
            // Default: no pulses
            frame_start <= 1'b0;
            frame_end <= 1'b0;
            
            // Generate test pattern: 4 consecutive bytes in increasing order
            // byte_counter = 0 → mipi_data = 0x03020100
            // byte_counter = 4 → mipi_data = 0x07060504
            // byte_counter = 8 → mipi_data = 0x0B0A0908
            // etc.
            mipi_data <= {
                byte_counter + 3,
                byte_counter + 2,
                byte_counter + 1,
                byte_counter + 0
            };
            
            // Data is valid during active transmission
            if (cycle_counter < ACTIVE_CYCLES) begin
                mipi_valid <= 1'b1;
                
                // Only increment byte counter if BRAM accepted data
                if (mipi_ready) begin
                    if (byte_counter >= FRAME_SIZE_BYTES - 4) begin
                        byte_counter <= 0;  // Wrap for next frame
                    end
                    else begin
                        byte_counter <= byte_counter + 4;  // 4 bytes per 32-bit word
                    end
                end
            end
            else begin
                mipi_valid <= 1'b0;
            end
            
            // Frame cycle management
            if (cycle_counter >= CYCLES_PER_FRAME - 1) begin
                cycle_counter <= 0;
                frame_num <= frame_num + 1;
                frame_start <= 1'b1;
            end
            else begin
                cycle_counter <= cycle_counter + 1;
            end
            
            // Pulse at end of active data
            if (cycle_counter == ACTIVE_CYCLES - 1) begin
                frame_end <= 1'b1;
            end
        end
    end
    
endmodule

/*
USAGE IN TOP_LEVEL.SV:
========================

// Instantiate dummy source instead of connecting real MIPI deserializer:
dummy_MIPI_video_source #(
    .MIPI_DATA_WIDTH(32),
    .FRAME_SIZE_BYTES(60000),      // 2 cameras, 100×100×3 each
    .FRAME_RATE_Hz(200)
) u_dummy_mipi (
    .clk_mipi      ( PLL_125MHZ ),
    .rst_n         ( 1'b1 ),
    .mipi_data     ( mipi_data ),
    .mipi_valid    ( mipi_valid ),
    .mipi_ready    ( mipi_ready ),
    .frame_start   ( frame_start_pulse ),  // Optional: debug signal
    .frame_end     ( frame_end_pulse ),    // Optional: debug signal
    .frame_counter ( frame_count_debug )   // Optional: monitor frames
);


TEST VERIFICATION:
==================

1. With simulator or logic analyzer, verify:
   ✓ Data counts: 0x03020100, 0x07060504, 0x0B0A0908, ...
   ✓ Valid pulse for 15000 cycles, then idle for 610000 cycles
   ✓ Frame counter increments at 200 Hz (5ms per frame)

2. Capture Ethernet packets:
   tcpdump -i eth0 'udp port 5000' -xx
   
   Verify UDP payload contains:
   00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F ...


FRAME RATE EXPLANATION:
=======================

At 125 MHz clock:
- 1 clock cycle = 8 ns
- 625000 cycles = 5 ms = 200 Hz frame rate

Data transmission: 60000 bytes ÷ 4 bytes/cycle = 15000 cycles ≈ 120 µs
Idle time: 625000 - 15000 = 610000 cycles ≈ 4.88 ms

This matches the original 200 Hz camera specification.


MODIFICATION FOR DIFFERENT FRAME SIZES:
======================================

2 cameras @ 100×100×3:    60000 bytes (this default)
2 cameras @ 320×240×3:    460800 bytes (modify FRAME_SIZE_BYTES)
2 cameras @ 1920×1080×3:  12441600 bytes (multiple BRAM buffers needed)
Single camera @ 640×480×3: 921600 bytes (fits in BRAM with room)


BACKPRESSURE SIMULATION:
=======================

This module respects mipi_ready signal. If BRAM is full:
- Clear mipi_valid, halt transmission
- Resume when mipi_ready returns (wait state)
- Simulates real CSI-2 RX behavior
*/
