# Tip 48 — Move Word-Wise

> Chapter 8 — Navigate Inside Files with Motions · *Practical Vim* (Drew Neil)

**One-liner:** Move a word at a time with `w`/`b`/`e`/`ge`, and use the uppercase `W`/`B`/`E`/`gE` for bigger **WORDS** (whitespace-delimited) when you want to cover ground faster.

**Practice file:** none — try on a line like `e.g. we're going too slow`: count `w` presses vs `W` presses.

## Commands

| Command | Move cursor |
| --- | --- |
| `w` / `W` | Forward to start of next word / WORD |
| `b` / `B` | Backward to start of current/previous word / WORD |
| `e` / `E` | Forward to end of current/next word / WORD |
| `ge` / `gE` | Backward to end of previous word / WORD |

Pairs: `w`/`b` target a word **start**; `e`/`ge` target a word **end**. `w`/`e` go **forward**, `b`/`ge` go **backward**.

## How it works

Word motions traverse far faster than `h`/`l` a column at a time. Start with just **`w`** (for-**word**) and **`b`** (**back**-word); add `e`/`ge` later. `e` is handy for jumping to the end of the current word — e.g. append to it:

```
{start}    Go fast.
ea er<Esc> Go faster.
```

`ea` = "append at the end of the current word" (feels like one command with practice); `gea` = "append at end of previous word."

## word vs WORD

Vim has two definitions:

- **word** — letters/digits/underscores, *or* a run of other non-blank punctuation, separated by whitespace (`:h word`). Punctuation like `.` and `'` counts as its own word.
- **WORD** — simply a run of non-blank characters separated by whitespace (`:h WORD`). **WORDS are bigger than words.**

Count the "words" in `e.g. we're going too slow`: **10 words** but only **5 WORDS** (the `.` and `'` split words but not WORDS).

```
e.g. we're going too slow
wwww…   many w presses to cross e.g. and we're
W W …   two W presses cover the same ground
```

## Choosing word vs WORD

Pick by the granularity you need:

- Treat `we` as a word → `cwyou<Esc>` turns `we're` into `you're`.
- Treat `we're` as a WORD → `cWit's<Esc>` turns `we're` into `it's`.

**WORD-wise = move faster; word-wise = finer control.** Don't overthink the definitions — play with both and intuition follows.

## Why it matters / when to reach for it

Word motions are your primary *horizontal* travel (Tip 46 said not to spam `h`/`l`). Combined with operators they're everyday tools: `dw`, `cw`, `de`, `cW`, `daw`. Reach for the uppercase WORD variants when punctuation would otherwise make `w`/`b` crawl.

## Gotchas

- `cw` behaves like `ce` (changes to end of word, not including trailing space) — a deliberate special case.
- Punctuation is its own **word** but not its own **WORD** — that's the whole distinction.
- `ge`/`gE` (backward-to-end) are the least-used of the set; fine to skip until you feel the need.
- With a count: `3w` jumps three words; `d3w` deletes three.

## Related

- Tip 46 — Keep Your Fingers on the Home Row (why not to spam `h`/`l`)
- Tip 49 — Find by Character (`f`/`t`)
- Tip 33 — Insert current word/WORD (`<C-r><C-w>` / `<C-r><C-a>`)
- Tip 12 — Combine and Conquer (word motions with operators)
