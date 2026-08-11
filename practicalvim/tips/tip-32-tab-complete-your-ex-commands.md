# Tip 32 — Tab-Complete Your Ex Commands

> Chapter 5 — Command-Line Mode · *Practical Vim* (Drew Neil)

**One-liner:** At the `:` prompt, `<Tab>` autocompletes commands and arguments context-sensitively, and `<C-d>` lists all matching completions.

**Practice file:** none — try live: `:col<C-d>`, `:colo<Tab>`, `:e <Tab>`.

## Commands

| Keys | Effect |
| --- | --- |
| `<Tab>` | Complete / cycle forward through suggestions |
| `<S-Tab>` | Cycle backward through suggestions |
| `<C-d>` | List all possible completions (`:h c_CTRL-D`) |

## How it works

Just like the shell, Vim autocompletes at the command line — but it's **context-aware**, building suggestions from what you've typed so far.

- **Command names:** `:col<C-d>` reveals `colder` and `colorscheme`. Pressing `<Tab>` cycles `colder` → `colorscheme` → back to `col`; `<S-Tab>` goes the other way.
- **Command arguments:** completion adapts to the command:
  - `:colorscheme <C-d>` lists every installed theme; type `so<Tab>` → `solarized`.
  - `:edit`/`:write` complete **directories and filenames** relative to the working directory.
  - `:tag` completes tag names; `:set` and `:help` know **every** option/help topic in Vim.

## Example

Switch color scheme when you can't recall the exact name:

```
:colorscheme <C-d>     list all available themes
:colorscheme so<Tab>   completes to "solarized"
<CR>                   apply it
```

## Why it matters / when to reach for it

Tab-completion turns half-remembered command and option names into a quick lookup — no need to memorize exact spellings of themes, settings, tags, or long file paths. `<C-d>` is especially handy for *discovery*: see what's available before committing.

## Gotchas

- `<C-d>` **lists** without selecting; `<Tab>` **completes/cycles**. Use `<C-d>` to browse, `<Tab>` to pick.
- Completion is contextual — the same `<Tab>` completes a command name early in the line and an argument (filename, option, tag) later.
- Filename completion is relative to Vim's working directory (`:pwd`), which matters when editing across directories (Tip 41–42).
- Custom Ex commands can define their own completion behavior (`:h :command-complete`).

## Related

- Tip 27 — Meet Vim's Command Line
- Tip 33 — Insert the Current Word at the Command Prompt
- Tip 34 — Recall Commands from History
- Tip 41–42 — Opening files (`:edit`/`:find` with path completion)
