#!/usr/bin/env bash
# istio practice tmux layout.
#   Usage: istio-tmux [project-dir] [namespace]
#   Defaults: project-dir = $PWD, namespace = istioinaction
# Creates a session "istio" with:
#   - Left  (60%): nvim, opened on the project dir
#   - Top-right : a free shell for kubectl/istioctl apply commands
#   - Bot-right : a live watch of pods
#
# Reattach later with:  tmux attach -t istio
# Kill with:            tmux kill-session -t istio

set -euo pipefail

DIR="${1:-$PWD}"
NS="${2:-istioinaction}"
SESSION="istio"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  exec tmux attach -t "$SESSION"
fi

# Window 0: nvim on the left.
tmux new-session -d -s "$SESSION" -c "$DIR" -n edit
tmux send-keys -t "$SESSION":edit "nvim ." C-m

# Right column: shell (top) + watch (bottom).
tmux split-window -h -t "$SESSION":edit -c "$DIR" -p 40
tmux split-window -v -t "$SESSION":edit.1 -c "$DIR" -p 50

# Bottom-right: live pod watch. Use `watch` if present (brew install watch),
# otherwise fall back to a kubectl --watch / loop so it works on a bare macOS.
if command -v watch >/dev/null 2>&1; then
  WATCH_CMD="watch -n 2 kubectl get pods -n $NS -o wide"
else
  WATCH_CMD="while true; do clear; kubectl get pods -n $NS -o wide; sleep 2; done"
fi
tmux send-keys -t "$SESSION":edit.2 "$WATCH_CMD" C-m

# Top-right: ready shell, focus here.
tmux send-keys -t "$SESSION":edit.1 "# kubectl apply -f <file>   |   istioctl analyze -n $NS" C-m
tmux select-pane -t "$SESSION":edit.1

# Optional second window for logs / istioctl proxy-config.
tmux new-window -t "$SESSION" -n debug -c "$DIR"

tmux select-window -t "$SESSION":edit
exec tmux attach -t "$SESSION"
