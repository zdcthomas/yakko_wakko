{ config, pkgs, lib, ... }:
let cfg = config.custom.hm.rofi;
in {
  options = {
    custom.hm.rofi = { enable = lib.mkEnableOption "Enable custom rofi"; };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ rofi-power-menu ];
    programs = {
      rofi = {
        package = pkgs.rofi-wayland;
        enable = true;
        theme = "gruvbox-dark-soft";
        plugins = [ pkgs.rofi-power-menu ];
        font = "FiraCode";
        extraConfig = {
          disable-history = true;
          show-icons = true;
          terminal = "alacritty";
        };
      };
    };
  };
}
