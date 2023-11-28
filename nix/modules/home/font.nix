{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.font;
in {
  options = {
    custom.hm.font = {
      enable = lib.mkEnableOption "Enable custom font";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        pragmataPro
        noto-fonts
        noto-fonts-cjk-sans
      ];
    };

    fonts.fontconfig.enable = true;
    xdg.configFile = {
      # Variant to use if the XML is in a separate file
      # "fontconfig/conf.d/75-disable-fantasque-calt.conf".source = ./75-disable-fantasque-calt.conf;

      "fontconfig/conf.d/75-disable-fantasque-calt.conf".text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <match target="font">
            <test name="family" compare="contains" ignore-blanks="true">
              <string>PragmataPro Mono Liga</string>
            </test>
            <edit name="fontfeatures" mode="append">
              <string>calt on</string>
              <string>ss11 on</string>
              <string>ss13 on</string>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };
}
