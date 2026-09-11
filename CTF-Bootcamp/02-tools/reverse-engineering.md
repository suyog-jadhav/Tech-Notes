# 🔬 Reverse Engineering Tools

| Tool | Purpose | Link |
|---|---|---|
| **Ghidra** | Free NSA-developed disassembler/decompiler, industry standard | https://ghidra-sre.org |
| **IDA Free / IDA Pro** | Most popular commercial disassembler (free tier available) | https://hex-rays.com/ida-free |
| **Binary Ninja** | Modern disassembler/decompiler with great API | https://binary.ninja |
| **radare2 / Cutter** | Open-source RE framework + GUI frontend | https://github.com/radareorg/radare2 |
| **x64dbg** | Windows user-mode debugger | https://github.com/x64dbg/x64dbg |
| **dnSpy / ILSpy** | .NET assembly decompilers | https://github.com/dnSpyEx/dnSpy · https://github.com/icsharpcode/ILSpy |
| **JD-GUI / CFR** | Java decompilers | https://github.com/java-decompiler/jd-gui |
| **Frida** | Dynamic instrumentation toolkit (hook functions at runtime) | https://frida.re |
| **strings / file / binwalk** | Quick static triage of unknown binaries | built-in / https://github.com/ReFirmLabs/binwalk |
| **Detect It Easy (DIE)** | Identify packers/compilers/file type | https://github.com/horsicq/Detect-It-Easy |
| **UPX** | Common packer — also used to *unpack* (`upx -d`) | https://github.com/upx/upx |
| **Androguard / jadx** | Android APK reverse engineering & decompilation | https://github.com/androguard/androguard · https://github.com/skylot/jadx |

## Notes
- Start static (Ghidra/IDA) to understand structure, then go dynamic (debugger/Frida) to confirm behavior.
- For CTF "crackme" style challenges, look for comparison functions, XOR loops, and hardcoded constants — these usually gate the flag check.
- Mobile RE (Android) is increasingly common in bootcamps — `jadx` + `apktool` is the standard combo.
