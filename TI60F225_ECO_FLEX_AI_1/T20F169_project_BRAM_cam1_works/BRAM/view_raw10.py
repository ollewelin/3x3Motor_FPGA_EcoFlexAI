# save as view_raw10.py  (run: python3 view_raw10.py)
import numpy as np

W, H = 96, 96
BYTES = 18432  # 96x96, 4 px/word, 2B per px

with open("frame.bin", "rb") as f:
    b = f.read()
assert len(b) == BYTES, f"unexpected size {len(b)}"

# interpret as little-endian uint16
u16 = np.frombuffer(b, dtype="<u2")     # 9216 samples
img = u16.reshape(H, 4*W//4)            # 96x96

# Variant A: RAW10 left-justified in 16b (bits 15..6) -> shift right by 6
a10 = (img >> 6).astype(np.uint16)      # range 0..1023
a8  = ((a10 * 255) // 1023).astype(np.uint8)

# Variant B: RAW10 right-justified (bits 9..0)
b10 = (img & 0x03FF).astype(np.uint16)  # range 0..1023
b8  = ((b10 * 255) // 1023).astype(np.uint8)

# Very quick-look: just take low byte (often shows something even if scaled wrong)
lo8 = (img & 0x00FF).astype(np.uint8)

def write_pgm(path, arr8):
    with open(path, "wb") as f:
        f.write(f"P5\n{W} {H}\n255\n".encode())
        f.write(arr8.tobytes())

write_pgm("frame_leftjust.pgm",  a8)
write_pgm("frame_rightjust.pgm", b8)
write_pgm("frame_lowbyte.pgm",   lo8)
print("Wrote: frame_leftjust.pgm, frame_rightjust.pgm, frame_lowbyte.pgm")


