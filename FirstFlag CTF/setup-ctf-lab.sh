#!/usr/bin/env bash
#
# setup-ctf-lab.sh
#
# Builds a 5-level, OWASP-style Linux CLI CTF on an Ubuntu Server VM.
#
#   - 5 independent Linux accounts: OWASP01 .. OWASP05 (NOT chained -
#     you distribute each password yourself via your own portal)
#   - each account can only read its own /opt/ctf-lab/levelN directory
#   - each level hides one unique OWASP{...} string
#   - 2 easy / 2 medium / 1 hard
#   - accounts are hardened: no sudo, no password self-change, no shell
#     history, restricted SSH, basic resource limits
#
# Run as root on the CTF VM (NOT your daily-use machine):
#   sudo bash setup-ctf-lab.sh          # build (idempotent)
#   sudo bash setup-ctf-lab.sh --reset  # wipe everything and rebuild
#
# After it runs, credentials + flags are in:
#   /root/ctf-portal-credentials.csv   (root-only, 600)
#
set -euo pipefail

# ------------------------------------------------------------------
# 0. Preconditions
# ------------------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (sudo)." >&2
    exit 1
fi

LAB_ROOT="/opt/ctf-lab"
USERS=(OWASP01 OWASP02 OWASP03 OWASP04 OWASP05)
NOPASSWD_GROUP="ctf-noPasswdChange"
CRED_FILE="/root/ctf-portal-credentials.csv"
SSHD_CONFIG="/etc/ssh/sshd_config"
PAM_PASSWD="/etc/pam.d/passwd"
MARKER="# --- ctf-lab managed block, do not edit by hand ---"

RESET=false
[[ "${1:-}" == "--reset" ]] && RESET=true

for bin in openssl gzip base64 rev shuf; do
    command -v "$bin" >/dev/null 2>&1 || { echo "Missing required tool: $bin" >&2; exit 1; }
done

gen_flag() {
    # OWASP{ctf<2-digit-year>_<12 hex chars>}
    echo "OWASP{ctf$(date +%y)_$(openssl rand -hex 6)}"
}

log() { echo -e "[ctf-lab] $*"; }

# ------------------------------------------------------------------
# 1. Optional reset
# ------------------------------------------------------------------
if $RESET; then
    log "Resetting: removing existing accounts and lab data..."
    for u in "${USERS[@]}"; do
        if id "$u" &>/dev/null; then
            for f in "/home/$u/.bashrc"; do
                [[ -f "$f" ]] && chattr -i "$f" 2>/dev/null || true
            done
            userdel -r "$u" 2>/dev/null || true
        fi
    done
    rm -rf "$LAB_ROOT"
    rm -f "$CRED_FILE"
    getent group "$NOPASSWD_GROUP" &>/dev/null && groupdel "$NOPASSWD_GROUP" || true
fi

# ------------------------------------------------------------------
# 2. Create accounts
# ------------------------------------------------------------------
getent group "$NOPASSWD_GROUP" &>/dev/null || groupadd "$NOPASSWD_GROUP"

declare -A PASSWORDS
for u in "${USERS[@]}"; do
    if ! id "$u" &>/dev/null; then
        log "Creating account $u ..."
        useradd -m -s /bin/bash -c "CTF challenge account ($u)" "$u"
    fi
    usermod -aG "$NOPASSWD_GROUP" "$u"
    # never allow sudo/adm/docker membership
    for badgrp in sudo wheel adm docker lxd; do
        gpasswd -d "$u" "$badgrp" &>/dev/null || true
    done

    pw="$(openssl rand -base64 12 | tr -d '=+/' | cut -c1-14)"
    PASSWORDS[$u]="$pw"
    echo "${u}:${pw}" | chpasswd
done

# ------------------------------------------------------------------
# 3. Harden the accounts
# ------------------------------------------------------------------

# 3a. Prevent students from changing their own (shared/portal-issued) password.
if ! grep -qF "$MARKER" "$PAM_PASSWD" 2>/dev/null; then
    log "Locking down 'passwd' for CTF accounts via PAM..."
    tmpfile="$(mktemp)"
    {
        echo "$MARKER"
        echo "account [success=1 default=ignore] pam_succeed_if.so user notingroup $NOPASSWD_GROUP"
        echo "account requisite pam_deny.so"
        echo "# --- end ctf-lab managed block ---"
        cat "$PAM_PASSWD"
    } > "$tmpfile"
    mv "$tmpfile" "$PAM_PASSWD"
fi

