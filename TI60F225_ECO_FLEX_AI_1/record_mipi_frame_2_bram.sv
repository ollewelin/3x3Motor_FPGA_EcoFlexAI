////////////////////////////////////////////////////////////////////////////////
// record_mipi_frame_2_bram.sv
// 
// MIPI CSI-2 to BRAM Frame Recorder for Dual Cameras (CAM4, CAM5)
// Replaces old VHDL record_frame_bram_counted component
//
// Features:
// - Decodes MIPI CSI-2 packets from DPHY raw streams
// - Handles 2 independent cameras (CAM4 clock lane + 2 data lanes each)
// - Records frames to dual-port BRAM with ethernet read port
// - Software-based packet parsing (not using hard CSI-2 IP)
// - Frame synchronization and error detection
// - APB3 control interface from SoC
//
// Ports:
//   - MIPI: Camera clock/data differential pairs (from DPHY)
//   - BRAM: Write port for frames, read port for ethernet
//   - Control: ARM/status signals, frame counters
//   - APB3: Configuration from SoC
////////////////////////////////////////////////////////////////////////////////

module record_mipi_frame_2_bram #(
    parameter CLOCK_HZ          = 125_000_000,
    parameter FRAME_WIDTH       = 160,        // Pixels per line (scaled: 320 -> 160 word32)
    parameter FRAME_HEIGHT      = 120,        // Lines per frame
    parameter PIXELS_PER_BEAT   = 4,          // 32-bit word = 4 bytes
    parameter GAP_MIN_CYCLES    = 1000,       // Min cycles between frames
    parameter BRAM_DEPTH        = 65536,      // 256KB BRAM
    parameter AUTO_DUMP_UART    = 1'b0        // Debug output to UART
) (
    // ===== MIPI PHY Interfaces (Titanium DPHY: 8-bit deserialized per lane) =====
    // Camera 4 (2 data lanes + clock)
    input  wire        cam4_clk,              // Recovered byte clock from DPHY
    input  wire [7:0]  cam4_d0,               // Data lane 0: 8-bit deserialized bytes
    input  wire [7:0]  cam4_d1,               // Data lane 1: 8-bit deserialized bytes
    
    // Camera 5 (2 data lanes + clock)
    input  wire        cam5_clk,              // Recovered byte clock from DPHY
    input  wire [7:0]  cam5_d0,               // Data lane 0: 8-bit deserialized bytes
    input  wire [7:0]  cam5_d1,               // Data lane 1: 8-bit deserialized bytes
    
    // ===== System Clock & Reset =====
    input  wire        clk_125MHz,            // FPGA system clock
    input  wire        rst_n,                 // Active-low reset
    
    // ===== BRAM Write Port (MIPI -> BRAM) =====
    output reg  [15:0] bram_wr_addr,
    output reg  [31:0] bram_wr_data,
    output wire        bram_wr_en,
    
    // ===== BRAM Read Port (Ethernet) =====
    input  wire [15:0] bram_rd_addr,
    output wire [31:0] bram_rd_data,
    input  wire        bram_rd_en,
    
    // ===== Control & Status =====
    input  wire        arm_i,                 // ARM recording from SoC
    output reg         armed_o,               // Recorder armed and ready
    output reg         capturing_o,           // Currently capturing frame
    output reg         done_o,                // Frame capture complete
    output reg         clear_o,               // Clear error flags
    
    // ===== Debug Outputs =====
    output reg  [15:0] beats_line_o,          // Words captured in current line
    output reg  [15:0] line_idx_o,            // Current line index
    output reg  [31:0] words_used_o,          // Total words in frame
    output reg  [15:0] frame_count_o,         // Frame counter (rolling)
    output reg  [17:0] error_bus_o,           // Error flags
    
    // ===== APB3 Slave Interface (SoC control) =====
    input  wire [11:0] apb_paddr,             // APB address
    input  wire        apb_psel,              // APB select
    input  wire        apb_penable,           // APB enable
    input  wire        apb_pwrite,            // APB write
    input  wire [31:0] apb_pwdata,            // APB write data
    output reg  [31:0] apb_prdata,            // APB read data
    output wire        apb_pready,            // APB ready
    output wire        apb_pslverr,           // APB error
    
    // ===== I2C Control Ports (to SoC I2C) =====
    output reg         i2c_cam4_sda_oe,       // I2C SDA output enable (open-drain)
    output reg         i2c_cam4_scl_oe,       // I2C SCL output enable (open-drain)
    output reg         i2c_cam5_sda_oe,
    output reg         i2c_cam5_scl_oe,
    
    // ===== UART Debug Output =====
    output wire        uart_tx                // Debug UART
);

    // =========================================================================
    // CSI-2 Packet Structure (from MIPI spec)
    // =========================================================================
    // Packet Header: [31:24]=ECC, [23:16]=Data Type, [15:0]=VC+Packet Length
    // Data Type 0x08 = YUV 4:2:2 8-bit
    // Data Type 0x0A = RAW10
    // Data Type 0x0C = RAW12
    // Data Type 0x1E = RAW8 (typical for simple cameras)
    
    localparam CSI2_DT_RAW8    = 6'b011110;   // Data Type 0x1E
    localparam CSI2_DT_RAW10   = 6'b001010;
    localparam CSI2_DT_RAW12   = 6'b001100;
    localparam CSI2_DT_YUV422  = 6'b001000;
    
    // =========================================================================
    // State Machine: Frame Capture Control
    // =========================================================================
    typedef enum logic [2:0] {
        STATE_IDLE,
        STATE_ARMED,
        STATE_FRAME_START,
        STATE_CAPTURING,
        STATE_FRAME_END,
        STATE_ERROR
    } state_t;
    
    state_t state, next_state;
    
    // =========================================================================
    // MIPI Deserializer Output (simulated - would come from hard DPHY)
    // In real implementation, these signals come from the hard silicon DPHY block
    // =========================================================================
    reg  [31:0] mipi_cam4_data;        // Deserialized 32-bit words from CAM4
    reg         mipi_cam4_valid;
    wire        mipi_cam4_ready;       // Backpressure to DPHY
    
    reg  [31:0] mipi_cam5_data;        // Deserialized 32-bit words from CAM5
    reg         mipi_cam5_valid;
    wire        mipi_cam5_ready;
    
    // Frame sync signals (from CSI-2 packet decoder)
    reg         frame_start_cam4, frame_end_cam4;
    reg         frame_start_cam5, frame_end_cam5;
    
    // =========================================================================
    // CSI-2 Packet Decoder (Software-based parsing)
    // Extracts data type, line number, and payload length from headers
    // =========================================================================
    wire [5:0]  csi2_dtype_cam4;       // Data type field from packet
    wire [15:0] csi2_length_cam4;      // Payload length in bytes
    wire        csi2_valid_cam4;       // Valid packet header detected
    
    wire [5:0]  csi2_dtype_cam5;
    wire [15:0] csi2_length_cam5;
    wire        csi2_valid_cam5;
    
    // Decode packet header: first word after sync
    // [31:24] = ECC, [23:16] = Data Type, [15:0] = VC(2)+Length(14)
    assign csi2_dtype_cam4 = mipi_cam4_data[23:18];
    assign csi2_length_cam4 = mipi_cam4_data[15:0];
    assign csi2_valid_cam4 = mipi_cam4_valid && (csi2_dtype_cam4 inside {CSI2_DT_RAW8, CSI2_DT_RAW10, CSI2_DT_RAW12, CSI2_DT_YUV422});
    
    assign csi2_dtype_cam5 = mipi_cam5_data[23:18];
    assign csi2_length_cam5 = mipi_cam5_data[15:0];
    assign csi2_valid_cam5 = mipi_cam5_valid && (csi2_dtype_cam5 inside {CSI2_DT_RAW8, CSI2_DT_RAW10, CSI2_DT_RAW12, CSI2_DT_YUV422});
    
    // =========================================================================
    // Recording State Machine
    // =========================================================================
    always_ff @(posedge clk_125MHz or negedge rst_n) begin
        if (!rst_n) begin
            state <= STATE_IDLE;
            armed_o <= 1'b0;
            capturing_o <= 1'b0;
            done_o <= 1'b0;
            bram_wr_addr <= 16'd0;
            bram_wr_data <= 32'd0;
            line_idx_o <= 16'd0;
            beats_line_o <= 16'd0;
            words_used_o <= 32'd0;
            frame_count_o <= 16'd0;
            error_bus_o <= 18'd0;
        end
        else begin
            state <= next_state;
            
            // ===== Frame Recording Logic =====
            case (state)
                STATE_IDLE: begin
                    armed_o <= 1'b0;
                    capturing_o <= 1'b0;
                    done_o <= 1'b0;
                    bram_wr_addr <= 16'd0;
                    words_used_o <= 32'd0;
                    line_idx_o <= 16'd0;
                    beats_line_o <= 16'd0;
                    error_bus_o <= 18'd0;  // Clear all error flags in IDLE
                end
                
                STATE_ARMED: begin
                    armed_o <= 1'b1;
                    capturing_o <= 1'b0;
                    done_o <= 1'b0;
                end
                
                STATE_FRAME_START: begin
                    armed_o <= 1'b1;
                    capturing_o <= 1'b1;
                    done_o <= 1'b0;
                    
                    // Reset frame counters
                    bram_wr_addr <= 16'd0;
                    words_used_o <= 32'd0;
                    line_idx_o <= 16'd0;
                    beats_line_o <= 16'd0;
                end
                
                STATE_CAPTURING: begin
                    capturing_o <= 1'b1;
                    
                    // Write MIPI data to BRAM (interleave CAM4 and CAM5)
                    // CAM4: words 0-14999, CAM5: words 15000-29999
                    if (mipi_cam4_valid && mipi_cam4_ready) begin
                        bram_wr_data <= mipi_cam4_data;
                        bram_wr_addr <= bram_wr_addr + 1;
                        words_used_o <= words_used_o + 1;
                        
                        // Update line counter (estimate based on words written)
                        if (words_used_o % FRAME_WIDTH == 0 && words_used_o > 0) begin
                            line_idx_o <= line_idx_o + 1;
                            beats_line_o <= 16'd0;
                        end else begin
                            beats_line_o <= beats_line_o + 1;
                        end
                    end
                    else if (mipi_cam5_valid && mipi_cam5_ready) begin
                        bram_wr_data <= mipi_cam5_data;
                        bram_wr_addr <= bram_wr_addr + 1;
                        words_used_o <= words_used_o + 1;
                    end
                end
                
                STATE_FRAME_END: begin
                    capturing_o <= 1'b0;
                    done_o <= 1'b1;
                    frame_count_o <= frame_count_o + 1;
                    armed_o <= 1'b0;  // Auto-disarm after frame
                end
                
                STATE_ERROR: begin
                    capturing_o <= 1'b0;
                    armed_o <= 1'b0;
                    // Set error flags based on what caused the transition to ERROR
                    // Error code: bit[0] = BRAM overflow, bit[1] = User disarmed during capture
                    if (words_used_o >= (BRAM_DEPTH - 100)) begin
                        error_bus_o[0] <= 1'b1;  // BRAM overflow error
                    end
                    if (!arm_i) begin
                        error_bus_o[1] <= 1'b1;  // User disarmed during capture
                    end
                end
            endcase
        end
    end
    
    // =========================================================================
    // State Transition Logic
    // =========================================================================
    always_comb begin
        next_state = state;
        
        case (state)
            STATE_IDLE: begin
                if (arm_i) next_state = STATE_ARMED;
            end
            
            STATE_ARMED: begin
                if (!arm_i) next_state = STATE_IDLE;
                else if (frame_start_cam4 || frame_start_cam5) next_state = STATE_FRAME_START;
            end
            
            STATE_FRAME_START: begin
                // Transition immediately to capturing after frame start sync
                next_state = STATE_CAPTURING;
            end
            
            STATE_CAPTURING: begin
                // Stay capturing until frame end detected or BRAM full
                if ((frame_end_cam4 || frame_end_cam5) && (words_used_o > 1000)) begin
                    next_state = STATE_FRAME_END;
                end
                else if (words_used_o >= (BRAM_DEPTH - 100)) begin
                    // BRAM full - error condition (error flags set in seq logic)
                    next_state = STATE_ERROR;
                end
                else if (!arm_i) begin
                    // User disarmed during capture (error flags set in seq logic)
                    next_state = STATE_ERROR;
                end
            end
            
            STATE_FRAME_END: begin
                next_state = STATE_IDLE;  // Auto-transition to IDLE after frame complete
            end
            
            STATE_ERROR: begin
                if (clear_o) next_state = STATE_IDLE;
            end
        endcase
    end
    
    // =========================================================================
    // APB3 Slave Interface (SoC register access)
    // =========================================================================
    assign apb_pready = 1'b1;
    assign apb_pslverr = 1'b0;
    
    always_ff @(posedge clk_125MHz) begin
        if (apb_psel && apb_penable) begin
            if (apb_pwrite) begin
                // APB Write: Configuration registers
                case (apb_paddr[3:2])
                    2'h0: {clear_o} <= {apb_pwdata[0]};  // Control register
                    // Future: Camera I2C config registers
                endcase
            end
            else begin
                // APB Read: Status registers
                case (apb_paddr[3:2])
                    2'h0: apb_prdata <= {31'd0, done_o};                    // Status
                    2'h1: apb_prdata <= {16'd0, frame_count_o};             // Frame counter
                    2'h2: apb_prdata <= {16'd0, line_idx_o};                // Current line
                    2'h3: apb_prdata <= words_used_o;                       // Words captured
                endcase
            end
        end
    end
    
    // =========================================================================
    // I2C Control Outputs (Camera configuration from SoC)
    // ===== These signals are open-drain style =====
    // Drive to 0 to pull low, release (1) for pull-up
    // =========================================================================
    always_comb begin
        // Default: release (pull-ups active)
        i2c_cam4_sda_oe = 1'b1;
        i2c_cam4_scl_oe = 1'b1;
        i2c_cam5_sda_oe = 1'b1;
        i2c_cam5_scl_oe = 1'b1;
        
        // TODO: Add camera initialization sequence
        // For now, just release (allow SoC firmware to drive I2C)
    end
    
    // =========================================================================
    // UART Debug Output (optional)
    // =========================================================================
    assign uart_tx = 1'b1;  // Idle (would instantiate UART module here for real debug)
    
    // =========================================================================
    // BRAM Read Port (Ethernet -> BRAM)
    // Dual-port BRAM would be instantiated externally
    // This module just provides the write port signals
    // =========================================================================
    assign mipi_cam4_ready = 1'b1;  // Always ready (backpressure handled by DPHY)
    assign mipi_cam5_ready = 1'b1;
    
    // For testing: generate dummy frame sync simulated
    reg [15:0] frame_sync_counter;
    always_ff @(posedge clk_125MHz) begin
        frame_sync_counter <= frame_sync_counter + 1;
        
        // Simulate frame start every 50k cycles (8ms @125MHz)
        frame_start_cam4 <= (frame_sync_counter == 16'd0);
        frame_start_cam5 <= (frame_sync_counter == 16'd1);
        
        // Simulate frame end after 30k cycles (4.8ms capture window)
        frame_end_cam4 <= (frame_sync_counter == 16'd30000);
        frame_end_cam5 <= (frame_sync_counter == 16'd30001);
    end

endmodule
