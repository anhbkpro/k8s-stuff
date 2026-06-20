#!/usr/bin/env bash
# Symlink this tracked k9s config into ~/.config/k9s (macOS).
# Re-runnable: backs up an existing real dir once, then relinks.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.config/k9s"

echo "Source : $SRC"
echo "Target : $DEST"

# If a real (non-symlink) dir already exists, back it up once.
if [ -e "$DEST" ] && [ ! -L "$DEST" ]; then
  BACKUP="$DEST.backup.$(date +%Y%m%d%H%M%S)"
  echo "Existing config found -> backing up to $BACKUP"
  mv "$DEST" "$BACKUP"
fi

mkdir -p "$(dirname "$DEST")"
ln -sfn "$SRC" "$DEST"
echo "Linked $DEST -> $SRC"

# Wire the shell snippet into ~/.zshrc (idempotent). This sources the kubectl
# aliases and exports K9S_CONFIG_DIR so the setup travels to new machines.
RC="$HOME/.zshrc"
LINE="source \"$SRC/shellrc.sh\""
if [ -f "$RC" ] && grep -qF "$LINE" "$RC"; then
  echo "Shell snippet already sourced in $RC"
else
  {
    echo ""
    echo "# k8s-stuff/k9s shell setup (kubectl aliases + K9S_CONFIG_DIR)"
    echo "$LINE"
  } >> "$RC"
  echo "Added shell snippet to $RC"
fi

cat <<'EOF'

Done. Reload your shell so the changes take effect:

    source ~/.zshrc

Verify k9s is reading from the right place:

    k9s info

The "Configuration" and "Logs" paths it prints should point under
~/.config/k9s. If hotkeys.yaml still isn't picked up, your k9s version
reads hotkeys from its DATA dir — in that case also run:

    ln -sfn "$HOME/.config/k9s/hotkeys.yaml" \
      "$HOME/Library/Application Support/k9s/hotkeys.yaml"
EOF
