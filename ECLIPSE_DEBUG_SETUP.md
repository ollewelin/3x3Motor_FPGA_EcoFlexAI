# Eclipse RISC-V IDE Debug Setup - T120F324_A

## Current Status
- ✅ **Efinix OpenOCD** installed at `/home/olle/efinix/efinity/2025.1/debugger/openocd/bin/openocd` (includes `vexriscv` target support)
- ✅ **FTDI device detected** (VID:PID 0x0403:0x6010 "Dual RS232-HS")
- ✅ **FPGA JTAG TAP detected** (IDCODE `0x00220a79`)
- ✅ **Core examinable + GDB server works** when using the VexRiscv (non-standard) debug path.

Notes:
- Stock OpenOCD builds (e.g. `/usr/local/bin/openocd`) typically do **not** include the `vexriscv` target type; if you force the `riscv` path you’ll hit `Unsupported DTM version: -1` because this SoC build doesn’t expose a standard RISC-V DTM.

## Updated OpenOCD Configuration
- **Location**: `/home/olle/efinity_p2/BRAM/T120F324_A/embedded_sw/RISC_V_standard_A/bsp/efinix/EfxSapphireSoc/openocd/`
- **Files**: `ftdi.cfg` and `debug.cfg` updated for T120F324_A project
- **Key changes**:
  - Device descriptor: "Dual RS232-HS" (matches actual hardware)
   - STANDARD_DEBUG=0 by default (uses `vexriscv`, matches `cpu0.yaml`)
   - `halt` is wrapped with `catch` so OpenOCD doesn't abort immediately
   - Added tunables to `debug.cfg` so you can quickly try alternate BSCAN tunnel settings

## Eclipse Launch Configuration Steps

### 1. Update OpenOCD Path
In Eclipse debug launch configuration:
- **GDB Server Executable**: `/home/olle/efinix/efinity/2025.1/debugger/openocd/bin/openocd`
- This is required for `vexriscv` target support.

### 2. OpenOCD Configuration Files
```
-f /home/olle/efinity_p2/BRAM/T120F324_A/embedded_sw/RISC_V_standard_A/bsp/efinix/EfxSapphireSoc/openocd/ftdi.cfg
-f /home/olle/efinity_p2/BRAM/T120F324_A/embedded_sw/RISC_V_standard_A/bsp/efinix/EfxSapphireSoc/openocd/debug.cfg
```

### 3. GDB Connection Settings
- **Host**: localhost
- **Port**: 3333
- **Use remote target**: YES

### 4. GDB Initialization Commands
```
set mem inaccessible-by-default off
monitor reset halt
break main
continue
```

### 5. Load Image Settings
- **Use project binary**: YES
- **Load symbols**: YES
- **Load image**: YES
- **Target ELF**: `./build/mdio_test.elf` (or your test program)

## Testing Connection

### Test 1: OpenOCD Startup
```bash
cd /home/olle/efinity_p2/BRAM/T120F324_A/embedded_sw/RISC_V_standard_A/bsp/efinix/EfxSapphireSoc/openocd
openocd -f ftdi.cfg -f debug.cfg
```
Should show:
```
Info : JTAG tap: fpga_spinal.bridge tap/device found: 0x00220a79
Info : [fpga_spinal.cpu0] starting gdb server on 3333
Info : Listening on port 3333 for gdb connections
```

### Test 2: GDB Connection
```bash
riscv-none-embed-gdb
target remote localhost:3333
monitor reset halt
file ./build/mdio_test.elf
load
break main
continue
```

## Known Limitations
1. **Standard RISC-V DTM debugging is not available in this SoC build**
   - `cpu0.yaml` reports `vexriscv.DebugReport`, and OpenOCD needs the `vexriscv` target driver.
   - If you want a standard RISC-V DTM/DM flow, the SoC/IP would need to be regenerated to expose it, and OpenOCD would need matching support.

## Quick Eclipse Checklist
- [ ] Launch configuration uses `/home/olle/efinix/efinity/2025.1/debugger/openocd/bin/openocd`
- [ ] Config files point to T120F324_A paths (not old micro_risc_v1)
- [ ] Device descriptor in ftdi.cfg matches hardware ("Dual RS232-HS")
- [ ] GDB port 3333 in launch config
- [ ] ELF file path correct in launch config
- [ ] Python environment clean (PYTHONHOME not set)

## Reload Eclipse IDE
Once configs are updated:
1. Close all debug sessions
2. Restart Eclipse RISC-V IDE
3. Create new debug launch configuration with updated paths
4. Test first debug session

## Troubleshooting
If "Device not found" error:
- Check: `lsusb | grep 0403` (should show FT2232C DUAL UART)
- Verify: FTDI device descriptor is "Dual RS232-HS"

If OpenOCD sees the FPGA TAP but **fails DTM** (`Unsupported DTM version: -1`) or complains about **unknown target type `vexriscv`**:

1) Confirm the CPU is alive (UART)
- The board enumerates a serial port at `/dev/ttyUSB0` (FTDI interface 00).
- BSP defaults to `115200` baud.
- Try: `picocom -b 115200 /dev/ttyUSB0` (or `minicom -D /dev/ttyUSB0 -b 115200`).

2) Use the Efinix OpenOCD build and the VexRiscv path
- Ensure `STANDARD_DEBUG` is `0` in `ftdi.cfg` (default in this workspace).
- Ensure Eclipse points at the Efinix OpenOCD binary (see step 1 above).

3) Only if you are intentionally experimenting with standard DTM via BSCAN
- `debug.cfg` supports overrides (`_BSCAN_TUNNEL_IR`, `_BSCAN_TUNNEL_PARAM0`, `_BSCAN_TUNNEL_PARAM1`), but this is not expected to work with the current SoC build.

## Getting your `.bin` running on the SoC

### Option A: Load into RAM while debugging (fast iteration)
- Build your app to produce both `*.elf` and `*.bin` (example already present: `software/standalone/mdio_test/build/mdio_test.{elf,bin}`).
- Use the provided Eclipse launch file [embedded_sw/RISC_V_standard_A/software/standalone/mdio_test/mdio_test_trion.launch](embedded_sw/RISC_V_standard_A/software/standalone/mdio_test/mdio_test_trion.launch) as a template:
  - Symbols: `.../build/<app>.elf`
  - Image: `.../build/<app>.bin`
  - OpenOCD: `/usr/local/bin/openocd`

### Option B: Boot the `.bin` automatically at power-up (BRAM init files)
The Sapphire SoC RAM is initialized from `EfxSapphireSoc.v_toplevel_system_ramA_logic_ram_symbol*.bin` files. By default these contain the SPI-flash bootloader; you can regenerate them from your application `.bin`:

1) Ensure Efinity environment is loaded:
   - `source ${EFINITY_HOME}/bin/setup.sh`
2) Generate init bins:
   - `cd embedded_sw/RISC_V_standard_A/tool`
   - `python3 binGen.py -b ../software/standalone/<app>/build/<app>.bin -f 0 -s 8192`
3) Copy the generated files from `embedded_sw/RISC_V_standard_A/tool/rom/` into the IP folder used by your build (commonly `ip/RISC_V_standard_A/`), replacing the existing `EfxSapphireSoc.v_toplevel_system_ramA_logic_ram_symbol*.bin`.
4) Re-run Efinity compile to rebuild the `.bit`, then program it.

If OpenOCD won't start:
- Check: OpenOCD version is 0.12.0+ (`openocd --version`)
- Check: Config files exist and have correct paths
- Check: No other OpenOCD instance running on port 3333
