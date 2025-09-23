{ pkgs, homeDirectory, }:
[
  (pkgs.lib.mkIf pkgs.stdenv.isDarwin (pkgs.writers.writeBashBin "dar-switch" ''
    echo $1
    if [ $1 ]; then
      echo "using configuration $1"
      nix build "/Users/zdcthomas/yakko_wakko#darwinConfigurations.$1.system" && /Users/zdcthomas/yakko_wakko/result/sw/bin/darwin-rebuild switch --flake /Users/zdcthomas/yakko_wakko
    else
      echo "using configuration for $(hostname -s)"
      nix build "/Users/zdcthomas/yakko_wakko#darwinConfigurations.$(hostname -s).system" && /Users/zdcthomas/yakko_wakko/result/sw/bin/darwin-rebuild switch --flake /Users/zdcthomas/yakko_wakko
    fi
  ''))
]
