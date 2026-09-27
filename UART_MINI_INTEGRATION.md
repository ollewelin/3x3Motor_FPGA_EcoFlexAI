# uart_mini APB3 Integration Guide

## Overview
This document describes the integration of the standalone `uart_mini.sv` UART core with the RISC_mini SoC via the APB3 bus, replacing the problematic SoC UART with a custom hardware/firmware solution.

## Files Created/Modified

### 1. Hardware IP Files
**Location:** `/home/olle/efinity_p2/BRAM/T120F324_A/ip/uart_mini/`

#### `uart_mini.sv` (NEW)
- Standalone UART transceiver with independent RX and TX engines
- 32-byte FIFO buffers for both TX and RX
- Configurable baud rate and clock frequency
- 16x oversampling for reliable reception
- LSB-first transmission (standard UART)
- **Features:**
  - No external SoC dependencies
  - All logic contained in one module
  - Easy to instantiate multiple instances

#### `uart_mini_apb3.sv` (NEW)
- APB3 slave wrapper for uart_mini
- Maps uart_mini to APB3 register interface
- **Register Map (at 0xf8100000):**
  - `0x00` - UART_CTRL: Control register (write-only)
  - `0x04` - UART_STATUS: FIFO flags (read-only)
    - [0] = tx_empty
    - [1] = tx_full
    - [2] = rx_empty
    - [3] = rx_full
  - `0x08` - UART_TX_DATA: TX byte to transmit (write-only)
  - `0x0C` - UART_RX_DATA: RX byte received (read-only)
  - `0x10` - UART_RX_CTRL: RX strobe/pop control (write-only)

### 2. Firmware Driver Files
**Location:** `/home/olle/efinity_p2/BRAM/T120F324_A/embedded_sw/RISC_mini/bsp/efinix/EfxSapphireSoc/include/`

#### `uart_mini_driver.h` (NEW)
- C language driver header for uart_mini APB3 peripheral
- **Key Functions:**
  ```c
  void uart_mini_init(void)                    // Initialize (no-op)
  uint8_t uart_mini_get_status(void)           // Read status flags
  int uart_mini_tx_ready(void)                 // Check TX FIFO not full
  int uart_mini_rx_available(void)             // Check RX FIFO not empty
  int uart_mini_tx_byte(uint8_t data)          // Write byte (non-blocking)
  int uart_mini_rx_byte(uint8_t *data)         // Read byte (non-blocking)
  void uart_mini_tx_byte_blocking(uint8_t)     // Write byte (blocking)
  uint8_t uart_mini_rx_byte_blocking(void)     // Read byte (blocking)
  void uart_mini_tx_string(const char *str)    // Write string (blocking)
  ```

### 3. Application Test File
**Location:** `/home/olle/efinity_p2/BRAM/T120F324_A/embedded_sw/RISC_mini/software/standalone/test_b/src/`

#### `test_b.c` (UPDATED)
- Replaced old Ethernet/UART code with uart_mini tests
- **Three test sequences:**
  1. **Test 1:** Loopback test - Send 'A', verify reception
  2. **Test 2:** LED blink indicator - FAST = success, SLOW = failure
  3. **Test 3:** Continuous TX - Send "HELLO\r\n" repeatedly for oscilloscope probing

## Hardware Integration Steps

### Step 1: Add uart_mini_apb3 to top_level.sv
In your [top_level.sv](top_level.sv), instantiate uart_mini_apb3:

```verilog
// At top level
uart_mini_apb3 uart_mini_inst (
    .pclk(clk_50mhz),
    .presetn(reset_n),
    .psel(io_apbSlave_0_PSEL),
    .penable(io_apbSlave_0_PENABLE),
    .pwrite(io_apbSlave_0_PWRITE),
    .paddr(io_apbSlave_0_PADDR),
    .pwdata(io_apbSlave_0_PWDATA),
    .prdata(io_apbSlave_0_PRDATA),
    .pready(io_apbSlave_0_PREADY),
    .pslverr(io_apbSlave_0_PSLVERR),
    .uart_txd(fpga_uart_tx),
    .uart_rxd(fpga_uart_rx)
);
```

### Step 2: Verify Pin Configuration in .peri.xml
Your current configuration (after swap) should be:
```xml
<efxpt:gpio name="fpga_uart_rx" gpio_def="GPIOB_TXP14" mode="input" .../>
<efxpt:gpio name="fpga_uart_tx" gpio_def="GPIOB_TXN14" mode="output" .../>
```

