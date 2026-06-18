local close_diffview = "<cmd>DiffviewClose<cr>"

local function map_diffview_close(bufnr)
  for _, lhs in ipairs({ "q", "gq" }) do
    vim.keymap.set("n", lhs, close_diffview, {
      buffer = bufnr,
      desc = "Close Diff View",
      nowait = true,
      silent = true,
    })
  end
end

local function map_diffview_buffers(view)
  local tabpage = view and view.tabpage or 0

  if tabpage ~= 0 and not vim.api.nvim_tabpage_is_valid(tabpage) then
    return
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(bufnr)

    if name:match("^diffview://") then
      map_diffview_close(bufnr)
    end
  end
end

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
      hooks = {
        view_opened = map_diffview_buffers,
        view_post_layout = map_diffview_buffers,
      },
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
          q = close_diffview,
          gq = close_diffview,
          ["<leader>e"] = "<cmd>DiffviewFocusFiles<cr>",
          ["<leader>b"] = "<cmd>DiffviewToggleFiles<cr>",
        },
        diff1 = {
          q = close_diffview,
          gq = close_diffview,
        },
        diff2 = {
          q = close_diffview,
          gq = close_diffview,
        },
        diff3 = {
          q = close_diffview,
          gq = close_diffview,
        },
        diff4 = {
          q = close_diffview,
          gq = close_diffview,
        },
        file_panel = {
          q = close_diffview,
          gq = close_diffview,
        },
        file_history_panel = {
          q = close_diffview,
          gq = close_diffview,
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
