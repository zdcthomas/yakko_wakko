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
            local FONT_SIZE = ${cfg.font-size}
            local DEFAULT_OPACITY = ${cfg.opacity}
            ${builtins.readFile ./wezterm.lua}
          '';
        };
      };
    };
  }
