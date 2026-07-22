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

# Related Tools

* **tcpdump** — Command-line packet capture tool; captures traffic and saves it for analysis in Wireshark.
* **tshark** — Wireshark's command-line counterpart for packet capture and analysis.
* **ss / netstat** — Display active network connections, sockets, and listening ports.
* **iftop / nload** — Monitor real-time network bandwidth usage.
* **ping / traceroute** — Test connectivity and identify routing paths before performing deeper packet analysis with Wireshark.
