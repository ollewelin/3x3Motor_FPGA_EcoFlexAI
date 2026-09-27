////////////////////////////////////////////////////////////////////////////////
// t120_cam_b1.c - Single-file IMX219 Camera Init for T120F324_A
//
// I2C camera initialisation using the full PiCam_init() register sequence
// from T20F169 reference design (PiCamDriver.c).
//
// Differences vs T20F169:
//   - No PCA9542A I2C mux (camera direct on SYSTEM_I2C_0)
//   - No I2C_CTRL_MIPI alias - uses SYSTEM_I2C_0_IO_CTRL directly
//   - LED/UART helpers follow T120F324_A test_b project conventions
//   - Timeout-protected I2C primitives with UART diagnostic output
//
// Output: 1920x1080, RAW10, 2-lane MIPI CSI-2, 24 MHz XCLK
////////////////////////////////////////////////////////////////////////////////

#include <stdint.h>
#include "bsp.h"
#include "gpio.h"
#include "i2c.h"
#include "uart_mini_driver.h"

// =============================================================================
// IMX219 Register Address Map
// (ported from T20F169 PiCamDriver.h / t120_camera.c)
// =============================================================================

// General set-up
#define mode_select                 0x0100
#define software_reset              0x0103

// Output / MIPI set-up
#define CSI_LANE_MODE               0x0114
#define DPHY_CTRL                   0x0128
#define EXCK_FREQ_1                 0x012A
#define EXCK_FREQ_0                 0x012B

// Frame bank A – timing
#define ANA_GAIN_GLOBAL_A           0x0157
#define DIG_GAIN_GLOBAL_A_1         0x0158
#define DIG_GAIN_GLOBAL_A_0         0x0159
#define COARSE_INTEGRATION_TIME_A_1 0x015A
#define COARSE_INTEGRATION_TIME_A_0 0x015B
#define FRM_LENGTH_A_1              0x0160
#define FRM_LENGTH_A_0              0x0161
#define LINE_LENGTH_A_1             0x0162
#define LINE_LENGTH_A_0             0x0163

// Frame bank A – window
#define X_ADD_STA_A_1               0x0164
#define X_ADD_STA_A_0               0x0165
#define X_ADD_END_A_1               0x0166
#define X_ADD_END_A_0               0x0167
#define Y_ADD_STA_A_1               0x0168
#define Y_ADD_STA_A_0               0x0169
#define Y_ADD_END_A_1               0x016A
#define Y_ADD_END_A_0               0x016B
#define x_output_size_A_1           0x016C
#define x_output_size_A_0           0x016D
#define y_output_size_A_1           0x016E
#define y_output_size_A_0           0x016F

// Frame bank A – pixel/binning/format
#define X_ODD_INC_A                 0x0170
#define Y_ODD_INC_A                 0x0171
#define IMG_ORIENTATION_A           0x0172
#define BINNING_MODE_H_A            0x0174
#define BINNING_MODE_V_A            0x0175
#define CSI_DATA_FORMAT_A_1         0x018C
#define CSI_DATA_FORMAT_A_0         0x018D

// PLL
#define VTPXCK_DIV                  0x0301
#define VTSYCK_DIV                  0x0303
#define PREPLLCK_VT_DIV             0x0304
#define PREPLLCK_OP_DIV             0x0305
#define PLL_VT_MPY_1                0x0306
#define PLL_VT_MPY_0                0x0307
#define OPPXCK_DIV                  0x0309
#define OPSYCK_DIV                  0x030B
#define PLL_OP_MPY_1                0x030C
#define PLL_OP_MPY_0                0x030D

// IMX219 I2C address (7-bit = 0x10, 8-bit write = 0x20)
#define CAM_I2C_ADDR7               0x10
#define CAM_I2C_ADDR8               (CAM_I2C_ADDR7 << 1)

// =============================================================================
// LED Helpers  (pattern from test_b/src/main.c)
// GPIO bit 0 : LED
// GPIO bit 1 : CAM2_EN (must stay HIGH)
// =============================================================================

static void led_on(void) {
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x3);  // LED on, CAM2_EN high
}

static void led_off(void) {
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2);  // LED off, CAM2_EN high
}

static void led_pulse(int ms) {
    led_on();
    bsp_uDelay(ms * 1000);
    led_off();
    bsp_uDelay(ms * 1000);
}

// =============================================================================
// UART Helpers  (pattern from test_b/src/t120_camera.c)
// =============================================================================

static void uart_drain(void) {
    while (!(uart_mini_get_status() & UART_STATUS_TX_EMPTY)) { }
    bsp_uDelay(2000);
}

