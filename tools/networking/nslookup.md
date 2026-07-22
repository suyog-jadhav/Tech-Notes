# Nslookup

Queries DNS servers to resolve a domain name to its IP address, or to look up other DNS record types (MX, NS, TXT, etc.).

## Purpose

- Resolves hostnames to IP addresses and vice versa
- Diagnoses DNS resolution failures ("host not found" type errors)
- Inspects specific DNS record types (A, AAAA, MX, NS, TXT, CNAME)
- Lets you query against a specific DNS server rather than your system's default

**Layer:** Operates at Layer 7 (Application Layer) — DNS runs over UDP/TCP port 53, but `nslookup` itself is a DNS client tool, not a raw transport-layer utility.

## Installation

Part of the `dnsutils` (Debian/Ubuntu) or `bind-utils` (Fedora/Arch) package:

```bash
sudo apt install dnsutils     # Debian/Ubuntu
sudo dnf install bind-utils   # Fedora
sudo pacman -S bind           # Arch
```

> Note: `nslookup` is considered legacy by its own maintainers in favor of `dig`, but it's still widely used for quick lookups and is preinstalled on Windows.

## Syntax

```bash
nslookup [options] domain [dns-server]
```

If no DNS server is specified, it queries your system's configured default resolver.

## Flags

| Flag | Description |
|------|--------------|
| `-type=A` | Query for IPv4 address records (default) |
| `-type=AAAA` | Query for IPv6 address records |
| `-type=MX` | Query for mail exchange records |
| `-type=NS` | Query for authoritative name server records |
| `-type=TXT` | Query for text records (often used for SPF/domain verification) |
| `-type=CNAME` | Query for canonical name (alias) records |
| `-type=ANY` | Query for all available record types |
| `-debug` | Show detailed query/response debug information |
| `-timeout=` | Set query timeout in seconds |
| `-port=` | Query a non-standard DNS port |

## Output Breakdown

Example output:

```
$ nslookup google.com

Server:         192.168.1.1
Address:        192.168.1.1#53

Non-authoritative answer:
Name:   google.com
Address: 142.250.183.14
```

| Field | Meaning |
|-------|---------|
| `Server` | The DNS resolver your query was sent to (usually your router or ISP's DNS, or a custom one if specified) |
| `Address` (top) | IP and port of that DNS server |
| `Non-authoritative answer` | The response came from a resolver's cache, not directly from the domain's authoritative name server — this is normal for everyday lookups |
| `Name` | The domain that was queried |
| `Address` (bottom) | The resolved IP address for that domain |

**Interpreting results:**
- **`** server can't find <domain>: NXDOMAIN`** — the domain doesn't exist, or a typo
- **`connection timed out; no servers could be reached`** — the DNS server itself is unreachable, not a domain-specific issue
- Comparing results from two different DNS servers (e.g. your ISP's vs `8.8.8.8`) helps identify whether an issue is with your local resolver or the domain's actual DNS records

## Practical Examples

Basic lookup:
```bash
nslookup google.com
```

Query against Google's public DNS instead of your default:
```bash
nslookup google.com 8.8.8.8
```

Look up mail server records for a domain:
```bash
nslookup -type=MX google.com
```

Reverse lookup (IP to hostname):
```bash
nslookup 142.250.183.14
```

Interactive mode (allows multiple queries in one session):
```bash
nslookup
> set type=NS
> google.com
> exit
```

**Troubleshooting scenario:** If a website is unreachable, run `nslookup <domain>` against your default DNS and then against `8.8.8.8`. If your default fails but `8.8.8.8` succeeds, your ISP's or local DNS resolver is the problem — not the website.

## Related Tools

- [ping](./ping.md) — after confirming the IP via `nslookup`, test if that IP is actually reachable
- [traceroute](./traceroute.md) — trace the path to the resolved IP if it's reachable but slow
- [dig](./dig.md) — the modern, more detailed replacement for `nslookup`, preferred for scripting
