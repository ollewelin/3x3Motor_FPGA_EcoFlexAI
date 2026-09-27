grab frame


# add yourself to plugdev (and dialout just in case)
sudo usermod -aG plugdev,dialout $USER
# then log out and back in (or reboot) so the new groups apply
groups


sudo stty -F /dev/ttyUSB0 3000000 cs8 -parenb -cstopb -ixon -ixoff -crtscts raw -echo
# (optional) lower FTDI latency to 1 ms for tighter bursts
echo 1 | sudo tee /sys/bus/usb-serial/devices/ttyUSB0/latency_timer

dd if=/dev/ttyUSB0 of=frame.bin bs=18432 count=1 iflag=fullblock status=progress
hexdump -Cv -n 128 frame.bin

hexdump -Cv -n 512 /dev/ttyUSB0
python view_raw10.py 



sudo stty -F /dev/ttyACM0 115200 cs8 -parenb -cstopb -ixon -ixoff -crtscts raw -echo
# (optional) lower FTDI latency to 1 ms for tighter bursts
echo 1 | sudo tee /sys/bus/usb-serial/devices/ttyACM0/latency_timer

dd if=/dev/ttyACM0 of=frame.bin bs=18432 count=1 iflag=fullblock status=progress
hexdump -Cv -n 128 frame.bin

# Read 10 bytes and write them to test.bin
head -c 10 /dev/ttyACM0 > test.bin

# Check what you got
hexdump -Cv test.bin

sudo stty -F /dev/ttyACM0 115200 cs8 -parenb -cstopb -ixon -ixoff -crtscts -hupcl clocal raw -echo

dd if=/dev/ttyACM0 of=frame.bin bs=1000 count=1 iflag=fullblock status=progress
hexdump -Cv -n 128 frame.bin

stty -F /dev/ttyACM0 flush

dd if=/dev/ttyACM0 of=frame.bin bs=1000 count=1 iflag=fullblock status=progress 
\ hexdump -Cv -n 128 frame.bin

dd if=/dev/ttyACM0 of=frame.bin bs=18432 count=1 iflag=fullblock status=progress
hexdump -Cv -n 128 frame.bin


# flush, then capture exactly 10k
stty -F /dev/ttyACM0 flush
dd if=/dev/ttyACM0 of=frame.bin bs=10000 count=1 iflag=fullblock status=progress


# Put the port into raw mode and block until data comes in
stty -F /dev/ttyACM0 raw -echo -echoe -echok -echoctl -echoke \
     -icanon -isig -iexten -ixon -ixoff -icrnl -inlcr -igncr \
     -istrip -inpck -parmrk min 3 time 0




#
stty -F /dev/ttyACM0 flush
# 0) (recommended once) make sure nothing else is poking the port:
# sudo systemctl disable --now ModemManager.service
# 1) Open the port and keep the file descriptor (asserts DTR, prevents “instant EOF”)
exec 3</dev/ttyACM0
# 2) Put it in raw, blocking mode (VMIN=1, VTIME=0), ignore carrier, don’t hang up
stty -F /dev/ttyACM0 raw -echo -echoe -echok -echoctl -echoke \
     -icanon -isig -iexten -ixon -ixoff -icrnl -inlcr -igncr \
     -istrip -inpck -parmrk clocal -hupcl min 1 time 0
# (optional) flush any stale bytes
stty -F /dev/ttyACM0 flush
# 3) NOW use dd on the already-open FD — this will BLOCK until full block is read
dd if=/proc/self/fd/3 of=frame.bin bs=1000 count=1 iflag=fullblock status=progress


python3 read_hex_after_S.py /dev/ttyACM0 115200 8192 -o frame.bin --preview

hexdump -Cv -n 128 frame.bin

python3 read_frame_image.py /dev/ttyACM0 115200 --width 96 --height 96 --out frame.png

python3 read_frame_auto_map.py /dev/ttyACM0 115200 --width 96 --height 96
