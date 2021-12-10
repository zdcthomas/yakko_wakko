shopt -s checkwinsize
alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
alias la='ls -laFGgohq'
alias gs='git status'
alias gco='git checkout'
alias fc='. fcd'
alias reload='source ~/.bashrc'
alias ..='cd ..'
alias n='nvim'

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

git_branch() {
    # git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    git branch 2>/dev/null | grep '^*' | colrm 1 2
}

function dirty(){
	if [[ $(git status --porcelain 2> /dev/null)  ]];
		then 
			echo "*"; 
	fi
}

cyan="\[\033[36m\]"
white="\[\033[m\]"
green="\[\033[32m\]"
yellow="\[\033[33;1m\]"
in_prompt="| => "
export PS1="$cyan\u$white@$yellow \w$white \$(git_branch) \$(dirty) \n$in_prompt"
export PS2=$in_prompt
export PS2="| ?> "

export PATH=/usr/local/bin:$PATH

# export PATH="$HOME/.rbenv/bin:$PATH"
# if rbenv 2>/dev/null; then
#   eval "$(rbenv init -)"
# fi
# if pyenv 2>/dev/null; then
#   eval "$(pyenv init -)"
# fi

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

  nvim
}

source ~/.profile
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
eval "$(nodenv init -)"
