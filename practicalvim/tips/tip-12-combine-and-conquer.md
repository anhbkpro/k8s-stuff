# Tip 12 — Combine and Conquer

> Chapter 2 — Normal Mode · *Practical Vim* (Drew Neil)

**One-liner:** Vim's editing power is a grammar — **operator + motion = action** — so every new operator or motion you learn multiplies with all the ones you already know.

**Practice file:** none of its own — drill on any prose/code buffer. Try `daw`, `gUaw`, `dap`, `gUap`, `guu`, `>ip`.

## Commands

| Trigger | Effect |
| --- | --- |
| `c` | Change |
| `d` | Delete |
| `y` | Yank into register |
| `g~` | Swap case |
| `gu` | Make lowercase |
| `gU` | Make uppercase |
| `>` | Shift right (indent) |
| `<` | Shift left (dedent) |
| `=` | Autoindent |
| `!` | Filter `{motion}` lines through an external program |

*(Table 2 in the book. Full list: `:h operator`.)*

## How it works

Operators like `d`, `c`, `y` don't act alone — they take a **motion** that defines their reach:

- `dl` — delete one character
- `daw` — delete a word
- `dap` — delete a paragraph

The same motions work with every operator. That's the grammar's first rule: **an action = an operator followed by a motion.** Motions and operators are the vocabulary; the grammar lets you combine them freely.

The multiplier effect: say you know `daw` (delete a word). Learn the operator `gU` (uppercase) and you instantly get `gUaw` → SHOUT the word. Learn the motion `ap` (a paragraph) and you get `dap` (delete paragraph) *and* `gUap` (shout the whole paragraph) for free. Vocabulary grows linearly; expressible actions grow multiplicatively.

**Second rule — doubled operator acts on the current line:** `dd` deletes the line, `>>` indents it, `yy` yanks it. (`gU` is the special case: `gUgU` or shorthand `gUU`.)

Note `g~`/`gu`/`gU` are two-keystroke operators where `g` is a *prefix* namespace modifying the next key — not a separate mode.

## Example

```
gUaw   the current word → THE CURRENT WORD (well, one word)
gUap   uppercase the entire paragraph
guu    lowercase the current line
>ip    indent the inner paragraph
d2w    delete two words
```

## Extending the grammar with plugins

Because the grammar is open, custom operators and motions plug straight in:

- **Custom operators work with existing motions.** Tim Pope's *commentary.vim* adds a comment operator: `\\ap` toggles comments on a paragraph, `\\G` from here to end of file, `\\\\` the current line. (Create your own: `:h :map-operator`.)
- **Custom motions/text objects work with existing operators.** Kana Natsuno's *textobj-entire* adds `ie`/`ae` (the entire file), so `=ae` autoindents the whole file regardless of cursor position (vs. built-in `gg=G`). (Create your own: `:h omap-info`.)
- They compose with each other too: with both plugins, `\\ae` toggles comments across the entire file.

## Operator-Pending mode

Invoking an operator drops Vim into **Operator-Pending mode** — a fleeting state (the pause between `d` and `w` in `dw`) that accepts only a motion to complete the action. Press `<Esc>` here to abort. This is a real, distinct mode precisely so that custom operators and motions can hook into it and extend Vim's vocabulary. (Two-key *namespace* prefixes like `g`, `z`, `<C-w>`, `[` are **not** Operator-Pending — they're just extra command namespaces.)

## Gotchas

- `daw` vs `diw` and friends: the motion/text object decides scope; the operator decides the verb. Mix and match at will.
- Doubling rule only applies to *operators*. `ff` isn't "find on the line" — `f` isn't an operator.
- The `!` operator filters lines through a shell command (e.g. `!ipsort`), a bridge to Tip 35's shell integration.

## Related

- Tip 9 — Compose Repeatable Changes (`daw` and text objects)
- Tip 11 — Don't Count If You Can Repeat
- Tip 51 / 52 — Text objects in depth
- Tip 35 — Run Commands in the Shell (the `!` operator)
