#!/usr/bin/env python3
"""
Read 192x192 RAW8 pixel frame from serial (ASCII-HEX format) after 'S' marker.
Extracts and saves first line for VSYNC debugging.
"""
import argparse
import binascii
import serial
import sys
import time

WSCHARS = b"\r\n\t "

# 192x192 RAW8 frame parameters
PIXEL_WIDTH = 192          # pixels per line
PIXEL_HEIGHT = 192         # lines per frame
TOTAL_BYTES = PIXEL_WIDTH * PIXEL_HEIGHT  # 36,864 bytes for full frame
FIRST_LINE_BYTES = PIXEL_WIDTH  # 192 bytes for first line only

def read_until_sync(ser, sync=b"S", timeout=None):
    """Block until we see the sync byte; raise on timeout if given."""
    t0 = time.time()
    while True:
        b = ser.read(1)
        if b == sync:
            return
        if timeout is not None and (time.time() - t0) > timeout:
            raise TimeoutError("Timed out waiting for sync 'S'")

def nibble_of(byte):
    """Return 0..15 for hex digit byte (0-9, A-F, a-f), else None."""
    if 48 <= byte <= 57:     # '0'..'9'
        return byte - 48
    lo = byte | 0x20         # to lower
    if 97 <= lo <= 102:      # 'a'..'f'
        return lo - 87
    return None

def read_ascii_hex_bytes(ser, n_bytes, timeout=None, stop_on_next_S=False):
    """
    Read ASCII hex digits, ignoring whitespace, and decode into exactly n_bytes.
    If stop_on_next_S is True, abort if 'S' appears before finishing.
    """
    out = bytearray()
    hi = None
    t0 = time.time()

    while len(out) < n_bytes:
        b = ser.read(1)
        if not b:
            if timeout is not None and (time.time() - t0) > timeout:
                raise TimeoutError(f"Timed out reading payload ({len(out)} / {n_bytes} bytes)")
            continue

        val = b[0]
        if stop_on_next_S and val == 0x53:  # 'S'
            raise RuntimeError("Encountered a new 'S' before finishing payload")

        t0 = time.time()  # activity resets timeout

        if val in WSCHARS:
            continue

        n = nibble_of(val)
        if n is None:
            # ignore any non-hex garbage safely
            continue

        if hi is None:
            hi = n
        else:
            out.append((hi << 4) | n)
            hi = None

    return bytes(out)

def hexdump_preview(data, maxlen=128):
    """Print a short hex preview of the data."""
    s = binascii.hexlify(data[:maxlen]).decode()
    print(" ".join(s[i:i+2] for i in range(0, len(s), 2)))
    if len(data) > maxlen:
        print(f"... ({len(data)-maxlen} more bytes)")

def save_hex_dump(filename, data):
    """Save data as formatted hex (16 bytes per line, like hexdump -C)."""
    with open(filename, 'w') as f:
        for i in range(0, len(data), 16):
            chunk = data[i:i+16]
            hex_str = ' '.join(f'{b:02X}' for b in chunk)
            ascii_str = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
            f.write(f'{i:08X}  {hex_str:<48}  {ascii_str}\n')

def save_first_line_analysis(filename, first_line_data):
    """
    Save detailed analysis of the first line for VSYNC debugging.
    """
    with open(filename, 'w') as f:
        f.write("=" * 80 + "\n")
        f.write("FIRST LINE ANALYSIS (192 bytes for VSYNC debugging)\n")
        f.write("=" * 80 + "\n\n")
        
        f.write(f"Frame: 192x192 pixels (RAW8)\n")
        f.write(f"First line size: {len(first_line_data)} bytes\n")
        f.write(f"Expected: {FIRST_LINE_BYTES} bytes\n\n")
        
        # Statistics
        if len(first_line_data) > 0:
            values = list(first_line_data)
            f.write("Statistics:\n")
            f.write(f"  Min value: 0x{min(values):02X} ({min(values):3d})\n")
            f.write(f"  Max value: 0x{max(values):02X} ({max(values):3d})\n")
            f.write(f"  Mean value: {sum(values) / len(values):.1f}\n")
            f.write(f"  All zeros: {all(v == 0 for v in values)}\n")
            f.write(f"  All 0xFF: {all(v == 0xFF for v in values)}\n\n")
        
        # Hex dump with line numbers for pixel mapping
        f.write("Hex dump (16 bytes per line):\n")
        f.write("-" * 80 + "\n")
        for i in range(0, len(first_line_data), 16):
            chunk = first_line_data[i:i+16]
            pixel_start = i
            pixel_end = min(i + 16, len(first_line_data))
            hex_str = ' '.join(f'{b:02X}' for b in chunk)
            f.write(f'Pixels {pixel_start:3d}-{pixel_end-1:3d}:  {hex_str}\n')
        
        f.write("\n")
        f.write("-" * 80 + "\n")
        f.write("All bytes in sequence (space-separated hex):\n")
        f.write("-" * 80 + "\n")
        hex_line = ' '.join(f'{b:02X}' for b in first_line_data)
        # Print in 80-char chunks for readability
        for i in range(0, len(hex_line), 80):
            f.write(hex_line[i:i+80] + "\n")
        
        f.write("\n")
        f.write("=" * 80 + "\n")

