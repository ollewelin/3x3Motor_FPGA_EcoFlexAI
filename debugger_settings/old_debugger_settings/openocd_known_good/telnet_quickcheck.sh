#!/usr/bin/env bash
set -euo pipefail

HOST=${1:-127.0.0.1}
PORT=${2:-4444}

# Send a minimal, safe sequence to OpenOCD's telnet server.
# This avoids Eclipse/GDB side effects and helps answer:
# - Can OpenOCD halt the CPU?
# - If halted, what is the PC?
# - Can we resume?

cmds=$(
  cat <<'EOF'
targets
# Try halting (may time out depending on SoC debug state)
halt
reg pc
# Resume (won't do anything if halt failed)
resume
exit
EOF
)

echo "Connecting to OpenOCD telnet at ${HOST}:${PORT}..." >&2

# nc sometimes blocks even with -w; wrap in timeout.
if command -v timeout >/dev/null 2>&1; then
  timeout 5 bash -lc "printf '%s' \"${cmds//$'\n'/\\n}\n\" | nc -w 2 ${HOST} ${PORT}"
else
  printf '%s' "${cmds}" | nc -w 2 "${HOST}" "${PORT}"
fi
