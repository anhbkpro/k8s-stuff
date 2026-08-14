# Tip 39 — Divide Your Workspace into Split Windows

> Chapter 6 — Manage Multiple Files · *Practical Vim* (Drew Neil)

**One-liner:** A window is a viewport onto a buffer — split horizontally with `<C-w>s` or vertically with `<C-w>v`, move focus with `<C-w>h/j/k/l`, and close with `<C-w>c` / `<C-w>o`.

**Practice file:** none — open any file and split it: `<C-w>v`, then `:edit {other-file}` in one split.

## Creating splits

| Command | Effect |
| --- | --- |
| `<C-w>s` | Split **horizontally**, same buffer in both |
| `<C-w>v` | Split **vertically**, same buffer in both |
| `:sp[lit] {file}` | Split horizontally, load `{file}` in the new window |
| `:vsp[lit] {file}` | Split vertically, load `{file}` in the new window |

## Moving focus

| Command | Effect |
| --- | --- |
| `<C-w>w` (= `<C-w><C-w>`) | Cycle between windows |
| `<C-w>h` / `j` / `k` / `l` | Focus window left / below / above / right |

## Closing & resizing

| Ex | Normal | Effect |
| --- | --- | --- |
| `:clo[se]` | `<C-w>c` | Close the active window |
| `:on[ly]` | `<C-w>o` | Keep only the active window |
| | `<C-w>=` | Equalize all window sizes |
| | `<C-w>_` / `<C-w>\|` | Maximize height / width |
| | `[N]<C-w>_` / `[N]<C-w>\|` | Set active window to `[N]` rows / cols |

## How it works

A **window** is a viewport onto a buffer (`:h window`) — not the buffer itself. You can show the *same* buffer in several windows (scroll one to a reference point while editing another spot), or *different* buffers in each.

Start with one window. `<C-w>s` divides it into two of equal height; `<C-w>v` into two of equal width. Both new windows initially show the current buffer. Repeat to keep subdividing — like cell division.

To put a *different* file in a split: `<C-w>s` then `:edit {file}`, or do both at once with `:split {file}` / `:vsplit {file}`.

**Focus:** `<C-w>` then a direction (`h/j/k/l`) moves to the adjacent window; `<C-w>w` cycles. Tip: hold `<Ctrl>` and tap `ww` (i.e. `<C-w><C-w>`) — awkward to write but easier to type than releasing for the final key. Heavy split users often remap these (e.g. `<C-h/j/k/l>`).

## Why it matters / when to reach for it

Splits build a workspace tailored to the task: source beside test, header beside implementation, or two regions of one long file at once. `<C-w>o` ("only") is the fast way to blow away clutter and focus on one window; `<C-w>=` re-balances after resizing.

## Gotchas

- `<C-w>s`/`<C-w>v` reuse the **current buffer** — use `:split {file}`/`:vsplit {file}` (or follow with `:edit`) to view another file.
- Closing a window (`:close`/`<C-w>c`) doesn't unload the buffer — it stays in `:ls`.
- Mouse works for click-to-focus and drag-to-resize if `:set mouse=a` (or in GVim); resizing by mouse is genuinely handy.
- Neovim/LazyVim already map `<C-h/j/k/l>` to window navigation, so you may not need `<C-w>` for focus.

## Related

- Tip 36 — Buffer List (windows vs buffers)
- Tip 40 — Organize Window Layouts with Tab Pages
- Tip 37 — Argument List
