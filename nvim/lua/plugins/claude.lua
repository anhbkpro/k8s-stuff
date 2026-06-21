-- Claude Code IDE integration (https://github.com/coder/claudecode.nvim).
-- Connects nvim to the Claude Code CLI over the same WebSocket/MCP protocol as
-- the official VS Code extension: real-time selection context + native diffs.
--
-- Requires the CLI:  npm install -g @anthropic-ai/claude-code
--                    (or: curl -fsSL claude.ai/install.sh | bash)
-- nvim/install.sh installs it for you.
--
-- Owns the <leader>a prefix. Copilot inline (ai.copilot) lives on <M-]> and does
-- not conflict. Don't enable ai.copilot-chat / ai.sidekick alongside this.
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    opts = {
      -- Anchor Claude's working dir to the git repo, not the buffer's cwd.
      git_repo_cwd = true,
    },
    -- stylua: ignore
    keys = {
      { "<leader>a", nil, desc = "+ai (Claude)" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file to Claude",
        ft = { "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff review: accept (or :w) / reject (or :q)
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Reject Claude diff" },
    },
  },
}
