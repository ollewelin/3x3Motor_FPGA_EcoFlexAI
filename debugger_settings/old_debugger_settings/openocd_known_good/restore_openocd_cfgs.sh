#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

SRC_DIR="${ROOT_DIR}/debugger_settings/openocd_known_good"
DST_OPENOCD_DIR="${ROOT_DIR}/embedded_sw/RISC_V_standard_A/bsp/efinix/EfxSapphireSoc/openocd"
DST_LAUNCH_FILE="${ROOT_DIR}/embedded_sw/RISC_V_standard_A/software/standalone/mdio_test/mdio_test_trion.launch"
DST_LAUNCH_ATTACH_ONLY_FILE="${ROOT_DIR}/embedded_sw/RISC_V_standard_A/software/standalone/mdio_test/mdio_test_trion_attach_only.launch"

mkdir -p "${DST_OPENOCD_DIR}"

cp -f "${SRC_DIR}/ftdi.cfg"  "${DST_OPENOCD_DIR}/ftdi.cfg"
cp -f "${SRC_DIR}/debug.cfg" "${DST_OPENOCD_DIR}/debug.cfg"
cp -f "${SRC_DIR}/mdio_test_trion.launch" "${DST_LAUNCH_FILE}"
cp -f "${SRC_DIR}/mdio_test_trion_attach_only.launch" "${DST_LAUNCH_ATTACH_ONLY_FILE}"

echo "Restored OpenOCD configs to: ${DST_OPENOCD_DIR}"
echo "Restored Eclipse launch to: ${DST_LAUNCH_FILE}"
echo "Restored Eclipse launch (attach-only) to: ${DST_LAUNCH_ATTACH_ONLY_FILE}"
