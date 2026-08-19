# Tip 53 — Mark Your Place and Snap Back to It

> Chapter 8 — Navigate Inside Files with Motions · *Practical Vim* (Drew Neil)

**One-liner:** `m{letter}` drops a mark at the cursor; `` `{letter} `` jumps back to that exact spot — and Vim maintains a set of *automatic* marks (last change, last insert, last selection…) for free.

**Practice file:** none — practise: `ma`, move away, `` `a `` to snap back; try `` `` ``, `` `. ``, `` `^ ``.

## Commands

| Command | Effect |
| --- | --- |
| `m{a-zA-Z}` | Set a mark at the cursor |
| `` `{mark} `` | Jump to the mark's **exact** line + column |
| `'{mark}` | Jump to the mark's line (first non-blank char) |

## How it works

`m{a-z…}` marks the current cursor position with a letter (`:h m`). **Lowercase** marks are local to the buffer; **uppercase** marks are global across files (Tip 58). Vim gives no visual feedback, but you can then leap back from anywhere in two keystrokes.

Two jump commands — they look alike, so be careful:

- `` `{mark} `` — restores the **exact position** (line *and* column).
- `'{mark}` — goes to the **line** only (first non-blank).

**If you learn one, learn `` `{mark} ``** — it gets you to the right line whether or not you care about the column. You only *need* `'{mark}` inside an Ex command range (e.g. `:'a,'b`, Tip 28).

Handy convention: `mm` sets mark `m`, `` `m `` jumps to it — a quick "mark here, wander off, snap back" maneuver (used in Swap Two Words, Tip 95). You get 26 lowercase marks per buffer — far more than you'll need.

## Automatic marks (Table 14)

Vim sets these for you — often more useful than manual marks:

| Mark | Position |
| --- | --- |
| `` `` `` | Before the **last jump** in the current file |
| `` `. `` | Location of the **last change** |
| `` `^ `` | Location of the **last insertion** |
| `` `[ `` / `` `] `` | Start / end of last change or yank |
| `` `< `` / `` `> `` | Start / end of last visual selection |

- `` `` `` complements the jump list (Tip 55) — bounce back to where you jumped from (and again to toggle).
- `` `. `` complements the change list (Tip 56) — snap to your last edit.
- `` `< ``/`` `> `` mean Visual mode is, in a sense, a friendly interface over marks — and they power the `'<,'>` range (Tip 28).

## Why it matters / when to reach for it

Set a manual mark before wandering off to reference or copy something, then `` `{mark} `` back. But the automatic marks are the daily win: `` `. `` returns to your last edit, `` `` `` toggles back to where you jumped from — no setup required.

## Gotchas

- `` ` `` (backtick) = exact spot; `'` (apostrophe) = line only. Prefer backtick.
- Lowercase = per-buffer; uppercase = global (jump across files, Tip 58).
- Marks aren't shown on screen — trust that they're set.
- `''` / `` `` `` (doubled) toggles between current and previous jump position — great for A↔B hopping.

## Related

- Tip 28 — Ranges (`'a,'b`, `'<,'>`)
- Tip 55 — Traverse the Jump List (`` `` ``)
- Tip 56 — Traverse the Change List (`` `. ``)
- Tip 58 — Global Marks (uppercase, cross-file)
- Tip 95 — Swap Two or More Words (mark-and-snap)
