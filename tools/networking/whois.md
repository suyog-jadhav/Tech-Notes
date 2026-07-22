# Whois

Queries domain registration databases to retrieve ownership, registrar, and registration date information for a domain name or IP address block.

## Purpose

- Looks up who registered a domain and through which registrar
- Shows domain creation, update, and expiration dates
- Identifies the authoritative name servers for a domain
- For IP addresses, identifies which organization/ISP owns a given IP block (via regional internet registries)

**Layer:** Layer 7 (Application) — a client for the WHOIS protocol, typically over TCP port 43.

## Installation

```bash
sudo apt install whois   # Debian/Ubuntu
sudo dnf install whois   # Fedora
sudo pacman -S whois     # Arch
```

## Syntax

```bash
whois [options] domain-or-ip
```

## Flags

| Flag | Description |
|------|--------------|
| `-h` | Query a specific WHOIS server instead of the default |
| `-p` | Specify a non-standard port |
| `-H` | Hide legal disclaimers in the output (cleaner output) |

> `whois` has relatively few flags compared to other tools — most of its value comes from simply pointing it at a target.

## Output Breakdown

Example (`whois example.com`, trimmed):

```
Domain Name: EXAMPLE.COM
Registry Domain ID: 2336799_DOMAIN_COM-VRSN
Registrar: RESERVED-Internet Assigned Numbers Authority
Creation Date: 1995-08-14T04:00:00Z
Registry Expiry Date: 2026-08-13T04:00:00Z
Name Server: A.IANA-SERVERS.NET
Name Server: B.IANA-SERVERS.NET
Domain Status: clientTransferProhibited
```

| Field | Meaning |
|-------|---------|
| `Domain Name` | The queried domain, normalized to uppercase |
| `Registrar` | The company through which the domain was registered |
| `Creation Date` | When the domain was first registered |
| `Registry Expiry Date` | When the domain registration currently expires — critical for renewal planning |
| `Name Server` | The authoritative DNS servers configured for this domain |
| `Domain Status` | EPP status codes indicating locks/restrictions (e.g. `clientTransferProhibited` prevents unauthorized transfers) |

**Interpreting results:**
- An approaching `Registry Expiry Date` is a common early-warning check in uptime monitoring — expired domains simply stop resolving
- Mismatched `Name Server` entries vs what you expect can explain why DNS changes aren't taking effect (wrong registrar-side nameservers)
- For privacy-protected domains, registrant contact info will show a proxy/privacy service instead of the actual owner — this is normal and doesn't indicate an error

## Practical Examples

Basic domain lookup:
```bash
whois example.com
```

Look up ownership info for an IP address:
```bash
whois 8.8.8.8
```

Suppress legal disclaimer text for cleaner output:
```bash
whois -H example.com
```

Query a specific WHOIS server directly:
```bash
whois -h whois.verisign-grs.com example.com
```

**Troubleshooting scenario:** If a domain suddenly stops resolving, run `whois <domain>` before anything else — an expired registration or a `Domain Status` showing `serverHold` explains it immediately, without needing to touch DNS tools at all.

## Related Tools

- [dig](./dig.md) / [nslookup](./nslookup.md) — check actual DNS records once ownership/registration is confirmed fine
- [hostname](./hostname.md) — for local machine identity, unrelated to domain registration but often confused with it by name
