{ config, username, modulesPath, pkgs, overlays, lib, inputs, ... }:
{

  stateVersion = "23.05";
  home = {
    username = username;
    homeDirectory = "/home/${username}"
  };
  home = {
    packages = with pkgs; [
      ffmpeg
      firefox
      lshw
      beets
      nodejs-18_x
      soulseekqt
      /* expressvpn */
    ];

    file = {
      ".config/beets/config.yaml".source = ../config/beets/config.yaml;
    };
  };



}
