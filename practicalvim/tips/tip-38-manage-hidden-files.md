# Tip 38 — Manage Hidden Files

> Chapter 6 — Manage Multiple Files · *Practical Vim* (Drew Neil)

**One-liner:** Vim blocks you from leaving a modified buffer (`E37`) unless you force it (`:bnext!`) — which *hides* it; enabling `:set hidden` lets you switch freely and is essential for `:argdo`/`:bufdo`.

**Practice files:** [`../practice/tip-38-manage-hidden-files/`](../practice/tip-38-manage-hidden-files/) — open both (`vim a.txt b.txt`), modify `a.txt` (e.g. `Go`), then try `:bnext`, `:bnext!`, `:ls`. Reset with `:e!`.

## Commands

| Command | Effect |
| --- | --- |
| `:ls` | List buffers; flags show state (see below) |
| `:bnext!` / `:next!` | Force-switch, hiding the modified current buffer |
| `:set hidden` | Allow leaving modified buffers without a bang |
| `:write` | Save the buffer to disk |
| `:edit!` | Reload from disk, **discarding** buffer changes |
| `:qall!` | Quit all, discarding changes without warning |
| `:wall` | Write **all** modified buffers |
| `:argdo write` / `:wn` | Save every arg-list buffer / write-and-next |

## `:ls` flags

```
:ls
  1 %a + "a.txt" line 1
  2      "b.txt" line 0
```

- `%` current window · `a` active · `+` **modified** (unsaved)
- After `:bnext!`: `1 #h + "a.txt"` — `#` alternate, `h` **hidden**, still `+` modified.

## How it works

Modify a buffer without saving and Vim marks it `+`. Try to leave it and Vim protests:

```
:bnext
E37: No write since last change (add ! to override)
```

This is a guard against losing work. Follow the hint with a bang — `:bnext!` — and Vim switches anyway, turning the modified buffer into a **hidden** buffer (still in memory, unsaved, `h` in `:ls`).

### Hidden buffers on quit

A hidden modified buffer lets you work normally… until you `:quit`:

```
E162: No write since last change for buffer "a.txt"
```

Vim loads each unsaved hidden buffer into the window so you can decide: `:write` to keep, or `:edit!` to revert from disk. It cycles through every modified buffer until each is resolved, then quits. Shortcuts: `:qall!` (discard everything, no review) or `:wall` (save everything).

## Why `:set hidden` matters — `:argdo`/`:bufdo`

`:argdo {cmd}` effectively does `:first`, `{cmd}`, `:next`, `{cmd}`, … But if `{cmd}` modifies the first buffer, the plain `:next` fails with `E37` — the batch stalls on the first file.

**Enable `:set hidden`** and `:next`/`:bnext`/`:cnext` no longer need a bang: Vim silently hides a modified buffer when you navigate away. This is what makes `:argdo` and `:bufdo` usable for editing a whole collection in one command.

After the batch, save everything with `:argdo write` (or `:wall`), or review file-by-file with `:first` then `:wn`.

## Example

```
:set hidden              (put this in your vimrc)
:args **/*.js
:argdo %s/oldAPI/newAPI/ge   edit each file (e flag = no error if no match)
:argdo update            write the changed ones
```

## Gotchas

- Without `hidden`, every `:argdo` that edits buffers dies on the first `:next` — set `hidden` first (most configs, including LazyVim/Neovim defaults, enable it).
- `:edit!` **discards** unsaved changes (reverts to disk) — don't confuse it with `:write`.
- `:qall!` throws away *all* unsaved work silently — use deliberately.
- The `+` flag = unsaved; hidden (`h`) just means "not shown in a window," it can still be modified.

## Related

- Tip 36 — Track Open Files with the Buffer List (`:ls`, flags)
- Tip 37 — Argument List (`:argdo`, which needs `hidden`)
- Tip 69 / 96 — Batch editing across files
