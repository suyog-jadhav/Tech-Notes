# Wireshark

Wireshark is a **network protocol analyzer (packet analyzer)** used to capture, inspect, and analyze network traffic in real time. It is one of the most widely used tools by network engineers, system administrators, security analysts, and penetration testers for troubleshooting, protocol analysis, and network forensics.

## Purpose

* Captures live network packets from wired or wireless interfaces
* Analyzes communication between devices packet by packet
* Decodes hundreds of network protocols automatically
* Troubleshoots network connectivity and performance issues
* Detects suspicious or malicious network activity
* Verifies application, protocol, and firewall behavior
* Saves captures for later analysis using `.pcap` or `.pcapng` files

**Layer:** Primarily **Layers 2–7** of the OSI model (Data Link to Application), depending on the captured protocol.

---

# Installation

### Debian/Ubuntu

```bash
sudo apt update
sudo apt install wireshark
```

### Fedora

```bash
sudo dnf install wireshark
```

### Arch Linux

```bash
sudo pacman -S wireshark-qt
```

Allow non-root users to capture packets (Linux):

```bash
sudo usermod -aG wireshark $USER
newgrp wireshark
```

Verify installation:

```bash
wireshark --version
```

---

# Starting Wireshark

GUI:

```bash
wireshark
```

Capture directly from terminal (using tshark):

```bash
tshark
```

---

# Common Capture Filters

Capture filters determine **which packets are captured**.

| Filter               | Description                    |
| -------------------- | ------------------------------ |
| `host 192.168.1.10`  | Capture traffic to/from a host |
| `net 192.168.1.0/24` | Capture an entire subnet       |
| `port 80`            | Capture HTTP traffic           |
| `tcp`                | Capture only TCP packets       |
| `udp`                | Capture only UDP packets       |
| `icmp`               | Capture ping packets           |
| `tcp port 22`        | Capture SSH traffic            |
| `not port 53`        | Exclude DNS traffic            |

Example:

```text
tcp port 443
```

Captures only HTTPS traffic.

---

# Common Display Filters

Display filters do **not** affect capture. They filter already captured packets.

| Filter                         | Description                  |
| ------------------------------ | ---------------------------- |
| `ip.addr == 192.168.1.5`       | Show packets involving an IP |
| `tcp`                          | Display TCP packets          |
| `udp`                          | Display UDP packets          |
| `http`                         | Display HTTP packets         |
| `dns`                          | Display DNS packets          |
| `icmp`                         | Display ping traffic         |
| `arp`                          | Display ARP packets          |
| `tcp.port == 80`               | HTTP traffic                 |
| `tcp.port == 443`              | HTTPS traffic                |
| `tcp.flags.syn == 1`           | SYN packets                  |
| `tcp.analysis.retransmission`  | Retransmitted TCP packets    |
| `frame contains "password"`    | Search packet contents       |
| `http.request.method == "GET"` | HTTP GET requests            |

---

# Packet Breakdown

Example packet:

```
Frame 45
Ethernet II
Internet Protocol Version 4
Transmission Control Protocol
Hypertext Transfer Protocol
```

| Section      | Meaning                                                |
| ------------ | ------------------------------------------------------ |
| Frame        | Packet number, size, timestamp                         |
| Ethernet II  | Source and destination MAC addresses                   |
| IPv4         | Source and destination IP addresses                    |
| TCP          | Source port, destination port, sequence numbers, flags |
| HTTP         | Request/response details such as GET, POST, headers    |
| Packet Bytes | Raw hexadecimal representation of the packet           |

---

# Important TCP Flags

| Flag | Meaning                                  |
| ---- | ---------------------------------------- |
| SYN  | Starts a TCP connection                  |
| ACK  | Acknowledges received data               |
| FIN  | Gracefully closes a connection           |
| RST  | Immediately resets a connection          |
| PSH  | Push data immediately to the application |
| URG  | Indicates urgent data                    |

---

# Useful Statistics

Available under **Statistics** menu.

| Option             | Purpose                                      |
| ------------------ | -------------------------------------------- |
| Protocol Hierarchy | Traffic distribution by protocol             |
| Conversations      | Communication between hosts                  |
| Endpoints          | Lists active IP/MAC addresses                |
| IO Graphs          | Network throughput over time                 |
| Flow Graph         | Visualizes packet exchange                   |
| Expert Information | Highlights warnings, errors, retransmissions |

---

# Following Streams

Right-click a packet →

```
Follow → TCP Stream
```

or

```
Follow → HTTP Stream
```

Shows the complete conversation between client and server, making it easier to inspect requests, responses, or transferred data.

---

# Exporting Data

Save capture:

```
File → Save As
```

Formats:

* `.pcap`
* `.pcapng`

Export objects:

```
File → Export Objects
```

Supported protocols include:

* HTTP
* SMB
* DICOM
* TFTP

This allows extracted files (images, documents, etc.) to be recovered from captured traffic when protocols permit.

