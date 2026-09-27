#!/usr/bin/env python3
"""
Continuously read 384x384 RAW8 Bayer frames from FPGA BRAM.
Each time an 'S' marker is detected, it captures the frame and
overwrites 'frame_colour.png'.
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

def main():
    ap = argparse.ArgumentParser(description="Continuous 384x384 RAW8 Bayer → 192x192 PNG")
    ap.add_argument("port")
    ap.add_argument("baud", type=int)
    ap.add_argument("--sensor-width",  type=int, default=384)
    ap.add_argument("--sensor-height", type=int, default=384)
    ap.add_argument("--out", default="frame_colour.png")
    ap.add_argument("--sync-timeout", type=float, default=None)
    ap.add_argument("--read-timeout", type=float, default=None)
    ap.add_argument("--px-per-beat", type=int, default=8)
    ap.add_argument("--bytes-per-beat", type=int, default=8)
    args = ap.parse_args()

    SW, SH = args.sensor_width, args.sensor_height
    PPB, BPB = args.px_per_beat, args.bytes_per_beat
    # 384 / 8 = 48 beats per line (exact), total 48*384=18432 beats, 147456 bytes
    beats_per_line = (SW + PPB - 1) // PPB
    total_beats    = beats_per_line * SH
    total_bytes    = total_beats * BPB

    print(f"Starting continuous capture on {args.port}...")
    print(f"Frame: {SW}x{SH} sensor px => {SW//2}x{SH//2} colour dots")
    print(f"Beats/line={beats_per_line}, total_beats={total_beats}, total_bytes={total_bytes}")
    print(f"Saving to: {args.out}. Press Ctrl+C to stop.")

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

                # 3. Unpack bytes
                raw_flat = bytearray(SW * SH)
                for line in range(SH):
                    for beat in range(beats_per_line):
                        src = (line * beats_per_line + beat) * BPB
                        dst = line * SW + beat * PPB
                        remaining = min(PPB, SW - beat * PPB)
                        raw_flat[dst:dst+remaining] = buf[src:src+remaining]

                raw = np.frombuffer(bytes(raw_flat), dtype=np.uint8).reshape((SH, SW))

                # 4. Debayer and Save (Overwriting)
                rgb = debayer_rggb(raw, SW, SH)
                im = Image.fromarray(rgb, mode="RGB")
                im.save(args.out)

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
