# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a Stow package:

```text
nvim/.config/nvim/...
alacritty/.config/alacritty/...
zellij/.config/zellij/...
```

More packages can be added later, for example:

```text
zsh/.zshrc
git/.gitconfig
kitty/.config/kitty/kitty.conf
```

## Setup

Clone this repo to `~/dotfiles`, then use `stow` from the repo root:

```bash
brew install stow
cd ~/dotfiles
stow nvim alacritty zellij
```

That will create:

```text
~/.config/nvim -> ~/dotfiles/nvim/.config/nvim
~/.config/alacritty -> ~/dotfiles/alacritty/.config/alacritty
~/.config/zellij -> ~/dotfiles/zellij/.config/zellij
```

## Common Commands

Install a package:

```bash
stow alacritty
```

Restow after edits:

```bash
stow --restow alacritty
```

Remove symlinks for a package:

```bash
stow --delete alacritty
```

Install multiple packages:

```bash
stow nvim alacritty zellij
```

## Workflow

- Keep commits scoped to one tool or one purpose.
- Use package names that match the app or tool being configured.
- Put app configs under `.config/...` inside each package.
- Keep machine-specific secrets or local-only files outside this repo.
