#!/usr/bin/env python3
import argparse
import binascii
import serial
import sys
import time

WSCHARS = b"\r\n\t "

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
    s = binascii.hexlify(data[:maxlen]).decode()
    print(" ".join(s[i:i+2] for i in range(0, len(s), 2)))
    if len(data) > maxlen:
        print(f"... ({len(data)-maxlen} more bytes)")

def main():
    ap = argparse.ArgumentParser(description="Read ASCII-HEX from serial after a single 'S' marker")
    ap.add_argument("port", help="e.g. /dev/ttyACM0")
    ap.add_argument("baud", type=int, help="e.g. 115200")
    ap.add_argument("nbytes", type=int, help="decoded payload size in bytes")
    ap.add_argument("-o", "--out", default="frame.bin", help="output file (default: frame.bin)")
    ap.add_argument("--sync-timeout", type=float, default=None, help="seconds to wait for 'S' (default: infinite)")
    ap.add_argument("--read-timeout", type=float, default=None, help="seconds to wait while reading payload (default: infinite)")
    ap.add_argument("--stop-on-next-S", action="store_true", help="abort if another 'S' appears mid-payload")
    ap.add_argument("--preview", action="store_true", help="print a short hexdump preview")
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

        data = read_ascii_hex_bytes(
            ser,
            n_bytes=args.nbytes,
            timeout=args.read_timeout,
            stop_on_next_S=args.stop_on_next_S
        )

        with open(args.out, "wb") as f:
            f.write(data)
        print(f"Wrote {len(data)} bytes to {args.out}")

        if args.preview:
            hexdump_preview(data)

    finally:
        ser.close()

if __name__ == "__main__":
    main()
