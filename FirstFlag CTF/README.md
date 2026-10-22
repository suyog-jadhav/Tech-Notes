# FirstFlag Linux CTF

A small, beginner-friendly Linux command-line CTF for an OWASP event, inspired by OverTheWire's Bandit.
One Ubuntu Server VM, five shared accounts (`OWASP01` to `OWASP05`), five independent challenges, one random flag each.

> **Read this first:** the script creates system users and edits `/etc/pam.d/passwd` and `/etc/ssh/sshd_config`.
> Run it **only inside a dedicated VM**, never on your daily-use machine.

## Levels

| Level | Account | Difficulty | Skill |
|---|---|---|---|
| 1 | `OWASP01` | Easy | `ls`, `cat` |
| 2 | `OWASP02` | Easy | hidden files (`ls -la`) |
| 3 | `OWASP03` | Medium | `grep` |
| 4 | `OWASP04` | Medium | `find` |
| 5 | `OWASP05` | Hard | layered encoding/compression, `strings` |

Levels are independent. You hand each player the credentials for a level (for example via your scoring portal);
they SSH in, `cd /opt/ctf-lab/levelN`, find the flag (`OWASP{...}`), and submit it.

## How it works

- Challenge files live in `/opt/ctf-lab/levelN`, owned by `root`, mode `550` (dirs) / `440` (files).
- Each account can only enter its own level (group-based access), so players can't read, edit, or delete anything.
- Many players can log into the same account at once.
- Passwords and flags are generated randomly at setup time. Nothing secret is stored in this repo.

## Hardening included

- Password changes blocked for the CTF accounts (PAM rule)
- No sudo / admin groups
- Shell history disabled, read-only immutable `.bashrc`
- SSH `Match` block: password auth only, no forwarding or tunnels
- Basic process and memory limits

Unix permissions are not a full sandbox. The VM is your real boundary: take a snapshot after setup.

## Usage

On a fresh Ubuntu Server VM (with OpenSSH server installed):

```bash
chmod +x setup-ctf-lab.sh
sudo ./setup-ctf-lab.sh            # build
sudo ./setup-ctf-lab.sh --reset    # wipe everything and rebuild with new passwords/flags
```

Credentials and flags are written to `/root/ctf-portal-credentials.csv` (root-only). **Never commit that file.**

## Sanity checks

```bash
sudo -l -U OWASP01                          # no sudo rights
su - OWASP01 -c 'passwd'                    # refused
su - OWASP01 -c 'ls /opt/ctf-lab/level3'    # permission denied
```

## Networking (VirtualBox)

- **NAT + port forwarding:** host port `2222` to guest `22` (leave Host IP blank to allow other devices on your network)
- **Bridged adapter:** the VM gets its own LAN IP, players use port `22`

Players connect with `ssh OWASP01@<host-or-vm-ip> -p <port>`.

## Disclaimer

For educational use in a controlled environment. Use at your own risk.
