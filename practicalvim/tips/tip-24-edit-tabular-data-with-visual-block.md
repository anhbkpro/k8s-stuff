# Tip 24 — Edit Tabular Data with Visual-Block Mode

> Chapter 4 — Visual Mode · *Practical Vim* (Drew Neil)

**One-liner:** Visual-Block mode (`<C-v>`) selects rectangular columns of text — delete a column with `x`, or replace a whole column with `r{char}` — perfect for reshaping plain-text tables.

**Practice file:** [`../practice/tip-24-edit-tabular-data-with-visual-block/chapter-table.txt`](../practice/tip-24-edit-tabular-data-with-visual-block/chapter-table.txt) — tighten the column gap, add a `|` divider, and underline the header. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `<C-v>` | Normal → Visual-Block | Start block-wise (columnar) selection |
| `<C-v>3j` | Normal → Visual-Block | Select a column spanning 4 lines |
| `x` | Visual-Block | Delete the selected column/block |
| `r{char}` | Visual-Block | Replace every char in the block with `{char}` |
| `gv` | Normal → Visual | Reselect the last selection |
| `yyp` / `Vr-` | Normal | Duplicate a line / replace the whole line with `-` |

## How it works

Rows are easy in any editor; **columns** need a special tool. `<C-v>` engages Visual-Block mode, where the selection is a rectangle. Move down (`3j`) and right to size the box, then operate on it.

Two block operations here:

- **`x`** deletes the selected column. Repeating with `.` deletes the same-sized column again — tighten the gap between columns one column at a time (instant visual feedback, `u` to back off). Alternatively, widen the block a few columns right and delete once.
- **`r{char}`** replaces *every* character in the block with one character — e.g. `r|` paints a vertical pipe divider down the whole selection.

## Example

Starting `chapter-table.txt` (columns spaced too far apart):

```
Chapter            Page
Normal mode          15
Insert mode          31
Visual mode          44
```

Reshape it:

```
<C-v>3j   select a 4-line column in the gap
x...      delete that column; . repeats to shrink the gap
gv        reselect the same block
r|        paint a "|" divider down the column
yyp       duplicate the header line
Vr-       replace the whole duplicated line with dashes
```

Result:

```
Chapter | Page
--------------------
Normal mode | 15
Insert mode | 31
Visual mode | 44
```

## Why it matters / when to reach for it

Any columnar edit — aligning tables, inserting/removing a vertical strip, drawing ASCII dividers, editing aligned code — is a Visual-Block job. The `x`-then-`.` rhythm gives you visual feedback while trimming whitespace columns; `r|`/`r-` turn a block or line into a ruled divider in two keystrokes.

## Gotchas

- Sizing the block: move down for rows, right for columns; the rectangle is anchor-to-cursor. `o`/`O` toggle which corner is free (Tip 21).
- `gv` reselects the exact last block — handy for a second block op on the same region.
- `Vr-` uses **line-wise** Visual + `r`, replacing every char on the line with `-`; `<C-v>` + `r|` uses **block-wise** to paint a column.
- Next tip (25) covers **inserting** into a block with `c`/`I`/`A`, which behaves surprisingly (change shows on the top line until `<Esc>`).

## Related

- Tip 21 — Define a Visual Selection (`<C-v>`, `o`/`O`, `gv`)
- Tip 25 — Change Columns of Text (block insert/change)
- Tip 26 — Append After a Ragged Visual Block
- Tip 19 — Replace Mode (`r{char}`)