def main():
    ap = argparse.ArgumentParser(
        description="Read 192x192 RAW8 frame from serial after 'S' marker, "
                    "with first-line VSYNC debugging"
    )
    ap.add_argument("port", help="e.g. /dev/ttyACM0")
    ap.add_argument("baud", type=int, help="e.g. 115200")
    ap.add_argument("-o", "--out", default="frame_192x192.bin", 
                    help="output binary file (default: frame_192x192.bin)")
    ap.add_argument("--first-line-hex", default="first_line.hex", 
                    help="output hex file for first line (default: first_line.hex)")
    ap.add_argument("--first-line-analysis", default="first_line_analysis.txt", 
                    help="detailed analysis file (default: first_line_analysis.txt)")
    ap.add_argument("--sync-timeout", type=float, default=None, 
                    help="seconds to wait for 'S' (default: infinite)")
    ap.add_argument("--read-timeout", type=float, default=None, 
                    help="seconds to wait while reading payload (default: infinite)")
    ap.add_argument("--stop-on-next-S", action="store_true", 
                    help="abort if another 'S' appears mid-payload")
    ap.add_argument("--preview", action="store_true", 
                    help="print a short hexdump preview")
    args = ap.parse_args()

    ser = serial.Serial(
        args.port,
        baudrate=args.baud,
        bytesize=8,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        timeout=0.2,   # small poll; loops handle blocking semantics
        xonxoff=False,
        rtscts=False,
        dsrdtr=False,
        write_timeout=1,
        exclusive=True if hasattr(serial.Serial, "exclusive") else False,
    )

    try:
        # start clean
        ser.reset_input_buffer()

        print(f"Waiting for 'S' on {args.port} @ {args.baud}...", flush=True)
        read_until_sync(ser, sync=b"S", timeout=args.sync_timeout)
        print("Sync 'S' detected. Reading ASCII-HEX payload...", flush=True)
        print(f"Reading {TOTAL_BYTES} bytes (192x192 pixels @ RAW8)...", flush=True)

        data = read_ascii_hex_bytes(
            ser,
            n_bytes=TOTAL_BYTES,
            timeout=args.read_timeout,
            stop_on_next_S=args.stop_on_next_S
        )

        # Write full frame
        with open(args.out, "wb") as f:
            f.write(data)
        print(f"✓ Wrote {len(data)} bytes to {args.out}")

        # Extract and save first line only
        if len(data) >= FIRST_LINE_BYTES:
            first_line = data[:FIRST_LINE_BYTES]
            
            # Save as formatted hex
            save_hex_dump(args.first_line_hex, first_line)
            print(f"✓ Saved first line ({len(first_line)} bytes) to {args.first_line_hex}")
            
            # Save detailed analysis
            save_first_line_analysis(args.first_line_analysis, first_line)
            print(f"✓ Saved first line analysis to {args.first_line_analysis}")
            
            print(f"\n[FIRST LINE DEBUG INFO]")
            print(f"  Pixels: {len(first_line)} bytes")
            print(f"  File: {args.first_line_hex}")
            print(f"  Analysis: {args.first_line_analysis}")
        else:
            print(f"⚠ Warning: received only {len(data)} bytes, expected {TOTAL_BYTES}")

        if args.preview:
            print("\n[FULL FRAME PREVIEW]")
            hexdump_preview(data)

    finally:
        ser.close()

if __name__ == "__main__":
    main()
