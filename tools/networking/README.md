# Networking Tools

Command-line networking tools for diagnostics, troubleshooting, and reconnaissance — covering connectivity testing, DNS resolution, routing, interface configuration, connection monitoring, HTTP/file transfer, and packet-level analysis.

## Index

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
| [tcpdump](./tcpdump.md) | Capture and inspect raw network traffic | Layer 2–7 |

## Typical Troubleshooting Flow

A rough order for diagnosing "why can't I reach X":

1. **[hostname](./hostname.md)** / **[ifconfig](./ifconfig.md)** — confirm your own machine has a valid network config
2. **[ping](./ping.md)** — check basic reachability
3. **[nslookup](./nslookup.md)** / **[dig](./dig.md)** — rule out DNS if hostname resolution is involved
4. **[traceroute](./traceroute.md)** / **[mtr](./mtr.md)** — see where along the path things break
5. **[netcat](./netcat.md)** / **[nmap](./nmap.md)** — check if the specific port/service is open
6. **[netstat / ss](./netstat.md)** — check locally what's listening (if you control the server)
7. **[curl](./curl.md)** / **[tcpdump](./tcpdump.md)** — dig into the actual request/response or packet contents
