# Tip 37 — Group Buffers into a Collection with the Argument List

> Chapter 6 — Manage Multiple Files · *Practical Vim* (Drew Neil)

**One-liner:** The argument list (`:args`) is a tidy, rebuildable subset of your buffers — populate it with filenames, globs, or backtick expansion, then batch-edit every file with `:argdo`.

**Practice files:** [`../practice/tip-37-argument-list/`](../practice/tip-37-argument-list/) — the `mvc/` tree (for globs) plus `a–e.txt`. From that dir, launch `vim` and try `:args **/*.js`, `:argdo`, `:next`/`:prev`.

## Commands

| Command | Effect |
| --- | --- |
| `:args` | Print the current argument list |
| `:args {arglist}` | **Set** the arg list (filenames / globs / backticks) |
| `:next` / `:prev` | Move forward / back through the arg list |
| `:first` / `:last` | Jump to start / end of the arg list |
| `:argdo {cmd}` | Run an Ex command on **every** file in the arg list |

## How it works

The **argument list** is the set of files you passed to `vim` at launch — but despite the name, you can **rewrite it any time** with `:args {arglist}`. It's cruder-looking than `:ls` (it predates Vim; it's a vi feature) but simpler to manage, which makes it the ideal place to *group a collection of files*.

`:args` with no argument prints the list; `[ ]` marks the active file:

```
:args
[a.txt] b.txt c.txt d.txt e.txt
```

### Three ways to populate it

**By name** — explicit and ordered:

```
:args index.html app.js
```

**By glob** — wildcards (`:h wildcard`):

- `*` matches within one directory; `**` recurses into subdirectories.
- `:args *.*` → top-level files; `:args **/*.js` → every `.js` in the tree.
- Multiple globs allowed: `:args **/*.js **/*.css` (all JS and CSS, nothing else).

**By backtick expansion** — use a shell command's output (`:h backtick-expansion`):

```
:args `cat .chapters`
```

Vim runs the backticked command in the shell and feeds its stdout to `:args` — e.g. read filenames (one per line) from a manifest file to control order. (Not available on all systems.)

## Example — batch edit with `:argdo`

```
:args **/*.js            collect every JS file into the arg list
:argdo %s/oldAPI/newAPI/g   run the substitution in each one
:argdo update            (or fold the write in) write changed buffers
```

`:argdo` executes the same Ex command on each file in the set — pairs beautifully with `:substitute` (Tip 96) or `:normal @q` to run a macro across files (Tip 69).

## Why it matters / when to reach for it

Neil's metaphor: **the buffer list is your messy desktop; the argument list is a tidy workspace you clear and repopulate on demand.** When you want to operate on a *specific* group of files — all JS in a module, the files touched by a refactor — build that set with `:args {glob}` and drive it with `:argdo`, rather than wrestling the buffer list into order.

## Gotchas

- `:args {arglist}` **replaces** the whole list — it doesn't append.
- The name is historical; the list is fully mutable, not just the launch arguments.
- `*` stays within one directory; use `**` to recurse.
- `:argdo` runs across all args — commands that fail mid-way can abort; test on a small set first, and ensure `hidden` is set or buffers are written (Tip 38) so switching files doesn't error.
- Backtick expansion is shell-dependent (may not work on Windows).

## Related

- Tip 36 — Track Open Files with the Buffer List
- Tip 38 — Manage Hidden Files (needed for smooth `:argdo`/`:next`)
- Tip 69 — Act Upon a Collection of Files (`:argdo normal @q`)
- Tip 96 — Find and Replace Across Multiple Files (`:argdo %s`)
