#!/usr/bin/env bash
#
# lazygit/install.sh — reproducible lazygit setup (git-delta pager + nvim editor).
#
# What it does (safe to re-run):
#   1. Installs lazygit + git-delta via Homebrew (native arm64 when available).
#   2. Symlinks config.yml into both config locations lazygit checks on macOS,
#      backing up any existing real file first.
#
# Usage:  cd lazygit && ./install.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

log()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }

# --- Pick the right Homebrew (arch consistency) ---------------------------
if [ "$(uname -m)" = "arm64" ] && [ -x /opt/homebrew/bin/brew ]; then
  BREW=/opt/homebrew/bin/brew
  eval "$("$BREW" shellenv)"
elif command -v brew >/dev/null 2>&1; then
  BREW="$(command -v brew)"
else
  BREW=""
fi

# --- 1. Dependencies ------------------------------------------------------
if [ -n "$BREW" ]; then
  log "Installing lazygit + git-delta via Homebrew ($BREW)..."
  "$BREW" install lazygit git-delta || warn "brew install failed — continuing."
else
  warn "Homebrew not found. Install it from https://brew.sh, or install"
  warn "lazygit and git-delta by hand."
fi

# --- 2. Symlink config ----------------------------------------------------
link_config() {
  local dst="$1"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    rm -f "$dst"
  elif [ -e "$dst" ]; then
    warn "Backing up existing $dst -> ${dst}.bak-$TS"
    mv "$dst" "${dst}.bak-$TS"
  fi
  ln -sfn "$SCRIPT_DIR/config.yml" "$dst"
  log "Linked $dst"
}

# macOS default location (used when XDG_CONFIG_HOME is unset)...
link_config "$HOME/Library/Application Support/lazygit/config.yml"
# ...and the XDG location (used when XDG_CONFIG_HOME=~/.config).
link_config "$HOME/.config/lazygit/config.yml"

log "Done. Open 'lazygit' and view a diff — it should render with delta."
