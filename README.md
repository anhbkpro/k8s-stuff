# k8s-stuff

Personal Kubernetes tooling, configuration, and notes — version-controlled for
reuse across machines.

## Contents

| Path | What it is |
|------|------------|
| [`k9s/`](k9s/README.md) | Version-controlled [k9s](https://k9scli.io) config: global defaults, per-env skins, per-context readonly, hotkeys, plugins, and kubectl aliases. Has its own installer + README. |
| [`vim/`](vim/README.md) | Self-contained, reproducible vim setup (vim-plug + fzf, NERDTree, ALE, vim-go, and more). Clone, run `./install.sh`, get the same editor on any machine. Has its own installer + README. |
| [`nvim/`](nvim/README.md) | Reproducible [LazyVim](https://www.lazyvim.org) (Neovim) setup with Go + Terraform/YAML/Docker/Helm extras. Symlinked to `~/.config/nvim`; `lazy-lock.json` pins plugin versions. Has its own installer + README. |
| [`lazygit/`](lazygit/README.md) | Version-controlled [lazygit](https://github.com/jesseduffield/lazygit) config: git-delta diffs, nvim editor, icons. Symlinked into place; also wired into the nvim installer. Has its own installer + README. |
| [`istio-tmux.sh`](istio-tmux.sh) | One-shot tmux layout for Istio practice: nvim (left), a kubectl/istioctl shell (top-right), and a live pod watch (bottom-right). Installed on PATH as `istio-tmux` by the nvim installer. See [`tmux-guide.md`](tmux-guide.md). |
| [`tmux-guide.md`](tmux-guide.md) | tmux lifecycle (detach vs. kill), navigation, copy mode, and best practices for the istio-tmux layout. |
| [`k9s-best-practices.md`](k9s-best-practices.md) | Day-to-day k9s best practices (safety, navigation, debugging, config). |
| [`stern-guide.md`](stern-guide.md) | stern install (incl. Homebrew tap-trust gotcha) + log-tailing best practices. |
| [`github-ssh-personal-setup.md`](github-ssh-personal-setup.md) | Ed25519 SSH key setup for GitHub with macOS Keychain. |

## k9s config — quick start

```bash
cd k9s && ./install.sh
source ~/.zshrc
k9s info        # confirm paths point under ~/.config/k9s
```

The installer symlinks `k9s/` to `~/.config/k9s`, migrates and symlinks your
`~/.kubectl_aliases.sh` into the repo, and wires `shellrc.sh` into `~/.zshrc`.
See [`k9s/README.md`](k9s/README.md) for full details, including the
per-context readonly + skin pattern and the macOS config/data dir gotcha.

### Per-context skins (configured)

| Context | Skin | Read-only |
|---------|------|-----------|
| `docker-desktop` | red (test) / green | no — local practice cluster |
| `minikube` | green | no — local cluster |
| `EXAMPLE-cluster` | red template | yes — copy for real prod contexts |

Reserve the **red** skin for real prod so the visual signal stays meaningful;
local clusters use **green**.

## istio-tmux — quick start

`istio-tmux.sh` spins up a tmux session named `istio` with a three-pane layout
for practicing Istio: nvim on the left, a free shell for `kubectl`/`istioctl`
top-right, and a live `watch kubectl get pods` bottom-right (plus a spare
`debug` window).

The nvim installer symlinks it to `~/.local/bin/istio-tmux`, so once that's run
it's callable from any new terminal:

```bash
cd nvim && ./install.sh     # links ~/.local/bin/istio-tmux (one-time)

istio-tmux                  # project-dir = $PWD, namespace = istioinaction
istio-tmux ~/code/mesh      # custom project dir
istio-tmux ~/code/mesh foo  # custom project dir + namespace
```

If `~/.local/bin` isn't on your `PATH`, the installer prints the line to add to
your shell rc.

**Quitting:** detach (leave it running) with `Ctrl-b` then `d`, and reattach
later with `tmux attach -t istio`. To tear it all down, `tmux kill-session -t
istio` — the cleanest "I'm done" command. The watch pane runs a loop, so
`Ctrl-c` it before `exit` if you're closing panes individually. Full lifecycle,
navigation, and best practices live in [`tmux-guide.md`](tmux-guide.md).

## Conventions

- Real per-context configs under `k9s/clusters/` are gitignored (they leak
  cluster names); only the `EXAMPLE` template and the standard local
  `docker-desktop` / `minikube` contexts are tracked.
- Shell setup lives in `k9s/shellrc.sh` so it travels with the repo; `~/.zshrc`
  only sources it.
