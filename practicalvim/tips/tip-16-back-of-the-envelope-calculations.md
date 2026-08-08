# Tip 16 — Do Back-of-the-Envelope Calculations in Place

> Chapter 3 — Insert Mode · *Practical Vim* (Drew Neil)

**One-liner:** The expression register (`<C-r>=`) evaluates Vim script — use it from Insert mode as a calculator and drop the result straight into the document.

**Practice file:** [`../practice/tip-16-back-of-the-envelope-calculations/back-of-envelope.txt`](../practice/tip-16-back-of-the-envelope-calculations/back-of-envelope.txt) — finish the sentence by computing `6 * 35` in place. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `<C-r>=` | Insert | Open the expression-register prompt |
| `<C-r>={expr}<CR>` | Insert | Evaluate `{expr}` and insert the result at the cursor |
| `A` | Normal → Insert | Append at end of line |

## How it works

Most registers just *store* text (set by delete/yank, retrieved by put). The **expression register**, addressed by `=`, is different: it evaluates a snippet of Vim script and returns the result, which you can then insert as if it were plain register text.

From Insert mode, `<C-r>=` opens a prompt at the bottom of the screen. Type an expression, press `<CR>`, and Vim inserts the result where your cursor was. Pass it `1+1` and you get `2` — a calculator built into the editor, no leaving Insert mode.

## Example

Starting `back-of-envelope.txt`:

```
6 chairs, each costing $35, totals $
```

```
A                6 chairs, each costing $35, totals $   (append at end)
<C-r>=6*35<CR>   6 chairs, each costing $35, totals $210
```

Vim computes `6*35` and inserts `210` right after the `$`.

## Why it matters / when to reach for it

Any time you're typing and need a quick number — a subtotal, a pixel offset, a sum of a few values — you don't have to reach for a separate calculator or scribble on paper. `<C-r>=` keeps you in flow. And because it's the full expression register, it does far more than arithmetic: it can call Vim script functions, reference other registers, etc. (a more advanced use appears in Tip 70, numbering list items).

## Gotchas

- The expression evaluates **Vim script**, not your shell or Python — syntax like `6*35`, `sqrt(2)` (via `sqrt()`), `line('.')`, `@a` (contents of register a) all work; shell math does not.
- Reference other registers inside the expression: e.g. `<C-r>=@a * 2<CR>` doubles the number stored in register `a`.
- Result is inserted literally at the cursor — mind surrounding spacing/currency symbols (here we typed `$` first, then the number).
- Float vs int: `7/2` yields `3` (integer division) unless you write `7/2.0`.

## Related

- Tip 10 — Use Counts to Do Simple Arithmetic (`<C-a>`/`<C-x>`)
- Tip 15 — Paste from a Register Without Leaving Insert Mode (`<C-r>`)
- Tip 70 — Evaluate an Iterator to Number Items in a List (advanced expression register)
