# nvim — LazyVim

Version-controlled [LazyVim](https://www.lazyvim.org) setup. Clone this repo on a
new machine, run `./install.sh`, and you get the same Neovim everywhere — same
plugins (pinned), same language tooling, same keymaps.

This folder **is** your Neovim config: `install.sh` symlinks it to
`~/.config/nvim`, so editing and committing files here is all it takes to keep
machines in sync.

## Quick start

```bash
cd nvim
./install.sh
nvim          # open it; let Mason finish installing LSP servers
```

`install.sh` is safe to re-run. It backs up any existing config (e.g. your old
NvChad) to `~/.config/nvim.bak-<timestamp>/` before symlinking.

## What `install.sh` does

1. **Installs CLI deps** via Homebrew: `neovim`, `ripgrep`, `fd`, `fzf`,
   `lazygit`, `node`, `tree-sitter`, plus a JetBrains Mono Nerd Font. (Go isn't
   force-installed — install it yourself for `gopls`/`delve`.) On Apple Silicon
   it prefers the native `/opt/homebrew` brew and warns if your `nvim` is an
   x86_64/Rosetta build, which would make treesitter parsers fail to load.

   > `tree-sitter` provides both `libtree-sitter.dylib` (neovim links against it)
   > and the parser-building CLI. Keep it installed — removing it breaks nvim.
2. **Backs up** `~/.config/nvim` and the `share`/`state`/`cache` dirs so LazyVim
   starts clean.
3. **Symlinks** this folder → `~/.config/nvim`.
4. **Syncs plugins** headlessly (`nvim +Lazy! sync`) and runs `:TSUpdate`.

Language servers, formatters, linters and debuggers are installed automatically
by **Mason** on first launch (driven by the enabled extras) — no extra brew
packages needed.

## Layout

```
nvim/
├── init.lua                 # entry point → require("config.lazy")
├── lua/
│   ├── config/
│   │   ├── lazy.lua         # bootstraps lazy.nvim + LazyVim + enabled extras
│   │   ├── options.lua      # your option overrides
│   │   ├── keymaps.lua      # your keymap additions
│   │   └── autocmds.lua     # your autocmd additions
│   └── plugins/
│       ├── example.lua      # inert reference (override patterns)
│       └── infra.lua        # extra treesitter parsers for Go/infra
├── stylua.toml
├── install.sh
└── lazy-lock.json           # generated on first sync — COMMIT IT to pin versions
```

## Enabled extras

Extras are imported in [`lua/config/lazy.lua`](lua/config/lazy.lua) — that file
is the source of truth (version-controlled), **not** `:LazyExtras`. Edit the
import list and restart to add or drop a language stack.

| Extra | Gives you |
|-------|-----------|
| `lang.go` | gopls, gofumpt, goimports, `nvim-dap-go` (delve), treesitter |
| `lang.terraform` | terraform-ls, tflint, HCL/terraform treesitter |
| `lang.yaml` | yaml-language-server with **SchemaStore (incl. Kubernetes)** schemas |
| `lang.docker` | dockerfile-language-server, hadolint |
| `lang.helm` | helm-ls for Helm chart templates |
| `dap.core` | nvim-dap + UI (wires up Go debugging) |
| `ai.copilot` | GitHub Copilot inline completion (ghost text) |

`lua_ls` + `lazydev` for editing this config come with LazyVim by default.

## AI assistants

Two layers, two tools — kept on separate keys so they don't clash:

- **Inline completion** → **Copilot** (`ai.copilot` extra). Ghost text as you
  type; accept/cycle with `<M-]>` / `<M-[>`. Run `:Copilot auth` once.
- **Agentic chat / edits** → **Claude Code** via
  [`claudecode.nvim`](lua/plugins/claude.lua), which connects nvim to the Claude
  Code CLI (same MCP protocol as the official VS Code extension). Owns
  `<leader>a`. The CLI is installed by `install.sh`
  (`npm i -g @anthropic-ai/claude-code`); authenticate on first `:ClaudeCode`.

| Key | Claude Code |
|-----|-------------|
| `<leader>ac` / `<leader>af` | Toggle / focus Claude |
| `<leader>as` (visual) | Send selection as context |
| `<leader>ab` | Add current buffer to context |
| `<leader>ar` / `<leader>aC` | Resume / continue session |
| `<leader>aa` / `<leader>ad` | Accept / reject a proposed diff (or `:w` / `:q`) |

Don't also enable `ai.copilot-chat` or `ai.sidekick` — all three fight over the
`<leader>a` prefix.

**Best practices:** review every proposed diff before `:w`; never send secrets
as context (k8s Secrets, `*.tfvars`, `.env`) — set Copilot content exclusions in
your GitHub org; use Copilot for boilerplate and Claude for multi-file
refactors/reasoning; and always validate AI-generated manifests
(`<leader>kn` istioctl analyze, `kubectl apply --dry-run=server`) before applying.

## Day-to-day keys

LazyVim's leader is `<Space>`. The essentials:

| Key | Does |
|-----|------|
| `<Space><Space>` | Find files (root dir) |
| `<Space>/` | Live grep (ripgrep) across the project |
| `<Space>,` | Switch buffers |
| `<Space>e` | File explorer (neo-tree) |
| `<Space>gg` | Lazygit |
| `gd` / `gr` / `K` | Go-to-definition / references / hover (LSP) |
| `<Space>ca` / `<Space>cr` | Code action / rename |
| `<Space>cf` | Format buffer |
| `<Space>cd` / `]d` `[d` | Line diagnostic / next / prev |
| `<Space>db` / `<Space>dc` | Toggle breakpoint / continue (DAP) |
| `<Space>L` | LazyVim changelog · `<Space>l` Lazy UI · `:Mason` tool manager |

Full list: press `<Space>` and wait for which-key, or see
<https://www.lazyvim.org/keymaps>.

## Reproducibility

`lazy-lock.json` pins the exact commit of every plugin. **Commit it** after the
first sync (and after any `:Lazy update`). On another machine, `install.sh` →
`Lazy! sync` restores those exact commits. This is the equivalent of a lockfile
for your editor.

```vim
:Lazy update     " update plugins (then commit the new lazy-lock.json)
:Lazy restore    " roll back to the committed lazy-lock.json
:Lazy sync       " install/clean/update to match the spec
```

## Customizing

- **Options / keymaps / autocmds** → edit the files in `lua/config/`.
- **Add or override a plugin** → drop a file in `lua/plugins/` returning a spec.
  See `example.lua` and <https://www.lazyvim.org/configuration/plugins>.
- **Add a language stack** → add a `{ import = "lazyvim.plugins.extras.lang.X" }`
  line to `lua/config/lazy.lua`.

## Migrating from NvChad

`install.sh` moved your NvChad config to `~/.config/nvim.bak-<timestamp>/` and
the plugin data to `~/.local/share/nvim.bak-<timestamp>/`. Nothing was deleted.
To pull over a custom keymap or option, copy it from the backup into the
matching file in `lua/config/`. To fully revert: remove the `~/.config/nvim`
symlink and move the backup back.

## Troubleshooting

- **Icons look like boxes** — set your terminal font to "JetBrainsMono Nerd Font".
- **LSP not attaching** — run `:Mason`, confirm the server installed; `:LazyHealth`.
- **`incompatible architecture (have 'arm64', need 'x86_64')`** loading a parser
  — your nvim is an Intel/Rosetta build but parsers compile as native arm64. Run
  a native nvim: `eval "$(/opt/homebrew/bin/brew shellenv)" && brew install
  neovim`, confirm with `file "$(which nvim)"`, then `rm -rf
  ~/.local/share/nvim/site/parser && nvim --headless +TSUpdate +qa`.
- **`Library not loaded: libtree-sitter.*.dylib` / nvim aborts on launch** — the
  `tree-sitter` formula (which neovim links against) is missing. Fix:
  `brew reinstall tree-sitter`. Never `brew uninstall tree-sitter`.
- **Treesitter parser build errors** — ensure the `tree-sitter` CLI is on PATH
  and matches the lib (`brew install tree-sitter`), then `:TSUpdate`.
- **`:checkhealth`** — the go-to for diagnosing anything.
