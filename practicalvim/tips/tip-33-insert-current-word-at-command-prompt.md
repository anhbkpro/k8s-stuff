# Tip 33 — Insert the Current Word at the Command Prompt

> Chapter 5 — Command-Line Mode · *Practical Vim* (Drew Neil)

**One-liner:** `<C-r><C-w>` copies the word under the cursor into the command line — pair it with `*` and `:%s//.../g` to rename a variable with almost no typing.

**Practice file:** [`../practice/tip-33-insert-current-word-at-command-prompt/loop.js`](../practice/tip-33-insert-current-word-at-command-prompt/loop.js) — rename `tally` to `counter` everywhere. Reset with `u` or `:e!`.

## Commands

| Keys | Effect |
| --- | --- |
| `<C-r><C-w>` | Insert the **word** under the cursor at the command prompt |
| `<C-r><C-a>` | Insert the **WORD** under the cursor (whitespace-delimited; Tip 48) |
| `*` | Search for the word under the cursor (`= /\<<C-r><C-w>\><CR>`) |
| `cw` | Change word (make the first edit) |

## How it works

Vim tracks the cursor even in Command-Line mode, so it can hand you the word under it. `<C-r><C-w>` inserts that word at the `:` (or `/`) prompt — two keystrokes instead of retyping. `<C-r><C-a>` grabs the bigger WORD (delimited only by whitespace).

Neat detail: the `*` command *is* `<C-r><C-w>` under the hood — it's shorthand for `/\<<C-r><C-w>\><CR>` (search the exact word under the cursor, with `\<`/`\>` word boundaries; Tip 76).

## Example — rename `tally` → `counter`

Starting `loop.js`:

```
var tally;
for (tally=1; tally <= 10; tally++) {
  // do something with tally
};
```

```
{cursor on "tally"}
*                    search for "tally" (cursor stays on a "tally")
cwcounter<Esc>       change this first one to "counter"
:%s//<C-r><C-w>/g    substitute: empty pattern reuses last search ("tally"),
                     replacement = word under cursor ("counter")
```

Two things you *didn't* type: the search pattern (thanks to `*`, and the empty pattern in `:%s//` reuses the last search — Tip 90) and the replacement word (thanks to `<C-r><C-w>`).

## Why it matters / when to reach for it

Any time an identifier under the cursor needs to appear in an Ex command — a `:substitute` replacement, a `:grep` term, a `:help` lookup — `<C-r><C-w>` saves retyping and typos. It works with **any** Ex command, not just `:s`.

Handy trick: open your vimrc, put the cursor on an option name, and type `:help<C-r><C-w>` to jump straight to that option's docs.

## Gotchas

- `<C-r><C-w>` = word (stops at punctuation); `<C-r><C-a>` = WORD (whitespace-only boundaries). Pick based on whether the token contains punctuation.
- `:%s//replacement/` with an **empty** pattern reuses the last search pattern (Tip 90) — that's why `*` first, then `:%s//…` works.
- The inserted text is a *copy* taken at insert time; moving the cursor afterward doesn't change it.

## Wildmode sidebar (from Tip 32)

Tune tab-completion behavior via `wildmode`/`wildmenu`:

- Bash-like: `set wildmode=longest,list`
- zsh-like navigable menu: `set wildmenu` + `set wildmode=full` — then scroll with `<Tab>`/`<C-n>`/`<Right>` and back with `<S-Tab>`/`<C-p>`/`<Left>`.

## Related

- Tip 32 — Tab-Complete Your Ex Commands
- Tip 48 — Move Word-Wise (word vs WORD)
- Tip 76 — Word boundaries (`\<`, `\>`)
- Tip 90 — Reuse the Last Search Pattern (empty `:%s//`)
