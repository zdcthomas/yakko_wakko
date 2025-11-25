{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.custom.hm.anyrun;
in
{
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
          plugins = [
            # applications
            # rink
            # shell
            # dictionary
            # translate
            # stdin
            # websearch
            "libapplications.so"
            "libsymbols.so"
            "libshell.so"
            "libtranslate.so"
          ];
          layer = "overlay";
          closeOnClick = true;
          showResultsImmediately = true;
          x = {
            fraction = 0.5;
          };
          y = {
            fraction = 0.2;
          };
        };
        extraConfigFiles = {
          "applications.ron".text = ''
            Config(
              terminal: Some("wezterm"),
            )
          '';
          "symbols.ron".text = ''
            Config(
              prefix: "sym",
              // Custom user defined symbols to be included along the unicode symbols
              symbols: {
                // "name": "text to be copied"
                "shrug": "¯\\_(ツ)_/¯",
              },
              max_entries: 3,
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
          # "translate.ron".text = ''
          #   Config(
          #     prefix: ":",
          #     language_delimiter: ">",
          #     max_entries: 3,
          #   )
          # '';
        };
      };
    };
  };
}
