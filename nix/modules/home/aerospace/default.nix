{ config, pkgs, lib, inputs, ... }:
let cfg = config.custom.hm.aerospace;
in {
  options = {
    custom.hm.aerospace = {
      enable = lib.mkEnableOption "Enable custom aerospace (macos only)";
    };
  };
  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    home = {
      file = {
        ".config/aerospace/" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/yakko_wakko/config/aerospace";
        };
      };
    };
  };
}
