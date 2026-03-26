return {
  "charludo/projectmgr.nvim",
  lazy = false, -- important!
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>pp"] = { "<Cmd>ProjectMgr<CR>", desc = "Open ProjectMgr panel" },
          },
        },
      },
    },
  },
  opts = {
    session = { enabled = true, file = ".session.vim" },
    shada = { enabled = false, file = "main.shada" },
  },
}
