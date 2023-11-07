# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
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
alias ll='ls -lah'
alias rr='ranger .'
alias cat='bat'
alias se='vim "$(fzf --reverse)"'

if [ ! -z "$DISPLAY" ]
then
    setxkbmap -layout us,am,ru -variant ",phonetic-alt,phonetic"
    setxkbmap -option 'grp:alt_shift_toggle'
    xset r rate 200 50
    setxkbmap -option caps:escape
fi 
export EDITOR=/usr/bin/vim
export TERM=xterm-256color
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export BROWSER=google-chrome-stable

source <(kubectl completion zsh)
source <(k3d completion zsh)
#export KUBECONFIG=$HOME/docs/kube-admin.conf
#alias kubectl='kubectl --kubeconfig $HOME/docs/kube-admin.conf'

#AWS CLI autocomplete
autoload bashcompinit && bashcompinit
complete -C '/usr/local/bin/aws_completer' aws

alias kubectl='\kubectl'
alias kai='cd ~/src/krisp/krisp-automation-infra'

export HISTSIZE=100000
