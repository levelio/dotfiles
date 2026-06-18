return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,
          },
          grep = {
            hidden = true,
          },
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
        icons = {
          files = {
            enabled = true,
          },
        },
      },
      terminal = {
        win = {
          position = "float",
          border = "rounded",
          width = 0.9,
          height = 0.9,
        },
      },
    },
  },
}
