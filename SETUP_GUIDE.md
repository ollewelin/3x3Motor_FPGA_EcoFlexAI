# System Verilog Top Level Integration Guide

## Overview

You now have a new `top_level.sv` that replaces `clk_test.vhd` and provides a complete Ethernet PHY bring-up infrastructure for your Efinix T120F324 FPGA board.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Efinix T120F324                          │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │              Sapphire RISC-V SoC (TO ADD)                 │ │
│  │  - Processor core (32-bit RISC-V)                         │ │
│  │  - Caches, MMU                                             │ │
│  │  - APB Master (connects to peripherals)                   │ │
│  │  - Timer, Interrupt Controller                            │ │
│  └──────────────────────┬───────────────────────────────────┘ │
│                         │ APB Bus                               │
│     ┌───────────────────┼───────────────────┐                 │
│     ▼                   ▼                   ▼                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │  MDIO Master │  │ETH Frame Gen │  │  Other Periph.   │   │
│  │              │  │              │  │  (UART, SPI...)  │   │
│  │ Address:     │  │ Address:     │  │                  │   │
│  │ 0x8001_0000  │  │ 0x8002_0000  │  │                  │   │
│  └──────┬───────┘  └──────┬───────┘  └──────────────────┘   │
│         │ APB              │ APB                               │
│         │ Decoders         │                                  │
│         ▼                  ▼                                  │
│     ┌─────────────────────────┐                              │
│     │  MDIO → PHY (RTL8211F)  │                              │
│     │  - PHY Config/Status    │                              │
│     │  - Link Detection       │                              │
│     └─────────────────────────┘                              │
│                                                               │
│     ┌─────────────────────────┐                              │
│     │ RGMII ↔ PHY (RTL8211F)  │                              │
│     │ - Ethernet Data         │                              │
│     │ - RX/TX Paths           │                              │
│     └─────────────────────────┘                              │
└─────────────────────────────────────────────────────────────────┘
         │                               │
         ▼ RXD[3:0], RXCTL, RXC         │
    ╔═══════════════════════════════════╩═════════════════╗
    ║     RTL8211F-CG Ethernet PHY (U98)                  ║
    ║     - RGMII Interface                               ║
    ║     - MDIO Interface                                ║
    ║     - Integrated Magnetics                          ║
    ╚═════════════════════════════════════════════════════╝
         │                               │
         ▼                               ▼
    RJ45 Connector                 Ethernet Network
```

## Key Components

### 1. **MDIO Master** (Already verified ✓)
- **File**: `ip/mdio_master/mdio_master_top.sv` + core
- **Purpose**: Communicate with Ethernet PHY configuration registers
- **APB Address**: `0x8001_0000`
- **Features**:
  - Read/write PHY registers (Clause-22)
  - 1 MHz MDC clock generation
  - PHY reset control
  
**Key Operations for PHY Setup**:
```
1. Release PHY from reset (write CONFIG reg, bit 0 = 1)
2. Read PHY ID (registers 0x02, 0x03)
   - Expected: PHYID1=0x001C, PHYID2=0xC916
3. Read Basic Mode Status (register 0x01)
   - Check link status (bit 2)
4. Configure for RGMII mode (Extended register 0xA43, reg 0x1D)
5. Enable auto-negotiation (register 0x00, bit 12)
6. Monitor link up status (register 0x01, bit 2)
```

### 2. **RGMII Receiver** 
- **Purpose**: Capture incoming Ethernet frames from PHY
- **Signals**:
  - `F2_RXC` - Receive clock (from PHY, usually 125 MHz or 25 MHz)
  - `F2_RXCTL` - RX control valid
  - `F2_RXD[3:0]` - RX data (4-bit parallel)

### 3. **RGMII Transmitter**
- **Purpose**: Send Ethernet frames to PHY
- **Signals**:
  - `F2_TXC` - Transmit clock (generated in FPGA)
  - `F2_TXCTL` - TX control
  - `F2_TXD[3:0]` - TX data (4-bit parallel)

### 4. **Ethernet Frame Generator**
- **Purpose**: Creates test UDP packets for Ethernet PHY bringup
- **Generates**: Simple broadcast packets (ARP, DHCP-like frames)
- **Future**: Expand for custom UDP payloads

### 5. **PHY Initialization FSM**
- **Purpose**: Automated PHY startup sequence
- **Steps**:
  1. Wait for PHY reset
  2. Read PHY ID for verification
  3. Check link status
  4. Configure PHY for operation

### 6. **Sapphire RISC-V SoC** (TO BE ADDED)
- **Status**: Placeholder in `top_level.sv`
- **Purpose**: Run firmware to control MDIO master and test data
- **Integration Method**: Use Efinity IP Manager

---

## Getting Started - 3 Steps

### Step 1: Update Project Settings in Efinity

1. Open your Efinity project: `T120F324_A.xml`
2. Change top module from `clk_test` → `top_level`
3. Add `top_level.sv` to design files (make sure path is correct)

**In Efinity GUI**:
```
Design > Design Sources
  ✓ Uncheck: clk_test.vhd (or delete it)
  ✓ Add: top_level.sv
  
