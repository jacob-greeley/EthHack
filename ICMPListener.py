#!/usr/bin/env python3
from scapy.all import sniff, ICMP, IP, Raw

captured = {}  # seq_num -> payload bytes

def handle_packet(pkt):
    if pkt.haslayer(ICMP) and pkt[ICMP].type == 8:  # Echo Request
        seq = pkt[ICMP].seq
        if pkt.haslayer(Raw):
            captured[seq] = bytes(pkt[Raw].load)
            print(f"[+] Got chunk seq={seq}, {len(captured[seq])} bytes")

print("[*] Listening for ICMP echo requests... Ctrl+C to stop and write file")
try:
    sniff(filter="icmp", prn=handle_packet, store=0)
except KeyboardInterrupt:
    pass

with open("reassembled_output", "wb") as f:
    for seq in sorted(captured.keys()):
        f.write(captured[seq])
print(f"[+] Wrote {len(captured)} chunks to reassembled_output")
