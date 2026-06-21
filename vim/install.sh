#!/usr/bin/env bash
#
# vim/install.sh — reproduce this vim setup on a new machine.
#
# What it does (idempotent, safe to re-run):
#   1. Installs CLI deps via Homebrew (vim, fzf, ripgrep, universal-ctags).
#   2. Backs up any existing real config, then symlinks this repo's files into
#      ~/.vimrc, ~/.vimrc.bundles, ~/.vim/ftplugin, ~/.vim/plugin.
#   3. Bootstraps vim-plug and installs every plugin headlessly.
#
# Usage:  cd vim && ./install.sh
#
set -euo pipefail

# Directory this script lives in (the repo's vim/ folder), resolved absolutely.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TS="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME/.vim-backup-$TS"

log()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }

# Move a real file/dir out of the way; drop a stale symlink.
backup() {
  local target="$1"
  if [ -L "$target" ]; then
    rm -f "$target"
  elif [ -e "$target" ]; then
    mkdir -p "$BACKUP_DIR"
    warn "Backing up existing $target -> $BACKUP_DIR/"
    mv "$target" "$BACKUP_DIR/"
  fi
}

link() {
  local src="$1" dst="$2"
  backup "$dst"
  ln -sfn "$src" "$dst"
  log "Linked $dst -> $src"
}

# --- 0. Pick the right Homebrew (arch consistency) ------------------------
# On Apple Silicon, prefer the native /opt/homebrew so we never end up with an
# x86_64 (Rosetta) vim + tooling on an arm64 Mac.
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
  # the_silver_searcher (ag) powers fzf file listing + :Ag grep in ~/.vimrc.
  "$BREW" install vim fzf the_silver_searcher universal-ctags || \
    warn "One or more brew installs failed — continuing."
else
  warn "Homebrew not found. Install it from https://brew.sh and re-run,"
  warn "or install vim, fzf, the_silver_searcher, and universal-ctags by hand."
fi

# --- 1b. Arch sanity check ------------------------------------------------
# Warn if vim's arch doesn't match the CPU (clipboard/plugin native bits can break).
if command -v vim >/dev/null 2>&1 && [ "$(uname -m)" = "arm64" ]; then
  if file "$(command -v vim)" | grep -q "x86_64"; then
    warn "WARNING: vim is x86_64 (Intel/Rosetta) on an arm64 Mac. For a native"
    warn "build:  eval \"\$(/opt/homebrew/bin/brew shellenv)\" && brew install vim"
  fi
fi

# --- 2. Symlink config ----------------------------------------------------
mkdir -p "$HOME/.vim"
link "$SCRIPT_DIR/vimrc"         "$HOME/.vimrc"
link "$SCRIPT_DIR/vimrc.bundles" "$HOME/.vimrc.bundles"
link "$SCRIPT_DIR/ftplugin"      "$HOME/.vim/ftplugin"
link "$SCRIPT_DIR/plugin"        "$HOME/.vim/plugin"

# --- 3. Bootstrap vim-plug ------------------------------------------------
PLUG="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG" ]; then
  log "Installing vim-plug..."
  curl -fLo "$PLUG" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  log "vim-plug already present."
fi

# --- 4. Install plugins headlessly ----------------------------------------
# Source only the bundles file so the `VimEnter * NERDTree` autocmd in ~/.vimrc
# doesn't fire (and error) before NERDTree is installed.
log "Installing plugins (this clones repos and builds the fzf binary)..."
vim -Es -u "$HOME/.vimrc.bundles" +'PlugInstall --sync' +qall || true

# --- 5. Optional: pin exact versions --------------------------------------
if [ -f "$SCRIPT_DIR/plug.snapshot.vim" ]; then
  log "Applying pinned plugin versions from plug.snapshot.vim..."
  vim -Es -u "$HOME/.vimrc" +"source $SCRIPT_DIR/plug.snapshot.vim" +qall || true
fi

log "Done."
echo
echo "Next steps:"
echo "  • Open vim and run  :Copilot setup   to authenticate GitHub Copilot."
echo "  • Run  :checkhealth  (or :GoInstallBinaries) if Go tooling is missing."
[ -d "$BACKUP_DIR" ] && echo "  • Your previous config was saved to: $BACKUP_DIR"
