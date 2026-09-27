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
extern void camera_init(void);

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

// =============================================================================
// Video Line Bridge Peripheral Registers (at 0xf8104000)
// =============================================================================
#define VID_BRIDGE_BASE       0xf8104000
#define VID_STATUS_REG        (*(volatile uint32_t *)(VID_BRIDGE_BASE + 0x00))
#define VID_TARGET_LINE_REG   (*(volatile uint32_t *)(VID_BRIDGE_BASE + 0x04))
#define VID_LIVE_STATUS_REG   (*(volatile uint32_t *)(VID_BRIDGE_BASE + 0x08))
#define VID_DIAG_REG          (*(volatile uint32_t *)(VID_BRIDGE_BASE + 0x0C))
#define VID_LINE_BUF          ((volatile uint32_t *)(VID_BRIDGE_BASE + 0x100))

#define VID_CTRL_REQ_SAMPLE   (1 << 0)
#define VID_STAT_LINE_READY   (1 << 1)
#define VID_CTRL_CLEAR_READY  (1 << 2)

// =============================================================================
// SPI Flash Master Peripheral Registers (at 0xf8103000)
// =============================================================================
#define SPI_FLASH_BASE      0xf8103000
#define SPI_DATA_REG        (*(volatile uint32_t *)(SPI_FLASH_BASE + 0x00))
#define SPI_STATUS_CTRL_REG (*(volatile uint32_t *)(SPI_FLASH_BASE + 0x04))
#define SPI_RECONFIG_REG    (*(volatile uint32_t *)(SPI_FLASH_BASE + 0x08))

#define SPI_STATUS_BUSY     (1 << 0)
#define SPI_CTRL_CS_N       (1 << 1)
#define SPI_CTRL_WP_N       (1 << 2)
#define SPI_CTRL_HOLD_N     (1 << 3)
#define SPI_CTRL_DIV(d)     (((d) & 0xFF) << 8)

static inline void spi_flash_cs_low(void) {
    SPI_STATUS_CTRL_REG = SPI_CTRL_WP_N | SPI_CTRL_HOLD_N | SPI_CTRL_DIV(2);
}

static inline void spi_flash_cs_high(void) {
    SPI_STATUS_CTRL_REG = SPI_CTRL_CS_N | SPI_CTRL_WP_N | SPI_CTRL_HOLD_N | SPI_CTRL_DIV(2);
}

static inline uint8_t spi_flash_transfer(uint8_t byte) {
    while (SPI_STATUS_CTRL_REG & SPI_STATUS_BUSY) {}
    SPI_DATA_REG = byte;
    while (SPI_STATUS_CTRL_REG & SPI_STATUS_BUSY) {}
    return (uint8_t)(SPI_DATA_REG & 0xFF);
}

static inline void spi_flash_write_enable(void) {
    spi_flash_cs_low();
    spi_flash_transfer(0x06); // WREN
    spi_flash_cs_high();
}

static inline uint8_t spi_flash_read_status(void) {
    spi_flash_cs_low();
    spi_flash_transfer(0x05); // RDSR
    uint8_t s = spi_flash_transfer(0xFF);
    spi_flash_cs_high();
    return s;
}

static inline void spi_flash_wait_busy(void) {
    while (spi_flash_read_status() & 0x01) {
        bsp_uDelay(100);
    }
}

static inline uint32_t spi_flash_read_jedec_id(void) {
    spi_flash_cs_low();
    spi_flash_transfer(0x9F); // JEDEC ID
    uint32_t id = 0;
    id |= ((uint32_t)spi_flash_transfer(0xFF)) << 16;
    id |= ((uint32_t)spi_flash_transfer(0xFF)) << 8;
    id |= ((uint32_t)spi_flash_transfer(0xFF));
    spi_flash_cs_high();
    return id;
}

