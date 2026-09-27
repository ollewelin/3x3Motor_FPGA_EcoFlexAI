////////////////////////////////////////////////////////////////////////////////
// main.c - T120F324_A Camera Setup Test
// 
// Entry point for test_b project
// Initializes BSP and camera (CAM2 IMX219 via I2C)
////////////////////////////////////////////////////////////////////////////////

#include <stdint.h>
#include "bsp.h"
#include "gpio.h"
#include "uart_mini_driver.h"

// Declare camera_init from t120_camera.c
extern void camera_init(void);

// =============================================================================
// LED Helper Functions (GPIO bit 0 only - keep bit 1 high for CAM2_EN)
// =============================================================================
static void led_on(void) {
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x3);  // LED on (bit 0=1), CAM2_EN high (bit 1=1)
}

static void led_off(void) {
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2);  // LED off (bit 0=0), CAM2_EN high (bit 1=1)
}

static void led_pulse(int ms) {
    led_on();
    bsp_uDelay(ms * 1000);
    led_off();
    bsp_uDelay(ms * 1000);
}

static void uart_drain(void) {
    while (!(uart_mini_get_status() & UART_STATUS_TX_EMPTY)) { }
    bsp_uDelay(2000);
}

static void println(const char *s) {
    uart_mini_tx_string(s);
    uart_mini_newline();
    uart_drain();
}

// =============================================================================
// Main Entry Point
// =============================================================================
void main(void) {
    // Initialize basic I/O
    bsp_init();
    
    // GPIO bit 0: LED output
    // GPIO bit 1: CAM2_EN (camera enable)
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, 0x3);  // Enable bits 0 and 1
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2);        // LED off (bit 0=0), CAM2_EN on (bit 1=1)

    // Phase 1: LED blink (3x fast) - boot indicator
    for (int i = 0; i < 3; i++) {
        led_pulse(200);
    }

    println("==T120 CAM2 INIT==");

    // Enable camera power (CAM2_EN high)
    println("Enabling CAM2 power...");
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2);  // Keep LED off, CAM2_EN HIGH
    bsp_uDelay(100000);  // 100 ms power-up delay

    // Initialize camera (full setup sequence - single shot)
    println("Camera initialization starting...");
    camera_init();
    println("Camera initialization complete");

    // Phase 3: Idle loop with LED activity
    // UART will switch to camera frame data after 20 seconds (top_level.sv timer)
    println("Waiting for UART switch (20 seconds)...");
    println("");

    int loop_count = 0;
    while (1) {
        led_on();
        bsp_uDelay(500000);  // 500 ms on
        led_off();
        bsp_uDelay(500000);  // 500 ms off
        loop_count++;

        // Print status every 10 seconds
        if ((loop_count % 10) == 0) {
            println("Time: 5 seconds elapsed");
        }

        // At 20 seconds, UART TX will have switched to camera frame data
        if (loop_count >= 40) {
            println("UART switched to camera frame output");
            loop_count = 0;  // Reset counter for next cycle
        }
    }
}

// =============================================================================
// Trap Handler (fallback for exceptions)
// =============================================================================
void trap(void) {
    while (1) {
        // Infinite loop on trap
        led_on();
        bsp_uDelay(100000);
        led_off();
        bsp_uDelay(100000);
    }
}
