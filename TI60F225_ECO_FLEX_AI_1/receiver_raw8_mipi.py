#!/usr/bin/env python3
"""
receive_raw8_mipi.py - Anpassad för RAW8 (Data Type 0x2A)
Kamera: IMX219, 96x96, RAW8
Hårdvara: Efinix MIPI CSI-2 RX (Pack Type 15), 64-bit buss.
"""

import socket
import sys
import time
from PIL import Image

ETH_IFACE    = 'enp2s0'
UDP_PORT     = 5000
PKT_SIZE     = 1472
RECV_TIMEOUT = 0.5 

# Kamera geometri
CAM_W  = 96
CAM_H  = 96

# I RAW8 med 64-bit buss (Pack Type 15) är varje beat 8 pixlar.
# Inga padding-bytes finns (alla 8 bytes är pixeldata).
BYTES_PER_BEAT = 8
PIXELS_PER_BEAT = 8 

# Beräkna hur mycket data vi förväntar oss i BRAM
# 96 pixlar / 8 pixlar per beat = 12 beats per rad.
# 12 beats * 96 rader = 1152 beats totalt.
# 1152 beats * 8 bytes = 9216 bytes totalt för en frame.
BEATS_PER_ROW    = CAM_W // PIXELS_PER_BEAT
TOTAL_BEATS      = BEATS_PER_ROW * CAM_H
EXPECTED_BYTES   = TOTAL_BEATS * BYTES_PER_BEAT

def receive_frame(sock):
    packets = []
    sock.settimeout(None)
    
    # Vänta på första paketet
    data, addr = sock.recvfrom(PKT_SIZE)
    packets.append(data)
    
    # Fortsätt läsa tills timeout (slutet på framen)
    sock.settimeout(RECV_TIMEOUT)
    try:
        while True:
            data, addr = sock.recvfrom(PKT_SIZE)
            packets.append(data)
    except socket.timeout:
        pass
    
    return b"".join(packets)

def main():
    print(f"Lyssnar på UDP port {UDP_PORT} för RAW8 data...")
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(('', UDP_PORT))

    frame_count = 0
    try:
        while True:
            raw = receive_frame(sock)
            if len(raw) < EXPECTED_BYTES:
                print(f"Varning: Mottog bara {len(raw)} bytes, förväntade {EXPECTED_BYTES}")
                # Vi försöker fortsätta ändå om vi har tillräckligt
                if len(raw) < 100: continue

            # I RAW8 (Pack Type 15) är datan redan i rätt ordning i BRAM.
            # Varje byte i img_data motsvarar en pixel (Grayscale 0-255).
            img_data = raw[:EXPECTED_BYTES]
            
            # Skapa bild direkt från bytes
            img = Image.frombytes('L', (CAM_W, CAM_H), img_data)
            
            filename = f"frame_raw8_{frame_count:04d}.png"
            img.save(filename)
            print(f"Sparade {filename} ({len(img_data)} bytes)")
            
            frame_count += 1
            
    except KeyboardInterrupt:
        print("\nAvbryter...")
    finally:
        sock.close()

if __name__ == "__main__":
    main()