-- istio / k8s practice keymaps
-- Copy into your nvim config, e.g. ~/.config/nvim/lua/keymaps.lua
-- (or paste the block into init.lua). Then :source % or restart nvim.

local map = vim.keymap.set

-- Apply / delete the CURRENT buffer's manifest. % = current file path.
-- :w<CR> saves first so you apply what's on screen.
map("n", "<leader>ka", ":w<CR>:!kubectl apply -f %<CR>",  { desc = "kubectl apply current file" })
map("n", "<leader>kd", ":!kubectl delete -f %<CR>",        { desc = "kubectl delete current file" })

-- Apply the whole directory the current file lives in (handy for multi-manifest exercises).
map("n", "<leader>kA", ":w<CR>:!kubectl apply -f %:h<CR>", { desc = "kubectl apply file's dir" })

-- istioctl helpers on the current file / its namespace.
map("n", "<leader>ia", ":!istioctl analyze %<CR>",                { desc = "istioctl analyze current file" })
map("n", "<leader>in", ":!istioctl analyze -n default<CR>",       { desc = "istioctl analyze namespace" })

-- Quick status checks without leaving nvim (block until you press enter).
map("n", "<leader>kp", ":!kubectl get pods -o wide<CR>",   { desc = "get pods" })
map("n", "<leader>ks", ":!kubectl get svc,gateway,virtualservice,destinationrule<CR>", { desc = "get istio resources" })

-- Open a terminal split for iterative work (watches, logs, port-forwards).
map("n", "<leader>tt", ":botright split | resize 15 | term<CR>i", { desc = "terminal split" })

-- NOTE: ensure <leader> is set before this file loads, e.g.:
--   vim.g.mapleader = " "
