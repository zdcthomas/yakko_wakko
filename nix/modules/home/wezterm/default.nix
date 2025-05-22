{
  config,
  pkgs,
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
          package = pkgs.wezterm;
          enable = true;
          extraConfig = let
            window_decorations =
              if pkgs.stdenv.isDarwin
              then ''"RESIZE"''
              else ''"TITLE | RESIZE"'';
          in ''
            local WINDOW_DECORATION = ${window_decorations}
            local FONT_SIZE = ${cfg.font-size}
            local DEFAULT_OPACITY = ${cfg.opacity}

            ${builtins.readFile ./wezterm.lua}
          '';
        };
      };
    };
  }
