# 🚀 Getting Started with CTFs

## What is a CTF?

A Capture The Flag (CTF) competition is a cybersecurity exercise where participants solve security-themed challenges to find hidden "flags" (strings like `flag{...}` or `CTF{...}`). Two common formats:

- **Jeopardy-style** — categorized challenges (Web, Pwn, Crypto, Forensics, RE, OSINT, Misc), solve independently for points. Most beginner-friendly.
- **Attack-Defense** — teams defend their own vulnerable services while attacking others' live. More advanced, team-based.

## Environment Setup

### Recommended base OS
- **Kali Linux** or **Parrot OS** — pre-loaded with most tools (VM or dual-boot).
- Alternative: any Linux distro + manually install tools from `02-tools/`.
- Windows users: use **WSL2** for a Linux subsystem, keep Windows for GUI tools if needed.

### Core setup checklist
- [ ] Linux environment (VM/WSL2/dual-boot)
- [ ] Python 3.x + `pip`
- [ ] `git`
- [ ] A good terminal + tmux/screen for multitasking
- [ ] Burp Suite Community Edition (Web)
- [ ] Ghidra or IDA Free (Reverse Engineering)
- [ ] pwntools + gdb with GEF/pwndbg (Pwn)
- [ ] Wireshark (Network/Forensics)
- [ ] A password manager for CTF platform accounts
- [ ] VPN client (OpenVPN) — needed for HackTheBox, TryHackMe labs

### Quick install (Debian/Ubuntu/Kali example)
```bash
sudo apt update && sudo apt install -y \
  git python3 python3-pip build-essential \
  nmap wireshark gdb netcat-traditional \
  binwalk exiftool steghide john hashcat

pip3 install pwntools requests pycryptodome
```

## Mindset & How to Approach a Challenge

1. **Read the challenge description fully** — hints are often hidden in the wording/category/points.
2. **Enumerate first, exploit second** — for Web/Pwn, always recon (`nmap`, view-source, `file`, `strings`) before diving in.
3. **Google the error messages** — verbatim error strings often point straight to the vulnerability class.
4. **Don't rabbit-hole** — if stuck >30–45 min on a challenge with no progress, switch challenges and come back later.
5. **Take notes** — keep a running log (Obsidian/Notion/plain markdown) of payloads and techniques that worked; you'll reuse them.
6. **Team up** — CTFs are more fun and effective in teams; divide by category strengths.
7. **Do write-ups after** — solving is half the learning; writing up why it worked cements it.

## Absolute Beginner Learning Order

1. **picoCTF** (self-paced, guided) → build fundamentals across all categories.
2. **OverTheWire Bandit** → Linux command-line fundamentals (prerequisite for almost everything).
3. **PortSwigger Web Security Academy** → web exploitation, free and extremely thorough.
4. **TryHackMe** (free rooms) → guided, beginner-friendly walkthrough-style learning.
5. Then branch into **Hack The Box**, **CTFtime**-listed live events, and category-specific platforms (see `03-practice-platforms/`).
