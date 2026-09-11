# 🚩 CTF & Cybersecurity Bootcamp — Master Resource Guide

Welcome! This repo is your one-stop reference for the bootcamp: tools, practice platforms, competitions, curated write-ups, and famous repos. Everything is organized by folder so you can jump straight to what you need.

> Last curated: September 2026. Tools/links change fast in this space — if something's dead, check the [Alternatives](#if-a-link-is-dead) note at the bottom.

## 📂 Folder Structure

```
CTF-Bootcamp/
├── README.md                      ← you are here
├── 01-getting-started/            ← how to start, mindset, prerequisites
├── 02-tools/                      ← categorized tool lists (recon, web, pwn, crypto, etc.)
├── 03-practice-platforms/         ← where to practice (beginner → advanced)
├── 04-find-ctfs/                  ← where to find live/upcoming CTFs
├── 05-writeups-resources/         ← write-up archives, blogs, YouTube channels
├── 06-github-repos/               ← famous/must-know GitHub repositories
└── 07-cheatsheets-guides/         ← cheatsheets & category guides
```

## 🧭 Suggested Path for Participants

1. Read **`01-getting-started/README.md`** — set up your environment & understand CTF categories.
2. Skim **`02-tools/`** — install the essentials for each category before you need them.
3. Pick a platform from **`03-practice-platforms/`** matching your level.
4. Bookmark **`04-find-ctfs/README.md`** to join live competitions.
5. When stuck (after genuinely trying), use **`05-writeups-resources/`** to learn technique, not just the answer.
6. Star the repos in **`06-github-repos/`** — they're the tools/wordlists you'll reuse forever.
7. Print/keep **`07-cheatsheets-guides/`** open in a tab during every CTF.

## 🏷️ CTF Categories (for reference throughout this repo)

| Category | What it tests |
|---|---|
| **Web Exploitation (Web)** | SQLi, XSS, SSRF, auth bypass, deserialization, logic flaws |
| **Binary Exploitation (Pwn)** | Buffer overflows, ROP, heap exploitation, format strings |
| **Reverse Engineering (RE)** | Disassembly, decompilation, anti-debugging, obfuscation |
| **Cryptography (Crypto)** | Classical & modern crypto attacks, RSA, hashing flaws |
| **Forensics** | File carving, memory/disk forensics, steganography, PCAP analysis |
| **OSINT** | Open-source intelligence gathering, geolocation, recon |
| **Network** | Packet analysis, protocol exploitation |
| **Misc/Scripting** | Puzzles, automation, esoteric challenges |

## ⚖️ Ethics Note

Only test systems you own or are explicitly authorized to test (CTF platforms, your own labs, authorized bug bounty scope). Skills taught here are for defense, research, and authorized offensive security — not unauthorized access.

## If a link is dead

Security tooling and platforms shift often. If something in this repo 404s:
- Search the tool/platform name + "github" (most tools live on GitHub and rarely truly disappear, just move).
- Check `06-github-repos/README.md` for the canonical repo.
- Ask in the bootcamp channel — we'll patch this doc.
