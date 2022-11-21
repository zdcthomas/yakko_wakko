{ pkgs, homeDirectory }:

[
  (
    pkgs.writeScriptBin "dot-switch" ''
      nix build --no-link ${homeDirectory}/yakko_wakko#homeConfigurations.$USER.activationPackage
      "$(nix path-info ${homeDirectory}/yakko_wakko#homeConfigurations.$USER.activationPackage)"/activate
    ''
  )

  (
    pkgs.writeScriptBin "dar-switch" ''
      nix build ${homeDirectory}/yakko_wakko#darwinConfigurations.$(hostname -s).system && ${homeDirectory}/yakko_wakko/result/sw/bin/darwin-rebuild switch --flake ${homeDirectory}/yakko_wakko
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

  (pkgs.writeScriptBin "os-switch" ''
    sudo nixos-rebuild switch --flake ~/yakko_wakko/
  '')
]

