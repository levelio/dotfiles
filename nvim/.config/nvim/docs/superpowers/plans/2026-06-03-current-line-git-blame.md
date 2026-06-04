# Current Line Git Blame Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Enable VSCode GitLens-style current-line git blame in this LazyVim config.

**Architecture:** Add a focused LazyVim plugin override for `gitsigns.nvim`. Let `gitsigns.nvim` do blame lookup and virtual text rendering, and use LazyVim's existing `Snacks.toggle` convention for the `<leader>ub` toggle.

**Tech Stack:** Neovim, LazyVim, lazy.nvim plugin specs, `lewis6991/gitsigns.nvim`, `folke/snacks.nvim`, Stylua.

---

### Task 1: Add Current-Line Blame Configuration

**Files:**
- Create: `lua/plugins/git.lua`
- Test: headless Neovim Lua assertion against `lua/plugins/git.lua`

- [ ] **Step 1: Run the failing configuration check**

Run:

```bash
nvim --headless -u NONE +'lua local ok, specs = pcall(dofile, "lua/plugins/git.lua"); if not ok then vim.notify(specs, vim.log.levels.ERROR); vim.cmd("cquit 1") end; assert(specs[1][1] == "lewis6991/gitsigns.nvim"); assert(specs[1].opts.current_line_blame == true); assert(specs[1].opts.current_line_blame_opts.virt_text_pos == "eol"); assert(specs[1].opts.current_line_blame_formatter == " <author>, <author_time:%R> - <summary>"); assert(specs[2][1] == "gitsigns.nvim"); assert(type(specs[2].opts) == "function"); vim.cmd("quitall")'
```

Expected: FAIL because `lua/plugins/git.lua` does not exist yet.

- [ ] **Step 2: Create the plugin override**

Create `lua/plugins/git.lua` with:

```lua
return {
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
```

- [ ] **Step 3: Run the configuration check**

Run:

```bash
nvim --headless -u NONE +'lua local ok, specs = pcall(dofile, "lua/plugins/git.lua"); if not ok then vim.notify(specs, vim.log.levels.ERROR); vim.cmd("cquit 1") end; assert(specs[1][1] == "lewis6991/gitsigns.nvim"); assert(specs[1].opts.current_line_blame == true); assert(specs[1].opts.current_line_blame_opts.virt_text_pos == "eol"); assert(specs[1].opts.current_line_blame_formatter == " <author>, <author_time:%R> - <summary>"); assert(specs[2][1] == "gitsigns.nvim"); assert(type(specs[2].opts) == "function"); vim.cmd("quitall")'
```

Expected: PASS with exit code 0.

- [ ] **Step 4: Check Lua formatting**

Run:

```bash
stylua --check lua/plugins/git.lua
```

Expected: PASS with exit code 0. If `stylua` is unavailable, report that formatting verification could not be run.

- [ ] **Step 5: Verify full config starts**

Run:

```bash
nvim --headless +'quitall'
```

Expected: PASS with exit code 0.

- [ ] **Step 6: Commit only this feature's files**

Run:

```bash
git add lua/plugins/git.lua docs/superpowers/plans/2026-06-03-current-line-git-blame.md
git commit -m "feat: enable current line git blame"
```

Expected: Commit succeeds and unrelated existing changes remain unstaged.
