{ pkgs, homeDirectory }:

[
  (
    pkgs.writeScriptBin "dot-switch" ''
      home-manager switch --flake ${homeDirectory}/yakko_wakko#$USER $@
    ''
  )

  (
    pkgs.writeScriptBin "dar-switch" ''
      nix build ${homeDirectory}/yakko_wakko#darwinConfigurations.Prime.system && ${homeDirectory}/yakko_wakko/result/sw/bin/darwin-rebuild switch --flake ${homeDirectory}/yakko_wakko
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

