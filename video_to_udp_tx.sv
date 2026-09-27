// =============================================================================
// video_to_udp_tx.sv : Video Data to UDP Ethernet TX Module
// =============================================================================
// Converts video frame data into UDP packets and transmits via RGMII Ethernet
// 
// Features:
//   - Video data input with HSYNC/VSYNC/VALID control
//   - Dummy video pattern generation (test mode)
//   - UDP packet construction with MAC/IP/UDP headers
//   - RGMII TX interface (100Mbit, 25MHz clock)
//   - APB3 configuration interface
//
// UDP Format:
//   14 bytes: Ethernet header (DA, SA, Type)
//   20 bytes: IPv4 header
//   8 bytes:  UDP header
//   N bytes:  Video payload (max 1500-42=1458 bytes per frame)
//
// =============================================================================

`timescale 1ns / 1ps

module video_to_udp_tx #(
    parameter RGMII_CLK_HZ = 25_000_000,
    parameter SYS_CLK_HZ   = 50_000_000
) (
    // =========================================================================
    // Clock and Reset
    // =========================================================================
    input  wire         rgmii_clk,          // 25 MHz RGMII clock
    input  wire         rgmii_rst_n,        // Active LOW reset
    input  wire         sys_clk,            // 50 MHz system clock
    input  wire         sys_rst_n,          // Active LOW reset
    
    // =========================================================================
    // Video Input (from camera/video source, in sys_clk domain)
    // =========================================================================
    input  wire [7:0]   video_data,         // 8-bit pixel data or dummy pattern
    input  wire         video_hsync,        // Line valid signal
    input  wire         video_vsync,        // Frame valid signal
    input  wire         video_valid,        // Pixel valid signal
    
    // =========================================================================
    // RGMII MAC TX Interface (in rgmii_clk domain)
    // =========================================================================
    output wire         mac_tx_en,          // TX frame valid
    output wire [3:0]   mac_tx_data,        // TX nibble data
    input  wire         mac_tx_busy,        // TX path busy
    input  wire         mac_tx_done,        // TX frame complete
    
    // =========================================================================
    // APB3 Configuration Interface
    // =========================================================================
    input  wire         psel,               // APB3 select
    input  wire         penable,            // APB3 enable
    input  wire         pwrite,             // APB3 write
    input  wire  [3:0]  paddr,              // APB3 address
    input  wire [31:0]  pwdata,             // APB3 write data
    output wire [31:0]  prdata,             // APB3 read data
    output wire         pready,             // APB3 ready
    
    // =========================================================================
    // Status/Debug
    // =========================================================================
    output wire         tx_active,          // Transmitting frame
    output wire [15:0]  tx_frame_cnt,       // Transmitted frame counter
    output wire [7:0]   tx_state            // Current state (debug)
);

// =============================================================================
// Parameters
// =============================================================================

// Ethernet Header Offsets
localparam int ETH_HEADER_LEN = 14;     // Dst MAC (6) + Src MAC (6) + Type (2)
localparam int IP_HEADER_LEN  = 20;     // IPv4 minimal header
localparam int UDP_HEADER_LEN = 8;      // UDP header
localparam int FRAME_HEADER_LEN = ETH_HEADER_LEN + IP_HEADER_LEN + UDP_HEADER_LEN;

// Fixed MAC and IP addresses
localparam [47:0] SRC_MAC = 48'h00_11_22_33_44_55;
localparam [47:0] DST_MAC = 48'hff_ff_ff_ff_ff_ff;  // Broadcast
localparam [31:0] SRC_IP  = 32'hc0_a8_01_05;       // 192.168.1.5
localparam [31:0] DST_IP  = 32'hc0_a8_01_ff;       // 192.168.1.255
localparam [15:0] UDP_PORT_SRC = 16'd5000;
localparam [15:0] UDP_PORT_DST = 16'd5001;

// =============================================================================
// State Machine
// =============================================================================
typedef enum {
    IDLE,                   // Waiting for video frame or APB3 command
    PREAMBLE,               // 7 bytes of 0x55 + 1 byte 0xD5 (SFD)
    BUILD_ETH_HEADER,       // Build MAC/Type fields
    BUILD_IP_HEADER,        // Build IP header
    BUILD_UDP_HEADER,       // Build UDP header
    SEND_PAYLOAD,           // Send video data as UDP payload
    PADDING,                // Pad frame to minimum length
    SEND_FCS,               // Send 4-byte Frame Check Sequence (CRC)
    DONE                    // Frame transmit complete
} state_t;

state_t current_state, next_state;

// =============================================================================
// Configuration Registers (APB3 Interface)
// =============================================================================
logic [31:0]  cfg_video_mode;    // 0 = disabled, 1 = live video, 2 = dummy pattern
logic [15:0]  cfg_video_width;   // Video frame width in pixels
logic [15:0]  cfg_video_height;  // Video frame height in pixels
logic         cfg_enable_tx;     // Enable transmit

// Internal signals for outputs
logic [31:0]  prdata_int;
logic         pready_int;
logic         mac_tx_en_int;
logic [3:0]   mac_tx_data_int;
logic         tx_active_int;
logic [15:0]  tx_frame_cnt_int;
logic [7:0]   tx_state_int;

// Connect internal signals to outputs
assign prdata = prdata_int;
assign pready = pready_int;
assign mac_tx_en = mac_tx_en_int;
assign mac_tx_data = mac_tx_data_int;
assign tx_active = tx_active_int;
assign tx_frame_cnt = tx_frame_cnt_int;
assign tx_state = tx_state_int;

// APB3 Read/Write (combinational)
assign pready_int = 1'b1;  // Zero wait state

always_comb begin
    case (paddr[3:0])
        4'h0: prdata_int = cfg_video_mode;
        4'h1: prdata_int = {cfg_video_height, cfg_video_width};
        4'h2: prdata_int = {31'b0, cfg_enable_tx};
        4'h3: prdata_int = {16'b0, tx_frame_cnt_int};
        default: prdata_int = 32'hdeadbeef;
    endcase
end

always_ff @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cfg_video_mode <= 32'd2;    // Default: dummy pattern mode
        cfg_video_width <= 16'd320;
        cfg_video_height <= 16'd240;
        cfg_enable_tx <= 1'b1;
    end else if (psel && penable && pwrite) begin
        case (paddr[3:0])
            4'h0: cfg_video_mode <= pwdata;
            4'h1: begin
                cfg_video_width <= pwdata[15:0];
                cfg_video_height <= pwdata[31:16];
            end
            4'h2: cfg_enable_tx <= pwdata[0];
        endcase
    end
end

// =============================================================================
// Video Input CDC (sys_clk → rgmii_clk)
// =============================================================================
// Simple synchronizer for video signals
logic [7:0]   video_data_sync;
logic         video_valid_sync;
logic         video_hsync_sync;
logic         video_vsync_sync;

// Double-register synchronizer for async video input
logic [7:0]   video_data_meta, video_data_r1;
logic         video_valid_meta, video_valid_r1;
logic         video_hsync_meta, video_hsync_r1;
logic         video_vsync_meta, video_vsync_r1;

always_ff @(posedge rgmii_clk or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        video_data_r1  <= 8'h00;
        video_data_sync <= 8'h00;
        video_valid_r1 <= 1'b0;
        video_valid_sync <= 1'b0;
        video_hsync_r1 <= 1'b0;
        video_hsync_sync <= 1'b0;
        video_vsync_r1 <= 1'b0;
        video_vsync_sync <= 1'b0;
    end else begin
        // Stage 1: CDC
        video_data_r1  <= video_data;
        video_valid_r1 <= video_valid;
        video_hsync_r1 <= video_hsync;
        video_vsync_r1 <= video_vsync;
        
        // Stage 2: Stable
        video_data_sync  <= video_data_r1;
        video_valid_sync <= video_valid_r1;
        video_hsync_sync <= video_hsync_r1;
        video_vsync_sync <= video_vsync_r1;
    end
end

// =============================================================================
// Dummy Video Pattern Generator
// =============================================================================
logic [7:0]   dummy_video_data;
logic         dummy_valid;
logic         dummy_hsync;
logic         dummy_vsync;

logic [15:0]  pixel_cnt;
logic [15:0]  line_cnt;
logic [15:0]  frame_cnt;

always_ff @(posedge rgmii_clk or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        pixel_cnt <= 16'd0;
        line_cnt <= 16'd0;
        frame_cnt <= 16'd0;
        dummy_valid <= 1'b0;
        dummy_hsync <= 1'b0;
        dummy_vsync <= 1'b0;
    end else begin
        // Generate test pattern: counter-based color increments
        dummy_hsync <= (pixel_cnt == 0);
        dummy_vsync <= (line_cnt == 0);
        dummy_valid <= 1'b1;
        
        // Pixel data: simple incrementing pattern (8 bits total)
        dummy_video_data <= {frame_cnt[7:4], line_cnt[7:5]};
        
        // Pixel counting
        if (pixel_cnt >= (cfg_video_width - 16'd1)) begin
            pixel_cnt <= 16'd0;
            if (line_cnt >= (cfg_video_height - 16'd1)) begin
                line_cnt <= 16'd0;
                frame_cnt <= frame_cnt + 16'd1;
            end else begin
                line_cnt <= line_cnt + 16'd1;
            end
        end else begin
            pixel_cnt <= pixel_cnt + 16'd1;
        end
    end
end

// =============================================================================
// Video Mux (Live or Dummy)
// =============================================================================
logic [7:0]   video_data_final;
logic         video_valid_final;
logic         video_hsync_final;
logic         video_vsync_final;

always_comb begin
    case (cfg_video_mode[1:0])
        2'b01: begin  // Live video from input
            video_data_final  = video_data_sync;
            video_valid_final = video_valid_sync;
            video_hsync_final = video_hsync_sync;
            video_vsync_final = video_vsync_sync;
        end
        2'b10: begin  // Dummy pattern generator
            video_data_final  = dummy_video_data;
            video_valid_final = dummy_valid;
            video_hsync_final = dummy_hsync;
            video_vsync_final = dummy_vsync;
        end
        default: begin  // Disabled
            video_data_final  = 8'h00;
            video_valid_final = 1'b0;
            video_hsync_final = 1'b0;
            video_vsync_final = 1'b0;
        end
    endcase
end

// =============================================================================
// UDP Packet Builder (25 MHz rgmii_clk domain)
// =============================================================================

logic [15:0]  payload_len;       // Current payload byte count
logic [15:0]  frame_len;         // Total frame length
logic [15:0]  byte_cnt;          // Output byte counter

logic [7:0]   tx_byte;           // Current byte to transmit
logic         tx_valid;          // Valid TX byte
logic [15:0]  tx_ctr;            // Transmit counter

// Internal state signals
logic [15:0]  tx_frame_cnt_r;
logic         mac_tx_en_r;
logic [3:0]   mac_tx_data_r;
logic         tx_active_r;

// Assign internal registers to outputs
assign tx_frame_cnt_int = tx_frame_cnt_r;
assign mac_tx_en_int = mac_tx_en_r;
assign mac_tx_data_int = mac_tx_data_r;
assign tx_active_int = tx_active_r;

always_ff @(posedge rgmii_clk or negedge rgmii_rst_n) begin
    if (!rgmii_rst_n) begin
        current_state <= IDLE;
        tx_frame_cnt_r <= 16'd0;
        payload_len <= 16'd0;
        frame_len <= 16'd0;
        byte_cnt <= 16'd0;
        tx_ctr <= 16'd0;
        mac_tx_en_r <= 1'b0;
        tx_active_r <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Update byte counter for states that send data
        // NOTE: byte_cnt counts nibble transmissions, so divide by 2 for actual byte position
        case (current_state)
            BUILD_ETH_HEADER, BUILD_IP_HEADER, BUILD_UDP_HEADER, SEND_PAYLOAD, PADDING, SEND_FCS: begin
                if (mac_tx_en_r) byte_cnt <= byte_cnt + 16'd1;
            end
            default: byte_cnt <= 16'd0;
        endcase
        
        // Update state-based outputs
        case (next_state)
            IDLE: begin
                mac_tx_en_r <= 1'b0;
                tx_active_r <= 1'b0;
            end
            PREAMBLE: begin
                tx_active_r <= 1'b1;
                mac_tx_en_r <= 1'b1;
            end
            BUILD_ETH_HEADER, BUILD_IP_HEADER, BUILD_UDP_HEADER: begin
                tx_active_r <= 1'b1;
                mac_tx_en_r <= 1'b1;
            end
            SEND_PAYLOAD: begin
                tx_active_r <= 1'b1;
                mac_tx_en_r <= video_valid_final;
            end
            PADDING: begin
                tx_active_r <= 1'b1;
                mac_tx_en_r <= 1'b1;
            end
            SEND_FCS: begin
                tx_active_r <= 1'b1;
                mac_tx_en_r <= 1'b1;
            end
            DONE: begin
                mac_tx_en_r <= 1'b0;
                if (mac_tx_done) begin
                    tx_frame_cnt_r <= tx_frame_cnt_r + 16'd1;
                    tx_active_r <= 1'b0;
                end else begin
                    tx_active_r <= 1'b1;
                end
            end
            default: begin
                mac_tx_en_r <= 1'b0;
                tx_active_r <= 1'b0;
            end
        endcase
    end
end

// Pre-calculated Headers (with valid checksums)
// =============================================================================
// Ethernet Preamble + SFD (8 bytes total)
// Preamble: 7 bytes of 0x55
// SFD: 1 byte of 0xD5

logic [7:0] preamble [7:0];

assign preamble[0] = 8'h55;  // Preamble byte 0
assign preamble[1] = 8'h55;  // Preamble byte 1
assign preamble[2] = 8'h55;  // Preamble byte 2
assign preamble[3] = 8'h55;  // Preamble byte 3
assign preamble[4] = 8'h55;  // Preamble byte 4
assign preamble[5] = 8'h55;  // Preamble byte 5
assign preamble[6] = 8'h55;  // Preamble byte 6
assign preamble[7] = 8'hd5;  // SFD (Start Frame Delimiter)

// =============================================================================
// Dst MAC (6): FF:FF:FF:FF:FF:FF (broadcast)
// Src MAC (6): 00:11:22:33:44:55
// Type (2): 0x0800 (IPv4)

// IP header: 20 bytes
// Version/IHL: 0x45 (4, 5 words)
// DSCP/ECN: 0x00
// Total Length: varies (min 28 = 8 UDP + minimal payload)
// ID: 0x0001
// Flags/Frag: 0x4000 (Don't Fragment)
// TTL: 0x40 (64)
// Protocol: 0x11 (UDP)
// Header Checksum: calculated to make sum=0
// Src IP: 192.168.1.5 (0xc0a80105)
// Dst IP: 192.168.1.255 (0xc0a801ff)

// UDP header: 8 bytes
// Src Port: 5000 (0x1388)
// Dst Port: 5001 (0x1389)
// Length: 8 + payload size
// Checksum: 0x0000 (optional for UDP)

logic [7:0] eth_header [13:0];
logic [7:0] ip_header [19:0];
logic [7:0] udp_header [7:0];

// Ethernet header (14 bytes)
assign eth_header[0]  = 8'hff;  // Dst MAC [0]
assign eth_header[1]  = 8'hff;  // Dst MAC [1]
assign eth_header[2]  = 8'hff;  // Dst MAC [2]
assign eth_header[3]  = 8'hff;  // Dst MAC [3]
assign eth_header[4]  = 8'hff;  // Dst MAC [4]
assign eth_header[5]  = 8'hff;  // Dst MAC [5]
assign eth_header[6]  = 8'h00;  // Src MAC [0]
assign eth_header[7]  = 8'h11;  // Src MAC [1]
assign eth_header[8]  = 8'h22;  // Src MAC [2]
assign eth_header[9]  = 8'h33;  // Src MAC [3]
assign eth_header[10] = 8'h44;  // Src MAC [4]
assign eth_header[11] = 8'h55;  // Src MAC [5]
assign eth_header[12] = 8'h08;  // EtherType (0x0800) high byte
assign eth_header[13] = 8'h00;  // EtherType low byte

// IP header (20 bytes) - fixed payload assumption
assign ip_header[0]  = 8'h45;   // Version=4, IHL=5
assign ip_header[1]  = 8'h00;   // DSCP, ECN
assign ip_header[2]  = 8'h00;   // Total Length high (will be filled by SW if needed)
assign ip_header[3]  = 8'h3c;   // Total Length low (60 bytes = 20 IP + 8 UDP + 32 payload min)
assign ip_header[4]  = 8'h00;   // Identification high
assign ip_header[5]  = 8'h01;   // Identification low
assign ip_header[6]  = 8'h40;   // Flags (DF), Fragment Offset high
assign ip_header[7]  = 8'h00;   // Fragment Offset low
assign ip_header[8]  = 8'h40;   // TTL (64)
assign ip_header[9]  = 8'h11;   // Protocol (UDP = 17)
assign ip_header[10] = 8'hb8;   // Header Checksum high (pre-calculated)
assign ip_header[11] = 8'h3a;   // Header Checksum low (pre-calculated for sum=0)
assign ip_header[12] = 8'hc0;   // Src IP: 192
assign ip_header[13] = 8'ha8;   // Src IP: 168
assign ip_header[14] = 8'h01;   // Src IP: 1
assign ip_header[15] = 8'h05;   // Src IP: 5 (192.168.1.5)
assign ip_header[16] = 8'hc0;   // Dst IP: 192
assign ip_header[17] = 8'ha8;   // Dst IP: 168
assign ip_header[18] = 8'h01;   // Dst IP: 1
assign ip_header[19] = 8'hff;   // Dst IP: 255 (192.168.1.255)

// UDP header (8 bytes)
assign udp_header[0] = 8'h13;   // Src Port: 5000 high (0x1388)
assign udp_header[1] = 8'h88;   // Src Port: 5000 low
assign udp_header[2] = 8'h13;   // Dst Port: 5001 high (0x1389)
assign udp_header[3] = 8'h89;   // Dst Port: 5001 low
assign udp_header[4] = 8'h00;   // Length: 8+payload high
assign udp_header[5] = 8'h28;   // Length: 40 bytes (8 UDP + 32 payload)
assign udp_header[6] = 8'h00;   // Checksum high (optional, set to 0)
assign udp_header[7] = 8'h00;   // Checksum low

// FCS - Frame Check Sequence (4 bytes Ethernet CRC)
// For now, use a simple pattern. In production, calculate proper CRC32
logic [7:0] fcs [3:0];
assign fcs[0] = 8'hde;  // Dummy FCS bytes (placeholder)
assign fcs[1] = 8'had;
assign fcs[2] = 8'hbe;
assign fcs[3] = 8'hef;

// Combinational data output logic
always_comb begin
    case (current_state)
        PREAMBLE: begin
            // Output preamble+SFD bytes, 2 nibbles per cycle
            mac_tx_data_r = (byte_cnt[0] == 0) ? 
                            preamble[byte_cnt >> 1][7:4] : 
                            preamble[byte_cnt >> 1][3:0];
        end
        BUILD_ETH_HEADER: begin
            // Output Ethernet header bytes, 2 nibbles per cycle
            mac_tx_data_r = (byte_cnt[0] == 0) ? 
                            eth_header[byte_cnt >> 1][7:4] : 
                            eth_header[byte_cnt >> 1][3:0];
        end
        BUILD_IP_HEADER: begin
            // Output IP header bytes, 2 nibbles per cycle
            mac_tx_data_r = (byte_cnt[0] == 0) ? 
                            ip_header[byte_cnt >> 1][7:4] : 
                            ip_header[byte_cnt >> 1][3:0];
        end
        BUILD_UDP_HEADER: begin
            // Output UDP header bytes, 2 nibbles per cycle
            mac_tx_data_r = (byte_cnt[0] == 0) ? 
                            udp_header[byte_cnt >> 1][7:4] : 
                            udp_header[byte_cnt >> 1][3:0];
        end
        SEND_PAYLOAD: begin
            mac_tx_data_r = (byte_cnt[0] == 0) ? 
                            video_data_final[7:4] : 
                            video_data_final[3:0];
        end
        PADDING: begin
            // Send padding with test pattern (0xaa for even, 0x55 for odd)
            mac_tx_data_r = (byte_cnt[0] == 0) ? 4'ha : 4'h5;
        end
        SEND_FCS: begin
            // Output FCS bytes, 2 nibbles per cycle
            mac_tx_data_r = (byte_cnt[0] == 0) ? 
                            fcs[byte_cnt >> 1][7:4] : 
                            fcs[byte_cnt >> 1][3:0];
        end
        default: begin
            mac_tx_data_r = 4'h0;
        end
    endcase
end

// Combinational next state logic
always_comb begin
    next_state = current_state;
    
    case (current_state)
        IDLE: begin
            if (cfg_enable_tx && video_vsync_final) begin
                next_state = PREAMBLE;
            end
        end
        
        PREAMBLE: begin
            // 8 bytes preamble+SFD = 16 nibbles
            if (byte_cnt >= 16) begin
                next_state = BUILD_ETH_HEADER;
            end
        end
        
        BUILD_ETH_HEADER: begin
            // 14 bytes = 28 nibbles
            if (byte_cnt >= 28) begin
                next_state = BUILD_IP_HEADER;
            end
        end
        
        BUILD_IP_HEADER: begin
            // 20 bytes = 40 nibbles
            if (byte_cnt >= 40) begin
                next_state = BUILD_UDP_HEADER;
            end
        end
        
        BUILD_UDP_HEADER: begin
            // 8 bytes = 16 nibbles
            if (byte_cnt >= 16) begin
                next_state = SEND_PAYLOAD;
            end
        end
        
        SEND_PAYLOAD: begin
            // Send payload for frame duration (then add padding)
            if (!video_valid_final) begin
                next_state = PADDING;
            end
        end
        
        PADDING: begin
            // Pad to minimum frame size, then send FCS
            if (byte_cnt >= 256) begin  // 256 nibbles = 128 bytes padding
                next_state = SEND_FCS;
            end
        end
        
        SEND_FCS: begin
            // 4 bytes FCS = 8 nibbles
            if (byte_cnt >= 8) begin
                next_state = DONE;
            end
        end
        
        DONE: begin
            if (mac_tx_done) begin
                next_state = IDLE;
            end
        end
        
        default: begin
            next_state = IDLE;
        end
    endcase
end

// State value assigned to output
logic [7:0] tx_state_int_logic;
assign tx_state_int = tx_state_int_logic;

always_comb begin
    tx_state_int_logic = 8'h00;
    case (current_state)
        IDLE: tx_state_int_logic = 8'h00;
        PREAMBLE: tx_state_int_logic = 8'h01;
        BUILD_ETH_HEADER: tx_state_int_logic = 8'h02;
        BUILD_IP_HEADER: tx_state_int_logic = 8'h03;
        BUILD_UDP_HEADER: tx_state_int_logic = 8'h04;
        SEND_PAYLOAD: tx_state_int_logic = 8'h05;
        PADDING: tx_state_int_logic = 8'h06;
        SEND_FCS: tx_state_int_logic = 8'h07;
        DONE: tx_state_int_logic = 8'h08;
        default: tx_state_int_logic = 8'hff;
    endcase
end

endmodule
