{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.helix;
in {
  options = {
    custom.hm.helix = {
      enable = lib.mkEnableOption "Enable custom helix";
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      helix = {
        enable = true;
        languages = {
          language-server.nixd = {
            command = "${lib.getExe pkgs.nixd}";
          };
          language = [
            # {
            #   name = "typescript";
            #   language-servers = ["typescript-language-server"];
            #   formatter.command = "prettier";
            #   formatter.args = ["--parser" "typescript"];
            #   formatter.binary = "${lib.getExe pkgs.nodePackages.prettier}";
            # }
            # {
            #   name = "python";
            #   formatter.command = "ruff";
            #   formatter.args = ["format" "--line-length" "88" "-"];
            #   formatter.binary = "${lib.getExe pkgs.ruff}";
            # }
            {
              name = "nix";
              language-servers = ["nixd"];
              formatter.binary = "${lib.getExe pkgs.nixfmt-classic}";
              formatter.command = "nixfmt";
            }
          ];
        };
        settings = {
          editor = {
            color-modes = true;
            rulers = [80];
            auto-save = true;
            auto-format = true;
            line-number = "relative";
            lsp = {
              enable = true;
              display-messages = true;
              display-inlay-hints = false;
            };
            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };
          };
          theme = "gruvbox";
        };
      };
    };
  };
}
