return {
  "akinsho/git-conflict.nvim",
  lazy = true,
  event = "BufReadPost",
  opts = {},
  keys = {
    { "<leader>gx", "<cmd>GitConflictListQf<cr>", desc = "List git conflicts" },
  },
}
