# Tip 51 — Trace Your Selection with Precision Text Objects

> Chapter 8 — Navigate Inside Files with Motions · *Practical Vim* (Drew Neil)

**One-liner:** Text objects select regions by **structure** — `i{delim}` = inside, `a{delim}` = around — so `ci"`, `dit`, `ya)` operate on quotes/tags/brackets in a couple of keystrokes, regardless of cursor position within them.

**Practice file:** [`../practice/tip-51-precision-text-objects/template.js`](../practice/tip-51-precision-text-objects/template.js) — try `vi}`, `a"`, `it`, `at`, `a]`; then `ci"#<Esc>` and `citclick here<Esc>`. Reset with `u` or `:e!`.

## Delimited text objects (Table 12)

| Object | Selection |
| --- | --- |
| `a)` / `ab` · `i)` / `ib` | A pair of / inside `(parens)` |
| `a}` / `aB` · `i}` / `iB` | A pair of / inside `{braces}` |
| `a]` · `i]` | A pair of / inside `[brackets]` |
| `a>` · `i>` | A pair of / inside `<angle>` |
| `a'` · `i'` | A pair of / inside `'single quotes'` |
| `a"` · `i"` | A pair of / inside `"double quotes"` |
| `` a` `` · `` i` `` | A pair of / inside `` `backticks` `` |
| `at` · `it` | A pair of / inside `<xml>tags</xml>` |

`i(` = `i)`, `a[` = `a]`, etc. — use whichever bracket feels natural.

## How it works

Text objects define regions by the **structure** of well-formed patterns (`:h text-objects`). Every text object is two characters: first is `i` (**inside** the delimiters) or `a` (**around** — including them); second names the delimiter.

Unlike normal Visual mode (anchor one end, move the other), `vi}` selects *everything inside the nearest `{}`* — **cursor position within the braces doesn't matter**. Expand by invoking another object: `a"` grabs the double-quoted span, `i>` the angle-bracket contents, `it`/`at` the tag's inside/whole.

Note the `it` vs `at` difference (inside the tag's content vs including the `<a>…</a>` tags), and that `a]` can span multiple lines.

## The real power — Operator-Pending mode

Text objects **aren't motions** (they can't move the cursor on their own), but anywhere a command's syntax shows `{motion}` you can use one — `d{motion}`, `c{motion}`, `y{motion}`, etc.

```
{start}           '<a href="{url}">{title}</a>'
ci"#<Esc>         '<a href="#">{title}</a>'      change inside " → "#"
citclick here<Esc> '<a href="#">click here</a>'   change inside tag
```

Read them aloud: `ci"` = "change inside the double quotes," `cit` = "change inside the tag." Swap the operator freely: `dit` deletes tag contents, `yi)` yanks inside parens, `da}` deletes a whole brace block.

## Why it matters / when to reach for it

Three self-documenting keystrokes replace fiddly manual selection. Where `f{char}`/`/pattern` are precise single strikes, text objects are the "scissors kick" — they hit *both* delimiters at once and don't care where inside the region your cursor sits. `ci"`, `ci(`, `cit`, `di{` are among the most-used commands in daily Vim.

## Gotchas

- `i` = inside, `a` = around/all — `a` variants include the delimiters (and for brackets, both of them).
- A text object works from **anywhere inside** the region — no need to position on a delimiter first.
- They only apply in Visual or Operator-Pending mode (not standalone navigation).
- Nested delimiters: the object acts on the **innermost** pair enclosing the cursor; repeat/expand to reach outer ones.
- The next tip (52) covers the *bounded* objects — `iw`/`aw`, `is`/`as`, `ip`/`ap`.

## Related

- Tip 12 — Combine and Conquer (the operator + object grammar)
- Tip 52 — Delete Around, or Change Inside (word/sentence/paragraph objects)
- Tip 49 / 50 — Character search & search motions (single-strike moves)
- Tip 26 — why `i`/`a` differ from `I`/`A` in Visual-Block mode
