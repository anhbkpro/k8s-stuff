# Tip 11 — Don't Count If You Can Repeat

> Chapter 2 — Normal Mode · *Practical Vim* (Drew Neil)

**One-liner:** A count can shave keystrokes, but repeating with `.` gives finer-grained undo and forgiving recovery — so prefer `dw.` over `d2w` when you'd otherwise have to *count* things, and save counts for when they genuinely matter.

**Practice file:** none — try both approaches on any line of prose, e.g. `Delete more than one word` and `I have a couple of questions.`

## Commands

| Keys | Mode | Does |
| --- | --- | --- |
| `d2w` / `2dw` | Normal | Delete two words (count on motion vs. on operator — same result) |
| `dw` then `.` | Normal | Delete a word, then repeat |
| `u` / `2u` | Normal | Undo once / undo twice |
| `c3w` | Normal → Insert | Change three words at once (a good use of a count) |

## How it works

To delete two words you have three equal-length (3-keystroke) options: `d2w`, `2dw`, or `dw.`.

- `d2w` = "delete two words" (count on the motion). `2dw` = "delete a word, twice" (count on the operator). Semantics differ, result is identical.
- `dw.` = "delete a word, then repeat."

They diverge on **undo and recovery granularity:**

- After `d2w`, one `u` brings both words back, and `.` would delete the *next two* words.
- After `dw.`, the underlying change is just `dw`. So restoring both words takes `uu` (or `2u`), and `.` deletes *one* more word. Each of `u` and `.` now acts on a single word.

**Why the finer granularity wins — recovery from a miscount.** Suppose you meant to delete three words but ran `d2w`. You can't just press `.` (that deletes two more → four total). You must back up and redo the count (`ud3w`) or bolt on `dw`. Had you started with `dw.`, deleting three words is just `dw..` — and if you overshoot, a single `u` steps back one word. That's the *act, repeat, reverse* mantra (Tip 4) in action.

For seven words: `d7w` vs `dw......`. Fewer keystrokes for the count — but would you trust yourself to *count to seven* correctly? Neil would rather tap `.` six times (and `u` once if he overshoots) than pause to count ahead.

## When a count *does* earn its place

Counts win when repeating would be awkward or when a clean undo history matters:

```
{start}            I have a couple of questions.
c3wsome more<Esc>  I have some more questions.
```

Here `.`-repetition is clumsy — you'd delete words, then switch gears into Insert mode — so a count (`c3w`) is cleaner. Bonus: the whole edit is a **single** change, so one `u` reverts it (ties into Tip 8's clean-undo idea).

The same clean-undo argument even favors `d5w` over `dw....` sometimes — so the preference isn't absolute. You'll develop your own line based on how much you value a tidy undo history versus avoiding the mental tax of counting.

## Gotchas

- `d2w` and `2dw` are interchangeable for this purpose, but the count *position* matters for other operator/motion combos — know which one the count binds to.
- The trade-off is real but personal: keystroke-minimizers lean toward counts; repeat-lovers lean toward `.`. Neither is "wrong."
- A miscounted count is expensive to fix; an over-repeated `.` is one `u` away from fixed. That asymmetry is the heart of the tip.

## Related

- Tip 4 — Act, Repeat, Reverse
- Tip 8 — Chunk Your Undos (clean undo history)
- Tip 10 — Use Counts to Do Simple Arithmetic (when counts shine)
- Tip 12 — Combine and Conquer (operator + motion grammar)
