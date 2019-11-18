shopt -s checkwinsize
alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
alias la='ls -la'
set -o vi

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

make_rails(){
  rails new $1 -T -d=postgresql --skip-turbolinks --skip-spring $2
  cd $1
  bundle add rspec-rails
  bundle add pry
  bundle add selenium
  bundle add capybara
  bundle install
  bundle update

  rails g rspec:install
  mkdir spec/features
  mkdir spec/models

  git add .
  git commit -m "Initial Commit"

  code .
}

export PS1="\w> \e[m"
alias gitsave="git commit -v -a"
alias vim='nvim'
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=/usr/local/bin:$PATH
eval "$(rbenv init -)"
eval "$(pyenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export FZF_DEFAULT_COMMAND="fd --hidden --type f"
export ERL_AFLAGS="-kernel shell_history enabled"
export NNN_TMPFILE="/tmp/nnn"
export BASH_SILENCE_DEPRECATION_WARNING=1

n()
{
        nnn "$@"

        if [ -f $NNN_TMPFILE ]; then
                . $NNN_TMPFILE
                rm -f $NNN_TMPFILE > /dev/null
        fi
}

export PATH="$HOME/.cargo/bin:$PATH"
