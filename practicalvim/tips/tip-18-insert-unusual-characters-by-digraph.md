# Tip 18 — Insert Unusual Characters by Digraph

> Chapter 3 — Insert Mode · *Practical Vim* (Drew Neil)

**One-liner:** Instead of memorizing numeric codes, insert unusual characters as **digraphs** — mnemonic two-character pairs — with `<C-k>{char1}{char2}` from Insert mode.

**Practice file:** none — try in any buffer: `<C-k>?I` → "¿", `<C-k>12` → "½", `<C-k>>>` → "»", `<C-k>e'` → "é".

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `<C-k>{c1}{c2}` | Insert | Insert the character represented by the `{c1}{c2}` digraph |
| `:digraphs` | Command | List available digraphs (dense output) |
| `:h digraph-table` | Command | A more readable digraph reference |

## How it works

Numeric codes (Tip 17) work but are hard to remember and fiddly to type. A **digraph** is a pair of characters chosen to *look like* or suggest the target glyph, so you can often guess it. From Insert mode, type `<C-k>` then the two characters.

The pairs follow descriptive conventions:

- `?I` → **¿** (inverted question mark)
- `<<` → **«** and `>>` → **»** (angle quotes)
- `12` → **½**, `14` → **¼**, `34` → **¾** (vulgar fractions)
- `e'` → **é**, `a:` → **ä**, `n~` → **ñ** (accents — letter + accent mark)
- `Co` → **©**, `->` → **→**, `13` → **⅓**

Conventions are summarized under `:h digraphs-default`. See the whole set with `:digraphs` (hard to read) or the nicer `:h digraph-table`.

## Example

Insert an inverted question mark while typing:

```
¿Cómo estás?
```

Type `<C-k>?I` to produce the leading **¿**, then continue normally (the **ó** is `<C-k>o'`).

## Why it matters / when to reach for it

Digraphs are the ergonomic way to enter accents, currency signs, arrows, math symbols, and typographic punctuation without leaving Insert mode or looking up code points. Because the pairs are mnemonic (letter + accent, or a visual resemblance), you can frequently *guess* them correctly on the first try.

## Gotchas

- The digraph is entered *after* `<C-k>`; the two characters themselves don't appear — only the resulting glyph does.
- Order can matter and some glyphs have a conventional pairing (e.g. accent digraphs are usually *letter then accent*: `e'` for é). If a guess fails, check `:h digraph-table`.
- Terminal + font must support the glyph to render it; otherwise you'll see a placeholder.
- Same end result as `<C-v>u{hex}` (Tip 17) — digraphs trade "know the code" for "know a mnemonic."

## Related

- Tip 17 — Insert Unusual Characters by Character Code (`<C-v>`, `ga`)
- Tip 19 — Overwrite Existing Text with Replace Mode
