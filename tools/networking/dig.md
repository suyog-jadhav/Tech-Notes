# Dig

A flexible DNS lookup utility that queries DNS servers for detailed, precisely-formatted record information — the modern, preferred replacement for `nslookup`.

## Purpose

- Queries any DNS record type (A, AAAA, MX, TXT, NS, SOA, CNAME, etc.)
- Shows the full DNS response including query time, flags, and authority sections
- Traces the full DNS resolution chain from root servers down
- Preferred over `nslookup` for scripting and detailed diagnostics due to cleaner, more parseable output

**Layer:** Layer 7 (Application) — a DNS client tool, querying over UDP/TCP port 53.

## Installation

Part of the `dnsutils` (Debian/Ubuntu) or `bind-utils` (Fedora/Arch) package:

```bash
sudo apt install dnsutils     # Debian/Ubuntu
sudo dnf install bind-utils   # Fedora
sudo pacman -S bind           # Arch
```

## Syntax

```bash
dig [@server] domain [record-type] [options]
```

## Flags

| Flag | Description |
|------|--------------|
| `@server` | Query a specific DNS server instead of the system default (e.g. `@8.8.8.8`) |
| `+short` | Show only the resolved answer, no extra output |
| `+trace` | Trace the full resolution path from root DNS servers down to the answer |
| `+noall +answer` | Show only the "answer" section, suppress the rest |
| `-x` | Reverse DNS lookup (IP to hostname) |
| `-t` | Explicitly specify record type (alternative to placing it after domain) |
| `+stats` | Show query statistics (query time, server used, response size) |
| `+tcp` | Force the query over TCP instead of UDP |

## Output Breakdown

Example output:

```
$ dig google.com

;; QUESTION SECTION:
;google.com.                   IN      A

;; ANSWER SECTION:
google.com.             211     IN      A       142.250.183.14

;; Query time: 14 msec
;; SERVER: 192.168.1.1#53(192.168.1.1)
;; WHEN: Wed Jul 22 10:15:03 IST 2026
;; MSG SIZE  rcvd: 55
```

| Field | Meaning |
|-------|---------|
| `QUESTION SECTION` | Echoes back what was queried — domain and record type |
| `ANSWER SECTION` | The actual DNS record(s) returned |
| `211` (in ANSWER) | TTL — how many seconds this record can be cached before it must be re-queried |
| `IN` | Internet class (virtually always `IN` in practice) |
| `A` | Record type returned (IPv4 address in this case) |
| `Query time` | How long the DNS server took to respond — high values can indicate a slow/distant resolver |
| `SERVER` | Which DNS server answered the query |
| `MSG SIZE` | Size of the DNS response packet in bytes |

**Interpreting results:**
- Empty `ANSWER SECTION` with `status: NXDOMAIN` in the header means the domain doesn't exist
- A very low TTL (e.g. under 60s) often indicates a domain that changes IPs frequently (load balancing, failover, or a CDN)
- `+trace` output showing failure partway through the chain pinpoints exactly which DNS server in the hierarchy is misbehaving

## Practical Examples

Quick answer only, no clutter:
```bash
dig +short google.com
```

Query a specific DNS server:
```bash
dig @1.1.1.1 google.com
```

Look up mail servers:
```bash
dig google.com MX
```

Reverse lookup:
```bash
dig -x 142.250.183.14
```

Trace full resolution path from root servers:
```bash
dig +trace google.com
```

**Troubleshooting scenario:** If a domain resolves inconsistently across locations (common with CDNs), run `dig +trace` to see the exact chain of authoritative servers involved, and compare `dig @8.8.8.8` vs `dig @1.1.1.1` to check if the discrepancy is resolver-specific caching or a genuine DNS misconfiguration.

## Related Tools

- [nslookup](./nslookup.md) — simpler, more interactive alternative; `dig` is generally preferred for scripting
- [whois](./whois.md) — look up domain registration info rather than DNS records
- [ping](./ping.md) — test reachability of the IP once resolved
