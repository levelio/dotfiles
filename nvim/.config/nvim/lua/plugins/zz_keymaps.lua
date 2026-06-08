local function move_key(keys, from, to)
  for _, key in ipairs(keys or {}) do
    if key[1] == from then
      key[1] = to
      table.insert(keys, { from, false, mode = key.mode })
      return
    end
  end
end

local function replace_key(keys, replacement)
  for index, key in ipairs(keys or {}) do
    if key[1] == replacement[1] then
      keys[index] = replacement
      return
    end
  end

  table.insert(keys, replacement)
end

local function references_key(lhs)
  return {
    lhs,
    function()
      Snacks.picker.lsp_references()
    end,
    desc = "References",
    nowait = true,
    has = "references",
  }
end

local function close_current_buffer()
  Snacks.bufdelete()
end

local function move_which_key_group(opts, from, to, group)
  local moved = false
  opts.spec = opts.spec or {}

  for _, spec in ipairs(opts.spec) do
    for _, key in ipairs(spec) do
      if type(key) == "table" and key[1] == from and key.group == group then
        key[1] = to
        moved = true
      end
    end
  end

  if not moved then
    table.insert(opts.spec, {
      mode = { "n", "x" },
      { to, group = group },
    })
  end
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>c", close_current_buffer, desc = "Close Current Buffer" },
    },
  },

  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      move_which_key_group(opts, "<leader>c", "<leader>l", "code")
      table.insert(opts.spec, {
        mode = { "n", "x" },
        { "<leader>c", desc = "Close Current Buffer" },
      })
    end,
  },

  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>cs", false },
      { "<leader>cS", false },
      { "<leader>ls", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>lS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
    },
  },

  {
    "stevearc/conform.nvim",
    keys = {
      { "<leader>cF", false, mode = { "n", "x" } },
      {
        "<leader>lF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "x" },
        desc = "Format Injected Langs",
      },
    },
  },

  {
    "mason-org/mason.nvim",
    keys = {
      { "<leader>cm", false },
      { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    keys = {
      { "<leader>cv", false, ft = "python" },
      { "<leader>lv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    keys = {
      { "<leader>cp", false, ft = "markdown" },
      { "<leader>lp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview", ft = "markdown" },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    optional = true,
    opts = function(_, opts)
      opts.server = opts.server or {}
      local on_attach = opts.server.on_attach

      opts.server.on_attach = function(client, bufnr)
        if on_attach then
          on_attach(client, bufnr)
        end

        pcall(vim.keymap.del, "n", "<leader>cR", { buffer = bufnr })
        vim.keymap.set("n", "<leader>lR", function()
          vim.cmd.RustLsp("codeAction")
        end, { desc = "Code Action", buffer = bufnr })
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keys = opts.servers["*"].keys
      replace_key(keys, references_key("gD"))
      move_key(keys, "<leader>cl", "<leader>ll")
      move_key(keys, "<leader>ca", "<leader>la")
      move_key(keys, "<leader>cc", "<leader>lc")
      move_key(keys, "<leader>cC", "<leader>lC")
      move_key(keys, "<leader>cR", "<leader>lR")
      move_key(keys, "<leader>cr", "<leader>lr")
      move_key(keys, "<leader>cA", "<leader>lA")
      move_key(keys, "<leader>co", "<leader>lo")

      local vtsls = opts.servers.vtsls
      if type(vtsls) == "table" then
        vtsls.keys = vtsls.keys or {}
        replace_key(vtsls.keys, references_key("gD"))
        move_key(vtsls.keys, "<leader>cM", "<leader>lM")
        move_key(vtsls.keys, "<leader>cD", "<leader>lD")
        move_key(vtsls.keys, "<leader>cV", "<leader>lV")
      end
    end,
  },
}
