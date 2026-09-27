#!/usr/bin/env python3
import argparse
import serial
import time
from PIL import Image

def wait_for_S(ser, timeout=10.0):
    """Väntar på start-tecknet 'S' från FPGA:ns UART-dump."""
    start_time = time.time()
    while (time.time() - start_time) < timeout:
        if ser.read(1) == b'S':
            return True
    raise TimeoutError("Hittade inte start-tecknet 'S' inom timeout-perioden.")

def read_ascii_hex(ser, n_bytes, timeout=30.0):
    """Läser ASCII-HEX från UART och gör om till bytes."""
    buf = bytearray()
    ser.timeout = 1.0
    print(f"Läser {n_bytes} bytes...")
    
    while len(buf) < n_bytes:
        # FPGA:n skickar t.ex. "FF" för en byte
        hex_chars = ser.read(2)
        if len(hex_chars) < 2:
            print(f"Timeout eller korrupt data vid byte {len(buf)}")
            break
        try:
            val = int(hex_chars, 16)
            buf.append(val)
        except ValueError:
            # Om vi får skräp, försök synka om eller hoppa över
            continue
            
        if len(buf) % 1000 == 0:
            print(f"Mottagit {len(buf)} / {n_bytes} bytes...", end='\r')
            
    print(f"\nKlar! Totalt {len(buf)} bytes mottagna.")
    return buf

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", default="/dev/ttyUSB1") # Justera efter din PC
    parser.add_argument("--baud", type=int, default=115200)
    parser.add_argument("--width", type=int, default=96)
    parser.add_argument("--height", type=int, default=96)
    args = parser.parse_args()

    # I RAW8 med PIXELS_PER_BEAT=8:
    # 96 pixlar per rad / 8 pixlar per beat = 12 beats per rad.
    # 12 beats * 96 rader = 1152 beats totalt.
    # 1152 beats * 8 bytes per beat = 9216 bytes totalt.
    total_beats = (args.width // 8) * args.height
    total_bytes = total_beats * 8 

    ser = serial.Serial(args.port, args.baud, timeout=1.0)
    try:
        ser.reset_input_buffer()
        print(f"Väntar på 'S' på {args.port}...")
        wait_for_S(ser)
        
        # Läs rådata från BRAM via UART
        raw_data = read_ascii_hex(ser, total_bytes)
        
        if len(raw_data) < total_bytes:
            print("Varning: Fick inte tillräckligt med data för en hel bild.")
            # Vi försöker ändå skapa en bild av det vi har
            raw_data = raw_data.ljust(total_bytes, b'\x00')

        # I RAW8 (Pack Type 15) på en 64-bit buss är varje byte en pixel.
        # Datan ligger linjärt: Pixel 0, 1, 2, 3, 4, 5, 6, 7 i första 8-byte ordet.
        img = Image.frombytes('L', (args.width, args.height), bytes(raw_data[:total_bytes]))
        
        out_name = "ti60_capture_raw8.png"
        img.save(out_name)
        print(f"Bild sparad som {out_name}")
        img.show() # Öppnar bilden automatiskt

    finally:
        ser.close()

if __name__ == "__main__":
    main()