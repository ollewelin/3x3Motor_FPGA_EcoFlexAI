#!/bin/bash
# Flash outflow/T120F324_A.hex to SPI Flash via JTAG Bridge (Efinity Programmer CLI)
# Step 1: Load Trion T120 JTAG-to-SPI Bridge bitstream into FPGA SRAM
# Step 2: Write outflow/T120F324_A.hex to external SPI Flash using the bridge
set -e

PROJECT_ROOT="/home/olle/efinity_p2/BRAM/T120F324_A"
EFINITY_HOME="/home/olle/efinix2/efinity-2025.2.288.2.10-linux-x64/efinity/2025.2"
FLI_BIT="$EFINITY_HOME/pgm/fli/trion/u00220A79_t120.bit"
HEX="$PROJECT_ROOT/outflow/T120F324_A.hex"

source "$EFINITY_HOME/bin/setup.sh"

echo "[1/2] Loading JTAG-to-SPI Bridge into FPGA SRAM..."
"$EFINITY_HOME/pgm/bin/ftdi_pgm.sh" -m jtag "$FLI_BIT"

echo "[2/2] Programming SPI Flash via JTAG Bridge..."
"$EFINITY_HOME/pgm/bin/ftdi_pgm.sh" -m jtag_bridge \
  --jtag_bridge_mode all \
  --verify_method onchipx2 \
  "$HEX"

echo ""
echo "=== Flash complete! ==="
echo "Power-cycle the board. Ping should arrive within ~10-12 seconds."
