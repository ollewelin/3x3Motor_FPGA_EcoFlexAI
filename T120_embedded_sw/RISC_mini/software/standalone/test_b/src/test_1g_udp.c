////////////////////////////////////////////////////////////////////////////////
// test_1g_udp.c - 1Gbit Ethernet UDP Test
// 
// Tests 1Gbit link establishment and UDP packet transmission
// Uses the new eth_2_soc_bridge_1g with async FIFOs and proper CDC
////////////////////////////////////////////////////////////////////////////////
#include <stdint.h>
#include "bsp.h"
#include "gpio.h"
#include "uart_mini_driver.h"
#include "mdio_driver.h"

// =============================================================================
// Ethernet Bridge Register Map (from eth_2_soc_bridge_1g.sv)
// Base address: 0xf8102000
// =============================================================================
#define ETH_BASE            0xf8102000

#define ETH_REG_CONTROL     (*(volatile uint32_t*)(ETH_BASE + 0x00))
#define ETH_REG_STATUS      (*(volatile uint32_t*)(ETH_BASE + 0x04))
#define ETH_REG_TX_DATA     (*(volatile uint32_t*)(ETH_BASE + 0x08))
#define ETH_REG_RX_DATA     (*(volatile uint32_t*)(ETH_BASE + 0x0C))
#define ETH_REG_TX_LEN      (*(volatile uint32_t*)(ETH_BASE + 0x10))
#define ETH_REG_RX_LEN      (*(volatile uint32_t*)(ETH_BASE + 0x14))
#define ETH_REG_TX_UDP_LEN  (*(volatile uint32_t*)(ETH_BASE + 0x18))
#define ETH_REG_MAC_ADDR_LO (*(volatile uint32_t*)(ETH_BASE + 0x1C))
#define ETH_REG_MAC_ADDR_HI (*(volatile uint32_t*)(ETH_BASE + 0x20))
#define ETH_REG_IP_ADDR     (*(volatile uint32_t*)(ETH_BASE + 0x24))
#define ETH_REG_DEST_MAC_LO (*(volatile uint32_t*)(ETH_BASE + 0x28))
#define ETH_REG_DEST_MAC_HI (*(volatile uint32_t*)(ETH_BASE + 0x2C))
#define ETH_REG_DEST_IP     (*(volatile uint32_t*)(ETH_BASE + 0x30))
#define ETH_REG_PORTS       (*(volatile uint32_t*)(ETH_BASE + 0x34))
#define ETH_REG_FRAME_CNT   (*(volatile uint32_t*)(ETH_BASE + 0x38))
#define ETH_REG_DEBUG       (*(volatile uint32_t*)(ETH_BASE + 0x3C))

// Control register bits
#define CTRL_ENABLE         (1 << 0)
#define CTRL_TX_START       (1 << 1)
#define CTRL_TX_RAW         (1 << 2)
#define CTRL_RX_ENABLE      (1 << 3)
#define CTRL_LOOPBACK       (1 << 4)

// Status register bits
#define STAT_TX_BUSY        (1 << 0)
#define STAT_TX_DONE        (1 << 1)
#define STAT_RX_VALID       (1 << 2)
#define STAT_RX_ERROR       (1 << 3)
#define STAT_TX_FIFO_FULL   (1 << 4)
#define STAT_RX_FIFO_EMPTY  (1 << 5)
#define STAT_LINK_UP        (1 << 6)
#define STAT_SPEED_1G       (1 << 7)

