# Antigravity IDE Crashes on Fedora 44 (Wayland)

## Overview

While using **Antigravity IDE** on **Fedora 44 KDE Plasma (Wayland)**, the application repeatedly became unresponsive and eventually crashed with the error:

```text
/usr/share/antigravity/antigravity has encountered a fatal error and was closed.
```

The issue occurred even after reinstalling the application and disabling extensions.

---

# System Information

| Component | Value |
|-----------|-------|
| Distribution | Fedora 44 |
| Desktop Environment | KDE Plasma |
| Display Server | Wayland |
| CPU | Intel Core i5-13500HX |
| GPU | Intel UHD Graphics + NVIDIA RTX 3050 Laptop GPU |
| OpenGL Renderer | Mesa Intel UHD Graphics |
| NVIDIA Driver | 610.43.03 |
| Antigravity Version | 1.107.0 |

---

# Symptoms

- Antigravity launches successfully.
- UI freezes after a short time.
- `CodeWindow: detected unresponsive` appears in logs.
- Application eventually crashes.
- Multiple Chromium utility processes dump core.

---

# Error Logs

Checking the journal:

```bash
journalctl --user -xe | grep antigravity
```

Important messages:

```text
CodeWindow: detected unresponsive

UnresponsiveSampleError

Process antigravity dumped core.
```

The application repeatedly entered an unresponsive state before terminating.

---

# Core Dump Analysis

View crash information:

```bash
coredumpctl info antigravity
```

Observed signals:

```
Signal: 5 (SIGTRAP)
```

and

```
Signal: 11 (SIGSEGV)
```

Most crashes occurred inside Chromium's utility process:

```
--type=utility
--utility-sub-type=node.mojom.NodeService
```

Attempting to inspect the core dump using GDB:

```bash
coredumpctl gdb antigravity
```

Result:

```
No debugging symbols found.
Backtrace stopped.
Cannot access memory.
```

Since the binary is stripped, no meaningful stack trace could be obtained.

---

# GPU Investigation

Verify NVIDIA driver:

```bash
nvidia-smi
```

Output confirmed the NVIDIA driver was functioning correctly.

Verify rendering device:

```bash
glxinfo -B | grep "OpenGL renderer"
```

Output:

```text
OpenGL renderer string:
Mesa Intel(R) UHD Graphics
```

Therefore Antigravity was **not using the NVIDIA GPU**.

---

# Troubleshooting Performed

## Reinstalled Antigravity

```bash
sudo dnf install antigravity
```

No improvement.

---

## Disabled Extensions

```bash
antigravity --disable-extensions
```

Result:

- Still crashed.

Conclusion:

> Extensions were not responsible.

---

## Fresh User Profile

```bash
mkdir -p /tmp/ag-test

antigravity --user-data-dir /tmp/ag-test
```

Result:

- Still crashed.

Conclusion:

> Existing user configuration was not responsible.

---

## GPU Acceleration Test

```bash
antigravity --disable-gpu
```

Recommended to determine whether Electron GPU acceleration is responsible.

---

## Wayland Test

Launch using XWayland:

```bash
ELECTRON_OZONE_PLATFORM_HINT=x11 antigravity
```

If the application works correctly, the issue is likely related to Electron running under Wayland.

---

# Root Cause

Based on the investigation:

- Fedora installation is healthy.
- NVIDIA driver is functioning.
- Intel Mesa renderer is functioning.
- Extensions are not responsible.
- User configuration is not responsible.

The remaining likely causes are:

- Electron/Chromium regression
- Antigravity IDE bug
- Wayland compatibility issue

---

# Community Workaround

The RPM package appears to cause issues on some Linux systems.

The Antigravity community recommends installing the **official tarball** instead of the RPM package.

### Steps

Install the Antigravity CLI.

Download:

- Antigravity 2.0 tarball
- Antigravity IDE tarball

Navigate to the download directory:

```bash
cd ~/Downloads
```

Launch the CLI:

```bash
agy
```

Prompt:

```
Please install Antigravity 2.0, the tarball is in this directory.
```

After installation:

```
Please install the Antigravity IDE, the tarball is in this directory.
```

The CLI installs the applications and creates desktop launchers automatically.

---

# Useful Commands

## Check Antigravity Version

```bash
antigravity --version
```

---

## View Logs

```bash
journalctl --user -xe | grep antigravity
```

---

## View Core Dumps

```bash
coredumpctl info antigravity
```

---

## Debug Core Dump

```bash
coredumpctl gdb antigravity
```

---

## Disable Extensions

```bash
antigravity --disable-extensions
```

---

## Disable GPU

```bash
antigravity --disable-gpu
```

---

## Use Temporary Profile

```bash
antigravity --user-data-dir /tmp/ag-test
```

---

## Force XWayland

```bash
ELECTRON_OZONE_PLATFORM_HINT=x11 antigravity
```

---

# Conclusion

This issue was **not caused by Fedora, NVIDIA drivers, or user configuration**.

Evidence strongly indicates an **Antigravity/Electron compatibility issue on Fedora 44 Wayland**. If the RPM package continues to crash, installing the **official Antigravity tarball** is currently the recommended workaround.

---

# References

- Google Antigravity Community – *How to install Antigravity 2.0 and IDE on Linux*
- Fedora `journalctl`
- `coredumpctl`
- `gdb`
- Mesa OpenGL tools