static inline void spi_flash_sector_erase(uint32_t addr) {
    spi_flash_write_enable();
    spi_flash_cs_low();
    spi_flash_transfer(0x20); // Sector Erase (4KB)
    spi_flash_transfer((addr >> 16) & 0xFF);
    spi_flash_transfer((addr >> 8) & 0xFF);
    spi_flash_transfer(addr & 0xFF);
    spi_flash_cs_high();
    spi_flash_wait_busy();
}

static inline void spi_flash_block64k_erase(uint32_t addr) {
    spi_flash_write_enable();
    spi_flash_cs_low();
    spi_flash_transfer(0xD8); // Block Erase (64KB)
    spi_flash_transfer((addr >> 16) & 0xFF);
    spi_flash_transfer((addr >> 8) & 0xFF);
    spi_flash_transfer(addr & 0xFF);
    spi_flash_cs_high();
    spi_flash_wait_busy();
}

static inline void spi_flash_page_program(uint32_t addr, const uint8_t *data, uint16_t len) {
    spi_flash_write_enable();
    spi_flash_cs_low();
    spi_flash_transfer(0x02); // Page Program
    spi_flash_transfer((addr >> 16) & 0xFF);
    spi_flash_transfer((addr >> 8) & 0xFF);
    spi_flash_transfer(addr & 0xFF);
    for (uint16_t i = 0; i < len; i++) {
        spi_flash_transfer(data[i]);
    }
    spi_flash_cs_high();
    spi_flash_wait_busy();
}

static inline void spi_flash_read_data(uint32_t addr, uint8_t *data, uint16_t len) {
    spi_flash_cs_low();
    spi_flash_transfer(0x03); // Read Data
    spi_flash_transfer((addr >> 16) & 0xFF);
    spi_flash_transfer((addr >> 8) & 0xFF);
    spi_flash_transfer(addr & 0xFF);
    for (uint16_t i = 0; i < len; i++) {
        data[i] = spi_flash_transfer(0xFF);
    }
    spi_flash_cs_high();
}

// Network Configuration
static const uint8_t MY_MAC[6] = {0x00, 0x12, 0x34, 0x56, 0x78, 0x9A};
static const uint8_t MY_IP[4]  = {192, 168, 1, 50};

// Local Packet Buffers
static uint8_t rx_frame[1536];
static uint8_t tx_frame[1536];

static void eth_send_frame(const uint8_t *frame, uint16_t len);

// Video Streaming State
static uint8_t  video_stream_active = 0;
static uint8_t  video_dest_mac[6]   = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
static uint8_t  video_dest_ip[4]    = {192, 168, 1, 129};
static uint16_t video_dest_port     = 5001;
static uint16_t video_cur_line      = 0;
static uint8_t  video_waiting_line  = 0;

