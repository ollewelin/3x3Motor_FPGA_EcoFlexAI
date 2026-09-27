////////////////////////////////////////////////////////////////////////////////
// test_100mbit_mdio_setup.c - 100Mbit MDIO PHY Configuration
// 
// Forces RTL8211F PHY to 100Mbit Full Duplex mode (no auto-negotiation)
// Simple UART debug output only
////////////////////////////////////////////////////////////////////////////////
#include <stdint.h>
#include "bsp.h"
#include "gpio.h"
#include "uart_mini_driver.h"
#include "mdio_driver.h"

// =============================================================================
// UART & LED Helper Functions
// =============================================================================
void led_on(void)  { gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x1); }
void led_off(void) { gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x0); }
void led_pulse(int ms) {
    led_on();
    bsp_uDelay(ms * 1000);
    led_off();
    bsp_uDelay(ms * 1000);
}

void uart_drain(void) {
    // UART drain - removed to avoid APB hangs
}

void print(const char *s)       { uart_mini_tx_string(s); }
void println(const char *s)     { print(s); uart_mini_newline(); uart_drain(); }
void print_hex16(uint16_t val)  { uart_mini_tx_string("0x"); uart_mini_print_hex16(val); }
void print_hex32(uint32_t val)  {
    uart_mini_tx_string("0x");
    uart_mini_print_hex16(val >> 16);
    uart_mini_print_hex16(val & 0xFFFF);
}

uint16_t bmsr_read(uint8_t phy) {
    uint16_t v;
    mdio_read(phy, PHY_REG_BMSR);
    v = mdio_read(phy, PHY_REG_BMSR);
    if (v == 0xFFFF) return 0;
    return v;
}

uint16_t rtl_physr(uint8_t phy) {
    mdio_write(phy, 0x1F, 0x0a43);
    bsp_uDelay(1000);
    uint16_t v = mdio_read(phy, 0x1A);
    mdio_write(phy, 0x1F, 0x0000);
    return v;
}

// =============================================================================
// RTL8211F RGMII Delay Configuration for 100Mbit
// =============================================================================
void rtl_set_rgmii_delay(uint8_t phy, int tx_delay_en, int rx_delay_en) {
    // Switch to page 0xd08
    mdio_write(phy, 0x1F, 0x0d08);
    bsp_uDelay(1000);
    
    // Read-modify-write register 0x11
    uint16_t reg11 = mdio_read(phy, 0x11);
    
    if (tx_delay_en)
        reg11 |= (1 << 8);    // Enable 2ns TX delay
    else
        reg11 &= ~(1 << 8);   // Disable TX delay
        
    if (rx_delay_en)
        reg11 |= (1 << 3);    // Enable 2ns RX delay
    else
        reg11 &= ~(1 << 3);   // Disable RX delay
    
    mdio_write(phy, 0x11, reg11);
    bsp_uDelay(1000);
    
    // Readback to verify
    uint16_t rb = mdio_read(phy, 0x11);
    
    // Return to page 0
    mdio_write(phy, 0x1F, 0x0000);
    
    print("DLY_REG="); print_hex16(rb);
    print(rb & (1<<8) ? " TX=ON" : " TX=OFF");
    print(rb & (1<<3) ? " RX=ON" : " RX=OFF");
    println("");
}

// =============================================================================
// Auto-Negotiate 100Mbit FD Only (proper way - clears 1G advertisement)
// =============================================================================
void rtl_an_100m_only(uint8_t phy) {
    // Step 1: Clear 1000M advertisement (GBCR reg 0x09)
    // GBCR=0x0200 was left from 1G code - MUST clear this!
    mdio_write(phy, PHY_REG_GBCR, 0x0000);   // No 1000M advertisement
    bsp_uDelay(1000);
    
    // Step 2: Set ANAR to advertise ONLY 100M FD + selector field
    // Bit 8 = 100M FD, Bit 7 = 100M HD, Bit 6 = 10M FD, Bit 5 = 10M HD
    // We want only 100M FD: bit 8 set + bit 0 (selector=802.3)
    mdio_write(phy, PHY_REG_ANAR, 0x0101);   // 100M FD only + selector
    bsp_uDelay(1000);
    
    // Verify clear
    uint16_t gbcr = mdio_read(phy, PHY_REG_GBCR);
    uint16_t anar = mdio_read(phy, PHY_REG_ANAR);
    print("GBCR="); print_hex16(gbcr); print(" (should be 0x0000)"); println("");
    print("ANAR="); print_hex16(anar); print(" (should be 0x0101)"); println("");
    
    // Step 3: Enable auto-negotiate + restart (BMCR bit 12=AN enable, bit 9=restart)
    mdio_write(phy, PHY_REG_BMCR, 0x1200);   // AN enable + restart
    bsp_uDelay(100000);
    
    uint16_t bmcr_rb = mdio_read(phy, PHY_REG_BMCR);
    print("BMCR="); print_hex16(bmcr_rb);
    print(" AN="); print(bmcr_rb & (1<<12) ? "ON" : "OFF");
    println("");
    println("Waiting for 100M AN...");
}

