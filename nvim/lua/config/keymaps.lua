-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- which-key group label for the <leader>k k8s/istio prefix
local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({ { "<leader>k", group = "k8s/istio" } })
end

-- kubectl: apply / delete. % = current file, %:h = its directory. :w saves first.
map("n", "<leader>ka", ":w<CR>:!kubectl apply -f %<CR>",  { desc = "kubectl apply current file" })
map("n", "<leader>kd", ":!kubectl delete -f %<CR>",        { desc = "kubectl delete current file" })
map("n", "<leader>kA", ":w<CR>:!kubectl apply -f %:h<CR>", { desc = "kubectl apply file's dir" })

-- istioctl analyze
map("n", "<leader>kn", ":!istioctl analyze %<CR>",         { desc = "istioctl analyze current file" })
map("n", "<leader>kN", ":!istioctl analyze<CR>",           { desc = "istioctl analyze namespace" })

-- quick status checks (block until you press enter)
map("n", "<leader>kp", ":!kubectl get pods -o wide<CR>",   { desc = "get pods" })
map("n", "<leader>ks", ":!kubectl get svc,gateway,virtualservice,destinationrule<CR>", { desc = "get istio resources" })
