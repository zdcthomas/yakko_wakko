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
        opacity = mkOption {
          type = with types; str;
          default = "1.0";
        };

        font-size = mkOption {
          type = with types; str;
          default = "12";
        };
      };
    };
    config = mkIf cfg.enable {
      programs = {
        wezterm = {
          enable = true;
          colorSchemes = {
            myCoolTheme = {
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
            config.font_size = ${cfg.font-size}

            config.window_background_opacity = ${cfg.opacity}
            config.text_background_opacity = 1
            config.hide_tab_bar_if_only_one_tab = true
            config.window_padding = {
              left = 2,
            	right = 2,
            	top = 2,
            	bottom = 2,
            }
            return config
          '';
        };
      };
    };
  }