static void print(const char *s) {
    uart_mini_tx_string(s);
}

static void println(const char *s) {
    print(s);
    uart_mini_newline();
    uart_drain();
}

static void print_hex8(uint8_t val) {
    static const char hex[] = "0123456789ABCDEF";
    uart_mini_tx_byte(hex[(val >> 4) & 0xF]);
    uart_mini_tx_byte(hex[val & 0xF]);
}

static void print_hex32(uint32_t val) {
    print_hex8((val >> 24) & 0xFF);
    print_hex8((val >> 16) & 0xFF);
    print_hex8((val >>  8) & 0xFF);
    print_hex8( val        & 0xFF);
}

// =============================================================================
// I2C Initialisation  (from test_b/src/t120_camera.c)
// =============================================================================

static void i2c_init_100khz(void) {
    I2c_Config cfg;

    const uint32_t fclk_hz       = 50000000;           // 50 MHz SoC clock
    const uint32_t cycles_per_us = fclk_hz / 1000000;  // 50 cycles/µs

    cfg.samplingClockDivider = 3;
    cfg.timeout              = (1000 * cycles_per_us) - 1;   // ~1 ms timeout
    cfg.tsuDat               = (1 * cycles_per_us) - 1;
    cfg.tLow                 = (5 * cycles_per_us) - 1;
    cfg.tHigh                = (5 * cycles_per_us) - 1;
    cfg.tBuf                 = (5 * cycles_per_us) - 1;

    i2c_applyConfig(SYSTEM_I2C_0_IO_CTRL, &cfg);
    println("I2C 100kHz init OK");
}

// =============================================================================
// Timeout-Protected I2C Primitives  (from test_b/src/t120_camera.c)
// =============================================================================

static void dbg_i2c_status(void) {
    uint32_t s = read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_MASTER_STATUS);
    print(" [MSTS=0x"); print_hex32(s); print("] ");
    uart_drain();
}

static int cam_i2c_start(void) {
    i2c_masterStart(SYSTEM_I2C_0_IO_CTRL);
    volatile uint32_t t = 2000000;
    while (read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_MASTER_STATUS) & I2C_MASTER_START) {
        if (--t == 0) { print("[START_TO]"); dbg_i2c_status(); return -1; }
    }
    return 0;
}

static void cam_i2c_stop(void) {
    i2c_masterStop(SYSTEM_I2C_0_IO_CTRL);
    volatile uint32_t t = 2000000;
    while (read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_MASTER_STATUS) & I2C_MASTER_BUSY) {
        if (--t == 0) { print("[STOP_TO]"); uart_drain(); return; }
    }
}

static int cam_i2c_txbyte_ack(uint8_t byte) {
    i2c_txByte(SYSTEM_I2C_0_IO_CTRL, byte);
    i2c_txNack(SYSTEM_I2C_0_IO_CTRL);
    volatile uint32_t t = 1000000;
    while (read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_TX_ACK) & I2C_TX_VALID) {
        if (--t == 0) { print("[TXACK_TO]"); uart_drain(); return -1; }
    }
    if (read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_RX_ACK) & I2C_RX_VALUE) {
        return -1;
    }
    return 0;
}

// Write 8-bit data to 16-bit IMX219 register; returns 0=ok, -1=error
static int cam_write_reg8(uint16_t reg, uint8_t data) {
    if (cam_i2c_start()) { print("[WR:START_FAIL]"); uart_drain(); return -1; }
    if (cam_i2c_txbyte_ack(CAM_I2C_ADDR8 | I2C_WRITE)) {
        print("[WR:ADDR_NACK addr=0x"); print_hex8(CAM_I2C_ADDR8); print("]");
        uart_drain(); goto fail;
    }
    if (cam_i2c_txbyte_ack((reg >> 8) & 0xFF)) {
        print("[WR:REG_H_NACK]"); uart_drain(); goto fail;
    }
    if (cam_i2c_txbyte_ack(reg & 0xFF)) {
        print("[WR:REG_L_NACK]"); uart_drain(); goto fail;
    }
    if (cam_i2c_txbyte_ack(data)) {
        print("[WR:DATA_NACK]"); uart_drain(); goto fail;
    }
    cam_i2c_stop();
    bsp_uDelay(500);
    return 0;
fail:
    cam_i2c_stop();
    bsp_uDelay(500);
    return -1;
}

// =============================================================================
// IMX219 Camera Functions
// (ported 1-to-1 from T20F169 PiCamDriver.c - same I2C sequence)
// =============================================================================

