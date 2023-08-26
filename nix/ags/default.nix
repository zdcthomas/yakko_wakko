{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    ags
  ];

  home.file.".config/ags/config.js" = {
    source = ./config.js;
  };
}
