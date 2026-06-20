# stern — install & best practices

[stern](https://github.com/stern/stern) tails logs from multiple pods and
containers at once, with per-pod color coding. Pairs well with k9s (bound to
`Ctrl-L` in this repo's k9s config).

## Installation (macOS)

```bash
brew install stern
```

### Gotcha: Homebrew tap-trust

Newer Homebrew refuses to proceed while any *installed* tap is untrusted, so
`brew install stern` can fail with errors like:

```
Error: Refusing to load formula mongodb/brew/mongodb-database-tools from untrusted tap mongodb/brew.
```

`stern` itself is a core formula — the blocker is dependency resolution hitting
your other taps. Trust the taps you intentionally added, then retry:

```bash
brew trust bufbuild/buf derailed/k9s hashicorp/tap localstack/tap mongodb/brew
brew install stern
```

Avoid `export HOMEBREW_NO_REQUIRE_TAP_TRUST=1` — it disables the trust check
globally and Homebrew is removing it.

Verify:

```bash
which stern    # should print a path
```

If k9s still reports `exec: "stern": executable file not found in $PATH`,
relaunch k9s from a fresh terminal so it inherits the updated `PATH`.

## Best practices

### Target by selector, not pod name

Pod names churn on every rollout; labels don't. Prefer `-l`:

```bash
stern -l app=catalog -n istioinaction
```

### Bound the output

```bash
stern -l app=catalog --tail 100 --since 15m -n istioinaction
```

`--tail` caps initial lines per pod; `--since` sets the time window. Without
them stern replays the whole buffer for every matching pod.

### Pick the right container (matters on Istio meshes)

Sidecar-injected pods are `2/2` (app + `istio-proxy`), so a plain tail
interleaves envoy noise with app logs. Scope it:

```bash
stern -l app=catalog -c catalog -n istioinaction        # only the app container
stern -l app=catalog --exclude-container istio-proxy     # everything but the sidecar
```

### Filter at the source

Filter in stern rather than piping to grep — it keeps the color coding:

```bash
stern -l app=catalog -i 'ERROR|WARN'       # include / highlight matches
stern -l app=catalog -e 'health|readiness'  # exclude noise
```

### One-shot vs follow

Default follows. For a snapshot in a script use `--no-follow`. Add
`--timestamps` when correlating across pods.

### Structured output

```bash
stern -l app=catalog -o json | jq .
```

### Scope deliberately

`-A` / `--all-namespaces` is powerful but loud — reserve it for cluster-wide
hunts. Day-to-day, stay namespaced.

## k9s integration

This repo wires stern into k9s via `k9s/plugins.yaml` with two pod-scoped
bindings:

| Key | Plugin | Behavior |
|-----|--------|----------|
| `Ctrl-L` | Stern logs (no sidecar) | App logs only — runs `--timestamps --exclude-container istio-proxy`, so envoy noise is dropped on a mesh. |
| `Shift-L` | Stern logs (all containers) | Same with timestamps, but keeps every container (use when debugging `istio-proxy`). |

Both pass `$NAME -n $NAMESPACE --context $CONTEXT` for the selected pod and show
up in the `?` help view. The sidecar exclusion is harmless on non-Istio pods —
if there's no `istio-proxy` container, stern just tails what's present.

## Quick reference

| Flag | Purpose |
|------|---------|
| `-l <selector>` | Match pods by label (preferred over name) |
| `-n <ns>` / `-A` | Namespace / all namespaces |
| `--tail N` | Initial lines per pod |
| `--since 15m` | Time window |
| `-c <regex>` | Include containers matching regex |
| `--exclude-container <regex>` | Drop containers (e.g. `istio-proxy`) |
| `-i <regex>` / `-e <regex>` | Include / exclude log lines |
| `--timestamps` | Prefix timestamps |
| `--no-follow` | One-shot, then exit |
| `-o json` | Structured output |
