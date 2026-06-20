# Personal SSH Setup for GitHub (Best Practice)

## Security notes

- Use a **strong passphrase** (not a simple word). Never store it in plaintext.
- The macOS Keychain holds the passphrase so you only type it once.
- If a passphrase was ever shared/pasted somewhere, treat it as compromised and regenerate.

## What changed vs. the old gist

- **RSA → Ed25519** (smaller, faster, more secure; RSA is legacy)
- `ssh-add -K` → `ssh-add --apple-use-keychain` (`-K`/`-A` are deprecated on modern macOS)
- Added `AddKeysToAgent` / `UseKeychain` / `IdentitiesOnly` to the SSH config

## Step 1 — Generate the key

```bash
ssh-keygen -t ed25519 -C "laingocanh1990@gmail.com" -f ~/.ssh/github-anhlai-personal
```

Enter a strong passphrase when prompted. This creates:

- `github-anhlai-personal` (private key)
- `github-anhlai-personal.pub` (public key)

## Step 2 — Add to the SSH agent + Keychain

```bash
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/github-anhlai-personal
```

## Step 3 — Add the public key to GitHub

```bash
pbcopy < ~/.ssh/github-anhlai-personal.pub
```

Then GitHub → **Settings → SSH and GPG keys → New SSH Key** → paste → give it a title
(e.g. "MacBook personal"). Key type stays "Authentication Key."

## Step 4 — `~/.ssh/config`

```sshconfig
# anhlai-personal account
Host github.com-anhlai-personal
    HostName github.com
    User git
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/github-anhlai-personal
    IdentitiesOnly yes
```

`IdentitiesOnly yes` stops SSH from offering the wrong key when you have multiple.

## Step 5 — Test & use

```bash
ssh -T git@github.com-anhlai-personal
```

Expected: `Hi <username>! You've successfully authenticated...`

Clone using the custom Host:

```bash
git clone git@github.com-anhlai-personal:<user>/<repo>.git
```

For an existing repo:

```bash
git remote set-url origin git@github.com-anhlai-personal:<user>/<repo>.git
```

## Tip — per-repo identity (work vs. personal)

Set identity per repo:

```bash
git config user.email "laingocanh1990@gmail.com"
git config user.name "Anh Lai"
```

Or split automatically in `~/.gitconfig` with conditional includes:

```gitconfig
[includeIf "gitdir:~/personal/"]
    path = ~/.gitconfig-personal

[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
```

`~/.gitconfig-personal`:

```gitconfig
[user]
    name = Anh Lai
    email = laingocanh1990@gmail.com
```
