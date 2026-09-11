# 🔐 Cryptography Tools

| Tool | Purpose | Link |
|---|---|---|
| **CyberChef** | "Cyber Swiss Army Knife" — web-based encode/decode/crypto tool, use constantly | https://gchq.github.io/CyberChef |
| **RsaCtfTool** | Automated RSA attack tool (weak keys, common factors, Wiener's attack, etc.) | https://github.com/RsaCtfTool/RsaCtfTool |
| **pycryptodome** | Python crypto library used to script custom attacks | https://github.com/Legrandin/pycryptodome |
| **SageMath** | Powerful math/crypto CAS — used for lattice attacks, modular arithmetic | https://www.sagemath.org |
| **hashcat** | GPU-accelerated password/hash cracking | https://hashcat.net/hashcat |
| **John the Ripper** | Classic password cracker | https://github.com/openwall/john |
| **FeatherDuster** | Automated classical cryptanalysis toolkit | https://github.com/nccgroup/featherduster |
| **XORTool** | Guess XOR key length & key for XOR'd ciphertext | https://github.com/hellman/xortool |
| **dcode.fr** | Huge library of online cipher solvers (Vigenère, Caesar, etc.) | https://www.dcode.fr |
| **CrackStation** | Online hash lookup (rainbow tables) | https://crackstation.net |

## Notes
- Know your basics cold: Caesar/Vigenère, XOR, Base64/32/85, hex, ROT13 — these show up as easy-points warmups constantly.
- For RSA challenges, always check: small `e`, shared primes/moduli between keys, Wiener's attack conditions, and Fermat factorization first before brute-forcing.
- CyberChef's "Magic" wand feature is a great first-pass tool for unidentified encodings.
