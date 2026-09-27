# How to Update SPI Flash Over 100M Ethernet

## 1. Overview
The FPGA running the 100M Ethernet core (IP: `192.168.1.50`) listens on **UDP Port 5000**. The Sapphire RISC-V SoC firmware acts as an in-system SPI Flash programmer for the external Winbond W25Q128JV (16 MB) chip.

---

## 2. Quick Command Reference

All commands are run from the project root (`/home/olle/efinity_p2/BRAM/T120F324_A`):

### Step A: Verify Network & SPI Flash Communication
```bash
# 1. Verify Ethernet ping
ping -c 3 192.168.1.50

# 2. Query Flash JEDEC ID over Ethernet
python3 eth_flash.py --ping
```
*Expected Output:*
```text
[*] Querying FPGA at 192.168.1.50:5000 for SPI Flash ID...
[+] SUCCESS: Found SPI Flash! JEDEC ID = 0xEF4018
    Chip: Winbond W25Q128JV (16 MByte / 128 Mbit)
```

---

### Step B: Inspect Stored Flash Data (Optional)
To dump the first 64 bytes of the bitstream currently stored in SPI flash:
```bash
python3 eth_flash.py --dump 64 --addr 0x000000
```
*Expected Output:*
```text
[*] Reading 64 bytes from 0x000000...
000000: 56 65 72 73 69 6F 6E 3A 20 32 30 32 35 2E 32 2E   |Version: 2025.2.|
000010: 32 38 38 2E 32 2E 31 30 0A 47 65 6E 65 72 61 74   |288.2.10.Generat|
...
```

---

### Step C: Flash a New Bitstream over Ethernet

When you build your FPGA project with Efinity, it generates `outflow/T120F324_A.hex`.
You can flash it directly over Ethernet with a single command:

```bash
python3 eth_flash.py outflow/T120F324_A.hex
```

#### What happens during execution:
1. **Parses the `.hex` bitstream** into ~3.55 MB of binary data (~0.9s).
2. **Erases Flash:** Erases the required sectors using fast 64KB block erases (`0xD8`) (~8s).
3. **Programs Pages:** Transmits 256-byte pages over UDP packets to the FPGA (~12s).
4. **Verifies Data:** Reads back every byte from flash over Ethernet and compares against the local file to guarantee 100% data integrity (~10s).
5. **Boot:** Power cycle the board, or pulse reset to boot the newly flashed design.

---

## 3. Command Options (`eth_flash.py` / `reflash_fpga.py`)

| Flag | Description | Default |
| :--- | :--- | :--- |
| `--addr <hex>` | Set SPI Flash target address (e.g. `0x000000` or `0x400000`) | `0x000000` |
| `--dump <N>` | Read and display `<N>` bytes from flash | `0` (disabled) |
| `--no-verify` | Skip read-back verification (saves ~10 seconds) | `False` |
| `--verify-only` | Only verify flash contents against bitstream file without erasing/writing | `False` |
| `--ping` | Query and verify SPI Flash JEDEC ID | `False` |

### Multi-Boot Example (AN010 Multi-Image):
If you want to keep the Golden Image at `0x000000` and flash a test image at Image 1 (offset `0x400000`):
```bash
python3 eth_flash.py outflow/T120F324_A.hex --addr 0x400000
```

---

## 4. Troubleshooting & Notes

- **UART Console:**
  Keep your terminal open on `/dev/ttyACM0` (external Arduino Uno at 115200 baud) to monitor boot and PHY status messages.
- **FTDI Ports:**
  **Never** open `/dev/ttyUSB0` or `/dev/ttyUSB1` as serial terminals. They are reserved for JTAG and OpenOCD.
- **Link Up Time:**
  After power-on or FPGA bitstream reload, wait ~10–12 seconds for the reset counter (`5.37s`) and RTL8211F PHY auto-negotiation (`~4s`) before pinging or reflashing.

