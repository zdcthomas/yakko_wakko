{ pkgs, }:

[
  (
    pkgs.writeScriptBin "dot-switch" ''
      home-manager switch --flake ${config.home.homeDirectory}/yakko_wakko#$USER $@
    ''
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

  (
    pkgs.writeScriptBin "dot-update" ''
      nix flake update
    ''
  )

  (
    pkgs.writeScriptBin "dot-edit" ''
      nvim ${config.home.homeDirectory}/yakko_wakko/home.nix
    ''
  )
]
