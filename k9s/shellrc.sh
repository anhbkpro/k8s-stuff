#!/usr/bin/env bash
# k9s + kubectl shell setup. Sourced from ~/.zshrc by install.sh.
# Keep all reusable shell env for k8s tooling here so it travels with the repo.

# kubectl aliases (e.g. kgp, kgpo, kdp ...). Created/maintained separately.
[ -f "$HOME/.kubectl_aliases.sh" ] && source "$HOME/.kubectl_aliases.sh"

# Point k9s at the version-controlled config dir.
export K9S_CONFIG_DIR="$HOME/.config/k9s"