// Required manufacturer unlock sequence before programming registers
static void imx219_access_seq(void) {
    print("  Access seq..."); uart_drain();
    int e = 0;
    e |= cam_write_reg8(0x30EB, 0x05);
    e |= cam_write_reg8(0x30EB, 0x0C);
    e |= cam_write_reg8(0x300A, 0xFF);
    e |= cam_write_reg8(0x300B, 0xFF);
    e |= cam_write_reg8(0x30EB, 0x05);
    e |= cam_write_reg8(0x30EB, 0x09);
    if (e) println("NACK!"); else println("OK");
}

static void imx219_set_output_size(uint16_t x, uint16_t y) {
    cam_write_reg8(x_output_size_A_1, (uint8_t)(x >> 8));
    cam_write_reg8(x_output_size_A_0, (uint8_t)(x & 0xFF));
    cam_write_reg8(y_output_size_A_1, (uint8_t)(y >> 8));
    cam_write_reg8(y_output_size_A_0, (uint8_t)(y & 0xFF));
}

static void imx219_set_active_pixel(uint16_t xs, uint16_t xe,
                                     uint16_t ys, uint16_t ye) {
    cam_write_reg8(X_ADD_STA_A_1, (uint8_t)(xs >> 8));
    cam_write_reg8(X_ADD_STA_A_0, (uint8_t)(xs & 0xFF));
    cam_write_reg8(X_ADD_END_A_1, (uint8_t)(xe >> 8));
    cam_write_reg8(X_ADD_END_A_0, (uint8_t)(xe & 0xFF));
    cam_write_reg8(Y_ADD_STA_A_1, (uint8_t)(ys >> 8));
    cam_write_reg8(Y_ADD_STA_A_0, (uint8_t)(ys & 0xFF));
    cam_write_reg8(Y_ADD_END_A_1, (uint8_t)(ye >> 8));
    cam_write_reg8(Y_ADD_END_A_0, (uint8_t)(ye & 0xFF));
}

static void imx219_set_binning(uint8_t xmode, uint8_t ymode) {
    if (xmode > 3) xmode = 3;
    if (ymode > 3) ymode = 3;
    cam_write_reg8(BINNING_MODE_H_A, xmode);
    cam_write_reg8(BINNING_MODE_V_A, ymode);
}

static void imx219_set_gain(uint8_t a_gain, uint16_t d_gain) {
    cam_write_reg8(ANA_GAIN_GLOBAL_A,   a_gain & 0xFF);
    cam_write_reg8(DIG_GAIN_GLOBAL_A_1, (uint8_t)((d_gain >> 8) & 0x0F));
    cam_write_reg8(DIG_GAIN_GLOBAL_A_0, (uint8_t)(d_gain & 0xFF));
}

