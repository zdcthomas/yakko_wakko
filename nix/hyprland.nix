{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [
        "-Dexperimental=true"
      ];
    }))
    dunst
    libnotify
    swww
    foot

    rofi-wayland

    bemenu
    fuzzel
    tofi

  ];

}
