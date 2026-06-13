# Enable powerlevel10k prompt
source ~/.local/opt/powerlevel10k/powerlevel10k.zsh-theme
source ~/.p10k.zsh

export EDITOR="nvim"
export PATH="$HOME/.local/bin:$PATH"

# Command aliases {{{

alias vim="nvim"

# Alias to edit .vimrc or .zshrc file
alias vimrc='$EDITOR ~/.vimrc'
alias initlua='nvim ~/.config/nvim/init.lua -c "cd %:h"'
alias zshrc='$EDITOR ~/.zshrc'

alias ls='ls -F --color=auto'
alias tree='tree -C'

alias q='exit'
alias c='clear'

# gt -> git log with nice graph view
alias gt='git log --graph --abbrev-commit --decorate --oneline --all'

# }}}

# configure zoxide {{{
# make it so z pythongreier changes directory to PythonGreier (and not
# pythongreier) when there is a symlink to PythonGreier in the cwd
export _ZO_RESOLVE_SYMLINKS=1
# Activate zoxide (and map the cd command to be zoxide's z command)
eval "$(zoxide init --cmd cd zsh)"
# }}}

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
# use fd for fzf
export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Share command history between terminals, ignore duplicate entries
setopt histignorealldups sharehistory
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# keep track of cd history, define aliases to view and navigate the directory stack {{{

# type only name of directory = cd into that directory (e.g. type .. to go up a dir)
setopt autocd
# automatically pushd for each cd. allows cd +1 to go back to prev. dir
setopt autopushd
# remove duplicates from directory stack
# (going back and forth between two dirs doesn't fill up the stack)
setopt pushdignoredups

# View cd history and jump to a previous directory
alias d='dirs -v | head -10'
alias +1='cd +1'
alias +2='cd +2'
alias +3='cd +3'
alias +4='cd +4'
alias +5='cd +5'
alias +6='cd +6'
alias +7='cd +7'
alias +8='cd +8'
alias +9='cd +9'

# }}}

# Use vi keybindings
bindkey -v
# enable zsh-vi-mode plugin
#source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source $HOME/.local/opt/zsh-vi-mode/zsh-vi-mode.plugin.zsh
ZVM_VI_INSERT_ESCAPE_BINDKEY=jj

# Use modern completion system {{{
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# }}}

# vim: foldmethod=marker
