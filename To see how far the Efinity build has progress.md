To see how far the Efinity build has progressed from your terminal in ~/efinity_p2/BRAM/T120F324_A, you can run any of these commands:

1. Check Live Routing Progress (Current Stage):
bash


tail -n 15 outflow/T120F324_A.route.out
Tip: To watch it live as it calculates iterations, run:

bash


tail -f outflow/T120F324_A.route.out
(Press Ctrl+C to exit the live view).

2. Check Placement Progress (Completed):
bash


tail -n 15 outflow/T120F324_A.place.out
3. Check Overall Toolchain Log:
bash


tail -n 20 outflow/T120F324_A.log

tail -n 15 outflow/T120F324_A.log

tail -f outflow/T120F324_A.log


olle@olle-SSD-256:~/efinity_p2/BRAM/T120F324_A$ ping 192.168.1.50
PING 192.168.1.50 (192.168.1.50) 56(84) bytes of data.
64 bytes from 192.168.1.50: icmp_seq=1 ttl=64 time=0.178 ms
64 bytes from 192.168.1.50: icmp_seq=2 ttl=64 time=0.190 ms
64 bytes from 192.168.1.50: icmp_seq=3 ttl=64 time=0.181 ms
64 bytes from 192.168.1.50: icmp_seq=4 ttl=64 time=0.189 ms
64 bytes from 192.168.1.50: icmp_seq=5 ttl=64 time=0.181 ms
64 bytes from 192.168.1.50: icmp_seq=6 ttl=64 time=0.180 ms
64 bytes from 192.168.1.50: icmp_seq=7 ttl=64 time=0.204 ms
64 bytes from 192.168.1.50: icmp_seq=8 ttl=64 time=0.187 ms
^C
--- 192.168.1.50 ping statistics ---
8 packets transmitted, 8 received, 0% packet loss, time 7148ms
rtt min/avg/max/mdev = 0.178/0.186/0.204/0.007 ms
olle@olle-SSD-256:~/efinity_p2/BRAM/T120F324_A$ 