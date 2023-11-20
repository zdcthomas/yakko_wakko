{
  config,
  lib,
  ...
}: let
  cfg = config.custom.hm.wezterm;

  col_hash =
    lib.attrsets.mapAttrs
    (name: value: ("#" + value))
    config.colorScheme.colors;
in
  with lib; {
    options = {
      custom.hm.wezterm = {
        enable = mkEnableOption "Enable custom wezterm";
      };
    };
    config = mkIf cfg.enable {
      programs = {
        wezterm = {
          enable = true;
          colorSchemes = {
            myCoolTheme = {
              # ansi = [
              #   "#222222"
              #   col_hash.base0F
              #   col_hash.base0B
              #   col_hash.base0A
              #   col_hash.base08
              #   col_hash.base09
              #   col_hash.base0D
              #   col_hash.base0F
              # ];
              # brights = [
              #   "#444444"
              #   "#FF6D6D"
              #   "#89FF95"
              #   "#FFF484"
              #   "#97DDFF"
              #   "#FDAAF2"
              #   "#85F5DA"
              #   "#E9E9E9"
              # ];
              # scheme: "Everforest"
              # author: "Sainnhe Park (https://github.com/sainnhe)"
              # base00: "#2f383e" # bg0,       palette1 dark (medium)
              # base01: "#374247" # bg1,       palette1 dark (medium)
              # base02: "#4a555b" # bg3,       palette1 dark (medium)
              # base03: "#859289" # grey1,     palette2 dark
              # base04: "#9da9a0" # grey2,     palette2 dark
              # base05: "#d3c6aa" # fg,        palette2 dark
              # base06: "#e4e1cd" # bg3,       palette1 light (medium)
              # base07: "#fdf6e3" # bg0,       palette1 light (medium)
              # base08: "#7fbbb3" # blue,      palette2 dark
              # base09: "#d699b6" # purple,    palette2 dark
              # base0A: "#dbbc7f" # yellow,    palette2 dark
              # base0B: "#83c092" # aqua,      palette2 dark
              # base0C: "#e69875" # orange,    palette2 dark
              # base0D: "#a7c080" # green,     palette2 dark
              # base0E: "#e67e80" # red,       palette2 dark
              # base0F: "#eaedc8" # bg_visual, palette1 dark (medium)

              # scheme: "Everforest Dark Hard"
              # author: "Oskar Liew (https://github.com/OskarLiew)"
              # base00: "#272e33" # bg0,        Default background
              # base01: "#2e383c" # bg1,        Lighter background
              # base02: "#414b50" # bg3,        Selection background
              # base03: "#859289" # grey1,      Comments
              # base04: "#9da9a0" # grey2,      Dark foreground
              # base05: "#d3c6aa" # fg,         Default foreground
              # base06: "#e4e1cd" # bg3,        Light foreground
              # base07: "#fdf6e3" # bg0,        Light background
              # base08: "#7fbbb3" # blue
              # base09: "#d699b6" # purple
              # base0A: "#dbbc7f" # yellow
              # base0B: "#83c092" # aqua
              # base0C: "#e69875" # orange
              # base0D: "#a7c080" # green
              # base0E: "#e67e80" # red
              # base0F: "#4C3743" # bg_visual
              background = col_hash.base00;
              cursor_bg = col_hash.base01;
              cursor_border = col_hash.base07;
              cursor_fg = col_hash.base05;
              foreground = col_hash.base0F;
              selection_bg = col_hash.base02;
              selection_fg = col_hash.base0F;
            };
          };
          extraConfig = ''
            local wezterm = require("wezterm")

            local config = {}

            if wezterm.config_builder then
            	config = wezterm.config_builder()
            end
            config.color_scheme = "Gruvbox Dark (Gogh)"

            config.font = wezterm.font("PragmataPro Mono Liga")
            config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"
            config.adjust_window_size_when_changing_font_size = false
            config.font_size = 10
            config.freetype_load_target = "Light"

            config.window_background_opacity = 0.7
            config.text_background_opacity = 1
            config.hide_tab_bar_if_only_one_tab = true
            config.window_padding = {
            	left = 0,
            	right = 0,
            	top = 0,
            	bottom = 0,
            }
            return config
          '';
        };
      };
    };
  }
