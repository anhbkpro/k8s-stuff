#!/usr/bin/env bash
#
# nvim/install.sh — reproduce this LazyVim setup on a new machine.
#
# What it does (safe to re-run):
#   1. Installs CLI deps via Homebrew (neovim, ripgrep, fd, fzf, lazygit, node,
#      tree-sitter, plus a Nerd Font). Mason installs language servers later.
#   2. Backs up any existing Neovim config + state (e.g. NvChad) to *.bak-<ts>.
#   3. Symlinks this folder to ~/.config/nvim.
#   4. Headlessly syncs plugins so the first real launch is instant.
#
# Usage:  cd nvim && ./install.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

log()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }

# --- 0. Pick the right Homebrew (arch consistency) ------------------------
# On Apple Silicon, nvim + its tree-sitter lib + the parser compiler must all be
# arm64. Prefer the native /opt/homebrew so we never end up with an x86_64
# (Rosetta) nvim building arm64 parsers it can't load.
if [ "$(uname -m)" = "arm64" ] && [ -x /opt/homebrew/bin/brew ]; then
  BREW=/opt/homebrew/bin/brew
  eval "$("$BREW" shellenv)"          # put /opt/homebrew/bin first on PATH
elif command -v brew >/dev/null 2>&1; then
  BREW="$(command -v brew)"
else
  BREW=""
fi

# --- 1. Dependencies ------------------------------------------------------
if [ -n "$BREW" ]; then
  log "Installing CLI dependencies via Homebrew ($BREW)..."
  # `tree-sitter` provides BOTH libtree-sitter.dylib (neovim links against it —
  # do NOT remove it) and the tree-sitter CLI that nvim-treesitter uses to build
  # parsers. Keeping it from one brew guarantees lib + CLI share an arch.
  "$BREW" install neovim ripgrep fd fzf lazygit node tree-sitter || \
    warn "One or more brew installs failed — continuing."
  log "Installing a Nerd Font (icons)..."
  "$BREW" install --cask font-jetbrains-mono-nerd-font || \
    warn "Nerd Font install failed — set your terminal font manually if icons look off."
else
  warn "Homebrew not found. Install it from https://brew.sh and re-run, or install"
  warn "neovim, ripgrep, fd, fzf, lazygit, node, and tree-sitter by hand."
fi

# Go is needed for gopls/delve; don't force-install (you may manage it yourself).
command -v go >/dev/null 2>&1 || \
  warn "Go not found on PATH — install it (brew install go) for gopls + debugging."

# --- 1a. Claude Code CLI (for claudecode.nvim) ----------------------------
# lua/plugins/claude.lua integrates the Claude Code CLI. Install it if missing.
if command -v claude >/dev/null 2>&1; then
  log "Claude Code CLI already installed ($(command -v claude))."
elif command -v npm >/dev/null 2>&1; then
  log "Installing Claude Code CLI via npm..."
  npm install -g @anthropic-ai/claude-code || \
    warn "Claude Code install failed — see https://docs.anthropic.com/en/docs/claude-code"
else
  warn "npm not found — install Claude Code manually for claudecode.nvim:"
  warn "  curl -fsSL claude.ai/install.sh | bash"
fi

# --- 1b. Arch sanity check ------------------------------------------------
# Fail loudly if nvim's arch doesn't match the CPU — parsers won't load otherwise.
if command -v nvim >/dev/null 2>&1 && [ "$(uname -m)" = "arm64" ]; then
  if file "$(command -v nvim)" | grep -q "x86_64"; then
    warn "WARNING: nvim is x86_64 (Intel/Rosetta) on an arm64 Mac."
    warn "Treesitter parsers build as arm64 and will fail to load. Fix with a"
    warn "native build:  eval \"\$(/opt/homebrew/bin/brew shellenv)\" && brew install neovim"
    warn "Then: rm -rf ~/.local/share/nvim/site/parser && nvim --headless +TSUpdate +qa"
  fi
fi

# --- 2. Back up existing Neovim dirs --------------------------------------
# Move real config + state aside so LazyVim starts from a clean slate.
backup() {
  local d="$1"
  if [ -L "$d" ]; then
    rm -f "$d"
  elif [ -e "$d" ]; then
    warn "Backing up $d -> ${d}.bak-$TS"
    mv "$d" "${d}.bak-$TS"
  fi
}
backup "$HOME/.config/nvim"
backup "$HOME/.local/share/nvim"
backup "$HOME/.local/state/nvim"
backup "$HOME/.cache/nvim"

# --- 3. Symlink this repo as the Neovim config ----------------------------
mkdir -p "$HOME/.config"
ln -sfn "$SCRIPT_DIR" "$HOME/.config/nvim"
log "Linked ~/.config/nvim -> $SCRIPT_DIR"

# --- 4. Install + sync plugins headlessly ---------------------------------
if command -v nvim >/dev/null 2>&1; then
  log "Syncing plugins (Lazy sync)... this clones every plugin."
  nvim --headless "+Lazy! sync" +qa 2>&1 | tail -n 5 || true
  log "Updating treesitter parsers..."
  nvim --headless "+TSUpdate" +qa 2>&1 | tail -n 5 || true
else
  warn "nvim not on PATH; skipping headless sync. Open nvim once to install plugins."
fi

# --- 5. Wire up lazygit (delta pager + nvim editor) -----------------------
# lazygit is core to the LazyVim workflow (<leader>gg); set it up if present.
if [ -x "$SCRIPT_DIR/../lazygit/install.sh" ]; then
  log "Setting up lazygit (git-delta + nvim editor)..."
  "$SCRIPT_DIR/../lazygit/install.sh" || warn "lazygit setup failed — run lazygit/install.sh manually."
fi

log "Done."
echo
echo "Next steps:"
echo "  • Open nvim. Let Mason finish installing LSP servers (gopls, terraform-ls,"
echo "    yaml-language-server, dockerfile-ls, helm-ls). Check with :Mason / :LazyHealth."
echo "  • Commit the regenerated lazy-lock.json to pin exact plugin versions."
ls -d "$HOME"/.config/nvim.bak-* >/dev/null 2>&1 && \
  echo "  • Your previous config was backed up to ~/.config/nvim.bak-$TS"
