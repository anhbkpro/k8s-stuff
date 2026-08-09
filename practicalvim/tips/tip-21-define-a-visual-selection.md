# Tip 21 — Define a Visual Selection

> Chapter 4 — Visual Mode · *Practical Vim* (Drew Neil)

**One-liner:** Vim has three Visual submodes — character (`v`), line (`V`), block (`<C-v>`) — that you can switch between on the fly; `gv` reselects the last selection, and `o` jumps to the other end so you can fix a mis-started range.

**Practice file:** none — practise on any line, e.g. `Select from here to here.`

## Commands — enabling

| Keys | Effect |
| --- | --- |
| `v` | Enable **character-wise** Visual mode |
| `V` | Enable **line-wise** Visual mode |
| `<C-v>` | Enable **block-wise** Visual mode |
| `gv` | Reselect the **last** visual selection |

## Commands — switching / adjusting

| Keys | Effect |
| --- | --- |
| `<Esc>` / `<C-[>` | Back to Normal mode |
| `v` / `V` / `<C-v>` | From that same submode, toggle back to Normal mode |
| `v` / `V` / `<C-v>` | From another submode, switch *to* character / line / block |
| `o` | Jump to the **other end** of the selection (toggle the free end) |

## How it works

The three submodes match the three kinds of text you operate on:

- **Character-wise (`v`)** — a single char up to a run of chars, within or across lines. For words and phrases.
- **Line-wise (`V`)** — whole lines. For operating on complete lines.
- **Block-wise (`<C-v>`)** — rectangular/columnar regions. Special enough to get its own tips (24–26).

**Switching is free.** The enabling keys double as switchers: from character-wise, `V` jumps to line-wise, `<C-v>` to block-wise. Pressing the *same* key you're already in toggles back to Normal — so `v` is a toggle between Normal and character-wise Visual. `<Esc>`/`<C-[>` always exits.

**`gv` — reselect last.** Reselects whatever you last had highlighted, regardless of submode. Handy for applying a second operation to the same range (since acting on a selection drops you back to Normal and clears it). Only gets confused if that text was since deleted.

**`o` — toggle the free end.** A selection has a fixed anchor and a moving end (follows the cursor). `o` swaps which end is free, so if you realize you started in the wrong place, you can extend from the *other* side without restarting.

## Example — fixing the start with `o`

```
{start}   Select from here to here.   (cursor on first "here")
vbb       Select from here to here.   (extend left, but overshot)
o         Select from here to here.   (jump to the free/other end)
e         Select from here to here.   (adjust that end forward)
```

## Why it matters / when to reach for it

Knowing you can *switch* submodes mid-selection means you rarely have to restart: begin character-wise, realize you want whole lines, press `V`. `o` saves a restart when your anchor was wrong. `gv` is the quickest way to reapply to the same region — or to recover a selection you just acted on.

## Gotchas

- `v`/`V`/`<C-v>` are toggles: pressing the current submode's key exits to Normal, it doesn't "do nothing."
- `gv` after deleting the previously selected text may land somewhere unexpected.
- `o` (lowercase) toggles the free end; in block-wise mode `O` toggles to the other *corner* on the same line (horizontal), useful for columnar edits.

## Related

- Tip 20 — Grok Visual Mode
- Tip 22 — Repeat Line-Wise Visual Commands
- Tip 24–26 — Visual-Block mode in depth
