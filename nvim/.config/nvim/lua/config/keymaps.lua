-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
for _, key in ipairs({ "<D-s>", "<C-s>" }) do
  vim.keymap.set("n", key, "<cmd>update<cr>", { desc = "Save File" })
  vim.keymap.set("i", key, "<Esc><cmd>update<cr>a", { desc = "Save File" })
  vim.keymap.set("v", key, "<Esc><cmd>update<cr>gv", { desc = "Save File" })
  vim.keymap.set("c", key, "<C-c><cmd>update<cr>", { desc = "Save File" })
end
vim.keymap.set("n", "<leader>uT", function()
  require("config.theme").cycle_tokyonight()
end, { desc = "Cycle TokyoNight Theme" })
vim.keymap.set("i", "kj", "<Esc>", { desc = "Exit Insert Mode" })
pcall(vim.keymap.del, "n", "<leader>cd")
pcall(vim.keymap.del, { "n", "x" }, "<leader>cf")
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set({ "n", "x" }, "<leader>lf", function()
  LazyVim.format({ force = true })
end, { desc = "Format" })
vim.keymap.set("n", "<leader>lE", LazyVim.lsp.action["source.fixAll.eslint"], { desc = "ESLint Fix All" })
