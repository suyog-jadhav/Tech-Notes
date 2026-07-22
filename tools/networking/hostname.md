# Hostname

Displays or sets the system's hostname — the human-readable name used to identify a machine on a network.

## Purpose

- Views the current hostname of the system
- Temporarily or permanently changes the hostname
- Resolves the system's own IP address(es) tied to its hostname
- Useful in networked environments (servers, clusters) where hostname consistency matters for DNS, SSH, and logging

**Layer:** Sits at the system/network configuration level — the hostname itself isn't a protocol layer, but it's used by DNS (Layer 7) and often appears in Layer 3/4 tool output (e.g. in `netstat`, `traceroute`, log files).

## Installation

Preinstalled on virtually all Linux and macOS systems as part of the base OS (`hostname` command from `hostname` package on Debian-based systems, or built into `systemd` via `hostnamectl`).

```bash
sudo apt install hostname   # rarely needed — nearly always preinstalled
```

## Syntax

```bash
hostname [options] [new-hostname]
hostnamectl [command]   # modern systemd-based equivalent, more feature-rich
```

## Flags

**hostname**

| Flag | Description |
|------|--------------|
| (no args) | Display the current hostname |
| `-f` | Show the fully qualified domain name (FQDN) |
| `-i` | Show the IP address(es) associated with the hostname |
| `-s` | Show the short hostname (strip domain suffix) |
| `-d` | Show the DNS domain name only |
| `new-hostname` | Temporarily set the hostname (until reboot) |

**hostnamectl** (modern systemd equivalent, persists across reboots)

| Command | Description |
|---------|--------------|
| `hostnamectl status` | Show detailed hostname and system info |
| `hostnamectl set-hostname <name>` | Permanently set the hostname |
| `hostnamectl set-hostname <name> --pretty` | Set a "pretty" display name (can include spaces/symbols) |

## Output Breakdown

Example (`hostnamectl status`):

```
 Static hostname: web-server-01
       Icon name: computer-vm
         Chassis: vm
      Machine ID: 4f8a2e1c9b3d4e2f8a1c9b3d4e2f8a1c
         Boot ID: 9b3d4e2f8a1c9b3d4e2f8a1c9b3d4e2f
  Virtualization: kvm
Operating System: Ubuntu 24.04 LTS
          Kernel: Linux 6.8.0-45-generic
    Architecture: x86-64
```

| Field | Meaning |
|-------|---------|
| `Static hostname` | The permanent hostname stored in `/etc/hostname`, persists across reboots |
| `Machine ID` | A unique identifier for the machine, used internally by systemd/logging (not the same as hostname) |
| `Virtualization` | Indicates if the system is running as a VM and under which hypervisor |
| `Operating System` / `Kernel` | Basic system identification info bundled into the same output |

Simple `hostname -i` example:
```
$ hostname -i
192.168.1.42
```
This maps the hostname to its resolvable IP address — useful to confirm `/etc/hosts` or DNS is correctly associating the name with the right IP.

**Interpreting results:**
- `hostname -i` failing or returning `127.0.1.1` unexpectedly often means `/etc/hosts` has a stale or incorrect entry for the hostname
- Mismatched `hostname -f` (FQDN) vs the actual DNS record can break services relying on reverse DNS (mail servers, some TLS certificate checks)

## Practical Examples

Show current hostname:
```bash
hostname
```

Show fully qualified domain name:
```bash
hostname -f
```

Temporarily change hostname (lost on reboot):
```bash
sudo hostname new-name
```

Permanently change hostname (persists across reboots):
```bash
sudo hostnamectl set-hostname new-name
```

Check what IP the hostname currently resolves to locally:
```bash
hostname -i
```

**Troubleshooting scenario:** If SSH or another service throws hostname-resolution warnings on a server, check `/etc/hosts` for a line mapping the hostname to `127.0.1.1` or the correct LAN IP — a missing or incorrect entry here is a very common cause of hostname-related errors distinct from actual DNS issues.

## Related Tools

- [nslookup](./nslookup.md) — verify how the hostname resolves externally via DNS, not just locally
- [ifconfig / ip](./ifconfig.md) — check the actual IP address(es) bound to the machine's interfaces
- [netstat / ss](./netstat.md) — hostname often appears alongside connection/service info in these tools' output
