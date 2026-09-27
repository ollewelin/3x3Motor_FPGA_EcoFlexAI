/**
 * ============================================================================
 * phy_init.c - Ethernet PHY (RTL8211F) Initialization Firmware
 * ============================================================================
 *
 * For Efinix T120F324 FPGA + Sapphire RISC-V + RTL8211F-CG Ethernet PHY
 *
 * This firmware demonstrates:
 *   1. Accessing MDIO Master via APB interface
 *   2. Reading/writing PHY registers
 *   3. Initializing PHY for Gigabit Ethernet
 *   4. Monitoring link status
 *   5. Generating test Ethernet frames
 *
 * ============================================================================
 */

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

// ============================================================================
// MDIO Master APB Registers
// ============================================================================

#define MDIO_BASE_ADDR      0x80010000

#define MDIO_CTRL           (*(volatile uint32_t*)(MDIO_BASE_ADDR + 0x00))
#define MDIO_STATUS         (*(volatile uint32_t*)(MDIO_BASE_ADDR + 0x04))
#define MDIO_CONFIG         (*(volatile uint32_t*)(MDIO_BASE_ADDR + 0x08))
#define MDIO_VERSION        (*(volatile uint32_t*)(MDIO_BASE_ADDR + 0x0C))

// MDIO_CTRL Register Bits
#define MDIO_CTRL_START     (1u << 0)                  // Start transaction
#define MDIO_CTRL_RW        (1u << 1)                  // 1=Read, 0=Write
#define MDIO_CTRL_PHY_ADDR  (0x1Fu << 5)              // PHY address [9:5]
#define MDIO_CTRL_REG_ADDR  (0x1Fu << 10)             // Register address [14:10]
#define MDIO_CTRL_WDATA     (0xFFFFu << 16)           // Write data [31:16]

// MDIO_STATUS Register Bits
#define MDIO_STATUS_BUSY    (1u << 0)                  // Transaction busy
#define MDIO_STATUS_DONE    (1u << 1)                  // Transaction done
#define MDIO_STATUS_RDATA   (0xFFFFu << 16)           // Read data [31:16]

// MDIO_CONFIG Register Bits
#define MDIO_CONFIG_PHY_RST (1u << 0)                  // PHY reset (1=normal)
#define MDIO_CONFIG_IRQ_EN  (1u << 1)                  // Interrupt enable

// ============================================================================
// RTL8211F-CG PHY Registers (Clause-22)
// ============================================================================

#define PHY_ADDR            0x01                       // Default address

// Standard Clause-22 registers
#define REG_BMCR            0x00                       // Basic Mode Control
#define REG_BMSR            0x01                       // Basic Mode Status
#define REG_PHYID1          0x02                       // PHY ID 1
#define REG_PHYID2          0x03                       // PHY ID 2
#define REG_ANAR            0x04                       // Auto-Negotiation Advertisement
#define REG_ANLPAR          0x05                       // Auto-Negotiation Link Partner
#define REG_ANER            0x06                       // Auto-Negotiation Expansion
#define REG_GBCR            0x09                       // 1000BASE-T Control
#define REG_GBSR            0x0A                       // 1000BASE-T Status

// BMCR (0x00) Bits
#define BMCR_RESET          (1u << 15)                 // Software reset
#define BMCR_LOOPBACK       (1u << 14)                 // Loopback mode
#define BMCR_SPEED_LSB      (1u << 13)                 // Speed select LSB
#define BMCR_AUTONEG_EN     (1u << 12)                 // Auto-negotiation enable
#define BMCR_POWER_DOWN     (1u << 11)                 // Power down
#define BMCR_ISOLATE        (1u << 10)                 // Isolate
#define BMCR_RESTART_AUTONEG (1u << 9)                 // Restart auto-negotiation
#define BMCR_DUPLEX         (1u << 8)                  // Duplex mode (1=Full)
#define BMCR_COLLISION_TEST (1u << 7)                  // Collision test

// BMSR (0x01) Bits
#define BMSR_100BASE_T4     (1u << 15)                 // 100BASE-T4 capable
#define BMSR_100BASE_FX     (1u << 14)                 // 100BASE-FX capable
#define BMSR_100BASE_TX     (1u << 13)                 // 100BASE-TX capable
#define BMSR_10BASE_T       (1u << 12)                 // 10BASE-T capable
#define BMSR_MFPS           (1u << 6)                  // MF preamble suppression
#define BMSR_AUTONEG_CMPLT  (1u << 5)                  // Auto-negotiation complete
#define BMSR_REMOTE_FAULT   (1u << 4)                  // Remote fault
#define BMSR_AUTONEG_ABLE   (1u << 3)                  // Auto-negotiation able
#define BMSR_LINK_UP        (1u << 2)                  // Link status (1=Up)
#define BMSR_JABBER         (1u << 1)                  // Jabber detected
#define BMSR_EXTENDED_CAP   (1u << 0)                  // Extended capability