---

# Practical Examples

### Capture all traffic

```text
Capture Filter:
```

```
(no filter)
```

Captures every packet on the selected interface.

---

### Capture SSH traffic only

```text
Capture Filter:
```

```
tcp port 22
```

---

### Display DNS traffic

```text
Display Filter:
```

```
dns
```

---

### Show traffic from one host

```text
Display Filter:
```

```
ip.addr == 192.168.1.10
```

---

### Find failed TCP connections

```text
Display Filter:
```

```
tcp.flags.reset == 1
```

Displays packets where a TCP connection was forcefully reset.

---

### Detect retransmissions

```text
Display Filter:
```

```
tcp.analysis.retransmission
```

Useful for diagnosing packet loss or poor network performance.

---

### Analyze HTTPS traffic

Capture filter:

```
tcp port 443
```

Although packet contents are encrypted, you can still analyze:

* TLS handshake
* Certificate exchange
* Cipher suites
* Server Name Indication (SNI)
* Connection timing
* Packet sizes

---

# Troubleshooting Scenarios

### Website is slow

Check:

```
tcp.analysis.retransmission
```

Frequent retransmissions often indicate packet loss or congestion.

---

### Cannot resolve a domain

Display filter:

```
dns
```

Verify whether DNS queries receive valid responses or return errors such as `NXDOMAIN`.

---

### High network usage

Open:

```
Statistics → Protocol Hierarchy
```

Identify which protocols consume the most bandwidth.

---

### Frequent connection failures

Display filter:

```
tcp.flags.reset == 1
```

A high number of RST packets may indicate application crashes, firewall interference, or server-side connection resets.

---

Wireshark has **two different filter syntaxes**, and this is one of the most common points of confusion.

1. **Capture Filters** (BPF syntax) → Applied **before** packets are captured.
2. **Display Filters** (Wireshark syntax) → Applied **after** packets have been captured.

---

# Capture Filter Syntax (BPF)

## General Syntax

```text
host <host>
net <network>
port <port>
src <host>
dst <host>
tcp
udp
icmp
arp
and
or
not
```

---

## Host Filters

| Syntax                  | Description                            |
| ----------------------- | -------------------------------------- |
| `host 192.168.1.10`     | Capture traffic to/from host           |
| `src host 192.168.1.10` | Source host only                       |
| `dst host 192.168.1.10` | Destination host only                  |
| `host google.com`       | Capture traffic involving the hostname |

Example

```text
host 192.168.1.100
```

---

## Network Filters

| Syntax                  | Description        |
| ----------------------- | ------------------ |
| `net 192.168.1.0/24`    | Entire subnet      |
| `src net 10.0.0.0/8`    | Source subnet      |
| `dst net 172.16.0.0/16` | Destination subnet |

Example

```text
net 192.168.0.0/24
```

---

## Port Filters

| Syntax            | Description                |
| ----------------- | -------------------------- |
| `port 80`         | Source or destination port |
| `src port 53`     | Source port                |
| `dst port 443`    | Destination port           |
| `portrange 20-25` | Port range                 |

Example

```text
tcp port 443
```

---

## Protocol Filters

```text
tcp
udp
icmp
icmp6
arp
ip
ip6
```

Examples

```text
tcp
```

```text
udp
```

```text
arp
```

---

## MAC Address Filters

```text
ether host AA:BB:CC:DD:EE:FF
```

```text
ether src AA:BB:CC:DD:EE:FF
```

```text
ether dst AA:BB:CC:DD:EE:FF
```

---

## Combining Filters

### AND

```text
tcp and port 80
```

---

### OR

```text
port 80 or port 443
```

---

### NOT

```text
not arp
```

---

### Multiple Conditions

```text
host 192.168.1.10 and tcp port 22
```

---

```text
src host 10.0.0.5 and dst port 443
```

---

```text
tcp port 80 or tcp port 443
```

---

# Display Filter Syntax

Display filters are much more powerful.

---

## General Syntax

```text
field operator value
```

Example

```text
ip.addr == 192.168.1.1
```

---

## Comparison Operators

| Operator   | Meaning               |
| ---------- | --------------------- |
| `==`       | Equal                 |
| `!=`       | Not equal             |
| `>`        | Greater than          |
| `<`        | Less than             |
| `>=`       | Greater than or equal |
| `<=`       | Less than or equal    |
| `contains` | Contains text         |
| `matches`  | Regular expression    |
| `in`       | Value in range        |

---

## IP Address Filters

| Syntax                   | Description           |
| ------------------------ | --------------------- |
| `ip.addr == 192.168.1.5` | Source or destination |
| `ip.src == 192.168.1.5`  | Source only           |
| `ip.dst == 8.8.8.8`      | Destination only      |

Example

```text
ip.addr == 192.168.1.10
```

---

## IPv6

```text
ipv6.addr == 2001:db8::1
```

---

## MAC Address

```text
eth.addr == AA:BB:CC:DD:EE:FF
```

