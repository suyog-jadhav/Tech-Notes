# Nmap

A network scanning tool used to discover hosts, open ports, running services, and operating systems on a network — the standard tool for network reconnaissance and security auditing.

## Purpose

- Discovers which hosts are alive on a network
- Identifies open ports and the services running on them
- Detects service versions and, with more aggressive scans, the operating system
- Used for security auditing, inventory of devices on a network, and verifying firewall rules

**Layer:** Layer 3/4 for host/port discovery; can probe up to Layer 7 for service/version detection.

> **Note:** Only scan networks and hosts you own or have explicit permission to test. Unauthorized scanning of third-party systems can violate laws and terms of service.

## Installation

```bash
sudo apt install nmap   # Debian/Ubuntu
sudo dnf install nmap   # Fedora
sudo pacman -S nmap     # Arch
```

## Syntax

```bash
nmap [scan-type] [options] target
```

`target` can be a single IP, hostname, IP range (`192.168.1.1-50`), or CIDR block (`192.168.1.0/24`).

## Flags

| Flag | Description |
|------|--------------|
| `-sS` | TCP SYN scan ("stealth" scan) — fast, doesn't complete full TCP handshake, requires root |
| `-sT` | TCP connect scan — completes full handshake, doesn't require root |
| `-sU` | UDP scan |
| `-sV` | Detect service/version running on open ports |
| `-O` | Attempt OS detection |
| `-p` | Specify port(s) to scan (e.g. `-p 80,443` or `-p 1-1000`) |
| `-p-` | Scan all 65535 ports |
| `-A` | Aggressive scan — enables OS detection, version detection, script scanning, and traceroute |
| `-T4` | Timing template (0=slowest/stealthiest, 5=fastest); T4 is a common balanced choice |
| `-v` | Verbose output |
| `-oN` | Save output to a normal text file |
| `--top-ports` | Scan the N most common ports only |

## Output Breakdown

Example output (`nmap -sV 192.168.1.10`):

```
Starting Nmap 7.94 ( https://nmap.org ) at 2026-07-22 10:30 IST
Nmap scan report for 192.168.1.10
Host is up (0.0021s latency).

PORT     STATE  SERVICE  VERSION
22/tcp   open   ssh      OpenSSH 8.9p1
80/tcp   open   http     nginx 1.24.0
443/tcp  open   https    nginx 1.24.0
3306/tcp closed mysql

Nmap done: 1 IP address (1 host up) scanned in 4.32 seconds
```

| Field | Meaning |
|-------|---------|
| `Host is up` | The target responded, along with the latency observed |
| `PORT` | Port number and protocol (tcp/udp) |
| `STATE` | `open` — service accepting connections; `closed` — reachable but nothing listening; `filtered` — no response, likely blocked by a firewall |
| `SERVICE` | Nmap's best guess at what service typically runs on that port |
| `VERSION` | Actual detected software/version (only with `-sV`), more reliable than the `SERVICE` guess alone |

**Interpreting results:**
- `filtered` ports (rather than `closed`) usually mean a firewall is silently dropping packets — distinct from a service simply not running
- Outdated version strings (e.g. an old OpenSSH or nginx version) are a signal for patching priorities in security audits
- A host showing far more open ports than expected can indicate unnecessary exposed services worth locking down

## Practical Examples

Quick scan of common ports:
```bash
nmap 192.168.1.10
```

Scan a specific port range with service detection:
```bash
nmap -sV -p 1-1000 192.168.1.10
```

Scan an entire subnet to discover live hosts:
```bash
nmap -sn 192.168.1.0/24
```

Full aggressive scan (use only on systems you're authorized to test):
```bash
nmap -A -T4 192.168.1.10
```

Scan all 65535 ports:
```bash
nmap -p- 192.168.1.10
```

**Troubleshooting scenario:** If a service is unreachable from a client but `netstat`/`ss` on the server shows it listening, run `nmap -p <port> <server-ip>` from the client's network — a `filtered` result confirms a firewall between the two is the blocker, not the service itself.

## Related Tools

- [netcat](./netcat.md) — lighter-weight single-port check when a full scan isn't needed
- [netstat / ss](./netstat.md) — confirm from the server side which ports are actually meant to be listening
- [tcpdump](./tcpdump.md) — capture the actual packets if a scan's results need deeper verification
