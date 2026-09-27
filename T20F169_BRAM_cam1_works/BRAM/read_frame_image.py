#!/usr/bin/env python3
import argparse, math, sys, serial, time
from PIL import Image

# ---------- RAW10 helpers ----------
def unpack_raw10_4px(b0,b1,b2,b3,b4):
    # 4x 10-bit packed into 5 bytes: LSB-first
    p0 = (b0      ) | ((b4 & 0b00000011) << 8)
    p1 = (b1      ) | ((b4 & 0b00001100) << 6)
    p2 = (b2      ) | ((b4 & 0b00110000) << 4)
    p3 = (b3      ) | ((b4 & 0b11000000) << 2)
    return p0, p1, p2, p3

def unpack_raw10_4px_normal(b0,b1,b2,b3,b4):
    # Byte4: [1:0]=p0[9:8], [3:2]=p1, [5:4]=p2, [7:6]=p3
    p0 =  b0 | ((b4 & 0x03) << 8)
    p1 =  b1 | ((b4 & 0x0C) << 6)
    p2 =  b2 | ((b4 & 0x30) << 4)
    p3 =  b3 | ((b4 & 0xC0) << 2)
    return p0, p1, p2, p3

def unpack_raw10_4px_alt(b0,b1,b2,b3,b4):
    # Swapped assignment if your packer reversed nibble order
    p0 =  b0 | ((b4 & 0xC0) << 2)
    p1 =  b1 | ((b4 & 0x30) << 4)
    p2 =  b2 | ((b4 & 0x0C) << 6)
    p3 =  b3 | ((b4 & 0x03) << 8)
    return p0, p1, p2, p3

def raw10_to_u8(p):  # simple 10→8 conversion (drop 2 LSBs)
    return p >> 2

# ---------- ASCII-HEX reader (same behavior as your script) ----------
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

# ---------- Main ----------
def main():
    ap = argparse.ArgumentParser(description="Read camera frame (ASCII-HEX after 'S') and save PNG")
    ap.add_argument("port")
    ap.add_argument("baud", type=int)
    ap.add_argument("--width",  type=int, required=True)
    ap.add_argument("--height", type=int, required=True)
    ap.add_argument("--out", default="frame.png")
    ap.add_argument("--sync-timeout", type=float, default=None)
    ap.add_argument("--read-timeout", type=float, default=None)
    # geometry/packing assumptions (match your RTL)
    ap.add_argument("--px-per-beat", type=int, default=4, help="pixels per 64-bit beat (RAW10→4)")
    ap.add_argument("--bytes-per-beat", type=int, default=8)
    ap.add_argument("--useful-bytes-per-beat", type=int, default=5, help="lower 5 bytes carry RAW10; top 3 are zero")
    args = ap.parse_args()

    W, H = args.width, args.height
    beats_per_line = (W + args.px_per_beat - 1) // args.px_per_beat
    total_beats    = beats_per_line * H
    total_bytes    = total_beats * args.bytes_per_beat

    ser = serial.Serial(args.port, args.baud, timeout=0.2, bytesize=8, parity=serial.PARITY_NONE,
                        stopbits=serial.STOPBITS_ONE, xonxoff=False, rtscts=False, dsrdtr=False)
    try:
        ser.reset_input_buffer()
        print(f"Waiting for 'S' on {args.port} @ {args.baud}...")
        wait_for_S(ser, timeout=args.sync_timeout)
        print(f"'S' seen. Reading {total_bytes} ASCII-HEX decoded bytes...")
        buf = read_ascii_hex(ser, n_bytes=total_bytes, timeout=args.read_timeout)
    finally:
        ser.close()

    # Strip each 8B beat down to the lower 5B with data
    if args.useful_bytes_per_beat == 5:
        useful = bytearray(total_beats * 5)
        o = 0
        for i in range(total_beats):
            base = i*args.bytes_per_beat
            useful[o:o+5] = buf[base:base+5]   # keep B0..B4 (LSB first)
            o += 5
    else:
        raise ValueError("This script currently expects 5 useful bytes per beat (RAW10).")

    # Unpack RAW10 → pixels
    pixels = []
    u = 0
    for _ in range(total_beats):
        b0,b1,b2,b3,b4 = useful[u:u+5]
        u += 5
        p0,p1,p2,p3 = unpack_raw10_4px_normal(b0,b1,b2,b3,b4)
        pixels.extend((raw10_to_u8(p0), raw10_to_u8(p1), raw10_to_u8(p2), raw10_to_u8(p3)))

    # Trim extra pixels on the right edge if width not multiple of 4
    row = []
    img = bytearray(W*H)
    pi = 0
    for y in range(H):
        start = y * ((beats_per_line)*args.px_per_beat)
        rowpx = pixels[start : start + W]
        img[y*W:(y+1)*W] = bytes(rowpx)

    # Save PNG (grayscale)
    im = Image.frombytes("L", (W,H), bytes(img))
    im.save(args.out)
    print(f"Saved {args.out} ({W}x{H})")

if __name__ == "__main__":
    main()
