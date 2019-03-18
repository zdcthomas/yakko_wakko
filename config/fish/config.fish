alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
alias la='ls -la'
alias l="ls -laFGgohq"
alias fsh='vim ~/.config/fish/'
alias vrc='vim ~/.vimrc'
alias tmc='vim ~/.tmux.conf'
alias gco='git checkout'
alias gs='git status'
alias ga='git add'
alias t='todolist'
alias nats="docker run -d -p 4222:4222 -p 6222:6222 -p 8222:8222 nats:latest"
alias vim=nvim
status --is-interactive; and source (rbenv init -|psub)
