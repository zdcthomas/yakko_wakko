{ config
, pkgs
, username
, inputs
, ...
}:
let
  # user_name = "zacharythomas";
  management_scripts = import ../../nix_management_scripts_pkgs.nix {
    pkgs = pkgs;
    homeDirectory = config.home.homeDirectory;
  };
in
{
  imports = [
    ../../modules/home
  ];
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-soft;
  custom.hm = {
    nvim.enable = true;
    bash.enable = true;
    cli.enable = true;
    fish.enable = true;
    git.enable = true;
    kitty.enable = true;
    nix.enable = true;
    alacritty.enable = true;
    ssh.enable = true;
    tmux.enable = true;
    firefox = {
      enable = true;
      bookmarks = [
        {
          name = "github";
          tags = [ "git" ];
          keyword = "git";
          url = "https://github.com";
        }
        {
          name = "hey";
          tags = [ "email" "hey" ];
          keyword = "hey";
          url = "https://app.hey.com/";
        }
        {
          name = "example nixos configurations";
          tags = [ "nixos" "nix" ];
          keyword = "example config";
          url = "https://nixos.wiki/wiki/Configuration_Collection";
        }

        {
          name = "hyprland wiki";
          tags = [ "wiki" "hyprland" ];
          keyword = "hyprland";
          url = "https://wiki.hyprland.org/";
        }
        {
          name = "wikipedia";
          tags = [ "wiki" ];
          keyword = "wiki";
          url = "https://en.wikipedia.org";
        }
        {
          name = "News";
          toolbar = true;
          bookmarks = [
            {
              name = "Hacker News";
              tags = [ "news" "tech" ];
              url = "https://news.ycombinator.com/";
            }
            {
              name = "Lobsters";
              tags = [ "news" "tech" ];
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
              tags = [ "search" "nix" ];
              url = "https://search.nixos.org/packages";
            }
            {
              name = "Options search";
              tags = [ "search" "nix" ];
              url = "https://search.nixos.org/options";
            }
            {
              name = "Home Manager Appendix";
              tags = [ "wiki" "nix" ];
              url = "https://nix-community.github.io/home-manager/options.xhtml";
            }
            {
              name = "wiki";
              tags = [ "wiki" "nix" ];
              url = "https://nixos.wiki/";
            }
          ];
        }
      ];
    };
    zsh.enable = true;
    font.enable = true;
    hammerspoon.enable = true;
  };
  home = {
    username = username;
    homeDirectory = "/Users/" + username;
    stateVersion = "22.05";

    packages = with pkgs;
      [
        asciinema
        deno
        dmux

        /*
          qflipper  BROKEN
        */
        du-dust
        ffmpeg_5
        flyctl
        font-awesome_5
        gnumake
        go
        graphviz
        gum
        hugo
        lua
        nix-init
        nodePackages_latest.pnpm
        nodejs-18_x
        nurl
        skim
        statix
        weechat
        zk
      ]
      ++ management_scripts;
  };
}
