autoload -U compinit promptinit colors
compinit
promptinit
colors

# Show git branch and status in zsh
source ~/.zsh/git-prompt/zshrc.sh


# Prompt
PROMPT="[%n@%m %{$fg[green]%}%~%{$reset_color%}]$ "
RPROMPT='%B%b$(git_super_status) '


# Zsh settings
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors 'exfxcxdxbxegedabagacad'
#setopt completealiases
setopt HIST_IGNORE_DUPS
source /usr/share/doc/pkgfile/command-not-found.zsh


# Private SSH server, sorry, but you don't need this
source ~/.zsh/ssh.sh
alias $SSH_ALIAS="ssh -fND 7777 $SSH_USER@$SSH_SERVER"


# Aliases
alias ls='ls --color=auto'
alias vnc="dbus-launch vncserver -geometry 1920x1080 :1"
alias sudo="nocorrect sudo"
alias yolo="sudo pacman -Syu"


# Exports
export EDITOR=vim
export BROWSER=firefox


# Key bindings

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
