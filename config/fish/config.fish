alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'

if type -q exa
  alias la='exa -la'
  alias ls='exa -la'
else
  alias la='ls -la'
end

alias l="ls -laFGghq"

if type -q vim
  alias fsh='vim ~/.config/fish/'
  alias vrc='vim ~/.vim/settings/'
  alias tmc='vim ~/.tmux.conf'
end

if type -q git
  alias gco='git switch'
  alias gs='git status'
  alias ga='git add'
  alias gap='git add --patch'
end

if type -q docker
  alias nats="docker run -d -p 4222:4222 -p 6222:6222 -p 8222:8222 nats:latest"
end

if type -q nvim
  alias vimdiff="nvim -d"
end

if type -q pg_ctl
  alias fuck_pg='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
end

if type -q rbenv
  status --is-interactive; and source (rbenv init -|psub)
end

if type -q pyenv
  status --is-interactive; and source (pyenv init -|psub)
end

if type -q nodenv
  status --is-interactive; and source (nodenv init -|psub)
  set -Ux fish_user_paths $HOME/.nodenv/bin $fish_user_paths
end

if type -q npm
  set fish_user_paths (npm bin)
end

set fish_color_command FFFFF
set fish_color_redirection FFFFF
set fish_color_end FFFFFF 
set fish_color_operator edd205
set fish_color_normal FFFFFF
set fish_color_param brgreen
if type -q direnv
  direnv hook fish | source 
end

# function fcd
#   if count $argv > /dev/null
#     echo $argv
#     set searchable_area $argv
#   end
#     set ol_dir (pwd)
#     cd $searchable_area
#     if set destination (fd -t d | fzf --preview 'tree -aCt {}' --reverse --margin=7%)
#       cd $destination
#     else
#       cd $ol_dir
#     end
# end 

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

source ~/.profile
