#!/bin/bash
set -e

PROJECT_ROOT="/home/olle/efinity_p2/BRAM/T120F324_A"
EFINITY_HOME="/home/olle/efinix2/efinity-2025.2.288.2.10-linux-x64/efinity/2025.2"
TOOLCHAIN="/home/olle/efinity/efinity-riscv-ide-2025.1/toolchain/bin"
FW_BUILD="$PROJECT_ROOT/embedded_sw/RISC_mini/software/standalone/test_b/build"
TOOL="$PROJECT_ROOT/embedded_sw/RISC_mini/tool"
IP="$PROJECT_ROOT/ip/RISC_mini"
RAM_SIZE=131072     # 128 KiB on-chip SRAM

export PATH="$TOOLCHAIN:$PATH"
source "$EFINITY_HOME/bin/setup.sh"

echo "=== [1/5] Compile firmware ==="
cd "$PROJECT_ROOT/embedded_sw/RISC_mini/software/standalone/test_b"
make BSP=efinix/EfxSapphireSoc

echo "=== [2/5] Generate BRAM init files ==="
cd "$TOOL"
python3 binGen.py -b "$FW_BUILD/test_b.bin" -f 0 -s $RAM_SIZE

echo "=== [3/5] Copy BRAM files to IP directory ==="
cp "$TOOL/rom/EfxSapphireSoc."*.bin "$IP/"

echo "=== [4/5] Patch bitstream (efx_bram_update) ==="
cd "$PROJECT_ROOT"
efx_bram_update \
  -j T120F324_A.xml \
  -b "u_sapphire_soc/u_EfxSapphireSoc/system_ramA_logic/ram_symbol0,$IP/EfxSapphireSoc.v_toplevel_system_ramA_logic_ram_symbol0.bin" \
  -b "u_sapphire_soc/u_EfxSapphireSoc/system_ramA_logic/ram_symbol1,$IP/EfxSapphireSoc.v_toplevel_system_ramA_logic_ram_symbol1.bin" \
  -b "u_sapphire_soc/u_EfxSapphireSoc/system_ramA_logic/ram_symbol2,$IP/EfxSapphireSoc.v_toplevel_system_ramA_logic_ram_symbol2.bin" \
  -b "u_sapphire_soc/u_EfxSapphireSoc/system_ramA_logic/ram_symbol3,$IP/EfxSapphireSoc.v_toplevel_system_ramA_logic_ram_symbol3.bin"

echo "=== [5/5] Re-generate outflow hex ==="
cd "$PROJECT_ROOT"
bash work_pnr/run_efx_pgm.sh

echo ""
echo "=========================================="
echo "Done!  outflow/T120F324_A.hex is ready."
echo "To flash:  python3 eth_flash.py outflow/T120F324_A.hex"
echo "=========================================="

