# Depends on zsh git prompt
PROMPT=$'┏╸%(?..%F{red}%?%f · )%B%~%b$(gitprompt)\n┗╸%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f '

unsetopt BEEP
autoload -Uz run-help
alias help='run-help'
# setopt interactive_comments


if ! nix_loc="$(type -p nix)" || [[ -z $nix_loc ]]; then
  # This means that Macos borked the nix config, we'll try to source it below
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
fi

# Future proof against OSX breakage
# zstyle ':completion:*' menu select
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
