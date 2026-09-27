#include <stdio.h>
#include <stdint.h>
#include <soc.h>

// MDIO Master APB Register Addresses (assuming 0x8001_0000 base)
#define MDIO_BASE     0x80010000
#define MDIO_CTRL     (MDIO_BASE + 0x00)
#define MDIO_STATUS   (MDIO_BASE + 0x04)
#define MDIO_CONFIG   (MDIO_BASE + 0x08)
#define MDIO_VERSION  (MDIO_BASE + 0x0C)

// DDRAM3 Base Address (from Sapphire SoC)
#define DDRAM_BASE    0x80000000

// Function to read MDIO register
uint16_t mdio_read(uint8_t phy_addr, uint8_t reg_addr) {
    volatile uint32_t *ctrl   = (uint32_t *)MDIO_CTRL;
    volatile uint32_t *status = (uint32_t *)MDIO_STATUS;
    
    // Build control word: [31:16]=0, [15]=0, [14:10]=reg_addr, [9:5]=phy_addr, [4:2]=0, [1]=1 (READ), [0]=1 (START)
    uint32_t cmd = ((reg_addr & 0x1F) << 10) | ((phy_addr & 0x1F) << 5) | 0x03;
    
    // Write command
    *ctrl = cmd;
    
    // Wait for DONE bit
    int timeout = 10000;
    while (timeout-- > 0) {
        if (*status & 0x02) {  // DONE bit [1]
            break;
        }
    }
    
    // Read data from STATUS[31:16]
    uint16_t rdata = (*status >> 16) & 0xFFFF;
    
    // Clear DONE bit by writing 0x02 to status
    *status = 0x02;
    
    return rdata;
}

// Function to test DDRAM3
int test_ddram3() {
    printf("\n========== DDRAM3 TEST ==========\n");
    
    volatile uint32_t *dram = (uint32_t *)DDRAM_BASE;
    uint32_t test_pattern = 0xDEADBEEF;
    
    // Write test pattern
    *dram = test_pattern;
    printf("Wrote: 0x%08X to 0x%08X\n", test_pattern, DDRAM_BASE);
    
    // Read back
    uint32_t readback = *dram;
    printf("Read:  0x%08X from 0x%08X\n", readback, DDRAM_BASE);
    
    if (readback == test_pattern) {
        printf("DDRAM3: PASS ✓\n");
        return 1;
    } else {
        printf("DDRAM3: FAIL ✗ (expected 0x%08X, got 0x%08X)\n", test_pattern, readback);
        return 0;
    }
}

int main(int argc, char **argv) {
    printf("\n");
    printf("================================\n");
    printf("  Efinix T120F324 PHY Bringup  \n");
    printf("  MDIO + DDRAM3 Test            \n");
    printf("================================\n");
    
    // Test PHYID1 (register 0x02)
    printf("\n========== MDIO TEST ==========\n");
    printf("Reading PHYID1 (reg 0x02, PHY 0x01)...\n");
    uint16_t phyid1 = mdio_read(0x01, 0x02);
    printf("PHYID1: 0x%04X\n", phyid1);
    if (phyid1 == 0x001C) {
        printf("PHYID1: PASS ✓ (RTL8211F detected)\n");
    } else {
        printf("PHYID1: FAIL ✗ (expected 0x001C)\n");
    }
    
    // Test PHYID2 (register 0x03)
    printf("\nReading PHYID2 (reg 0x03, PHY 0x01)...\n");
    uint16_t phyid2 = mdio_read(0x01, 0x03);
    printf("PHYID2: 0x%04X\n", phyid2);
    if (phyid2 == 0xC916) {
        printf("PHYID2: PASS ✓ (RTL8211F detected)\n");
    } else {
        printf("PHYID2: FAIL ✗ (expected 0xC916)\n");
    }
    
    // Test Status Register (register 0x01)
    printf("\nReading Status (reg 0x01, PHY 0x01)...\n");
    uint16_t status = mdio_read(0x01, 0x01);
    printf("STATUS: 0x%04X\n", status);
    printf("  Link Status: %s\n", (status & 0x0004) ? "UP" : "DOWN");
    
    // Test DDRAM3
    int ddram_ok = test_ddram3();
    
    // Summary
    printf("\n========== SUMMARY ==========\n");
    printf("PHYID1: %s\n", (phyid1 == 0x001C) ? "PASS" : "FAIL");
    printf("PHYID2: %s\n", (phyid2 == 0xC916) ? "PASS" : "FAIL");
    printf("DDRAM3: %s\n", ddram_ok ? "PASS" : "FAIL");
    printf("=============================\n\n");
    
    return 0;
}
