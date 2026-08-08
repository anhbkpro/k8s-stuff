# Tip 15 — Paste from a Register Without Leaving Insert Mode

> Chapter 3 — Insert Mode · *Practical Vim* (Drew Neil)

**One-liner:** From Insert mode, `<C-r>{register}` pastes the contents of a register at the cursor — handy for dropping in a few yanked words without switching to Normal mode.

**Practice file:** [`../practice/tip-15-paste-from-register-in-insert-mode/practical-vim.txt`](../practice/tip-15-paste-from-register-in-insert-mode/practical-vim.txt) — yank "Practical Vim" from line 1 and append it to line 2. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `<C-r>{register}` | Insert | Paste the contents of `{register}` at the cursor |
| `<C-r>0` | Insert | Paste the **yank register** (last `y`) |
| `<C-r><C-p>{register}` | Insert | Paste literally, fixing unwanted auto-indentation |
| `yt,` | Normal | Yank up to (but not incl.) the next `,` into the unnamed + `0` register |
| `A` | Normal → Insert | Append at end of line |

## How it works

Yank and put normally happen in Normal mode, but sometimes you're mid-type and want to drop in some text you already yanked. From Insert mode, `<C-r>{register}` inserts that register's contents at the cursor (`:h i_CTRL-R`). The general form is `<C-r>` followed by the register's address.

The **yank register** is `0` — it always holds the text from your most recent `y` command (unlike the unnamed register, which also catches deletes). So `<C-r>0` reliably pastes "the thing I just yanked."

## Example

Starting `practical-vim.txt`:

```
Practical Vim, by Drew Neil
Read Drew Neil's
```

Goal: finish line 2 with the book's title.

```
yt,        yank "Practical Vim" (up to the comma) → register 0
jA␣        down a line, append at end, type a space
<C-r>0     paste "Practical Vim" → "Read Drew Neil's Practical Vim"
.<Esc>     add a period, leave Insert mode
```

Result:

```
Practical Vim, by Drew Neil
Read Drew Neil's Practical Vim.
```

## Why it matters / when to reach for it

`<C-r>0` is the sweet spot for inserting **a few words** you just yanked while you're already composing — no `<Esc>`, paste, resume-insert dance. Great for repeating an identifier, a filename, or a phrase into the line you're typing.

## Gotchas

- **Big or multi-line registers:** `<C-r>{reg}` inserts the text *as if typed one character at a time*. With `textwidth` or `autoindent` on, that can trigger unwanted line breaks or cascading indentation, and you may see a slight delay.
  - `<C-r><C-p>{register}` inserts literally and fixes indentation (`:h i_CTRL-R_CTRL-P`) — smarter but awkward to type.
  - For multiple lines, it's usually cleaner to return to Normal mode and use a put command (`p`/`P`, Tip 62).
- Register `0` = yank only; the unnamed register `"` also holds deletes, so `<C-r>0` is safer when you've deleted something since yanking.
- **Caps Lock warning (book sidebar):** with Caps Lock on, `j`/`k` become `J` (join lines) and `K` (man lookup) — easy to mangle a buffer. Many remap Caps Lock to `<Esc>` or `<Ctrl>` at the OS level (`<C-[>` = `<Esc>`).

## Related

- Tip 10 — Use Counts to Do Simple Arithmetic
- Tip 16 — Do Back-of-the-Envelope Calculations in Place (`<C-r>=`)
- Tip 49 — Find by Character (`t{char}`)
- Tip 60 — Grok Vim's Registers (what `0`, `"`, named registers mean)
- Tip 62 — Paste from a Register (Normal-mode put)
