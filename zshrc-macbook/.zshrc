# Custom shell prompt {{{

# Enable powerlevel10k prompt
source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme
source ~/.p10k.zsh

# Default prompt:
# export PS1='(base) %n@%m %1~ %# '

# Custom prompt:
# DIM COLOUR: %{\e[2m%}
# CURRENT DIR (using '~' to indicate home dir): %1~
# END COLOUR: %{\e[0m%}
# BLUE COLOUR: %{\e[34m%}
# literal percent sign '%': %%
#export PS1=$'%{\e[2m%}%1~%{\e[0m%} %{\e[34m%}%%%{\e[0m%} '
##            \__DIM__/dir\__END__/ \__BLUE__/ %\__END__/

# Custom prompt 2:
# Same as above except with > instead of %
export PS1=$'%{\e[2m%}%1~%{\e[0m%} %{\e[34m%}>%{\e[0m%} '

# Custom prompt 3:
# Has full working path on line above
# export PS1=$'%{\e[34m%}%{\e[2m%}  %~ %{\e[0m%}\n%{\e[34m%}>%{\e[0m%} '
# }}}

export EDITOR="nvim"

# Command aliases {{{


alias vim="nvim"

# Alias to edit .vimrc or .zshrc file
alias vimrc='$EDITOR ~/.vimrc'
alias initlua='nvim ~/.config/nvim/init.lua -c "cd %:h"'
alias zshrc='$EDITOR ~/.zshrc'

alias ls='ls -F --color=auto'
alias tree='tree -C'

# Alias to shorten python commands
# alias py='python3'
# alias python='python3'
# alias ipy='ipython -i'

alias q='exit'
alias c='clear'

# gt -> git log with nice graph view
alias gt='git log --graph --abbrev-commit --decorate --oneline --all'

alias batteryinfo='system_profiler SPPowerDataType | grep -A1 -B7 "Condition"'
lsof_volume () {"sudo lsof | grep /Volumes/$1"}

# }}}

# Aliases to stuff on my macbook {{{

alias 1024='python3.11 ~/bin/ntnu1024/administrer_kalender_ntnu.py'
alias ntnu1024='python3.11 ~/bin/ntnu1024/administrer_kalender_ntnu.py'
alias p='cd ~/Documents/PythonGreier/'

# Gimme some ideas for coding projects
alias ideer='cat ~/Documents/PythonGreier/ideer.txt'
alias ideas='cat ~/Documents/PythonGreier/ideer.txt'

# Aliases to play games :)
alias snake='python3.10 ~/Documents/PythonGreier/Snake/main.py'
alias hangman='python3 ~/Documents/PythonGreier/Hangman/main.py'
alias hypermaze='python3.10 ~/Documents/PythonGreier/HyperMaze/main.py'
alias tetrix='python3.10 ~/Documents/PythonGreier/Tetrix/main.py'
alias slidingpuzzle='python3.10 ~/Documents/PythonGreier/SlidingPuzzle/main.py'
alias quake='/Users/emiliolombardo/Applications/vkQuake/build/vkquake'
alias drench='python3 ~/Documents/PythonGreier/Diverse/drench.py'

gzdoom_app='/Applications/GZDoom.app/Contents/MacOS/gzdoom'
gzdoom_dir='/Users/emiliolombardo/Library/ApplicationSupport/gzdoom'
idkfa_wad="$gzdoom_dir/idkfa-2024.wad"
brutaldoom_args="-file $gzdoom_dir/brutalv21.pk3 -file $gzdoom_dir/Brutal_Doom_HUD_Pack_v1.5/bd21_hudpack_v1.5.pk3"
alias gzdoom=$gzdoom_app
alias brutal_DOOM="$gzdoom_app -iwad $gzdoom_dir/DOOM.WAD $brutaldoom_args -file $idkfa_wad"
alias brutal_DOOM2="$gzdoom_app -iwad $gzdoom_dir/DOOM2.WAD $brutaldoom_args -file $idkfa_wad"
alias DOOM="$gzdoom_app -iwad $gzdoom_dir/DOOM.WAD -file $idkfa_wad"
alias DOOM2="$gzdoom_app -iwad $gzdoom_dir/DOOM2.WAD -file $idkfa_wad"

alias games='echo "snake\nhangman\nhypermaze\ntetrix\nslidingpuzzle\nquake\ndrench\ngzdoom"'


# }}}

# configure zoxide {{{
# make it so z pythongreier changes directory to PythonGreier (and not
# pythongreier) when there is a symlink to PythonGreier in the cwd
export _ZO_RESOLVE_SYMLINKS=1
# Activate zoxide (and map the cd command to be zoxide's z command)
eval "$(zoxide init --cmd cd zsh)"
# }}}

# cd-shortcut: TAB on empty line {{{

first-tab() {
    if [[ $#BUFFER == 0 ]]; then
        BUFFER="cd "
        CURSOR=3
        zle list-choices
    else
        zle expand-or-complete
    fi
}
zle -N first-tab
bindkey '^I' first-tab
# }}}

# keep track of cd history, define aliases to view and navigate the directory stack {{{

# type only name of directory = cd into that directory (e.g. type .. to go up a dir)
setopt autocd
# automatically pushd for each cd. allows cd +1 to go back to prev. dir
setopt autopushd
# remove duplicates from directory stack
# (going back and forth between two dirs doesn't fill up the stack)
setopt pushdignoredups

# View cd history and jump to a previous directory
alias d='dirs -v | HEAD -10'
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

# To make FZF (fuzzy finder) work
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add ~/bin to PATH (my scripts)
PATH=$PATH:$HOME/bin
export PATH

# Homebrew stuff {{{
# Don't depend on local clone of tap
export HOMEBREW_INSTALL_FROM_API=1
# Add sbin to PATH, for Homebrew-formulae (idk)
export PATH="/usr/local/sbin:$PATH"
# }}}

# enable zsh-vi-mode plugin
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
ZVM_VI_INSERT_ESCAPE_BINDKEY=jj

# Add flutter to PATH
# export PATH=$HOME/bin/flutter/bin:$PATH

# haskell stuff
[ -f "/Users/emiliolombardo/.ghcup/env" ] && . "/Users/emiliolombardo/.ghcup/env" # ghcup-env

# Enable autocomplete
autoload -U compinit && compinit

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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# vim: foldmethod=marker


export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin
