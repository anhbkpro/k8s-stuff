# Tip 14 — Get Back to Normal Mode

> Chapter 3 — Insert Mode · *Practical Vim* (Drew Neil)

**One-liner:** Leave Insert mode with `<Esc>` or the closer-reach `<C-[>`, and when you just need *one* Normal command mid-typing, use `<C-o>` (Insert Normal mode) to fire it and drop straight back into Insert.

**Practice file:** none — practise in any buffer: type a bit, then `<C-o>zz` to recenter without breaking flow.

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `<Esc>` | Insert → Normal | Switch to Normal mode |
| `<C-[>` | Insert → Normal | Switch to Normal mode (identical to `<Esc>`, shorter reach) |
| `<C-o>` | Insert → Insert Normal | Fire **one** Normal-mode command, then return to Insert |
| `zz` | Normal | Redraw screen with the current line centered |

## How it works

Insert mode does one job — entering text — while Normal mode is where you live, so switching between them fast matters.

The classic exit is `<Esc>`, but on many keyboards it's a long reach. `<C-[>` does *exactly* the same thing (`:h i_CTRL-[`) without leaving the home area — many Vim users train this as their reflex, or remap Caps Lock to Esc.

**Insert Normal mode (`<C-o>`)** solves a specific friction: you're typing and want to run *just one* Normal command, then keep going. Instead of `<Esc>`, command, `A`/`i` to resume, press `<C-o>` — Vim gives you "one bullet": a single Normal command executes and you're instantly back in Insert mode (`:h i_CTRL-O`).

## Example

You're typing near the top or bottom of the window and want more context. Recenter without breaking stride:

```
…typing…<C-o>zz…keep typing…
```

`<C-o>` → one Normal command → `zz` centers the current line → back in Insert mode, cursor exactly where you left it.

## Why it matters / when to reach for it

`<C-[>` reduces the physical cost of the most frequent transition in Vim. `<C-o>` reduces the *mental* cost of a one-off Normal command while composing — recenter (`zz`), delete to end of line (`D`), jump to line start (some prefer this over `<C-u>`), paste, etc. It keeps you from the `<Esc>` … resume-insert dance for a single action.

## Gotchas

- `<C-o>` grants **exactly one** command. After it runs (or after a motion completes an operator), you're back in Insert mode automatically — you can't chain two commands.
- A motion during `<C-o>` counts as the one command (e.g. `<C-o>0` jumps to column 0, then Insert resumes).
- `<C-[>` = `<Esc>` at the byte level on most terminals; if a plugin/mapping treats them differently, it's unusual. Prefer whichever your muscle memory likes.
- Don't confuse Insert Normal mode with Normal mode proper — it self-terminates back to Insert.

## Related

- Tip 7 — Pause with Your Brush Off the Page (return-to-Normal habit)
- Tip 8 — Chunk Your Undos (each Insert trip is one change)
- Tip 13 — Make Corrections Instantly from Insert Mode