// -----------------------------------------------------------------------------
// Full IMX219 init – register sequence ported from T20F169 PiCam_init()
// Output: 1920x1080, RAW10, 2-lane MIPI CSI-2, 24 MHz XCLK
// -----------------------------------------------------------------------------
static void imx219_init(void) {
    println("=IMX219 INIT (T20F169 seq)=");

    // Dump raw bus state
    print("  I2C status:"); dbg_i2c_status(); println("");

    // 1. Standby
    print("  Standby..."); uart_drain();
    if (cam_write_reg8(mode_select, 0x00)) {
        println("FAIL - camera not responding");
        print("  I2C status:"); dbg_i2c_status(); println("");
        return;
    }
    println("OK");

    // 2. Manufacturer unlock
    imx219_access_seq();

    // 3. MIPI CSI-2: 2 lanes, DPHY auto, 24 MHz input clock
    print("  MIPI config..."); uart_drain();
    cam_write_reg8(CSI_LANE_MODE, 0x01);
    cam_write_reg8(DPHY_CTRL,     0x00);
    cam_write_reg8(EXCK_FREQ_1,   0x18);   // 24 MHz
    cam_write_reg8(EXCK_FREQ_0,   0x00);
    println("OK");

    // 4. Frame / line timing (initial values – overwritten below after streaming)
    print("  Frame timing A..."); uart_drain();
    cam_write_reg8(FRM_LENGTH_A_1,  0x04);
    cam_write_reg8(FRM_LENGTH_A_0,  0x59);
    cam_write_reg8(LINE_LENGTH_A_1, 0x0D);
    cam_write_reg8(LINE_LENGTH_A_0, 0x78);
    println("OK");

    // 5. Active pixel window: XStart=680, XEnd=3279, YStart=0, YEnd=2463
    //    (central offset for 1920-pixel-wide output, same as T20F169 reference)
    print("  Active pixel..."); uart_drain();
    imx219_set_active_pixel(680, 3279, 0, 2463);
    println("OK");

    // 6. Output size: 1920x1080
    print("  Output size..."); uart_drain();
    imx219_set_output_size(1920, 1080);
    println("OK");

    // 7. Pixel increment (no skip)
    print("  ODD INC..."); uart_drain();
    cam_write_reg8(X_ODD_INC_A, 0x01);
    cam_write_reg8(Y_ODD_INC_A, 0x01);
    println("OK");

    // 8. Binning: none
    print("  Binning off..."); uart_drain();
    imx219_set_binning(0, 0);
    println("OK");

    // 9. CSI data format: RAW10
    print("  CSI fmt RAW10..."); uart_drain();
    cam_write_reg8(CSI_DATA_FORMAT_A_1, 0x0A);
    cam_write_reg8(CSI_DATA_FORMAT_A_0, 0x0A);
    println("OK");

    // 10. PLL (from T20F169 reference, 24 MHz -> MIPI pixel clock)
    print("  PLL..."); uart_drain();
    cam_write_reg8(VTPXCK_DIV,      0x05);
    cam_write_reg8(VTSYCK_DIV,      0x01);
    cam_write_reg8(PREPLLCK_VT_DIV, 0x03);
    cam_write_reg8(PREPLLCK_OP_DIV, 0x03);
    cam_write_reg8(PLL_VT_MPY_1,    0x00);
    cam_write_reg8(PLL_VT_MPY_0,    0x39);
    cam_write_reg8(OPPXCK_DIV,      0x0A);
    cam_write_reg8(OPSYCK_DIV,      0x01);
    cam_write_reg8(PLL_OP_MPY_1,    0x00);
    cam_write_reg8(PLL_OP_MPY_0,    0x72);
    // Second write (as in T20F169 reference)
    cam_write_reg8(OPPXCK_DIV,      0x0A);
    cam_write_reg8(OPSYCK_DIV,      0x01);
    cam_write_reg8(PLL_OP_MPY_1,    0x00);
    cam_write_reg8(PLL_OP_MPY_0,    0x72);
    println("OK");

    // 11. Start streaming
    print("  Start stream..."); uart_drain();
    cam_write_reg8(mode_select, 0x01);
    println("OK");

    // 12. Gain (AGain=0xB9, DGain=0x200) – can be written while streaming
    print("  Gain..."); uart_drain();
    imx219_set_gain(0xB9, 0x200);
    println("OK");

    // 13. Line length (re-applied after streaming start, as in T20F169)
    cam_write_reg8(LINE_LENGTH_A_1, 0x0D);
    cam_write_reg8(LINE_LENGTH_A_0, 0x78);

    // 14. Longer exposure / lower frame rate (from T20F169 "longer exposure" block)
    print("  Exposure..."); uart_drain();
    cam_write_reg8(FRM_LENGTH_A_1,              0x06);
    cam_write_reg8(FRM_LENGTH_A_0,              0xE3);
    cam_write_reg8(COARSE_INTEGRATION_TIME_A_1, 0x04);
    cam_write_reg8(COARSE_INTEGRATION_TIME_A_0, 0x54);
    println("OK");

    // 15. Normal image orientation
    cam_write_reg8(IMG_ORIENTATION_A, 0x00);

    println("=IMX219 READY=");
}

// =============================================================================
// Camera Top-Level Init
// =============================================================================

static void camera_init(void) {
    print("Init I2C..."); uart_drain();
    i2c_init_100khz();

    print("Settling..."); uart_drain();
    bsp_uDelay(50000);   // 50 ms power-on settle
    println("OK");

    imx219_init();
    println("=CAM SETUP COMPLETE=");
}

// =============================================================================
// Main Entry Point
// =============================================================================

void main(void) {
    bsp_init();

    // GPIO bit 0: LED output
    // GPIO bit 1: CAM2_EN (camera enable, keep HIGH throughout)
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, 0x3);
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2);   // LED off, CAM2_EN high

    // Boot indicator: 3x fast blink
    for (int i = 0; i < 3; i++) {
        led_pulse(200);
    }

    println("==T120 CAM B1 INIT==");

    // Ensure camera power is enabled (bit 1 = CAM2_EN high)
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2);
    bsp_uDelay(100000);   // 100 ms power-up delay

    println("Camera init starting...");
    camera_init();
    println("Camera init complete");

    println("Idle loop...");

    // Idle loop with LED heartbeat
    int loop_count = 0;
    while (1) {
        led_on();
        bsp_uDelay(500000);   // 500 ms on
        led_off();
        bsp_uDelay(500000);   // 500 ms off
        loop_count++;

        if ((loop_count % 10) == 0) {
            println("Running...");
        }
    }
}

void trap(void) { while (1) { } }
