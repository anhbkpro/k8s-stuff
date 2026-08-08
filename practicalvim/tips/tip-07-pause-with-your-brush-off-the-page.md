# Tip 7 — Pause with Your Brush Off the Page

> Chapter 2 — Normal Mode · *Practical Vim* (Drew Neil)

**One-liner:** Normal mode is Vim's natural *resting* state, not Insert mode — like a painter who spends most of their time with the brush off the canvas.

**Practice file:** none — this tip is a mindset, not a drill. The rest of Chapter 2 is where the keys come in.

## The core idea

Ask how much time a painter actually spends with brush touching canvas — probably less than half. The rest goes to studying the subject, adjusting the light, mixing colors, and choosing tools (a palette knife, a cotton swab) instead of the brush.

Programming is the same. We spend only a fraction of our time *typing new code*. Far more goes to thinking, reading, and navigating. So the editor's default state shouldn't be "inserting text." In Vim, the resting state is **Normal mode** — the clue is in the name.

And when you *do* want to change something, you don't have to drop into Insert mode. From Normal mode you can reformat, duplicate, move, or delete existing code. Insert mode is just one tool among many; you pick up the brush only when you actually need to lay down new paint.

## Why it matters / when to reach for it

This reframes the instinct newcomers bring from other editors ("I'm always in a typing mode"). The habit to build: **return to Normal mode the moment you finish a burst of typing.** Don't camp in Insert mode with the brush resting on the canvas. Sitting in Normal mode keeps every navigation and editing command one keystroke away — and, per the Dot Formula, keeps your last change repeatable with `.`.

Practically: hit `<Esc>` (or `<C-[>`) as soon as a thought is typed, then think/read/navigate from Normal mode.

## Gotchas

- This is the philosophy behind why later tips insist on short, deliberate Insert-mode bursts: everything typed between `i` and `<Esc>` is one change (one undo, one dot-repeat), so long stays in Insert mode make for clumsy undo/repeat granularity (see Tip 8).
- No keystrokes to memorize here — the payoff is the habit, not a command.

## Related

- Tip 6 — Meet the Dot Formula (why staying in Normal mode pays off)
- Tip 8 — Chunk Your Undos (consequence of Insert-mode bursts)
- Tip 14 — Get Back to Normal Mode (how to leave Insert mode efficiently)
