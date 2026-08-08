-- Extra text objects layered onto LazyVim's existing mini.ai.
--
-- Adds a whole-buffer text object on `e` (mnemonic: "entire"), mirroring
-- Kana Natsuno's vim-textobj-entire — but native to mini.ai, so no extra
-- plugin (or vim-textobj-user) is needed. Works with every operator:
--   =ae  autoindent the whole file      (built-in equivalent: gg=G)
--   dae  delete the whole buffer
--   yae  yank the whole buffer
--   gcae toggle-comment the whole file  (ts-comments provides gc)
--   vae  visually select everything
--
-- `ie` trims surrounding blank lines; `ae` takes the buffer verbatim.
return {
  {
    "echasnovski/mini.ai",
    opts = function(_, opts)
      opts.custom_textobjects = opts.custom_textobjects or {}
      opts.custom_textobjects.e = function(ai_type)
        local last = vim.fn.line("$")
        local first = 1
        if ai_type == "i" then
          -- inner: skip leading/trailing blank lines
          while first < last and vim.fn.getline(first):match("^%s*$") do
            first = first + 1
          end
          while last > first and vim.fn.getline(last):match("^%s*$") do
            last = last - 1
          end
        end
        return {
          from = { line = first, col = 1 },
          to = { line = last, col = math.max(vim.fn.getline(last):len(), 1) },
        }
      end
    end,
  },
}