---

## Port Filters

```text
tcp.port == 80
```

```text
udp.port == 53
```

```text
tcp.srcport == 443
```

```text
tcp.dstport == 22
```

---

## Protocol Filters

```text
tcp
```

```text
udp
```

```text
icmp
```

```text
arp
```

```text
dns
```

```text
http
```

```text
tls
```

```text
ssh
```

---

## TCP Flag Filters

| Syntax                 | Meaning     |
| ---------------------- | ----------- |
| `tcp.flags.syn == 1`   | SYN packets |
| `tcp.flags.ack == 1`   | ACK packets |
| `tcp.flags.fin == 1`   | FIN packets |
| `tcp.flags.reset == 1` | RST packets |
| `tcp.flags.push == 1`  | PSH packets |
| `tcp.flags.urg == 1`   | URG packets |

Example

```text
tcp.flags.syn == 1 and tcp.flags.ack == 0
```

Shows only the initial SYN packets starting TCP connections.

---

## HTTP Filters

```text
http
```

```text
http.request
```

```text
http.response
```

```text
http.request.method == "GET"
```

```text
http.request.method == "POST"
```

```text
http.host
```

```text
http.user_agent
```

---

## DNS Filters

```text
dns
```

```text
dns.qry.name
```

```text
dns.flags.response == 1
```

```text
dns.flags.rcode != 0
```

---

## TLS/HTTPS Filters

```text
tls
```

```text
tls.handshake
```

```text
tls.handshake.type == 1
```

(Client Hello)

```text
tls.handshake.type == 2
```

(Server Hello)

---

## ICMP Filters

```text
icmp
```

```text
icmp.type == 8
```

(Echo Request)

```text
icmp.type == 0
```

(Echo Reply)

---

## ARP Filters

```text
arp
```

```text
arp.opcode == 1
```

(Request)

```text
arp.opcode == 2
```

(Reply)

---

## Packet Length

```text
frame.len > 1000
```

---

## Packet Number

```text
frame.number == 50
```

---

## Time

```text
frame.time
```

```text
frame.time_relative
```

---

## Search for Text

```text
frame contains "password"
```

```text
tcp contains "HTTP"
```

---

## Retransmissions

```text
tcp.analysis.retransmission
```

---

## Duplicate ACKs

```text
tcp.analysis.duplicate_ack
```

---

## Lost Segments

```text
tcp.analysis.lost_segment
```

---

## Bad Checksums

```text
tcp.checksum_bad
```

---

## Conversation Between Two Hosts

```text
ip.src == 192.168.1.5 && ip.dst == 8.8.8.8
```

---

## Multiple Hosts

```text
ip.addr == 192.168.1.5 || ip.addr == 192.168.1.6
```

---

## Excluding Traffic

```text
!(arp)
```

or

```text
not arp
```

---

# Logical Operators

| Operator | Description       | Example         |   |                                 |
| -------- | ----------------- | --------------- | - | ------------------------------- |
| `&&`     | Logical AND       | `tcp && http`   |   |                                 |
| `\|\|`   | Logical OR        | `dns \|\| http` |   |                                 |
| `!`      | Logical NOT       | `!icmp`         |   |                                 |
| `()`     | Group expressions | `(http          |   | dns) && ip.addr == 192.168.1.5` |

---

# Practical Filter Examples

| Goal            | Capture Filter                              | Display Filter                             |
| --------------- | ------------------------------------------- | ------------------------------------------ |
| Capture HTTP    | `tcp port 80`                               | `http`                                     |
| Capture HTTPS   | `tcp port 443`                              | `tls`                                      |
| Capture SSH     | `tcp port 22`                               | `ssh`                                      |
| Capture DNS     | `port 53`                                   | `dns`                                      |
| Capture Ping    | `icmp`                                      | `icmp`                                     |
| Only one host   | `host 192.168.1.10`                         | `ip.addr == 192.168.1.10`                  |
| Only TCP        | `tcp`                                       | `tcp`                                      |
| Exclude DNS     | `not port 53`                               | `!dns`                                     |
| TCP SYN packets | *(Not possible directly in capture filter)* | `tcp.flags.syn == 1 && tcp.flags.ack == 0` |
| Retransmissions | *(Not possible during capture)*             | `tcp.analysis.retransmission`              |

> **Key difference:** Capture filters (BPF) are simpler and optimized for deciding **what to record**, while display filters are Wireshark-specific and far more expressive, allowing detailed analysis of the packets already captured.

---
# Related Tools

* **tcpdump** — Command-line packet capture tool; captures traffic and saves it for analysis in Wireshark.
* **tshark** — Wireshark's command-line counterpart for packet capture and analysis.
* **ss / netstat** — Display active network connections, sockets, and listening ports.
* **iftop / nload** — Monitor real-time network bandwidth usage.
* **ping / traceroute** — Test connectivity and identify routing paths before performing deeper packet analysis with Wireshark.
