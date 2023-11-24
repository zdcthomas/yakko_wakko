{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.hm.tofi;

  col =
    lib.attrsets.mapAttrs
    (name: value: ("#" + value))
    config.colorScheme.colors;
  templateFile = import ../../../templateFile.nix {inherit pkgs;};
in {
  options = {
    custom.hm.tofi = {
      enable = lib.mkEnableOption "Enable custom tofi";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tofi
    ];

    home.file = {
      ".config/tofi/tofi.launcher.conf" = {
        source = templateFile "tofi.launcher.conf" ./tofi.launcher.conf col;
      };
    };
  };
}
