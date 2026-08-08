# Tip 9 — Compose Repeatable Changes

> Chapter 2 — Normal Mode · *Practical Vim* (Drew Neil)

**One-liner:** When several techniques take the same number of keystrokes, the best one is whichever leaves the dot command primed to do something useful — so `daw` beats `dbx` and `bdw` for deleting a word.

**Practice file:** [`../practice/tip-09-compose-repeatable-changes/the_end.txt`](../practice/tip-09-compose-repeatable-changes/the_end.txt) — cursor on the final `h` of "nigh"; delete the word three different ways, then press `.` after each to feel the difference. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Does |
| --- | --- | --- |
| `db` | Normal | Delete backward to start of word |
| `dw` | Normal | Delete forward to start of next word |
| `daw` | Normal | Delete **a** word (the word + a trailing space) — a text object |
| `b` | Normal | Move back to start of word |
| `x` | Normal | Delete one character |
| `.` | Normal | Repeat the last change |

## How it works

Efficiency (fewest keystrokes, "VimGolf") is the obvious metric — but when techniques tie, the tie-breaker is **which one makes the dot command most useful.**

Cursor is on the `h` at the end of `The end is nigh`. Three ways to delete "nigh", all scoring 3 keystrokes:

- **Delete backward — `dbx`:** `db` deletes back to the start of the word but leaves the final `h`; `x` cleans it up. Two operations. `.` now repeats just `x` (delete one char) — nearly useless.
- **Delete forward — `bdw`:** `b` moves to the start of the word (a plain motion), `dw` deletes it. `.` repeats `dw`, but we're at end of line so there's no next word — useless *here*, though at least it's shorthand for a real change.
- **Delete a word — `daw`:** one operation. `daw` = "delete a word" (a text object), removing the word *and* a whitespace char. `.` now repeats `daw` — genuinely useful: it deletes another whole word.

`daw` invests the most power in `.`, so it wins.

## Example

```
{start}   The end is nigh   (cursor on the h)
daw       The end is        (cursor now on "is")
.         The end           (dot repeats "delete a word")
```

Contrast: after `dbx`, `.` would just delete a single character; after `bdw`, `.` would try to delete a nonexistent next word.

## Why it matters / when to reach for it

This is the discipline behind the Dot Formula (Tip 6): making a change repeatable often takes *forethought*, not just fewer keystrokes. When you notice you'll make the same small edit in several places, deliberately compose the first change so `.` can carry the rest — prefer a single operator + text object (`daw`, `ciw`, `dap`) over a motion-plus-cleanup sequence.

Build the habit of asking "which of these equal-length options leaves `.` primed?" and Vim rewards you: often you finish a change and realize the dot command is already loaded to do the next one for free.

## Gotchas

- `daw` deletes a trailing (or leading) space too, so the cursor lands cleanly on the next word — that's *why* `.` chains nicely. Its cousin `diw` ("delete inner word") leaves surrounding whitespace, which is better when you'll type a replacement in place.
- Text objects (`aw`, `iw`, …) work with any operator: `caw`, `yaw`, `gUaw`, etc. — more in Tips 51–52.
- Fewest-keystrokes is a tempting but incomplete metric; repeatability is the real prize.

## Related

- Tip 6 — Meet the Dot Formula
- Tip 8 — Chunk Your Undos
- Tip 51 — Trace Your Selection with Precision Text Objects
- Tip 52 — Delete Around, or Change Inside (`daw` vs `diw`, `caw` vs `ciw`)
