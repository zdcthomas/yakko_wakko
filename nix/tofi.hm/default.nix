{
  pkgs,
  config,
  lib,
  ...
}: let
  col =
    lib.attrsets.mapAttrs
    (name: value: ("#" + value))
    config.colorScheme.colors;
  templateFile = import ../templateFile.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [
    tofi
  ];

  home.file = {
    ".config/tofi/tofi.launcher.conf" = {
      source = templateFile "tofi.launcher.conf" ./tofi.launcher.conf col;
    };
  };
}
