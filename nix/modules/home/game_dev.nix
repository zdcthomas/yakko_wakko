{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.game_dev;
in {
  options = {
    custom.hm.game_dev = {
      enable = lib.mkEnableOption "Enable custom game_dev";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        aseprite
        rx
        ldtk
        godot_4
      ];
    };
  };
}
