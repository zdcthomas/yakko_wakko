{ pkgs, homeDirectory }:
[
  (pkgs.lib.mkIf pkgs.stdenv.isDarwin (
    pkgs.writers.writeBashBin "dar-switch" ''
      echo $1
      # --out-link pins the symlink next to the flake. Without it, nix build
      # drops ./result into whatever directory this runs from, and the sudo
      # step below reads a stale one.
      if [ $1 ]; then
        echo "using configuration $1"
        nix build --out-link /Users/zdcthomas/yakko_wakko/result "/Users/zdcthomas/yakko_wakko#darwinConfigurations.$1.system" && sudo /Users/zdcthomas/yakko_wakko/result/sw/bin/darwin-rebuild switch --flake /Users/zdcthomas/yakko_wakko
      else
        echo "using configuration for $(hostname -s)"
        nix build --out-link /Users/zdcthomas/yakko_wakko/result "/Users/zdcthomas/yakko_wakko#darwinConfigurations.$(hostname -s).system" && sudo /Users/zdcthomas/yakko_wakko/result/sw/bin/darwin-rebuild switch --flake /Users/zdcthomas/yakko_wakko
      fi
    ''
  ))
]
