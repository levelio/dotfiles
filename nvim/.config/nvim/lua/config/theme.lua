local M = {}

local styles = { "night", "moon", "storm", "day" }

local function current_tokyonight_style()
  local name = vim.g.colors_name or ""
  local style = name:match("^tokyonight%-(.+)$")
  return style or "night"
end

function M.cycle_tokyonight()
  local current = current_tokyonight_style()
  local index = vim.fn.index(styles, current)
  local next_style = styles[(index + 1) % #styles + 1]

  vim.cmd.colorscheme("tokyonight-" .. next_style)
  vim.notify("TokyoNight: " .. next_style, vim.log.levels.INFO, { title = "Theme" })
end

return M