// =============================================================================
// Helper Functions
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
    while (!(uart_mini_get_status() & UART_STATUS_TX_EMPTY)) { }
    bsp_uDelay(2000);
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
// RTL8211F RGMII Delay Configuration for 1Gbit
// =============================================================================
// RTL8211F RGMII delays: Page 0xd08, Register 0x11
//   Bit 8: TXDLY (adds 2ns to TXC output, for the receiver to sample our data)
//   Bit 3: RXDLY (adds 2ns to RXC input, for us to sample incoming data)
// Both are in the SAME register (0x11). There is no separate 0x15 register.
// Reference: Linux kernel drivers/net/phy/realtek/realtek_main.c + mdio_driver.h
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
// Configure Ethernet Bridge
// =============================================================================
void eth_configure(void) {
    // Set source MAC address: 02:00:00:00:00:01 (locally administered)
    ETH_REG_MAC_ADDR_LO = 0x00000001;    // MAC[31:0]
    ETH_REG_MAC_ADDR_HI = 0x00000200;    // MAC[47:32]
    
    // Set source IP: 192.168.1.2
    ETH_REG_IP_ADDR = 0xC0A80102;
    
    // Set destination MAC: broadcast (FF:FF:FF:FF:FF:FF)
    // Or set to your PC's MAC for direct delivery
    ETH_REG_DEST_MAC_LO = 0xFFFFFFFF;
    ETH_REG_DEST_MAC_HI = 0x0000FFFF;
    
    // Set destination IP: 192.168.1.1 (typical PC/gateway)
    ETH_REG_DEST_IP = 0xC0A80101;
    
    // Set ports: src=5000, dest=5001
    ETH_REG_PORTS = (5001 << 16) | 5000;
    
    // Enable bridge and RX
    ETH_REG_CONTROL = CTRL_ENABLE | CTRL_RX_ENABLE;
    
    println("ETH CFG OK");
}

