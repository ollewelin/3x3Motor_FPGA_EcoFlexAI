#include "soc.h"
#include "bsp.h"
#include "gpio.h"
#include "i2c.h"

// Optional helpers provided in your repo
#include "common.h"        // For I2C_CTRL_MIPI and mipi_i2c_init()
#include "PiCamDriver.h"   // IMX219 register map (X_ADD_STA_A_*, etc.)
#include "userDef.h"

#include <stdint.h>
#include <stdbool.h>

/* =========================
 *  IMX219 / PiCam v2 basics
 * ========================= */
#define CAM_I2C_ADDR7     0x10            // IMX219 7-bit I2C address
#define CAM_I2C_ADDR8     (CAM_I2C_ADDR7 << 1)

/* ---------- Low-level IMX219 register write (16-bit reg, 8-bit data) ---------- */
static inline void cam_write_reg8(uint16_t reg, uint8_t data) {
    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    i2c_txByte(I2C_CTRL_MIPI, CAM_I2C_ADDR8 | I2C_WRITE);
    i2c_txNackBlocking(I2C_CTRL_MIPI);
    (void)i2c_rxAck(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, (reg >> 8) & 0xFF);
    i2c_txNackBlocking(I2C_CTRL_MIPI);
    (void)i2c_rxAck(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, reg & 0xFF);
    i2c_txNackBlocking(I2C_CTRL_MIPI);
    (void)i2c_rxAck(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, data & 0xFF);
    i2c_txNackBlocking(I2C_CTRL_MIPI);
    (void)i2c_rxAck(I2C_CTRL_MIPI);

    i2c_masterStopBlocking(I2C_CTRL_MIPI);
}

/* Some sequences in the demo expect this “Access Command Sequence” before init */
static void imx219_access_seq(void) {
    cam_write_reg8(0x30EB, 0x05);
    cam_write_reg8(0x30EB, 0x0C);
    cam_write_reg8(0x300A, 0xFF);
    cam_write_reg8(0x300B, 0xFF);
    cam_write_reg8(0x30EB, 0x05);
    cam_write_reg8(0x30EB, 0x09);
}

/* ----------------------- Configure 96x96 output window -----------------------
   Uses the IMX219 Frame Bank A registers from PiCamDriver.h
   Full active array is 3280 x 2464. We'll take a centered 96x96 crop.
------------------------------------------------------------------------------- */
static void imx219_set_roi_96x96_center(void) {
    const uint16_t full_w = 3280;
    const uint16_t full_h = 2464;
    const uint16_t out_w  = 96;
    const uint16_t out_h  = 96;

    // Center the crop window
    const uint16_t x_start = (full_w/2) - (out_w/2);      // 1592
    const uint16_t x_end   = x_start + out_w - 1;         // 1687
    const uint16_t y_start = (full_h/2) - (out_h/2);      // 1184
    const uint16_t y_end   = y_start + out_h - 1;         // 1279

    // Program the sensor ROI (add/sub arrays)
    cam_write_reg8(X_ADD_STA_A_1, (x_start >> 8) & 0x0F);
    cam_write_reg8(X_ADD_STA_A_0, (uint8_t)(x_start & 0xFF));
    cam_write_reg8(X_ADD_END_A_1, (x_end   >> 8) & 0x0F);
    cam_write_reg8(X_ADD_END_A_0, (uint8_t)(x_end   & 0xFF));

    cam_write_reg8(Y_ADD_STA_A_1, (y_start >> 8) & 0x0F);
    cam_write_reg8(Y_ADD_STA_A_0, (uint8_t)(y_start & 0xFF));
    cam_write_reg8(Y_ADD_END_A_1, (y_end   >> 8) & 0x0F);
    cam_write_reg8(Y_ADD_END_A_0, (uint8_t)(y_end   & 0xFF));

    // Output size registers
    cam_write_reg8(x_output_size_A_1, (out_w  >> 8) & 0x0F);
    cam_write_reg8(x_output_size_A_0, (uint8_t)(out_w  & 0xFF));
    cam_write_reg8(y_output_size_A_1, (out_h  >> 8) & 0x0F);
    cam_write_reg8(y_output_size_A_0, (uint8_t)(out_h  & 0xFF));
}

/* ------------------------- Minimal IMX219 initialization -------------------------
   This is distilled from the demo's PiCam init, keeping ONLY I2C/MIPI sensor setup.
   You can extend it with more controls (gain, exposure, binning) as needed.
----------------------------------------------------------------------------------- */
static void imx219_init_96x96(void) {
    // Stop streaming
    cam_write_reg8(mode_select, 0x00);

    // Required access sequence
    imx219_access_seq();

    // Basic lane / clocking settings seen in the demo
    cam_write_reg8(CSI_LANE_MODE, 0x01);    // 2-lane (per demo)
    cam_write_reg8(DPHY_CTRL,     0x00);
    cam_write_reg8(EXCK_FREQ_1,   0x18);    // 24 MHz
    cam_write_reg8(EXCK_FREQ_0,   0x00);

    // Frame/line length (taken from demo baseline)
    cam_write_reg8(FRM_LENGTH_A_1, 0x04);
    cam_write_reg8(FRM_LENGTH_A_0, 0x59);
    cam_write_reg8(LINE_LENGTH_A_1, 0x0D);
    cam_write_reg8(LINE_LENGTH_A_0, 0x78);

    // Program centered 96x96 crop/output
    imx219_set_roi_96x96_center();

    // Reasonable exposure defaults (longer exposure per demo comment)
    cam_write_reg8(COARSE_INTEGRATION_TIME_A_1, 0x04);
    cam_write_reg8(COARSE_INTEGRATION_TIME_A_0, 0x54);

    // Orientation normal
    cam_write_reg8(IMG_ORIENTATION_A, 0x00);

    // Start streaming
    cam_write_reg8(mode_select, 0x01);
}

/* Simple LED blink using GPIO0[0] */
static void blink_loop(void) {
    // Make GPIO0[0] output; other bits remain inputs
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, 0x00000001);

    for(;;) {
        gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x00000001);
        bsp_uDelay(100000); // 100 ms
        gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x00000000);
        bsp_uDelay(100000);
    }
}

int main(void) {
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, 0x1);
    bsp_init();
    i2c_init_100khz();

    uint8_t ctrl[1] = {0x04};
    i2c_writeData_b(SYSTEM_I2C_0_IO_CTRL, 0xE0, 0x04, ctrl, 1);//Set the PCA9542A I2C switch to CAM0
    // Configure I2C controller for the MIPI cam
    mipi_i2c_init();    // uses I2C_CTRL_MIPI from common.h + user/bsp clocks

    // (Optional) switch an upstream I2C mux if present – left out on purpose

    // Bring up the camera with ONLY I2C commands; 96x96 output
    imx219_init_96x96();

    // Heartbeat
    blink_loop();
    return 0;
}

/* RISC-V trap fallback (keep minimal) */
void trap(void) { while (1) { } }
