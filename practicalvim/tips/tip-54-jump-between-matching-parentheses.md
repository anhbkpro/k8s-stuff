# Tip 54 — Jump Between Matching Parentheses

> Chapter 8 — Navigate Inside Files with Motions · *Practical Vim* (Drew Neil)

**One-liner:** `%` jumps between matching `()`, `{}`, `[]` — and with the bundled **matchit** plugin it extends to XML tags and language keywords (`if`/`end`, `<a>`/`</a>`).

**Practice file:** [`../practice/tip-54-jump-between-matching-parentheses/parentheses.rb`](../practice/tip-54-jump-between-matching-parentheses/parentheses.rb) — turn `%w{London Berlin New\ York}` toward a `[...]` list, using `%` before editing. Reset with `u` or `:e!`.

## Commands

| Command | Effect |
| --- | --- |
| `%` | Jump to the matching bracket of the pair under/after the cursor |
| `` `` `` | Snap back to before the last jump (auto-mark, Tip 53) |
| `<C-o>` | Also returns to the previous jump-list spot (Tip 55) |

## How it works

`%` jumps between an opening bracket and its partner — works for `()`, `{}`, `[]` (`:h %`). Put the cursor on (or before) a bracket and `%` flies to its match; press again to come back.

```
console.log([{'a':1},{'b':2}])
%   from [ → matching ]
```

## The gotcha — jump *before* you edit

`%` only works on **well-formed** pairs. If you change one bracket first, the pair breaks and `%` can't find the partner.

Refactoring `%w{...}` toward `[...]` in `parentheses.rb`:

```
{start}  cities = %w{London Berlin New\ York}
dt{      cities = {London Berlin New\ York}    (drop the %w)
%        jump from { to the matching }
r]       cities = {London Berlin New\ York]    (change } → ])
``       snap back to where % jumped from (the { )
r[       cities = [London Berlin New\ York]    (change { → [)
```

The trick: `%` **before** changing a bracket. When you `%`, Vim auto-sets the `` `` `` mark at the departure point, so `` `` `` (or `<C-o>`) snaps back to fix the other bracket. (surround.vim makes this kind of edit even easier — below.)

## matchit — extend `%` to tags and keywords

Vim ships **matchit** (not on by default). Enabled, `%` also jumps between:

- HTML/XML opening ↔ closing tags (`<a>` ↔ `</a>`)
- language keyword pairs — Ruby `class`/`def`/`if` ↔ `end`, etc.

Enable in vimrc:

```vim
set nocompatible
filetype plugin on
runtime macros/matchit.vim
```

Highly recommended (`:h matchit-install`). *(Neovim enables matchit by default.)*

## surround.vim sidebar (Tim Pope)

Great companion for working with delimiters:

- `S"` (in Visual) — surround the selection with `"` (also `S)`, `S}`, …).
- `cs}]` — change surrounding `{}` to `[]`; `cs]}` goes back.
- `ds"` — delete surrounding quotes.

## Why it matters / when to reach for it

`%` is the fast way to check/close brackets and to leap across big blocks (function bodies, arrays). With matchit it becomes structural navigation for markup and code. Remember the "`%` first, then edit, `` `` `` back" pattern whenever you're swapping a pair of delimiters.

## Gotchas

- `%` needs a **balanced** pair — edit one side and it can't match; jump first.
- After `%`, `` `` `` / `<C-o>` returns to the start point (auto-mark / jump list).
- matchit and surround.vim aren't core `%` behavior — matchit ships with Vim (enable it), surround.vim is a separate plugin.

## Related

- Tip 53 — Marks (`` `` `` auto-mark)
- Tip 55 — Traverse the Jump List (`<C-o>`/`<C-i>`)
- Tip 51 — Text objects (`i)`, `i}` — often easier than `%`)
