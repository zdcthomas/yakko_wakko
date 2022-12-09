#!/usr/bin/env bash
# Don't sudo this script!

sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon
. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'

pushd ~/yakko_wakko/

if [[ "$OSTYPE" =~ "darwin" ]]; then
  nix --extra-experimental-features nix-command --extra-experimental-features flakes build .#darwinConfigurations.$(hostname -s).system && ./result/sw/bin/darwin-rebuild switch --flake . else
  echo "No known setup for non darwin env, Sorry!"
fi
# nix --extra-experimental-features nix-command --extra-experimental-features flakes build .#homeConfigurations.zacharythomas.activationPackage
# nix --extra-experimental-features nix-command --extra-experimental-features flakes build .#darwinConfigurations.$(hostname -s).system && ./result/sw/bin/darwin-rebuild switch --flake .
# ./result/activate -b bk
popd
