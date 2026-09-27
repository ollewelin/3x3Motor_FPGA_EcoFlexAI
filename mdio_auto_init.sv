// =============================================================================
// mdio_auto_init.sv : Autonomous Hardware MDIO Initializer for RTL8211F PHY
// =============================================================================
// Automatically executes upon FPGA power-on/reset:
// 1. Waits ~50ms for PHY power and clocks to stabilize.
// 2. Pulses PHY hardware reset (asserts low, then releases high).
// 3. Sweeps PHY addresses 0 through 7:
//    - Disables 1000BASE-T advertisement (Reg 9 GBCR = 0x0000)
//    - Advertises 100M Full/Half & 10M Full/Half only (Reg 4 ANAR = 0x01E1)
//    - Restarts Auto-Negotiation (Reg 0 BMCR = 0x1200)
// 4. Sets init_active = 0, handing full control of mdio_master to the SoC APB3 bus.
// =============================================================================

`timescale 1ns / 1ps
`default_nettype none

module mdio_auto_init #(
    parameter int CLK_HZ = 50_000_000
) (
    input  wire        clk,
    input  wire        rst_n,

    // Control handover
    output logic       init_active,   // 1 = hardware init in progress, 0 = SoC in control

    // Master port to mdio_master APB interface
    output logic       m_psel,
    output logic       m_penable,
    output logic       m_pwrite,
    output logic [3:0] m_paddr,
    output logic [31:0] m_pwdata,
    input  wire  [31:0] m_prdata
);

    localparam logic [3:0] ADDR_CTRL    = 4'h0;
    localparam logic [3:0] ADDR_STATUS  = 4'h1;
    localparam logic [3:0] ADDR_CONFIG  = 4'h2;

    typedef enum logic [3:0] {
        ST_DELAY_POWERUP = 4'd0,
        ST_RST_ASSERT    = 4'd1,
        ST_DELAY_RST     = 4'd2,
        ST_RST_RELEASE   = 4'd3,
        ST_DELAY_READY   = 4'd4,
        ST_CLR_DONE      = 4'd5,
        ST_START_CMD     = 4'd6,
        ST_WAIT_BUSY_LOW = 4'd7,
        ST_NEXT_STEP     = 4'd8,
        ST_DONE          = 4'd9
    } state_t;

    state_t state = ST_DELAY_POWERUP;

    logic [23:0] delay_cnt = '0;
    logic [2:0]  phy_idx   = '0;   // 0 to 7
    logic [1:0]  cmd_idx   = '0;   // 0: GBCR(Reg 9), 1: ANAR(Reg 4), 2: BMCR(Reg 0)
    logic [3:0]  apb_phase = '0;

    // Command parameters
    logic [4:0]  reg_addr;
    logic [15:0] reg_val;

    always_comb begin
        case (cmd_idx)
            2'd0: begin
                reg_addr = 5'd9;        // GBCR: 1000BASE-T Control
                reg_val  = 16'h0000;    // DISABLE 1000M advertisement!
            end
            2'd1: begin
                reg_addr = 5'd4;        // ANAR: Auto-Negotiation Advertisement
                reg_val  = 16'h01E1;    // 100M FD, 100M HD, 10M FD, 10M HD
            end
            2'd2: begin
                reg_addr = 5'd0;        // BMCR: Basic Mode Control
                reg_val  = 16'h1200;    // Auto-neg enable + restart auto-neg
            end
            default: begin
                reg_addr = 5'd0;
                reg_val  = 16'h0000;
            end
        endcase
    end

    // 50 MHz clock timing constants
    localparam logic [23:0] DLY_50MS  = 24'd2_500_000;  // 50 ms
    localparam logic [23:0] DLY_10MS  = 24'd500_000;    // 10 ms
    localparam logic [23:0] DLY_100MS = 24'd5_000_000;  // 100 ms

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= ST_DELAY_POWERUP;
            init_active <= 1'b1;
            m_psel      <= 1'b0;
            m_penable   <= 1'b0;
            m_pwrite    <= 1'b0;
            m_paddr     <= '0;
            m_pwdata    <= '0;
            delay_cnt   <= '0;
            phy_idx     <= '0;
            cmd_idx     <= '0;
            apb_phase   <= '0;
        end else begin
            case (state)
                // 1. Initial power-up settling delay (50 ms)
                ST_DELAY_POWERUP: begin
                    init_active <= 1'b1;
                    if (delay_cnt >= DLY_50MS) begin
                        delay_cnt <= '0;
                        state     <= ST_RST_ASSERT;
                    end else begin
                        delay_cnt <= delay_cnt + 1'b1;
                    end
                end

                // 2. Assert PHY reset (CONFIG[0] = 0)
                ST_RST_ASSERT: begin
                    if (apb_phase == 4'd0) begin
                        m_psel    <= 1'b1;
                        m_penable <= 1'b0;
                        m_pwrite  <= 1'b1;
                        m_paddr   <= ADDR_CONFIG;
                        m_pwdata  <= 32'h0000_0000;
                        apb_phase <= 4'd1;
                    end else if (apb_phase == 4'd1) begin
                        m_penable <= 1'b1;
                        apb_phase <= 4'd2;
                    end else begin
                        m_psel    <= 1'b0;
                        m_penable <= 1'b0;
                        apb_phase <= 4'd0;
                        delay_cnt <= '0;
                        state     <= ST_DELAY_RST;
                    end
                end

                // 3. Hold PHY in reset for 10 ms
                ST_DELAY_RST: begin
                    if (delay_cnt >= DLY_10MS) begin
                        delay_cnt <= '0;
                        state     <= ST_RST_RELEASE;
                    end else begin
                        delay_cnt <= delay_cnt + 1'b1;
                    end
                end

                // 4. Release PHY reset (CONFIG[0] = 1)
                ST_RST_RELEASE: begin
                    if (apb_phase == 4'd0) begin
                        m_psel    <= 1'b1;
                        m_penable <= 1'b0;
                        m_pwrite  <= 1'b1;
                        m_paddr   <= ADDR_CONFIG;
                        m_pwdata  <= 32'h0000_0001;
                        apb_phase <= 4'd1;
                    end else if (apb_phase == 4'd1) begin
                        m_penable <= 1'b1;
                        apb_phase <= 4'd2;
                    end else begin
                        m_psel    <= 1'b0;
                        m_penable <= 1'b0;
                        apb_phase <= 4'd0;
                        delay_cnt <= '0;
                        state     <= ST_DELAY_READY;
                    end
                end

                // 5. Wait 100 ms for PHY internal PLL to lock after reset release
                ST_DELAY_READY: begin
                    if (delay_cnt >= DLY_100MS) begin
                        delay_cnt <= '0;
                        state     <= ST_CLR_DONE;
                    end else begin
                        delay_cnt <= delay_cnt + 1'b1;
                    end
                end

                // 6. Clear mdio_master done flag
                ST_CLR_DONE: begin
                    if (apb_phase == 4'd0) begin
                        m_psel    <= 1'b1;
                        m_penable <= 1'b0;
                        m_pwrite  <= 1'b1;
                        m_paddr   <= ADDR_STATUS;
                        m_pwdata  <= 32'h0000_0002; // Write 1 to bit 1 to clear done
                        apb_phase <= 4'd1;
                    end else if (apb_phase == 4'd1) begin
                        m_penable <= 1'b1;
                        apb_phase <= 4'd2;
                    end else begin
                        m_psel    <= 1'b0;
                        m_penable <= 1'b0;
                        apb_phase <= 4'd0;
                        state     <= ST_START_CMD;
                    end
                end

                // 7. Write MDIO command to ADDR_CTRL
                ST_START_CMD: begin
                    if (apb_phase == 4'd0) begin
                        m_psel    <= 1'b1;
                        m_penable <= 1'b0;
                        m_pwrite  <= 1'b1;
                        m_paddr   <= ADDR_CTRL;
                        // pwdata: [31:16]=wdata, [14:10]=reg_addr, [9:5]=phy_addr, [1]=rw(0), [0]=start(1)
                        m_pwdata  <= {reg_val, 1'b0, reg_addr, {2'b00, phy_idx}, 3'b000, 1'b0, 1'b1};
                        apb_phase <= 4'd1;
                    end else if (apb_phase == 4'd1) begin
                        m_penable <= 1'b1;
                        apb_phase <= 4'd2;
                    end else begin
                        m_psel    <= 1'b0;
                        m_penable <= 1'b0;
                        apb_phase <= 4'd0;
                        delay_cnt <= '0;
                        state     <= ST_WAIT_BUSY_LOW;
                    end
                end

                // 8. Read ADDR_STATUS and wait until mdio_master finishes (busy == 0)
                ST_WAIT_BUSY_LOW: begin
                    // Read STATUS register
                    if (apb_phase == 4'd0) begin
                        m_psel    <= 1'b1;
                        m_penable <= 1'b0;
                        m_pwrite  <= 1'b0;
                        m_paddr   <= ADDR_STATUS;
                        apb_phase <= 4'd1;
                    end else if (apb_phase == 4'd1) begin
                        m_penable <= 1'b1;
                        apb_phase <= 4'd2;
                    end else if (apb_phase == 4'd2) begin
                        // bit 0 is busy, bit 1 is done
                        // Wait at least a few cycles for busy to assert then drop
                        delay_cnt <= delay_cnt + 1'b1;
                        if (((delay_cnt > 24'd1000) && (m_prdata[0] == 1'b0)) || (delay_cnt > 24'd100_000)) begin
                            m_psel    <= 1'b0;
                            m_penable <= 1'b0;
                            apb_phase <= 4'd0;
                            state     <= ST_NEXT_STEP;
                        end
                    end
                end

                // 9. Advance command and PHY indices
                ST_NEXT_STEP: begin
                    if (cmd_idx < 2'd2) begin
                        cmd_idx <= cmd_idx + 1'b1;
                        state   <= ST_CLR_DONE;
                    end else begin
                        cmd_idx <= 2'd0;
                        if (phy_idx < 3'd7) begin
                            phy_idx <= phy_idx + 1'b1;
                            state   <= ST_CLR_DONE;
                        end else begin
                            state   <= ST_DONE;
                        end
                    end
                end

                // 10. Auto-init completed! Deassert init_active and idle.
                ST_DONE: begin
                    init_active <= 1'b0;
                    m_psel      <= 1'b0;
                    m_penable   <= 1'b0;
                    m_pwrite    <= 1'b0;
                end

                default: state <= ST_DONE;
            endcase
        end
    end

endmodule
`default_nettype wire
