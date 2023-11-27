{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.hammerspoon;
in {
  options = {
    custom.hm.hammerspoon = {
      enable = lib.mkEnableOption "Enable custom hammerspoon";
    };
  };
  config = lib.mkIf (cfg.enable
    && pkgs.stdenv.isDarwin) {
    # TODO two files
    home.file.hammerspoon = {
      target = ".hammerspoon/";
      source = ../../../config/hammerspoon;
      recursive = true;
    };
  };
}
