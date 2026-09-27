# APB Interface & Register Reference

## Quick Register Map

```
Address Space: 0x8001_0000 - 0x8001_000F (16 bytes)

Offset  Name      Access  Description
------  --------  ------  -----------
0x00    CTRL      RW      Control Register (start, read/write, PHY/reg addr, data)
0x04    STATUS    RO/W1C  Status Register (busy, done, read data)
0x08    CONFIG    RW      Configuration Register (PHY reset, interrupts)
0x0C    VERSION   RO      Version Register (firmware version)
```

---

## Register Details

### CTRL Register (Offset 0x00) - Read/Write

Used to initiate MDIO transactions (read or write to PHY registers).

**Format:**
```
Bits  Field       Type  Description
----  ---------   ----  -----------
[0]   START       RW    Write 1 to start transaction (auto-clears after completion)
[1]   RW          RW    1=Read from PHY, 0=Write to PHY
[4:2] Reserved   -     (unused)
[9:5] PHY_ADDR    RW    PHY address (0x00-0x1F, typically 0x01 for RTL8211F)
[14:10] REG_ADDR  RW    Register address (0x00-0x1F in PHY)
[15]  Reserved   -     (unused)
[31:16] WDATA    RW    Write data (only used for write operations)
```

**Example: Write 0x1234 to PHY 0x01, Register 0x04**

```c
MDIO_CTRL = (1 << 0) |           // START = 1 (start transaction)
            (0 << 1) |           // RW = 0 (write operation)
            (0x01 << 5) |        // PHY_ADDR = 0x01
            (0x04 << 10) |       // REG_ADDR = 0x04
            (0x1234 << 16);      // WDATA = 0x1234
```

**Example: Read from PHY 0x01, Register 0x02**

```c
MDIO_CTRL = (1 << 0) |           // START = 1 (start transaction)
            (1 << 1) |           // RW = 1 (read operation)
            (0x01 << 5) |        // PHY_ADDR = 0x01
            (0x02 << 10);        // REG_ADDR = 0x02
            // WDATA ignored for read
```

---

### STATUS Register (Offset 0x04) - Read Only / Write 1 to Clear

Contains transaction status and read data.

**Format:**
```
Bits   Field       Type  Description
-----  ---------   ----  -----------
[0]    BUSY        RO    1 = Transaction in progress, 0 = Idle
[1]    DONE        RO/W1C 1 = Transaction complete (write 1 to clear)
[15:2] Reserved   -     (unused)
[31:16] RDATA     RO    Read data from PHY (for read operations)
```

**Usage:**

```c
// Wait for transaction to complete
while ((MDIO_STATUS & 0x01) != 0) {
    // BUSY bit is set, wait
}

// Check if done
if (MDIO_STATUS & 0x02) {
    // Transaction completed
    uint16_t rdata = (MDIO_STATUS >> 16) & 0xFFFF;  // Extract read data
    
    // Clear done flag
    MDIO_STATUS = 0x02;  // Write 1 to clear
}
```

---

### CONFIG Register (Offset 0x08) - Read/Write

PHY reset and interrupt control.

**Format:**
```
Bits  Field       Type  Description
----  ---------   ----  -----------
[0]   PHY_RST     RW    0 = PHY in reset, 1 = Normal operation
[1]   IRQ_EN      RW    0 = Interrupts disabled, 1 = Interrupts enabled
[31:2] Reserved  -     (unused)
```

**Usage:**

```c
// Release PHY from reset
MDIO_CONFIG = (1 << 0);  // PHY_RST = 1

// Wait for PHY to stabilize
delay_ms(100);

// Enable interrupts (optional)
MDIO_CONFIG = (1 << 0) | (1 << 1);  // PHY_RST=1, IRQ_EN=1
```

---

### VERSION Register (Offset 0x0C) - Read Only

Firmware/IP version information.

**Format:**
```
Bits   Field      Type  Description
-----  --------   ----  -----------
[7:0]  MINOR      RO    Minor version number
[15:8] MAJOR      RO    Major version number
[31:16] Reserved  -     (unused)
```

