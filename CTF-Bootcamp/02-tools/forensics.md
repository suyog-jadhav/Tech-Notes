# 🕵️ Forensics Tools

## File / Data Carving
| Tool | Purpose | Link |
|---|---|---|
| **binwalk** | Firmware/file carving & extraction | https://github.com/ReFirmLabs/binwalk |
| **foremost / scalpel** | File carving from disk images | https://github.com/korczis/foremost |
| **exiftool** | Metadata extraction/editing | https://exiftool.org |
| **file / TrID** | File-type identification | built-in / https://mark0.net/soft-trid-e.html |

## Steganography
| Tool | Purpose | Link |
|---|---|---|
| **steghide** | Hide/extract data in images/audio | https://github.com/StefanoDeVuono/steghide |
| **zsteg** | Detect stego data in PNG/BMP | https://github.com/zed-0xff/zsteg |
| **StegSolve** | Visual stego analysis (bit planes, etc.) | https://github.com/Giotino/stegsolve |
| **Stegcracker** | Brute-force steghide passphrases | https://github.com/Paradoxis/StegCracker |
| **Aperi'Solve** | Online multi-layer stego analysis platform | https://www.aperisolve.com |

## Memory & Disk Forensics
| Tool | Purpose | Link |
|---|---|---|
| **Volatility 3** | Memory dump (RAM) forensic analysis | https://github.com/volatilityfoundation/volatility3 |
| **Autopsy / The Sleuth Kit** | Disk image forensic analysis suite | https://www.autopsy.com |
| **FTK Imager** | Disk imaging & preview | https://www.exterro.com/digital-forensics-software/ftk-imager |

## Network Forensics
| Tool | Purpose | Link |
|---|---|---|
| **Wireshark** | PCAP analysis — see `network-tools.md` | https://www.wireshark.org |
| **NetworkMiner** | Passive network forensic analysis from PCAPs | https://www.netresec.com/?page=NetworkMiner |
| **CyberChef** | Also great for decoding forensic artifacts | https://gchq.github.io/CyberChef |

## Notes
- Always run `file` and `exiftool` on unknown files first — you'd be surprised how many "easy" points come from just reading metadata.
- Check for appended data after the EOF marker of images (`binwalk -e`) — a classic beginner stego trick.
