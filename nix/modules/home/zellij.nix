{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.zellij;
in {
  options = {
    custom.hm.zellij = {
      enable = lib.mkEnableOption "Enable custom zellij";
    };
  };
  config = lib.mkIf cfg.enable {
    home.file = {
      ".config/zellij/" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/zellij";
      };
    };

    programs.zellij = {
      enable = true;
      # settings = {
      #   theme = "catppuccin-mocha";
      # };
    };
  };
}
