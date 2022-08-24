#!/bin/bash
# Don't sudo this script!

# sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon
# . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'

pushd ~/yakko_wakko/
nix --extra-experimental-features nix-command --extra-experimental-features flakes build .#homeConfigurations.zacharythomas.activationPackage
./result/activate -b bk
popd
