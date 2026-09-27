#!/usr/bin/env python3
"""
Debug script: dump raw serial data and look for 'S' header.
Shows hex + ASCII of everything received so you can see what the FPGA sends.
"""
import sys, serial, time

port = sys.argv[1] if len(sys.argv) > 1 else "/dev/ttyUSB1"
baud = int(sys.argv[2]) if len(sys.argv) > 2 else 115200

ser = serial.Serial(port, baud, timeout=0.5, bytesize=8,
                    parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE,
                    xonxoff=False, rtscts=False, dsrdtr=False)
ser.reset_input_buffer()

print(f"Listening on {port} @ {baud}  (Ctrl-C to stop)")
print(f"{'time':>8s}  {'offset':>6s}  {'hex dump':<50s}  ASCII")
print("-" * 80)

total = 0
t0 = time.time()
s_found = False
s_offset = None

try:
    while True:
        chunk = ser.read(64)  # read up to 64 bytes at a time
        if not chunk:
            continue
        elapsed = time.time() - t0

        # print in rows of 16
        for i in range(0, len(chunk), 16):
            row = chunk[i:i+16]
            hx = " ".join(f"{b:02X}" for b in row)
            asc = "".join(chr(b) if 32 <= b < 127 else "." for b in row)

            # highlight 'S' (0x53)
            markers = ""
            for j, b in enumerate(row):
                if b == 0x53 and not s_found:
                    s_found = True
                    s_offset = total + i + j
                    markers += f"  <<< 'S' FOUND at byte offset {s_offset} (t={elapsed:.3f}s)"

            print(f"{elapsed:8.3f}  {total+i:6d}  {hx:<50s}  {asc}{markers}")

        total += len(chunk)

        # after finding S, print a summary after 2000 more bytes
        if s_found and (total - s_offset) > 2000:
            print(f"\n=== 'S' was at offset {s_offset}.  Received {total} bytes so far. ===")
            print(f"=== First 200 bytes after 'S' should be ASCII hex (0-9, A-F). ===")
            # keep going, don't break

except KeyboardInterrupt:
    pass
finally:
    ser.close()
    print(f"\nTotal bytes received: {total}")
    if s_found:
        print(f"'S' found at byte offset {s_offset}")
    else:
        print("'S' (0x53) was NEVER seen in the data stream!")
