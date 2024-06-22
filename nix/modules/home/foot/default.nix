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
          font-bold = "PragmataPro Mono Liga:weight=bold";
          font-italic = "PragmataPro Mono Liga:slant=italic";
          font-bold-italic = "PragmataPro Mono Liga";
          dpi-aware = "yes";
          # colors = {
          #   alpha = "0.9";
          # };
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
