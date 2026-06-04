return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
      },
      file_panel = {
        listing_style = "tree",
        win_config = {
          position = "left",
          width = 40,
        },
      },
      keymaps = {
        view = {
          q = "<cmd>DiffviewClose<cr>",
          gq = "<cmd>DiffviewClose<cr>",
          ["<leader>e"] = "<cmd>DiffviewFocusFiles<cr>",
          ["<leader>b"] = "<cmd>DiffviewToggleFiles<cr>",
        },
        file_panel = {
          q = "<cmd>DiffviewClose<cr>",
          gq = "<cmd>DiffviewClose<cr>",
        },
        file_history_panel = {
          q = "<cmd>DiffviewClose<cr>",
          gq = "<cmd>DiffviewClose<cr>",
        },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View" },
      { "<leader>gD", "<cmd>DiffviewOpen -- %<cr>", desc = "Diff Current File" },
      { "<leader>gS", "<cmd>DiffviewOpen --staged<cr>", desc = "Diff Staged" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Diff File History" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diff View" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 600,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = " <author>, <author_time:%R> - <summary>",
    },
  },
  {
    "gitsigns.nvim",
    opts = function()
      Snacks.toggle({
        name = "Git Blame Line",
        get = function()
          return require("gitsigns.config").config.current_line_blame
        end,
        set = function(state)
          require("gitsigns").toggle_current_line_blame(state)
        end,
      }):map("<leader>ub")
    end,
  },
}
