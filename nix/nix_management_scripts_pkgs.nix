{ pkgs, homeDirectory }:

[
  (
    pkgs.writeScriptBin "dot-switch" ''
      home-manager switch --flake ${homeDirectory}/yakko_wakko#$USER $@
    ''
  )


  (
    pkgs.writeScriptBin "dot-update" ''
      nix flake update
    ''
  )

  (
    pkgs.writeScriptBin "dot-edit" ''
      nvim ${homeDirectory}/yakko_wakko/home.nix
    ''
  )
]