**Example:**

```c
uint32_t version = MDIO_VERSION;
uint8_t major = (version >> 8) & 0xFF;
uint8_t minor = version & 0xFF;
printf("MDIO IP Version: %d.%d\n", major, minor);
```

---

## C Function Library

Recommended C wrapper functions for firmware:

```c
/**
 * Write MDIO transaction
 * 
 * @param phy_addr   PHY address (0-31)
 * @param reg_addr   Register address (0-31)
 * @param data       16-bit data value
 */
void mdio_write(uint32_t phy_addr, uint32_t reg_addr, uint16_t data) {
    // Build and write CTRL register
    uint32_t ctrl = (1u << 0) |                    // START
                    (0u << 1) |                    // Write (not read)
                    ((phy_addr & 0x1F) << 5) |    // PHY_ADDR
                    ((reg_addr & 0x1F) << 10) |   // REG_ADDR
                    ((uint32_t)data << 16);       // WDATA
    
    MDIO_CTRL = ctrl;
    
    // Wait for completion
    while (MDIO_STATUS & 0x01) {
        // BUSY bit set, wait
    }
}

/**
 * Read MDIO transaction
 * 
 * @param phy_addr   PHY address (0-31)
 * @param reg_addr   Register address (0-31)
 * @return           16-bit data from PHY
 */
uint16_t mdio_read(uint32_t phy_addr, uint32_t reg_addr) {
    // Build and write CTRL register
    uint32_t ctrl = (1u << 0) |                    // START
                    (1u << 1) |                    // Read
                    ((phy_addr & 0x1F) << 5) |    // PHY_ADDR
                    ((reg_addr & 0x1F) << 10);    // REG_ADDR
    
    MDIO_CTRL = ctrl;
    
    // Wait for completion
    while (MDIO_STATUS & 0x01) {
        // BUSY bit set, wait
    }
    
    // Extract read data
    uint32_t status = MDIO_STATUS;
    uint16_t rdata = (uint16_t)((status >> 16) & 0xFFFF);
    
    // Clear done flag
    MDIO_STATUS = 0x02;  // Write 1 to clear
    
    return rdata;
}

/**
 * Check if PHY is present and responding
 * 
 * @return  true if PHY responds with correct ID, false otherwise
 */
bool mdio_phy_present(uint32_t phy_addr) {
    uint16_t id1 = mdio_read(phy_addr, 0x02);  // PHYID1
    uint16_t id2 = mdio_read(phy_addr, 0x03);  // PHYID2
    
    // RTL8211F-CG: ID1=0x001C, ID2=0xC916
    return (id1 == 0x001C) && (id2 == 0xC916);
}

/**
 * Check link status
 * 
 * @return  true if link is UP, false if DOWN
 */
bool mdio_link_up(uint32_t phy_addr) {
    uint16_t bmsr = mdio_read(phy_addr, 0x01);  // Basic Mode Status Register
    return (bmsr & 0x0004) != 0;  // Bit 2 = Link Status
}

/**
 * Initialize PHY for operation
 */
void mdio_phy_init(uint32_t phy_addr) {
    // Release from reset
    MDIO_CONFIG = 0x01;  // PHY_RST = 1
    delay_ms(100);
    
    // Read BMCR
    uint16_t bmcr = mdio_read(phy_addr, 0x00);
    
    // Set Full Duplex + Auto-Negotiation
    bmcr |= 0x0300;  // DUPLEX + AUTONEG_EN
    
    mdio_write(phy_addr, 0x00, bmcr);
    
    // Enable 1000BASE-T
    uint16_t gbcr = mdio_read(phy_addr, 0x09);
    gbcr |= 0x0200;  // 1000BASE-T
    
    mdio_write(phy_addr, 0x09, gbcr);
}
```

---

## MDIO Transaction Timing

All transactions follow IEEE 802.3 Clause-22 protocol:

```
MDC Clock:  ~2.5 MHz (1 microsecond period)
Transaction Duration: ~120 microseconds for typical read/write
Preamble: 32 consecutive 1s
Start Code: 01 (2 bits)
Operation: RW (1 for read, 0 for write)
PHY Address: 5 bits
Register Address: 5 bits
Turn-around: 2 bits (TA)
Data: 16 bits
Idle: Released to pull-up

Waveform:
┌─────────────────────────────────┬────────────────────┬──────────┐
│         Preamble                │    Frame Header     │   Data   │
│  32 × 1s, 128 clock cycles     │  Start, OP, Addr   │ 16 bits  │
└─────────────────────────────────┴────────────────────┴──────────┘
```

---

## APB Protocol (Sapphire RISC-V ↔ MDIO Master)

When Sapphire RISC-V accesses MDIO Master registers:

### Write Cycle

```
T0: psel    = 1 (peripheral selected)
    pwrite  = 1 (write operation)
    paddr   = register address (0x00, 0x04, 0x08, 0x0C)
    pwdata  = data to write

T1: penable = 1 (enable transfer)
    (hold all signals stable)

T2: penable = 0 (end transfer)
    pready  = 1 (transfer accepted)
    psel    = 0 (deselect)
```

### Read Cycle

```
T0: psel    = 1 (peripheral selected)
    pwrite  = 0 (read operation)
    paddr   = register address

T1: penable = 1 (enable transfer)
    (hold address stable)

T2: pready  = 1 (ready to provide data)
    prdata  = data from register
    penable = 0 (end transfer)
    psel    = 0 (deselect)
```

---

## PHY Registers Reference

### RTL8211F-CG Standard Registers (Clause-22)

```
Address  Name                          Description
-------  ----                          -----------
0x00     BMCR (Basic Mode Control)     Speed, duplex, autoneg
0x01     BMSR (Basic Mode Status)      Link status, capabilities
0x02     PHYID1                        OUI high (0x001C)
0x03     PHYID2                        OUI low + model + revision (0xC916)
0x04     ANAR (Auto-Neg Advertisement) Advertised capabilities
0x05     ANLPAR (Link Partner Ability) Link partner capabilities
0x06     ANER (Auto-Neg Expansion)     Auto-negotiation events
0x09     GBCR (1000BASE-T Control)    Gigabit control
0x0A     GBSR (1000BASE-T Status)     Gigabit status
0x0F     Extended Status Register     Additional status info
```

### Important BMCR (0x00) Bits

```
Bit  Name                 Value   Meaning
---  ----                 -----   -------
15   Reset                1       Software reset (auto-clears)
14   Loopback             1       Enable loopback mode
13   Speed Select LSB     1       100 Mbps (with bit 6=0)
12   Auto-Negotiation En  1       Enable auto-negotiation
11   Power Down           1       Power down mode
10   Isolate              1       Isolate from RMII/RGMII
9    Restart AN           1       Restart auto-negotiation
8    Duplex               1       1=Full duplex, 0=Half
7    Collision Test       1       Enable collision test
```

### Important BMSR (0x01) Bits

```
Bit  Name                      Value   Meaning
---  ----                      -----   -------
5    Auto-Negotiation Complete 1       Auto-negotiation finished
4    Remote Fault              1       Remote fault detected
3    Auto-Negotiation Able     1       PHY can do auto-negotiation
2    Link Status               1       1=Link Up, 0=Link Down
1    Jabber Detected           1       Jabber detected
0    Extended Capabilities     1       Supports extended registers
```

---

## Common PHY Initialization Sequence

```c
// 1. Release PHY from reset
MDIO_CONFIG = 0x01;
delay_ms(100);

// 2. Verify PHY is present
uint16_t id1 = mdio_read(0x01, 0x02);  // Should be 0x001C
uint16_t id2 = mdio_read(0x01, 0x03);  // Should be 0xC916

// 3. Configure for Gigabit Ethernet
// Read BMCR
uint16_t bmcr = mdio_read(0x01, 0x00);

// Set Full Duplex (bit 8) + Restart Auto-Negotiation (bit 9)
bmcr |= (1 << 8) | (1 << 9);

// Write back
mdio_write(0x01, 0x00, bmcr);

// 4. Wait for link to come up
for (int i = 0; i < 100; i++) {
    delay_ms(100);
    uint16_t bmsr = mdio_read(0x01, 0x01);
    if (bmsr & (1 << 2)) {  // Link Status bit
        printf("Link UP!\n");
        break;
    }
    printf("Waiting... (%d sec)\n", i / 10);
}

// 5. Check final status
uint16_t final_bmsr = mdio_read(0x01, 0x01);
printf("Link: %s\n", (final_bmsr & 0x04) ? "UP" : "DOWN");
```