// =============================================================================
// MDIO Diagnostic Functions
// =============================================================================
void mdio_print_reg(const char *name, uint8_t phy, uint8_t reg) {
    uint16_t val = mdio_read(phy, reg);
    print(name); print("="); print_hex16(val); println("");
}

void mdio_diagnostics(uint8_t phy) {
    println("=MDIO DIAGNOSTICS=");
    
    // Read all standard registers
    mdio_print_reg("BMCR", phy, 0x00);
    mdio_print_reg("BMSR", phy, 0x01);
    mdio_print_reg("PHYID1", phy, 0x02);
    mdio_print_reg("PHYID2", phy, 0x03);
    mdio_print_reg("ANAR", phy, 0x04);   // Advertised abilities
    mdio_print_reg("LPAR", phy, 0x05);   // Link partner abilities
    mdio_print_reg("ANER", phy, 0x06);   // Auto-negotiate expansion
    mdio_print_reg("ANNPT", phy, 0x07);  // Auto-negotiate next page
    mdio_print_reg("LPANPT", phy, 0x08); // Link partner next page
    mdio_print_reg("GBCR", phy, 0x09);   // 1000B-T control
    mdio_print_reg("GBSR", phy, 0x0A);   // 1000B-T status
    mdio_print_reg("ESTSR", phy, 0x0F);  // Extended status
    
    println("=RTL VENDOR REGS=");
    // Read RTL vendor registers (page 0xa43)
    mdio_write(phy, 0x1F, 0x0a43);
    bsp_uDelay(1000);
    mdio_print_reg("INSR", phy, 0x10);    // Interrupt status
    mdio_print_reg("INTRP", phy, 0x12);   // Interrupt pin config
    uint16_t phystat = mdio_read(phy, 0x1A);
    print("PHY_STAT="); print_hex16(phystat);
    uint16_t spd = (phystat >> 4) & 0x3;
    print(" Speed=");
    if (spd == 0) print("10M");
    else if (spd == 1) print("100M");
    else if (spd == 2) print("1000M");
    else print("UNK");
    print(" Duplex="); print(phystat & 0x08 ? "FD" : "HD");
    print(" Link="); print(phystat & 0x04 ? "UP" : "DN");
    println("");
    
    mdio_write(phy, 0x1F, 0x0000);  // Return to page 0
    bsp_uDelay(1000);
}

// =============================================================================
// Try Different RGMII Delay Configurations
// =============================================================================
void rtl_try_delay_configs(uint8_t phy) {
    println("=TRYING DELAY CONFIGS=");
    
    const char *configs[] = {
        "TX_OFF RX_OFF",
        "TX_ON  RX_OFF",
        "TX_OFF RX_ON ",
        "TX_ON  RX_ON "
    };
    
    int configs_idx = 0;
    for (int tx = 0; tx <= 1; tx++) {
        for (int rx = 0; rx <= 1; rx++) {
            print("["); print(configs[configs_idx]); print("] ");
            
            // Set delays
            mdio_write(phy, 0x1F, 0x0d08);
            bsp_uDelay(1000);
            uint16_t reg11 = mdio_read(phy, 0x11);
            
            if (tx) reg11 |= (1 << 8);
            else reg11 &= ~(1 << 8);
            
            if (rx) reg11 |= (1 << 3);
            else reg11 &= ~(1 << 3);
            
            mdio_write(phy, 0x11, reg11);
            bsp_uDelay(1000);
            mdio_write(phy, 0x1F, 0x0000);
            bsp_uDelay(1000);
            
            // Wait and check link
            for (int i = 0; i < 3; i++) {
                bsp_uDelay(500000);  // 500ms each
                print("."); uart_drain();
            }
            
            uint16_t bmsr = bmsr_read(phy);
            print(" BMSR="); print_hex16(bmsr);
            if (bmsr & BMSR_LINK_STATUS) {
                print(" **LINK UP**");
            }
            println("");
            
            configs_idx++;
            
            // If link came up, stop trying
            if (bmsr & BMSR_LINK_STATUS) {
                return;
            }
        }
    }
    
    println("NO CONFIG WORKED");
}

