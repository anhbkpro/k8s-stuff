# Tip 27 — Meet Vim's Command Line

> Chapter 5 — Command-Line Mode · *Practical Vim* (Drew Neil)

**One-liner:** Press `:` to enter Command-Line mode and run **Ex commands** — line-oriented commands that "strike far and wide," editing many lines anywhere in the file without moving the cursor.

**Practice file:** none — this is an overview; the hands-on drills start in Tip 28 (`practical-vim.html`).

## How it works

`:` switches Vim into **Command-Line mode**, a shell-like prompt where you type a command and press `<CR>` to run it (`<Esc>` cancels back to Normal mode). The commands you run here are **Ex commands**, inherited from Vim's ancestor line editor *ex* (hence the name). The same mode also backs the `/` search prompt and the `<C-r>=` expression register.

**Why bother when Normal mode exists?** Ex commands complement Normal commands:

- Normal commands act on the current character/line; **Ex commands can act anywhere** — no need to move the cursor there first.
- Ex commands can operate over a whole **range of lines** in one move.

Neil's summary: **Ex commands strike far and wide.**

## Ex commands that operate on buffer text (Table 9)

| Command | Effect |
| --- | --- |
| `:[range]delete [x]` | Delete lines [into register x] |
| `:[range]yank [x]` | Yank lines [into register x] |
| `:[line]put [x]` | Put register x's text after the line |
| `:[range]copy {address}` | Copy lines to below `{address}` (`:t`) |
| `:[range]move {address}` | Move lines to below `{address}` (`:m`) |
| `:[range]join` | Join the lines |
| `:[range]normal {cmds}` | Run Normal-mode `{cmds}` on each line |
| `:[range]substitute/{pat}/{str}/[flags]` | Find & replace on each line |
| `:[range]global/{pat}/[cmd]` | Run `[cmd]` on every matching line |

Beyond text editing, Ex commands do nearly everything: `:edit`/`:write` (files), `:tabnew`/`:split` (windows), `:prev`/`:next`, `:bprev`/`:bnext` (lists). Full list: `:h ex-cmd-index`.

## Special keys at the command line

Command-Line mode is like Insert mode — most keys just type a character — and it shares several chords:

| Keys | Effect |
| --- | --- |
| `<C-w>` | Delete back one word |
| `<C-u>` | Delete back to start of line |
| `<C-v>` / `<C-k>` | Insert a character by code / digraph |
| `<C-r>{register}` | Insert the contents of a register |

Motion at the prompt is limited (just `<Left>`/`<Right>` a char at a time) — but the **command-line window** (Tip 34) gives you full editing power for composing complex commands.

## Why it matters / when to reach for it

This tip frames the whole chapter: whenever a change is line-oriented, spans many lines, or is somewhere other than the cursor, an Ex command is often faster than navigating + Normal commands. Ranges (Tip 28), `:t`/`:m` (Tip 29), `:normal` (Tip 30), `:substitute` (Ch. 14), and `:global` (Ch. 15) all build on this.

## Gotchas

- The terse syntax is historical: *ed* had to be economical over slow teletype links (`p` prints a line, `%p` the file). That terseness is why Ex commands are powerful in few keystrokes.
- Most commands accept a `[range]` (Tip 28) — omit it and they act on the current line.
- `:substitute` and `:global` are big enough to get their own chapters.

## Related

- Tip 28 — Execute a Command on One or More Consecutive Lines (`[range]`)
- Tip 29 — Duplicate or Move Lines Using `:t` and `:m`
- Tip 30 — Run Normal Mode Commands Across a Range (`:normal`)
- Tip 34 — Recall Commands from History (command-line window)
