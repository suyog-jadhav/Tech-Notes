# Netstat / ss

Displays active network connections, listening ports, routing tables, and interface statistics on a system.

## Purpose

- Shows which ports are open/listening on your machine
- Lists active TCP/UDP connections and their state
- Identifies which process is using a given port (with elevated privileges)
- Useful for confirming a service is actually running and bound to the expected port

**Layer:** Operates at Layer 3/4 — reports on IP-level routing info as well as TCP/UDP connection states.

## Installation

`netstat` is part of the legacy `net-tools` package, which is **deprecated on most modern distros** in favor of `ss` (from `iproute2`, usually preinstalled).

```bash
sudo apt install net-tools   # Debian/Ubuntu, if netstat is needed specifically
sudo dnf install net-tools   # Fedora
sudo pacman -S net-tools     # Arch
```

`ss` ships by default with `iproute2` on nearly all modern Linux systems — no separate install typically needed.

## Syntax

```bash
netstat [options]
ss [options]
```

## Flags

**netstat**

| Flag | Description |
|------|--------------|
| `-t` | Show TCP connections |
| `-u` | Show UDP connections |
| `-l` | Show only listening sockets |
| `-n` | Show numeric addresses/ports (skip name resolution — faster) |
| `-p` | Show the PID/process name using each socket (requires root for other users' processes) |
| `-a` | Show all connections (listening + established) |
| `-r` | Show the routing table |
| `-i` | Show interface statistics |

**ss** (modern equivalent — same core flags behave similarly)

| Flag | Description |
|------|--------------|
| `-t` | TCP sockets |
| `-u` | UDP sockets |
| `-l` | Listening sockets only |
| `-n` | Numeric output |
| `-p` | Show process using the socket |
| `-a` | All sockets |
| `-s` | Summary statistics |

> Common combo: `netstat -tulnp` or its modern equivalent `ss -tulnp` — TCP + UDP, listening only, numeric, show process.

## Output Breakdown

Example (`ss -tulnp` or `netstat -tulnp`):

```
Netid  State    Recv-Q  Send-Q   Local Address:Port    Peer Address:Port   Process
tcp    LISTEN   0       128      0.0.0.0:22             0.0.0.0:*           users:(("sshd",pid=812,fd=3))
tcp    LISTEN   0       511      127.0.0.1:3306          0.0.0.0:*           users:(("mysqld",pid=1204,fd=21))
tcp    ESTAB    0       0        192.168.1.5:52344       142.250.183.14:443  users:(("firefox",pid=3021,fd=88))
```

| Field | Meaning |
|-------|---------|
| `Netid`/Proto | Protocol — `tcp` or `udp` |
| `State` | Connection state (see below) |
| `Recv-Q` / `Send-Q` | Bytes queued for receiving/sending — non-zero and growing can indicate a stuck or backed-up connection |
| `Local Address:Port` | The local IP and port the socket is bound to — `0.0.0.0` means it's listening on all interfaces |
| `Peer Address:Port` | The remote IP/port for established connections; `0.0.0.0:*` for listening sockets means no specific peer yet |
| `Process` | Which process (PID and name) owns the socket, shown only with `-p` and sufficient privileges |

**Common TCP states:**

| State | Meaning |
|-------|---------|
| `LISTEN` | Socket is open and waiting for incoming connections |
| `ESTABLISHED` | An active, fully connected session |
| `TIME_WAIT` | Connection recently closed, waiting to ensure no stray packets arrive |
| `CLOSE_WAIT` | Remote end closed the connection; local side hasn't finished closing yet |
| `SYN_SENT` | Attempting to establish a connection outbound |

**Interpreting results:**
- A service "not working" but showing `LISTEN` on `127.0.0.1` instead of `0.0.0.0` means it's only accepting local connections — a common misconfiguration for remote access issues
- A large number of connections stuck in `TIME_WAIT` or `CLOSE_WAIT` can indicate an application not closing connections properly

## Practical Examples

Show all listening TCP/UDP ports with the owning process:
```bash
sudo ss -tulnp
```

Show all established connections:
```bash
ss -t state established
```

Legacy equivalent:
```bash
sudo netstat -tulnp
```

Show the routing table:
```bash
netstat -r
# or
ip route
```

Check if a specific port (e.g. 8080) is in use:
```bash
sudo ss -tulnp | grep 8080
```

**Troubleshooting scenario:** If a client gets "connection refused" on a port you expect to be open, run `ss -tulnp` on the server — if the port isn't listed at all, the service isn't running or isn't bound to that port; if it's listed on `127.0.0.1` only, it's not accepting external connections.

## Related Tools

- [netcat](./netcat.md) — test from the *client* side whether a port is actually reachable, complementing netstat's server-side view
- [ifconfig / ip](./ifconfig.md) — check interface-level configuration if a socket seems bound to the wrong address
- [hostname](./hostname.md) — confirm the machine's own address/identity when diagnosing local bindings
