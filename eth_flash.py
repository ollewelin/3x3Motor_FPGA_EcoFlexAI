#!/usr/bin/env python3
"""
eth_flash.py - Robust Remote In-System SPI Flash Programmer over 100M Ethernet (UDP)

Target: Efinix Trion T120F324 FPGA Board
SPI Flash: Winbond W25Q128JVSIQ (16MB)
FPGA IP: 192.168.1.50, Port: 5000 (UDP)
"""

import sys
import time
import socket
import argparse
import os

DEFAULT_IP = "192.168.1.50"
DEFAULT_PORT = 5000

CMD_PING        = 0x01
CMD_SECTOR_4K   = 0x02
CMD_BLOCK_64K   = 0x03
CMD_PAGE_PROG   = 0x04
CMD_READ_DATA   = 0x05

def drain_socket(sock, timeout=1.0):
    """Drain any stray or stale packets from the socket buffer without resetting timeout."""
    sock.settimeout(0.0)
    try:
        while True:
            data = sock.recv(2048)
            if not data:
                break
    except (BlockingIOError, socket.error):
        pass
    sock.settimeout(timeout)

def send_recv_udp(sock, target_ip, target_port, packet, timeout=1.0, max_retries=3):
    sock.settimeout(timeout)
    for attempt in range(max_retries):
        drain_socket(sock, timeout)
        try:
            sock.sendto(packet, (target_ip, target_port))
            t_end = time.time() + timeout
            while time.time() < t_end:
                try:
                    data, _ = sock.recvfrom(2048)
                except socket.timeout:
                    break
                if len(data) >= 2 and data[0] == packet[0]:
                    # For erase and page write commands, check that echoed address matches
                    if packet[0] in [CMD_SECTOR_4K, CMD_BLOCK_64K, CMD_PAGE_PROG] and len(data) >= 6 and len(packet) >= 5:
                        if data[2:6] == packet[1:5]:
                            return data
                        # Address mismatch: stale delayed packet, discard and keep waiting
                        continue
                    return data
        except socket.error:
            pass
        time.sleep(0.01)
    return None

def ping_flash(sock, target_ip, target_port):
    req = bytes([CMD_PING])
    resp = send_recv_udp(sock, target_ip, target_port, req, timeout=1.0)
    if resp and len(resp) >= 5 and resp[0] == CMD_PING and resp[1] == 0x00:
        mfg = resp[2]
        mtype = resp[3]
        cap = resp[4]
        jedec_id = (mfg << 16) | (mtype << 8) | cap
        return jedec_id
    return None

def read_chunk(sock, target_ip, target_port, addr, length):
    req = bytes([CMD_READ_DATA, (addr >> 24) & 0xFF, (addr >> 16) & 0xFF, (addr >> 8) & 0xFF, addr & 0xFF,
                 (length >> 8) & 0xFF, length & 0xFF])
    resp = send_recv_udp(sock, target_ip, target_port, req, timeout=1.5, max_retries=5)
    if resp and len(resp) >= 2 + length and resp[1] == 0:
        return resp[2 : 2 + length]
    return None

def dump_flash(sock, target_ip, target_port, start_addr, count):
    print(f"[*] Reading {count} bytes from flash address 0x{start_addr:06X} via {target_ip}:{target_port}...")
    cur = 0
    all_data = bytearray()
    while cur < count:
        chunk_len = min(256, count - cur)
        addr = start_addr + cur
        chunk = read_chunk(sock, target_ip, target_port, addr, chunk_len)
        if chunk is None:
            print(f"[-] Read failed at address 0x{addr:06X}")
            return False
        all_data.extend(chunk)
        cur += chunk_len

    for i in range(0, len(all_data), 16):
        chunk = all_data[i : i + 16]
        hex_str = " ".join(f"{b:02X}" for b in chunk)
        ascii_str = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
        print(f"{start_addr + i:06X}: {hex_str:<48}  |{ascii_str}|")
    return True

