# Tip 29 — Duplicate or Move Lines Using ':t' and ':m' Commands

> Chapter 5 — Command-Line Mode · *Practical Vim* (Drew Neil)

**One-liner:** `:[range]t {address}` copies lines to just below `{address}` and `:[range]m {address}` moves them there — long-range line duplication/relocation without leaving your cursor.

**Practice file:** [`../practice/tip-29-duplicate-or-move-lines/shopping-list.todo`](../practice/tip-29-duplicate-or-move-lines/shopping-list.todo) — copy "Buy nails" under "Hardware Store" with `:t`, then move the whole Hardware Store section after Beauty Parlor with `:m`. Reset with `u` or `:e!`.

## Commands

| Command | Effect |
| --- | --- |
| `:[range]copy {address}` / `:t {address}` | Copy `[range]` to below `{address}` (`:co`, `:t` = "copy TO") |
| `:[range]move {address}` / `:m {address}` | Move `[range]` to below `{address}` |
| `:t.` | Duplicate the current line (like `yyp`, but no register) |
| `:t$` | Copy current line to end of file |
| `:'<,'>t0` | Copy the visual selection to the top of the file |
| `:'<,'>m$` | Move the visual selection to the end of the file |

## How it works — `:t` (copy)

`:[range]copy {address}` duplicates lines. Shorten to `:co` or `:t` (mnemonic: **copy TO**). Read `:6t.` as "copy line 6 to below the current line."

Examples:

- `:6t.` — copy line 6 below the current line
- `:t6` — copy current line below line 6
- `:t.` — duplicate the current line
- `:t$` — copy current line to the end of the file

**`:t.` vs `yyp`:** both duplicate the current line, but `yyp` uses a register (clobbering the unnamed register) while `:t.` doesn't — handy when you want to keep what's in the default register. And for a **distant** line, `:6t.` beats `6G yy <C-o> p` (jump, yank, snap back, put) — Ex commands are long-range, Normal commands act locally.

## How it works — `:m` (move)

`:[range]move {address}` relocates lines; shorten to `:m`. Read `:'<,'>m$` as "move the selected lines to the end of the file."

## Example

Starting `shopping-list.todo`:

```
Shopping list
    Hardware Store
        Buy new hammer
    Beauty Parlor
        Buy nail polish remover
        Buy nails
```

Copy "Buy nails" (line 6) under "Hardware Store" (current line = line 2):

```
:6t.
```

Then move the Hardware Store block below Beauty Parlor — select it and move to end:

```
Vjj        select the 3 Hardware Store lines
:'<,'>m$   move them to the end of the file
```

## Why it matters / when to reach for it

`:t`/`:m` shine for line surgery where the source or destination is far from the cursor — you name both by address instead of navigating. Alternatives exist (`dGp` = delete selection, `G`, `p` to move to end), but the Ex form is **more reproducible**: repeat the last Ex command with `@:` (Tip 31), so `:'<,'>m$` can be re-fired on a new selection.

## Gotchas

- `{address}` follows Tip 28's rules: line number, `.` (current), `$` (last), `0` (top of file), `'m` mark, `/pattern/`, with offsets.
- **Line `0`** is the destination for "move/copy to the very top": `:t0`, `:m0`.
- `:t.` avoids touching registers — prefer it over `yyp` when register contents matter.
- `:'<,'>` refers to the last visual selection's marks, usable even from Normal mode.

## Related

- Tip 27 — Meet Vim's Command Line
- Tip 28 — Ranges and addresses (`.`, `$`, `0`, `'<,'>`, patterns)
- Tip 31 — Repeat the Last Ex Command (`@:`)
- Tip 30 — Run Normal Mode Commands Across a Range (`:normal`)
