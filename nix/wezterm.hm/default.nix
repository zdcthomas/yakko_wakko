{
  config,
  lib,
}: let
  cfg = config.custom.hm.wezterm;
in
  with lib; {
    options = {
      custom.hm.wezterm = {
        enable = mkEnableOption "Custom Nvim config";
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
