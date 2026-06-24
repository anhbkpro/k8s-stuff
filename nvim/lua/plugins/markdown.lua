-- Better Markdown viewing.
-- markdown + markdown_inline parsers are already ensured in infra.lua, so both
-- plugins below have what they need from treesitter.
return {
  -- In-buffer rendering: headings, code blocks, tables, callouts, checkboxes,
  -- bullets — all drawn inline, no leaving the editor.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
      heading = { sign = false },
      code = { width = "block", left_pad = 2, right_pad = 2 },
      checkbox = { enabled = true },
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render" },
    },
  },

  -- Live browser preview (real HTML, auto-syncs on save/scroll).
  -- Build from source with yarn — the prebuilt-binary path (mkdp#util#install)
  -- breaks on newer Node (missing 'tslib'); installing app deps avoids that.
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npx --yes yarn install",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown browser preview" },
    },
    config = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = "dark"
    end,
  },
}
