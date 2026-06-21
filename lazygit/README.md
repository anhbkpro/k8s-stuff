# lazygit

Version-controlled [lazygit](https://github.com/jesseduffield/lazygit) config.
Run `./install.sh` to install lazygit + git-delta and symlink the config into
place. Used standalone (`lazygit`) and from Neovim (`<leader>gg` in LazyVim).

## Quick start

```bash
cd lazygit
./install.sh
lazygit          # open a diff — it renders with delta
```

The installer symlinks `config.yml` to **both** locations lazygit checks on
macOS, so it works whether or not `XDG_CONFIG_HOME` is set:

- `~/Library/Application Support/lazygit/config.yml`
- `~/.config/lazygit/config.yml`

Any existing real config is backed up to `*.bak-<timestamp>` first.

## What's configured

See [`config.yml`](config.yml) — only non-defaults are set:

| Setting | Why |
|---------|-----|
| `git.pagers` → `delta --dark --paging=never` | Word-level, syntax-highlighted diffs (needs `git-delta`, installed here) |
| `os.editPreset: nvim` | `e` opens files in Neovim (jumps to the line from the staging view) |
| `gui.nerdFontsVersion: "3"` | File/branch icons (you have a Nerd Font) |
| `gui.showDivergenceFromBaseBranch: arrowAndNumber` | See ahead/behind vs base branch in the branches panel |
| `gui.filterMode: fuzzy` | `/` filters fuzzily |
| `git.parseEmoji: true` | Renders `:rocket:` → 🚀 in commit messages |
| `update.method: background` | Quiet update checks, no prompts |

## Essential keys

Panels are numbered `1`–`5`; `?` shows context help, `x` lists every action.

| Key | Action |
|-----|--------|
| `<space>` | Stage/unstage file — or `<enter>` to stage **hunks**/lines inside it |
| `c` / `C` / `A` | Commit / commit in editor / amend last commit |
| `d` | Discard (file or hunk) |
| `s` / `S` | Stash all / stash options |
| `p` / `P` | Pull / push |
| `b` (commits) | Interactive rebase: `s` squash, `f` fixup, `r` reword, `d` drop, `e` edit |
| `<ctrl+j>` / `<ctrl+k>` | Move commit down / up (reorder during rebase) |
| `C` / `V` (commits) | Cherry-pick: copy / paste commits |
| `z` / `Z` | **Undo / redo** (reflog-backed — makes rebasing safe) |
| `<leader>gg` | Open lazygit from Neovim (LazyVim) |

## Best-practice habit

Stage at the **hunk/line level** (`<enter>` into a file, `<space>` on hunks, `v`
to select lines) so each commit is small and atomic. Combined with `z` undo,
interactive rebase becomes a safe, everyday tool for cleaning up a branch before
opening a PR.

## Per-repo overrides

Drop a `.git/lazygit.yml` in a repo, or a `.lazygit.yml` in a parent directory,
to override these settings for specific projects (e.g. a different `mainBranches`
or commit-prefix pattern).
