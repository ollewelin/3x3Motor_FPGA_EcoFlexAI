#!/usr/bin/env python3
"""
debug_drift.py - Diagnose per-line pixel drift in FPGA frame readout.

Reads RAW8 Bayer frames continuously (same protocol as read_frame_image.py),
then for each frame produces 3 corrected images where each successive raw line
is rolled RIGHT by k*drift pixels (k = line index, drift = 79/80/81).

If the image has a diagonal staircase shift of ~80 raw pixels per line, one of
the three outputs should appear correctly aligned.

Outputs (overwritten each frame):
  frame_colour_79_shift_right.png
  frame_colour_80_shift_right.png
  frame_colour_81_shift_right.png
"""
import argparse, sys, serial, time
from PIL import Image
import numpy as np

# ---------- ASCII-HEX reader (identical to read_frame_image.py) ----------
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
    if 48 <= x <= 57: return x - 48
    y = x | 0x20
    if 97 <= y <= 102: return y - 87
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

# ---------- Debayer RGGB → RGB ----------
def debayer_rggb(raw):
    R  = raw[0::2, 0::2].astype(np.uint16)
    Gr = raw[0::2, 1::2].astype(np.uint16)
    Gb = raw[1::2, 0::2].astype(np.uint16)
    B  = raw[1::2, 1::2].astype(np.uint16)
    G  = ((Gr + Gb + 1) >> 1).astype(np.uint8)
    return np.stack([R.astype(np.uint8), G, B.astype(np.uint8)], axis=-1)

# ---------- Apply per-line drift correction ----------
def apply_drift_correction(raw, drift, direction='right'):
    """
    For each row k, roll that row by k*drift raw pixels.
    direction='right'  corrects a left-drift  (roll positive)
    direction='left'   corrects a right-drift (roll negative)
    """
    corrected = raw.copy()
    sign = 1 if direction == 'right' else -1
    for k in range(raw.shape[0]):
        shift = sign * ((k * drift) % raw.shape[1])
        if shift:
            corrected[k] = np.roll(raw[k], shift)
    return corrected

# ---------- Main ----------
def main():
    ap = argparse.ArgumentParser(
        description="Debug per-line pixel drift: outputs 3 drift-corrected images per frame")
    ap.add_argument("port")
    ap.add_argument("baud", type=int)
    ap.add_argument("--sensor-width",  type=int, default=232)
    ap.add_argument("--sensor-height", type=int, default=192)
    ap.add_argument("--sync-timeout",  type=float, default=None)
    ap.add_argument("--read-timeout",  type=float, default=None)
    ap.add_argument("--px-per-beat",   type=int, default=8)
    ap.add_argument("--bytes-per-beat", type=int, default=8)
    ap.add_argument("--drifts", type=int, nargs="+", default=list(range(60, 101)),
                    help="drift values (raw pixels per line) to test (default: 60..100)")
    args = ap.parse_args()

    SW, SH = args.sensor_width, args.sensor_height
    PPB, BPB = args.px_per_beat, args.bytes_per_beat
    beats_per_line = (SW + PPB - 1) // PPB
    total_beats    = beats_per_line * SH
    total_bytes    = total_beats * BPB

    print(f"Sensor: {SW}x{SH}  beats/line={beats_per_line}  total_bytes={total_bytes}")
    print(f"Drift values to test: {args.drifts}")
    print("Output files (overwritten each frame):")
    for d in args.drifts:
        print(f"  frame_colour_{d}_shift_right.png")
        print(f"  frame_colour_{d}_shift_left.png")
    print("Press Ctrl+C to stop.\n")

    ser = serial.Serial(args.port, args.baud, timeout=0.1, bytesize=8,
                        parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE)

    frame_count = 0
    try:
        while True:
            try:
                # 1. Sync
                wait_for_S(ser, timeout=args.sync_timeout)

                # 2. Read raw hex bytes
                buf = read_ascii_hex(ser, n_bytes=total_bytes, timeout=args.read_timeout)

                # 3. Unpack beat-packed bytes into a flat pixel array
                raw_flat = bytearray(SW * SH)
                for line in range(SH):
                    for beat in range(beats_per_line):
                        src = (line * beats_per_line + beat) * BPB
                        dst = line * SW + beat * PPB
                        remaining = min(PPB, SW - beat * PPB)
                        raw_flat[dst:dst + remaining] = buf[src:src + remaining]

                raw = np.frombuffer(bytes(raw_flat), dtype=np.uint8).reshape((SH, SW))

                # 4. For each drift candidate: correct → debayer → save (both directions)
                for drift in args.drifts:
                    for direction in ('right', 'left'):
                        corrected = apply_drift_correction(raw, drift, direction)
                        rgb = debayer_rggb(corrected)
                        fname = f"frame_colour_{drift}_shift_{direction}.png"
                        Image.fromarray(rgb, mode="RGB").save(fname)

                frame_count += 1
                sys.stdout.write(f"\rFrames captured: {frame_count}")
                sys.stdout.flush()

            except TimeoutError as e:
                print(f"\n{e}. Retrying...")
                ser.reset_input_buffer()
                continue

    except KeyboardInterrupt:
        print("\nStopped.")
    finally:
        ser.close()

if __name__ == "__main__":
    main()
