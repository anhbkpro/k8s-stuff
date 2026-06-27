# tmux guide

Day-to-day tmux notes for the [`istio-tmux.sh`](istio-tmux.sh) layout and
terminal multiplexing in general. The default **prefix** is `Ctrl-b` — every
shortcut below is "press the prefix, release, then the key".

## Mental model

- **Session** — a named workspace that keeps running even after you close the
  terminal. `istio-tmux.sh` creates one called `istio`.
- **Window** — like a tab inside a session (`edit`, `debug`).
- **Pane** — a split within a window. The istio layout has three: nvim (left),
  a kubectl/istioctl shell (top-right), and a live pod watch (bottom-right).

The win is persistence: detach, close your laptop, come back, and the session —
including running `watch` and any long commands — is exactly where you left it.

## Lifecycle: detach vs. kill (the "how do I quit" answer)

| Goal | Command |
|------|---------|
| **Detach** — leave everything running, reattach later | `Ctrl-b` then `d` |
| Reattach to the istio session | `tmux attach -t istio` |
| **Kill the whole session** (tear it all down) | `tmux kill-session -t istio` |
| Kill from inside the session | `Ctrl-b` then `:` → `kill-session` → Enter |
| Close the focused pane | `Ctrl-b` then `x` (or type `exit`) |
| Close the whole window | `Ctrl-b` then `&` |
| List running sessions | `tmux ls` |

The bottom-right pane runs an infinite watch/loop, so `Ctrl-c` it first before
`exit`, or just use `kill-session` to nuke the whole thing at once — that's the
cleanest "I'm done" command. Both are in `istio-tmux.sh`'s header comments.

**Detach when you'll come back; kill when you're truly done.** Leaving dozens of
stale sessions around wastes memory and makes `tmux ls` useless — `kill-session`
the ones you've finished with.

## Navigation

| Action | Keys |
|--------|------|
| Move between panes | `Ctrl-b` then arrow key |
| Cycle panes | `Ctrl-b` then `o` |
| Zoom focused pane fullscreen (toggle) | `Ctrl-b` then `z` |
| Next / previous window | `Ctrl-b` then `n` / `p` |
| Jump to window by number | `Ctrl-b` then `0`–`9` |
| Show pane numbers (then press one) | `Ctrl-b` then `q` |
| Rename current window | `Ctrl-b` then `,` |

`Ctrl-b z` is the most underused shortcut — zoom the nvim pane to fullscreen
while editing, then zoom back out to see the pod watch again.

## Splitting and resizing

| Action | Keys |
|--------|------|
| Split horizontally (new pane to the right) | `Ctrl-b` then `%` |
| Split vertically (new pane below) | `Ctrl-b` then `"` |
| Resize pane | `Ctrl-b` then hold the arrow key |
| Convert pane into its own window | `Ctrl-b` then `!` |

## Copy mode (scrolling + selecting)

The watch pane and logs scroll off-screen; copy mode lets you scroll back and
yank text without a mouse.

1. `Ctrl-b` then `[` to enter copy mode.
2. Scroll with arrows / `PageUp` / `Ctrl-u` / `Ctrl-d`, or search with `/`.
3. `Space` to start selection, move, `Enter` to copy.
4. `Ctrl-b` then `]` to paste. `q` exits copy mode.

## Best practices

- **One session per project/context.** Name it (`tmux new -s istio`) so
  `tmux ls` and `attach -t` stay meaningful. `istio-tmux.sh` does this for you.
- **Re-running is safe.** `istio-tmux.sh` checks for an existing `istio` session
  and just re-attaches, so it's idempotent — run it from any terminal.
- **Detach, don't kill, mid-task.** Long applies, port-forwards, and the pod
  watch survive a detach; you lose them on kill.
- **Keep panes purposeful.** The istio layout encodes a workflow: edit on the
  left, run on the top-right, observe on the bottom-right. Don't crowd it.
- **Use `kubectl get pods -w`** in the watch pane if `watch` isn't installed —
  the script already falls back to a `clear`/`sleep` loop on a bare macOS.
- **Clean up.** `tmux kill-session -t <name>` when done; `tmux kill-server`
  nukes every session if things get messy.

## Optional: a minimal `~/.tmux.conf`

Not required for `istio-tmux.sh`, but these quality-of-life tweaks are common:

```tmux
set -g mouse on                 # click panes, scroll, drag-resize
set -g base-index 1             # windows start at 1 (matches keyboard)
setw -g pane-base-index 1
set -g history-limit 50000      # deeper scrollback for logs
set -g renumber-windows on      # no gaps after closing a window
bind r source-file ~/.tmux.conf \; display "reloaded"   # prefix r to reload
```

Reload without restarting: `Ctrl-b` then `:` → `source-file ~/.tmux.conf`.
