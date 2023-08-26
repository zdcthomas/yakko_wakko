{ config, username, modulesPath, pkgs, overlays, lib, inputs, ... }:
{

  imports = [
    ../../nix.hm/
    ../../nvim.hm/

  ];

  # stateVersion = "23.05";
  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };
  home = {
    packages = with pkgs; [
      ffmpeg
      firefox
      lshw
      neovim
      beets
      nodejs-18_x
      soulseekqt
      fzf
      /* expressvpn */
    ];

    # file = {
    #   ".config/beets/config.yaml".source = ../config/beets/config.yaml;
    # };
  };



}
