#!/usr/bin/env bash
set -euo pipefail

# Restore RISC_mini OpenOCD configs from debugger_settings to BSP openocd folder
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="${ROOT_DIR}/RISC_mini_debugg_config/openocd"
DST_OPENOCD_DIR="${ROOT_DIR}/../embedded_sw/RISC_mini/bsp/efinix/EfxSapphireSoc/openocd"

# Make sure source files exist
for f in "${SRC_DIR}/ftdi.cfg" "${SRC_DIR}/debug.cfg"; do
    if [ ! -f "${f}" ]; then
        echo "ERROR: Required file not found: ${f}" >&2
        exit 1
    fi
done

# Create destination dir if needed
mkdir -p "${DST_OPENOCD_DIR}"

# Backup existing files if present
TS="$(date +%Y%m%d_%H%M%S)"
for f in ftdi.cfg debug.cfg; do
    if [ -f "${DST_OPENOCD_DIR}/${f}" ]; then
        cp -a "${DST_OPENOCD_DIR}/${f}" "${DST_OPENOCD_DIR}/${f}.bak.${TS}"
        echo "Backed up ${DST_OPENOCD_DIR}/${f} -> ${DST_OPENOCD_DIR}/${f}.bak.${TS}"
    fi
    cp -f "${SRC_DIR}/${f}" "${DST_OPENOCD_DIR}/${f}"
    echo "Restored ${f} -> ${DST_OPENOCD_DIR}/${f}"
done

cat <<'EOF'
Done. To use these configs in Eclipse/OpenOCD: 
  - Restart OpenOCD/Eclipse or run OpenOCD with your usual command
  - If BSP is regenerated later, re-run this script to re-apply the known-good configs
EOF
