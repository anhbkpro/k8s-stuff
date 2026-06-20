# k9s Best Practices

k9s is the terminal UI for navigating Kubernetes clusters. Below are the practices that matter day-to-day.

## Safety / Context

- Always confirm your context and namespace before acting — `:ctx` to switch context, `:ns` for namespace. The header shows the current context; misreading it is the #1 way people `delete` in prod by accident.
- Set readonly mode for prod clusters so you can't accidentally mutate: run `k9s --readonly` or set it per-context in config. Many teams alias `k9s-prod` to launch readonly.
- Use distinct skins per environment (different colors for prod vs staging) so you _see_ you're in prod. Configure in `skins/` referenced from your cluster config.

## Navigation Efficiency

- `:` opens the command prompt — type any resource (`:po`, `:deploy`, `:svc`, `:cm`, `:secret`, `:ing`, `:hpa`, `:job`). Learn the aliases; it's faster than menus.
- `/` filters within a view; `Esc` clears. Use `/!` for inverse filters and label filters like `/-l app=foo`.
- `0` shows all namespaces; number keys jump to namespace favorites.
- `Ctrl-a` lists all available resource aliases (including CRDs) — great for discovering custom resources.

## Debugging Workflow

- `l` for logs, `Shift-f` to port-forward, `s` to shell into a container, `d` to describe, `y` to view YAML.
- `Ctrl-d` deletes, `Ctrl-k` kills (no grace period) — be deliberate with these.
- In logs view, `0`–`9` set the tail line count; `f` toggles fullscreen; toggle autoscroll with `s`.
- `:pulse` gives a cluster health dashboard; `:xray deploy` shows the resource dependency tree (deploy → rs → pod), which is excellent for spotting why a rollout is stuck.

## Config & Ergonomics

- Keep config in `~/.config/k9s/` (`config.yaml`, `skins/`, `hotkeys.yaml`, `plugins.yaml`). Version-control it.
- Define **hotkeys** for resources you hit constantly and **plugins** to wire in your own tooling (e.g. a plugin that opens `stern` logs, runs `kubectl debug`, or jumps to Grafana for the selected pod).
- Tune the refresh rate (`refreshRate`) — lower it on large clusters to reduce API server load.
- Set `noExitOnCtrlC` and resource limits in config if you're on big clusters to avoid hammering the API.

## Operational

- Respect RBAC — k9s only shows what your kubeconfig user can see. If a resource is missing, it's usually permissions, not k9s.
- Use `:bench` (built-in Hey benchmarking) sparingly and never against prod.

## Highest-Value Habit

The single highest-value habit for a backend engineer: **readonly + per-env skins on prod contexts.** It removes the entire category of "wrong cluster" accidents.
