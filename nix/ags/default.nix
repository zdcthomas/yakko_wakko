{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    ags
  ];

  home.file.".config/ags/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/ags";
  };
}
