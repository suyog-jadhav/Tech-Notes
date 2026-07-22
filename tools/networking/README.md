# Networking Tools

Comprehensive documentation and quick references for essential command-line and graphical networking tools — covering connectivity testing, DNS resolution, routing, interface configuration, connection monitoring, HTTP/file transfer, and packet-level analysis.

---

## 📌 Quick Navigation

- [All Tools (A–Z Master Index)](#-all-tools-az-master-index)
- [Categorized Index](#-categorized-index)
  - [Connectivity & Path](#connectivity--path)
  - [DNS & Domain Info](#dns--domain-info)
  - [Ports & Connections](#ports--connections)
  - [Interfaces & System Identity](#interfaces--system-identity)
  - [HTTP & File Transfer](#http--file-transfer)
  - [Packet-Level Analysis](#packet-level-analysis)
- [Tool Selection Matrix by Task](#-tool-selection-matrix-by-task)
- [Typical Troubleshooting Flow](#-typical-troubleshooting-flow)

---

## 🗂️ All Tools (A–Z Master Index)

| Tool | Category | Layer | Purpose |
|------|----------|-------|---------|
| [curl](./curl.md) | HTTP & File Transfer | Layer 7 | Send HTTP requests, test and debug APIs |
| [dig](./dig.md) | DNS & Domain Info | Layer 7 (DNS) | Detailed, scriptable DNS lookups — modern replacement for nslookup |
| [hostname](./hostname.md) | Interfaces & Identity | System / Config | Display or set the system's hostname |
| [ifconfig / ip](./ifconfig.md) | Interfaces & Identity | Layer 2 / 3 | View and configure network interfaces and IP addresses |
| [mtr](./mtr.md) | Connectivity & Path | Layer 3 | Continuous traceroute + ping combined for spotting intermittent loss |
| [netcat](./netcat.md) | Ports & Connections | Layer 4 (TCP/UDP) | Read/write raw data over TCP or UDP connections ("Swiss Army knife") |
| [netstat / ss](./netstat.md) | Ports & Connections | Layer 3 / 4 | View active connections, listening ports, and routing tables |
| [nmap](./nmap.md) | Ports & Connections | Layer 3 / 4 / 7 | Scan hosts/networks for open ports, OS, and running services |
| [nslookup](./nslookup.md) | DNS & Domain Info | Layer 7 (DNS) | Query DNS records interactively or via CLI |
| [ping](./ping.md) | Connectivity & Path | Layer 3 (ICMP) | Test host reachability and measure round-trip latency |
| [tcpdump](./tcpdump.md) | Packet Analysis | Layer 2–7 | Capture and inspect raw network traffic from the command line |
| [traceroute](./traceroute.md) | Connectivity & Path | Layer 3 (ICMP/UDP/TCP) | Trace the path packets take to a destination hop-by-hop |
| [wget](./wget.md) | HTTP & File Transfer | Layer 7 | Non-interactive file download and site mirroring tool |
| [whois](./whois.md) | DNS & Domain Info | Layer 7 | Look up domain registration, registrar, and IP allocation ownership |
| [wireshark](./wireshark.md) | Packet Analysis | Layer 2–7 | GUI protocol analyzer for live packet capture & deep `.pcap` analysis |

---

## 📂 Categorized Index

### Connectivity & Path
| Tool | Purpose | Layer |
|------|---------|-------|
| [ping](./ping.md) | Test host reachability and measure latency | Layer 3 (ICMP) |
| [traceroute](./traceroute.md) | Trace the path packets take to a destination | Layer 3 (ICMP/UDP/TCP) |
| [mtr](./mtr.md) | Continuous traceroute + ping combined, for spotting intermittent loss | Layer 3 |

### DNS & Domain Info
| Tool | Purpose | Layer |
|------|---------|-------|
| [nslookup](./nslookup.md) | Query DNS records for a domain | Layer 7 (DNS) |
| [dig](./dig.md) | Detailed, scriptable DNS lookups — modern replacement for nslookup | Layer 7 (DNS) |
| [whois](./whois.md) | Look up domain registration and ownership info | Layer 7 |

### Ports & Connections
| Tool | Purpose | Layer |
|------|---------|-------|
| [netcat](./netcat.md) | Read/write raw data over TCP or UDP connections | Layer 4 (TCP/UDP) |
| [netstat / ss](./netstat.md) | View active connections, listening ports, and routing tables | Layer 3/4 |
| [nmap](./nmap.md) | Scan hosts/networks for open ports and running services | Layer 3/4/7 |

### Interfaces & System Identity
| Tool | Purpose | Layer |
|------|---------|-------|
| [ifconfig / ip](./ifconfig.md) | View and configure network interfaces | Layer 2/3 |
| [hostname](./hostname.md) | Display or set the system's hostname | System/Network config |

### HTTP & File Transfer
| Tool | Purpose | Layer |
|------|---------|-------|
| [curl](./curl.md) | Send HTTP requests, test and debug APIs | Layer 7 |
| [wget](./wget.md) | Download files and mirror sites non-interactively | Layer 7 |

### Packet-Level Analysis
| Tool | Purpose | Layer |
|------|---------|-------|
| [tcpdump](./tcpdump.md) | Command-line capture and inspection of raw network traffic | Layer 2–7 |
| [wireshark](./wireshark.md) | GUI protocol analyzer for live packet capture and deep protocol inspection | Layer 2–7 |

---

## 🎯 Tool Selection Matrix by Task

| If you want to... | Recommended Tool(s) |
|-------------------|----------------------|
| Test basic IP connectivity to a server | [ping](./ping.md) |
| Find out where along the path traffic is failing | [traceroute](./traceroute.md) or [mtr](./mtr.md) |
| Troubleshoot DNS resolution issues | [dig](./dig.md) or [nslookup](./nslookup.md) |
| Find owner/registrar details of a domain or IP | [whois](./whois.md) |
| See open listening ports on your local machine | [netstat / ss](./netstat.md) |
| Discover open ports and services on a remote target | [nmap](./nmap.md) |
| Test if a remote TCP/UDP port is accepting connections | [netcat](./netcat.md) |
| Check local IP address and network interface state | [ifconfig / ip](./ifconfig.md) |
| Check or set system hostname | [hostname](./hostname.md) |
| Test REST APIs or make HTTP requests | [curl](./curl.md) |
| Download large files or recursively mirror web pages | [wget](./wget.md) |
| Capture packets directly on a headless Linux server | [tcpdump](./tcpdump.md) |
| Deeply analyze packet dumps visually with filters | [wireshark](./wireshark.md) |

---

## 🔍 Typical Troubleshooting Flow

A systematic order for diagnosing "why can't I reach X":

1. **[hostname](./hostname.md)** / **[ifconfig](./ifconfig.md)** — Confirm your own machine has a valid IP address and network interface state.
2. **[ping](./ping.md)** — Check basic Layer 3 reachability to the target IP.
3. **[nslookup](./nslookup.md)** / **[dig](./dig.md)** — Rule out DNS resolution problems if connecting via domain name.
4. **[traceroute](./traceroute.md)** / **[mtr](./mtr.md)** — Pinpoint where along the network path packets are dropped.
5. **[netcat](./netcat.md)** / **[nmap](./nmap.md)** — Test if the specific target port/service is open and listening.
6. **[netstat / ss](./netstat.md)** — Inspect local sockets and listening processes (if you control the target host).
7. **[curl](./curl.md)** / **[wget](./wget.md)** — Test application layer response (HTTP headers, status codes, payload).
8. **[tcpdump](./tcpdump.md)** / **[wireshark](./wireshark.md)** — Capture raw traffic on CLI or analyze `.pcap` files visually for deep packet analysis.

