# Tip 55 — Traverse the Jump List

> Chapter 9 — Navigate Between Files with Jumps · *Practical Vim* (Drew Neil)

**One-liner:** `<C-o>` and `<C-i>` are Vim's "back" and "forward" buttons — they retrace the **jump list**, the trail of long-range jumps (including between files) you've made this session.

**Practice file:** none — open a couple of files, `[count]G` / `/pattern` / `%` around, then `<C-o>` / `<C-i>` to retrace. Inspect with `:jumps`.

## Commands

| Command | Effect |
| --- | --- |
| `<C-o>` | Jump **back** to the previous position (like Back) |
| `<C-i>` | Jump **forward** (like Forward) |
| `:jumps` | Show the jump list |

## How it works

Like a browser's back/forward buttons, `<C-o>`/`<C-i>` walk the **jump list** — Vim records your cursor position before and after each *jump*. `:jumps` prints the list.

**Motion vs jump:** motions move within a file; **jumps can move between files** (and some motions count as jumps). Rule of thumb: **long-range moves are jumps; short-range moves aren't.** Any command that changes the active file is a jump too — so after `:edit other.js`, `<C-o>` takes you back to where you were.

## What counts as a jump (selection)

| Command | |
| --- | --- |
| `[count]G` | Jump to a line number |
| `/pat` `?pat` `n` `N` | Search jumps |
| `%` | Matching bracket |
| `(` `)` | Sentence start (prev/next) |
| `{` `}` | Paragraph start (prev/next) |
| `H` `M` `L` | Top / middle / bottom of screen |
| `gf` | To the filename under the cursor (Tip 57) |
| `<C-]>` | To the definition of the keyword under the cursor |
| `` '{mark} `` / `` `{mark} `` | To a mark |

**Not** jumps: `j`/`k` one line, `h`/`l`, word motions — those are just motions. (So `10G` is a jump you can `<C-o>` back from; `10j` isn't.)

## Why it matters / when to reach for it

The jump list is a breadcrumb trail through the places you've visited — invaluable for "take me back to where I was before I chased that definition." Jump into a function with `<C-]>` or `gf`, read it, then `<C-o>` straight back. Because jumps span files, it's your primary cross-file "undo my navigation."

## Gotchas

- `<C-o>`/`<C-i>` are **not motions** — you can't use them in Visual or Operator-Pending mode to extend a selection.
- **Each window has its own jump list** — `<C-o>`/`<C-i>` are scoped to the active window (splits/tabs each keep their own trail).
- **`<C-i>` = `<Tab>`** to Vim — they're the same keycode. Mapping `<Tab>` overrides `<C-i>`, crippling forward-jump. Think twice before remapping `<Tab>` in Normal mode.
- Short motions don't enter the jump list, so you can't `<C-o>` back over a single `j`.

## Related

- Tip 53 — Marks (`` `` `` = before last jump)
- Tip 56 — Traverse the Change List (`g;` / `g,`)
- Tip 57 — Jump to the Filename Under the Cursor (`gf`)
- Tip 54 — `%` (a jump)
