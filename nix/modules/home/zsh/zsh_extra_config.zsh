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

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-min-size 50 8
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# Future proof against OSX breakage
if ! nix_loc="$(type -p nix)" || [[ -z $nix_loc ]]; then
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
