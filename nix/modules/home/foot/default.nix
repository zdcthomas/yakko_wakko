{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.foot;
in {
  options = {
    custom.hm.foot = {
      enable = lib.mkEnableOption "Enable custom foot";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          # term = "xterm-256color";

          font = "PragmataPro Mono Liga";
          dpi-aware = "yes";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
