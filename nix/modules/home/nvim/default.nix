{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.hm.nvim;
in
  with lib; {
    options = {
      custom.hm.nvim = {
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
    config = let
      packages = with pkgs;
      # it'd be super super cool to wrap all these so they're only available in the nvim process
        [
          fzf
          cfg.package
          # zathura
          # boxes
          fd
          jq
          ripgrep
          silver-searcher
          shfmt
          prettierd
          # entirely for dap rust codelldb
          python3
        ]
        ++ optionals cfg.language_servers.nix [
          # nixpkgs-fmt
          alejandra
          statix
          nixd
          nil
        ]
        ++ optionals cfg.language_servers.lua [
          stylua
          lua-language-server
        ]
        ++ optionals cfg.language_servers.yml [
          yamlfmt
        ]
        # ++ optionals pkgs.stdenv.isLinux [
        #   vscode-extensions.vadimcn.vscode-lldb
        # ]
        ++ optionals cfg.language_servers.markdown [
          marksman
          glow
        ];
    in
      mkIf cfg.enable {
        home = {
          sessionVariables =
            {}
            // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux
            {
              RUST_DAP = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/";
            }
            // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin
            {
              RUST_DAP = "~/.local/share/lldb/extension/";
            };
          shellAliases = {
            n = "nvim";
          };

          file =
            {
              ".config/nvim/" = {
                source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/nvim";
              };
            }
            // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
              ".local/share/lldb/" = {
                source = pkgs.fetchzip {
                  url = "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-aarch64-darwin.vsix#lldb.zip";
                  hash = "sha256-IJr3PJDGZ5EpAzJ6uwRs0NJcdEGiZfke5pwghjfFYEY=";
                  stripRoot = false;
                };
              };
            };

          packages = packages;
        };
      };
  }
