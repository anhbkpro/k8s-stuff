# Tip 42 — Open a File by Its Filename Using ':find'

> Chapter 7 — Open Files and Save Them to Disk · *Practical Vim* (Drew Neil)

**One-liner:** Configure the `path` option (e.g. `set path+=**`) and then `:find {filename}` opens a file by name alone — no full path, tab-completion cycles duplicates.

**Practice files:** [`../practice/tip-42-open-file-by-filename/mvc/`](../practice/tip-42-open-file-by-filename/mvc/) — from that dir, `:set path+=app/**` then `:find Main.js<Tab>`. Note there are two `Main.js` files.

## Commands

| Command | Effect |
| --- | --- |
| `:set path+=app/**` | Add `app/` and all subdirs to the search path |
| `:set path+=**` | Add the whole tree under cwd to the path |
| `:find {filename}` | Open a file by name, searching `path` |
| `<Tab>` | Complete / cycle through matching filepaths |

## How it works

`:edit` needs a path; in deep project trees that gets tedious. `:find` opens a file by **name only** — but it has to know *where* to look. Out of the box it doesn't:

```
:find Main.js
E345: Can't find file "Main.js" in path
```

The **`path` option** (`:h 'path'`) lists directories `:find` searches. Add your source dirs:

```
:set path+=app/**
```

The `**` wildcard matches all subdirectories beneath `app/`. (Note: in `path`, `*`/`**` are handled by **Vim**, not the shell, and behave a bit differently — `:h file-searching`.) A common blanket setting is `:set path+=**` to make the whole project searchable.

Now `:find` works:

```
:find Navigation.js       opens app/controllers/Navigation.js
:find nav<Tab>            tab-completes it
```

**Duplicate names:** with two `Main.js` (in `app/controllers` and `app/views`), `:find Main.js<Tab>` expands the first match (`./app/controllers/Main.js`); `<Tab>` again cycles to `./app/views/Main.js`. `<CR>` opens the expanded path, or the first match if you didn't tab. (Behavior varies with `wildmode`, Tip 32.)

## Why it matters / when to reach for it

Once `path` is set, `:find` is fuzzy-ish "open by name" without a fuzzy finder — great for projects with conventional layouts. Framework plugins automate it: Tim Pope's **rails.vim** auto-configures `path` for Rails conventions and adds `:Rcontroller`/`:Rmodel`/`:Rview` (scoped `:find` variants).

## Gotchas

- **`:find` does nothing useful until `path` includes your dirs** — the `E345` error means "not in path," not "file doesn't exist."
- `**` in `path` can be slow on huge trees; scope it (`app/**`, `src/**`) if needed.
- Duplicate filenames require tabbing to the right match.
- Modern workflows often prefer a fuzzy finder (fzf/Telescope) over `:find`, but `path`/`:find` are built-in and zero-dependency.

## Related

- Tip 41 — Open a File by Its Filepath Using `:edit`
- Tip 43 — Explore the File System with netrw
- Tip 32 — Tab-Complete Your Ex Commands (`wildmode`)
- Tip 37 — Argument List (`**` wildcard)
