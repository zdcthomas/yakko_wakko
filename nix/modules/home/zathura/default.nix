{ config, pkgs, lib, inputs, ... }:
let
  cfg = config.custom.hm.zathura;
  col = config.colorScheme.colors;
in {
  options = {
    custom.hm.zathura = {
      enable = lib.mkEnableOption "Enable custom zathura";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      extraConfig = ''
        # Zathura configuration file
        # See man `man zathurarc'

        # Open document in fit-width mode by default
        set adjust-open "best-fit"

        # One page per row by default
        set pages-per-row 1

        #stop at page boundries
        set scroll-page-aware "true"
        set smooth-scroll "true"
        set scroll-full-overlap 0.01
        set scroll-step 100

        #zoom settings
        set zoom-min 10
        set guioptions ""

        # zathurarc-dark

        set font "inconsolata 15"
        set default-bg "#${col.base00}" #00
        set default-fg "#${col.base01}" #01

        set statusbar-fg "#${col.base04}" #04
        set statusbar-bg "#${col.base02}" #01

        set inputbar-bg "#${col.base01}" #00 currently not used
        set inputbar-fg "#${col.base07}" #02

        set notification-error-bg "#${col.base08}" #08
        set notification-error-fg "#${col.base00}" #00

        set notification-warning-bg "#${col.base08}" #08
        set notification-warning-fg "#${col.base00}" #00

        set highlight-color "#${col.base0A}" #0A
        set highlight-active-color "#${col.base0D}" #0D
        set completion-highlight-fg "#${col.base00}" #02
        set completion-highlight-bg "#${col.base0C}" #0C

        set completion-bg "#${col.base01}" #02
        set completion-fg "#${col.base0C}" #0C

        set notification-bg "#${col.base0B}" #0B
        set notification-fg "#${col.base00}" #00

        set recolor "true"
        set recolor-lightcolor "#${col.base07}" #00
        set recolor-darkcolor "#${col.base01}" #06
        set recolor-reverse-video "true"
        set recolor-keephue "true"


        set render-loading "false"
        set scroll-step 50
        # unmap f
        # map f toggle_fullscreen
        # map [fullscreen] f toggle_fullscreen
      '';
    };
  };
}
