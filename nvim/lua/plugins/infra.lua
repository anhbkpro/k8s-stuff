-- Custom tweaks for a Go / infra (Kubernetes, Terraform) workflow.
-- The lang extras in lua/config/lazy.lua already wire up LSP, formatters,
-- linters and DAP. This file just guarantees a few treesitter parsers and
-- shows the LazyVim override pattern.
return {
  -- Make sure these parsers are always installed (extends, doesn't overwrite).
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gosum",
        "gowork",
        "hcl",
        "terraform",
        "yaml",
        "dockerfile",
        "bash",
        "json",
        "jsonc",
        "markdown",
        "markdown_inline",
      })
    end,
  },
}
