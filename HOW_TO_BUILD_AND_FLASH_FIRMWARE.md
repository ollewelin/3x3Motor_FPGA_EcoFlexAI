# 1. Rebuild firmware and update outflow/T120F324_A.hex (~10 seconds)
bash rebuild_and_flash.sh
# 2. Flash to SPI Flash via JTAG Bridge (~38 seconds)
./jtag_flash.sh

# 3. test ping
ping 192.168.1.50

olle@olle-SSD-256:~/efinity_p2/BRAM/T120F324_A$ ping 192.168.1.50
PING 192.168.1.50 (192.168.1.50) 56(84) bytes of data.
64 bytes from 192.168.1.50: icmp_seq=1 ttl=64 time=0.177 ms
64 bytes from 192.168.1.50: icmp_seq=2 ttl=64 time=0.190 ms
64 bytes from 192.168.1.50: icmp_seq=3 ttl=64 time=0.195 ms
64 bytes from 192.168.1.50: icmp_seq=4 ttl=64 time=0.205 ms
^C
--- 192.168.1.50 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3057ms
rtt min/avg/max/mdev = 0.177/0.191/0.205/0.010 ms
olle@olle-SSD-256:~/efinity_p2/BRAM/T120F324_A$ 

# 4. test UART debug if attached
olle@olle-SSD-256:~$ picocom -b 115200 /dev/ttyACM0
picocom v3.1

port is        : /dev/ttyACM0
flowcontrol    : none
baudrate is    : 115200
parity is      : none
databits are   : 8
stopbits are   : 1
escape is      : C-a
local echo is  : no
noinit is      : no
noreset is     : no
hangup is      : no
nolock is      : no
send_cmd is    : sz -vv
receive_cmd is : rz -vv -E
imap is        : 
omap is        : 
emap is        : crcrlf,delbs,
logfile is     : none
initstring     : none
exit_after is  : not set
exit is        : no

Type [C-a] [C-h] to see available commands
Terminal ready
[ETH] ARP Reply Sent
[ETH] ICMP Ping Reply Sent [*222*] 
[ETH] ICMP Ping Reply Sent [*222*] 
[ETH] ICMP Ping Reply Sent [*222*] 
[ETH] ICMP Ping Reply Sent [*222*] 
[ETH] ARP Reply Sent


# reset via FT2232 
python3 reset_fpga.py



Example log:

olle@olle-SSD-256:~/efinity_p2/BRAM/T120F324_A$ ./jtag_flash.sh
[1/2] Loading JTAG-to-SPI Bridge into FPGA SRAM...
jtag programming started!
JTAG Programming on ftdi://0x0403:0x6010:1:d/2
Programming '/home/olle/efinix2/efinity-2025.2.288.2.10-linux-x64/efinity/2025.2/pgm/fli/trion/u00220A79_t120.bit' via JTAG at freq 6.0 MHz
Device ID read from JTAG: 0x00220A79
... finished with JTAG programming
[2/2] Programming SPI Flash via JTAG Bridge...
Connecting to JTAG_TAP: efx
Flash device: Winbond W25Q128 16 MiB (JEDEC ID: 0xEF4018) @ JTAG freq 6.0 MHz
Unlock all sectors for write.
Erasing 3468 KiB from flash @ 0x00000000 (may take a while...)
Finished erase in 16 seconds
Writing 3467 KiB to flash @ 0x00000000 ...
Finished write in 22 seconds
Reading 3467 KiB from flash @ 0x00000000 ...
Finished read in 2 seconds
Flash verify successful
Restore Write-protect status register.
JTAG2SPI programming...done

=== Flash complete! ===
Power-cycle the board. Ping should arrive within ~10-12 seconds.
olle@olle-SSD-256:~/efinity_p2/BRAM/T120F324_A$ 