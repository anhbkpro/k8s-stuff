# Tip 20 — Grok Visual Mode

> Chapter 4 — Visual Mode · *Practical Vim* (Drew Neil)

**One-liner:** Visual mode is *another mode* — you select first, then act — so to replace a selected word you press `c` (change), not a printable key; typing a letter runs that letter's command.

**Practice file:** none — try on any word: put the cursor on it, `viw` to select, then `c` and retype.

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `v` | Normal → Visual | Start character-wise Visual mode |
| `viw` | Normal → Visual | Select the inner word |
| `c` | Visual → Insert | Change (delete) the selection and enter Insert mode |
| `hjkl` / `f{char}` / `;` `,` / `/` `n` | Visual | Move the cursor = extend the selection |
| `<C-g>` | Visual ↔ Select | Toggle between Visual and Select mode |

## How it works

Visual mode lets you select a range and then operate on it — familiar from every editor. But Vim's twist: it's a **mode**, so every key does its Normal-mode job, not "replace the selection."

In a web textarea, selecting "March" and typing `A` replaces it and you keep typing "pril" → "April". In Vim's Visual mode, with "March" selected, typing `A` triggers the **append** command (`A`), inserting "pril" in the wrong place. Instead you press `c` to **change** the selection: it deletes the word and drops you into Insert mode, where you type "April".

Two things to internalize:

1. **Motions still work and they resize the selection.** `hjkl`, `f{char}` + `;`/`,`, and `/pattern` + `n`/`N` all move the cursor, and in Visual mode moving the cursor changes the selection bounds.
2. **Operators invert vs. Normal mode.** In Normal mode you give the operator first, then a motion (`c` + `iw` = `ciw`). In Visual mode you make the selection first, then the operator (`viw` then `c`). Same result, reversed order — and for many people the Visual order feels more intuitive.

## Example

Change "March" → "April":

```
{cursor on March}
viw        select the word ("March")
cApril<Esc>  change it → type "April"
```

Note: you can't type "April" directly on the selection — the `A` would run the append command.

## Why it matters / when to reach for it

Visual mode shines when you want to *see* the range before acting, or when the selection is easier to build interactively (extend with motions) than to express as a single motion. But because it's modal, retrain the reflex: **select, then use an operator (`c`, `d`, `y`, `gU`, `>`…)** — don't expect a printable key to replace the selection.

## Gotchas

- Typing a letter in Visual mode runs that letter's command; use `c` (or `s`) to replace.
- **Select mode** (the sidebar) *does* behave like other editors — a printable character deletes the selection and inserts the char. Toggle with `<C-g>`; the status line shows `--SELECT--` vs `--VISUAL--`. Most Vim users have little use for it except snippet-plugin placeholders (it resembles Windows/TextMate selection).
- If you embrace Vim's modal nature, prefer `c` from Visual mode over Select mode.

## Related

- Tip 12 — Combine and Conquer (operator + motion; the inversion)
- Tip 21 — Define a Visual Selection (the three submodes)
- Tip 23 — Prefer Operators to Visual Commands Where Possible
