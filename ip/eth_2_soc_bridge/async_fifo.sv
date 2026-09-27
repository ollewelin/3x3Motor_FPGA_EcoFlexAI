// =============================================================================
// async_fifo.sv : Asynchronous FIFO with Gray-Code Pointers for CDC
// =============================================================================
// Safe clock domain crossing between 125MHz RGMII and 50MHz system clock
// Uses gray-code pointers to prevent metastability issues
// =============================================================================

`timescale 1ns / 1ps
`default_nettype none

module async_fifo #(
    parameter int DATA_WIDTH = 8,       // Data width in bits
    parameter int DEPTH_LOG2 = 4,       // Log2 of FIFO depth (4 = 16 entries)
    parameter int DEPTH = (1 << DEPTH_LOG2)  // FIFO depth
) (
    // Write Clock Domain (e.g., 125 MHz RGMII RX)
    input  wire                     wr_clk,
    input  wire                     wr_rst_n,
    input  wire                     wr_en,
    input  wire [DATA_WIDTH-1:0]    wr_data,
    output logic                    wr_full,
    output logic [DEPTH_LOG2:0]     wr_level,    // Fill level in write domain
    
    // Read Clock Domain (e.g., 50 MHz system)
    input  wire                     rd_clk,
    input  wire                     rd_rst_n,
    input  wire                     rd_en,
    output logic [DATA_WIDTH-1:0]   rd_data,
    output logic                    rd_empty,
    output logic [DEPTH_LOG2:0]     rd_level     // Fill level in read domain
);

// =============================================================================
// FIFO Memory
// =============================================================================
logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

// =============================================================================
// Write Pointer (binary and gray-code)
// =============================================================================
logic [DEPTH_LOG2:0] wr_ptr_bin;      // Binary write pointer (extra bit for wrap)
logic [DEPTH_LOG2:0] wr_ptr_gray;     // Gray-coded write pointer
logic [DEPTH_LOG2:0] wr_ptr_gray_sync1;  // Synchronized to read domain (stage 1)
logic [DEPTH_LOG2:0] wr_ptr_gray_sync2;  // Synchronized to read domain (stage 2)

// =============================================================================
// Read Pointer (binary and gray-code)
// =============================================================================
logic [DEPTH_LOG2:0] rd_ptr_bin;      // Binary read pointer (extra bit for wrap)
logic [DEPTH_LOG2:0] rd_ptr_gray;     // Gray-coded read pointer
logic [DEPTH_LOG2:0] rd_ptr_gray_sync1;  // Synchronized to write domain (stage 1)
logic [DEPTH_LOG2:0] rd_ptr_gray_sync2;  // Synchronized to write domain (stage 2)

// =============================================================================
// Binary to Gray Code Conversion
// =============================================================================
function automatic logic [DEPTH_LOG2:0] bin2gray(input logic [DEPTH_LOG2:0] bin);
    return bin ^ (bin >> 1);
endfunction

// =============================================================================
// Gray Code to Binary Conversion
// =============================================================================
function automatic logic [DEPTH_LOG2:0] gray2bin(input logic [DEPTH_LOG2:0] gray);
    logic [DEPTH_LOG2:0] bin;
    bin[DEPTH_LOG2] = gray[DEPTH_LOG2];
    for (int i = DEPTH_LOG2 - 1; i >= 0; i--) begin
        bin[i] = bin[i+1] ^ gray[i];
    end
    return bin;
endfunction

// =============================================================================
// Write Logic (wr_clk domain)
// =============================================================================
always_ff @(posedge wr_clk or negedge wr_rst_n) begin
    if (!wr_rst_n) begin
        wr_ptr_bin  <= '0;
        wr_ptr_gray <= '0;
    end else if (wr_en && !wr_full) begin
        wr_ptr_bin  <= wr_ptr_bin + 1'b1;
        wr_ptr_gray <= bin2gray(wr_ptr_bin + 1'b1);
    end
end

// Write to memory
always_ff @(posedge wr_clk) begin
    if (wr_en && !wr_full) begin
        mem[wr_ptr_bin[DEPTH_LOG2-1:0]] <= wr_data;
    end
end

// Synchronize read pointer to write domain (2-stage synchronizer)
always_ff @(posedge wr_clk or negedge wr_rst_n) begin
    if (!wr_rst_n) begin
        rd_ptr_gray_sync1 <= '0;
        rd_ptr_gray_sync2 <= '0;
    end else begin
        rd_ptr_gray_sync1 <= rd_ptr_gray;
        rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
    end
end

// Full flag: FIFO is full when write pointer catches up to read pointer
// with opposite MSB (wrapped) and same lower bits
logic [DEPTH_LOG2:0] rd_ptr_bin_sync;
assign rd_ptr_bin_sync = gray2bin(rd_ptr_gray_sync2);

always_comb begin
    // Full when wr_ptr MSB differs and rest is same (pointer wrapped)
    wr_full = (wr_ptr_bin[DEPTH_LOG2] != rd_ptr_bin_sync[DEPTH_LOG2]) &&
              (wr_ptr_bin[DEPTH_LOG2-1:0] == rd_ptr_bin_sync[DEPTH_LOG2-1:0]);
    
    // Calculate fill level in write domain
    if (wr_ptr_bin[DEPTH_LOG2] == rd_ptr_bin_sync[DEPTH_LOG2]) begin
        wr_level = wr_ptr_bin[DEPTH_LOG2-1:0] - rd_ptr_bin_sync[DEPTH_LOG2-1:0];
    end else begin
        wr_level = DEPTH - (rd_ptr_bin_sync[DEPTH_LOG2-1:0] - wr_ptr_bin[DEPTH_LOG2-1:0]);
    end
end

// =============================================================================
// Read Logic (rd_clk domain)
// =============================================================================
always_ff @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) begin
        rd_ptr_bin  <= '0;
        rd_ptr_gray <= '0;
    end else if (rd_en && !rd_empty) begin
        rd_ptr_bin  <= rd_ptr_bin + 1'b1;
        rd_ptr_gray <= bin2gray(rd_ptr_bin + 1'b1);
    end
end

// Read from memory (registered output for timing)
always_ff @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) begin
        rd_data <= '0;
    end else if (!rd_empty) begin
        rd_data <= mem[rd_ptr_bin[DEPTH_LOG2-1:0]];
    end
end

// Synchronize write pointer to read domain (2-stage synchronizer)
always_ff @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) begin
        wr_ptr_gray_sync1 <= '0;
        wr_ptr_gray_sync2 <= '0;
    end else begin
        wr_ptr_gray_sync1 <= wr_ptr_gray;
        wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
    end
end

// Empty flag: FIFO is empty when read pointer equals write pointer
logic [DEPTH_LOG2:0] wr_ptr_bin_sync;
assign wr_ptr_bin_sync = gray2bin(wr_ptr_gray_sync2);

always_comb begin
    rd_empty = (rd_ptr_bin == wr_ptr_bin_sync);
    
    // Calculate fill level in read domain
    if (wr_ptr_bin_sync[DEPTH_LOG2] == rd_ptr_bin[DEPTH_LOG2]) begin
        rd_level = wr_ptr_bin_sync[DEPTH_LOG2-1:0] - rd_ptr_bin[DEPTH_LOG2-1:0];
    end else begin
        rd_level = DEPTH - (rd_ptr_bin[DEPTH_LOG2-1:0] - wr_ptr_bin_sync[DEPTH_LOG2-1:0]);
    end
end

endmodule
