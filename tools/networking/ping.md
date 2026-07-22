# Ping

Sends ICMP Echo Request packets to a host and listens for ICMP Echo Reply packets, used to test reachability and measure round-trip latency.

## Purpose

- Checks whether a host is reachable over the network
- Measures round-trip time (RTT) and packet loss
- Often the first command run when diagnosing "the internet is down"

**Layer:** Operates at Layer 3 (Network Layer) using the ICMP protocol — it does not use TCP or UDP, so it bypasses application-level issues entirely and tests raw connectivity.

## Installation

Preinstalled on virtually all Linux, macOS, and Windows systems via `iputils-ping`. If missing:

```bash
sudo apt install iputils-ping   # Debian/Ubuntu
sudo dnf install iputils        # Fedora
sudo pacman -S iputils          # Arch
```

## Syntax

```bash
ping [options] destination
```

`destination` can be a hostname (`ping google.com`) or an IP address (`ping 8.8.8.8`).

## Flags

| Flag | Long form | Description |
|------|-----------|--------------|
| `-c` | `--count` | Number of packets to send, then stop (Linux/macOS keep pinging indefinitely otherwise) |
| `-i` | `--interval` | Seconds between packets (default: 1) |
| `-t` | `--ttl` | Set the Time-To-Live value |
| `-s` | `--size` | Packet size in bytes to send |
| `-w` | `--deadline` | Total time in seconds to run before exiting, regardless of packets sent |
| `-W` | `--timeout` | Time in seconds to wait for a reply per packet |
| `-4` | | Force IPv4 |
| `-6` | | Force IPv6 |
| `-q` | `--quiet` | Only show summary at the end, not each reply |
| `-f` | `--flood` | Flood ping — sends packets as fast as possible (requires root; use with caution) |

> On Windows, `ping` uses different flags: `-n` for count (not `-c`), `-l` for size, `-i` for TTL.

## Output Breakdown

Example output:

```
PING google.com (142.250.183.14) 56(84) bytes of data.
64 bytes from bom07s28-in-f14.1e100.net (142.250.183.14): icmp_seq=1 ttl=117 time=12.4 ms
64 bytes from bom07s28-in-f14.1e100.net (142.250.183.14): icmp_seq=2 ttl=117 time=11.9 ms

--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 11.9/12.1/12.4/0.3 ms
```

| Field | Meaning |
|-------|---------|
| `64 bytes` | Size of the ICMP reply packet received |
| `icmp_seq` | Sequence number of the packet — used to detect dropped or out-of-order packets |
| `ttl` | Time-To-Live remaining on the reply; a lower-than-expected TTL can indicate an unusually long route |
| `time` | Round-trip time in milliseconds — lower is better; consistency matters as much as the raw number |
| `packet loss` | Percentage of packets that got no reply — any loss over 0% signals network issues |
| `rtt min/avg/max/mdev` | Minimum, average, maximum, and mean deviation (jitter) of RTT across all replies — high `mdev` indicates unstable/inconsistent latency |

**Interpreting results:**
- **No reply / 100% loss** — host is unreachable, firewalled, or ICMP is blocked (some servers intentionally block ping)
- **High `time`** — high latency; could be distance, congestion, or a slow link somewhere on the path
- **High `mdev`** — jitter; problematic for real-time traffic like VoIP or gaming even if average latency looks fine

## Practical Examples

Ping with a limited count (recommended for scripts/quick checks):
```bash
ping -c 4 8.8.8.8
```

Ping and only see the final summary:
```bash
ping -c 10 -q github.com
```

Test with a larger packet size (useful for diagnosing MTU/fragmentation issues):
```bash
ping -c 4 -s 1472 google.com
```

Set a deadline so the command won't hang indefinitely:
```bash
ping -w 5 example.com
```

Force IPv6:
```bash
ping -6 -c 4 google.com
```

**Troubleshooting scenario:** If `ping <IP address>` works but `ping <hostname>` fails, the network path is fine but DNS resolution is broken — check with [nslookup](./nslookup.md) next.

## Related Tools

- [traceroute](./traceroute.md) — see *where* along the path connectivity breaks, not just whether the host is reachable
- [nslookup](./nslookup.md) — resolve a hostname to confirm DNS isn't the issue
- [netcat](./netcat.md) — test reachability of a specific port/service rather than just ICMP-level host reachability