# 3b. No shell history, minimal read-only shell profile, immutable .bashrc
for u in "${USERS[@]}"; do
    home="/home/$u"
    chmod 700 "$home"
    cat > "$home/.bashrc" <<'EOF'
# CTF lab shell profile (read-only, managed)
export HISTFILE=/dev/null
export HISTSIZE=0
export HISTFILESIZE=0
umask 077
PS1='\u@ctf-lab:\w\$ '
EOF
    chown root:root "$home/.bashrc"
    chmod 444 "$home/.bashrc"
    chattr +i "$home/.bashrc" 2>/dev/null || true
    # remove any leftover login/profile files students could edit and abuse
    rm -f "$home/.bash_history" "$home/.bash_logout" 2>/dev/null || true
done

# 3c. Resource limits (fork-bomb / runaway process protection)
cat > /etc/security/limits.d/90-ctf-lab.conf <<EOF
@${NOPASSWD_GROUP} soft nproc 60
@${NOPASSWD_GROUP} hard nproc 120
@${NOPASSWD_GROUP} soft as 1048576
@${NOPASSWD_GROUP} hard as 2097152
EOF

# 3d. SSH: password auth only for these accounts, no forwarding/tunneling
if ! grep -qF "Match User $(IFS=,; echo "${USERS[*]}")" "$SSHD_CONFIG" 2>/dev/null; then
    log "Adding restricted SSH Match block for CTF accounts..."
    {
        echo ""
        echo "$MARKER"
        echo "Match User $(IFS=,; echo "${USERS[*]}")"
        echo "    PasswordAuthentication yes"
        echo "    PubkeyAuthentication no"
        echo "    X11Forwarding no"
        echo "    AllowTcpForwarding no"
        echo "    AllowAgentForwarding no"
        echo "    PermitTunnel no"
        echo "    PermitTTY yes"
        echo "# --- end ctf-lab managed block ---"
    } >> "$SSHD_CONFIG"
    sshd -t && systemctl reload ssh 2>/dev/null || systemctl reload sshd 2>/dev/null || true
fi

# ------------------------------------------------------------------
# 4. Build the lab directory tree
# ------------------------------------------------------------------
mkdir -p "$LAB_ROOT"
chown root:root "$LAB_ROOT"
chmod 711 "$LAB_ROOT"   # traversable by all, listable by none

secure_level() {
    local dir="$1" group="$2"
    chown -R root:"$group" "$dir"
    find "$dir" -type d -exec chmod 550 {} \;
    find "$dir" -type f -exec chmod 440 {} \;
}

declare -A FLAGS

# --- Level 1 (Easy): plain file discovery ---------------------------------
L0="$LAB_ROOT/level1"; mkdir -p "$L0"
FLAGS[OWASP01]="$(gen_flag)"
cat > "$L0/README" <<EOF
Level 1 - Warm up
------------------
There is a file in this directory. Read it.
EOF
echo "${FLAGS[OWASP01]}" > "$L0/password.txt"
secure_level "$L0" OWASP01

# --- Level 2 (Easy): hidden file -------------------------------------------
L1="$LAB_ROOT/level2"; mkdir -p "$L1"
FLAGS[OWASP02]="$(gen_flag)"
cat > "$L1/README" <<EOF
Level 2 - Hide and seek
------------------------
A plain 'ls' won't show you everything. Look for hidden files.
EOF
echo "${FLAGS[OWASP02]}" > "$L1/.password"
secure_level "$L1" OWASP02

# --- Level 3 (Medium): grep through noisy log file -------------------------
L2="$LAB_ROOT/level3"; mkdir -p "$L2"
FLAGS[OWASP03]="$(gen_flag)"
cat > "$L2/README" <<EOF
Level 3 - Needle in a haystack
-------------------------------
access.log contains a lot of noise. Somewhere in there is a line
starting with AUTH_TOKEN. Find it.
EOF
{
    ips=(10.0.0.{1..40} 172.16.{1..8}.{1..10} 192.168.1.{1..30})
    verbs=(GET POST PUT DELETE)
    paths=(/login /api/users /static/app.js /health /favicon.ico /admin)
    codes=(200 200 200 301 404 403 500)
    for i in $(seq 1 400); do
        ip="${ips[$((RANDOM % ${#ips[@]}))]}"
        v="${verbs[$((RANDOM % ${#verbs[@]}))]}"
        p="${paths[$((RANDOM % ${#paths[@]}))]}"
        c="${codes[$((RANDOM % ${#codes[@]}))]}"
        printf '%s - - [%s] "%s %s HTTP/1.1" %s %d\n' \
            "$ip" "$(date -d "-$((RANDOM % 5000)) sec" '+%d/%b/%Y:%H:%M:%S %z')" \
            "$v" "$p" "$c" "$((RANDOM % 4000))"
    done
    printf '%s - - [%s] "AUTH_TOKEN %s issued to service ctf-portal" 200 0\n' \
        "10.0.0.99" "$(date '+%d/%b/%Y:%H:%M:%S %z')" "${FLAGS[OWASP03]}"
} | shuf > "$L2/access.log"
secure_level "$L2" OWASP03

