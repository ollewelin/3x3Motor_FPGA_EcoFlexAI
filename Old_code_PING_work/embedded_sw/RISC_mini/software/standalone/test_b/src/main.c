////////////////////////////////////////////////////////////////////////////////
// main.c - T120F324_A 100Mbit RGMII Ethernet Setup & Ping Responder
//
// Features:
//   1. RTL8211F-CG PHY configured via MDIO for 100M Full Duplex immediately
//   2. 100M Ethernet MAC (eth_mac_100m) at 0xf8102000
//   3. Autonomous ARP Responder (IP: 192.168.1.50, MAC: 00:12:34:56:78:9A)
//   4. Autonomous ICMP Echo (Ping) Responder
//   5. Heartbeat and packet activity LED blinking on CAM3_SDA_OUT
////////////////////////////////////////////////////////////////////////////////

#include <stdint.h>
#include <string.h>
#include "bsp.h"
#include "gpio.h"
#include "uart_mini_driver.h"
#include "mdio_driver.h"

// =============================================================================
// Ethernet MAC Peripheral Registers (at 0xf8102000)
// =============================================================================
#define ETH_BASE            0xf8102000
#define ETH_CTRL_REG        (*(volatile uint32_t *)(ETH_BASE + 0x00))
#define ETH_STATUS_REG      (*(volatile uint32_t *)(ETH_BASE + 0x04))
#define ETH_TX_LEN_REG      (*(volatile uint32_t *)(ETH_BASE + 0x08))
#define ETH_RX_LEN_REG      (*(volatile uint32_t *)(ETH_BASE + 0x0C))
#define ETH_MAC_LO_REG      (*(volatile uint32_t *)(ETH_BASE + 0x10))
#define ETH_MAC_HI_REG      (*(volatile uint32_t *)(ETH_BASE + 0x14))
#define ETH_TX_CNT_REG      (*(volatile uint32_t *)(ETH_BASE + 0x18))
#define ETH_RX_CNT_REG      (*(volatile uint32_t *)(ETH_BASE + 0x1C))

#define ETH_TX_BUF          ((volatile uint32_t *)(ETH_BASE + 0x80))
#define ETH_RX_BUF          ((volatile uint32_t *)(ETH_BASE + 0x800))

#define ETH_CTRL_TX_START   (1 << 0)
#define ETH_CTRL_RX_ACK     (1 << 1)
#define ETH_CTRL_PROMISC    (1 << 2)

#define ETH_STAT_TX_BUSY    (1 << 0)
#define ETH_STAT_RX_READY   (1 << 1)
#define ETH_STAT_LINK_UP    (1 << 2)

// Network Configuration
static const uint8_t MY_MAC[6] = {0x00, 0x12, 0x34, 0x56, 0x78, 0x9A};
static const uint8_t MY_IP[4]  = {192, 168, 1, 50};

// Local Packet Buffers
static uint8_t rx_frame[1536];
static uint8_t tx_frame[1536];

// =============================================================================
// Local helpers
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
// RTL8211F-CG PHY Initialisation via MDIO (100M Full Duplex Mode)
// =============================================================================
static void phy_init_100m(void) {
    const uint8_t phy = 0x01;

    println_s("=PHY INIT (100M)=");

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
    //   bit 8 = TXDLY (2 ns TX delay in PHY)
    //   bit 3 = RXDLY (2 ns RX delay in PHY)
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
    print_s("REG="); print_hex16_s(rb); println_s("");

    // -----------------------------------------------------------------
    // Disable Green Ethernet
    // -----------------------------------------------------------------
    mdio_write(phy, 0x1F, 0x0a43);
    mdio_write(phy, 0x1B, 0x8011);
    mdio_write(phy, 0x1C, 0x573F);
    mdio_write(phy, 0x1F, 0x0000);

    // -----------------------------------------------------------------
    // Configure Auto-Negotiation for 100M Full Duplex ONLY
    // -----------------------------------------------------------------
    println_s("Configuring 100M Full Duplex...");
    // Register 9 (GBCR): DISABLE 1000BASE-T advertisement completely!
    mdio_write(phy, PHY_REG_GBCR, 0x0000);

    // Register 4 (ANAR): Advertise 100M FD, 100M HD, 10M FD, 10M HD
    mdio_write(phy, PHY_REG_ANAR, 0x01E1);

    // Register 0 (BMCR): Restart Auto-Negotiation
    mdio_write(phy, PHY_REG_BMCR, 0x1200);

    // Wait up to 6 s for link
    int linked = 0;
    for (int i = 0; i < 60; i++) {
        bsp_uDelay(100000); // 100 ms
        mdio_read(phy, PHY_REG_BMSR);
        uint16_t bmsr = mdio_read(phy, PHY_REG_BMSR);
        if ((bmsr & 0x0004) && (bmsr & 0x0020)) {
            linked = 1;
            break;
        }
        print_s("."); uart_drain();
    }
    println_s("");

    // Report result
    mdio_read(phy, PHY_REG_BMSR);
    uint16_t bmsr = mdio_read(phy, PHY_REG_BMSR);

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

    if (linked && spd == 1) {
        println_s("** 100M FULL DUPLEX LINK UP! **");
    } else {
        println_s("NOTE: Negotiation in progress or link changing...");
    }
}

