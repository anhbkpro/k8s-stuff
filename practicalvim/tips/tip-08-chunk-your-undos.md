# Tip 8 — Chunk Your Undos

> Chapter 2 — Normal Mode · *Practical Vim* (Drew Neil)

**One-liner:** In Vim you control undo granularity: everything typed between entering Insert mode and pressing `<Esc>` is one undoable chunk — so leave Insert mode at natural breaks to make each `u` revert a coherent thought.

**Practice file:** none — try it live in any buffer while writing a few sentences.

## Commands

| Keys | Mode | Does |
| --- | --- | --- |
| `u` | Normal | Undo the most recent change |
| `i…<Esc>` | Insert | One trip into Insert mode = **one** change = one undo |
| `<Esc>` | Insert → Normal | Ends the current undo chunk |
| `A` | Normal → Insert | Resume appending at end of line after a pause |
| `<Esc>o` | Normal → Insert | Open a new line *and* start a fresh undo chunk |

## How it works

`u` reverts "the most recent change." A change is anything that modifies the buffer — a Normal/Visual/Command-line command, **or** a whole trip through Insert mode. From the moment you press `i` (or `a`, `o`, `c…`) until you press `<Esc>`, everything you type or delete collapses into a *single* change.

That means **you** decide how big an undo step is, just by moderating your `<Esc>` presses:

- Type a whole paragraph in one Insert session → one `u` wipes the paragraph.
- Press `<Esc>` at the end of each sentence → each `u` peels off a sentence.

Neil's rule of thumb: make each undoable chunk correspond to a *thought*. Pause at a natural break, hit `<Esc>`, then press `A` to carry on where you left off. If a sentence goes wrong, `<Esc>` then `u` throws it away cleanly. This is why he'll sometimes press `<Esc>o` to open a new line instead of `<CR>` from Insert mode — the extra mode switch buys finer undo granularity.

General rule: **if you've paused long enough to wonder "should I leave Insert mode?", the answer is yes.**

## Example

```
iThe quick brown fox.<Esc>      ← chunk 1
oThe lazy dog sleeps.<Esc>      ← chunk 2
u                               ← removes "The lazy dog sleeps." only
u                               ← removes "The quick brown fox."
```

Had you typed both sentences in one Insert session, a single `u` would erase both at once.

## Gotchas

- **Cursor keys reset the change.** Using `<Up>`/`<Down>`/`<Left>`/`<Right>` *while in Insert mode* starts a new undo chunk — as if you'd popped to Normal mode and moved with `hjkl`, without actually leaving Insert. This also breaks what the **dot command** will replay (it only repeats keystrokes since the last such reset), so avoid arrow-key navigation mid-insert if you want a clean `.` repeat (see Tip 1's caveat, and Tip 9).
- Undo granularity is a matter of taste — but too-coarse chunks (long Insert sessions) make `u` blunt and `.` unwieldy.
- `U` (capital) is a different beast — "undo line" — not covered here.

## Related

- Tip 1 — Meet the Dot Command (same "one Insert trip = one change" rule)
- Tip 7 — Pause with Your Brush Off the Page (return to Normal mode habit)
- Tip 9 — Compose Repeatable Changes