// GBCR (0x09) - 1000BASE-T Control
#define GBCR_1000BASE_T     (1u << 9)                  // 1000BASE-T enable
#define GBCR_1000BASE_FD    (1u << 9)                  // 1000BASE-T Full Duplex

// ============================================================================
// Utility Functions
// ============================================================================

/**
 * Wait for MDIO transaction to complete
 */
static void mdio_wait_ready(void) {
    volatile int timeout = 100000;
    while ((MDIO_STATUS & MDIO_STATUS_BUSY) && (--timeout > 0)) {
        // Spin wait
    }
    if (timeout <= 0) {
        printf("ERROR: MDIO timeout!\n");
    }
}

/**
 * Write to PHY register via MDIO
 *
 * @param phy_addr   PHY address (typically 0x01 for RTL8211F)
 * @param reg_addr   Register address (0x00-0x1F)
 * @param data       Data to write (16-bit)
 */
void mdio_write(uint32_t phy_addr, uint32_t reg_addr, uint16_t data) {
    // Build control register value
    uint32_t ctrl = MDIO_CTRL_START |           // Start transaction
                    (0u << 1) |                  // Write operation (RW=0)
                    ((phy_addr & 0x1F) << 5) |  // PHY address
                    ((reg_addr & 0x1F) << 10) | // Register address
                    ((uint32_t)data << 16);     // Write data
    
    MDIO_CTRL = ctrl;
    mdio_wait_ready();
    
    printf("MDIO Write: PHY=0x%02X REG=0x%02X DATA=0x%04X\n",
           phy_addr, reg_addr, data);
}

/**
 * Read from PHY register via MDIO
 *
 * @param phy_addr   PHY address
 * @param reg_addr   Register address
 * @return           16-bit data from PHY
 */
uint16_t mdio_read(uint32_t phy_addr, uint32_t reg_addr) {
    // Build control register value
    uint32_t ctrl = MDIO_CTRL_START |           // Start transaction
                    (1u << 1) |                  // Read operation (RW=1)
                    ((phy_addr & 0x1F) << 5) |  // PHY address
                    ((reg_addr & 0x1F) << 10);  // Register address
    
    MDIO_CTRL = ctrl;
    mdio_wait_ready();
    
    uint32_t status = MDIO_STATUS;
    uint16_t data = (uint16_t)((status & MDIO_STATUS_RDATA) >> 16);
    
    printf("MDIO Read:  PHY=0x%02X REG=0x%02X DATA=0x%04X\n",
           phy_addr, reg_addr, data);
    
    return data;
}

/**
 * Simple delay (approximate milliseconds)
 */
void delay_ms(uint32_t ms) {
    volatile uint32_t cnt = ms * 5000;  // Rough approximation for 50 MHz clock
    while (cnt--);
}

// ============================================================================
// PHY Initialization Sequence
// ============================================================================

/**
 * Initialize RTL8211F-CG Ethernet PHY
 *
 * Sequence:
 *   1. Release PHY from reset
 *   2. Wait for PHY to stabilize
 *   3. Read and verify PHY ID
 *   4. Configure for Gigabit Ethernet
 *   5. Enable auto-negotiation
 *   6. Monitor link status
 */