def erase_flash(sock, target_ip, target_port, start_addr, length):
    end_addr = start_addr + length
    cur = start_addr & ~0xFFF  # align to 4KB
    total_blocks = (end_addr - cur + 65535) // 65536
    blocks_done = 0

    print(f"[*] Erasing flash range 0x{start_addr:06X} - 0x{end_addr:06X} ({length} bytes)...")

    while cur < end_addr:
        # Check if 64KB block erase can be used
        if (cur % 65536 == 0) and (cur + 65536 <= end_addr + 4096):
            req = bytes([CMD_BLOCK_64K, (cur >> 24) & 0xFF, (cur >> 16) & 0xFF, (cur >> 8) & 0xFF, cur & 0xFF])
            # Winbond 64KB block erase can take up to 2.0s in hardware, use 5.0s timeout
            resp = send_recv_udp(sock, target_ip, target_port, req, timeout=5.0, max_retries=4)
            if not resp or resp[1] != 0:
                raise RuntimeError(f"Failed to erase 64KB block at 0x{cur:06X}")
            cur += 65536
            blocks_done += 1
            print(f"    Erased 64KB block at 0x{cur - 65536:06X} [{blocks_done}/{total_blocks}]", end="\r")
        else:
            req = bytes([CMD_SECTOR_4K, (cur >> 24) & 0xFF, (cur >> 16) & 0xFF, (cur >> 8) & 0xFF, cur & 0xFF])
            # 4KB sector erase timeout 2.0s
            resp = send_recv_udp(sock, target_ip, target_port, req, timeout=2.0, max_retries=4)
            if not resp or resp[1] != 0:
                raise RuntimeError(f"Failed to erase 4KB sector at 0x{cur:06X}")
            cur += 4096
    print("\n[+] Erase completed successfully.")

def program_flash(sock, target_ip, target_port, start_addr, data):
    total = len(data)
    cur = 0
    print(f"[*] Programming {total} bytes ({total/(1024*1024):.2f} MB) to flash starting at 0x{start_addr:06X}...")
    t0 = time.time()

    while cur < total:
        chunk_len = min(256, total - cur)
        page_offset = (start_addr + cur) % 256
        if page_offset + chunk_len > 256:
            chunk_len = 256 - page_offset

        addr = start_addr + cur
        chunk = data[cur : cur + chunk_len]

        req = bytearray([CMD_PAGE_PROG, (addr >> 24) & 0xFF, (addr >> 16) & 0xFF, (addr >> 8) & 0xFF, addr & 0xFF,
                         (chunk_len >> 8) & 0xFF, chunk_len & 0xFF])
        req.extend(chunk)

        resp = send_recv_udp(sock, target_ip, target_port, bytes(req), timeout=1.0, max_retries=3)

        # Fallback: if ACK was lost, check if page was actually programmed into flash
        if not resp or resp[1] != 0:
            time.sleep(0.005)
            verify_read = read_chunk(sock, target_ip, target_port, addr, chunk_len)
            if verify_read == chunk:
                # The page was programmed successfully, only the ACK UDP packet was dropped!
                pass
            else:
                # Retry programming once more
                time.sleep(0.01)
                resp = send_recv_udp(sock, target_ip, target_port, bytes(req), timeout=2.0, max_retries=3)
                if not resp or resp[1] != 0:
                    raise RuntimeError(f"Page write failed at address 0x{addr:06X}")

        cur += chunk_len
        # Small 200us pacing to avoid overwhelming the FPGA MAC receiver FIFO
        time.sleep(0.0002)

        if cur % 16384 == 0 or cur == total:
            pct = (cur * 100.0) / total
            elapsed = time.time() - t0
            rate = (cur / 1024.0) / elapsed if elapsed > 0 else 0
            print(f"    Progress: {cur}/{total} bytes ({pct:.1f}%) - {rate:.1f} KB/s", end="\r")

    print("\n[+] Programming completed successfully.")

def verify_flash(sock, target_ip, target_port, start_addr, original_data):
    total = len(original_data)
    cur = 0
    print(f"[*] Verifying {total} bytes against flash memory...")
    t0 = time.time()

    while cur < total:
        chunk_len = min(256, total - cur)
        addr = start_addr + cur

        read_data = read_chunk(sock, target_ip, target_port, addr, chunk_len)
        if read_data is None:
            raise RuntimeError(f"Flash read failed at address 0x{addr:06X}")

        orig_chunk = original_data[cur : cur + chunk_len]

        if read_data != orig_chunk:
            for idx in range(chunk_len):
                if read_data[idx] != orig_chunk[idx]:
                    raise ValueError(f"Verification mismatch at 0x{addr + idx:06X}: expected 0x{orig_chunk[idx]:02X}, read 0x{read_data[idx]:02X}")

        cur += chunk_len
        if cur % 16384 == 0 or cur == total:
            pct = (cur * 100.0) / total
            print(f"    Verified: {cur}/{total} bytes ({pct:.1f}%)", end="\r")

    print("\n[+] Verification PASSED! Data in SPI flash matches perfectly.")

