# Tip 6 — Meet the Dot Formula

> Chapter 1 — The Vim Way · *Practical Vim* (Drew Neil)

**One-liner:** The optimal editing pattern is **one keystroke to move, one keystroke to execute** — set up a repeatable change, then advance to each target with a single motion and press `.`.

**Practice file:** none of its own — this tip generalizes Tips 2, 3, and 5. Re-run those drills and notice the shared shape: [`2_foo_bar.js`](../practice/tip-02-dont-repeat-yourself/2_foo_bar.js), [`3_concat.js`](../practice/tip-03-one-step-back-three-forward/3_concat.js), [`1_copy_content.txt`](../practice/tip-05-find-and-replace-by-hand/1_copy_content.txt).

## The core idea

Three different tasks, three solutions — all the same shape. Each made the *change* repeatable (so `.` replays it) and needed only a *single keystroke* to reach the next target. That pattern is the **Dot Formula**.

## The three tasks, side by side

| Tip | Task | Set-up change | Move | Execute | Rhythm |
| --- | --- | --- | --- | --- | --- |
| 2 | Append `;` to each line | `A;<Esc>` | `j` | `.` | `j.` `j.` … |
| 3 | Pad each `+` with spaces | `f+` then `s␣+␣<Esc>` | `;` | `.` | `;.` `;.` … |
| 5 | Change "content" → "copy" | `*` then `cwcopy<Esc>` | `n` | `.` | `n.` `n.` … |

The move key differs (`j`, `;`, `n`) and the change differs, but the formula is identical: **move (1 key) + execute (1 key)**.

## Why it matters / when to reach for it

This is the mental model to carry through the rest of the book. Whenever you face a repetitive edit, ask two questions:

1. **Can I make the change repeatable?** Prefer compound commands (`A`, `s`, `cw`) and self-contained edits so `.` replays the whole thing regardless of exact cursor column.
2. **Can I reach the next target in one keystroke?** Line down = `j`; next char landmark = `f{char}` then `;`; next word occurrence = `*` then `n`; next search hit = `/pat` then `n`.

Get both and the edit collapses to a two-key drumbeat. When either half needs more than one keystroke, that's the signal to rethink — pick a better motion, or a more repeatable change.

## Gotchas

- The formula shines for a *handful* of targets. For dozens of consecutive lines, `:normal` across a range (Tip 30) or `:substitute` (Ch. 14) scales better.
- "Repeatable change" is the harder half to get right — Tip 9 ("Compose Repeatable Changes") and Tip 23 dig into making changes that replay cleanly.
- Remember the reverses (Tip 4): overshoot with `.`/`;`/`n` and back out with `u`/`,`/`N`, so you can hammer the rhythm confidently.

## Related

- Tip 2 — Don't Repeat Yourself (`j.`)
- Tip 3 — Take One Step Back, Then Three Forward (`;.`)
- Tip 5 — Find and Replace by Hand (`n.`)
- Tip 4 — Act, Repeat, Reverse (the reverse gears)
- Tip 9 — Compose Repeatable Changes
- Tip 30 — Run Normal Mode Commands Across a Range (when the formula doesn't scale)