static void video_send_current_line(void) {
    if (!video_stream_active) return;

    if (!video_waiting_line) {
        VID_TARGET_LINE_REG = video_cur_line;
        VID_STATUS_REG = VID_CTRL_REQ_SAMPLE;
        video_waiting_line = 1;
    } else {
        uint32_t status = VID_STATUS_REG;
        if (status & VID_STAT_LINE_READY) {
            uint16_t frame_seq = (status >> 16) & 0xFFFF;
            uint16_t line_num  = video_cur_line;

            memcpy(&tx_frame[0], video_dest_mac, 6);
            memcpy(&tx_frame[6], MY_MAC, 6);
            tx_frame[12] = 0x08; tx_frame[13] = 0x00;

            uint16_t payload_len = 8 + 224;
            uint16_t udp_len     = 8 + payload_len;
            uint16_t ip_len      = 20 + udp_len;

            tx_frame[14] = 0x45; tx_frame[15] = 0x00;
            tx_frame[16] = (ip_len >> 8) & 0xFF;
            tx_frame[17] = ip_len & 0xFF;
            tx_frame[18] = 0x00; tx_frame[19] = 0x00;
            tx_frame[20] = 0x40; tx_frame[21] = 0x00;
            tx_frame[22] = 64;
            tx_frame[23] = 17;
            tx_frame[24] = 0;    tx_frame[25] = 0;
            memcpy(&tx_frame[26], MY_IP, 4);
            memcpy(&tx_frame[30], video_dest_ip, 4);

            uint32_t ip_cs = 0;
            for (int i = 0; i < 20; i += 2) {
                ip_cs += ((uint32_t)tx_frame[14 + i] << 8) | tx_frame[14 + i + 1];
            }
            while (ip_cs >> 16) {
                ip_cs = (ip_cs & 0xFFFF) + (ip_cs >> 16);
            }
            ip_cs = ~ip_cs & 0xFFFF;
            tx_frame[24] = (ip_cs >> 8) & 0xFF;
            tx_frame[25] = ip_cs & 0xFF;

            tx_frame[34] = 0x13; tx_frame[35] = 0x89;
            tx_frame[36] = (video_dest_port >> 8) & 0xFF;
            tx_frame[37] = video_dest_port & 0xFF;
            tx_frame[38] = (udp_len >> 8) & 0xFF;
            tx_frame[39] = udp_len & 0xFF;
            tx_frame[40] = 0x00; tx_frame[41] = 0x00;

            uint8_t *vhdr = &tx_frame[42];
            vhdr[0] = 'V'; vhdr[1] = 'I';
            vhdr[2] = (frame_seq >> 8) & 0xFF;
            vhdr[3] = frame_seq & 0xFF;
            vhdr[4] = (line_num >> 8) & 0xFF;
            vhdr[5] = line_num & 0xFF;
            vhdr[6] = 224;
            vhdr[7] = 224;

            uint8_t *dst_bytes = &tx_frame[50];
            for (int w = 0; w < 56; w++) {
                uint32_t val = VID_LINE_BUF[w];
                dst_bytes[w * 4 + 0] = val & 0xFF;
                dst_bytes[w * 4 + 1] = (val >> 8) & 0xFF;
                dst_bytes[w * 4 + 2] = (val >> 16) & 0xFF;
                dst_bytes[w * 4 + 3] = (val >> 24) & 0xFF;
            }

            eth_send_frame(tx_frame, 14 + ip_len);

            VID_STATUS_REG = VID_CTRL_CLEAR_READY;
            video_waiting_line = 0;

            video_cur_line++;
            if (video_cur_line >= 224) {
                video_cur_line = 0;
            }
        }
    }
}

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

            println_s("[ETH] ICMP Ping Reply Sent [*333*] ");
            led_pulse(50);
        }
    }
    // Protocol: UDP (17 / 0x11)
    else if (in[23] == 0x11) {
        uint16_t udp_offset = 14 + ihl;
        if (len < udp_offset + 8) return;

        uint16_t src_port = ((uint16_t)in[udp_offset] << 8) | in[udp_offset + 1];
        uint16_t dst_port = ((uint16_t)in[udp_offset + 2] << 8) | in[udp_offset + 3];
        uint16_t udp_len  = ((uint16_t)in[udp_offset + 4] << 8) | in[udp_offset + 5];

        // Flash Server Port: 5000 (0x1388)
        if (dst_port == 5000 && udp_len >= 8) {
            const uint8_t *payload = &in[udp_offset + 8];
            uint16_t payload_len = udp_len - 8;

            // Prepare base response UDP packet
            memcpy(tx_frame, in, udp_offset + 8);
            // Swap MACs
            memcpy(&tx_frame[0], &in[6], 6);
            memcpy(&tx_frame[6], MY_MAC, 6);
            // Swap IPs
            memcpy(&tx_frame[26], MY_IP, 4);
            memcpy(&tx_frame[30], &in[26], 4);
            // Swap UDP Ports
            tx_frame[udp_offset]     = in[udp_offset + 2];
            tx_frame[udp_offset + 1] = in[udp_offset + 3];
            tx_frame[udp_offset + 2] = in[udp_offset];
            tx_frame[udp_offset + 3] = in[udp_offset + 1];

            uint8_t *resp_payload = &tx_frame[udp_offset + 8];
            uint16_t resp_payload_len = 0;

            if (payload_len >= 1) {
                uint8_t cmd = payload[0];
                resp_payload[0] = cmd; // Echo command
                resp_payload[1] = 0x00; // Status OK

                switch (cmd) {
                    case 0x01: { // PING / JEDEC ID READ
                        uint32_t id = spi_flash_read_jedec_id();
                        resp_payload[2] = (id >> 16) & 0xFF; // Manufacturer (Winbond: 0xEF)
                        resp_payload[3] = (id >> 8)  & 0xFF; // Memory type (0x40)
                        resp_payload[4] = id & 0xFF;         // Capacity (0x18 for 128Mb)
                        resp_payload_len = 5;
                        break;
                    }

                    case 0x02: { // SECTOR ERASE (4KB) [cmd(1), addr(4)]
                        if (payload_len >= 5) {
                            uint32_t addr = ((uint32_t)payload[1] << 24) |
                                            ((uint32_t)payload[2] << 16) |
                                            ((uint32_t)payload[3] << 8)  |
                                            ((uint32_t)payload[4]);
                            spi_flash_sector_erase(addr);
                            resp_payload_len = 2;
                        } else {
                            resp_payload[1] = 0x01; // Error
                            resp_payload_len = 2;
                        }
                        break;
                    }

                    case 0x03: { // BLOCK 64KB ERASE [cmd(1), addr(4)]
                        if (payload_len >= 5) {
                            uint32_t addr = ((uint32_t)payload[1] << 24) |
                                            ((uint32_t)payload[2] << 16) |
                                            ((uint32_t)payload[3] << 8)  |
                                            ((uint32_t)payload[4]);
                            spi_flash_block64k_erase(addr);
                            resp_payload_len = 2;
                        } else {
                            resp_payload[1] = 0x01; // Error
                            resp_payload_len = 2;
                        }
                        break;
                    }

                    case 0x04: { // PAGE WRITE (up to 256 bytes) [cmd(1), addr(4), len(2), data(N)]
                        if (payload_len >= 7) {
                            uint32_t addr = ((uint32_t)payload[1] << 24) |
                                            ((uint32_t)payload[2] << 16) |
                                            ((uint32_t)payload[3] << 8)  |
                                            ((uint32_t)payload[4]);
                            uint16_t wlen = ((uint16_t)payload[5] << 8) | payload[6];
                            if (wlen <= 256 && (7 + wlen) <= payload_len) {
                                spi_flash_page_program(addr, &payload[7], wlen);
                                resp_payload_len = 2;
                            } else {
                                resp_payload[1] = 0x01;
                                resp_payload_len = 2;
                            }
                        } else {
                            resp_payload[1] = 0x01;
                            resp_payload_len = 2;
                        }
                        break;
                    }

                    case 0x05: { // READ DATA [cmd(1), addr(4), len(2)]
                        if (payload_len >= 7) {
                            uint32_t addr = ((uint32_t)payload[1] << 24) |
                                            ((uint32_t)payload[2] << 16) |
                                            ((uint32_t)payload[3] << 8)  |
                                            ((uint32_t)payload[4]);
                            uint16_t rlen = ((uint16_t)payload[5] << 8) | payload[6];
                            if (rlen <= 512) {
                                spi_flash_read_data(addr, &resp_payload[2], rlen);
                                resp_payload_len = 2 + rlen;
                            } else {
                                resp_payload[1] = 0x01;
                                resp_payload_len = 2;
                            }
                        } else {
                            resp_payload[1] = 0x01;
                            resp_payload_len = 2;
                        }
                        break;
                    }

                    case 0x10: { // VIDEO BRIDGE DIAGNOSTIC READ
                        // Reads 16 bytes: VID_STATUS, VID_TARGET_LINE, VID_LIVE_STATUS, VID_DIAG
                        uint32_t s0 = VID_STATUS_REG;
                        uint32_t s1 = VID_TARGET_LINE_REG;
                        uint32_t s2 = VID_LIVE_STATUS_REG;
                        uint32_t s3 = VID_DIAG_REG;
                        resp_payload[2] = (s0 >> 24) & 0xFF; resp_payload[3] = (s0 >> 16) & 0xFF; resp_payload[4] = (s0 >> 8) & 0xFF; resp_payload[5] = s0 & 0xFF;
                        resp_payload[6] = (s1 >> 24) & 0xFF; resp_payload[7] = (s1 >> 16) & 0xFF; resp_payload[8] = (s1 >> 8) & 0xFF; resp_payload[9] = s1 & 0xFF;
                        resp_payload[10] = (s2 >> 24) & 0xFF; resp_payload[11] = (s2 >> 16) & 0xFF; resp_payload[12] = (s2 >> 8) & 0xFF; resp_payload[13] = s2 & 0xFF;
                        resp_payload[14] = (s3 >> 24) & 0xFF; resp_payload[15] = (s3 >> 16) & 0xFF; resp_payload[16] = (s3 >> 8) & 0xFF; resp_payload[17] = s3 & 0xFF;
                        resp_payload_len = 18;
                        break;
                    }

                    case 0x11: { // VIDEO BRIDGE TRIGGER SAMPLE [line(2)]
                        if (payload_len >= 3) {
                            uint16_t line = ((uint16_t)payload[1] << 8) | payload[2];
                            VID_TARGET_LINE_REG = line;
                            VID_STATUS_REG = VID_CTRL_REQ_SAMPLE;
                        }
                        resp_payload_len = 2;
                        break;
                    }

                    default:
                        resp_payload[1] = 0xFF; // Unknown command
                        resp_payload_len = 2;
                        break;
                }
            }

            // Fill UDP & IP length
            uint16_t resp_udp_len = 8 + resp_payload_len;
            tx_frame[udp_offset + 4] = (resp_udp_len >> 8) & 0xFF;
            tx_frame[udp_offset + 5] = resp_udp_len & 0xFF;
            tx_frame[udp_offset + 6] = 0x00; // Checksum disabled for UDP
            tx_frame[udp_offset + 7] = 0x00;

            uint16_t resp_ip_len = ihl + resp_udp_len;
            tx_frame[16] = (resp_ip_len >> 8) & 0xFF;
            tx_frame[17] = resp_ip_len & 0xFF;

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

            // Transmit response UDP packet
            eth_send_frame(tx_frame, 14 + resp_ip_len);
        }
        // Video Streamer Port: 5001 (0x1389)
        else if (dst_port == 5001 && udp_len >= 8) {
            const uint8_t *payload = &in[udp_offset + 8];
            uint16_t payload_len = udp_len - 8;

            if (payload_len >= 1) {
                uint8_t cmd = payload[0];
                if (cmd == 0x01) { // START STREAM
                    video_stream_active = 1;
                    memcpy(video_dest_mac, &in[6], 6);
                    memcpy(video_dest_ip,  &in[26], 4);
                    video_dest_port = src_port;
                    video_cur_line = 0;
                    video_waiting_line = 0;
                    println_s("[VID] UDP Video Stream Started!");
                } else if (cmd == 0x02) { // STOP STREAM
                    video_stream_active = 0;
                    println_s("[VID] UDP Video Stream Stopped");
                }
            }
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

    // Initialize SPI Flash Master
    spi_flash_cs_high();
    bsp_uDelay(1000);
    uint32_t flash_id = spi_flash_read_jedec_id();
    print_s("SPI Flash JEDEC ID: 0x");
    print_hex16_s((flash_id >> 8) & 0xFFFF);
    print_hex16_s(flash_id & 0xFF);
    println_s("");

    println_s("Ethernet ready. Listening for ARP / Ping / UDP Flash...");

    // Initialize Camera (CAM2 IMX219 via I2C)
    println_s("Initializing camera (CAM2 IMX219)...");
    camera_init();
    println_s("Camera initialization complete!");

    uint32_t loop_cnt = 0;
    while (1) {
        // Poll for incoming Ethernet packets
        eth_poll();

        // Stream video line if active
        video_send_current_line();

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
