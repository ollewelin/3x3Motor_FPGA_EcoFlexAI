#!/usr/bin/env python3
import serial
import time
from PIL import Image

def wait_for_S(ser, timeout=10.0):
    """Väntar på start-tecknet 'S'."""
    start_time = time.time()
    while (time.time() - start_time) < timeout:
        b = ser.read(1)
        if b == b'S':
            # Vi hittade S, rensa eventuellt skräp precis efter (som newline)
            return True
    return False

def read_ascii_hex_robust(ser, n_bytes):
    """Läser ASCII-HEX men ignorerar allt som inte är HEX-tecken."""
    buf = bytearray()
    hex_chars = ""
    print(f"Läser {n_bytes} bytes (RAW8)...")
    
    while len(buf) < n_bytes:
        char = ser.read(1).decode('ascii', errors='ignore').upper()
        if char in "0123456789ABCDEF":
            hex_chars += char
            if len(hex_chars) == 2:
                buf.append(int(hex_chars, 16))
                hex_chars = ""
        elif char == 'S':
            # Om vi ser ett nytt 'S' mitt i allt, har vi förmodligen missat slutet 
            # på förra framen. Vi kan välja att nollställa eller fortsätta.
            pass
            
        if len(buf) % 1000 == 0 and len(hex_chars) == 0:
            print(f"Mottagit {len(buf)} / {n_bytes}...", end='\r')
            
    print(f"\nKlar! Totalt {len(buf)} bytes mottagna.")
    return buf

def main():
    # Enligt din logg skickar FPGA:n 18432 bytes i ASCII-HEX dumpen
    # (Vilket motsvarar 2304 klockcykler i BRAM * 8 bytes)
    TOTAL_BYTES_TO_READ = 18432 
    WIDTH = 96
    HEIGHT = 96
    
    # Ändra porten om det behövs (/dev/ttyACM0 eller /dev/ttyUSB0)
    ser = serial.Serial('/dev/ttyACM0', 115200, timeout=1.0)
    
    try:
        ser.reset_input_buffer()
        print("Väntar på 'S' från FPGA...")
        if not wait_for_S(ser):
            print("Timeout: Hittade inget 'S'.")
            return

        # Läs hela dumpen
        raw_dump = read_ascii_hex_robust(ser, TOTAL_BYTES_TO_READ)
        
        # Logik för RAW8:
        # Eftersom PIXELS_PER_BEAT nu är 8, och WIDTH är 96:
        # En rad = 96 pixlar = 12 klockcykler (beats).
        # Varje beat i BRAM är 8 bytes.
        # Rad 0 börjar på byte 0. Rad 1 börjar på byte 96.
        # Hela bilden (96x96) tar upp exakt de första 9216 byten (96*96).
        
        pixel_data = raw_dump[:(WIDTH * HEIGHT)]
        # Kolla om det finns NÅGON data överhuvudtaget
        non_zero_bytes = [b for b in raw_dump if b != 0]
        print(f"Antal bytes som INTE är noll: {len(non_zero_bytes)} av {len(raw_dump)}")
        if len(non_zero_bytes) > 0:
            print(f"Första 20 icke-noll värdena: {non_zero_bytes[:20]}")
        
        if len(pixel_data) < (WIDTH * HEIGHT):
            print(f"VARNING: Fick bara {len(pixel_data)} pixlar.")
            pixel_data = pixel_data.ljust(WIDTH * HEIGHT, b'\x00')

        # Skapa bilden. 'L' betyder 8-bit grayscale (Luminance).
        img = Image.frombytes('L', (WIDTH, HEIGHT), bytes(pixel_data))
        
        out_name = "output_raw8.png"
        img.save(out_name)
        print(f"Succé! Bild sparad som {out_name}")
        img.show()

    except Exception as e:
        print(f"\nEtt fel uppstod: {e}")
    finally:
        ser.close()

if __name__ == "__main__":
    main()