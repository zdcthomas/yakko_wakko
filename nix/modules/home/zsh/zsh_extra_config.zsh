# Depends on zsh git prompt
function sign {
  if [[ -v IN_NIX_SHELL ]]; then
    echo -n "%F{blue}n%f%F{cyan}i%f%F{green}x%f"
  else
    echo -n "%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f"
  fi
}

PROMPT=$'┏╸%(?..%F{red}%?%f · )%B%~%b$(gitprompt)\n┗╸$(sign) '

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

zstyle ':completion:*' menu select
bindkey '^[[Z' reverse-menu-complete

# Future proof against OSX breakage
if ! nix_loc="$(type -p nix)" || [[ -z $nix_loc ]]; then
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
