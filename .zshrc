### Load Oh My Zsh config
# For new installations:
#   cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc.oh-my-zsh
export ZSH_THEME="ys"
[ -f ~/.zshrc.oh-my-zsh ] && source ~/.zshrc.oh-my-zsh

export WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'

# Cont
eval "$(~/.local/bin/mise activate zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
export LC_MESSAGES=en_US.UTF-8

export HOMEBREW_NO_AUTO_UPDATE=1

# Local config
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Common shell config
[ -f ~/.sh.aliases ] && source ~/.sh.aliases
[ -f ~/.sh.functions ] && source ~/.sh.functions

# Use vim as default editor
export EDITOR=vim
