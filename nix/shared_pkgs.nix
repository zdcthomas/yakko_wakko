{ pkgs, }:

with pkgs; [

  bash
  bashInteractive
  bat
  boxes
  exa
  fd
  fish
  font-awesome_5
  fzf
  gh
  git
  graphviz
  jq
  kitty
  neovim
  nodePackages.prettier_d_slim
  ripgrep
  rustup
  silver-searcher
  statix
  tmux
  tmuxPlugins.tmux-fzf
  tree
  unzip
  vim
  zip

  (
    nerdfonts.override {
      fonts = [
        "FiraCode"
        "Meslo"
      ];
    }
  )

  (
    pkgs.writeScriptBin "roc" ''
      ~/dev/roc_playground/roc_nightly-macos_x86_64-2022-10-01-2b91154/roc $@
    ''
  )

  (
    pkgs.writeScriptBin "gfuz"
      ''
        git ls-files -m -o --exclude-standard | fzf --print0 -m -1 | xargs -0 -t -o
      ''
  )
]
