# Tip 10 — Use Counts to Do Simple Arithmetic

> Chapter 2 — Normal Mode · *Practical Vim* (Drew Neil)

**One-liner:** `<C-a>` and `<C-x>` add/subtract from the number at or after the cursor, and prefixing a count sets the amount — so `180<C-x>` subtracts 180 without you ever typing the new value.

**Practice file:** [`../practice/tip-10-use-counts-to-do-simple-arithmetic/sprite.css`](../practice/tip-10-use-counts-to-do-simple-arithmetic/sprite.css) — duplicate the last line, change `blog`→`news`, and turn `0px`→`-180px`. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Does |
| --- | --- | --- |
| `<C-a>` | Normal | Add to the number at/after the cursor (default +1) |
| `<C-x>` | Normal | Subtract from the number at/after the cursor (default −1) |
| `{n}<C-a>` / `{n}<C-x>` | Normal | Add/subtract `n` (a count) |
| `yyp` | Normal | Duplicate the current line |
| `cW` | Normal → Insert | Change to next whitespace (used to swap the first word) |

## How it works

Most Normal-mode commands accept a **count**: a number typed before the command that runs it that many times (`:h count`). `<C-a>`/`<C-x>` exploit this to do arithmetic — count `n` means "add/subtract `n`."

The clever part: `<C-a>` operates on "the number **at or after** the cursor" (`:h ctrl-a`). If the cursor isn't already on a digit, Vim scans forward on the current line and jumps to the first one. So you don't have to position the cursor precisely — just be somewhere left of the number.

Example: cursor on a `5`, `10<C-a>` → `15`.

## Example

Starting `sprite.css`:

```
.blog, .news { background-image: url(/sprite.png); }
.blog { background-position: 0px 0px }
```

Goal: duplicate line 2, rename `.blog`→`.news`, and change the first `0px`→`-180px`.

```
yyp             duplicate the last line
cW.news<Esc>    first word becomes ".news"
180<C-x>        cursor isn't on a digit → jumps to the first 0, subtracts 180 → -180px
```

Result:

```
.blog, .news { background-image: url(/sprite.png); }
.blog { background-position: 0px 0px }
.news { background-position: -180px 0px }
```

Compare the manual alternative — `f0` to jump to the digit, then `i-18<Esc>` — which is more keystrokes and, crucially, *different text each time*. With `180<C-x>` the workflow is identical for every copy, so if you needed ten lines each 180 less than the last, you could record it as a macro (Ch. 11) and replay it.

## Why it matters / when to reach for it

Reach for `<C-a>`/`<C-x>` whenever you're nudging numbers — CSS offsets, list indices, version numbers, ports. Because the operation is a *repeatable* count command (not hand-typed text), it plays perfectly with `.` and with macros: the same keystrokes produce the correct new value on every line.

## Gotchas

- **Leading zeros = octal!** By default Vim treats `007` as octal, so `<C-a>` on it gives `010` (octal 8), not `008`. If you don't work in octal, add `set nrformats=` (empty) to your vimrc to force decimal regardless of padding. (Modern Vim/Neovim default `nrformats` no longer includes `octal`, but it's worth knowing.)
- `nrformats` also controls whether hex (`0x…`) and even alphabetic characters are incrementable.
- `<C-a>` looks ahead only on the **current line** — if there's no digit to the right, nothing happens.
- Cursor lands on the last digit of the changed number afterward, which is handy for a follow-up `.`.

## Related

- Tip 4 — Act, Repeat, Reverse
- Tip 8 — Chunk Your Undos (clean undo history)
- Tip 11 — Don't Count If You Can Repeat
- Chapter 11 — Macros (replay the arithmetic across many lines)
