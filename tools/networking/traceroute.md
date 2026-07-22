# Traceroute

Maps the path packets take from your machine to a destination host, showing every intermediate router (hop) along the way and the latency to each.

## Purpose

- Identifies each router/hop between source and destination
- Pinpoints *where* in the path latency or packet loss is occurring
- Useful when `ping` shows failure/high latency but you need to know if the problem is local, at your ISP, or on the destination's end

**Layer:** Operates at Layer 3, typically using UDP packets with incrementing TTL values on Linux/macOS (ICMP Echo on Windows' `tracert`). It exploits ICMP "Time Exceeded" messages returned by routers when a packet's TTL hits zero.

## Installation

Often preinstalled; if not:

```bash
sudo apt install traceroute   # Debian/Ubuntu
sudo dnf install traceroute   # Fedora
sudo pacman -S traceroute     # Arch
```

On Windows, the equivalent built-in command is `tracert`.

## Syntax

```bash
traceroute [options] destination
```

## Flags

| Flag | Long form | Description |
|------|-----------|--------------|
| `-m` | `--max-hops` | Maximum number of hops to probe (default: 30) |
| `-q` | `--queries` | Number of probe packets sent per hop (default: 3) |
| `-w` | `--wait` | Time in seconds to wait for a response per probe |
| `-I` | `--icmp` | Use ICMP Echo instead of UDP for probes |
| `-T` | `--tcp` | Use TCP SYN for probes (useful when UDP/ICMP is firewalled) |
| `-p` | `--port` | Set the destination port (for UDP/TCP probes) |
| `-n` | | Show numeric IP addresses only, skip reverse DNS lookups (much faster) |
| `-4` | | Force IPv4 |
| `-6` | | Force IPv6 |

## Output Breakdown

Example output:

```
traceroute to google.com (142.250.183.14), 30 hops max, 60 byte packets
 1  192.168.1.1 (192.168.1.1)  1.203 ms  1.150 ms  1.102 ms
 2  10.10.10.1 (10.10.10.1)  4.512 ms  4.389 ms  4.301 ms
 3  * * *
 4  72.14.215.85 (72.14.215.85)  10.223 ms  10.101 ms  9.998 ms
 5  142.250.183.14 (142.250.183.14)  12.410 ms  12.201 ms  12.150 ms
```

| Field | Meaning |
|-------|---------|
| Hop number (leftmost) | Position of this router in the path, starting from your machine |
| Hostname/IP | The router or host that responded at this hop |
| Three time values | Round-trip time for each of the 3 probe packets sent to that hop — compare them to spot inconsistent latency |
| `* * *` | No response received for that hop's probes — usually because a router is dropping or rate-limiting the response, **not necessarily a failure of the path itself** |

**Interpreting results:**
- Latency that jumps sharply at one hop and stays high afterward usually indicates that hop (or the link just after it) is the bottleneck
- A few `* * *` rows in the middle of an otherwise-successful trace are common and often harmless (routers deprioritizing ICMP)
- If the trace stops completely and never reaches the destination, the issue lies at or after the last responding hop

## Practical Examples

Basic trace:
```bash
traceroute google.com
```

Skip reverse DNS lookups for faster results:
```bash
traceroute -n google.com
```

Limit to 15 hops:
```bash
traceroute -m 15 google.com
```

Use TCP probes on port 443 (useful when ISPs/firewalls block the default UDP probes):
```bash
traceroute -T -p 443 google.com
```

**Troubleshooting scenario:** If `ping` to a destination times out entirely but you need to know if that's expected (many servers block ICMP) or a genuine path issue, run `traceroute -T -p 443` to that host — if it completes using TCP, ICMP is simply being filtered somewhere, not a real connectivity problem.

## Related Tools

- [ping](./ping.md) — quick reachability/latency check before diving into a full path trace
- [netcat](./netcat.md) — confirm whether a specific port is actually reachable/open at the destination
- [nslookup](./nslookup.md) — verify the destination hostname resolves to the expected IP before tracing
