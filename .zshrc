# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
zstyle ':completion:::*:default' menu no select

bindkey '^[f' emacs-forward-word
bindkey '^[b' emacs-backward-word

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
alias ll='ls -lh'
alias rr='ranger .'
alias se='fzf --reverse'

setxkbmap -layout us,am,ru -variant ",phonetic-alt,"
setxkbmap -option 'grp:alt_shift_toggle'
xset r rate 300 50
setxkbmap -option caps:escape

export EDITOR=/usr/bin/vim
export TERM=xterm-256color
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

source <(kubectl completion zsh)
#export KUBECONFIG=$HOME/docs/kube-admin.conf
alias kubectl='kubectl --kubeconfig $HOME/docs/kube-admin.conf'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
