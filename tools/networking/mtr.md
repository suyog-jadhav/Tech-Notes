# Mtr (My Traceroute)

Combines the functionality of `ping` and `traceroute` into a single continuously-updating tool, showing live per-hop latency and packet loss statistics.

## Purpose

- Traces the path to a destination like `traceroute`, but continuously re-probes each hop like `ping`
- Reveals intermittent packet loss or latency spikes that a single traceroute snapshot would miss
- The preferred tool for diagnosing "flaky" or intermittent connectivity issues, since it accumulates statistics over time rather than a single pass

**Layer:** Layer 3 — same underlying mechanism as `traceroute` (ICMP/UDP with incrementing TTL), run repeatedly.

## Installation

```bash
sudo apt install mtr        # Debian/Ubuntu
sudo dnf install mtr        # Fedora
sudo pacman -S mtr          # Arch
```

## Syntax

```bash
mtr [options] destination
```

## Flags

| Flag | Long form | Description |
|------|-----------|--------------|
| `-r` | `--report` | Run in report mode — collects data then prints a static summary instead of a live view |
| `-c` | `--report-cycles` | Number of pings sent per hop (default 10 in report mode) |
| `-n` | | Skip DNS resolution, show IPs only (faster) |
| `-b` | `--show-ips` | Show both hostname and IP address |
| `-u` | | Use UDP instead of ICMP |
| `-T` | | Use TCP instead of ICMP |
| `-P` | | Specify port for TCP/UDP mode |
| `-i` | `--interval` | Seconds between pings (default: 1) |
| `-4` / `-6` | | Force IPv4 or IPv6 |

## Output Breakdown

Example (`mtr -r -c 10 google.com`):

```
Start: 2026-07-22T10:40:00+0530
HOST: my-laptop                  Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. 192.168.1.1                  0.0%    10    1.2   1.3   1.1   1.6   0.1
  2. 10.10.10.1                   0.0%    10    4.5   4.6   4.3   5.0   0.2
  3. 100.65.0.1                  20.0%    10    9.8  10.2   9.5  12.1   0.8
  4. 142.250.183.14                0.0%    10   12.4  12.6  12.1  13.0   0.3
```

| Field | Meaning |
|-------|---------|
| `Loss%` | Percentage of probes to that hop that got no reply — the core metric `mtr` adds over plain `traceroute` |
| `Snt` | Number of probes sent to that hop |
| `Last` | Latency of the most recent probe |
| `Avg` | Average latency across all probes to that hop |
| `Best` / `Wrst` | Minimum and maximum observed latency |
| `StDev` | Standard deviation — high values mean inconsistent/jittery latency at that hop |

**Interpreting results:**
- Loss appearing at one hop but **not** at hops after it is usually **not** a real problem — many routers deprioritize/rate-limit ICMP replies to themselves while still forwarding traffic correctly
- Loss appearing at one hop **and every hop after it** indicates a genuine problem at or near that point in the path
- High `StDev` at a hop under otherwise-stable conditions suggests congestion or an unreliable link at that point

## Practical Examples

Live interactive view (default):
```bash
mtr google.com
```

Generate a static report after 10 cycles (useful for sharing with ISPs/support):
```bash
mtr -r -c 10 google.com
```

Use TCP probes on port 443 (bypasses ICMP-blocking firewalls):
```bash
mtr -T -P 443 -r -c 10 google.com
```

Skip DNS resolution for faster output:
```bash
mtr -n google.com
```

**Troubleshooting scenario:** For an intermittent connectivity complaint that a single `ping` or `traceroute` doesn't reproduce, run `mtr -r -c 100 <destination>` to gather loss statistics over a longer window — sustained loss at a consistent hop is strong evidence to escalate to that specific network provider.

## Related Tools

- [ping](./ping.md) — quick single-point reachability check without full path detail
- [traceroute](./traceroute.md) — single-pass path trace; `mtr` is the continuous, statistics-gathering version of the same idea
- [tcpdump](./tcpdump.md) — deeper packet-level inspection once `mtr` narrows down where the issue is
