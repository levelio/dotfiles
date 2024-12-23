# zsh config
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# aliases
alias vim="nvim"
alias vi="nvim"
alias gg="lazygit"
alias nvcf="nvim ~/.config/nvim"
alias cm="chezmoi"
alias cma="chezmoi add"
alias cme="chezmoi edit --apply"
alias cmap="chezmoi apply"
alias cmdiff="chezmoi diff"
alias cmcd="chezmoi cd"
alias ls="exa"
alias ll="exa -l"
alias la="exa -la"

# rust proxy
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

# nodejs > 16 legeacy ssl
# export NODE_OPTIONS=--openssl-legacy-provider

# fnm env
eval "$(fnm env --use-on-cd)"

## ========== PATH ========== ##
# pnpm
export PNPM_HOME="/Users/zhiqiang/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="$HOME/.local/bin:$PATH"
# DOOM Emacs
export PATH="$HOME/.config/emacs/bin:$PATH"
# homebrew
export PATH="/opt/homebrew/bin:$PATH"
# ggrep
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"

