export ERL_AFLAGS="-kernel shell_history enabled"
export TERM="xterm-256color"
export NNN_TMPFILE="/tmp/nnn"

export FZF_ALT_C_COMMAND="fd -t d"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_CTRL_T_OPTS="--preview '(bat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_DEFAULT_COMMAND="fd --hidden --type f"
export FZF_DEFAULT_OPTS="--height 40%"

SKIM_DEFAULT_COMMAND="fd --hidden --type f"

export MANPAGER="nvim -c 'set ft=man' -"
export EDITOR="nvim"
export GIT_EDITOR=nvim
export VISUAL="nvim"
export DIFFPROG="nvim -d"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.mix/escripts:$PATH"
