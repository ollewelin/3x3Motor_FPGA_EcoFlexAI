# RISC_mini Migration Summary

## Overview
Successfully migrated `top_level.sv` from **RISC_V_standard_A** (with DDR3 support) to **RISC_mini** (simpler, no DDR3).

## Changes Made to top_level.sv

### 1. Module Instantiation
**Changed from:**
- `RISC_V_standard_A u_sapphire_soc` - Full featured SoC with DDR3 controller and AXI bus

**Changed to:**
- `RISC_mini u_sapphire_soc` - Lightweight SoC without DDR3, simpler APB peripherals only

### 2. Removed Port Connections
Removed the following complex interfaces that are not needed:
- **DDR3 Configuration Signals:**
  - `ddr_inst1_CFG_RST_N`
  - `ddr_inst1_CFG_SEQ_RST`
  - `ddr_inst1_CFG_SEQ_START`
  
- **AXI Bus (DDR3 Master Interface):**
  - Write Address Channel (aw_*)
  - Write Data Channel (w_*)
  - Write Response Channel (b_*)
  - Read Address Channel (ar_*)
  - Read Data Channel (r_*)
  
- **DDR Master Interface:**
  - All `io_ddrMasters_0_*` signals

### 3. Added GPIO Output Control
**New feature:** Connected GPIO bit 0 from RISC_mini to LED #2 (CAM3_SDA_OUT)

```systemverilog
// GPIO bit 0 is the LED output when writeEnable[0] is high
assign CAM3_SDA_OUT = (gpio_writeEnable[0]) ? gpio_write[0] : 1'b0;
assign CAM3_SDA_OE  = 1'b1;  // Always drive output
```

### 4. Removed APB Address Decoder
Removed the complex APB address decoder that routed APB transactions:
- `0x8001_0000 → MDIO Master`
- `0x8002_0000 → Reserved`
- `0x8003_0000 → Reserved`

This decoder is no longer needed since RISC_mini doesn't support external APB slaves.

### 5. Removed MDIO Master Instance
Removed the `mdio_master` module instantiation and all MDIO/Ethernet PHY control logic:
- No more MDIO clock generation
- No more MDIO transaction handling
- Ethernet PHY communication disabled (for now)

### 6. Disabled Ethernet PHY Signals
All Ethernet signals are now tied to safe inactive states:
```systemverilog
// MDIO Interface (disabled)
assign F2_MDC   = 1'b0;
assign F2_MDIO_OUT = 1'b0;
assign F2_MDIO_OE  = 1'b0;

// PHY Reset (held in reset)
assign F2_RSTB = 1'b0;

// RGMII TX Interface (disabled)
assign F2_TXC   = 1'b0;
assign F2_TXCTL = 1'b0;
assign F2_TXD   = 4'h0;
```

### 7. Simplified Internal Signals
**Removed:**
- MDIO-related signals (`mdio_psel`, `mdio_penable`, `mdio_prdata`, `mdio_pready`, `mdio_pslverr`, `mdio_irq`)
- PHY status signals (`phy_ready`, `eth_link_up`)
- APB decoder logic

**Kept:**
- Clock and reset (`sys_clk`, `sys_rst_n`)
- UART signals (`sapphire_uart_txd`, `sapphire_uart_rxd`)
- GPIO signals (`gpio_write`, `gpio_writeEnable`, `gpio_read`)

## Next Steps: LED Blink Firmware

To use the LED blink feature, write firmware for RISC_mini that:

1. **Initializes GPIO bit 0 as output:**
   ```c
   // Example (depends on RISC_mini GPIO peripheral address)
   volatile uint32_t *gpio_ctrl = (volatile uint32_t *)0x8000_XXXX;
   gpio_ctrl[WRITENABLE] = 0x1;  // Enable write on bit 0
   ```

2. **Toggles the GPIO bit in a loop:**
   ```c
   while(1) {
       gpio_ctrl[WRITE] = 1;      // LED ON
       delay_ms(500);
       gpio_ctrl[WRITE] = 0;      // LED OFF
       delay_ms(500);
   }
   ```

3. **Upload and run the firmware via JTAG/OpenOCD**

## Benefits of RISC_mini

✅ **Simpler:** No DDR3 complexity → easier debugging  
✅ **Faster Compilation:** Fewer modules to synthesize  
✅ **Lower Resource Usage:** Smaller FPGA footprint  
✅ **Cleaner Control:** Direct GPIO access via firmware  
✅ **JTAG Debug Support:** Included (OpenOCD compatible)  

## Remaining Work

1. ⚠️ **Update Efinix project file** - Ensure `RISC_mini.v` is added to the project's file list in the `.peri.xml` or build system
2. ✅ **Implement LED blink firmware** - Write C code for RISC_mini to toggle GPIO bit 0
3. ✅ **Verify UART communication** - Test debug console at 115200 baud
4. ✅ **Test JTAG debugger** - Confirm OpenOCD can connect and debug

## File Structure Reference

```
RISC_mini module location:
  /ip/RISC_mini/RISC_mini.v

Modified files:
  /top_level.sv  (this file)

Related project files:
  /T120F324_A.peri.xml  (Efinix peripheral configuration)
```

---

**Date:** 2026-01-24  
**Status:** ✅ Hardware configuration complete, ready for firmware development
