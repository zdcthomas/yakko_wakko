{ pkgs, lib, ... }:

{
  programs = {
    rofi = {
      enable = true;
      theme = "gruvbox-dark-soft";
      plugins = [ pkgs.rofi-power-menu ];
      extraConfig = {
        disable-history = true;
        show-icons = true;
        terminal = "alacritty";
      };
    };
  };
}

