{
  config,
  username,
  modulesPath,
  pkgs,
  overlays,
  lib,
  inputs,
  ...
}: {
  imports = [
    # ../../nix.hm
    # ../../bash.hm
    # ../../zsh.hm
    # ../../git.hm
    # ../../nvim.hm
    # ../../ssh.hm.nix
    # ../../tmux.hm
    # ../../cli.hm
    ../../modules/home
  ];

  custom.hm = {
    nvim = {
      enable = true;
      # package = pkgs.neovim-nightly;
    };

    cli.enable = true;
    fish.enable = true;
    zsh.enable = true;
    git.enable = true;
    nix.enable = true;
    tmux.enable = true;
  };

  colorScheme = inputs.nix-colors.colorSchemes.everforest;

  # stateVersion = "23.05";
  home = {
    stateVersion = "23.05";
    username = username;
    homeDirectory = "/home/${username}";
  };
  home = {
    packages = with pkgs; [
      ffmpeg
      lshw
      beets
      nodejs-18_x
      /*
      expressvpn
      */
    ];

    # file = {
    #   ".config/beets/config.yaml".source = ../config/beets/config.yaml;
    # };
  };
}
