# Tip 30 — Run Normal Mode Commands Across a Range

> Chapter 5 — Command-Line Mode · *Practical Vim* (Drew Neil)

**One-liner:** `:[range]normal {cmd}` runs a Normal-mode command on every line in the range — the scalable Dot Formula: `:%normal A;` appends a semicolon to *every* line without counting.

**Practice file:** [`../practice/tip-30-run-normal-commands-across-a-range/foobar.js`](../practice/tip-30-run-normal-commands-across-a-range/foobar.js) — append `;` to every `var` line at once. Reset with `u` or `:e!`.

## Commands

| Command | Effect |
| --- | --- |
| `:[range]normal {cmd}` | Run Normal-mode `{cmd}` on each line in `[range]` |
| `:'<,'>normal .` | Repeat the last change on every selected line |
| `:%normal A;` | Append `;` to every line in the file |
| `:%normal i//` | Prefix every line with `//` (comment out the file) |
| `:'<,'>normal @q` | Run macro `q` on every selected line |

## How it works

The Dot Formula (`A;<Esc>` then `j.`) is great for a few lines — but for 50 lines that's `j.` × 50 = 100 keystrokes. `:normal` fixes that: it runs a Normal-mode command **once per line** across a whole range.

Two flavors:

1. **`:'<,'>normal .`** — "for each line in the visual selection, execute the `.` command." Change the first line normally, then select the rest and let `:normal .` repeat it on all of them.
2. **`:%normal {cmd}`** — run any Normal command on the whole file (`%` = all lines). E.g. `:%normal A;` appends `;` everywhere in one shot.

Two things make it robust:

- Before running `{cmd}` on each line, Vim **moves the cursor to the start of that line** — so cursor position doesn't matter.
- If `{cmd}` enters Insert mode (like `A;` or `i//`), Vim automatically returns to Normal mode after each line.

## Example

Starting `foobar.js` (var lines):

```
var foo = 1
var bar = 'a'
var baz = 'z'
var foobar = foo + bar
var foobarbaz = foo + bar + baz
```

**Option A — change first line, repeat on the rest with `.`:**

```
A;<Esc>          var foo = 1;   (change line 1)
jVG              select the remaining lines
:'<,'>normal .   append ";" to each via the dot command
```

**Option B — one command for the whole file:**

```
:%normal A;
```

Both yield every line ending in `;`. Works identically for 5 lines or 50 — no counting, just select (or use `%`).

## Why it matters / when to reach for it

`:normal` marries **Normal mode's expressiveness** with **Ex commands' range** — "strike far and wide" with any keystroke sequence. It's most powerful combined with a repeat:

- `:normal .` for simple repeats
- `:normal @q` to replay a **macro** on every line (Tips 67, 69)

Reach for it whenever the same edit must hit many consecutive lines and the Dot Formula would be tedious. `:%normal i//` comments out a whole file in one line.

## Gotchas

- The command runs from the **start of each line** — design `{cmd}` accordingly (use `A`/`$` to reach line ends, `I`/`^` for starts).
- Insert-mode commands are fine — Vim exits Insert after each line automatically. Don't add a trailing `<Esc>` in `:normal A;` (it's implicit; a literal `<Esc>` would need `<C-v><Esc>`).
- If a command fails on one line, the whole run can abort — test on a small selection first.
- Alternatives to this exact task: the Dot Formula (Tip 2) for a few lines, or Visual-Block `$A;` (Tip 26).

## Related

- Tip 2 — Don't Repeat Yourself (Dot Formula, doesn't scale)
- Tip 26 — Append After a Ragged Visual Block (another solution)
- Tip 28 — Ranges (`%`, `'<,'>`)
- Tip 67 / 69 — `:normal @q` with macros
