#!/usr/bin/env python3
"""
Read 192x192 RAW8 Bayer frame from FPGA BRAM (ASCII-HEX after 'S' marker)
and debayer into a 96x96 colour PNG.

RAW8 on 64-bit bus => 8 pixels per beat, all 8 bytes useful.
Camera Bayer pattern (GBRG):
  Even rows: Gb B  Gb B  ...   (G at even cols, B at odd cols)
  Odd  rows: R  Gr R  Gr ...   (R at even cols, G at odd cols)
Each 2x2 block  →  one colour dot (R, avg(Gb,Gr), B).
"""
import argparse, sys, serial, time
from PIL import Image
import numpy as np

# ---------- ASCII-HEX reader ----------
WS = b"\r\n\t "

def wait_for_S(ser, timeout=None):
    t0 = time.time()
    while True:
        b = ser.read(1)
        if b == b"S":
            return
        if timeout is not None and (time.time()-t0) > timeout:
            raise TimeoutError("Timed out waiting for 'S'")

def nibble_of(x):
    if 48 <= x <= 57: return x-48            # '0'..'9'
    y = x | 0x20                              # to lower
    if 97 <= y <= 102: return y-87            # 'a'..'f' -> 10..15
    return None

def read_ascii_hex(ser, n_bytes, timeout=None):
    out = bytearray()
    hi = None
    t0 = time.time()
    while len(out) < n_bytes:
        b = ser.read(1)
        if not b:
            if timeout is not None and (time.time()-t0) > timeout:
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
            out.append((hi<<4) | n)
            hi = None
    return bytes(out)

# ---------- Bayer GBRG → RGB debayer (2x2 block average) ----------
def debayer_gbrg(raw, sensor_w, sensor_h):
    """
    raw: numpy uint8 array (sensor_h, sensor_w) with GBRG Bayer pattern
    Camera output:
      Even rows (0,2,4...): Gb B  Gb B  ...   (G at even cols, B at odd cols)
      Odd  rows (1,3,5...): R  Gr R  Gr ...   (R at even cols, G at odd cols)
    Returns: numpy uint8 array (sensor_h//2, sensor_w//2, 3) RGB
    """
    Gb = raw[0::2, 0::2].astype(np.uint16)   # Green (on blue row)
    B  = raw[0::2, 1::2].astype(np.uint16)   # Blue
    R  = raw[1::2, 0::2].astype(np.uint16)   # Red
    Gr = raw[1::2, 1::2].astype(np.uint16)   # Green (on red row)
    G  = ((Gb + Gr + 1) >> 1).astype(np.uint8)
    rgb = np.stack([R.astype(np.uint8), G, B.astype(np.uint8)], axis=-1)
    return rgb

# ---------- Main ----------
def main():
    ap = argparse.ArgumentParser(
        description="Read 192x192 RAW8 Bayer frame (ASCII-HEX after 'S') → 96x96 colour PNG")
    ap.add_argument("port")
    ap.add_argument("baud", type=int)
    ap.add_argument("--sensor-width",  type=int, default=192,
                    help="sensor pixel width  (default 192)")
    ap.add_argument("--sensor-height", type=int, default=192,
                    help="sensor pixel height (default 192)")
    ap.add_argument("--out", default="frame_colour.png")
    ap.add_argument("--out-raw", default=None,
                    help="also save raw Bayer grayscale PNG (optional)")
    ap.add_argument("--sync-timeout", type=float, default=None)
    ap.add_argument("--read-timeout", type=float, default=None)
    # RTL packing: RAW8 on 64-bit bus → 8 px/beat, all 8 bytes used
    ap.add_argument("--px-per-beat", type=int, default=8,
                    help="pixels per 64-bit beat (RAW8→8)")
    ap.add_argument("--bytes-per-beat", type=int, default=8)
    args = ap.parse_args()

    SW, SH = args.sensor_width, args.sensor_height
    PPB = args.px_per_beat
    BPB = args.bytes_per_beat
    beats_per_line = (SW + PPB - 1) // PPB    # 192/8 = 24
    total_beats    = beats_per_line * SH       # 24*192 = 4608
    total_bytes    = total_beats * BPB         # 4608*8 = 36864

    colour_w = SW // 2   # 96
    colour_h = SH // 2   # 96

    print(f"RAW8 sensor: {SW}x{SH}  →  colour: {colour_w}x{colour_h}")
    print(f"Beats/line={beats_per_line}  total_beats={total_beats}  total_bytes={total_bytes}")

    ser = serial.Serial(args.port, args.baud, timeout=0.2, bytesize=8,
                        parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE,
                        xonxoff=False, rtscts=False, dsrdtr=False)
    try:
        ser.reset_input_buffer()
        print(f"Waiting for 'S' on {args.port} @ {args.baud}...")
        wait_for_S(ser, timeout=args.sync_timeout)
        print(f"'S' seen. Reading {total_bytes} ASCII-HEX decoded bytes...")
        buf = read_ascii_hex(ser, n_bytes=total_bytes, timeout=args.read_timeout)
    finally:
        ser.close()

    print(f"Received {len(buf)} bytes.")

    # ---- Unpack: each 8-byte beat = 8 RAW8 pixels (all bytes useful) ----
    raw_flat = bytearray(SW * SH)
    for line in range(SH):
        for beat in range(beats_per_line):
            src = (line * beats_per_line + beat) * BPB
            dst = line * SW + beat * PPB
            remaining = min(PPB, SW - beat * PPB)
            raw_flat[dst:dst+remaining] = buf[src:src+remaining]

    raw = np.frombuffer(bytes(raw_flat), dtype=np.uint8).reshape((SH, SW))

    # Optionally save raw Bayer as grayscale
    if args.out_raw:
        im_raw = Image.fromarray(raw, mode="L")
        im_raw.save(args.out_raw)
        print(f"Saved raw Bayer: {args.out_raw} ({SW}x{SH})")

    # ---- Debayer GBRG → 96x96 RGB ----
    rgb = debayer_gbrg(raw, SW, SH)
    im = Image.fromarray(rgb, mode="RGB")
    im.save(args.out)
    print(f"Saved colour:    {args.out} ({colour_w}x{colour_h})")

if __name__ == "__main__":
    main()
