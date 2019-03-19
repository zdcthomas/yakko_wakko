shopt -s checkwinsize
alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
alias la='ls -la'

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
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=/usr/local/bin:$PATH
eval "$(rbenv init -)"
eval "$(pyenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
