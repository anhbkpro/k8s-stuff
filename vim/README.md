# vim

Version-controlled, self-contained vim setup. Clone this repo on a new machine,
run `./install.sh`, and you get the same editor everywhere — same plugins, same
mappings, same language tooling.

Built around [vim-plug](https://github.com/junegunn/vim-plug) (thoughtbot
`~/.vim/bundle` convention), tuned for a Go / Python / infra workflow.

## Quick start

```bash
cd vim
./install.sh
# open vim, then once:
vim +'Copilot setup'
```

That's it. The installer is idempotent — re-run it any time to pick up new
plugins or repair a broken setup.

## What `install.sh` does

1. **Installs CLI deps** via Homebrew: `vim`, `fzf`, `the_silver_searcher` (`ag`), `universal-ctags`.
2. **Symlinks** this repo's files into place, backing up anything real it finds
   into `~/.vim-backup-<timestamp>/` first:

   | Repo file        | Symlinked to          |
   |------------------|-----------------------|
   | `vimrc`          | `~/.vimrc`            |
   | `vimrc.bundles`  | `~/.vimrc.bundles`    |
   | `ftplugin/`      | `~/.vim/ftplugin`     |
   | `plugin/`        | `~/.vim/plugin`       |

3. **Bootstraps vim-plug** into `~/.vim/autoload/plug.vim`.
4. **Installs every plugin** headlessly (`vim +PlugInstall`) into `~/.vim/bundle`,
   including building the `fzf` binary.

Because the config is symlinked, editing files in this repo and committing them
is all you need to keep machines in sync — `git pull` on the other machine, then
`:PlugInstall` (or re-run `install.sh`).

## Layout

```
vim/
├── install.sh        # one-shot reproducible installer
├── vimrc             # main config → ~/.vimrc
├── vimrc.bundles     # plugin manifest (vim-plug) → ~/.vimrc.bundles
├── ftplugin/         # per-filetype settings (go, markdown, css, …)
└── plugin/           # ctags helper
```

Machine-specific or secret settings go in `~/.vimrc.local` (sourced at the end
of `vimrc`, never committed).

## Plugins

Declared in [`vimrc.bundles`](vimrc.bundles). Add a line, run `:PlugInstall`;
remove a line, run `:PlugClean`.

| Plugin | Purpose |
|--------|---------|
| `junegunn/fzf` + `fzf.vim` | Fuzzy finder (files, buffers, grep, history) |
| `preservim/nerdtree` | File-tree sidebar |
| `dense-analysis/ale` | Async lint + fix + LSP (gopls, ruff, …) |
| `fatih/vim-go` | Go language support (build, test, highlight) |
| `tpope/vim-fugitive` + `vim-rhubarb` | Git inside vim + GitHub `:GBrowse` |
| `janko-m/vim-test` | Run tests from the editor |
| `tpope/vim-surround` / `vim-repeat` / `vim-endwise` | Editing motions |
| `tpope/vim-eunuch` | Unix file ops (`:Move`, `:Rename`, `:SudoWrite`) |
| `tpope/vim-projectionist` | Project-aware navigation |
| `vim-scripts/tComment` | Toggle comments (`gcc`) |
| `pbrisbin/vim-mkdir` | Auto-create missing dirs on save |
| `christoomey/vim-run-interactive` | Run shell commands interactively |
| `pangloss/vim-javascript`, `elixir-lang/vim-elixir`, `vim-ruby/vim-ruby`, `tpope/vim-rails`/`vim-rake`/`vim-bundler`, `slim-template/vim-slim` | Language packs |
| `github/copilot.vim` | AI completion (`:Copilot setup` once) |

## Key mappings

Leader is `<Space>`. These are the mappings defined in [`vimrc`](vimrc).

### fzf — fuzzy finding