// =============================================================================
// Main Entry Point
// =============================================================================
void main(void)
{
    bsp_init();
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, 0x1);
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x0);

    // Phase 1: LED blink (3x fast)
    for (int i = 0; i < 3; i++) {
        led_pulse(200);
    }

    println("==100Mbit MDIO Setup==");

    // Phase 2: HW reset PHY
    print("HW RST...");
    uart_drain();
    mdio_phy_reset_assert();
    bsp_uDelay(50000);
    mdio_phy_reset_release();
    bsp_uDelay(300000);
    println(" OK");

    // Phase 3: Quick ID check
    uint16_t id1 = mdio_read(0x01, PHY_REG_PHYID1);
    uint16_t id2 = mdio_read(0x01, PHY_REG_PHYID2);
    print("ID="); print_hex16(id1); print("/"); print_hex16(id2); println("");
    
    uint8_t phy = 0x01;
    uint16_t bmsr, physr;
    
    // =========================================================================
    // Phase 4-5: Configure RGMII delay and Green Ethernet
    // =========================================================================
    println("=RGMII DLY=");
    rtl_set_rgmii_delay(phy, 1, 1);  // TX delay=ON, RX delay=ON (initial try)
    
    println("=DIS GREEN=");
    mdio_write(phy, 0x1F, 0x0a43);
    mdio_write(phy, 0x1B, 0x8011);
    uint16_t r27 = mdio_read(phy, 0x1B);
    mdio_write(phy, 0x1C, 0x573F);
    uint16_t r28 = mdio_read(phy, 0x1C);
    mdio_write(phy, 0x1F, 0x0000);
    print("R27="); print_hex16(r27); print(" R28="); print_hex16(r28); println("");
    
    // =========================================================================
    // Phase 6: Auto-Negotiate 100Mbit FD (advertise only 100M, no 1G)
    // =========================================================================
    println("=AN 100M ONLY=");
    rtl_an_100m_only(phy);
    
    print("Wait");
    uart_drain();
    
    // Wait up to 10 seconds for AN to complete
    for (int i = 0; i < 10; i++) {
        bsp_uDelay(1000000);  // 1 second
        bmsr = bmsr_read(phy);
        if ((bmsr & BMSR_LINK_STATUS) && (bmsr & BMSR_AN_COMPLETE)) {
            break;
        }
        print("."); uart_drain();
    }
    println("");
    
    // =========================================================================
    // Phase 7: Full MDIO Diagnostics
    // =========================================================================
    mdio_diagnostics(phy);
    
    // =========================================================================
    // Phase 8: If link is still down, try different delay configs
    // =========================================================================
    bmsr = bmsr_read(phy);
    if (!(bmsr & BMSR_LINK_STATUS)) {
        println("");
        println("--LINK DOWN--TRYING CONFIGS--");
        rtl_try_delay_configs(phy);
    }
    
    // =========================================================================
    // Final Status
    // =========================================================================
    println("");
    bmsr = bmsr_read(phy);
    physr = rtl_physr(phy);
    
    print("FINAL BMSR="); print_hex16(bmsr);
    print((bmsr & BMSR_LINK_STATUS) ? " UP" : " DN");
    println("");
    
    print("FINAL PHSR="); print_hex16(physr);
    uint16_t spd = (physr >> 4) & 0x3;
    if (spd == 0) print(" 10M");
    else if (spd == 1) print(" 100M");
    else if (spd == 2) print(" 1000M");
    print((physr & 0x08) ? " FD" : " HD");
    println("");
    
    if (bmsr & BMSR_LINK_STATUS) {
        println("** LINK ESTABLISHED **");
        led_on();
    } else {
        println("LINK FAILED");
        led_off();
    }
    
    // =========================================================================
    // Done: Monitor loop
    // =========================================================================
    println("");
    println("=MONITORING=");
    
    int loop = 0;
    uint16_t last_bmsr = bmsr;
    
    while (1) {
        // Check link status every 5 seconds
        bmsr = bmsr_read(phy);
        
        // Always print BMSR to show polling is active
        print("["); uart_mini_print_hex16(loop); 
        print("] BMSR="); print_hex16(bmsr);
        print((bmsr & BMSR_LINK_STATUS) ? " UP" : " DOWN");
        
        // Only print extra info if status changed
        if (bmsr != last_bmsr) {
            print(" **CHANGED**");
            last_bmsr = bmsr;
            
            if (bmsr & BMSR_LINK_STATUS) {
                led_on();
            } else {
                led_off();
            }
        }
        println("");
        
        bsp_uDelay(5000000);  // 5 seconds
        loop++;
    }
}

void trap(void) { while(1); }
