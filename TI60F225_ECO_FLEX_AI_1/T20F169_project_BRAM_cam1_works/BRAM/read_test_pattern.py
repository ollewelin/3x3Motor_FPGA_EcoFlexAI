#!/usr/bin/env python3
import socket
import struct
import sys
import time
import os
from collections import Counter

# --- KONFIGURATION ---
ETH_IFACE = 'enp2s0' # Kontrollera med 'ip link' om detta är rätt
UDP_PORT = 5000
PKT_SIZE = 1472
# Sänk tröskeln för frame-boundary så vi fångar snabbare strömmar
RECV_TIMEOUT = 0.2  

def open_raw_socket(iface):
    try:
        s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(0x0003))
        s.bind((iface, 0))
        s.settimeout(RECV_TIMEOUT)
        return s
    except PermissionError:
        print("FEL: Du måste köra scriptet med 'sudo'!")
        sys.exit(1)

def extract_udp_payload(raw_frame):
    if len(raw_frame) < 42: return None
    # Kolla om det är IPv4 (0x0800)
    eth_type = struct.unpack('!H', raw_frame[12:14])[0]
    if eth_type != 0x0800: return None
    
    # IP Header (min 20 bytes)
    ip_header = raw_frame[14:34]
    protocol = ip_header[9]
    if protocol != 17: return None # Inte UDP
    
    # UDP Header (8 bytes)
    udp_header = raw_frame[34:42]
    dst_port = struct.unpack('!H', udp_header[2:4])[0]
    
    if dst_port == UDP_PORT:
        return raw_frame[42:]
    return None

def save_diagnostics(frame_data, frame_num):
    if not frame_data: return
    
    raw = bytes(frame_data)
    d0_bytes = raw[0::2] # Jämna bytes (Lane 0)
    d1_bytes = raw[1::2] # Udda bytes (Lane 1)
    
    print(f"\n=== ANALYS AV RAM {frame_num} ===")
    print(f"  Totalt mottaget: {len(raw)} bytes")
    
    # Histogram för att se om det är ett testmönster
    # Color bars ger ofta repetitiva värden som 0xAA, 0x55 eller stegvisa värden
    d0_hist = Counter(d0_bytes).most_common(5)
    print(f"  Vanligaste värden (Lane 0): {', '.join([f'0x{v:02X}({c}st)' for v,c in d0_hist])}")
    
    # Spara binärfil
    fname = f"test_pattern_{frame_num:03d}.bin"
    with open(fname, 'wb') as f:
        f.write(raw)
    
    # Försök skapa en bild (antar 640 i bredd pga camera.c)
    try:
        from PIL import Image
        width = 640
        height = len(d0_bytes) // width
        if height > 5:
            img = Image.frombytes('L', (width, height), d0_bytes[:width*height])
            img.save(f"pattern_{frame_num:03d}_w{width}.png")
            print(f"  Sparade: {fname} och PNG ({width}x{height})")
    except ImportError:
        print("  Tips: Installera 'Pillow' (pip install Pillow) för att spara PNG")

def main():
    print(f"Lyssnar på {ETH_IFACE} efter UDP-port {UDP_PORT}...")
    sock = open_raw_socket(ETH_IFACE)
    
    frame_num = 0
    current_frame = bytearray()
    last_pkt_time = time.time()
    
    try:
        while True:
            try:
                raw_frame, addr = sock.recvfrom(2048)
                payload = extract_udp_payload(raw_frame)
                
                if payload:
                    if time.time() - last_pkt_time > RECV_TIMEOUT and len(current_frame) > 0:
                        # Ny bildruta startar, spara den gamla
                        save_diagnostics(current_frame, frame_num)
                        frame_num += 1
                        current_frame = bytearray()
                    
                    current_frame.extend(payload)
                    last_pkt_time = time.time()
                    if len(current_frame) % (PKT_SIZE * 10) == 0:
                        print(".", end="", flush=True)
                        
            except socket.timeout:
                if len(current_frame) > 0:
                    save_diagnostics(current_frame, frame_num)
                    frame_num += 1
                    current_frame = bytearray()

    except KeyboardInterrupt:
        print("\nAvbryter...")
    finally:
        sock.close()

if __name__ == "__main__":
    main()