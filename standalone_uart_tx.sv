// =============================================================================
// standalone_uart_tx.sv
// =============================================================================
// Minimal standalone UART TX (8N1) with ASCII-HEX formatter.
// Same protocol as uart_tx_simple in record_frame_bram_counted.vhd:
//   - tx_start pulse (when tx_busy=0) kicks a transfer
//   - If tx_send_S=1: send ASCII 'S' (0x53)
//   - Else: send hex(tx_data) as two ASCII chars (high nibble, low nibble)
//
// Portable SystemVerilog — no external dependencies.
// Designed to be moved to another board later.
// =============================================================================
`timescale 1ns / 1ps

module standalone_uart_tx #(
    parameter int CLOCK_HZ = 50_000_000,
    parameter int BAUD     = 115200
) (
    input  wire       clk,
    input  wire       rst_n,       // Active LOW

    // Control
    input  wire       tx_start,    // 1-cycle strobe (only when tx_busy=0)
    input  wire       tx_send_S,   // When 1 at tx_start: send 'S'; else hex(tx_data)
    input  wire [7:0] tx_data,     // Data byte to send as two hex chars

    // Status
    output logic      tx_busy,     // High while sending
    output logic      tx_busy_q,   // 1-cycle delayed copy (for upstream FSM edge detect)

    // UART line
    output logic      txd          // Idle HIGH
);

// ---- Timing ----
localparam int TICKS_PER_BIT = (CLOCK_HZ + BAUD / 2) / BAUD;

// ---- Hex nibble → ASCII ----
function automatic logic [7:0] hex_ascii(input logic [3:0] nib);
    if (nib < 4'd10) return 8'h30 + {4'b0, nib};   // '0'..'9'
    else              return 8'h41 + {4'b0, nib} - 8'd10; // 'A'..'F'
endfunction

// ---- Byte sequence buffer (1 or 2 chars) ----
logic [7:0] seq [0:1];
logic [1:0] seq_len;   // 1 or 2
logic [1:0] seq_idx;   // 0 or 1

// ---- 8N1 bit engine ----
typedef enum logic [2:0] { IDLE, PREPARE, START_BIT, DATA_BITS, STOP_BIT } st_t;
st_t st;

logic [9:0]  shreg;     // [stop(1) | data[7:0] | start(0)]
logic [3:0]  bit_idx;
logic [31:0] tick_cnt;
logic        busy_i;

assign txd     = shreg[0];
assign tx_busy = busy_i;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        st        <= IDLE;
        shreg     <= 10'h3FF; // all ones = idle
        bit_idx   <= '0;
        tick_cnt  <= '0;
        seq_len   <= '0;
        seq_idx   <= '0;
        busy_i    <= 1'b0;
        tx_busy_q <= 1'b1;
    end else begin
        tx_busy_q <= busy_i;  // 1-cycle delay

        case (st)
            // ------------------------------------------------------------------
            IDLE: begin
                busy_i <= 1'b0;
                if (tx_start) begin
                    if (tx_send_S) begin
                        seq[0]  <= 8'h53;   // 'S'
                        seq_len <= 2'd1;
                    end else begin
                        seq[0]  <= hex_ascii(tx_data[7:4]);
                        seq[1]  <= hex_ascii(tx_data[3:0]);
                        seq_len <= 2'd2;
                    end
                    seq_idx <= '0;
                    busy_i  <= 1'b1;
                    st      <= PREPARE;
                end
            end

            // ------------------------------------------------------------------
            PREPARE: begin
                // Load shift register: stop(1) | data[7:0] | start(0)
                shreg    <= {1'b1, seq[seq_idx], 1'b0};
                bit_idx  <= '0;
                tick_cnt <= '0;
                st       <= START_BIT;
            end

            // ------------------------------------------------------------------
            START_BIT: begin
                if (tick_cnt == TICKS_PER_BIT[31:0] - 1) begin
                    tick_cnt <= '0;
                    shreg    <= {1'b1, shreg[9:1]};
                    bit_idx  <= 4'd1;
                    st       <= DATA_BITS;
                end else
                    tick_cnt <= tick_cnt + 1;
            end

            // ------------------------------------------------------------------
            DATA_BITS: begin
                if (tick_cnt == TICKS_PER_BIT[31:0] - 1) begin
                    tick_cnt <= '0;
                    if (bit_idx == 4'd9) begin
                        st <= STOP_BIT;
                    end else begin
                        shreg   <= {1'b1, shreg[9:1]};
                        bit_idx <= bit_idx + 1;
                    end
                end else
                    tick_cnt <= tick_cnt + 1;
            end

            // ------------------------------------------------------------------
            STOP_BIT: begin
                if (tick_cnt == TICKS_PER_BIT[31:0] - 1) begin
                    tick_cnt <= '0;
                    if (seq_idx + 1 < seq_len) begin
                        seq_idx <= seq_idx + 1;
                        st      <= PREPARE;
                    end else begin
                        busy_i <= 1'b0;
                        st     <= IDLE;
                    end
                end else
                    tick_cnt <= tick_cnt + 1;
            end

            default: st <= IDLE;
        endcase
    end
end

endmodule