---

## Debugging MDIO Issues

### Symptom: No Response from PHY

**Check:**
1. F2_RSTB pulse (should go LOW then HIGH)
2. F2_MDC clock appears after RSTB goes HIGH
3. PHY power supply (3.3V to U98)
4. MDIO pull-up resistor

**Solution:**
```c
// Check if PHY ID can be read
for (int i = 0; i < 10; i++) {
    uint16_t id = mdio_read(0x01, 0x02);
    printf("ID1 read %d: 0x%04X\n", i, id);
    delay_ms(100);
}
```

### Symptom: Wrong PHY ID

**Possible causes:**
1. Wrong PHY address (try 0x00-0x1F)
2. PHY variant (not RTL8211F-CG)
3. Electrical connection issue

**Solution:**
```c
// Scan for any responding PHY
for (int phy_addr = 0; phy_addr < 32; phy_addr++) {
    uint16_t id1 = mdio_read(phy_addr, 0x02);
    if (id1 != 0xFFFF && id1 != 0x0000) {
        printf("Found PHY at address 0x%02X: ID1=0x%04X\n", phy_addr, id1);
    }
}
```

### Symptom: Link never comes UP

**Check:**
1. Cable connected to network interface
2. Network interface powered on
3. Auto-negotiation completing (check ANER register)
4. Link partner (switch/router) responding

**Solution:**
```c
// Monitor extended status
while (1) {
    uint16_t bmsr = mdio_read(0x01, 0x01);
    uint16_t aner = mdio_read(0x01, 0x06);
    
    printf("BMSR: 0x%04X (Link=%s, AN=%s)\n",
           bmsr,
           (bmsr & 0x04) ? "UP" : "DOWN",
           (bmsr & 0x20) ? "DONE" : "IN PROGRESS");
    
    printf("ANER: 0x%04X\n", aner);
    
    delay_ms(1000);
}
```

---

## Register Access Examples

### Example 1: Read BMSR (Basic Mode Status)

```c
// Read link status
uint16_t bmsr = mdio_read(0x01, 0x01);

// Extract individual fields
bool link_up = (bmsr & 0x0004) != 0;           // Bit 2
bool an_complete = (bmsr & 0x0020) != 0;       // Bit 5
bool an_capable = (bmsr & 0x0008) != 0;        // Bit 3

printf("Link Status:     %s\n", link_up ? "UP" : "DOWN");
printf("Auto-Neg:        %s\n", an_capable ? "Capable" : "N/A");
printf("Auto-Neg Done:   %s\n", an_complete ? "Yes" : "No");
```

### Example 2: Enable Full Duplex

```c
// Read current BMCR
uint16_t bmcr = mdio_read(0x01, 0x00);

// Set Full Duplex bit (bit 8)
bmcr |= 0x0100;

// Write back
mdio_write(0x01, 0x00, bmcr);

printf("Full Duplex enabled\n");
```

### Example 3: Restart Auto-Negotiation

```c
// Read current BMCR
uint16_t bmcr = mdio_read(0x01, 0x00);

// Set Restart Auto-Neg bit (bit 9)
bmcr |= 0x0200;

// Write back
mdio_write(0x01, 0x00, bmcr);

printf("Auto-negotiation restarted\n");
```

---

**Last Updated**: January 18, 2026  
**Status**: Complete register reference  
**Target Device**: RTL8211F-CG Gigabit Ethernet PHY  
**FPGA Platform**: Efinix T120F324 with Sapphire RISC-V

