////////////////////////////////////////////////////////////////////////////////
// main.c - T120F324_A Camera + PHY Setup
//
// Entry point for test_b project.
// Initializes:
//   1. CAM2 IMX219 via I2C (camera_init from t120_camera.c)
//   2. RTL8211F-CG RGMII PHY via MDIO (phy_init inline below)
// Video is streamed continuously over the blue_wire_video_bus (vid_clk/vid_d).
// UART → uart_mini permanently (no 20-second MUX switch).
////////////////////////////////////////////////////////////////////////////////

#include <stdint.h>
#include "bsp.h"
#include "gpio.h"
#include "uart_mini_driver.h"
#include "mdio_driver.h"

extern void camera_init(void);

// =============================================================================
// Local helpers (all static to avoid duplicate-symbol link errors)
// =============================================================================
static void led_on(void)  { gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x3); }
static void led_off(void) { gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2); }

static void led_pulse(int ms) {
    led_on();  bsp_uDelay(ms * 1000);
    led_off(); bsp_uDelay(ms * 1000);
}

static void uart_drain(void) {
    while (!(uart_mini_get_status() & UART_STATUS_TX_EMPTY)) {}
    bsp_uDelay(2000);
}

static void print_s(const char *s) { uart_mini_tx_string(s); }
static void println_s(const char *s) { print_s(s); uart_mini_newline(); uart_drain(); }

static void print_hex16_s(uint16_t v) {
    static const char h[] = "0123456789ABCDEF";
    uart_mini_tx_byte(h[(v >> 12) & 0xF]);
    uart_mini_tx_byte(h[(v >>  8) & 0xF]);
    uart_mini_tx_byte(h[(v >>  4) & 0xF]);
    uart_mini_tx_byte(h[ v        & 0xF]);
}

// =============================================================================
// RTL8211F-CG PHY Initialisation via MDIO
// Sets RGMII internal TX/RX delays and configures 1Gbit auto-negotiation.
// PHY MDIO address: 0x01 (default for RTL8211F-CG)
// =============================================================================
static void phy_init(void) {
    const uint8_t phy = 0x01;

    println_s("=PHY INIT=");

    // Hardware reset: assert for 50 ms, release, wait 300 ms for PHY ready
    print_s("PHY HW RST...");
    mdio_phy_reset_assert();
    bsp_uDelay(50000);
    mdio_phy_reset_release();
    bsp_uDelay(300000);
    println_s("OK");

    // Read and print PHY ID for sanity check
    uint16_t id1 = mdio_read(phy, PHY_REG_PHYID1);
    uint16_t id2 = mdio_read(phy, PHY_REG_PHYID2);
    print_s("ID="); print_hex16_s(id1); print_s("/"); print_hex16_s(id2); println_s("");

    // -----------------------------------------------------------------
    // RGMII internal delay: page 0xd08, register 0x11
    //   bit 8 = TXDLY (2 ns TX delay in PHY, for far-end to sample our data)
    //   bit 3 = RXDLY (2 ns RX delay in PHY, for us to sample incoming data)
    // Enable both for standard RGMII with equal PCB trace lengths.
    // -----------------------------------------------------------------
    print_s("RGMII DLY...");
    mdio_write(phy, 0x1F, 0x0d08);
    bsp_uDelay(1000);
    uint16_t reg11 = mdio_read(phy, 0x11);
    reg11 |= (1 << 8) | (1 << 3);   // TX and RX delay ON
    mdio_write(phy, 0x11, reg11);
    bsp_uDelay(1000);
    uint16_t rb = mdio_read(phy, 0x11);
    mdio_write(phy, 0x1F, 0x0000);
    print_s("REG="); print_hex16_s(rb);
    print_s(rb & (1 << 8) ? " TX=ON" : " TX=OFF");
    print_s(rb & (1 << 3) ? " RX=ON" : " RX=OFF");
    println_s("");

    // -----------------------------------------------------------------
    // Disable Green Ethernet (can interfere with 1Gbit link stability)
    // -----------------------------------------------------------------
    print_s("Dis GreenEth...");
    mdio_write(phy, 0x1F, 0x0a43);
    mdio_write(phy, 0x1B, 0x8011);
    mdio_write(phy, 0x1C, 0x573F);
    mdio_write(phy, 0x1F, 0x0000);
    println_s("OK");

    // -----------------------------------------------------------------
    // Force 1Gbit full-duplex auto-negotiation
    // -----------------------------------------------------------------
    println_s("1G AN start...");
    mdio_write(phy, PHY_REG_GBCR, 0x0200);  // Advertise 1000M FD only
    mdio_write(phy, PHY_REG_ANAR, 0x0001);  // Do not advertise 10/100
    mdio_write(phy, PHY_REG_BMCR, 0x1200);  // AN enable + restart AN

    // Wait up to 10 s for link
    int linked = 0;
    for (int i = 0; i < 10; i++) {
        bsp_uDelay(1000000);
        // Read BMSR twice (first read may return stale latched state)
        mdio_read(phy, PHY_REG_BMSR);
        uint16_t bmsr = mdio_read(phy, PHY_REG_BMSR);
        if ((bmsr & 0x0004) && (bmsr & 0x0020)) { linked = 1; break; }
        print_s("."); uart_drain();
    }
    println_s("");

    // Report result
    mdio_read(phy, PHY_REG_BMSR);
    uint16_t bmsr  = mdio_read(phy, PHY_REG_BMSR);
    // PHY specific status: switch to page 0xa43, read reg 0x1A
    mdio_write(phy, 0x1F, 0x0a43);
    bsp_uDelay(1000);
    uint16_t physr = mdio_read(phy, 0x1A);
    mdio_write(phy, 0x1F, 0x0000);

    print_s("BMSR="); print_hex16_s(bmsr);
    print_s((bmsr & 0x0004) ? " LINK" : " noLINK");
    print_s((bmsr & 0x0020) ? " AN_OK" : " no_AN");
    println_s("");

    uint16_t spd = (physr >> 4) & 0x3;
    print_s("PHYSR="); print_hex16_s(physr);
    if      (spd == 2) print_s(" 1000M");
    else if (spd == 1) print_s(" 100M");
    else               print_s(" 10M");
    print_s((physr & 0x08) ? " FD" : " HD");
    println_s("");

    if (linked && spd == 2)
        println_s("** 1G LINK OK **");
    else
        println_s("WARN: not 1G — check PHY CLKOUT (R47)");
}

// =============================================================================
// Main
// =============================================================================
void main(void) {
    bsp_init();

    // bit 0 = LED, bit 1 = CAM2_EN
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, 0x3);
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2);  // LED off, CAM2_EN HIGH

    for (int i = 0; i < 3; i++) led_pulse(200);

    println_s("=V=T120 INIT=V=");

    // Camera power-on + init
    println_s("CAM2 power on...");
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2);
    bsp_uDelay(100000);
    println_s("Camera init...");
    camera_init();
    println_s("Camera init OK");

    // PHY setup via MDIO
    phy_init();

    // Idle — video streams via blue_wire_video_bus (vid_clk / vid_d[7:0])
    println_s("Streaming via blue_wire_video_bus...");

    int n = 0;
    while (1) {
        led_on();  bsp_uDelay(500000);
        led_off(); bsp_uDelay(500000);
        if ((++n % 20) == 0) println_s("Running...");
    }
}

void trap(void) {
    while (1) { led_on(); bsp_uDelay(100000); led_off(); bsp_uDelay(100000); }
}

