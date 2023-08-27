{ config, pkgs, lib, ... }:
let
  cfg = config.custom.home.nvim;
in
with lib;
{
  options = {
    custom.home.nvim = {
      enable = mkEnableOption "Custom Nvim config";

      language_servers = {
        rust = mkOption {
          default = true;
          example = true;
          description = "enable language server and config for rust";
          type = types.bool;
        };

        nix = mkOption {
          default = true;
          example = true;
          description = "enable language server and config for nix";
          type = types.bool;
        };

        lua = mkOption {
          default = true;
          example = true;
          description = "enable language server and config for lua";
          type = types.bool;
        };

        js_stuff = mkOption {
          default = true;
          example = true;
          description = "enable language server and config for js_stuff";
          type = types.bool;
        };

        yml = mkOption {
          default = true;
          example = true;
          description = "enable language server and config for yml";
          type = types.bool;
        };

        markdown = mkOption {
          default = true;
          example = true;
          description = "enable language server and config for markdown";
          type = types.bool;
        };

      };

      package = mkOption {
        type = types.package;
        default = pkgs.neovim;
        defaultText = literalExpression "pkgs.neovim";
        description = "The Neovim package to install.";
      };
    };
  };
  config =
    let
      packages = with pkgs;[
        neovim
        fzf
        # zathura
        boxes
        fd
        jq
        ripgrep
        silver-searcher
      ] ++ optionals cfg.language_servers.rust [
        rust-analyzer-nightly
        (fenix.complete.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
        ])
      ] ++ optionals cfg.language_servers.nix [
        nixpkgs-fmt
        statix
        nixd
      ] ++ optionals cfg.language_servers.lua [
        stylua
        lua-language-server
      ] ++ optionals cfg.language_servers.js_stuff [
        prettierd
        eslint_d
      ] ++ optionals cfg.language_servers.yml [
        yamlfmt
      ] ++ optionals cfg.language_servers.markdown [
        marksman
      ];
    in
    mkIf cfg.enable {
      home = {

        file = {
          ".config/nvim/" = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/nvim";
          };
        };
        packages = packages;
      };
    };
}