**Physical Mapping:**
- `fpga_uart_tx` (GPIOB_TXN14) → P10 on XB2 connector (your oscilloscope probe point)
- `fpga_uart_rx` (GPIOB_TXP14) → N10 on XB3 connector
- These are the correct pins wired to your FTDI2232 ADBUS0/ADBUS1

### Step 3: Remove Old SoC UART References
- The `soc.h` has already been updated (SoC UART removed from definition)
- No longer need `uart_write()`, `uart_read()`, `uart_readOccupancy()` from old driver

## Firmware Integration

### Include the Driver
```c
#include "uart_mini_driver.h"
```

### Basic Usage Pattern
```c
// Initialize (optional, auto-initializes)
uart_mini_init();

// Non-blocking TX
if (uart_mini_tx_ready()) {
    uart_mini_tx_byte('A');
}

// Non-blocking RX
uint8_t data;
if (uart_mini_rx_available()) {
    uart_mini_rx_byte(&data);
}

// Blocking operations
uart_mini_tx_byte_blocking('A');     // Wait until sent
uint8_t c = uart_mini_rx_byte_blocking();  // Wait for data
uart_mini_tx_string("HELLO\r\n");    // Send string
```

## Testing & Verification

### Compilation Test
```bash
cd embedded_sw/RISC_mini/software/standalone/test_b
make clean && make
# Expected: 0 errors, 0 warnings
```

### Hardware Test Sequence
1. **Resynthesize FPGA** - Generate bitstream with updated top_level.sv
2. **Program FPGA** - Load new bitstream
3. **Connect oscilloscope** - Probe P10 (fpga_uart_tx from GPIOB_TXN14)
4. **Run firmware** - Execute test_b
5. **Observe:**
   - **LED indicator:** FAST blink = uart_mini working, SLOW blink = not working
   - **Oscilloscope:** UART bit patterns on P10 during "HELLO" transmission

### Expected Oscilloscope Waveform
- Baud Rate: 115200 (bit time ≈ 8.7 µs)
- Each "HELLO" = 5 bytes + CR + LF = 7 bytes = ~61 µs transmission
- Start bit: 0 (LOW)
- Data bits: LSB first
- Stop bit: 1 (HIGH)
- Idle: HIGH (3.3V)

## Pin Details

| Signal | Pin | GPIO | Direction |
|--------|-----|------|-----------|
| `fpga_uart_tx` | P10 (XB2) | GPIOB_TXN14 | Output |
| `fpga_uart_rx` | N10 (XB3) | GPIOB_TXP14 | Input |
| LED (GPIO_0) | CAM3_SDA_OUT | - | Output |

## Address Map

| Peripheral | Base Address | Size | Bus |
|------------|-------------|------|-----|
| uart_mini (APB3) | 0xf8100000 | 0x14 | APB3 |
| RISC_mini SoC | - | - | Internal |

## Troubleshooting

### P10 Still Shows Constant 3.3V
- **Cause:** Pin not connected to UART TX in FPGA design
- **Solution:** Check that top_level.sv properly wires `fpga_uart_tx` to UART output
- **Verify:** In RTL: `assign fpga_uart_tx = sapphire_uart_txd;`

### LED Blinks SLOW (250ms)
- **Cause:** uart_mini not receiving loopback character
- **Possible Issues:**
  - FPGA not programmed with loopback enabled (top_level.sv `LOOPBACK_TEST`)
  - Internal loopback not connected in RTL
  - UART core not initialized
- **Solution:** Verify FPGA bitstream is current and loopback wire is in place

### P10 Has Activity But No "HELLO" Output on Terminal
- **Cause:** Pin routing works, but external terminal not receiving
- **Issue:** FTDI2232 may be using different channel or baud rate mismatch
- **Solution:** Verify external terminal is on correct /dev/ttyUSB port at 115200 baud

## Future Enhancements

Possible improvements to uart_mini:
1. Add interrupt support (RX data available, TX empty)
2. Add configurable data length (5-8 bits)
3. Add parity bit support
4. Add flow control (CTS/RTS)
5. Implement DMA interface for bulk transfers

## References

- [uart_mini.sv](../ip/uart_mini/uart_mini.sv) - Core UART implementation
- [uart_mini_apb3.sv](../ip/uart_mini/uart_mini_apb3.sv) - APB3 wrapper
- [uart_mini_driver.h](../embedded_sw/RISC_mini/bsp/efinix/EfxSapphireSoc/include/uart_mini_driver.h) - C driver
- [test_b.c](../embedded_sw/RISC_mini/software/standalone/test_b/src/test_b.c) - Test application
