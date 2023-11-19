{
  config,
  lib,
  ...
}: let
  cfg = config.custom.hm.wezterm;
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
        };
      };
    };
  }
