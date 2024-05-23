{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.nushell;
in {
  options = {
    custom.hm.nushell = {
      enable = lib.mkEnableOption "Enable custom nushell";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      file = {
        "Library/Application Support/nushell/" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/nushell";
        };
      };

      packages = [pkgs.nushell];
    };
    # programs.nushell = {
    #   enable = true;
    #   extraConfig = ''
    #
    #   '';
    # };
  };
}