def load_bitstream_file(filename):
    if filename.endswith(".hex"):
        print(f"[*] Parsing ASCII hex bitstream: {filename}...")
        t0 = time.time()
        with open(filename, "r") as f:
            lines = f.read().splitlines()
        data = bytes([int(x[:2], 16) for x in lines if len(x) >= 2])
        print(f"[*] Parsed {len(lines)} lines into {len(data)} binary bytes ({len(data)/(1024*1024):.2f} MB) in {time.time()-t0:.2f}s")
        return data
    else:
        with open(filename, "rb") as f:
            return f.read()

def main():
    parser = argparse.ArgumentParser(description="Program Efinix T120 SPI Flash over 100M Ethernet")
    parser.add_argument("bitstream", nargs="?", help="Path to bitstream file (.hex or .bin)")
    parser.add_argument("--ping", action="store_true", help="Ping FPGA and query SPI Flash JEDEC ID")
    parser.add_argument("--dump", type=int, default=0, help="Dump N bytes from flash starting at --addr")
    parser.add_argument("--addr", default="0x000000", help="Flash start address (default: 0x000000)")
    parser.add_argument("--ip", default=DEFAULT_IP, help=f"FPGA IP address (default: {DEFAULT_IP})")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT, help=f"FPGA UDP port (default: {DEFAULT_PORT})")
    parser.add_argument("--no-verify", action="store_true", help="Skip read-back verification")
    parser.add_argument("--verify-only", action="store_true", help="Only verify flash content against bitstream (do not erase/write)")
    args = parser.parse_args()

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    start_addr = int(args.addr, 0)

    # 1. PING / TEST CONNECTION
    if args.ping or (not args.bitstream and args.dump == 0 and not args.verify_only):
        print(f"[*] Querying FPGA at {args.ip}:{args.port} for SPI Flash ID...")
        jedec_id = ping_flash(sock, args.ip, args.port)
        if jedec_id:
            print(f"[+] SUCCESS: Found SPI Flash! JEDEC ID = 0x{jedec_id:06X}")
            if (jedec_id >> 16) == 0xEF and (jedec_id & 0xFFFF) == 0x4018:
                print("    Chip: Winbond W25Q128JV (16 MByte / 128 Mbit)")
        else:
            print(f"[-] FAILED: No response from FPGA at {args.ip}:{args.port}. Check link.")
            sys.exit(1)
        if not args.bitstream and args.dump == 0:
            sys.exit(0)

    # 2. DUMP FLASH
    if args.dump > 0:
        if not dump_flash(sock, args.ip, args.port, start_addr, args.dump):
            sys.exit(1)
        sys.exit(0)

    # 3. FLASH BITSTREAM
    filename = args.bitstream
    if not os.path.isfile(filename):
        print(f"[-] Error: file not found: {filename}")
        sys.exit(1)

    file_bytes = load_bitstream_file(filename)
    print(f"[*] Bitstream {filename}: {len(file_bytes)} bytes ({len(file_bytes)/(1024*1024):.2f} MB)")

    if args.verify_only:
        t_start = time.time()
        verify_flash(sock, args.ip, args.port, start_addr, file_bytes)
        print(f"[+] Verification completed in {time.time()-t_start:.1f} seconds!")
        sys.exit(0)

    t_start = time.time()
    erase_flash(sock, args.ip, args.port, start_addr, len(file_bytes))
    program_flash(sock, args.ip, args.port, start_addr, file_bytes)

    if not args.no_verify:
        verify_flash(sock, args.ip, args.port, start_addr, file_bytes)

    total_time = time.time() - t_start
    print(f"\n[+] ALL DONE in {total_time:.1f} seconds! Power cycle the board to boot new image from flash.")

if __name__ == "__main__":
    main()
