{ config, username, modulesPath, pkgs, overlays, lib, inputs, ... }:
{

  imports = [
    ../../nix.hm
    ../../bash.hm
    ../../zsh.hm
    ../../git.hm
    ../../nvim.hm
    ../../ssh.hm.nix
    ../../tmux.hm
    ../../cli.hm
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = inputs.nix-colors.colorSchemes.everforest;

  # stateVersion = "23.05";
  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };
  home = {
    packages = with pkgs; [
      ffmpeg
      lshw
      beets
      nodejs-18_x
      /* expressvpn */
    ];

    # file = {
    #   ".config/beets/config.yaml".source = ../config/beets/config.yaml;
    # };
  };



}