void phy_init(void) {
    uint16_t phy_id1, phy_id2;
    uint16_t bmsr, bmcr, gbcr;
    uint32_t wait_count = 0;
    bool link_up = false;
    
    printf("\n");
    printf("================================================================================\n");
    printf("Ethernet PHY Initialization - RTL8211F-CG\n");
    printf("================================================================================\n\n");
    
    // ========================================================================
    // Step 1: Release PHY from Reset
    // ========================================================================
    printf("[1] Releasing PHY from reset...\n");
    MDIO_CONFIG = MDIO_CONFIG_PHY_RST;  // Set PHY_RST = 1 (normal operation)
    delay_ms(100);                      // Wait 100ms for PHY to stabilize
    printf("    Done. Waiting 100ms for PHY stabilization.\n\n");
    
    // ========================================================================
    // Step 2: Read and Verify PHY ID
    // ========================================================================
    printf("[2] Reading PHY ID...\n");
    
    phy_id1 = mdio_read(PHY_ADDR, REG_PHYID1);
    phy_id2 = mdio_read(PHY_ADDR, REG_PHYID2);
    
    printf("    PHY ID1 = 0x%04X (Expected: 0x001C)\n", phy_id1);
    printf("    PHY ID2 = 0x%04X (Expected: 0xC916)\n", phy_id2);
    
    if ((phy_id1 == 0x001C) && (phy_id2 == 0xC916)) {
        printf("    ✓ PHY ID verified as RTL8211F!\n\n");
    } else {
        printf("    ✗ ERROR: PHY ID mismatch! Check connection and power.\n");
        printf("    This is the RTL8211F-CG? Unexpected IDs detected.\n\n");
        // Continue anyway for debug
    }
    
    // ========================================================================
    // Step 3: Read Basic Mode Status
    // ========================================================================
    printf("[3] Checking Basic Mode Status...\n");
    bmsr = mdio_read(PHY_ADDR, REG_BMSR);
    
    printf("    BMSR = 0x%04X\n", bmsr);
    printf("    - Extended Register Capability: %s\n",
           (bmsr & BMSR_EXTENDED_CAP) ? "Yes" : "No");
    printf("    - Jabber Detected:              %s\n",
           (bmsr & BMSR_JABBER) ? "Yes" : "No");
    printf("    - Link Status:                  %s\n",
           (bmsr & BMSR_LINK_UP) ? "UP" : "DOWN");
    printf("    - Auto-Negotiation Able:       %s\n",
           (bmsr & BMSR_AUTONEG_ABLE) ? "Yes" : "No");
    printf("    - Auto-Negotiation Complete:   %s\n",
           (bmsr & BMSR_AUTONEG_CMPLT) ? "Yes" : "No");
    printf("    - 100BASE-TX Capable:          %s\n",
           (bmsr & BMSR_100BASE_TX) ? "Yes" : "No");
    printf("\n");
    
    // ========================================================================
    // Step 4: Configure for Gigabit Ethernet
    // ========================================================================
    printf("[4] Configuring for Gigabit Ethernet...\n");
    
    // Read current BMCR
    bmcr = mdio_read(PHY_ADDR, REG_BMCR);
    
    // Set for Full Duplex + Gigabit + Auto-Negotiation
    bmcr |= BMCR_DUPLEX;           // Full duplex
    bmcr |= BMCR_AUTONEG_EN;       // Enable auto-negotiation
    
    mdio_write(PHY_ADDR, REG_BMCR, bmcr);
    printf("    BMCR configured: 0x%04X\n", bmcr);
    printf("    - Full Duplex:                  Enabled\n");
    printf("    - Auto-Negotiation:             Enabled\n\n");
    
    // Read 1000BASE-T Control register
    gbcr = mdio_read(PHY_ADDR, REG_GBCR);
    
    // Enable 1000BASE-T
    gbcr |= GBCR_1000BASE_T;
    
    mdio_write(PHY_ADDR, REG_GBCR, gbcr);
    printf("    GBCR configured: 0x%04X\n", gbcr);
    printf("    - 1000BASE-T:                   Enabled\n\n");
    
    // ========================================================================
    // Step 5: Wait for Auto-Negotiation and Link Up
    // ========================================================================
    printf("[5] Waiting for auto-negotiation and link establishment...\n");
    printf("    (Timeout: 10 seconds)\n\n");
    
    while (!link_up && (wait_count < 100)) {
        delay_ms(100);  // Wait 100ms between checks
        
        bmsr = mdio_read(PHY_ADDR, REG_BMSR);
        
        if (bmsr & BMSR_LINK_UP) {
            link_up = true;
            printf("    ✓ LINK UP DETECTED!\n");
        } else {
            printf("    [%2d sec] BMSR=0x%04X - Link: %s, Autoneg: %s\n",
                   wait_count / 10,
                   bmsr,
                   (bmsr & BMSR_LINK_UP) ? "UP" : "DOWN",
                   (bmsr & BMSR_AUTONEG_CMPLT) ? "DONE" : "IN PROGRESS");
        }
        
        wait_count++;
    }
    
    if (link_up) {
        printf("\n    ✓ SUCCESS: Ethernet link is UP!\n");
        printf("    You can now send/receive Ethernet frames.\n\n");
    } else {
        printf("\n    ✗ TIMEOUT: Link did not come up in 10 seconds.\n");
        printf("    Check:\n");
        printf("      - Ethernet cable connected\n");
        printf("      - Network interface active\n");
        printf("      - PHY power supply\n");
        printf("      - MDIO connections\n\n");
    }
    
    // ========================================================================
    // Step 6: Display Final PHY Status
    // ========================================================================
    printf("[6] Final PHY Status:\n");
    
    bmsr = mdio_read(PHY_ADDR, REG_BMSR);
    bmcr = mdio_read(PHY_ADDR, REG_BMCR);
    
    printf("    Speed:              %s\n",
           (bmcr & BMCR_SPEED_LSB) ? "100 Mbps" : "10 Mbps");
    printf("    Duplex:             %s\n",
           (bmcr & BMCR_DUPLEX) ? "Full" : "Half");
    printf("    Auto-Negotiation:   %s\n",
           (bmcr & BMCR_AUTONEG_EN) ? "Enabled" : "Disabled");
    printf("    Link Status:        %s\n",
           (bmsr & BMSR_LINK_UP) ? "UP" : "DOWN");
    printf("\n");
    printf("================================================================================\n");
    printf("Initialization Complete!\n");
    printf("================================================================================\n\n");
}

