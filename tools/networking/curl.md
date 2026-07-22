# Curl

A command-line tool for transferring data to or from a server using URLs — supports HTTP, HTTPS, FTP, and many other protocols, and is the standard tool for testing and debugging APIs and web endpoints.

## Purpose

- Sends HTTP requests (GET, POST, PUT, DELETE, etc.) and inspects responses
- Tests REST APIs directly from the command line
- Downloads files and inspects headers, redirects, and TLS certificate details
- Widely used in scripts, CI/CD pipelines, and health-check automation

**Layer:** Layer 7 (Application) — primarily used for HTTP/HTTPS, but also supports FTP, SMTP, and other application-layer protocols.

## Installation

Preinstalled on most Linux distros and macOS. If missing:

```bash
sudo apt install curl   # Debian/Ubuntu
sudo dnf install curl   # Fedora
sudo pacman -S curl     # Arch
```

## Syntax

```bash
curl [options] URL
```

## Flags

| Flag | Long form | Description |
|------|-----------|--------------|
| `-X` | `--request` | Specify the HTTP method (GET, POST, PUT, DELETE, etc.) |
| `-H` | `--header` | Add a custom request header |
| `-d` | `--data` | Send data in the request body (implies POST) |
| `-i` | `--include` | Include response headers in the output |
| `-I` | `--head` | Fetch headers only (HEAD request) |
| `-v` | `--verbose` | Show the full request/response exchange, including TLS handshake |
| `-L` | `--location` | Follow redirects automatically |
| `-o` | `--output` | Write output to a file instead of stdout |
| `-s` | `--silent` | Suppress progress meter and errors |
| `-k` | `--insecure` | Skip TLS certificate verification (use only for testing) |
| `-u` | `--user` | Provide username:password for basic auth |
| `-w` | `--write-out` | Print custom info after the transfer (e.g. status code, timing) |

## Output Breakdown

Example with headers included (`curl -i https://api.github.com`):

```
HTTP/2 200
server: GitHub.com
content-type: application/json; charset=utf-8
x-ratelimit-limit: 60
x-ratelimit-remaining: 58

{
  "current_user_url": "https://api.github.com/user",
  ...
}
```

| Field | Meaning |
|-------|---------|
| `HTTP/2 200` | Protocol version and status code — `200` means success |
| `server` | Identifies the server software handling the request |
| `content-type` | Format of the response body (JSON, HTML, etc.) |
| `x-ratelimit-*` | Custom headers, in this case GitHub's API rate-limit info — common in API responses |
| Body (after blank line) | The actual response content |

**Common status codes to recognize:**

| Code | Meaning |
|------|---------|
| `200` | Success |
| `301`/`302` | Redirect (use `-L` to follow automatically) |
| `401` | Unauthorized — missing/invalid credentials |
| `403` | Forbidden — authenticated but not permitted |
| `404` | Not found |
| `500` | Server-side error |

## Practical Examples

Simple GET request:
```bash
curl https://api.github.com
```

Send a POST request with JSON data:
```bash
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Suyog"}'
```

Fetch only response headers:
```bash
curl -I https://google.com
```

Follow redirects and save output to a file:
```bash
curl -L -o page.html https://example.com
```

Show only the HTTP status code (useful in scripts/health checks):
```bash
curl -s -o /dev/null -w "%{http_code}\n" https://example.com
```

Test with basic authentication:
```bash
curl -u username:password https://api.example.com/data
```

**Troubleshooting scenario:** If a web app returns unexpected content in the browser, run `curl -iv <url>` to see the raw request/response including headers and TLS details — this isolates whether the issue is server-side (bad response) or client-side (browser caching, JS, cookies).

## Related Tools

- [wget](./wget.md) — better suited for bulk downloads and recursive fetching than API testing
- [netcat](./netcat.md) — lower-level alternative for raw protocol testing when `curl` is too high-level
- [nslookup](./nslookup.md) / [dig](./dig.md) — verify DNS resolution if `curl` reports it can't resolve a host
