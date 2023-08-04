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

    ".config/tofi/" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/tofi";
    };

    ".config/waybar/" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/waybar";
    };
  };

  imports = [
    ./rofi.nix
  ];
  programs.wofi = {
    enable = true;
    settings = {

      width = 420;
      height = 550;
      location = "center";
      show = "drun";
      matching = "fuzzy";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 28;
      gtk_dark = false;
      term = "alacritty";
    };

    style = ''
          * {
        transition: 0.2s;
      }

      window {
      	font-family: "FiraCode Nerd Font Mono";
      	font-size: 13px;
      }

      window {
          margin: 0px;
          border: 2px solid #cba6f7;
      /*
          background-color: #161925;
      */
          background-color: transparent;
          border-radius: 16px;
      }

      #input {
          padding: 4px;
          margin: 20px;
          padding-left: 20px;
          border: none;
          color: #fff;
          font-weight: bold;
          background: linear-gradient(90deg, #cba6f7 0%, #94e2d5 100%);
         	outline: none;
          border-radius: 16px;
      }

      #input image {
          color: #fff;
      }

      #input:focus {
          border: none;
         	outline: none;
      }

      #inner-box {
          margin: 20px;
          margin-top: 0px;
          border: none;
          color: #cba6f7;
          border-radius: 16px;
      }

      #inner-box * {
          transition: none;
      }

      #outer-box {
          margin: 0px;
          border: none;
          padding: 0px;
          border-radius: 16px;
      }

      #scroll {
          margin-top: 5px;
          border: none;
          border-radius: 16px;
          margin-bottom: 5px;
      }

      #text:selected {
          color: #fff;
          font-weight: bold;
      }

      #img {
          margin-right: 20px;
          background: transparent;
      }

      #text {
          margin: 0px;
          border: none;
          padding: 0px;
          background: transparent;
      }

      #entry {
          margin: 0px;
          border: none;
          border-radius: 16px;
          background-color: transparent;
          min-height:32px;
          font-weight: bold;
      }

      #entry:selected {
          outline: none;
          margin: 0px;
          border: none;
          border-radius: 16px;
          background: linear-gradient(90deg, #cba6f7 0%, #94e2d5 100%);
      }
    '';
  };
  home.packages = with pkgs; [
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [
        "-Dexperimental=true"
      ];
    }))

    brightnessctl
    hyprpicker
    inotify-tools
    dunst
    libnotify
    swww
    swayidle
    fuzzel
    tofi
    wofi
    networkmanagerapplet
    swaylock
    hyprpaper
  ];
}
