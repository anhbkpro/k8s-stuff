# Tip 40 — Organize Your Window Layouts with Tab Pages

> Chapter 6 — Manage Multiple Files · *Practical Vim* (Drew Neil)

**One-liner:** A Vim tab page is a **container for a layout of windows** (like a virtual desktop), not one-tab-per-file — create with `:tabedit`, switch with `{N}gt`/`gT`.

**Practice file:** none — try it: split a window, `:tabedit other.txt`, then `gt`/`gT` to switch, `:tabclose` to close.

## Commands

| Ex | Normal | Effect |
| --- | --- | --- |
| `:tabe[dit] {file}` | | Open `{file}` in a new tab (empty buffer if omitted) |
| | `<C-w>T` | Move the current window into its own new tab |
| `:tabc[lose]` | | Close the current tab (and all its windows) |
| `:tabo[nly]` | | Close all tabs except the current |
| `:tabn[ext] {N}` | `{N}gt` | Go to tab `{N}` |
| `:tabn[ext]` | `gt` | Next tab |
| `:tabp[revious]` | `gT` | Previous tab |
| `:tabmove [N]` | | Move current tab to position `[N]` (0 = first, omitted = last) |

## How it works

In most editors a tab = an open file. **Not in Vim.** `:edit` doesn't make a tab — it loads a buffer into the current window; the *buffer list* tracks open files (Tip 36). Instead, a Vim **tab page is a container that holds a collection of windows** (`:h tabpage`) — closer to a Linux **virtual desktop** than a browser tab.

So tabs are for **partitioning work into separate window layouts**. Mid-task with a carefully arranged set of splits, and something urgent comes up? Open a new tab (`:tabedit`), deal with it there, then `gT`/`gt` back — your original split layout is preserved intact.

**Scope a tab to a project directory:** `:lcd {path}` sets the working directory *locally to the current window*. New tab + `:lcd` = each tab scoped to a different project. (For all windows in a tab: `:windo lcd {path}`.)

Tabs work identically in GVim (GUI tab bar) and terminal Vim (text tab bar).

## Switching — `{N}gt`

Tabs are numbered from 1. `{N}gt` = "goto tab N"; bare `gt` advances to the next tab, `gT` goes back. (`<C-w>T` promotes the current window out into its own tab.)

## Example

```
{working with several splits}
:tabedit urgent.txt   new tab for the interruption
{do the urgent work}
gT                    back to the original tab — splits untouched
2gt                   jump straight to tab 2
```

## Why it matters / when to reach for it

Reach for tabs when you need **multiple distinct workspaces**, not to list open files (that's the buffer list). Each tab keeps its own window arrangement, so context-switching doesn't disturb your layout. Combined with `:lcd`, tabs become per-project sandboxes.

## Gotchas

- Don't use tabs as a file list — Vim's model is layout-per-tab, buffer-list-for-files. Fighting this leads to frustration.
- `:lcd` is **window-local**, not tab-local — use `:windo lcd` to set it for every window in a multi-split tab.
- `:close`/`<C-w>c` on a tab's *last* window closes the tab too; `:tabclose` closes it regardless of window count.
- `{N}gt` uses tab *position*, which changes if you `:tabmove` them around.

## Related

- Tip 36 — Buffer List (the real "open files" list)
- Tip 39 — Split Windows (what tabs contain)
- Tip 37 — Argument List
