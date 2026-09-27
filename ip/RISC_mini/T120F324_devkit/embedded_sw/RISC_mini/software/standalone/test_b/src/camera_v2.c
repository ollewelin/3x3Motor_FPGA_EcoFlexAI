#include <stdint.h>
#include "bsp.h"
#include "i2c.h"
#include "gpio.h"
#include "uart_mini_driver.h"

// IMX219 Constants
// 7-bit 0x10 << 1 = 0x20 Write Address
#define IMX219_ADDR_W     0x20
#define REG_MODE_SELECT   0x0100
#define I2C_BASE          SYSTEM_I2C_0_IO_CTRL
#define GPIO_BASE         SYSTEM_GPIO_0_IO_CTRL
#define I2C_FREQUENCY     100000   // 100 kHz
#define I2C_CTRL_HZ       SYSTEM_CLINT_HZ  // 50 MHz (from RISC_mini BSP soc.h)

// Helper to print strings
void println(const char *s) {
    uart_mini_tx_string(s);
    uart_mini_newline();
}

/**
 * Reset and Power Sequence
 * Bit 0 = CAM2_EN (XCLR)
 * Bit 1 = cam_arm
 */
void camera_hw_setup() {
    // Enable Bit 0 and Bit 1 as outputs
    gpio_setOutputEnable(GPIO_BASE, 0x3);

    // Configure I2C timing for 100 kHz - identical pattern to RISC_mini i2cMasterDemo.
    // MUST be done before any I2C transaction or the master will hang forever
    // with BUSY=1 (TLOW/THIGH=0 means the SCL clock never completes a cycle).
    I2c_Config i2c_cfg;
    i2c_cfg.samplingClockDivider = 3;
    i2c_cfg.timeout              = I2C_CTRL_HZ / 10;               // 0.1 s timeout
    i2c_cfg.tsuDat               = I2C_CTRL_HZ / I2C_FREQUENCY / 3; // ~3.33 us
    i2c_cfg.tLow                 = I2C_CTRL_HZ / I2C_FREQUENCY / 2; // 5 us SCL low
    i2c_cfg.tHigh                = I2C_CTRL_HZ / I2C_FREQUENCY / 2; // 5 us SCL high
    i2c_cfg.tBuf                 = I2C_CTRL_HZ / I2C_FREQUENCY;     // 10 us bus free
    i2c_applyConfig(I2C_BASE, &i2c_cfg);
    
    // 1. Hard Reset: Drive XCLR (Bit 0) LOW
    println("Hardware Reset: Camera OFF...");
    gpio_setOutput(GPIO_BASE, 0x0);
    bsp_uDelay(50000); // 50ms

    // 2. Power Up: Drive XCLR (Bit 0) HIGH
    println("Hardware Power: Camera ON...");
    gpio_setOutput(GPIO_BASE, 0x1);
    
    // IMPORTANT: IMX219 needs time for its internal oscillator 
    // to stabilize before it will respond to I2C.
    bsp_uDelay(100000); // 100ms
}

/**
 * Probe the camera and set to Standby
 */
int camera_v2_probe() {
    // Print BEFORE touching the I2C bus - UART must never run during a transaction
    println("Probing IMX219 at 0x20...");

    // --- Begin I2C transaction - NO uart prints until after i2c_masterStop() ---
    i2c_masterStart(I2C_BASE);

    // Send device address (write)
    i2c_txByte(I2C_BASE, IMX219_ADDR_W);
    while(i2c_masterBusy(I2C_BASE));

    if (i2c_rxNack(I2C_BASE)) {
        i2c_masterStop(I2C_BASE);
        // --- End I2C transaction - safe to print now ---
        println("Result: NACK - No response from camera.");
        return -1;
    }

    // Write REG_MODE_SELECT (0x0100) -> 0x00 (Standby)
    i2c_txByte(I2C_BASE, (REG_MODE_SELECT >> 8));   // Register MSB
    while(i2c_masterBusy(I2C_BASE));

    i2c_txByte(I2C_BASE, (REG_MODE_SELECT & 0xFF)); // Register LSB
    while(i2c_masterBusy(I2C_BASE));

    i2c_txByte(I2C_BASE, 0x00);                     // Data byte
    while(i2c_masterBusy(I2C_BASE));

    i2c_masterStop(I2C_BASE);
    // --- End I2C transaction - safe to print now ---
    println("Result: ACK - Camera is alive!");
    return 0;
}

int main() {
    uart_mini_tx_string("\r\n--- T120 IMX219 Initialization ---\r\n");

    // Initialize Hardware Pins
    camera_hw_setup();

    // Probe Loop
    int attempt = 1;
    while (1) {
        uart_mini_tx_string("Attempt #");
        uart_mini_tx_byte('0' + (attempt % 10));
        uart_mini_tx_string(": ");

        if (camera_v2_probe() == 0) {
            // SUCCESS
            // Now Arm the capture logic in top_level.sv
            // Bit 0 = 1 (Keep camera on), Bit 1 = 1 (Arm recording) -> 0x3
            gpio_setOutput(GPIO_BASE, 0x3);
            println("Capture logic ARMED. Starting MIPI stream...");
            break; 
        }

        attempt++;
        if(attempt > 9) attempt = 1;
        bsp_uDelay(1000000); // Wait 1s before retry
    }

    // Main loop: Blink LED (Bit 0) while keeping Arm (Bit 1) high
    // Note: If Bit 0 is the camera power, blinking it will kill the camera.
    // If you have a separate LED pin, use that instead.
    while (1) {
        // Just stay alive
        bsp_uDelay(500000);
    }

    return 0;
}