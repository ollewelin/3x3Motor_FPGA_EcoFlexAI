#!/usr/bin/env python3
"""
Continuously read 224x224 RAW8 Bayer frames from FPGA BRAM.
Produces two output PNGs per frame:
  frame_colour.png  -- full 112x112 colour image (unpatched)
  frame_patched.png -- 80x112 colour image with duplicated column block removed

Column patch (in colour-dot space, 0-indexed):
  Colour cols 0..6   : unique  (7 cols)
  Colour cols 7..38  : original data  (32 cols)
  Colour cols 39..70 : DUPLICATE of cols 7..38  <- dropped
  Colour cols 71..111: continuation  (41 cols)
  Result: cols 0..38 + cols 71..111 = 80 cols wide
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

def debayer_rggb(raw, sensor_w, sensor_h):
    R  = raw[0::2, 0::2].astype(np.uint16)
    Gr = raw[0::2, 1::2].astype(np.uint16)
    Gb = raw[1::2, 0::2].astype(np.uint16)
    B  = raw[1::2, 1::2].astype(np.uint16)
    G  = ((Gr + Gb + 1) >> 1).astype(np.uint8)
    rgb = np.stack([R.astype(np.uint8), G, B.astype(np.uint8)], axis=-1)
    return rgb

def patch_columns(rgb):
    """
    Remove the duplicate 32-column block at colour cols 39..70.
    Returns array of shape (H, 80, 3).
    """
    left  = rgb[:, :39, :]   # cols 0..38  (unique + original 32)
    right = rgb[:, 71:, :]   # cols 71..111 (41 cols, shifted left)
    return np.concatenate([left, right], axis=1)

def main():
    ap = argparse.ArgumentParser(
        description="Continuous 224x224 RAW8 Bayer → 112x112 PNG + 80x112 patched PNG")
    ap.add_argument("port")
    ap.add_argument("baud", type=int)
    ap.add_argument("--sensor-width",  type=int, default=224)
    ap.add_argument("--sensor-height", type=int, default=224)
    ap.add_argument("--out",           default="frame_colour.png")
    ap.add_argument("--out-patched",   default="frame_patched.png")
    ap.add_argument("--sync-timeout",  type=float, default=None)
    ap.add_argument("--read-timeout",  type=float, default=None)
    ap.add_argument("--px-per-beat",   type=int, default=8)
    ap.add_argument("--bytes-per-beat",type=int, default=8)
    args = ap.parse_args()

    SW, SH = args.sensor_width, args.sensor_height
    PPB, BPB = args.px_per_beat, args.bytes_per_beat
    # 224 / 8 = 28 beats per line (exact), total 28*224=6272 beats, 50176 bytes
    beats_per_line = (SW + PPB - 1) // PPB
    total_beats    = beats_per_line * SH
    total_bytes    = total_beats * BPB

    colour_w = SW // 2   # 112
    colour_h = SH // 2   # 112
    patched_w = colour_w - 32  # 80  (drop cols 39..70)

    print(f"Starting continuous capture on {args.port}...")
    print(f"Raw frame   : {SW}x{SH} sensor px")
    print(f"Colour full : {colour_w}x{colour_h}")
    print(f"Colour patch: {patched_w}x{colour_h}  (cols 39..70 removed)")
    print(f"Saving full    -> {args.out}")
    print(f"Saving patched -> {args.out_patched}")
    print("Press Ctrl+C to stop.")

    ser = serial.Serial(args.port, args.baud, timeout=0.1, bytesize=8,
                        parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE)

    frame_count = 0
    try:
        while True:
            try:
                # 1. Wait for Start Marker
                wait_for_S(ser, timeout=args.sync_timeout)

                # 2. Read the full frame data
                buf = read_ascii_hex(ser, n_bytes=total_bytes, timeout=args.read_timeout)

                # 3. Unpack beat-packed bytes into contiguous raw array
                raw_flat = bytearray(SW * SH)
                for line in range(SH):
                    for beat in range(beats_per_line):
                        src = (line * beats_per_line + beat) * BPB
                        dst = line * SW + beat * PPB
                        remaining = min(PPB, SW - beat * PPB)
                        raw_flat[dst:dst+remaining] = buf[src:src+remaining]

                raw = np.frombuffer(bytes(raw_flat), dtype=np.uint8).reshape((SH, SW))

                # 4. Debayer RGGB → RGB  (112x112x3)
                rgb = debayer_rggb(raw, SW, SH)

                # 5. Save full (unpatched) frame
                Image.fromarray(rgb, mode="RGB").save(args.out)

                # 6. Patch duplicate columns and save
                rgb_patched = patch_columns(rgb)   # (112, 80, 3)
                Image.fromarray(rgb_patched, mode="RGB").save(args.out_patched)

                frame_count += 1
                sys.stdout.write(f"\rFrames captured: {frame_count}")
                sys.stdout.flush()

            except TimeoutError as e:
                print(f"\n{e}. Retrying...")
                ser.reset_input_buffer()
                continue

    except KeyboardInterrupt:
        print("\nStopping capture...")
    finally:
        ser.close()

if __name__ == "__main__":
    main()
