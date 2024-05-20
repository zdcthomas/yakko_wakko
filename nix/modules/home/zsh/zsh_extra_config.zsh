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

# zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' menu select=0 interactive
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup



zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them

# zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
# zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ':fzf-tab:*' query-string prefix first



# zstyle ':completion:*' menu select
# bindkey '^[[Z' reverse-menu-complete

# Future proof against OSX breakage
if ! nix_loc="$(type -p nix)" || [[ -z $nix_loc ]]; then
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
