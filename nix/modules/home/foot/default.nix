{ config, pkgs, lib, inputs, ... }:
let
  cfg = config.custom.hm.foot;
  # foot wants bare hex, no leading '#'
  col = config.colorScheme.palette;
in {
  options = {
    custom.hm.foot = { enable = lib.mkEnableOption "Enable custom foot"; };
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
        };

        # Same base16 assignment alacritty uses, so the two terminals match.
        colors = {
          alpha = "0.9";
          background = col.base00;
          foreground = col.base05;

          selection-foreground = col.base07;
          selection-background = col.base0D;

          urls = col.base0D;

          regular0 = col.base00;
          regular1 = col.base08;
          regular2 = col.base0B;
          regular3 = col.base0A;
          regular4 = col.base0D;
          regular5 = col.base0E;
          regular6 = col.base0C;
          regular7 = col.base05;

          bright0 = col.base03;
          bright1 = col.base08;
          bright2 = col.base0B;
          bright3 = col.base0A;
          bright4 = col.base0D;
          bright5 = col.base0E;
          bright6 = col.base0C;
          bright7 = col.base07;
        };

        # <text> <cursor>, mirroring alacritty's cursor colours.
        cursor = { color = "${col.base00} ${col.base0A}"; };

        mouse = { hide-when-typing = "yes"; };
      };
    };
  };
}
