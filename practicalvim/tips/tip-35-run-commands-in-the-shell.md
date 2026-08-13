# Tip 35 — Run Commands in the Shell

> Chapter 5 — Command-Line Mode · *Practical Vim* (Drew Neil)

**One-liner:** Call external programs without leaving Vim — `:!{cmd}` runs one, and with a range `:[range]!{filter}` pipes those lines *through* the command, replacing them with its output (e.g. `:2,$!sort`).

**Practice file:** [`../practice/tip-35-run-commands-in-the-shell/emails.csv`](../practice/tip-35-run-commands-in-the-shell/emails.csv) — sort the records by last name, keeping the header on top. Reset with `u` or `:e!`.

## Commands

| Command | Effect |
| --- | --- |
| `:!{cmd}` | Run `{cmd}` in the shell, echo its output (`:h :!`) |
| `:shell` | Start an interactive shell; `exit` returns to Vim |
| `:read !{cmd}` | Insert `{cmd}`'s stdout **below the cursor** |
| `:[range]write !{cmd}` | Feed `[range]` lines to `{cmd}` as **stdin** |
| `:[range]!{filter}` | **Filter** `[range]` through `{filter}` (stdin → replaces the lines) |
| `!{motion}` | Operator: set the range from a motion, then prompt `:.,X!` |

Best used from **terminal Vim** (GVim/MacVim delegate to the shell less smoothly).

## How it works

**Fire one command — `:!{cmd}`.** `:!ls` shells out to `ls`. (Note `:!ls` ≠ `:ls`: the latter is Vim's *buffer list*.) On the command line, `%` is shorthand for the current filename (`:h cmdline-special`), so `:!ruby %` runs the current file. Filename modifiers extract path/extension (`:h filename-modifiers`, Tip 44).

**Many commands — `:shell`** starts an interactive shell; `exit` comes back. Even simpler in terminal Vim: `<C-z>` suspends Vim to the background (`jobs` lists it), and `fg` resumes it — faster than `:shell`/`exit`.

**Buffer as stdin/stdout.**
- `:read !{cmd}` puts a command's **output into** the buffer (good when there's lots of output).
- `:[range]write !{cmd}` sends buffer lines **as input to** a command. Beware bang placement: `:write !sh` and `:write ! sh` pipe the buffer to `sh`; but `:write! sh` means `:write!` (force-overwrite) to a *file* named `sh`. Same characters, very different outcome — take care.

**Filter a range — `:[range]!{filter}`.** With a range, `:!` *filters*: the range is fed as stdin and its output **overwrites** those lines. A filter = "reads stdin, transforms, writes stdout" (sort, sed, awk, jq, fmt, column…).

## Example — sort a CSV by last name

Starting `emails.csv`:

```
first name,last name,email
john,smith,john@example.com
drew,neil,drew@vimcasts.org
jane,doe,jane@example.com
```

Sort by the 2nd field, keeping the header on line 1:

```
:2,$!sort -t',' -k2
```

Result:

```
first name,last name,email
jane,doe,jane@example.com
drew,neil,drew@vimcasts.org
john,smith,john@example.com
```

`-t','` sets the field separator, `-k2` sorts on the second field, and the `2,$` range excludes the header.

**Shortcut for the range — `!{motion}`.** `!` is an operator: put the cursor on line 2 and press `!G`; Vim opens the prompt pre-filled with `:.,$!`, and you just type the filter (`sort -t',' -k2`).

## Why it matters / when to reach for it

You're always a couple of keystrokes from the shell. Filtering (`:[range]!`) is the standout: reformat, sort, or transform buffer text with any Unix tool instead of hunting for a Vim-native way. `:read !` pulls in command output (dates, file listings, generated code); `:write !` pipes the buffer out.

## Gotchas

- **Bang placement matters:** `:write !sh` (pipe to shell) vs `:write! sh` (overwrite file `sh`).
- `:!{cmd}` echoes output and waits for `<Enter>`; for verbose output prefer `:read !{cmd}`.
- Terminal Vim handles all this best; GVim/MacVim can be flaky.
- `make` and `grep` get special wrapper commands (`:make`, `:grep`) that parse output into the quickfix list (Chapters 17–18) — don't shell out manually for those.

## Related

- Tip 44/45 — filename modifiers; `:write !` for saving as super user
- Tip 12 — Combine and Conquer (the `!` filter operator)
- Chapters 17–18 — `:make` and `:grep` (quickfix)
