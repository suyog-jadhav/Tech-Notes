# Git & GitHub Setup Guide

A step-by-step guide to installing Git, configuring your profile, setting up SSH authentication, and pushing your first repository to GitHub.

## Prerequisites

- A GitHub account ([github.com](https://github.com))
- A Linux system (Ubuntu/Debian, Fedora, or Arch — steps below cover all three)
- Terminal access with `sudo` privileges

## Step 1: Install Git

Check if Git is already installed:

```bash
git --version
```

If it isn't installed, use the command for your distro:

**Ubuntu/Debian**
```bash
sudo apt update
sudo apt install git
```

**Fedora**
```bash
sudo dnf install git
```

**Arch Linux**
```bash
sudo pacman -S git
```

## Step 2: Configure Your Global Git Profile

Set your name:

```bash
git config --global user.name "Your Name"
```

Set your email (the one associated with your GitHub account):

```bash
git config --global user.email "your-email@example.com"
```

### Optional Settings

Set the default branch name:

```bash
git config --global init.defaultBranch main
```

Enable colored output:

```bash
git config --global color.ui auto
```

Set VS Code as the default editor:

```bash
git config --global core.editor "code --wait"
```

## Step 3: Verify the Configuration

```bash
git config --list
```

Or:

```bash
git config --global --list
```

Expected output:

```
user.name=Suyog Jadhav
user.email=your-email@example.com
init.defaultBranch=main
color.ui=auto
core.editor=code --wait
```

## Step 4: Create or Clone a Repository

Create a new project:

```bash
mkdir Tech-Notes
cd Tech-Notes
git init
```

Or clone an existing repository:

```bash
git clone git@github.com:username/repository.git
```

## Step 5: Create Your First Commit

```bash
git add .
git commit -m "Initial commit"
```

> **Tip:** Before your first commit, it's worth adding a `.gitignore` file to exclude files you don't want tracked (build artifacts, `node_modules/`, `.env` files, IDE settings, etc.). GitHub maintains a collection of language-specific templates at [github.com/github/gitignore](https://github.com/github/gitignore).
>
> ```bash
> touch .gitignore
> ```

## Step 6: Generate an SSH Key (Recommended)

Check if one already exists:

```bash
ls ~/.ssh
```

Look for:

```
id_ed25519
id_ed25519.pub
```

If not present, generate one:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

Press Enter to accept the default file location. Optionally set a passphrase.

## Step 7: Start the SSH Agent

```bash
eval "$(ssh-agent -s)"
```

## Step 8: Add Your SSH Key

```bash
ssh-add ~/.ssh/id_ed25519
```

## Step 9: Copy the Public Key

Display it:

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the entire output.

## Step 10: Add the Key to GitHub

1. Sign in to GitHub.
2. Go to **Settings → SSH and GPG keys**.
3. Click **New SSH key**.
4. Give it a name (e.g., "Fedora Laptop").
5. Paste the copied public key.
6. Save.

## Step 11: Test the SSH Connection

```bash
ssh -T git@github.com
```

The first time, type `yes` when prompted.

Expected output:

```
Hi your-username!
You've successfully authenticated...
```

### Alternative: Using HTTPS Instead of SSH

Some corporate or restrictive networks block outbound SSH (port 22). If `ssh -T git@github.com` times out or fails, you can use HTTPS instead:

```bash
git remote add origin https://github.com/your-username/Tech-Notes.git
```

With HTTPS, GitHub will prompt for authentication on push. Since password authentication is deprecated, use a [Personal Access Token](https://github.com/settings/tokens) in place of your password, or authenticate via the [GitHub CLI](https://cli.github.com/):

```bash
gh auth login
```

If you've already added an SSH remote and want to switch a repo to HTTPS (or vice versa):

```bash
git remote set-url origin https://github.com/your-username/Tech-Notes.git
```

## Step 12: Add the GitHub Repository as a Remote

Create a repository on GitHub, then connect it:

```bash
git remote add origin git@github.com:your-username/Tech-Notes.git
```

Verify:

```bash
git remote -v
```

Example output:

```
origin  git@github.com:your-username/Tech-Notes.git (fetch)
origin  git@github.com:your-username/Tech-Notes.git (push)
```

## Step 13: Push Your Code

Ensure your branch is named `main`:

```bash
git branch -M main
```

Push for the first time:

```bash
git push -u origin main
```

The `-u` option sets the upstream branch, so future pushes only require:

```bash
git push
```

## Step 14: (Optional) Sign Your Commits with GPG

Many professional and enterprise repos require **verified** commits. GitHub will show a "Verified" badge on signed commits.

Generate a GPG key:

```bash
gpg --full-generate-key
```

List your keys and copy the key ID:

```bash
gpg --list-secret-keys --keyid-format=long
```

Export the public key:

```bash
gpg --armor --export <KEY_ID>
```

Add it to GitHub under **Settings → SSH and GPG keys → New GPG key**, then tell Git to use it:

```bash
git config --global user.signingkey <KEY_ID>
git config --global commit.gpgsign true
```

Now every commit will be signed automatically.

## Troubleshooting

**`ssh -T git@github.com` hangs or times out**
Your network likely blocks port 22. Try GitHub's SSH-over-HTTPS workaround (edit `~/.ssh/config`):
```
Host github.com
  Hostname ssh.github.com
  Port 443
  User git
```
Or switch to the [HTTPS remote](#alternative-using-https-instead-of-ssh) instead.

**`git push` fails with "rejected — non-fast-forward"**
The remote has commits you don't have locally (e.g. a README created on GitHub). Pull first, then push:
```bash
git pull origin main --allow-unrelated-histories
git push -u origin main
```

**`Permission denied (publickey)` when pushing over SSH**
Your SSH key isn't loaded or isn't linked to your GitHub account. Confirm it's added to the agent:
```bash
ssh-add -l
```
If empty, re-run `ssh-add ~/.ssh/id_ed25519` and re-check that the public key is saved under GitHub → Settings → SSH and GPG keys.

**`fatal: not a git repository`**
You're not inside a folder with a `.git` directory. Run `git init` or `cd` into the correct repo.

**Wrong author name/email on commits**
Local repo settings override global ones. Check with:
```bash
git config user.name
git config user.email
```
Fix per-repo with `git config user.name "Correct Name"` (no `--global`).

**Merge conflicts after `git pull`**
Git will mark conflicting sections in the file with `<<<<<<<`, `=======`, `>>>>>>>`. Manually edit the file to resolve, then:
```bash
git add <file>
git commit
```
