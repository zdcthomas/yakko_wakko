{
  config,
  modulesPath,
  pkgs,
  overlays,
  lib,
  inputs,
  ...
}: let
  management_scripts = import ../../nix_management_scripts_pkgs.nix {
    pkgs = pkgs;
    homeDirectory = config.home.homeDirectory;
  };
in {
  fonts.fontconfig.enable = true;
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../modules/home
    ../../bash.hm
    ../../cli.hm
    ../../hyprland.hm
    ../../kitty.hm
    ../../ssh.hm.nix
    ../../zathura.hm
    ../../zsh.hm
  ];

  # colorScheme = inputs.nix-colors.colorSchemes.everforest;
  # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
  # colorScheme = inputs.nix-colors.colorSchemes.chalk;
  # colorScheme = inputs.nix-colors.colorSchemes.rose-pine;
  # colorScheme = inputs.nix-colors.colorSchemes.windows-95;
  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-light-soft;
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-soft;
  custom.hm = {
    git.enable = true;
    tmux.enable = true;
    nix.enable = true;
    wezterm.enable = true;
    fish.enable = true;
    nvim = {
      enable = true;
    };
    firefox = {
      enable = true;
      bookmarks = [
        {
          name = "github";
          tags = ["git"];
          keyword = "git";
          url = "https://github.com";
        }
        {
          name = "example nixos configurations";
          tags = ["nixos" "nix"];
          keyword = "example config";
          url = "https://nixos.wiki/wiki/Configuration_Collection";
        }

        {
          name = "hyprland wiki";
          tags = ["wiki" "hyprland"];
          keyword = "hyprland";
          url = "https://wiki.hyprland.org/";
        }
        {
          name = "wikipedia";
          tags = ["wiki"];
          keyword = "wiki";
          url = "https://en.wikipedia.org";
        }

        {
          name = "i3 docs";
          tags = ["i3"];
          keyword = "i3";
          url = "https://i3wm.org/docs/user-contributed/lzap-config.html";
        }
        {
          name = "News";
          toolbar = true;
          bookmarks = [
            {
              name = "Hacker News";
              tags = ["news" "tech"];
              url = "https://news.ycombinator.com/";
            }
            {
              name = "Lobsters";
              tags = ["news" "tech"];
              url = "https://lobste.rs";
            }
          ];
        }
        {
          name = "Nix sites";
          toolbar = true;
          bookmarks = [
            {
              name = "Packages search";
              tags = ["search" "nix"];
              url = "https://search.nixos.org/packages";
            }
            {
              name = "Options search";
              tags = ["search" "nix"];
              url = "https://search.nixos.org/options";
            }
            {
              name = "Home Manager Appendix";
              tags = ["wiki" "nix"];
              url = "https://nix-community.github.io/home-manager/options.html";
            }
            {
              name = "wiki";
              tags = ["wiki" "nix"];
              url = "https://nixos.wiki/";
            }
          ];
        }
      ];
    };
  };
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
    /*
    stateVersion = "22.05";
    */

    /*
    extraOutputsToInstall = [ "man" ];
    */
    packages = with pkgs; [
      # bash
      # feh
      # texlive.combined.scheme-basic

      # music
      alda # music programming lang
      lenmus # music theory learning
      sonic-pi # live music env in python
      kord # cli for playing/analyzing chords
      denemo # write sheet music with keys
      milkytracker # tracker
      supercollider

      # hivelytracker # another one
      # helio-workstation # midi composer

      pamixer
      xfce.thunar
      aseprite
      rx
      godot_4
      sass
      ags
      eza
      texlive.combined.scheme-full
      zathura
      bashInteractive
      font-awesome_5
      gnumake
      nix-init
      nurl
      weechat
      openssh

      calibre
      jp2a
      vhs
      # slides
      gum

      # minecraft
      (prismlauncher.override {
        jdks = with pkgs; [
          # Java 8
          temurin-jre-bin-8
          zulu8
          # Java 11
          temurin-jre-bin-11
          # Java 17
          temurin-jre-bin-17
          # Latest
          temurin-jre-bin
          zulu
          graalvm-ce
        ];
      })

      # rnix-lsp
      pavucontrol
      cava
      imv

      # xdg-utils
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

    /*
     symlink the config directory. I know this isn't the nix way, but it's
    * ridiculous to invent another layer of rconfiguration languages
    */
    file = {
      ".config/zk/" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/zk";
      };
      /*
      ".tmux.conf".source = ./tmux.conf;
      */
      ".config/dmux/dmux.conf.toml".source = ../../../config/dmux/dmux.conf.toml;
      ".boxes".source = ../../../config/boxes/.boxes;
    };

    keyboard = {
      # variant = "colemak";
      layout = "us";
      options = ["caps:escape"];
    };
  };

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    qutebrowser = {
      enable = true;
    };
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
  services = {
    blueman-applet.enable = true;
  };
}
