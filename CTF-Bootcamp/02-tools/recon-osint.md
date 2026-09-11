# 🔎 Reconnaissance & OSINT Tools

## General Recon / Scanning
| Tool | Purpose | Link |
|---|---|---|
| **Nmap** | Network/port scanning, service/version detection | https://nmap.org |
| **Masscan** | Ultra-fast port scanner for large ranges | https://github.com/robertdavidgraham/masscan |
| **RustScan** | Fast port scanner, feeds into Nmap | https://github.com/RustScan/RustScan |
| **Amass** | Attack surface / subdomain enumeration | https://github.com/owasp-amass/amass |
| **Subfinder** | Passive subdomain enumeration | https://github.com/projectdiscovery/subfinder |
| **httpx** | Fast HTTP probing of live hosts | https://github.com/projectdiscovery/httpx |
| **Nuclei** | Template-based vulnerability scanning | https://github.com/projectdiscovery/nuclei |
| **Gobuster / ffuf / dirsearch** | Directory & file brute-forcing | https://github.com/OJ/gobuster · https://github.com/ffuf/ffuf · https://github.com/maurosoria/dirsearch |
| **theHarvester** | Emails, subdomains, names from public sources | https://github.com/laramies/theHarvester |
| **Shodan / Censys** | Internet-wide device/service search engines | https://www.shodan.io · https://search.censys.io |

## OSINT Specific
| Tool | Purpose | Link |
|---|---|---|
| **Maltego** | Link-analysis / relationship mapping | https://www.maltego.com |
| **SpiderFoot** | Automated OSINT reconnaissance | https://github.com/smicallef/spiderfoot |
| **Sherlock** | Find usernames across social platforms | https://github.com/sherlock-project/sherlock |
| **ExifTool** | Metadata extraction from images/files | https://exiftool.org |
| **Google/Bing/DuckDuckGo Dorking** | Advanced search operators for exposed data | (search engine syntax, no install) |
| **Wayback Machine / archive.org** | Historical snapshots of websites | https://web.archive.org |
| **Intelligence X** | Search engine for leaks, darknet, docs | https://intelx.io |
| **OSINT Framework** | Categorized directory of OSINT tools | https://osintframework.com |
| **GeoGuessr techniques / Overpass Turbo / SunCalc** | Image geolocation CTFs | https://overpass-turbo.eu · https://suncalc.org |
| **ExifCleaner, Metagoofil** | Metadata harvesting/cleaning | https://github.com/laramies/metagoofil |

## Notes
- OSINT challenges in CTFs often combine **reverse image search** (Google Lens, Yandex, TinEye) with metadata and social-media digging.
- Always check `robots.txt`, `/sitemap.xml`, and page **source/comments** early in web recon.
