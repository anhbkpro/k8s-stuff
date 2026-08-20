# Tip 56 — Traverse the Change List

> Chapter 9 — Navigate Between Files with Jumps · *Practical Vim* (Drew Neil)

**One-liner:** Vim remembers where each edit happened — `g;` walks **back** through the change list, `g,` forward, and `gi` drops you back into Insert mode exactly where you last stopped.

**Practice file:** none — make a few edits in scattered places, scroll away, then `g;` `g;` to revisit them; try `gi`.

## Commands

| Command | Effect |
| --- | --- |
| `g;` | Go to the **previous** position in the change list |
| `g,` | Go to the **next** position in the change list |
| `gi` | Jump to the last insertion **and** re-enter Insert mode |
| `:changes` | Show the change list |
| `` `. `` | Mark: position of the **last change** |
| `` `^ `` | Mark: position of the **last insertion** |

## How it works

Vim keeps a **change list** per buffer — the line/column of every modification (`:h changelist`). Inspect it with `:changes`.

`g;` jumps back to the most recent change (same landing spot as the `u<C-r>` hack — undo then redo puts the cursor on the last edit — but **without** the transient change to the document). Keep pressing `g;` to walk further back through earlier edits; `g,` moves forward again.

Mnemonic: `;`/`,` repeat/reverse `f{char}` (Tip 49), so `g;`/`g,` "repeat/reverse" through the change list.

## Complementary marks

- `` `. `` — always the **last change** (`:h `.`). Similar to `g;`, but a mark points to *one* spot, whereas `g;` steps through *many*.
- `` `^ `` — the **last insertion** (where you last left Insert mode).
- **`gi`** is the star: it uses `` `^ `` to return to that exact spot *and* switches to Insert mode in one move — perfect for "I got distracted, put me back where I was typing." A real time-saver.

## Why it matters / when to reach for it

Editing is bursty — you make a change here, jump off to read something, and want to come back. `g;` retraces your edits without leaving the buffer; `gi` resumes typing where you stopped. Compared to the jump list (Tip 55), the change list follows your *edits* rather than your *navigation*.

## Gotchas

- **Change list is per buffer**; the jump list is per window (Tip 55) — different scopes.
- `` `. `` only ever points at the *latest* change; use `g;` when you need to step through several.
- `g;`/`g,` don't cross files — they're within the current buffer's edit history.
- `gi` re-enters Insert mode; handy but remember you're now inserting, not navigating.

## Related

- Tip 53 — Marks (`` `. ``, `` `^ `` automatic marks)
- Tip 55 — Traverse the Jump List (`<C-o>`/`<C-i>`)
- Tip 49 — Find by Character (`;`/`,` mnemonic)
