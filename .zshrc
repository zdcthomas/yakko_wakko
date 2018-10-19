echo " ________  _________    ";
echo "|\_____  \|\___   ___\  ";
echo " \|___/  /\|___ \  \_|  ";
echo "     /  / /    \ \  \   ";
echo "    /  /_/__  __\ \  \  ";
echo "   |\________\\__\ \__\ ";
echo "    \|_______\|__|\|__| ";
echo "                        ";





alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
alias reload='source ~/.zshrc'
alias hmm='pry -r ./config/environment.rb'
alias zrc="vim ~/.zshrc"
alias l="ls -laFGgohq"
alias gco="git checkout"


function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi





for ver in $(rbenv whence yarn); do
  RBENV_VERSION="$ver" gem uninstall -ax yarn
  rm -f "$(rbenv prefix "$ver")/bin/yarn"
done

rbenv rehash

function ask(){
  read -r "response?$1 [y/N] "
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    return true
  else
    return false
  fi
}

function pr(){
  if command_exists hub; then
    read -r "response?Open pull request? [y/N] "
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
      if [ $1 -eq '-r']; then
        hub browse
      else
        hub pull-request
        read -r "response?View Github page? [y/N] "
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
          hub browse
        fi
      fi
    else 
      echo 'No pull request opened'
    fi
  else
    echo 'Hub package not found'
  fi
}

function command_exists () {
  if brew ls --versions $1 > /dev/null; then
    return true
  else
    return false
  fi
}

function push(){
  if cleanGit;then 
    run_test
    read -r "response?Still push [y/N] "
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
      echo 'pushing to... '
      echo "$(git symbolic-ref --short HEAD 2>/dev/null)"
      local remote="${1:-origin}"
      local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
      git push $remote $branch
      pr
    else
      echo 'Staying local.'
    fi
  else 
    echo 'Current branch is not clean.'
    echo 'Cannot push.'
  fi
}

function doTheRspec(){
  echo "Running Rspec."
  rspec
  if [ $? -eq 0 ]; then
    echo "Tests passing"
    return true
  else
    echo "Some tests failed"
    return false
  fi
}

function doTheNpmTest(){
  echo "Running Npm Test."
  npm test
  if [ $? -eq 0 ]; then
    echo "Tests passing"
    return true
  else
    echo "Some tests failed"
    return false
  fi
} 

function run_test(){
  echo "Attempting to find test suite."
  if [ -d spec ]; then
    echo "Framework found."
    doTheRspec
  elif [ -f 'package.json' ]; then
    echo "Framework found."
    doTheNpmTest
  else
    echo "No testing framework found. Sorry."
    return false
  fi
}

function cleanGit(){
  if output=$(git status --porcelain) && [ -z "$output" ]; then
    echo "true path"
    echo $output
    return true
  else 
    echo $output
    return false
  fi
}

function specifyDeploy(){
  local server="${1:-heroku}"
  printf '\nDo you want to deploy to '
  echo $server
  read -r "response? [y/N] "

  if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    printf "\nDeploying\n" 
    git push heroku master
  else
    printf "\nOk Cool, Currently no other deployments are supported...\nSo, bye I guess\n"
  fi
}

function deploy(){
  clear
  if [ -d .git ]; then
    echo "Switching to master"
    git checkout master
    echo "Pulling from master"
    git pull origin master
    bundle install
    bundle update

    if cleanGit; then
      if run_test; then
        read -r "response?Are you sure you want to deploy [y/N] "

        if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
          specifyDeploy $1

        else
          echo "Good Call"
          echo "Exiting."
        fi


      else 
        echo "Unable to deploy."
      fi

    else
      echo "It seems like you have uncommited changes."
      echo "Unable to deploy."
    fi
  else
    echo "I'm sorry I can't find your project."
    echo "Unable to deploy."
  fi
}

function make_rails(){
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

  vim .
}

echo "(╯°□°）╯︵ ┻━┻) "

source $HOME/.zshenv
