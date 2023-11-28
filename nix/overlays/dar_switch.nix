{pkgs}:
pkgs.writeScriptBin "dar-switch" ''
  nix build ${homeDirectory}/yakko_wakko#darwinConfigurations.$(hostname -s).system && ${homeDirectory}/yakko_wakko/result/sw/bin/darwin-rebuild switch --flake ${homeDirectory}/yakko_wakko
''
