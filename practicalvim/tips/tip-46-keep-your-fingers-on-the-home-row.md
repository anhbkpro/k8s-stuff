# Tip 46 — Keep Your Fingers on the Home Row

> Chapter 8 — Navigate Inside Files with Motions · *Practical Vim* (Drew Neil)

**One-liner:** Move the cursor with `h`/`j`/`k`/`l` instead of the arrow keys so your hands never leave the home row — but treat `h`/`l` as off-by-one nudges, not your main horizontal travel.

**Practice file:** none — practise everywhere; optionally disable the arrow keys (below) to build the habit.

## Commands

| Key | Move cursor |
| --- | --- |
| `h` | One column left |
| `l` | One column right |
| `j` | One line down |
| `k` | One line up |

## How it works

Touch typists rest their fingers on the home row (`asdf` / `jkl;`), from which any key is reachable without moving the hands. Vim's `h`/`j`/`k`/`l` let you move the cursor from exactly that position — no reaching for the arrow keys.

They're unintuitive at first (`j`/`k` sit side-by-side; `l` moves *right*, not left) — the assignment is historical, not logical. Memory aids: `j` looks a bit like a down-arrow; `h` and `l` sit on the left/right mirroring their directions. On Qwerty, `j`/`k`/`l` fall under your index/middle/ring fingers; you reach slightly for `h`.

The saving sounds trivial but compounds — once `hjkl` is habit, arrow-key editors feel clumsy.

## Don't overuse `h`/`l` — the real lesson

**Do not** shift your whole right hand left so every finger covers one of `hjkl`. And **don't hammer `h`/`l`** for horizontal travel: pressing `h` more than twice in a row is wasted keystrokes. Neil uses `h`/`l` only for *off-by-one* corrections when he narrowly misses a target. For real horizontal movement, use faster motions:

- word-wise motions (Tip 48: `w`, `b`, `e`)
- character search (Tip 49: `f`, `t`, `;`, `,`)

That's why it's fine that `h` is a slight stretch, while `;` (character-search repeat) sits comfortably under the little finger.

## Break the arrow-key habit

Temporarily disable the arrow keys in vimrc so reaching for them does nothing (a reminder to stay on the home row):

```vim
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>
```

Keep these only until the habit sticks — then consider remapping the arrows to something more useful.

## Why it matters / when to reach for it

`hjkl` is the foundation, but the chapter's real message is: **vertical** moves use `j`/`k` (often with counts or `gj`/`gk`, relative line numbers, etc.), while **horizontal** moves should graduate to word motions and character search rather than repeated `h`/`l`.

## Gotchas

- `j`/`k` move by **real** lines; on wrapped lines you may want `gj`/`gk` (display lines — Tip 47).
- Counts help: `5j` moves down five lines (see relativenumber for picking the count).
- Repeating `h`/`l` many times is a smell — reach for `w`/`b`/`f{char}` instead.

## Related

- Tip 47 — Distinguish Between Real Lines and Display Lines (`gj`/`gk`)
- Tip 48 — Move Word-Wise
- Tip 49 — Find by Character
