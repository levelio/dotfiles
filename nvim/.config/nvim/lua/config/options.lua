-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_ts_lsp = "vtsls"
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

vim.g.lazyvim_eslint_auto_format = true
vim.g.lazyvim_prettier_needs_config = false

-- Neovide (GUI) runtime options. These only apply when Neovim runs inside
-- Neovide; in a regular terminal vim.g.neovide is unset, so nothing happens.
-- Docs: https://neovide.dev/configuration.html
if vim.g.neovide then
  -- Live font (config.toml also sets this; guifont wins at runtime and makes
  -- Cmd +/- zoom actually change the size). Format: "Family:h<size>".
  vim.o.guifont = "JetBrainsMono Nerd Font Mono,Noto Sans CJK SC:h16"

  -- A little breathing room around the grid feels nicer in a native GUI window.
  vim.g.neovide_padding_top = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_right = 8
  vim.g.neovide_padding_left = 8

  -- Smooth animations (seconds). 0 disables each effect.
  vim.g.neovide_cursor_animation_length = 0.08
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_scroll_animation_far_lines = 1

  -- Subtle cursor trail. 0 = no trail; larger = longer smear.
  vim.g.neovide_cursor_trail_size = 0.4

  -- Keep the pointer out of the way while typing.
  vim.g.neovide_hide_mouse_when_typing = true

  -- Floating-window glass: blur + drop shadow (needs multigrid, on by default).
  vim.g.neovide_floating_blur = true
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 8

  -- Remember the window size across launches.
  vim.g.neovide_remember_window_size = true

  -- Treat the LEFT Option key as Meta so <M-...> mappings reach Neovim; leave
  -- the right Option key free for typing accented characters. Set to false
  -- (or remove) if you never use Option-based mappings.
  vim.g.neovide_input_macos_alt_key_is_meta = "only_left"

  -- Window transparency (1.0 = opaque, <1.0 = see-through). Requires a macOS
  -- compositor. Also set tokyonight `transparent = true` for a clean blend.
  -- vim.g.neovide_transparency = 0.9
end
