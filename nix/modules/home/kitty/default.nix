{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.hm.kitty;
in {
  options = {
    custom.hm.kitty = {
      enable = lib.mkEnableOption "Enable custom kitty";
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      kitty = {
        /*
        cool kitty colors
        */
        /*
        Forest Night
        */
        /*
        kanagawabones
        */
        /*
        Nova
        */
        /*
        Obsidian
        */
        /*
        Rose Pine
        */
        /*
        moonlight
        */
        /*
        Flat
        */
        /*
        zenwritten_dark
        */

        # theme = "Everforest Dark Medium";
        enable = true;
        theme = "Everforest Dark Medium";
        # theme = "Galaxy";
        # theme = "Lavandula";
        # theme = "Royal";
        # theme = config.colorScheme.name;
        font = {
          size = 11;
          name = "PragmataPro Mono Liga";
        };
        settings = {
          disable_ligatures = "cursor";
          hide_window_decorations = "titlebar-only";
          enable_audio_bell = false;
          background_opacity = "0.7";
          macos_quit_when_last_window_closed = true;
          macos_option_as_alt = true;
        };
        # extraConfig = builtins.readFile ../../../config/kitty/kitty.conf;
      };
    };
  };
}