Design > Top Module
  Change from: clk_test
  Change to: top_level
```

### Step 2: Configure GPIO in Efinity Peripherals

Verify these GPIO pins are configured in `T120F324_A.peri.xml`:

```
MDIO Interface:
├── F2_MDC     → GPIOB_TXN01 (T18) - Output
├── F2_MDIO    → GPIOB_TXN05 (R15) - Inout (tri-state)
└── F2_RSTB    → GPIOB_TXP00 (T17) - Output

RGMII Interface:
├── RX Path:
│  ├── F2_RXC    → GPIOR_178     - Input
│  ├── F2_RXCTL  → GPIOB_TXP08   - Input
│  └── F2_RXD[3:0] → GPIOB_TXN08/TXP06/TXN06/TXN07 - Input[4]
│
├── TX Path:
│  ├── F2_TXC    → GPIOB_TXP07   - Output
│  ├── F2_TXCTL  → GPIOB_TXP05   - Output
│  └── F2_TXD[3:0] → Need to assign - Output[4]
│
├── Control:
│  ├── F2_INTB    → GPIOB_TXP02   - Input
│  └── F2_EXT_CLK → GPIOR_174     - Input

Debug Outputs:
├── CAM3_SCL → Status LED (PHY ready)
└── CAM3_EN  → Link status LED
```

**Status**: Most are already configured! Check the `.peri.xml` file.

### Step 3: Synthesize & Program

```bash
# In Efinity:
1. Tools > Synthesis
   - Verify no errors
   - Warning about unconnected APB (normal, SAP will be added)

2. Tools > Place & Route
   - Verify successful placement/routing

3. Tools > Program Device
   - Program T120F324 with .bit file
```

---

## Adding Sapphire RISC-V SoC (Next Phase)

When you're ready to add the processor:

### Via Efinity IP Manager:
1. Open Efinity IP Manager
2. Search for "Sapphire"
3. Add Sapphire SoC to project
4. Configure:
   - **Clock**: Connect to `sys_clk` (50 MHz)
   - **Reset**: Connect to `sys_rst_n`
   - **APB Master**: Routes to MDIO Master at `0x8001_0000`
   - **UART** (optional): For console output/debug
   - **GPIO** (optional): Additional control signals

5. In `top_level.sv`, replace the commented-out `u_sapphire` instantiation with actual instance

### APB Address Map:
```
0x8001_0000 - 0x8001_000F : MDIO Master
  0x8001_0000 : CTRL Register
  0x8001_0004 : STATUS Register
  0x8001_0008 : CONFIG Register
  0x8001_000C : VERSION Register

0x8002_0000 - 0x8002_000F : Ethernet Frame Generator (future)
0x8003_0000 - 0x8003_FFFF : Expansion area
```

---

## Firmware Development (C Code for RISC-V)

Once Sapphire is integrated, you can write firmware to:

### 1. Initialize Ethernet PHY
```c
// Release PHY from reset
mdio_write(PHY_ADDR, CONFIG_REG, 0x0001);  // PHY_RST = 1

// Read PHY ID to verify
uint32_t id1 = mdio_read(PHY_ADDR, 0x02);  // Should be 0x001C
uint32_t id2 = mdio_read(PHY_ADDR, 0x03);  // Should be 0xC916

// Check link status
uint32_t status = mdio_read(PHY_ADDR, 0x01);  // BMSR
bool link_up = (status & 0x0004) != 0;       // Bit 2
```

### 2. Read/Write MDIO Registers
```c
// See README.md in ip/mdio_master/ for full APB interface

#define MDIO_BASE  0x80010000
#define CTRL       *(volatile uint32_t*)(MDIO_BASE + 0x00)
#define STATUS     *(volatile uint32_t*)(MDIO_BASE + 0x04)
#define CONFIG     *(volatile uint32_t*)(MDIO_BASE + 0x08)

// Write to PHY register
CTRL = (1 << 0) |           // START
       (0 << 1) |           // Write (not read)
       (0x01 << 5) |        // PHY_ADDR
       (0x00 << 10) |       // REG_ADDR (BMCR)
       (0x1200 << 16);      // WDATA

