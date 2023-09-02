{ pkgs, homeDirectory }:

[

  (
    pkgs.writeScriptBin "dar-switch" ''
      nix build ${homeDirectory}/yakko_wakko#darwinConfigurations.$(hostname -s).system && ${homeDirectory}/yakko_wakko/result/sw/bin/darwin-rebuild switch --flake ${homeDirectory}/yakko_wakko
    ''
  )

  (
    pkgs.writeScriptBin "os-switch" ''
      sudo nixos-rebuild switch --flake ~/yakko_wakko/
    ''
  )
]

