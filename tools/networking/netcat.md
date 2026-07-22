# Netcat (nc)

A general-purpose networking utility for reading from and writing to TCP or UDP connections directly — often called the "Swiss Army knife" of networking tools.

## Purpose

- Tests whether a specific port is open/reachable on a host
- Sends and receives raw data over TCP/UDP without a full client application
- Can act as a simple client, a listening server, a port scanner, or a file-transfer tool
- Commonly used to debug services (e.g. confirming a web server is actually listening on port 80)

**Layer:** Operates at Layer 4 (Transport Layer) — works directly with TCP or UDP, below the application protocols (HTTP, SMTP, etc.) that normally sit on top of them.

## Installation

```bash
sudo apt install netcat-openbsd   # Debian/Ubuntu (OpenBSD variant, recommended)
sudo dnf install nmap-ncat        # Fedora
sudo pacman -S openbsd-netcat     # Arch
```

> Multiple variants exist (`netcat-openbsd`, `netcat-traditional`, `ncat` from the Nmap project). Flag behavior can differ slightly between them — check `nc -h` on your system.

## Syntax

```bash
nc [options] host port        # client mode
nc -l [options] port          # listen mode (server)
```

## Flags

| Flag | Description |
|------|--------------|
| `-l` | Listen mode — turns `nc` into a server waiting for a connection |
| `-p` | Specify local port to use |
| `-v` | Verbose output |
| `-vv` | Extra verbose output |
| `-z` | Zero-I/O mode — used for port scanning, doesn't send data |
| `-u` | Use UDP instead of the default TCP |
| `-w` | Timeout in seconds for connection attempts |
| `-n` | Skip DNS resolution, use IP addresses only (faster) |
| `-k` | Keep listening after a client disconnects (with `-l`) |

## Output Breakdown

Example: checking if a port is open with verbose + zero-I/O mode:

```
$ nc -zv scanme.nmap.org 22
Connection to scanme.nmap.org 22 port [tcp/ssh] succeeded!
```

```
$ nc -zv scanme.nmap.org 81
nc: connect to scanme.nmap.org port 81 (tcp) failed: Connection refused
```

| Output | Meaning |
|--------|---------|
| `succeeded!` | The port is open and something is actively listening/accepting connections |
| `Connection refused` | The host is reachable, but nothing is listening on that port (or a firewall actively rejected it) |
| `Connection timed out` | No response at all — likely blocked by a firewall silently dropping packets, or the host is unreachable |
| `[tcp/ssh]` | `nc` resolved the port number to its commonly known service name (from `/etc/services`) |

**Interpreting results:** "Refused" vs "timed out" is an important distinction — refused means the network path is fine but no service is running; timeout usually means a firewall is silently dropping the traffic somewhere along the path.

## Practical Examples

Check if a specific port is open (most common use case):
```bash
nc -zv example.com 443
```

Scan a range of ports:
```bash
nc -zv example.com 20-25
```

Start a simple listener (useful for testing if traffic reaches a machine):
```bash
nc -l 4444
```

Connect to that listener from another machine:
```bash
nc <server-ip> 4444
```

Send a file over the network:
```bash
# On receiving machine
nc -l 4444 > received_file.txt

# On sending machine
nc <receiver-ip> 4444 < file_to_send.txt
```

Quickly test a web server's response by talking HTTP manually:
```bash
nc example.com 80
GET / HTTP/1.1
Host: example.com

```

**Troubleshooting scenario:** If `ping` succeeds (host is reachable) but your application can't connect, use `nc -zv <host> <port>` to confirm whether the specific port/service is actually open — this isolates "network is fine, service isn't running" from broader connectivity issues.

## Related Tools

- [ping](./ping.md) — confirm basic host reachability before checking specific ports
- [netstat / ss](./netstat.md) — check which ports are listening *locally* rather than testing a remote host
- [traceroute](./traceroute.md) — trace the path if a port appears to time out rather than refuse
