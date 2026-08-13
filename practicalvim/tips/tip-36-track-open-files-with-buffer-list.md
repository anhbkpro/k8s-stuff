# Tip 36 — Track Open Files with the Buffer List

> Chapter 6 — Manage Multiple Files · *Practical Vim* (Drew Neil)

**One-liner:** You edit **buffers** (in-memory), not files (on disk); `:ls` lists loaded buffers, `:bnext`/`:bprev`/`:bfirst`/`:blast` traverse them, and `<C-^>` toggles the two most recent.

**Practice files:** [`../practice/tip-36-track-open-files-with-buffer-list/`](../practice/tip-36-track-open-files-with-buffer-list/) — open both with `vim a.txt b.txt` (or `:args a.txt b.txt`), then try `:ls`, `:bnext`, `<C-^>`.

## Commands

| Command | Effect |
| --- | --- |
| `:ls` (`:buffers`) | List loaded buffers |
| `:bnext` / `:bprev` | Next / previous buffer |
| `:bfirst` / `:blast` | First / last buffer |
| `:buffer N` / `:buffer {name}` | Jump to buffer by number or name-fragment |
| `<C-^>` | Toggle current ⇄ alternate (`#`) buffer |
| `:bufdo {cmd}` | Run an Ex command in every listed buffer |
| `:bdelete N1 N2…` / `:N,M bdelete` | Remove buffers from memory (file untouched) |

## Files vs buffers

Key distinction: a **file** lives on disk; a **buffer** is Vim's in-memory copy. Opening a file *reads* it into a like-named buffer; edits diverge the buffer from the file until you *write* it back. Most commands act on buffers — only a few (`:write`, `:update`, `:saveas`) touch files.

## The buffer list

Open several files (`vim *.txt`) and Vim loads each into a buffer, showing the first. `:ls` reveals them all:

```
:ls
  1 %a   "a.txt"   line 1
  2      "b.txt"   line 0
```

- `%` = buffer in the current window; `#` = the **alternate** buffer.
- `<C-^>` toggles between `%` and `#` — fast two-file switching.
- Each buffer gets an auto-assigned number; jump with `:buffer N`, or `:buffer {name}` where the name fragment just needs to be unique (tab-complete if not).

Traverse with `:bnext`/`:bprev`/`:bfirst`/`:blast`. Since typing `:bn`/`:bp` is tedious, Tim Pope's **unimpaired.vim** maps `]b`/`[b` (next/prev) and `]B`/`[B` (last/first) — consistent with Vim's `[`/`]` prefix family (also `]a`/`]q`/`]l`/`]t` for arg/quickfix/location/tag lists).

## Deleting buffers

`:bdelete` removes a buffer from memory (the **file is unaffected**). Two forms: `:bdelete 5 6 7` (by number) or `:5,10bd` (range). But numbers are auto-assigned and can't be renumbered, so deleting specific buffers means looking up numbers first — often not worth it. In practice Neil rarely bothers, letting `:ls` accumulate as the session's list of opened files.

## Why it matters / when to reach for it

The buffer list is your session's working set. `<C-^>` alone is a huge win for bouncing between two files (e.g. a source and its test). But Vim's built-in buffer management is deliberately thin — **don't try to organize your workflow by curating the buffer list.** For structure, use split windows (Tip 39), tab pages (Tip 40), or the argument list (Tip 37).

## Gotchas

- `:!ls` (shell) ≠ `:ls` (buffer list) — see Tip 35.
- Buffer numbers are assigned by Vim and immutable; you can't reorder them.
- `:bufdo` works but `:argdo` (Tip 37) is usually more practical for batch edits.
- A buffer with unsaved changes may block navigation unless the file is written or `hidden` is set (Tip 38).

## Related

- Tip 37 — Group Buffers into a Collection with the Argument List (`:args`, `:argdo`)
- Tip 38 — Manage Hidden Files
- Tip 39 / 40 — Split windows / tab pages
- Tip 31 — Repeat the Last Ex Command (`:bnext` + `@:`)
