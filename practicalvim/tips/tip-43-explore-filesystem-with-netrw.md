# Tip 43 — Explore the File System with netrw

> Chapter 7 — Open Files and Save Them to Disk · *Practical Vim* (Drew Neil)

**One-liner:** netrw (Vim's bundled file explorer) turns a window into a browsable directory listing — `:E` opens the active file's dir, `:e.` the working dir, and you navigate it with regular Vim motions.

**Practice files:** [`../practice/tip-43-explore-filesystem-with-netrw/mvc/`](../practice/tip-43-explore-filesystem-with-netrw/mvc/) — from that dir run `vim .` to open the explorer; navigate with `j`/`k`/`<CR>`/`-`, or `/html<CR>` to jump to `index.html`.

## Commands

| Ex | Shorthand | Effect |
| --- | --- | --- |
| `:edit .` | `:e.` | Open explorer for the **working** directory |
| `:Explore` | `:E` | Open explorer for the **active buffer's** directory |
| `:Sexplore` | | Explorer in a horizontal split |
| `:Vexplore` | | Explorer in a vertical split |

Inside netrw: `j`/`k` move, `<CR>` opens (dir → descend, file → edit), `-` goes to the parent, `<C-^>` returns to the buffer you came from.

## Setup

netrw ships with Vim but needs plugin loading enabled — minimum vimrc:

```vim
set nocompatible
filetype plugin on
```

## How it works

Launch Vim with a **directory** instead of a file (`vim .`) and it opens a file-explorer window — a normal Vim buffer that shows a directory's contents. So all your motions work: `j`/`k` to move, `<CR>` to open the item (descend into a directory, or load a file into the window), `-` (or `..` + `<CR>`) to go up. Want `index.html`? Just `/html<CR>` to search the listing.

Open the explorer on demand:

- `:e.` → explorer for the working directory (project root; `.` = cwd).
- `:E` (`:Explore`) → explorer for the **current file's** directory (like `:edit %:h`, but netrw-native).
- `:Sexplore` / `:Vexplore` → in a split.

## The "flip the card" model

Unlike editors with a persistent sidebar "project drawer," netrw **replaces the active window** with the explorer. Think of each window as a playing card: one face shows a file, the other shows the explorer. `:Explore` flips the active window to the explorer face; pick a file, `<CR>`, and it flips back to show that file — **in the same window**. `<C-^>` flips back to what you were editing.

Why this instead of a sidebar? With split windows, a sidebar makes "which window will this open in?" ambiguous. Replacing the active window removes all doubt — the file always opens where the explorer was.

## Beyond browsing

netrw can also **create** files (`:h netrw-%`) and directories (`:h netrw-d`), **rename** (`:h netrw-rename`), and **delete** (`:h netrw-del`). Its namesake feature: reading/writing files **over the network** (scp, ftp, curl, wget) — `:h netrw-ref`.

## Gotchas

- Needs `filetype plugin on` — netrw is a bundled *plugin*, not core.
- `:E`/`:e.` **replace** the current window (by design) — use `:Sexplore`/`:Vexplore` if you want a sidebar-like split.
- `<C-^>` (edit ⇄ alternate) is the quick way back out of the explorer.
- Many users prefer richer trees (nvim-tree, neo-tree, oil.nvim) — but netrw is zero-install and always available.

## Related

- Tip 41 — `:edit` and `%:h`
- Tip 42 — `:find` and `path`
- Tip 44 — Save Files to Nonexistent Directories
- Tip 36 — Buffer list / `<C-^>`
