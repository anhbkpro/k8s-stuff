# Tip 57 — Jump to the Filename Under the Cursor

> Chapter 9 — Navigate Between Files with Jumps · *Practical Vim* (Drew Neil)

**One-liner:** `gf` ("go to file") treats the filename under the cursor as a hyperlink and opens it — configure `suffixesadd` (extensions) and `path` (directories) so Vim can resolve the reference.

**Practice files:** [`../practice/tip-57-jump-to-filename-under-cursor/`](../practice/tip-57-jump-to-filename-under-cursor/) — open `practical_vim.rb` (`vim -u NONE -N practical_vim.rb`), put the cursor in `'practical_vim/core'`, `:set suffixesadd+=.rb`, then `gf`.

## Commands

| Command | Effect |
| --- | --- |
| `gf` | Open the file named under the cursor (`:h gf`) |
| `<C-o>` | Jump back (gf adds to the jump list — Tip 55) |
| `:set suffixesadd+=.rb` | Extensions Vim appends when resolving `gf` |
| `:set path?` | Show directories `gf`/`:find` search |
| `<C-]>` | Jump to the **definition** of the keyword under the cursor (ctags, Tip 102) |

## How it works

Vim treats a filepath in your text like a link. Put the cursor on it and `gf` opens it. In `practical_vim.rb`:

```ruby
require 'practical_vim/core'
require 'practical_vim/more'
```

Cursor inside `'practical_vim/core'` (e.g. `fp` to get there), press `gf`:

```
E447: Can't find file "practical_vim/core" in path
```

The reference omits the `.rb` extension. Two options control resolution:

**`suffixesadd` — extensions.** Tell Vim which extensions to try appending:

```
:set suffixesadd+=.rb
```

Now `gf` finds `practical_vim/core.rb`. Each `gf` adds to the jump list, so `<C-o>` walks back (open `more.rb` via `gf`, follow another `require`, then `<C-o>` `<C-o>` back to the start).

**`path` — directories.** `gf` searches the comma-separated `path` (same option `:find` uses, Tip 42):

```
:set path?
path=.,/usr/include,,
```

Here `.` = the current file's directory, the empty entry (`,,`) = the working directory. For real projects, add your source/library dirs so `gf` can resolve references to third-party modules (e.g. rubygems). Tim Pope's *bundler.vim* auto-populates `path` from a Gemfile.

## Why it matters / when to reach for it

`gf` makes every path in a file a clickable link — hop from a `require`/`import`/`include` straight into the referenced file, read it, `<C-o>` back. Where the jump/change lists are breadcrumb trails, `gf` and `<C-]>` are **wormholes** that transport you across the codebase.

## Gotchas

- `E447` = "can't resolve" — usually a missing `suffixesadd` extension or a `path` that doesn't include the target dir.
- **File-type plugins usually set `suffixesadd`/`path` for you** — Vim ships Ruby/etc. ftplugins, so in practice you rarely configure these by hand (the demo used `-u NONE` to show the raw behavior).
- Both options are **buffer-local**, so they differ per file type.
- `<C-]>` (jump to definition) is the cousin of `gf` but needs a tags file (Tip 102).

## Related

- Tip 42 — `:find` and `path`
- Tip 55 — Traverse the Jump List (`<C-o>` after `gf`)
- Tip 58 — Snap Between Files Using Global Marks
- Tip 102/103 — ctags and `<C-]>`
