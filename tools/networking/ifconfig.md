# Ifconfig / ip

Displays and configures network interfaces — IP addresses, MAC addresses, subnet masks, and interface status.

## Purpose

- Views the IP address(es), MAC address, and status of network interfaces
- Enables/disables network interfaces
- Assigns or removes IP addresses manually
- Views traffic statistics (packets sent/received, errors) per interface

**Layer:** Operates at Layer 2/3 — deals directly with network interfaces (Layer 2, MAC addresses) and their assigned IP configuration (Layer 3).

## Installation

`ifconfig` is part of the legacy `net-tools` package, **deprecated on most modern distros** in favor of `ip` (from `iproute2`).

```bash
sudo apt install net-tools   # Debian/Ubuntu, if ifconfig is needed specifically
sudo dnf install net-tools   # Fedora
sudo pacman -S net-tools     # Arch
```

`ip` ships by default with `iproute2` — already present on nearly all modern Linux installs.

## Syntax

```bash
ifconfig [interface] [options]
ip addr show [interface]        # modern equivalent for viewing
ip link set [interface] [up|down]   # modern equivalent for enabling/disabling
```

## Flags

**ifconfig**

| Flag/Usage | Description |
|------|--------------|
| `ifconfig` (no args) | Show all active interfaces |
| `ifconfig -a` | Show all interfaces, including inactive ones |
| `ifconfig <iface> up` | Bring an interface up (enable it) |
| `ifconfig <iface> down` | Bring an interface down (disable it) |
| `ifconfig <iface> <ip> netmask <mask>` | Manually assign an IP address and subnet mask |
| `ifconfig <iface> mtu <value>` | Set the MTU (max transmission unit) size |

**ip** (modern equivalent)

| Command | Description |
|---------|--------------|
| `ip addr show` | Show all interfaces and their IPs (equivalent to `ifconfig`) |
| `ip link show` | Show interface status (up/down, MAC address) without IP details |
| `ip addr add <ip>/<prefix> dev <iface>` | Assign an IP address |
| `ip link set <iface> up` / `down` | Enable/disable an interface |
| `ip -s link show <iface>` | Show interface traffic statistics |

## Output Breakdown

Example (`ifconfig eth0` or `ip addr show eth0`):

```
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.42  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 fe80::a00:27ff:fe4e:66a1  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:4e:66:a1  txqueuelen 1000  (Ethernet)
        RX packets 84213  bytes 62834923 (59.9 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 51023  bytes 8213445 (7.8 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

| Field | Meaning |
|-------|---------|
| `flags=<UP,BROADCAST,RUNNING,MULTICAST>` | Interface state — `UP` means enabled, `RUNNING` means it has an active link (e.g. cable plugged in) |
| `mtu` | Maximum Transmission Unit — largest packet size the interface will send without fragmentation |
| `inet` | The IPv4 address assigned to this interface |
| `netmask` | Defines the size of the local subnet |
| `broadcast` | The broadcast address for this subnet |
| `inet6` | IPv6 address (often a link-local address starting with `fe80::`) |
| `ether` | The interface's MAC (hardware) address |
| `RX packets` / `TX packets` | Total packets received/transmitted since the interface came up |
| `RX errors` / `TX errors` | Packets that failed to be received/sent correctly — should normally be 0 |
| `dropped` | Packets discarded, often due to buffer limits or filtering |
| `collisions` | Only relevant on old half-duplex networks; should be 0 on modern switched networks |

**Interpreting results:**
- Interface missing `UP` in flags — the interface is administratively disabled
- `UP` but no `RUNNING` — enabled, but no physical link detected (cable unplugged, Wi-Fi not associated)
- Non-zero `errors` or `dropped` counts climbing over time can indicate a bad cable, driver issue, or network congestion

## Practical Examples

Show all active interfaces:
```bash
ifconfig
# or
ip addr show
```

Show a specific interface:
```bash
ifconfig eth0
# or
ip addr show eth0
```

Bring an interface down and back up (useful after config changes):
```bash
sudo ifconfig eth0 down
sudo ifconfig eth0 up
# or
sudo ip link set eth0 down
sudo ip link set eth0 up
```

Manually assign an IP address:
```bash
sudo ifconfig eth0 192.168.1.100 netmask 255.255.255.0
# or
sudo ip addr add 192.168.1.100/24 dev eth0
```

View traffic statistics only:
```bash
ip -s link show eth0
```

**Troubleshooting scenario:** If a machine can't reach the network at all, run `ip addr show` first — no IP address assigned to the interface (or the interface showing `DOWN`) is a very common root cause before even checking DNS or routing.

## Related Tools

- [netstat / ss](./netstat.md) — check what's using the interface's assigned address, once confirmed correct
- [ping](./ping.md) — test connectivity once the interface has a valid IP
- [hostname](./hostname.md) — check the system's own name/identity alongside its interface configuration
