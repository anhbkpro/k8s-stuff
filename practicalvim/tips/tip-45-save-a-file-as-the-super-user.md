# Tip 45 — Save a File as the Super User

> Chapter 7 — Open Files and Save Them to Disk · *Practical Vim* (Drew Neil)

**One-liner:** Editing a root-owned file as a normal user, `:write` fails on permissions — pipe the buffer to `sudo tee` instead: `:w !sudo tee % > /dev/null`.

**Practice file:** none — the book uses `/etc/hosts` (a real system file). Only try on a throwaway root-owned file, or just read this one.

## Commands

| Command | Effect |
| --- | --- |
| `<C-g>` | Show file status (e.g. `[readonly]`) |
| `:write` | Normal save (fails with `E45` if readonly) |
| `:write!` | Force save (still fails with `E212` if no OS permission) |
| `:w !sudo tee % > /dev/null` | Save via a `sudo` shell process |

Unix + terminal Vim only (not GVim, not Windows).

## How it works

Open a root-owned file as a regular user (`vim /etc/hosts`) and `<C-g>` shows `[readonly]`. Vim still *lets you edit* the buffer (with a `W10: Changing a readonly file` reminder — advisory, not a block), but saving hits two walls:

```
:write
E45: 'readonly' option is set (add ! to override)

:write!
"/etc/hosts" E212: Can't open file for writing
```

`:write!` clears Vim's own readonly flag, but the **OS** still refuses — you (user `drew`) don't own the file. The remedy delegates the write to a privileged shell process:

```
:w !sudo tee % > /dev/null
```

Breaking it down:

- `:w !{cmd}` pipes the **buffer contents as stdin** to an external `{cmd}` (Tip 35, `:h :write_c`). Vim itself keeps running as your user.
- `%` expands to the current buffer's path (`/etc/hosts`).
- `sudo tee %` runs `tee` **as root**, and `tee` writes its stdin to that file — so the buffer overwrites `/etc/hosts` with root privileges.
- `> /dev/null` discards `tee`'s stdout (it also echoes to stdout, which you don't need).

You'll be prompted for your sudo password, then Vim notices the file changed on disk and asks whether to reload — press **`L`** (load) to sync the buffer with what was just written.

## Why it matters / when to reach for it

The classic "damn, this file needs sudo and I've already made my edits" rescue — no need to quit, `sudo vim`, and redo the changes. Many people map it (e.g. `:W`) or use a plugin (`vim-eunuch`'s `:SudoWrite`) since the raw command is hard to remember.

## Gotchas

- `E45` = Vim's readonly flag (bypass with `!`); `E212` here = OS permission denied (needs sudo) — different problems, both can appear in sequence.
- After the write, Vim prompts about the externally-changed file — choose **Load** so buffer and disk agree.
- Unix/terminal only; won't work in GVim or on Windows.
- Editing system files (`/etc/hosts`, etc.) with root power is risky — double-check before saving.

## Related

- Tip 35 — Run Commands in the Shell (`:w !{cmd}`, `%`)
- Tip 44 — Save Files to Nonexistent Directories (the *missing-dir* case)
- Tip 41 — Filename modifiers (`%`)
