#!/usr/bin/env python3
"""
receive_raw_mipi.py - Receive MIPI CSI-2 frame data via UDP and save as image

Camera:  IMX219, 96×96, RAW10, 2-lane CSI-2 (via csi2_rx_cam_b IP)
BRAM:    64 KB transmitted per frame (~45 UDP packets × 1472 bytes)
Image:   Each 8-byte BRAM beat has 5 useful RAW10 bytes + 3 padding.
         18432 BRAM bytes → strip → 11520 RAW10 bytes → 96×96 8-bit grayscale.

Usage:
    sudo python3 receive_raw_mipi.py
"""

import socket
import struct
import sys
import time

ETH_IFACE    = 'enp2s0'
UDP_PORT     = 5000
PKT_SIZE     = 1472
RECV_TIMEOUT = 0.5    # 500 ms gap = frame boundary

# Camera geometry
CAM_W  = 96
CAM_H  = 96

# CSI-2 IP (PACK_TYPE=15) outputs 64-bit beats:
#   Lower 5 bytes = RAW10 packed (4 pixels per 5 bytes)
#   Upper 3 bytes = zero / padding
# So each 8-byte BRAM word holds 4 pixels (5 useful bytes).
BYTES_PER_BEAT   = 8
USEFUL_PER_BEAT  = 5   # RAW10: 4 px × 10 bit / 8 = 5 bytes
PX_PER_BEAT      = 4

BEATS_PER_ROW  = CAM_W // PX_PER_BEAT          # 24 beats per row
BRAM_BYTES_PER_ROW = BEATS_PER_ROW * BYTES_PER_BEAT  # 192 bytes/row in BRAM
IMAGE_BRAM_BYTES = BRAM_BYTES_PER_ROW * CAM_H  # 18432 bytes of BRAM for one frame

# Full BRAM size transmitted per frame
BRAM_SIZE      = 65536
PKTS_PER_FRAME = (BRAM_SIZE + PKT_SIZE - 1) // PKT_SIZE   # 45


def strip_beats(raw_bram, beats_total, bytes_per_beat=8, useful_per_beat=5):
    """Strip padding bytes from each 64-bit BRAM beat.

    The CSI-2 IP (PACK_TYPE=15) writes 5 useful bytes in the lower
    part of each 8-byte beat, with 3 zero-padding bytes at the top.
    This function extracts only the useful bytes.
    """
    out = bytearray(beats_total * useful_per_beat)
    o = 0
    for i in range(beats_total):
        base = i * bytes_per_beat
        out[o:o+useful_per_beat] = raw_bram[base:base+useful_per_beat]
        o += useful_per_beat
    return bytes(out)


def unpack_raw10_to_gray8(packed_data, width, height):
    """Unpack standard MIPI RAW10 packed data to 8-bit grayscale.

    Input: contiguous RAW10 bytes (after stripping padding).
    Every 5 bytes hold 4 10-bit pixels:
      byte0 = P0[9:2], byte1 = P1[9:2], byte2 = P2[9:2], byte3 = P3[9:2]
      byte4 = P0[1:0] | P1[1:0] | P2[1:0] | P3[1:0]  (low bits)

    We use the full 10→8 conversion: (byte_hi | low_2bits<<8) >> 2
    """
    row_packed = width * 5 // 4   # 120 bytes/row for width=96
    out = bytearray(width * height)
    for row in range(height):
        for grp in range(width // 4):
            base = row * row_packed + grp * 5
            if base + 4 >= len(packed_data):
                break
            b0, b1, b2, b3, b4 = packed_data[base:base+5]
            dst = row * width + grp * 4
            out[dst + 0] = min(255, (b0 | ((b4 & 0x03) << 8)) >> 2)
            out[dst + 1] = min(255, (b1 | ((b4 & 0x0C) << 6)) >> 2)
            out[dst + 2] = min(255, (b2 | ((b4 & 0x30) << 4)) >> 2)
            out[dst + 3] = min(255, (b3 | ((b4 & 0xC0) << 2)) >> 2)
    return bytes(out)


def open_raw_socket(iface):
    """Open a raw socket that captures all Ethernet frames on iface."""
    s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(0x0003))
    s.bind((iface, 0))
    return s


def extract_udp_payload(raw_frame):
    """Extract UDP payload from a raw Ethernet frame. Returns bytes or None."""
    if len(raw_frame) < 42:
        return None
    # Ethernet: dst(6) + src(6) + type(2) = 14 bytes
    eth_type = struct.unpack('!H', raw_frame[12:14])[0]
    if eth_type != 0x0800:  # not IPv4
        return None
    # IP header: at offset 14
    ip_hdr = raw_frame[14:34]
    ihl = (ip_hdr[0] & 0x0F) * 4
    protocol = ip_hdr[9]
    if protocol != 17:  # not UDP
        return None
    # UDP header: at offset 14 + ihl
    udp_offset = 14 + ihl
    if len(raw_frame) < udp_offset + 8:
        return None
    dst_port = struct.unpack('!H', raw_frame[udp_offset+2:udp_offset+4])[0]
    if dst_port != UDP_PORT:
        return None
    # UDP payload starts after 8-byte UDP header
    payload = raw_frame[udp_offset+8:]
    return payload


