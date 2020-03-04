shopt -s checkwinsize
alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
alias la='ls -laFGgohq'
alias gs='git status'
alias gco='git checkout'
alias fco='git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"'
alias res='source ~/.bash_profile'
alias ..='cd ..'
set -o vi

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

# export PS1='\[\033[36m\]\u\[\033[m\]@\[\033[32m\] \e[38;5;211m$(shortwd)\e[38;5;48m $(git_branch)\e[0m$\n| => '
 # PS1
# export PS1=
cyan="\[\033[36m\]"
white="\[\033[m\]"
green="\[\033[32m\]"
yellow="\[\033[33;1m\]"
in_prompt="| => "
export PS1="$cyan\u$white@$yellow \w$white \$(git_branch) \$(dirty) \n$in_prompt"
export PS2=$in_prompt
export PS2="| ?> "

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
# thanks apple
export BASH_SILENCE_DEPRECATION_WARNING=1

n()
{
        nnn "$@"

        if [ -f $NNN_TMPFILE ]; then
                . $NNN_TMPFILE
                rm -f $NNN_TMPFILE > /dev/null
        fi
}

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
export PATH="$HOME/.cargo/bin:$PATH"
