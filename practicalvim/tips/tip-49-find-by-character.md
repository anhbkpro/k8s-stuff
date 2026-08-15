# Tip 49 — Find by Character

> Chapter 8 — Navigate Inside Files with Motions · *Practical Vim* (Drew Neil)

**One-liner:** `f{char}` jumps to the next occurrence of a character on the line (`t{char}` stops just before it); repeat with `;`, reverse with `,` — and pick rare target characters to hit in one move.

**Practice file:** none — practise on any prose line; e.g. `I've been expecting you, Mister Bond.` with `f,dt.`

## Commands

| Command | Effect |
| --- | --- |
| `f{char}` | Forward to the next `{char}` |
| `F{char}` | Backward to the previous `{char}` |
| `t{char}` | Forward to just **before** the next `{char}` (till) |
| `T{char}` | Backward to just **after** the previous `{char}` |
| `;` | Repeat the last character search (same direction) |
| `,` | Reverse the last character search |

## How it works

`f{char}` is one of Vim's fastest moves: from the cursor it scans to the end of the **current line** for `{char}` and lands on the first match (stays put if none, `:h f`). `fo` jumps to the next `o`.

When the target repeats, you don't retype `f{char}` — Vim remembers it:

- `;` repeats the search forward (`fc` then `;;;` steps through each `c`).
- `,` repeats it **backward** — the safety net when `;` overshoots (*act, repeat, reverse*, Tip 4).

## `f`/`F` vs `t`/`T` — on vs till

`f`/`F` land **on** the character; `t`/`T` stop one character **before/after** it ("till"). Why both? Consider deleting to the end of a sentence but keeping the period:

```
{start}   I've been expecting you, Mister Bond.
f,        jump onto the comma
dt.       delete till the period  → "I've been expecting you."
```

`dt.` (delete till `.`) leaves the period; `df.` would delete it too. Neil's habit: **`f`/`F` in Normal mode** to move, **`t`/`T` in Operator-Pending mode** (`dt.`, `ct)`), because "delete up to but not including X" is a common shape. `f,dt.` becomes a finger macro.

## Think like a Scrabble player — pick rare targets

Character search is only as efficient as your target choice. Common letters need many `;` presses; rare ones hit in one move.

```
Improve your writing by deleting excellent adjectives.
```

To reach "excellent": `fe` then `;;;` (many e's to skip) — vs `fx` (only one `x`, one move), then `daw` to delete the word. Capitals and punctuation are rarer than lowercase — aim for those.

## Gotchas

- **Line-scoped and single-character** only — for multi-char or cross-line targets use search `/` (Tip 50).
- `;`/`,` are a *pair* — if you remap the leader to `,`, remap the reverse search elsewhere (e.g. `noremap \ ,`) or you cripple the whole family.
- `;` repeats in the *original* direction (even after `F`/`T`); `,` is the opposite.
- Cursor must be before the target on the line; if `{char}` isn't found, nothing moves.

## Related

- Tip 4 — Act, Repeat, Reverse (`;` / `,`)
- Tip 48 — Move Word-Wise
- Tip 50 — Search to Navigate (`/`)
- Tip 52 — Delete Around / Change Inside (`daw`)
- Tip 12 — Operator-Pending mode (`dt.`, `ct)`)
