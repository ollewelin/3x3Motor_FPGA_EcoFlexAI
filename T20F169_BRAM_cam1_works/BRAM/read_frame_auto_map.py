#!/usr/bin/env python3
import argparse, sys, time, serial
from PIL import Image
import itertools
import math

# ---------- serial helpers ----------
WS = b"\r\n\t "
def wait_for_S(ser, timeout=None):
    t0 = time.time()
    while True:
        b = ser.read(1)
        if b == b"S": return
        if timeout is not None and (time.time()-t0) > timeout:
            raise TimeoutError("Timeout waiting for 'S'")

def nibble_of(x):
    if 48 <= x <= 57: return x-48
    y = x|0x20
    if 97 <= y <= 102: return y-87
    return None

def read_ascii_hex(ser, n_bytes, timeout=None):
    out = bytearray(); hi=None; t0=time.time()
    while len(out) < n_bytes:
        b = ser.read(1)
        if not b:
            if timeout is not None and (time.time()-t0) > timeout:
                raise TimeoutError(f"Timeout ({len(out)}/{n_bytes})")
            continue
        t0=time.time()
        c=b[0]
        if c in WS: continue
        n=nibble_of(c)
        if n is None: continue
        if hi is None: hi=n
        else:
            out.append((hi<<4)|n)
            hi=None
    return bytes(out)

# ---------- RAW10 variants ----------
def unpack_normal(b0,b1,b2,b3,b4):
    p0 =  b0 | ((b4 & 0x03) << 8)
    p1 =  b1 | ((b4 & 0x0C) << 6)
    p2 =  b2 | ((b4 & 0x30) << 4)
    p3 =  b3 | ((b4 & 0xC0) << 2)
    return (p0,p1,p2,p3)

def unpack_alt(b0,b1,b2,b3,b4):
    p0 =  b0 | ((b4 & 0xC0) << 2)
    p1 =  b1 | ((b4 & 0x30) << 4)
    p2 =  b2 | ((b4 & 0x0C) << 6)
    p3 =  b3 | ((b4 & 0x03) << 8)
    return (p0,p1,p2,p3)

def p10_to_u8(x): return x>>2   # 10→8 (simple)

# score: negative SAD of horizontal differences (higher is “smoother”)
def smoothness_score(img_u8, W, H):
    s=0
    for y in range(H):
        row = img_u8[y*W:(y+1)*W]
        for x in range(W-1):
            d = row[x+1]-row[x]
            s -= abs(d)
    return s

def render(W,H, beats_per_line, buf, byte_order, nibble_variant, pixel_order):
    # slice 5 useful bytes per 8-byte beat
    useful = bytearray()
    for i in range(beats_per_line*H):
        base = 8*i
        b = list(buf[base:base+5])  # B0..B4
        if byte_order == "rev5":
            b = b[::-1]
        # choose unpacker
        if nibble_variant == "normal":
            p = unpack_normal(*b)
        else:
            p = unpack_alt(*b)
        # reorder pixels
        p = [p[i] for i in pixel_order]
        # append as 8-bit
        for px in p:
            useful.append(p10_to_u8(px))
    # reshape, trim to W
    out = bytearray(W*H)
    src_px_per_line = beats_per_line*4
    for y in range(H):
        start = y*src_px_per_line
        out[y*W:(y+1)*W] = useful[start:start+W]
    return out

def main():
    ap = argparse.ArgumentParser(description="Read frame after 'S' and auto-detect RAW10 mapping")
    ap.add_argument("port"); ap.add_argument("baud", type=int)
    ap.add_argument("--width",  type=int, required=True)
    ap.add_argument("--height", type=int, required=True)
    ap.add_argument("--out", default="frame_best.png")
    ap.add_argument("--save-top", type=int, default=4, help="save N best candidates")
    ap.add_argument("--sync-timeout", type=float, default=None)
    ap.add_argument("--read-timeout", type=float, default=None)
    args = ap.parse_args()

    W,H = args.width, args.height
    beats_per_line = (W + 3)//4
    total_beats = beats_per_line*H
    total_bytes = total_beats*8

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

    variants=[]
    nibs = ["normal","alt"]
    bytes5 = ["fwd5","rev5"]               # B0..B4 or reversed
    pix_orders = [
        (0,1,2,3), (3,2,1,0),             # as is / reversed
        (1,0,3,2), (2,3,0,1),             # swap pairs
        (0,2,1,3), (1,3,0,2),             # interleaves
        (2,0,3,1), (3,1,2,0),
    ]
    for nb in nibs:
        for bo in bytes5:
            for po in pix_orders:
                img = render(W,H, beats_per_line, buf, bo, nb, po)
                sc = smoothness_score(img, W,H)
                variants.append((sc, nb, bo, po, img))

    variants.sort(key=lambda x: x[0], reverse=True)
    best = variants[0]
    print("Best mapping:",
          f"nibble={best[1]}  byteorder={best[2]}  pixel_order={best[3]}  score={best[0]}")

    # save best
    im = Image.frombytes("L", (W,H), bytes(best[4]))
    im.save(args.out)
    print(f"Saved {args.out}")

    # save a few more for eyeballing
    for i in range(1, min(args.save_top, len(variants))):
        sc, nb, bo, po, img = variants[i]
        name = f"frame_{i}_{nb}_{bo}_{''.join(map(str,po))}.png"
        Image.frombytes("L", (W,H), bytes(img)).save(name)
        print(f"Saved {name} (score {sc})")

if __name__ == "__main__":
    main()