// =============================================================================
// Send UDP Test Packet
// =============================================================================
void eth_send_udp_test(uint16_t payload_len, uint32_t seq_num) {
    // Wait for TX ready
    int timeout = 1000;
    while ((ETH_REG_STATUS & STAT_TX_FIFO_FULL) && --timeout > 0) {
        bsp_uDelay(10);
    }
    
    if (timeout <= 0) {
        println("TX FULL!");
        return;
    }
    
    // Setting TX_UDP_LEN triggers header generation
    // The bridge will auto-build Ethernet+IP+UDP headers (42 bytes)
    ETH_REG_TX_UDP_LEN = payload_len;
    
    // Wait a bit for header generation
    bsp_uDelay(100);
    
    // Write payload data to TX FIFO
    // First 4 bytes: sequence number (for packet loss detection)
    ETH_REG_TX_DATA = (seq_num >> 24) & 0xFF;
    ETH_REG_TX_DATA = (seq_num >> 16) & 0xFF;
    ETH_REG_TX_DATA = (seq_num >> 8) & 0xFF;
    ETH_REG_TX_DATA = seq_num & 0xFF;
    
    // Fill rest with test pattern
    for (int i = 4; i < payload_len; i++) {
        ETH_REG_TX_DATA = (i & 0xFF);
    }
    
    // Start transmission
    ETH_REG_CONTROL = CTRL_ENABLE | CTRL_RX_ENABLE | CTRL_TX_START;
    
    // Wait for TX done
    timeout = 10000;
    while (!(ETH_REG_STATUS & STAT_TX_DONE) && --timeout > 0) {
        bsp_uDelay(1);
    }
    
    // Clear TX_DONE sticky bit
    ETH_REG_STATUS = STAT_TX_DONE;
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

    println("==1G UDP Test==");

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
    // Phase 4: Configure RGMII delay for 1Gbit
    // =========================================================================
    println("=RGMII DLY=");
    // Enable both TX and RX 2ns internal delays in the PHY
    // With equal-length PCB traces, both delays are needed for proper RGMII timing
    rtl_set_rgmii_delay(phy, 1, 1);  // TX delay=ON, RX delay=ON
    
    // =========================================================================
    // Phase 5: Disable Green Ethernet (can interfere with 1Gbit)
    // =========================================================================
    println("=DIS GREEN=");
    mdio_write(phy, 0x1F, 0x0a43);
    mdio_write(phy, 0x1B, 0x8011);
    uint16_t r27 = mdio_read(phy, 0x1B);
    mdio_write(phy, 0x1C, 0x573F);
    uint16_t r28 = mdio_read(phy, 0x1C);
    mdio_write(phy, 0x1F, 0x0000);
    print("R27="); print_hex16(r27); print(" R28="); print_hex16(r28); println("");
    
    // =========================================================================
    // Phase 6: Force 1Gbit Full Duplex Auto-Negotiation
    // =========================================================================
    println("=1G AN=");
    
    // Enable 1000BASE-T Full Duplex advertisement
    mdio_write(phy, PHY_REG_GBCR, 0x0200);   // Advertise 1000M FD only
    mdio_write(phy, PHY_REG_ANAR, 0x0001);   // Don't advertise 10/100
    
    // Restart auto-negotiation
    mdio_write(phy, PHY_REG_BMCR, 0x1200);   // AN enable + restart
    
    print("Wait");
    uart_drain();
    
    int linked = 0;
    for (int i = 0; i < 15; i++) {
        bsp_uDelay(1000000);  // 1 second
        bmsr = bmsr_read(phy);
        if ((bmsr & BMSR_LINK_STATUS) && (bmsr & BMSR_AN_COMPLETE)) {
            linked = 1;
            break;
        }
        print("."); uart_drain();
    }
    println("");
    
    bmsr = bmsr_read(phy);
    physr = rtl_physr(phy);
    
    print("BMSR="); print_hex16(bmsr);
    print((bmsr & BMSR_LINK_STATUS) ? " UP" : " DN");
    print((bmsr & BMSR_AN_COMPLETE) ? " AN" : " noAN");
    println("");
    
    print("PHSR="); print_hex16(physr);
    uint16_t spd = (physr >> 4) & 0x3;
    if (spd == 0) print(" 10M");
    else if (spd == 1) print(" 100M");
    else if (spd == 2) print(" 1000M");
    print((physr & 0x08) ? " FD" : " HD");
    println("");
    
    if (!linked || spd != 2) {
        println("NOT 1G!");
        println("Check CLKOUT (R47)");
        // Continue anyway for debugging
    } else {
        println("** 1G LINK OK **");
    }
    
    // =========================================================================
    // Phase 7: Configure Ethernet Bridge
    // =========================================================================
    println("=ETH CFG=");
    eth_configure();
    
    uint32_t status = ETH_REG_STATUS;
    print("STS="); print_hex32(status); println("");
    
    // =========================================================================
    // Phase 8: Send UDP Test Packets
    // =========================================================================
    println("=UDP TX=");
    
    uint32_t seq = 0;
    int burst_size = 10;  // Send 10 packets per burst
    uint16_t payload_size = 100;  // 100 bytes per packet
    
    // Send initial burst
    for (int i = 0; i < burst_size; i++) {
        eth_send_udp_test(payload_size, seq++);
        led_pulse(10);
    }
    
    print("Sent "); uart_mini_print_hex16(burst_size); println(" pkts");
    
    // =========================================================================
    // Phase 9: Continuous TX/Monitor Loop
    // =========================================================================
    println("=MONITOR=");
    println("PC: nc -ul 5001");
    
    int loop = 0;
    uint16_t last_bmsr = bmsr;
    
    while (1) {
        // Check link status
        bmsr = bmsr_read(phy);
        if (bmsr != last_bmsr) {
            print("BMSR="); print_hex16(bmsr);
            print((bmsr & BMSR_LINK_STATUS) ? " UP" : " DN");
            println("");
            last_bmsr = bmsr;
        }
        
        // Send a packet every second when link is up
        if (bmsr & BMSR_LINK_STATUS) {
            eth_send_udp_test(payload_size, seq++);
            led_on();
        } else {
            led_off();
        }
        
        // Print stats every 10 seconds
        if ((loop % 10) == 0) {
            uint32_t cnt = ETH_REG_FRAME_CNT;
            print("["); uart_mini_print_hex16(loop);
            print("] TX="); uart_mini_print_hex16(cnt & 0xFFFF);
            print(" RX="); uart_mini_print_hex16(cnt >> 16);
            println("");
        }
        
        bsp_uDelay(1000000);  // 1 second
        loop++;
        led_off();
    }
}

void trap(void) { while(1); }
