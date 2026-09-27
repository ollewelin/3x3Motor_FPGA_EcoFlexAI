# Immediate Action Items - Ethernet PHY Bring-up

## What You Have Now ✅

1. **top_level.sv** - Complete SystemVerilog top-level with:
   - MDIO Master for PHY configuration
   - RGMII receiver/transmitter (placeholder modules)
   - Ethernet frame generator (placeholder)
   - PHY initialization FSM (placeholder)
   - Clock/reset distribution

2. **phy_init.c** - RISC-V firmware for:
   - PHY initialization sequence
   - MDIO read/write operations
   - Link status monitoring
   - Test UDP frame generation

3. **SETUP_GUIDE.md** - Complete integration guide

## Next Steps (DO THIS NOW)

### Phase 1: Basic Hardware Verification (15 minutes)

1. **Update Efinity Project**
   ```
   File: T120F324_A.xml
   Change top module from: clk_test
   Change to: top_level
   
   Add design files:
   - top_level.sv (NEW)
   - Keep existing: ip/mdio_master/*.sv
   ```

2. **Verify GPIO Configuration**
   ```
   Check T120F324_A.peri.xml for these configured GPIOs:
   ✓ F2_MDC      → GPIOB_TXN01 (T18)   - Output
   ✓ F2_MDIO     → GPIOB_TXN05 (R15)   - Inout (tri-state)
   ✓ F2_RSTB     → GPIOB_TXP00 (T17)   - Output
   ✓ F2_RXC      → GPIOR_178
   ✓ F2_RXCTL    → GPIOB_TXP08
   ✓ F2_RXD[3:0] → GPIOB TXN08/TXP06/TXN06/TXN07
   ✓ F2_TXC      → GPIOB_TXP07
   ✓ F2_TXCTL    → GPIOB_TXP05
   ✓ F2_EXT_CLK  → GPIOR_174
   ✓ F2_INTB     → GPIOB_TXP02
   
   Note: Most are already configured from previous work!
   ```

3. **Synthesize**
   ```
   Efinity > Tools > Synthesis
   Expected: No errors
   Warnings about unconnected APB signals are OK (Sapphire not added yet)
   ```

4. **Place & Route**
   ```
   Efinity > Tools > Place & Route
   Verify successful placement
   Check timing (should meet 50 MHz constraint)
   ```

5. **Program FPGA**
   ```
   Efinity > Tools > Program Device
   
   THEN:
   - Monitor F2_RSTB pin with oscilloscope/logic analyzer
     Expected: Pulse LOW (active low reset)
     Duration: ~1ms from power-on
   
   - Measure F2_MDC clock with oscilloscope
     Expected: ~2.5 MHz square wave (after reset is released)
     Verification: Clock only present after F2_RSTB goes HIGH
   
   - Check CAM3_SCL LED
     Expected: Should light up after reset sequence
   ```

### Phase 2: MDIO Communication Verification (30 minutes)

Once basic hardware works, verify MDIO without Sapphire:

1. **Create Simple MDIO Test Module** (optional, for debug)
   ```verilog
   // Simple state machine to read PHY ID registers
   // Instantiate in top_level.sv for standalone testing
   
   // Sequence:
   // 1. Release PHY reset (CONFIG reg)
   // 2. Wait 100ms
   // 3. Issue read command for register 0x02 (PHYID1)
   // 4. Read back 0x001C
   // 5. Issue read command for register 0x03 (PHYID2)
   // 6. Read back 0xC916
   // 7. Assert status LED if both match
   ```

2. **Observe MDIO Signals**
   ```
   With logic analyzer connected to:
   - F2_MDC   (clock)
   - F2_MDIO  (data)
   - F2_RSTB  (reset)
   
   Expected waveforms:
   - MDC: 2.5 MHz square wave after reset
   - MDIO: Idle HIGH (pull-up)
   - During read: MDIO pulses LOW for each bit transmitted
   
   Protocol: Clause-22 MDIO (32-bit frames)
   ```

3. **Debug MDIO Issues**
   ```
   If no MDC clock:
   - Check GPIOB_TXN01 output driver
   - Verify clock divider in mdio_master.sv
   
   If MDC but no MDIO data:
   - Check pull-up resistor on F2_MDIO line (board schematic)
   - Verify tri-state buffer logic in mdio_master_top.sv
   
   If wrong PHY ID:
   - PHY might not be responding
   - Check power supply to U98 (RTL8211F)
   - Verify MDIO connections
   ```

### Phase 3: Add Sapphire RISC-V (1-2 hours)

Once MDIO is verified:

1. **Use Efinity IP Manager**
   ```
   Efinity > IP Manager
   Search: Sapphire
   Add Sapphire SoC
   
   Configure:
   - Main Clock Input: sys_clk (50 MHz)
   - Reset Input: sys_rst_n
   - APB Clock: sys_clk
   - APB Reset: sys_rst_n
   - Boot Mode: BRAM (internal)
   ```

2. **Map APB Addresses**
   ```
   In Sapphire configuration:
   
   Peripheral 0: MDIO Master
   - Base Address: 0x80010000
   - Size: 16 bytes (0x10)
   - Connected to: mdio_master_top instance
   
   Peripheral 1: Ethernet Frame Generator (future)
   - Base Address: 0x80020000
   - Size: 16 bytes
   ```

