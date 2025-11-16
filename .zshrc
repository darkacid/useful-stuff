# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
#ZSHRC_LOAD_START_1=$EPOCHREALTIME

zstyle ':completion:::*:default' menu no select

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

bindkey '^[f' emacs-forward-word
bindkey '^[b' emacs-backward-word
unsetopt correct

alias cp='cp -i'
alias df='df -h'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias free='free -m'
alias grep='grep --colour=auto'
alias ls='ls --color=auto'
alias more='less'
alias np='nano -w PKGBUILD'
alias l='ls -lah'
alias ll='ls -lahrt'
alias rr='ranger .'
alias cat='bat -p'
alias ssa="ss -ptuln|column -t"
alias vim="nvim"
alias se='vim "$(fzf --reverse)"'
alias cd='z'
#
#if [ ! -z "$DISPLAY" ]
#then
#    setxkbmap -layout us,am,ru -variant ",phonetic-alt,phonetic"
#    setxkbmap -option 'grp:win_space_toggle'
#    xset r rate 200 50
#    setxkbmap -option caps:escape
#fi 
export EDITOR=/usr/bin/vim
export TERM=xterm-256color
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export BROWSER=google-chrome-stable


#AWS CLI autocomplete
autoload bashcompinit && bashcompinit
complete -C '/usr/local/bin/aws_completer' aws

alias kai='cd ~/src/krisp/krisp-automation-infra'
alias koi='cd ~/src/krisp/krisp-onprem-infra'
alias dcls='docker container ls -a'
alias wg2='sudo wg-quick up wg2'
alias wg1='sudo wg-quick up wg1'


export HISTSIZE=100000
eval "$(zoxide init zsh)"
GPG_TTY=$(tty)
export GPG_TTY
#
eval "$(pyenv init - zsh)"
export PATH=$PATH:~/.cargo/bin/
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

source /usr/share/nvm/init-nvm.sh

#ZSHRC_LOAD_END=$EPOCHREALTIME
#ZSHRC_LOAD_TIME=$(( ZSHRC_LOAD_END - ZSHRC_LOAD_START_1 ))
#printf "⏱️ .zshrc loaded in %.3f seconds\n" "$ZSHRC_LOAD_TIME"
