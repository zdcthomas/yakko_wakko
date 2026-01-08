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
        # extraCss = builtins.readFile "${./default.css}";

        # config = {
        #   x = {
        #     fraction = 0.5;
        #   };
        #   y = {
        #     fraction = 0.3;
        #   };
        #   width = {
        #     fraction = 0.3;
        #   };
        #   hideIcons = true;
        #   ignoreExclusiveZones = false;
        #   layer = "overlay";
        #   hidePluginInfo = false;
        #   closeOnClick = false;
        #   showResultsImmediately = false;
        #   maxEntries = null;
        #
        #   plugins = [
        #     "${pkgs.anyrun}/lib/libapplications.so"
        #     "${pkgs.anyrun}/lib/libsymbols.so"
        #   ];
        # };
        # config = {
        #   plugins = [
        #     # applications
        #     # rink
        #     # shell
        #     # dictionary
        #     # translate
        #     # stdin
        #     # websearch
        #     # "libapplications.so"
        #     # "libsymbols.so"
        #     # "libshell.so"
        #     # "libtranslate.so"
        #
        #     "${pkgs.anyrun}/lib/libapplications.so"
        #     "${pkgs.anyrun}/lib/libsymbols.so"
        #   ];
        #   # layer = "overlay";
        #   closeOnClick = true;
        #   showResultsImmediately = true;
        #   height = {
        #     fraction = 0.4;
        #   };
        #   width = {
        #     fraction = 0.4;
        #   };
        #   x = {
        #     fraction = 0.5;
        #   };
        #   y = {
        #     fraction = 0.2;
        #   };
        # };
        # extraConfigFiles = {
        #   "applications.ron".text = ''
        #     Config(
        #       // Also show the Desktop Actions defined in the desktop files, e.g. "New Window" from LibreWolf
        #       desktop_actions: true,
        #
        #       max_entries: 5,
        #
        #       hide_description: true,
        #
        #       // A command to preprocess the command from the desktop file. The commands should take arguments in this order:
        #       // command_name <term|no-term> <command>
        #       preprocess_exec_script: Some("/home/user/.local/share/anyrun/preprocess_application_command.sh")
        #
        #       // The terminal used for running terminal based desktop entries, if left as `None` a static list of terminals is used
        #       // to determine what terminal to use.
        #       terminal: Some(Terminal(
        #         // The main terminal command
        #         command: "wezterm",
        #         // What arguments should be passed to the terminal process to run the command correctly
        #         // {} is replaced with the command in the desktop entry
        #         // args: "-e {}",
        #       )),
        #     )
        #   '';
        #   "symbols.ron".text = ''
        #     Config(
        #       prefix: "sym",
        #       // Custom user defined symbols to be included along the unicode symbols
        #       symbols: {
        #         // "name": "text to be copied"
        #         "shrug": "¯\\_(ツ)_/¯",
        #       },
        #       max_entries: 3,
        #     )
        #   '';
        #   "websearch.ron".text = ''
        #     Config(
        #       prefix: "?",
        #     )
        #   '';
        #   "shell.ron".text = ''
        #     Config(
        #      prefix: ">"
        #     )
        #   '';
        #   # "translate.ron".text = ''
        #   #   Config(
        #   #     prefix: ":",
        #   #     language_delimiter: ">",
        #   #     max_entries: 3,
        #   #   )
        #   # '';
        # };
      };
    };
  };
}
