# Tip 52 — Delete Around, or Change Inside

> Chapter 8 — Navigate Inside Files with Motions · *Practical Vim* (Drew Neil)

**One-liner:** Bounded text objects come in `i`/`a` pairs (`iw`/`aw`, `is`/`as`, `ip`/`ap`) — as a rule, **`daw` deletes cleanly** (word + a space) while **`ciw` changes cleanly** (word without touching the spaces).

**Practice file:** none — try on `Improve your writing by deleting excellent adjectives.`: compare `daw` vs `diw`, and `ciw` vs `caw`.

## Bounded text objects (Table 13)

| Object | Selection |
| --- | --- |
| `iw` | Current word |
| `aw` | Current word **plus one space** |
| `iW` | Current WORD |
| `aW` | Current WORD plus one space |
| `is` | Current sentence |
| `as` | Current sentence plus one space |
| `ip` | Current paragraph |
| `ap` | Current paragraph plus one blank line |

## How it works

Text objects split into two families: **delimited** ones bounded by matching symbols (`i)`, `i"`, `it` — Tip 51) and **bounded** ones defined by boundaries (words, sentences, paragraphs — above).

Compare `iw` and `aw`:

- `iw` = "inside word" — the word's characters only.
- `aw` = "around word" — the word **plus one adjacent whitespace** (after, or before if there's none after).

That one-space difference decides which to pick, and it splits cleanly by operator:

**Deleting → use `aw`** (removes the trailing space too, no double space left):

```
{start}   Improve your writing by deleting excellent adjectives.
daw       Improve your writing by deleting adjectives.
```

(`diw` here would leave two spaces where "excellent" was.)

**Changing → use `iw`** (keeps surrounding spaces, since you're typing a replacement):

```
{start}       Improve your writing by deleting excellent adjectives.
ciwmost<Esc>  Improve your writing by deleting most adjectives.
```

(`caw` would eat the space and give "mostadjectives".)

## The rule of thumb

> **`d{motion}` pairs with `aw`/`as`/`ap`; `c{motion}` pairs with `iw`/`is`/`ip`.**

Delete-around keeps spacing tidy by removing a separator; change-inside preserves spacing because your new text supplies its own boundaries.

## Why it matters / when to reach for it

`daw`/`ciw` and their sentence/paragraph cousins (`das`, `cip`, `dap`) are everyday edits. Internalizing the "delete around / change inside" pairing means you rarely have to clean up stray or missing whitespace afterward.

## Gotchas

- `aw` grabs a space on **one** side (prefers trailing) — not both.
- Word vs WORD applies: `iW`/`aW` treat punctuation-joined tokens as one (Tip 48).
- Sentence objects (`is`/`as`) depend on Vim's sentence detection (periods + spacing); paragraph objects (`ip`/`ap`) split on blank lines.
- These work in Visual and Operator-Pending mode — not as standalone navigation (text objects aren't motions).

## Related

- Tip 51 — Precision (delimited) Text Objects (`i)`, `i"`, `it`)
- Tip 48 — Move Word-Wise (word vs WORD)
- Tip 9 — Compose Repeatable Changes (`daw` and the dot command)
- Tip 12 — Combine and Conquer (operator + object)
