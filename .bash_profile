export PATH=/usr/local/bin:$PATH
eval "$(rbenv init -)"
export PS1="\w> \e[m"
alias gitsave="git commit -v -a"
shopt -s checkwinsize
alias bye="rm -rf"
alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'


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
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
