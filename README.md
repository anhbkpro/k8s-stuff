# k8s-stuff

Personal Kubernetes tooling, configuration, and notes — version-controlled for
reuse across machines.

## Contents

| Path | What it is |
|------|------------|
| [`k9s/`](k9s/README.md) | Version-controlled [k9s](https://k9scli.io) config: global defaults, per-env skins, per-context readonly, hotkeys, plugins, and kubectl aliases. Has its own installer + README. |
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

## Conventions

- Real per-context configs under `k9s/clusters/` are gitignored (they leak
  cluster names); only the `EXAMPLE` template and the standard local
  `docker-desktop` / `minikube` contexts are tracked.
- Shell setup lives in `k9s/shellrc.sh` so it travels with the repo; `~/.zshrc`
  only sources it.
