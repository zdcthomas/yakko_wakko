{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.anyrun;
in {
  options = {
    custom.hm.anyrun = {
      enable = lib.mkEnableOption "Enable custom anyrun";
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      anyrun = {
        enable = true;
        extraCss = builtins.readFile "${./default.css}";
        config = {
          plugins = with inputs.anyrun.packages.${pkgs.system}; [
            applications
            rink
            shell
            dictionary
            translate
            stdin
            websearch
          ];
          layer = "overlay";
          closeOnClick = true;
          showResultsImmediately = true;
          x = {fraction = 0.5;};
          y = {fraction = 0.2;};
        };
        extraConfigFiles = {
          "applications.ron".text = ''
            Config(
              terminal: Some("wezterm"),
            )
          '';
          "websearch.ron".text = ''
            Config(
              prefix: "?",
            )
          '';
          "shell.ron".text = ''
            Config(
             prefix: ">"
            )
          '';
          "translate.ron".text = ''
            Config(
              prefix: ":tr",
              language_delimiter: ">",
              max_entries: 3,
            )
          '';
        };
      };
    };
  };
}
