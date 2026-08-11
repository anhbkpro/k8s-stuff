# Tip 34 — Recall Commands from History

> Chapter 5 — Command-Line Mode · *Practical Vim* (Drew Neil)

**One-liner:** Vim remembers your Ex and search commands — scroll them with `<Up>`/`<Down>` (prefix-filtered), or open the **command-line window** with `q:` to edit past commands using full Vim editing power.

**Practice file:** none — practise by running a few `:` commands, then `:` `<Up>` and `q:`.

## Commands

| Keys | Effect |
| --- | --- |
| `:` then `<Up>`/`<Down>` | Scroll Ex-command history (filters by what you've typed) |
| `/` then `<Up>`/`<Down>` | Scroll search history |
| `<C-p>` / `<C-n>` | Older / newer history (home-row, but **not** filtered) |
| `q:` | Open the command-line window (Ex history) |
| `q/` | Open the command-line window (search history) |
| `<C-f>` | Switch from the `:` prompt into the command-line window |
| `:set history=200` | Increase remembered commands (default 20; persists across sessions) |

## How it works

**Scrolling history.** Press `:`, leave it empty, and `<Up>` recalls your last Ex command; keep pressing to go further back (`<Down>` forward). Type a prefix first — `:help` then `<Up>` — and Vim **filters** to commands starting with "help". The `/` search prompt has its own separate history (it's just another Command-Line mode).

History defaults to the last 20 commands and **persists across sessions** (via viminfo). Bump it with `set history=200`.

**`<C-p>`/`<C-n>`** move through history without leaving the home row, but they *don't* filter by prefix like `<Up>`/`<Down>` do. Get the best of both with mappings:

```vim
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
```

## The command-line window (`q:`)

Command-Line mode is fine for composing but awful for *editing* a command. `q:` opens the **command-line window** — a real Vim buffer where each line is a history item. Navigate with `j`/`k` or search; press `<CR>` on a line to execute it. The payoff: you can edit historical commands with **full modal editing** — motions, Visual mode, Insert mode, even Ex commands on the history itself.

**Example — merge two history lines into one.** You keep running:

```
:write
:!ruby %
```

Fold them into one command line via `q:`:

```
{in command-line window}
write
!ruby %

A |<Esc>            write |
J                   write | !ruby %
:s/write/update     update | !ruby %
<CR>                execute → runs :update | !ruby %
```

## Why it matters / when to reach for it

For long or fiddly Ex commands, never retype — recall and tweak. `<Up>` with a prefix is the fastest way to re-run a variant of a recent command. `q:` is the tool when a command needs real editing (combining, fixing, adapting), and it reappears in Tip 85 for building complex search patterns.

## Gotchas

- **`q:` vs `:q`** — easy to swap! `q:` opens the command-line window; `:q` quits. Many people meet `q:` by accident and get confused — close it with `:q` or `<CR>`.
- The command-line window **grabs focus**: you can't switch windows until you dismiss it, and it executes in the context of the *previously active* window — watch out with splits (Vim doesn't highlight which is active).
- `<C-p>`/`<C-n>` don't filter by prefix unless you remap them as above.
- `<C-f>` from the `:` prompt carries your half-typed command into the window.

## Related

- Tip 31 — Repeat the Last Ex Command (`@:`)
- Tip 33 — Insert the Current Word at the Command Prompt
- Tip 85 — Create Complex Patterns by Iterating upon Search History (`q/`)
