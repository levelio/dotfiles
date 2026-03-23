# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a Stow package:

```text
doom/.config/doom/...
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
stow doom
```

That will create:

```text
~/.config/doom -> ~/dotfiles/doom/.config/doom
```

## Common Commands

Install a package:

```bash
stow doom
```

Restow after edits:

```bash
stow --restow doom
```

Remove symlinks for a package:

```bash
stow --delete doom
```

Install multiple packages:

```bash
stow doom zsh git
```

## Workflow

- Keep commits scoped to one tool or one purpose.
- Use package names that match the app or tool being configured.
- Put app configs under `.config/...` inside each package.
- Keep machine-specific secrets or local-only files outside this repo.

## Doom Notes

The Doom Emacs config lives in `doom/.config/doom/`.
Package-specific notes are in `doom/.config/doom/README.org`.
