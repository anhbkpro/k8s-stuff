# Tip 41 — Open a File by Its Filepath Using ':edit'

> Chapter 7 — Open Files and Save Them to Disk · *Practical Vim* (Drew Neil)

**One-liner:** `:edit {path}` opens a file relative to the working directory (`:pwd`); to open a file *next to the current one*, use `:edit %:h<Tab>` where `%` is the active file and `:h` strips the filename.

**Practice files:** [`../practice/tip-41-open-file-by-filepath/mvc/`](../practice/tip-41-open-file-by-filepath/mvc/) — from that dir launch `vim index.html`, then `:edit lib/framework.js`, `:edit %:h<Tab>`. Explore the `app/controllers` / `app/views` tree.

## Commands

| Command | Effect |
| --- | --- |
| `:pwd` | Print Vim's working directory |
| `:edit {relpath}` | Open a file relative to the working directory |
| `:edit %` | `%` = full path of the active buffer |
| `:edit %:h` | `:h` modifier = active file's **directory** (filename removed) |
| `<Tab>` | Autocomplete the path as you type |

## How it works

Like a shell, Vim has a **working directory** — it inherits the shell's cwd at launch; check with `:pwd`.

**Relative to cwd:** `:edit {file}` takes a path relative to that directory:

```
:edit lib/framework.js
:edit app/controllers/Navigation.js
```

Tab-completion (Tip 32) makes this fast: `:edit a<Tab>c<Tab>N<Tab>` walks `app/` → `controllers/` → `Navigation.js`.

**Relative to the active file:** editing `app/controllers/Navigation.js` and want `Main.js` in the *same* folder? Drilling from cwd is wasteful. Use the active buffer as the reference:

- `%` = full path of the active buffer (`:h cmdline-special`).
- `%:h` = that path with the **filename stripped** (the `:h` "head" modifier, `:h ::h`), i.e. the current file's directory.

So:

```
:edit %:h<Tab>       expands to  :edit app/controllers/
:edit %:h<Tab>M<Tab> → app/controllers/Main.js
```

## The `%%` mapping (handy shortcut)

`%:h<Tab>` is common enough to map. Add to vimrc:

```vim
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
```

Now typing `%%` at the `:` prompt expands to the active file's directory — works with `:edit`, `:write`, `:saveas`, `:read`, etc.

## Example

```
:pwd                     /…/files/mvc
:edit lib/theme.css      open relative to cwd
:edit %:h<Tab>           expand to current file's dir
%%                       (with the mapping) same thing, fewer keys
```

## Why it matters / when to reach for it

`:edit` is the fundamental "open a file" command. The `%`/`%:h` filename modifiers turn "open the file next to this one" from a full-path chore into a couple of keystrokes — invaluable in deep project trees. For opening by *name* without any path, see `:find` (Tip 42).

## Gotchas

- `:edit` opens relative to `:pwd`, **not** the active file — that's exactly why `%:h` exists for same-directory opens.
- `%` alone expands to the file *including* its name; add `:h` to get just the directory.
- Filename modifiers chain: `%:t` (tail/filename), `%:r` (root/no extension), `%:e` (extension), `%:p` (absolute) — `:h filename-modifiers`.
- `:edit!` (with bang) reloads/reverts the current buffer — different use (Tip 38).

## Related

- Tip 32 — Tab-Complete Your Ex Commands
- Tip 42 — Open a File by Its Filename Using `:find`
- Tip 43 — Explore the File System with netrw
- Tip 35 — Run Commands in the Shell (`%` on the command line)
