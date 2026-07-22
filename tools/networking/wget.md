# Wget

A non-interactive command-line tool for downloading files from the web over HTTP, HTTPS, and FTP — built for reliability on unstable connections and recursive/bulk downloads.

## Purpose

- Downloads single files or entire directory trees from a server
- Resumes interrupted downloads automatically
- Mirrors entire websites for offline use
- Runs non-interactively, making it well suited for scripts and cron jobs (its name literally means "web get")

**Layer:** Layer 7 (Application) — operates over HTTP/HTTPS/FTP.

## Installation

Preinstalled on most Linux distros. If missing:

```bash
sudo apt install wget   # Debian/Ubuntu
sudo dnf install wget   # Fedora
sudo pacman -S wget     # Arch
```

> Not preinstalled on macOS — install via `brew install wget`.

## Syntax

```bash
wget [options] URL
```

## Flags

| Flag | Long form | Description |
|------|-----------|--------------|
| `-O` | `--output-document` | Save the file under a specific name |
| `-P` | `--directory-prefix` | Save into a specific directory |
| `-c` | `--continue` | Resume a partially downloaded file |
| `-b` | `--background` | Download in the background |
| `-q` | `--quiet` | Suppress output |
| `-r` | `--recursive` | Download recursively (e.g. entire site/directory) |
| `-np` | `--no-parent` | When recursing, don't ascend to the parent directory |
| `--limit-rate` | | Cap download speed (e.g. `--limit-rate=200k`) |
| `--mirror` | | Shortcut for recursive download suitable for mirroring a full site |
| `-t` | `--tries` | Number of retry attempts on failure |
| `-U` | `--user-agent` | Set a custom User-Agent string |

## Output Breakdown

Example output:

```
$ wget https://example.com/file.zip

--2026-07-22 10:20:01--  https://example.com/file.zip
Resolving example.com (example.com)... 93.184.216.34
Connecting to example.com (example.com)|93.184.216.34|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 10485760 (10M) [application/zip]
Saving to: 'file.zip'

file.zip     100%[===================>]  10.00M  2.45MB/s    in 4.1s

2026-07-22 10:20:05 (2.45 MB/s) - 'file.zip' saved [10485760/10485760]
```

| Field | Meaning |
|-------|---------|
| `Resolving ...` | DNS resolution step — shows the IP resolved for the hostname |
| `Connecting ... connected` | TCP connection established to that IP |
| `HTTP request sent, awaiting response... 200 OK` | Server accepted the request and is returning the content (see curl.md for status code meanings) |
| `Length` | Total size of the file being downloaded, in bytes and human-readable form |
| Progress bar line | Percentage complete, download speed, and time elapsed |
| Final saved line | Confirms bytes downloaded matched expected content length |

**Interpreting results:**
- `Length: unspecified` means the server didn't provide a `Content-Length` header — progress can't be estimated accurately
- Repeated `Connecting... failed` messages before eventual success usually indicate an unstable or rate-limited connection — `wget` will retry automatically based on `-t`
- A mismatch between expected and actual downloaded size at the end signals a truncated/corrupted download — re-run with `-c` to resume

## Practical Examples

Basic download:
```bash
wget https://example.com/file.zip
```

Save with a custom filename:
```bash
wget -O myfile.zip https://example.com/file.zip
```

Resume an interrupted download:
```bash
wget -c https://example.com/largefile.iso
```

Download an entire website for offline browsing:
```bash
wget --mirror -np -P ./offline-site https://example.com
```

Download in the background with logging:
```bash
wget -b https://example.com/largefile.iso -o download.log
```

Limit bandwidth usage:
```bash
wget --limit-rate=500k https://example.com/file.zip
```

**Troubleshooting scenario:** If a large download keeps failing partway through, use `wget -c -t 0` (unlimited retries) to auto-resume from where it left off rather than restarting from scratch each time.

## Related Tools

- [curl](./curl.md) — better suited for API interaction and inspecting request/response details rather than bulk downloading
- [nslookup](./nslookup.md) / [dig](./dig.md) — check DNS resolution if `wget` fails at the "Resolving..." step
