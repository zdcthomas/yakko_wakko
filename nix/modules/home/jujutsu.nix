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
          ui.allow-filesets = true;
          user = {
            name = "Bruno Bigras";
            email = "bigras.bruno@gmail.com";
          };
          template-aliases = {
            "format_short_signature(signature)" = "signature.username()";
          };
        };
      };
    };
    packages = with pkgs; [
      watchman
    ];
  };
}
