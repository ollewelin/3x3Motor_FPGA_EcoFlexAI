#!/usr/bin/env python3
"""
Read 192x192 RAW8 Bayer (GBRG) frame from FPGA UART (ASCII-HEX after 'S')
and save each Bayer channel as a separate grayscale image.

GBRG Bayer layout (one 2x2 block):
  Even rows: G  B  G  B  ...   (pixel cols 0,2,4 = Gb ; cols 1,3,5 = B)
  Odd  rows: R  G  R  G  ...   (pixel cols 0,2,4 = R  ; cols 1,3,5 = Gr)

Output images (96x96 each, grayscale):
  G1.png  – Gb channel (even rows, even cols)
  B.png   – B  channel (even rows, odd  cols)
  R.png   – R  channel (odd  rows, even cols)
  G2.png  – Gr channel (odd  rows, odd  cols)

Usage:
  python read_frame_image_separate.py /dev/ttyUSB0 115200
  python read_frame_image_separate.py /dev/ttyUSB0 115200 --out-dir ./channels
"""
import argparse
import sys
import time
import serial
from PIL import Image
import numpy as np

# ---------- ASCII-HEX reader (same as read_frame_image.py) ----------
WS = b"\r\n\t "


def wait_for_S(ser, timeout=None):
    t0 = time.time()
    while True:
        b = ser.read(1)
        if b == b"S":
            return
        if timeout is not None and (time.time() - t0) > timeout:
            raise TimeoutError("Timed out waiting for 'S'")


def nibble_of(x):
    if 48 <= x <= 57:
        return x - 48          # '0'..'9'
    y = x | 0x20               # to lower
    if 97 <= y <= 102:
        return y - 87          # 'a'..'f' -> 10..15
    return None


def read_ascii_hex(ser, n_bytes, timeout=None):
    out = bytearray()
    hi = None
    t0 = time.time()
    while len(out) < n_bytes:
        b = ser.read(1)
        if not b:
            if timeout is not None and (time.time() - t0) > timeout:
                raise TimeoutError(f"Timed out ({len(out)}/{n_bytes})")
            continue
        t0 = time.time()
        c = b[0]
        if c in WS:
            continue
        n = nibble_of(c)
        if n is None:
            continue
        if hi is None:
            hi = n
        else:
            out.append((hi << 4) | n)
            hi = None
    return bytes(out)


# ---------- Main ----------
def main():
    ap = argparse.ArgumentParser(
        description="Read 192x192 RAW8 GBRG Bayer frame → 4 separate grayscale channel PNGs")
    ap.add_argument("port")
    ap.add_argument("baud", type=int)
    ap.add_argument("--sensor-width",  type=int, default=192)
    ap.add_argument("--sensor-height", type=int, default=192)
    ap.add_argument("--out-dir", default=".",
                    help="Directory to save channel PNGs (default: current dir)")
    ap.add_argument("--sync-timeout", type=float, default=None)
    ap.add_argument("--read-timeout", type=float, default=None)
    # RTL: RAW8 on 64-bit bus => 8 px/beat, all 8 bytes used
    ap.add_argument("--px-per-beat",    type=int, default=8)
    ap.add_argument("--bytes-per-beat", type=int, default=8)
    args = ap.parse_args()

    import os
    os.makedirs(args.out_dir, exist_ok=True)

    SW, SH = args.sensor_width, args.sensor_height
    PPB = args.px_per_beat
    BPB = args.bytes_per_beat
    beats_per_line = (SW + PPB - 1) // PPB   # 192/8 = 24
    total_beats    = beats_per_line * SH      # 24*192 = 4608
    total_bytes    = total_beats * BPB        # 4608*8 = 36864

    print(f"Sensor: {SW}x{SH}  |  beats/line={beats_per_line}  "
          f"total_beats={total_beats}  total_bytes={total_bytes}")
    print(f"Bayer pattern: GBRG  →  each channel will be {SW//2}x{SH//2} pixels")

    ser = serial.Serial(
        args.port, args.baud, timeout=0.2,
        bytesize=8, parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        xonxoff=False, rtscts=False, dsrdtr=False
    )
    try:
        ser.reset_input_buffer()
        print(f"Waiting for 'S' on {args.port} @ {args.baud} baud...")
        wait_for_S(ser, timeout=args.sync_timeout)
        print(f"'S' received. Reading {total_bytes} ASCII-HEX bytes...")
        buf = read_ascii_hex(ser, n_bytes=total_bytes, timeout=args.read_timeout)
    finally:
        ser.close()

    print(f"Received {len(buf)} bytes.")

    # ---- Unpack: each 8-byte beat = 8 RAW8 pixels ----
    # VHDL dumps bytes [7:0] first ... [63:56] last → natural pixel order
    raw_flat = bytearray(SW * SH)
    for line in range(SH):
        for beat in range(beats_per_line):
            src = (line * beats_per_line + beat) * BPB
            dst = line * SW + beat * PPB
            remaining = min(PPB, SW - beat * PPB)
            raw_flat[dst:dst + remaining] = buf[src:src + remaining]

    raw = np.frombuffer(bytes(raw_flat), dtype=np.uint8).reshape((SH, SW))

    # ---- Extract 4 Bayer channels (GBRG) ----
    # Even rows (0,2,4...): Gb at even cols, B at odd cols
    # Odd  rows (1,3,5...): R  at even cols, Gr at odd cols
    G1 = raw[0::2, 0::2]   # Gb  – even row, even col
    B  = raw[0::2, 1::2]   # B   – even row, odd  col
    R  = raw[1::2, 0::2]   # R   – odd  row, even col
    G2 = raw[1::2, 1::2]   # Gr  – odd  row, odd  col

    # Print basic statistics for each channel
    for name, ch in [("G1 (Gb)", G1), ("B", B), ("R", R), ("G2 (Gr)", G2)]:
        print(f"  {name:8s}: min={ch.min():3d}  max={ch.max():3d}  "
              f"mean={ch.mean():.1f}  shape={ch.shape}")

    # ---- Save grayscale PNGs ----
    def save_gray(arr, filename):
        path = os.path.join(args.out_dir, filename)
        Image.fromarray(arr, mode="L").save(path)
        print(f"  Saved: {path}  ({arr.shape[1]}x{arr.shape[0]})")

    save_gray(G1, "G1.png")
    save_gray(B,  "B.png")
    save_gray(R,  "R.png")
    save_gray(G2, "G2.png")

    print("Done.")


if __name__ == "__main__":
    main()
