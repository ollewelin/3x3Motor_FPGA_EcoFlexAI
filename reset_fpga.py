#!/usr/bin/env python3
"""
reset_fpga.py - Hardware Reset Efinix T120 FPGA via FT2232 ADBUS4 (P_CRESET_N)

Hardware Connection:
  FT2232H Pin 21 (ADBUS4 / GPIOL0) -> Jumper -> T120_CRESET_N (Pin N17)
"""

import sys
import os
import time

# Auto-add Efinity's bundled pyftdi and pyusb paths
efinity_paths = [
    "/home/olle/efinix2/efinity-2025.2.288.2.10-linux-x64/efinity/2025.2/lib/python3.11/site-packages",
    "/home/olle/efinix2/efinity-2025.2.288.2.10-linux-x64/efinity/2025.2/lib/python3.10/site-packages",
    "/home/olle/efinix2/efinity-2025.2.288.2.10-linux-x64/efinity/2025.2/pgm/bin/efx_pgm"
]
for p in efinity_paths:
    if os.path.isdir(p) and p not in sys.path:
        sys.path.insert(0, p)

try:
    from pyftdi.gpio import GpioAsyncController
except ImportError:
    print("[-] Error: pyftdi not found.")
    print("    Please run: source /home/olle/efinix2/efinity-2025.2.288.2.10-linux-x64/efinity/2025.2/bin/setup.sh")
    sys.exit(1)

def reset_fpga(pulse_ms=100):
    gpio = GpioAsyncController()
    try:
        # FT2232 Channel 1 (Port A, ADBUS)
        # ADBUS4 = bit 4 (0x10)
        PIN_CRESET_N = 0x10
        gpio.open_from_url('ftdi://ftdi:2232:1/1', direction=PIN_CRESET_N)

        print("[*] Asserting T120_CRESET_N LOW (Resetting FPGA)...")
        gpio.write(0x00)
        time.sleep(pulse_ms / 1000.0)

        print("[*] Releasing T120_CRESET_N HIGH (FPGA booting from SPI Flash)...")
        gpio.write(PIN_CRESET_N)
        time.sleep(0.02)

        # High-Z (input)
        gpio.set_direction(PIN_CRESET_N, 0x00)
        gpio.close()
        print("[+] Reset pulse complete!")
        return True
    except Exception as e:
        print(f"[-] FTDI GPIO Error: {e}")
        return False

if __name__ == "__main__":
    reset_fpga()
