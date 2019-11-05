alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
if type -q exa
  alias la='exa -la'
else
  alias la='ls -la'
end
alias l="ls -laFGgohq"
alias fsh='vim ~/.config/fish/'
alias vrc='vim ~/.vim/settings/'
alias tmc='vim ~/.tmux.conf'
alias gco='git checkout'
alias gs='git status'
alias ga='git add'
alias t='todolist'
alias nats="docker run -d -p 4222:4222 -p 6222:6222 -p 8222:8222 nats:latest"
alias vim=nvim
alias fuck_pg='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias fm='fzf | xargs rm -rfi'
status --is-interactive; and source (rbenv init -|psub)
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (nodenv init -|psub)

set fish_user_paths (npm bin)
set -x ERL_AFLAGS "-kernel shell_history enabled"
set -Ux FZF_DEFAULT_COMMAND "fd --hidden --type f"
set -Ux TERM "xterm-256color"
export NNN_TMPFILE="/tmp/nnn"
set -Ux EDITOR vim
set PATH $HOME/.cargo/bin $PATH
export NNN_USE_EDITOR=1
fish_user_key_bindings
fish_vi_key_bindings

direnv hook fish | source 

function fco -d "Fuzzy-find and checkout a branch"
  git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
end

function fc
  set ol_dir (pwd)
  cd
  if set destination (fd -t d | fzf --preview 'tree -aCt {}' --reverse --margin=7%)
    cd $destination
  else
    cd $ol_dir
  end
end 

function dev
  set ol_dir (pwd)
  cd
  if count $argv > /dev/null
    cd dev
    git clone $argv
    cd (echo $argv | awk -F "/" '{print $NF}' | sed 's/\.git//')
    bash ~/yakko_wakko/dev_tmux.sh
  else if set destination (fd -t d | fzf --preview 'tree -aCt {}' --reverse --margin=7%)
    cd $destination
    bash ~/yakko_wakko/dev_tmux.sh
  end
  cd $ol_dir
end


function circle
	set org_and_repo (git remote -v | grep push | awk '{print $2}' | sed 's/\.git//g' | sed 's/.*\.com\///g')
  set branch (git branch | grep \* | cut -d ' ' -f2)
  open https://circleci.com/gh/"$org_and_repo"/tree/"$branch"
end