| Mapping | Command | Does |
|---------|---------|------|
| `Ctrl-p` | `:Files` | Find any file by fuzzy name |
| `\` | `:Ag ` | Grep file contents across the repo (then type a pattern) |

File listing and `:Ag` are powered by **The Silver Searcher** (`ag`), which
respects `.gitignore` (`$FZF_DEFAULT_COMMAND` is set to `ag` in `vimrc`). Inside
any fzf window: `Enter` opens, `Ctrl-t`/`Ctrl-x`/`Ctrl-v` open in a
tab/split/vsplit, `Tab` multi-selects, `Esc` cancels. You can also run
`:Buffers`, `:Lines`, `:History`, `:Commits` directly.

### NERDTree — file explorer

| Mapping | Does |
|---------|------|
| `<Leader>n` | Focus the tree (`:NERDTreeFocus`) |
| `Ctrl-n` | Open the tree (`:NERDTree`) |
| `Ctrl-t` | Toggle the tree (`:NERDTreeToggle`) |
| `Ctrl-f` | Reveal the current file in the tree (`:NERDTreeFind`) |

The tree also **opens automatically on startup** (`autocmd VimEnter * NERDTree`).
In the tree: `Enter` open, `s` vsplit, `i` hsplit, `t` new tab, `m` file menu
(add/move/delete/rename), `I` toggle hidden, `R` refresh, `?` help.

### Tests, linting, windows, navigation

| Mapping | Does |
|---------|------|
| `<Leader>t` / `<Leader>s` / `<Leader>l` / `<Leader>a` / `<Leader>gt` | Test file / nearest / last / suite / visit |
| `]r` / `[r` | Next / previous ALE lint error |
| `Ctrl-h` `Ctrl-j` `Ctrl-k` `Ctrl-l` | Move between split windows |
| `<Leader><Leader>` | Switch to the previously edited file |
| `<Leader>r` | Run a command in an interactive shell |
| `<Leader>ct` | Reindex ctags for the project (`plugin/ctags.vim`) |
| arrow keys | Disabled — print "Use h/j/k/l" to build muscle memory |

ALE lints on a 1s `CursorHold` (not on every keystroke) once async is available.

## Best practices baked in

- **One source of truth.** Config is symlinked from this repo, so the machine
  and the repo never drift. Commit changes; `git pull` + `:PlugInstall` on the
  next box.
- **Safe installs.** `install.sh` backs up existing real files before
  symlinking, so it never silently clobbers an existing `~/.vimrc`.
- **Separation of concerns.** Plugin list lives in `vimrc.bundles`; settings in
  `vimrc`; per-filetype rules in `ftplugin/`; host-specific bits go in the
  untracked `~/.vimrc.local` and `~/.vimrc.bundles.local`.
- **No on-disk clutter.** Backup, write-backup, and swap files are all disabled,
  so there's no `*.swp` litter in project dirs.
- **80-column guide, hybrid-free line numbers, whitespace made visible**, and
  `ag`-backed grep for day-to-day ergonomics.

## Reproducing exact versions (optional)

vim-plug tracks branches, not commits, so two installs months apart can differ.
To pin exact commits:

```vim
:PlugSnapshot ~/work/me/repos/k8s-stuff/vim/plug.snapshot.vim
```

Commit the generated `plug.snapshot.vim`. `install.sh` auto-applies it on the
next machine if present, restoring the identical commit of every plugin.

## Updating

```vim
:PlugUpdate     " update all plugins
:PlugClean      " remove plugins no longer in vimrc.bundles
:PlugUpgrade    " update vim-plug itself
```

## Troubleshooting

- **`:Files` / `:Ag` do nothing** — `fzf`/`ag` not on `PATH`. Run
  `brew install fzf the_silver_searcher` and reopen vim.
- **No system clipboard (`"+y` fails)** — macOS system vim lacks `+clipboard`.
  Use Homebrew vim: `brew install vim` (the installer does this).
- **Copilot not working** — run `:Copilot setup` and sign in.
- **Go tools missing** — run `:GoInstallBinaries` (needs Go installed).
- **Want your old config back** — it's in `~/.vim-backup-<timestamp>/`.

## Uninstall

```bash
rm ~/.vimrc ~/.vimrc.bundles ~/.vim/ftplugin ~/.vim/plugin   # remove symlinks
# restore from ~/.vim-backup-<timestamp>/ if needed
```