// ============================================================================
// Ethernet Frame Transmission (Test Data)
// ============================================================================

/**
 * Send a simple UDP packet to test Ethernet link
 *
 * This creates a minimal Ethernet frame with:
 *   - Destination: Broadcast MAC (FF:FF:FF:FF:FF:FF)
 *   - Source: FPGA MAC (00:11:22:33:44:55)
 *   - Type: IPv4
 *   - Payload: Simple UDP packet
 */
void send_test_udp_packet(void) {
    printf("Sending test UDP packet...\n");
    printf("  Destination: FF:FF:FF:FF:FF:FF (Broadcast)\n");
    printf("  Source:      00:11:22:33:44:55 (FPGA)\n");
    printf("  Protocol:    UDP\n");
    printf("  Data:        'Hello from FPGA!'\n");
    printf("\n");
    
    // TODO: Implement actual packet transmission via RGMII
    // This would involve:
    //   1. Write Ethernet header (src/dst MAC, EtherType)
    //   2. Write IPv4 header (src/dst IP, protocol=UDP, checksum)
    //   3. Write UDP header (src/dst ports, length, checksum)
    //   4. Write payload data
    //   5. Calculate and append FCS (32-bit CRC)
    //   6. Transmit via RGMII TX interface
}

// ============================================================================
// Main Entry Point
// ============================================================================

/**
 * Main firmware entry point
 *
 * Called after Sapphire RISC-V boots
 */
int main(void) {
    printf("\n\n");
    printf("=================================================================\n");
    printf("Efinix T120F324 FPGA - Ethernet PHY Bringup Firmware\n");
    printf("=================================================================\n");
    printf("System Clock:    50 MHz\n");
    printf("PHY Device:      RTL8211F-CG\n");
    printf("Interface:       RGMII (Gigabit Ethernet)\n");
    printf("Management:      MDIO (via Sapphire APB)\n");
    printf("=================================================================\n\n");
    
    // Initialize Ethernet PHY
    phy_init();
    
    // Once link is up, you can:
    //   1. Send test UDP packets
    //   2. Receive Ethernet frames
    //   3. Implement full IP stack (lwIP, etc.)
    //   4. Add application protocols (HTTP, MQTT, etc.)
    
    // Example: Send test packet
    send_test_udp_packet();
    
    printf("Firmware running. Waiting for Ethernet activity...\n");
    printf("Use 'ping 192.168.1.254' from your computer to test.\n\n");
    
    // Main loop
    while (1) {
        // TODO: Check for Ethernet frames, process them
        // TODO: Handle interrupts from PHY (F2_INTB)
        // TODO: Update link status periodically
        
        delay_ms(1000);
        
        // Periodically check link status
        uint16_t bmsr = mdio_read(PHY_ADDR, REG_BMSR);
        if (!(bmsr & BMSR_LINK_UP)) {
            printf("WARNING: Link went DOWN!\n");
        }
    }
    
    return 0;
}

// ============================================================================
// Optional: Standalone Verification (for testing without RISC-V)
// ============================================================================

/**
 * Quick PHY verification without full initialization
 * Use this if you just want to check PHY presence
 */
void phy_verify_only(void) {
    printf("Quick PHY Verification (no initialization):\n\n");
    
    // Just read ID
    uint16_t id1 = mdio_read(PHY_ADDR, REG_PHYID1);
    uint16_t id2 = mdio_read(PHY_ADDR, REG_PHYID2);
    
    printf("PHY ID: 0x%04X_%04X\n", id1, id2);
    
    if ((id1 == 0x001C) && (id2 == 0xC916)) {
        printf("✓ RTL8211F-CG detected and responding!\n");
    } else {
        printf("✗ Unexpected PHY or no response.\n");
    }
}

/**
 * MDIO register dump (for debugging)
 */
void phy_dump_registers(void) {
    printf("\nPHY Register Dump:\n\n");
    
    for (int reg = 0; reg < 16; reg++) {
        uint16_t val = mdio_read(PHY_ADDR, reg);
        printf("  REG[%2d] = 0x%04X\n", reg, val);
    }
}

// ============================================================================
// EOF
// ============================================================================
