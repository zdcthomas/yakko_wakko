{pkgs}: {}
# pkgs.writeShellScriptBin "dar-switch" ''
#   if [ -z "$1" ]; then
#     echo "using configuration $1"
#     nix build ${homeDirectory}/yakko_wakko#darwinConfigurations.$1.system && ${homeDirectory}/yakko_wakko/result/sw/bin/darwin-rebuild switch --flake ${homeDirectory}/yakko_wakko
#   else
#     nix build ${homeDirectory}/yakko_wakko#darwinConfigurations.$(hostname -s).system && ${homeDirectory}/yakko_wakko/result/sw/bin/darwin-rebuild switch --flake ${homeDirectory}/yakko_wakko
#   fi
# ''

