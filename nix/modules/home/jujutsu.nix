{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.jujutsu;
in {
  options = {
    custom.hm.jujutsu = {
      enable = lib.mkEnableOption "Enable custom jujutsu";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        watchman
      ];
    };

    programs = {
      jujutsu = {
        enable = true;
        settings = {
          core.fsmonitor = "watchman";
          user = {
            name = "Zachary Thomas";
            email = "zdcthoms@yahoo.com";
          };
        };
      };
    };
  };
}
