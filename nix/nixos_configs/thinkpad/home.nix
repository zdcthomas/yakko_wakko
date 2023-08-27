{ config, modulesPath, pkgs, overlays, lib, inputs, ... }:

let
  management_scripts = import ../../nix_management_scripts_pkgs.nix { pkgs = pkgs; homeDirectory = config.home.homeDirectory; };
in
{
  fonts.fontconfig.enable = true;
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../alacritty.hm.nix
    ../../firefox.hm.nix
    ../../fish.hm
    ../../bash.hm
    ../../cli.hm
    ../../git.hm
    ../../hyprland.hm
    ../../kitty.hm
    ../../nix.hm
    ../../nvim.hm
    ../../ssh.hm.nix
    ../../tmux.hm
    ../../zathura.hm
    ../../zsh.hm
    # ../../neofetch
    # ../../zellij.nix
  ];
  custom.home.nvim = {
    enable = true;
  };
  colorScheme = inputs.nix-colors.colorSchemes.everforest;
  news.display = "show";
  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    /* stateVersion = "22.05"; */

    /* extraOutputsToInstall = [ "man" ]; */
    packages = with pkgs; [

      # bash
      # feh
      # texlive.combined.scheme-basic
      texlive.combined.scheme-full
      zathura
      bashInteractive
      font-awesome_5
      gnumake
      nix-init
      nurl
      weechat

      minecraft
      prismlauncher
      (
        nerdfonts.override {
          fonts = [
            "Terminus"
            "FiraCode"
            "Meslo"
            "Monofur"
            "Iosevka"
          ];
        }
      )

      # rnix-lsp
      pavucontrol
      cava
      imv

      xdg-utils
      discord
      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
      ])
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";


    /* symlink the config directory. I know this isn't the nix way, but it's
      * ridiculous to invent another layer of rconfiguration languages */
    file = {

      ".config/zk/" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/zk";
      };
      /* ".tmux.conf".source = ./tmux.conf; */
      ".config/dmux/dmux.conf.toml".source = ../../../config/dmux/dmux.conf.toml;
      ".boxes".source = ../../../config/boxes/.boxes;
    };

    keyboard = {
      # variant = "colemak";
      layout = "us";
      options = [ "caps:escape" ];
    };
  };

  programs = {
    qutebrowser = {
      enable = true;
    };
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