// =============================================================================
// Ethernet Frame Transmission
// =============================================================================
static void eth_send_frame(const uint8_t *frame, uint16_t len) {
    if (len < 60) len = 60;   // Hardware padding min frame length
    if (len > 1514) len = 1514;

    // Wait until TX engine is ready (not busy)
    while (ETH_STATUS_REG & ETH_STAT_TX_BUSY) {}

    // Copy bytes to word-aligned TX buffer (little-endian byte packing)
    uint32_t words = (len + 3) / 4;
    const uint32_t *src = (const uint32_t *)frame;
    for (uint32_t i = 0; i < words; i++) {
        ETH_TX_BUF[i] = src[i];
    }

    // Set frame length and trigger start
    ETH_TX_LEN_REG = len;
    ETH_CTRL_REG = ETH_CTRL_TX_START;
}

// =============================================================================
// ARP Packet Handler
// =============================================================================
static void handle_arp(const uint8_t *in, uint16_t len) {
    if (len < 42) return;

    // Hardware type: Ethernet (0x0001), Protocol: IPv4 (0x0800)
    if (in[14] != 0x00 || in[15] != 0x01) return;
    if (in[16] != 0x08 || in[17] != 0x00) return;

    // Opcode: ARP Request (0x0001)
    if (in[20] != 0x00 || in[21] != 0x01) return;

    // Target IP matches MY_IP?
    if (memcmp(&in[38], MY_IP, 4) != 0) return;

    // Construct ARP Reply (42 bytes)
    // Ethernet Header
    memcpy(&tx_frame[0], &in[22], 6);     // Destination MAC = Sender MAC
    memcpy(&tx_frame[6], MY_MAC, 6);       // Source MAC = Our MAC
    tx_frame[12] = 0x08;                   // EtherType = ARP (0x0806)
    tx_frame[13] = 0x06;

    // ARP Payload
    tx_frame[14] = 0x00; tx_frame[15] = 0x01; // HW type = Ethernet
    tx_frame[16] = 0x08; tx_frame[17] = 0x00; // Proto = IPv4
    tx_frame[18] = 0x06;                      // HW size = 6
    tx_frame[19] = 0x04;                      // Proto size = 4
    tx_frame[20] = 0x00; tx_frame[21] = 0x02; // Opcode = ARP Reply (2)
    memcpy(&tx_frame[22], MY_MAC, 6);         // Sender MAC
    memcpy(&tx_frame[28], MY_IP, 4);          // Sender IP
    memcpy(&tx_frame[32], &in[22], 6);        // Target MAC = Request Sender MAC
    memcpy(&tx_frame[38], &in[28], 4);        // Target IP = Request Sender IP

    // Send reply (hardware pads to 60 bytes)
    eth_send_frame(tx_frame, 42);

    println_s("[ETH] ARP Reply Sent");
    led_pulse(50);
}

