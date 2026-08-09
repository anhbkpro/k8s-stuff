# Tip 25 — Change Columns of Text

> Chapter 4 — Visual Mode · *Practical Vim* (Drew Neil)

**One-liner:** In Visual-Block mode, `c` deletes the selected column and drops you into Insert mode — type once and, on `<Esc>`, the text is stamped onto **every** selected line.

**Practice file:** [`../practice/tip-25-change-columns-of-text/sprite.css`](../practice/tip-25-change-columns-of-text/sprite.css) — change `images` to `components` on all three lines at once. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `<C-v>` | Normal → Visual-Block | Start block-wise selection |
| `<C-v>jje` | Normal → Visual-Block | Select a column across 3 lines, out to end of word |
| `c` | Visual-Block → Insert | Delete the block and enter Insert mode |
| `<Esc>` | Insert → Normal | Commit the typed text to **all** selected lines |

## How it works

Visual-Block isn't just for tables — it's great for parallel edits in code. Say `sprite.png` moved from `images/` to `components/` and you must fix every line.

1. `<C-v>` starts the block; extend it to cover the word `images` on all three lines (`jj` down, `e` to end of the word).
2. `c` deletes the selected column across all lines and drops you into Insert mode.
3. Type `components`.

**The surprise:** while you type, the new text appears on the **topmost line only**. The other lines look untouched — until you press `<Esc>`, at which point Vim stamps the typed text onto every line in the block.

## Example

Starting `sprite.css`:

```
li.one   a{ background-image: url('/images/sprite.png'); }
li.two   a{ background-image: url('/images/sprite.png'); }
li.three a{ background-image: url('/images/sprite.png'); }
```

```
{cursor on the "images" of line 1}
<C-v>jje        select the "images" column on all 3 lines
c               delete it → Insert mode (only top line shows changes)
components      type the replacement
<Esc>           now all three lines read '/components/sprite.png'
```

## Why it matters / when to reach for it

Any time the *same* text change lands in a column across several lines — renaming a path, a variable prefix, a shared literal — block-change does it in one pass instead of `.`-repeating per line. It's the multi-cursor-style edit many editors advertise, built into Vim.

## Gotchas

- **Deletion is immediate on all lines; insertion previews on the top line only** and propagates on `<Esc>`. This feels inconsistent vs. editors that update every line live — but the final result is identical.
- **Keep the Insert burst short.** The propagation only works cleanly for a simple typed insertion; complex in-Insert navigation can spoil it (same spirit as Tip 8's "moving in Insert mode resets the change").
- Every selected line must actually have text in that column for the change to land as expected.
- Related block inserts: `I` inserts *before* the block on every line, `A` appends *after* it (Tip 26) — same top-line-preview, propagate-on-`<Esc>` behavior.

## Related

- Tip 24 — Edit Tabular Data with Visual-Block Mode
- Tip 26 — Append After a Ragged Visual Block (`$A`)
- Tip 8 — Chunk Your Undos (keep Insert bursts short)