while ((STATUS & 1) == 1);  // Wait for BUSY to clear
```

### 3. Generate Test Data
```c
// Send simple UDP broadcast packets
ethernet_send_test_packet(
    src_mac,    // 00:11:22:33:44:55
    dst_mac,    // FF:FF:FF:FF:FF:FF (broadcast)
    src_ip,     // 192.168.1.254
    dst_ip,     // 192.168.1.255
    payload,
    length
);
```

---

## Verification Checklist

### Hardware Bring-up (No RISC-V):
- [ ] Program FPGA with `top_level.sv`
- [ ] Check CAM3_SCL LED (should light up if PHY ready)
- [ ] Measure F2_MDC clock (should be ~2.5 MHz after reset)
- [ ] Verify F2_RSTB pulse (active low, ~10ms duration)
- [ ] Check RGMII RXC clock from PHY (125 MHz or 25 MHz)

### With Sapphire RISC-V:
- [ ] Boot Sapphire successfully
- [ ] Read PHY ID via MDIO (0x001C, 0xC916)
- [ ] Detect link status (read BMSR)
- [ ] Monitor Ethernet RX frames
- [ ] Transmit test UDP packets

### Ethernet Functionality:
- [ ] Cable connects Ethernet port to network
- [ ] Link LED on RJ45 connector lights up
- [ ] Can ping FPGA (once IP stack is added)
- [ ] Receive packets at correct MAC address

---

## Debugging Tips

### MDIO Issues:
1. **No MDC clock**: Check MDIO master clock divider in `mdio_master.sv`
2. **PHY not responding**: Verify F2_RSTB is high (active high after release)
3. **Wrong PHY ID**: Check PHY_ADDR (RTL8211F default is 0x01)

### RGMII Issues:
1. **No RXC clock**: Verify cable connected, check PHY clock output
2. **Data corruption**: Check timing constraints in `const.sdc`
3. **TX not working**: Verify TXC clock divider, check output drivers

### General:
- Check `outflow/T120F324_A.interface.csv` for signal assignments
- Review synthesis log for unconnected signals (especially APB)
- Use GTKWave to view `.vcd` files during simulation

---

## File Organization

```
T120F324_A/
├── top_level.sv                    ← NEW: Main SystemVerilog top level
├── clk_test.vhd                    ← OLD: Can be deleted/archived
├── const.sdc                       ← Timing constraints
├── T120F324_A.xml                 ← Project file (update top module)
├── T120F324_A.peri.xml            ← GPIO configuration
├── ip/
│   └── mdio_master/
│       ├── mdio_master.sv          ← Core MDIO protocol
│       ├── mdio_master_top.sv      ← Efinix wrapper
│       ├── tb_mdio_master.sv       ← Testbench
│       └── README.md               ← MDIO register map
├── work_syn/                       ← Synthesis outputs
├── work_pnr/                       ← Place & Route outputs
└── outflow/                        ← Final bitstream & reports
```

---

## Next Steps

### Immediate (This Session):
1. ✅ Create `top_level.sv` with MDIO, RGMII, ETH frame gen
2. Update project to use new top module
3. Verify synthesis succeeds
4. Program FPGA and check PHY reset timing

### Short Term (Next Hour):
1. Add Sapphire SoC via Efinity IP Manager
2. Configure APB peripherals
3. Write simple PHY initialization firmware
4. Test MDIO read/write of PHY registers

### Medium Term (This Week):
1. Implement full PHY configuration sequence
2. Add Ethernet MAC/RGMII controller
3. Create UDP packet transmitter
4. Debug link bring-up

### Long Term (Production):
1. Full TCP/IP stack integration
2. Ethernet driver optimization
3. Performance tuning
4. Final validation

---

## Key References

- **MDIO Master**: See `ip/mdio_master/README.md` for register map
- **RTL8211F Datasheet**: Registers, timing, configuration
- **Efinix Sapphire**: IP Manager documentation
- **IEEE 802.3**: RGMII timing, Clause-22 MDIO protocol

---

## Questions?

1. **How do I add Sapphire SoC?**
   → Use Efinity IP Manager, see section "Adding Sapphire RISC-V SoC"

2. **What about the clock/reset?**
   → `top_level.sv` provides 50 MHz `sys_clk` and `sys_rst_n` (via reset counter)

3. **When should I test without PHY?**
   → Immediately! Program FPGA and verify MDC clock and reset timing

4. **How do I verify frames are being transmitted?**
   → Use external Ethernet analyzer or check RXD[3:0] signals with logic analyzer

5. **Can I test MDIO before Sapphire is added?**
   → Yes! The PHY init FSM (placeholder) shows the sequence needed

---

**Last Updated**: Jan 18, 2026  
**Status**: Framework complete, placeholders marked with TODO  
**Ready for**: Hardware integration + Sapphire SoC addition

