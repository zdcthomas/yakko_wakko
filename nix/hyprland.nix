{ pkgs, lib, inputs, config, ... }:

# https://git.sr.ht/~misterio/nix-config/tree/main/item/home/misterio/features/desktop/common/wayland-wm/waybar.nix
{
  services.mako = {
    enable = true;
    borderRadius = 10;
    defaultTimeout = 3;
  };

  home.file = {
    ".config/hypr/" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/hypr";
    };

    ".config/waybar/" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/waybar";
    };
  };

  imports = [
    ./rofi.nix
  ];
  home.packages = with pkgs; [
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [
        "-Dexperimental=true"
      ];
    }))

    hyprpicker
    inotify-tools
    dunst
    libnotify
    swww
    swayidle
    fuzzel
    tofi
    networkmanagerapplet
    swaylock
    hyprpaper
  ];
}
