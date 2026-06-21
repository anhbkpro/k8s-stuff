-- Reference only: this file is inert (returns an empty spec).
-- Every file under lua/plugins/ is auto-loaded by lazy.nvim. In your own files
-- you can add plugins, disable LazyVim ones, or override their opts. See:
-- https://www.lazyvim.org/configuration/plugins
-- stylua: ignore
if true then return {} end

return {
  -- Example: switch colorscheme
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight" } },

  -- Example: add an LSP server (auto-installed via Mason)
  { "neovim/nvim-lspconfig", opts = { servers = { gopls = {} } } },
}
