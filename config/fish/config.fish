alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'

if type -q exa
  alias la='exa -la'
  alias ls='exa -la'
else
  alias la='ls -la'
end

alias l="ls -laFGgohq"

if type -q vim
  alias fsh='vim ~/.config/fish/'
  alias vrc='vim ~/.vim/settings/'
  alias tmc='vim ~/.tmux.conf'
end

if type -q git
  alias gco='git checkout'
  alias gs='git status'
  alias ga='git add'
end

if type -q todolist
  alias t='todolist'
end

if type -q docker
  alias nats="docker run -d -p 4222:4222 -p 6222:6222 -p 8222:8222 nats:latest"
end

if type -q nvim
  alias vim=nvim
  alias vimdiff="nvim -d"
end

if type -q pg_ctl
  alias fuck_pg='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
end

# if type -q fzf
#   alias fm='fzf | xargs rm -rfi'
# end

if type -q rbenv
  status --is-interactive; and source (rbenv init -|psub)
end

if type -q pyenv
  status --is-interactive; and source (pyenv init -|psub)
end

if type -q nodenv
  status --is-interactive; and source (nodenv init -|psub)
end

if type -q npm
  set fish_user_paths (npm bin)
end

if type -q navi
  source (navi widget fish)
end

set -x ERL_AFLAGS "-kernel shell_history enabled"
set -Ux FZF_DEFAULT_COMMAND "fd --hidden --type f"
set -Ux FZF_DEFAULT_OPTS "--height 40%"
set -Ux TERM "xterm-256color"
export NNN_TMPFILE="/tmp/nnn"
set -Ux EDITOR nvim
set -Ux VISUAL nvim
set PATH $HOME/.cargo/bin $PATH

direnv hook fish | source 

function fco -d "Fuzzy-find and checkout a branch"
  git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
end

function fc
  if count $argv > /dev/null
    echo $argv
    set searchable_area $argv
  end
    set ol_dir (pwd)
    cd $searchable_area
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