# --- Level 4 (Medium): find through decoy directory tree -------------------
L3="$LAB_ROOT/level4"; mkdir -p "$L3"
FLAGS[OWASP04]="$(gen_flag)"
cat > "$L3/README" <<EOF
Level 4 - Buried
------------------
The flag is in a file called treasure.txt, somewhere under this
directory. Everything else you find here is a decoy.
EOF
pool=(backup old archive tmp cache logs config data misc project_alpha project_beta 2019 2020 2021 snapshots incoming)
make_branch() {
    local base="$1" depth="$2"
    local path="$base"
    for _ in $(seq 1 "$depth"); do
        path="$path/${pool[$((RANDOM % ${#pool[@]}))]}_$RANDOM"
    done
    mkdir -p "$path"
    echo "$path"
}
# 10 decoy branches
for _ in $(seq 1 10); do
    d="$(make_branch "$L3" $((RANDOM % 3 + 3)))"
    echo "Not the flag, keep looking." > "$d/decoy.txt"
done
# real branch
real_dir="$(make_branch "$L3" $((RANDOM % 2 + 5)))"
echo "${FLAGS[OWASP04]}" > "$real_dir/treasure.txt"
secure_level "$L3" OWASP04

# --- Level 5 (Hard): rev | base64 -d | zcat, plus a decoy binary -----------
L4="$LAB_ROOT/level5"; mkdir -p "$L4"
FLAGS[OWASP05]="$(gen_flag)"
cat > "$L4/README" <<EOF
Level 5 - Layered
-------------------
challenge.dat is not what it looks like. Figure out how it was built
and undo each step. 'file' and 'strings' may help you understand what
you're looking at. Not everything in this directory is real.
EOF
payload_b64="$(echo -n "${FLAGS[OWASP05]}" | gzip -c | base64 -w0)"
echo -n "$payload_b64" | rev > "$L4/challenge.dat"

# decoy binary blob with a fake, wrong-format flag buried in random bytes
{
    head -c 512 /dev/urandom
    echo -n "OWASP{not_the_real_one_keep_digging}"
    head -c 512 /dev/urandom
} > "$L4/system_dump.bin"
secure_level "$L4" OWASP05

log "Lab tree built and locked down under $LAB_ROOT"

# ------------------------------------------------------------------
# 5. Emit credentials + flags for your portal
# ------------------------------------------------------------------
{
    echo "level,username,password,flag"
    echo "1,OWASP01,${PASSWORDS[OWASP01]},${FLAGS[OWASP01]}"
    echo "2,OWASP02,${PASSWORDS[OWASP02]},${FLAGS[OWASP02]}"
    echo "3,OWASP03,${PASSWORDS[OWASP03]},${FLAGS[OWASP03]}"
    echo "4,OWASP04,${PASSWORDS[OWASP04]},${FLAGS[OWASP04]}"
    echo "5,OWASP05,${PASSWORDS[OWASP05]},${FLAGS[OWASP05]}"
} > "$CRED_FILE"
chown root:root "$CRED_FILE"
chmod 600 "$CRED_FILE"

echo ""
echo "=================================================================="
echo " CTF lab ready. Credentials + flags (root-only): $CRED_FILE"
echo "=================================================================="
column -s, -t "$CRED_FILE"
echo "=================================================================="
echo "Give each student ONLY their username + password. They SSH in,"
echo "find the flag, and submit it on your portal against that level."
echo ""
echo "Sanity checks before your event:"
echo "  sudo -l -U OWASP01            # confirm no sudo rights"
echo "  su - OWASP01 -c 'passwd'      # confirm password change is refused"
echo "  su - OWASP01 -c 'ls /opt/ctf-lab/level2'   # confirm no cross-level access"
echo ""
echo "Take a clean VM snapshot now, before students connect."
echo "To wipe and rebuild everything: sudo bash $(basename "$0") --reset"
