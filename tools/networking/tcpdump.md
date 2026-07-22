# Tcpdump

A packet-capture tool that intercepts and displays network traffic passing through an interface in real time — the command-line standard for deep packet-level troubleshooting.

## Purpose

- Captures raw packets on a network interface for inspection
- Filters traffic by host, port, protocol, or custom expressions
- Diagnoses issues that higher-level tools (ping, curl) can't explain — e.g. malformed packets, unexpected retransmissions, TLS handshake failures
- Saves captures to `.pcap` files for deeper analysis in tools like Wireshark

**Layer:** Operates at Layer 2 and above — captures raw frames off the wire and can decode headers up through Layer 4 (and inspect Layer 7 payloads on unencrypted traffic).

> **Note:** Capturing traffic you don't own or have permission to monitor can be illegal. Only use on networks/interfaces you control or are authorized to inspect.

## Installation

```bash
sudo apt install tcpdump   # Debian/Ubuntu
sudo dnf install tcpdump   # Fedora
sudo pacman -S tcpdump     # Arch
```

## Syntax

```bash
sudo tcpdump [options] [filter-expression]
```

Root privileges are required since it operates directly on network interfaces.

## Flags

| Flag | Description |
|------|--------------|
| `-i` | Specify the interface to capture on (e.g. `-i eth0`, or `any` for all) |
| `-n` | Don't resolve hostnames — show raw IPs (faster, avoids DNS noise) |
| `-nn` | Also skip port name resolution — show raw port numbers |
| `-c` | Capture a fixed number of packets, then stop |
| `-w` | Write captured packets to a `.pcap` file |
| `-r` | Read packets from a previously saved `.pcap` file |
| `-v`, `-vv`, `-vvv` | Increasing levels of verbosity |
| `-X` | Show packet contents in hex and ASCII |
| `-s` | Snapshot length — how many bytes per packet to capture (0 = full packet) |

**Common filter expressions** (used at the end of the command):

| Filter | Description |
|--------|--------------|
| `host <ip>` | Only traffic to/from a specific host |
| `port <n>` | Only traffic on a specific port |
| `tcp` / `udp` / `icmp` | Only that protocol |
| `src` / `dst` | Restrict to source or destination direction |
| `and`, `or`, `not` | Combine filter expressions |

## Output Breakdown

Example output (`sudo tcpdump -i eth0 -n port 443`):

```
10:32:01.123456 IP 192.168.1.5.52344 > 142.250.183.14.443: Flags [S], seq 123456789, win 64240, length 0
10:32:01.135678 IP 142.250.183.14.443 > 192.168.1.5.52344: Flags [S.], seq 987654321, ack 123456790, win 65535, length 0
10:32:01.135900 IP 192.168.1.5.52344 > 142.250.183.14.443: Flags [.], ack 987654322, win 64240, length 0
```

| Field | Meaning |
|-------|---------|
| Timestamp | When the packet was captured |
| `IP src.port > dst.port` | Source and destination IP:port of the packet |
| `Flags [S]` | TCP flag — `S`=SYN, `.`=ACK, `F`=FIN, `R`=RST, `P`=PUSH; `[S.]` means SYN+ACK combined |
| `seq` / `ack` | TCP sequence and acknowledgment numbers, used to track packet ordering |
| `win` | TCP window size — how much data the sender is willing to receive before an ACK |
| `length` | Payload length in bytes (0 for pure control packets like SYN/ACK) |

**Interpreting results:**
- This three-line pattern (`SYN` → `SYN-ACK` → `ACK`) is a normal TCP three-way handshake completing successfully
- Repeated `SYN` packets with no `SYN-ACK` reply indicates the destination isn't responding — firewall drop or service down
- Frequent `[R]` (RST) packets can indicate a connection being actively refused or reset by a firewall/service

## Practical Examples

Capture traffic on a specific interface:
```bash
sudo tcpdump -i eth0
```

Capture only traffic to/from a specific host:
```bash
sudo tcpdump -i eth0 host 192.168.1.10
```

Capture HTTP/HTTPS traffic only, numeric output:
```bash
sudo tcpdump -i eth0 -nn port 80 or port 443
```

Save captured traffic to a file for later analysis (e.g. in Wireshark):
```bash
sudo tcpdump -i eth0 -w capture.pcap
```

Read back a saved capture:
```bash
tcpdump -r capture.pcap
```

Capture and show packet contents in hex/ASCII (useful for inspecting plaintext protocols):
```bash
sudo tcpdump -i eth0 -X port 80
```

**Troubleshooting scenario:** If a client reports a connection "hangs" rather than failing outright, run `tcpdump` filtered to that host/port on the server — seeing repeated `SYN` packets with no reply confirms the server never even sees the traffic (firewall/routing issue upstream), while seeing a completed handshake followed by silence points to an application-level hang instead.

## Related Tools

- [netcat](./netcat.md) — generate test traffic to capture and inspect with `tcpdump`
- [nmap](./nmap.md) — broader port/service discovery; `tcpdump` for granular packet-level detail on a known issue
- [netstat / ss](./netstat.md) — check connection state locally before diving into packet capture
