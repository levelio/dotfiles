# Current Line Git Blame Design

## Goal

Show git blame information after the cursor line in Neovim, similar to the inline blame shown by VSCode GitLens.

## Scope

- Enable blame only for the current cursor line.
- Do not show blame for every visible line.
- Use the existing `gitsigns.nvim` plugin that LazyVim already includes.
- Keep the change small and reversible through a normal Gitsigns toggle.

## Approach

Add a plugin override for `lewis6991/gitsigns.nvim` in the local LazyVim plugin specs. The override will enable `current_line_blame` and configure the blame virtual text to appear at end of line.

The displayed format will include the author, relative commit time, and commit summary:

```text
 author, 2 years ago - commit summary
```

## Components

- `lua/plugins/git.lua`: local LazyVim plugin override for git-related UI behavior.
- `gitsigns.nvim`: provides git attachment, blame lookup, virtual text rendering, and toggle command.

## Behavior

- In files inside a git repository, moving the cursor to a committed line shows inline blame at the end of that line.
- Uncommitted lines use Gitsigns' normal not-committed fallback.
- The built-in command `:Gitsigns toggle_current_line_blame` can turn the feature on or off.
- The keymap `<leader>ub` toggles current-line blame, matching the existing LazyVim-style `<leader>u...` toggle convention.

## Testing

- Start Neovim with this config and open a tracked file in a git repository.
- Confirm the cursor line shows virtual text blame after a short delay.
- Run `:Gitsigns toggle_current_line_blame` and confirm the inline text disappears and reappears.
- Run Stylua if the repository uses Lua formatting for changed files.
