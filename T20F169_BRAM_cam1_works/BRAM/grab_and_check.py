import sys, struct, serial

dev  = sys.argv[1]           # e.g. /dev/ttyACM0
baud = int(sys.argv[2])      # e.g. 115200
words = int(sys.argv[3])     # e.g. 512

ser = serial.Serial(dev, baudrate=baud, bytesize=8, parity=serial.PARITY_NONE,
                    stopbits=serial.STOPBITS_ONE, timeout=None,
                    xonxoff=False, rtscts=False, dsrdtr=False)
ser.reset_input_buffer()

N = words * 8
buf = bytearray()
while len(buf) < N:
    buf += ser.read(N - len(buf))

# Verify little-endian 64-bit: 0,1,2,...
bad = []
for i in range(words):
    (x,) = struct.unpack_from("<Q", buf, i*8)
    if x != i:
        bad.append((i, x))
        if len(bad) > 20: break

print(f"received {len(buf)} bytes, checked {words} words")
if bad:
    print("MISMATCHES (first 20):")
    for i,x in bad[:20]:
        print(f"  word {i}: got 0x{x:016X}, expected 0x{i:016X}")
else:
    print("All good ✅")
open("frame.bin", "wb").write(buf)
