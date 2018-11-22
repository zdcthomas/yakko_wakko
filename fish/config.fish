alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
alias la='ls -la'
alias l="ls -laFGgohq"
alias fsh='vim ~/.config/fish/'
alias vrc='vim ~/.vimrc'
alias tmc='vim ~/.tmux.conf'
alias gco='git checkout'
alias less='less -N'

set homebrew /usr/local/bin /usr/local/sbin

set PATH $HOME/.rbenv/bin $PATH
set PATH $HOME/.rbenv/shims $PATH
rbenv rehash >/dev/null ^&1