3. **Connect Sapphire Instance in top_level.sv**
   ```verilog
   // Replace the commented-out placeholder with:
   
   sapphire_soc u_sapphire (
       .clk        (sys_clk),
       .rst_n      (sys_rst_n),
       
       // APB Master outputs
       .apb_paddr  (apb_paddr),
       .apb_psel   (apb_psel),
       .apb_penable(apb_penable),
       .apb_pwrite (apb_pwrite),
       .apb_pwdata (apb_pwdata),
       .apb_prdata (combined_prdata),  // From mux
       .apb_pready (combined_pready),  // From mux
       
       // Interrupts
       .mdio_irq   (mdio_irq),
       
       // UART (debug)
       .uart_txd   (),  // Connect to terminal
       .uart_rxd   ()
   );
   ```

4. **Verify Sapphire Boot**
   ```
   Expected boot output on UART:
   "Booting Sapphire RISC-V..."
   "System Clock: 50 MHz"
   ```

### Phase 4: Run PHY Initialization Firmware (30 minutes)

Once Sapphire boots:

1. **Build phy_init.c**
   ```bash
   # In your RISC-V toolchain:
   riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 \
       -O2 -c phy_init.c -o phy_init.o
   
   riscv32-unknown-elf-ld -Tlink.ld phy_init.o -o phy_init.elf
   
   riscv32-unknown-elf-objcopy -O ihex phy_init.elf firmware.hex
   ```

2. **Load into BRAM**
   ```
   Place firmware.hex in FPGA BRAM during synthesis/bitstream
   (Depends on your Sapphire/BRAM configuration)
   ```

3. **Monitor UART Output**
   ```
   Connect to UART at 115200 baud
   
   Expected output:
   "Ethernet PHY Initialization"
   "[1] Releasing PHY from reset..."
   "[2] Reading PHY ID..."
   "PHY ID1 = 0x001C"
   "PHY ID2 = 0xC916"
   "✓ PHY ID verified as RTL8211F!"
   "[3] Checking Basic Mode Status..."
   "[4] Configuring for Gigabit Ethernet..."
   "[5] Waiting for link..."
   "✓ LINK UP DETECTED!"
   ```

## Critical Signals to Monitor

### With Logic Analyzer / Oscilloscope:

1. **F2_RSTB** (T17)
   - Should pulse LOW on power-up
   - Release HIGH after ~1-5ms
   - Stays HIGH during operation

2. **F2_MDC** (T18)
   - 2.5 MHz clock square wave
   - Only appears after F2_RSTB is released
   - Continuous during MDIO transactions

3. **F2_MDIO** (R15)
   - Idles HIGH (pulled up)
   - Pulses LOW during read/write operations
   - Open-drain output (needs external pull-up)

4. **F2_RXC** (from PHY)
   - 125 MHz clock (Gigabit mode)
   - Or 25 MHz (10/100 mode)
   - Check oscilloscope frequency

5. **F2_RXD[3:0]** & **F2_RXCTL**
   - Data valid only when F2_RXCTL is HIGH
   - Data changes on clock edges

## Troubleshooting Checklist

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| No MDC clock | GPIOB_TXN01 not configured | Check .peri.xml, reconfigure GPIO |
| MDC but no MDIO data | Tri-state buffer issue | Check mdio_master_top.sv, verify pull-up resistor |
| Wrong PHY ID | PHY not powered | Check 3.3V supply to U98 |
| No RXC clock | PHY not outputting clock | Check F2_EXT_CLK input, verify cable |
| Link stays DOWN | Auto-negotiation timeout | Check network cable, try connecting to different port |
| Synthesis fails | Module conflicts | Remove clk_test.vhd from project |

## Files You Created Today

```
top_level.sv              ← Main design (replaces clk_test.vhd)
phy_init.c               ← RISC-V firmware for PHY init
SETUP_GUIDE.md           ← Complete integration guide
IMMEDIATE_ACTIONS.md     ← This file
```

## Expected Timeline

| Phase | Time | Status |
|-------|------|--------|
| 1. Basic HW verification | 15 min | START HERE |
| 2. MDIO verification | 30 min | After phase 1 |
| 3. Add Sapphire RISC-V | 1-2 hrs | After phase 2 |
| 4. Run firmware | 30 min | After phase 3 |
| 5. Ethernet bringup | 2-4 hrs | Final stage |

## Key Success Indicators

After each phase, you should see:

**Phase 1**: ✓ Compilation OK, F2_RSTB pulse visible, F2_MDC clock at 2.5 MHz  
**Phase 2**: ✓ MDIO protocol frames on logic analyzer, PHY responding  
**Phase 3**: ✓ Sapphire boots, UART output visible  
**Phase 4**: ✓ UART shows "LINK UP DETECTED!"  

---

## Questions Before You Start?

1. **Do I need to remove clk_test.vhd?**
   - Not required, but recommended to avoid conflicts
   - Uncheck it in "Design Sources" in Efinity

2. **What if synthesis fails?**
   - Check design files path (top_level.sv should be at project root)
   - Verify mdio_master.sv is in ip/mdio_master/ directory
   - Check Efinity allows mixed VHDL/Verilog (it does)

3. **Can I test without Sapphire?**
   - Yes! Phase 1 & 2 work with just the state machine in top_level.sv
   - You can observe MDIO waveforms without any processor

4. **What clock frequency should I use?**
   - System clock: 50 MHz (T120_GCLK from board)
   - MDC clock: 1 MHz (automatically generated by divider)
   - Possible RGMII: 125 MHz for Gigabit (from PHY)

---

**Start with Phase 1 right now! Report back with results. 🚀**