def receive_frame(sock):
    """Receive one burst of UDP packets (= one BRAM dump). Returns bytes."""
    packets = []
    pkt_count = 0
    start_time = time.time()

    # Wait for first packet
    sock.settimeout(0.1)
    while True:
        try:
            raw_frame = sock.recv(65535)
            pkt_count += 1
            payload = extract_udp_payload(raw_frame)
            if payload and len(payload) > 100:
                packets.append(payload)
                print(f"  >> Got UDP packet #{len(packets)}: {len(payload)} bytes payload")
                break
            # Print status every 2 seconds
            if time.time() - start_time > 2.0:
                print(f"  (received {pkt_count} raw frames, {len(packets)} matched UDP port {UDP_PORT}...)")
                start_time = time.time()
        except socket.timeout:
            if time.time() - start_time > 2.0:
                print(f"  (waiting... {pkt_count} raw frames seen so far)")
                start_time = time.time()
            continue

    # Collect remaining packets — stop after PKTS_PER_FRAME or timeout
    sock.settimeout(RECV_TIMEOUT)
    while len(packets) < PKTS_PER_FRAME:
        try:
            raw_frame = sock.recv(65535)
            payload = extract_udp_payload(raw_frame)
            if payload and len(payload) > 100:
                packets.append(payload)
        except socket.timeout:
            break

    print(f"  >> Collected {len(packets)} packets ({sum(len(p) for p in packets)} bytes)")
    return b''.join(packets)


def hex_dump(data, offset=0, length=128):
    """Print hex dump of data."""
    for i in range(0, min(length, len(data)), 16):
        hex_part = ' '.join(f'{b:02X}' for b in data[i:i+16])
        ascii_part = ''.join(chr(b) if 32 <= b < 127 else '.' for b in data[i:i+16])
        print(f'  {offset+i:04X}: {hex_part:<48s} {ascii_part}')


def find_nonzero_regions(data):
    """Find regions of non-zero data (potential image content)."""
    regions = []
    in_region = False
    start = 0
    for i, b in enumerate(data):
        if b != 0 and not in_region:
            start = i
            in_region = True
        elif b == 0 and in_region:
            if i - start > 4:  # ignore tiny blips
                regions.append((start, i))
            in_region = False
    if in_region and len(data) - start > 4:
        regions.append((start, len(data)))
    return regions


def main():
    sock = open_raw_socket(ETH_IFACE)

    print(f"Capturing raw packets on {ETH_IFACE}, filtering UDP port {UDP_PORT}...")
    print(f"Camera: {CAM_W}x{CAM_H} RAW10  |  "
          f"Image data: {IMAGE_BRAM_BYTES} BRAM bytes ({BEATS_PER_ROW*CAM_H} beats)  |  "
          f"BRAM: {BRAM_SIZE} bytes (~{PKTS_PER_FRAME} packets/frame)")

    # Quick self-test: show first 5 raw frames to confirm socket works
    sock.settimeout(2.0)
    print("\nSelf-test: checking for any Ethernet frames...")
    for i in range(5):
        try:
            raw_frame = sock.recv(65535)
            eth_type = struct.unpack('!H', raw_frame[12:14])[0] if len(raw_frame) >= 14 else 0
            payload = extract_udp_payload(raw_frame)
            tag = " *** OUR UDP ***" if payload else ""
            print(f"  frame {i+1}: {len(raw_frame)} bytes, eth_type=0x{eth_type:04X}, "
                  f"dst={raw_frame[:6].hex()}{tag}")
        except socket.timeout:
            print(f"  frame {i+1}: timeout (no traffic on {ETH_IFACE})")
    print("Self-test done. Waiting for MIPI capture data...\n")

    frame_num = 0
    while True:
        raw = receive_frame(sock)
        frame_num += 1

        print(f"=== Frame {frame_num}: {len(raw)} bytes received ===")

        # Print first 64 bytes as hex for debug
        print("  First 64 bytes (raw BRAM data):")
        hex_dump(raw, 0, 64)

        # Save raw binary dump
        bin_name = f"mipi_raw_{frame_num:04d}.bin"
        with open(bin_name, 'wb') as f:
            f.write(raw)

        # --- Build and save one 96×96 grayscale image ---
        # Each 8-byte BRAM beat has 5 useful RAW10 bytes + 3 padding.
        # 1) Slice the image region from BRAM (18432 bytes = 2304 beats × 8)
        # 2) Strip padding: 2304 beats → 11520 packed RAW10 bytes
        # 3) Unpack RAW10 → 96×96 grayscale
        if len(raw) < IMAGE_BRAM_BYTES:
            print(f"  WARNING: only {len(raw)} bytes received, need {IMAGE_BRAM_BYTES}")

        img_bram = raw[:IMAGE_BRAM_BYTES]
        total_beats = min(len(img_bram) // BYTES_PER_BEAT, BEATS_PER_ROW * CAM_H)
        packed = strip_beats(img_bram, total_beats)

        nonzero = sum(1 for b in packed if b != 0)
        print(f"  Stripped: {len(packed)} RAW10 bytes from {total_beats} beats | "
              f"{nonzero} non-zero ({100*nonzero/max(len(packed),1):.1f}%)")

        try:
            from PIL import Image
            pixels = unpack_raw10_to_gray8(packed, CAM_W, CAM_H)
            img = Image.frombytes('L', (CAM_W, CAM_H), pixels)
            img_name = f"frame_{frame_num:04d}_{CAM_W}x{CAM_H}.png"
            img.save(img_name)
            print(f"  Saved: {img_name}  ({bin_name})")
        except ImportError:
            print(f"  Saved: {bin_name}  (install Pillow for PNG:  pip install Pillow)")
        except Exception as e:
            print(f"  Saved: {bin_name}  (image error: {e})")

        print()


if __name__ == '__main__':
    main()
