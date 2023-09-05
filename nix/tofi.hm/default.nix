{
  pkgs,
  config,
  lib,
  ...
}: let
  col =
    lib.attrsets.mapAttrs
    (name: value: ("#" + value))
    config.colorScheme.colors;
in {
  home.packages = with pkgs; [
    tofi
  ];

  home.file = {
    ".config/tofi/tofi.launcher.conf" = {
      text = ''
        hide-cursor = true
        fuzzy-match = true
        hide-input = false
        drun-launch = true
        multi-instance = false

        font = Iosevka
        font-size = 12
        font-features = ss01, ss02, ss03, ss04, ss05, ss06, zero, onum
        background-color = ${col.base00}
        outline-width = 0
        border-width = 2
        border-color = ${col.base0E}
        text-color = ${col.base05}
        prompt-text = 
        prompt-padding = 20
        prompt-color = ${col.base06}
        prompt-background = ${col.base01}
        prompt-background-padding = 0, 0
        prompt-background-corner-radius = 12
        placeholder-text = Application
        selection-color = ${col.base0E}
        selection-match-color = ${col.base0C}
        selection-background-padding = 8, 12
        selection-background-corner-radius = 12
        result-spacing = 22
        min-input-width = 100
        # width = 1900
        height = 45
        corner-radius = 16
        anchor = top
        exclusive-zone = -1
        output = launcher
        padding-top = 7.5
        padding-left = 10
        padding-right = 20
        clip-to-padding = false
        margin-top = 5
        horizontal = true
        require-match = false
      '';
    };
  };
}
