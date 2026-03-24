# Ghostty

Ghostty terminal configuration managed with GNU Stow.

## Install

From the dotfiles repo root:

```bash
stow ghostty
```

That creates this symlink:

```text
~/.config/ghostty/config -> ~/dotfiles/ghostty/.config/ghostty/config
```

## Config Overview

The main config file lives at `.config/ghostty/config`.

Current preferences:

- Font: `JetBrainsMono Nerd Font Mono`
- Font size: `18`
- Theme: `Mathias`
- Window: maximized with light padding
- Quick terminal: top, `60%`
- Cursor: bar, no blink
- Scrollback: `10000`
- Close confirmation: disabled

Background image settings are kept in the config as commented examples.
Local wallpapers are intentionally not tracked in this repo.

## Keybinding Cheat Sheet

Leader key: `Ctrl+A`

### Splits

| Shortcut | Action |
| --- | --- |
| `Ctrl+A` `-` | Split down |
| `Ctrl+A` `\` | Split right |
| `Ctrl+A` `h` | Focus left split |
| `Ctrl+A` `j` | Focus lower split |
| `Ctrl+A` `k` | Focus upper split |
| `Ctrl+A` `l` | Focus right split |
| `Ctrl+A` `Shift+Left` | Resize split left |
| `Ctrl+A` `Shift+Right` | Resize split right |
| `Ctrl+A` `Shift+Up` | Resize split up |
| `Ctrl+A` `Shift+Down` | Resize split down |
| `Ctrl+A` `z` | Toggle split zoom |
| `Ctrl+A` `x` | Close current surface |

### Tabs

| Shortcut | Action |
| --- | --- |
| `Ctrl+A` `c` | New tab |
| `Ctrl+A` `n` | Next tab |
| `Ctrl+A` `p` | Previous tab |
| `Ctrl+A` `1` | Go to tab 1 |
| `Ctrl+A` `2` | Go to tab 2 |
| `Ctrl+A` `3` | Go to tab 3 |
| `Ctrl+A` `4` | Go to tab 4 |
| `Ctrl+A` `5` | Go to tab 5 |
| `Ctrl+A` `6` | Go to tab 6 |
| `Ctrl+A` `7` | Go to tab 7 |
| `Ctrl+A` `8` | Go to tab 8 |
| `Ctrl+A` `9` | Go to tab 9 |

## Notes

- The keybinding layout is intentionally tmux-like.
- `Ctrl+A` is used as a single leader prefix for all window-management actions.
