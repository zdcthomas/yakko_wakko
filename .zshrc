echo " ________  _________    ";
echo "|\_____  \|\___   ___\  ";
echo " \|___/  /\|___ \  \_|  ";
echo "     /  / /    \ \  \   ";
echo "    /  /_/__  __\ \  \  ";
echo "   |\________\\__\ \__\ ";
echo "    \|_______\|__|\|__| ";
echo "                        ";



# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
#export ZSH="/Users/zacharythomas/.oh-my-zsh"


#this is a test


# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(
#  git
#  bundler
#  osx
#  rake
#  rbenv
#  ruby
#)
#source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
prompt_context(){}
alias gitsave="git commit -v -a"
alias bye="rm -rf"
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