// =============================================================================
// IPv4 / ICMP Echo (Ping) Handler
// =============================================================================
static void handle_ipv4(const uint8_t *in, uint16_t len) {
    if (len < 34) return;

    // Check IPv4 Version and Header Length
    if ((in[14] >> 4) != 4) return;
    uint8_t ihl = (in[14] & 0x0F) * 4;
    if (ihl < 20 || (14 + ihl) > len) return;

    // Check Destination IP matches MY_IP
    if (memcmp(&in[30], MY_IP, 4) != 0) return;

    // Protocol: ICMP (1)
    if (in[23] == 0x01) {
        uint16_t icmp_offset = 14 + ihl;
        if (len < icmp_offset + 8) return;

        // ICMP Type: Echo Request (8), Code: 0
        if (in[icmp_offset] == 0x08 && in[icmp_offset + 1] == 0x00) {
            // Echo Reply: reuse incoming frame with swapped addresses
            memcpy(tx_frame, in, len);

            // Swap MACs
            memcpy(&tx_frame[0], &in[6], 6);
            memcpy(&tx_frame[6], MY_MAC, 6);

            // Swap IPs
            memcpy(&tx_frame[26], MY_IP, 4);
            memcpy(&tx_frame[30], &in[26], 4);

            // Recalculate IPv4 Checksum
            tx_frame[24] = 0;
            tx_frame[25] = 0;
            uint32_t ip_cs = 0;
            for (int i = 0; i < ihl; i += 2) {
                ip_cs += ((uint32_t)tx_frame[14 + i] << 8) | tx_frame[14 + i + 1];
            }
            while (ip_cs >> 16) {
                ip_cs = (ip_cs & 0xFFFF) + (ip_cs >> 16);
            }
            ip_cs = ~ip_cs & 0xFFFF;
            tx_frame[24] = (ip_cs >> 8) & 0xFF;
            tx_frame[25] = ip_cs & 0xFF;

            // Change ICMP Type to Echo Reply (0)
            tx_frame[icmp_offset] = 0x00;

            // Adjust ICMP Checksum (subtract 8 from type = add 0x0800 to 1's complement)
            uint32_t icmp_cs = ((uint32_t)tx_frame[icmp_offset + 2] << 8) | tx_frame[icmp_offset + 3];
            icmp_cs += 0x0800;
            if (icmp_cs > 0xFFFF) {
                icmp_cs = (icmp_cs & 0xFFFF) + 1;
            }
            tx_frame[icmp_offset + 2] = (icmp_cs >> 8) & 0xFF;
            tx_frame[icmp_offset + 3] = icmp_cs & 0xFF;

            // Send Echo Reply
            eth_send_frame(tx_frame, len);

            println_s("[ETH] ICMP Ping Reply Sent");
            led_pulse(50);
        }
    }
}

// =============================================================================
// Ethernet RX Poll & Dispatch
// =============================================================================
static void eth_poll(void) {
    if (ETH_STATUS_REG & ETH_STAT_RX_READY) {
        uint16_t rx_len = (uint16_t)ETH_RX_LEN_REG;
        if (rx_len >= 14 && rx_len <= 1514) {
            uint32_t words = (rx_len + 3) / 4;
            uint32_t *dst = (uint32_t *)rx_frame;
            for (uint32_t i = 0; i < words; i++) {
                dst[i] = ETH_RX_BUF[i];
            }

            // Release hardware buffer
            ETH_CTRL_REG = ETH_CTRL_RX_ACK;

            // Dispatch packet based on EtherType
            uint16_t ethertype = ((uint16_t)rx_frame[12] << 8) | rx_frame[13];
            if (ethertype == 0x0806) {
                handle_arp(rx_frame, rx_len);
            } else if (ethertype == 0x0800) {
                handle_ipv4(rx_frame, rx_len);
            }
        } else {
            // Bad frame, just acknowledge
            ETH_CTRL_REG = ETH_CTRL_RX_ACK;
        }
    }
}

// =============================================================================
// Main
// =============================================================================
void main(void) {
    bsp_init();

    // bit 0 = LED, bit 1 = CAM2_EN
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, 0x3);
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2);  // LED off, CAM2_EN HIGH

    for (int i = 0; i < 3; i++) led_pulse(150);

    println_s("================================");
    println_s("= T120F324 100M Ethernet + Ping=");
    println_s("= IP:  192.168.1.50            =");
    println_s("= MAC: 00:12:34:56:78:9A       =");
    println_s("================================");

    // Initialize MAC address registers
    ETH_MAC_LO_REG = 0x56789A;
    ETH_MAC_HI_REG = 0x001234;

    // RTL8211F PHY setup via MDIO (100M Full Duplex) FIRST
    phy_init_100m();

    println_s("Ethernet ready. Listening for ARP / Ping...");

    uint32_t loop_cnt = 0;
    while (1) {
        // Poll for incoming Ethernet packets
        eth_poll();

        // Slow LED heartbeat
        loop_cnt++;
        if ((loop_cnt % 200000) == 0) {
            led_on();
        } else if ((loop_cnt % 200000) == 100000) {
            led_off();
        }
    }
}

void trap(void) {
    while (1) { led_on(); bsp_uDelay(100000); led_off(); bsp_uDelay(100000); }
}
