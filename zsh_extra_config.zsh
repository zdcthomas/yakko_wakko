# Depends on zsh git prompt
PROMPT=$'┏╸%(?..%F{red}%?%f · )%B%~%b$(gitprompt)\n┗╸%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f '

unsetopt BEEP
setopt interactive_comments

zstyle ':completion:*' menu select
