# k9s config

Version-controlled [k9s](https://k9scli.io) configuration for reuse across machines.
Worked examples for safe, ergonomic cluster navigation — readonly prod, per-env skins,
hotkeys, and plugins.

## Layout

```
k9s/
├── config.yaml                  # global defaults (refresh, logger, thresholds, shellPod)
├── skins/
│   ├── prod_red.yaml            # loud red skin → assign to prod contexts
│   └── staging_green.yaml       # calm green skin → assign to non-prod contexts
├── plugins.yaml                 # stern logs, events, yaml-to-pager, debug container
├── hotkeys.yaml                 # Shift-D/S/I/C/X/P jumps to favorite resources
├── clusters/
│   └── EXAMPLE-cluster/EXAMPLE-context/config.yaml  # per-context readonly+skin template
├── shellrc.sh                   # sources kubectl aliases + exports K9S_CONFIG_DIR
├── install.sh                   # symlinks dir + wires shellrc.sh into ~/.zshrc
└── .gitignore                   # keeps your real per-context files out of git
```

## Install (macOS)

```bash
./install.sh
```

This symlinks the dir to `~/.config/k9s` **and** appends a single line to
`~/.zshrc` (idempotent) that sources `shellrc.sh`. That snippet:

- sources `~/.kubectl_aliases.sh` if present (your kubectl aliases), and
- exports `K9S_CONFIG_DIR="$HOME/.config/k9s"`.

So a fresh machine gets the aliases + k9s env automatically. Then reload:

```bash
source ~/.zshrc
```

Confirm k9s is loading from here:

```bash
k9s info
```

### The two-directory gotcha

k9s splits its files across two XDG roots. `config.yaml`, `skins/`, and
`plugins.yaml` come from the **config** dir; `hotkeys.yaml` and `clusters/`
come from the **data** dir. On macOS both default to
`~/Library/Application Support/k9s`. Setting `K9S_CONFIG_DIR` points the config
dir at `~/.config/k9s`. If `k9s info` shows hotkeys still loading from the data
dir, `install.sh` prints the one extra symlink to fix it.

## Per-context readonly + skin (the important part)

The single biggest safety win is making prod contexts read-only and coloring
them red so "wrong cluster" mistakes are impossible to miss.

1. List your contexts: `kubectl config get-contexts`
2. Copy the template to match a real cluster/context name:

   ```bash
   mkdir -p clusters/my-prod-cluster/my-prod-context
   cp clusters/EXAMPLE-cluster/EXAMPLE-context/config.yaml \
      clusters/my-prod-cluster/my-prod-context/config.yaml
   ```

3. Edit `cluster:`, keep `readOnly: true` and `skin: prod_red`.

Real per-context files are gitignored (they leak cluster names); only the
EXAMPLE template is tracked.

## Plugins reference

| Shortcut | Scope | Action |
|----------|-------|--------|
| `Ctrl-L` | pods | Stern logs (needs `stern` on PATH) |
| `Shift-E` | all  | Events for the selected object, paged |
| `Ctrl-J` | all  | Resource YAML to pager |
| `Shift-K` | pods | Ephemeral debug container (netshoot) |

## Hotkeys reference

| Key | Goes to |
|-----|---------|
| `Shift-1` | Deployments |
| `Shift-2` | Services |
| `Shift-3` | Ingresses |
| `Shift-4` | ConfigMaps |
| `Shift-5` | XRay deployments |
| `Shift-6` | Cluster pulse |

Custom hotkeys also show up in the `?` help view.

> **Why digits, not letters?** k9s reserves `Shift-<letter>` for column
> sorting (Shift-C=CPU, Shift-S=status, Shift-I=IP, …). Binding those without
> `override: true` makes k9s reject the entire hotkeys file with
> "HotKeys load failed!". `Shift-<digit>` combos are collision-free.
