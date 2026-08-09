# Tip 26 — Append After a Ragged Visual Block

> Chapter 4 — Visual Mode · *Practical Vim* (Drew Neil)

**One-liner:** `$` in Visual-Block mode extends the selection to the end of *every* line regardless of length, so `<C-v>jj$A;<Esc>` appends a semicolon to the ragged right edge of all selected lines at once.

**Practice file:** [`../practice/tip-26-append-after-a-ragged-visual-block/2_foo_bar.js`](../practice/tip-26-append-after-a-ragged-visual-block/2_foo_bar.js) — append `;` to all three lines in one block operation. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `<C-v>` | Normal → Visual-Block | Start block-wise selection |
| `$` | Visual-Block | Extend selection to the end of **each** line (ragged edge) |
| `<C-v>jj$` | Normal → Visual-Block | Select to end of all 3 lines, whatever their length |
| `A{text}` | Visual-Block → Insert | Append `{text}` after the selection on every line |
| `I{text}` | Visual-Block → Insert | Insert `{text}` before the selection on every line |

## How it works

Visual-Block isn't limited to rectangles. After `<C-v>`, pressing `$` tells Vim to extend the selection to the end of **all** selected lines — even though each ends at a different column. The right edge becomes ragged, tracing the actual line ends.

Then `A` enters Insert mode at the end of each selected line. Type your text; as with Tip 25's block change, it shows on the top line during Insert, and on `<Esc>` it propagates to every line — appended at each line's own end.

## Example

Starting `2_foo_bar.js` (lines of different lengths):

```
var foo = 1
var bar = 'a'
var foobar = foo + bar
```

```
<C-v>jj$   block-select to the end of all 3 lines (ragged)
A;         append ";" (previews on line 1 only)
<Esc>      propagate → every line ends with ";"
```

Result:

```
var foo = 1;
var bar = 'a';
var foobar = foo + bar;
```

This is the same task as Tip 2 (solved there with `A;<Esc>` + `j.`); here it's one block operation instead of a dot-repeat.

## `i`/`a` vs `I`/`A` — the key sidebar

- **Normal mode:** `i`/`a` insert before/after the **cursor**; `I`/`A` insert at **start/end of line**.
- **Visual-Block mode:** `I` and `A` switch to Insert at the **start/end of the block** and propagate to all lines. But `i`/`a` do **not** — in Visual and Operator-Pending modes they begin a **text object** (`iw`, `aw`, …; Tip 51).
- So if you selected a block, pressed `i`, and wondered why you're not in Insert mode — use **`I`** (or `A`) instead.

## Gotchas

- Use `$` to catch ragged line ends; without it you'd append at a fixed column and mangle shorter/longer lines.
- Text appears on the top line only until `<Esc>`, then propagates (keep the Insert burst short — Tip 8).
- Don't reach for lowercase `i`/`a` to insert in a block — that's the text-object gotcha above.

## Related

- Tip 2 — Don't Repeat Yourself (same task via `A;` + `j.`)
- Tip 24 — Edit Tabular Data with Visual-Block Mode
- Tip 25 — Change Columns of Text
- Tip 51 — Precision Text Objects (why `i`/`a` differ in Visual mode)
