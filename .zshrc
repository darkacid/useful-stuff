# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
zstyle ':completion:::*:default' menu no select

#bindkey '^[f' emacs-forward-word
#bindkey '^[b' emacs-backward-word

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

setxkbmap -layout us,am,ru -variant ",phonetic-alt,"
setxkbmap -option 'grp:alt_shift_toggle'

export EDITOR=/usr/bin/vim
export TERM=xterm-256color

source <(kubectl completion zsh)
