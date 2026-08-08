# Tip 13 — Make Corrections Instantly from Insert Mode

> Chapter 3 — Insert Mode · *Practical Vim* (Drew Neil)

**One-liner:** Fix typos without leaving Insert mode using the delete chords `<C-h>` (char), `<C-w>` (word), and `<C-u>` (to start of line) — and when a word comes out wrong at the start, just nuke it and retype rather than dancing back with the cursor.

**Practice file:** none — practise while typing prose in any buffer; deliberately fat-finger a word and clear it with `<C-w>`.

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `<BS>` | Insert | Delete the character before the cursor (backspace) |
| `<C-h>` | Insert | Delete back one character (same as backspace) |
| `<C-w>` | Insert | Delete back one word |
| `<C-u>` | Insert | Delete back to the start of the line |

## How it works

Touch typing is done *by feel* — you often sense a mistake in your fingers before your eyes catch it on screen. When that happens you don't need to change modes; Insert mode has its own quick erasers:

- Error near the **end** of the word → tap `<BS>`/`<C-h>` a few times and retype the tail.
- Error at the **start** of the word → don't backspace through the whole thing, and don't switch to Normal mode to hunt for it. Expert typists' advice: **delete the whole word (`<C-w>`) and type it again.** Above ~60 wpm that costs about a second; below that, it's good practice.
- Whole line went wrong → `<C-u>` wipes back to the start of the line.

Switching to Normal mode, navigating to the start of the word, fixing it, then `A` to resume is a slower "little dance" that also does nothing for your typing skill. *Just because you can switch modes doesn't mean you should.*

## Example

```
The quick brwon   ← noticed "brwon" is wrong
<C-w>             ← deletes "brwon"
brown             ← retype it cleanly
```

## Why it matters / when to reach for it

These chords keep you in the flow of composing text. Retyping a fumbled word (rather than surgically editing it) also builds a useful side effect: you become aware of which words consistently trip you up, and over time you mistype them less.

## Gotchas

- **Not Vim-specific.** `<C-h>`, `<C-w>`, and `<C-u>` also work in Vim's command line *and* in the bash/zsh shell and most readline prompts — muscle memory that pays off everywhere.
- `<C-w>`'s notion of a "word" follows Vim's small-word rules, so it stops at punctuation boundaries.
- On some terminals `<C-h>` and backspace are the same byte — usually a non-issue, occasionally relevant to `:h i_CTRL-H` quirks.
- This is about *correcting as you type*. For structural edits, return to Normal mode (Tip 14).

## Related

- Tip 7 — Pause with Your Brush Off the Page ("can" ≠ "should" for mode switching)
- Tip 8 — Chunk Your Undos (Insert-mode edits are one change)
- Tip 14 — Get Back to Normal Mode
