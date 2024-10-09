{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.hm.git;
in {
  options = {
    custom.hm.git = {
      enable = lib.mkEnableOption "Enable custom git";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git-absorb
      lazygit # trying out this cool git manager thing
    ];
    programs = {
      gh = {
        enable = true;
        extensions = with pkgs; [
          gh-markdown-preview
          gh-dash
        ];
        settings = {
          git_protocol = "ssh";
          prompt = "enabled";
          aliases = {
            rvw = "repo view --web";
            pvw = "pr view --web";
          };
        };
      };

      git = {
        enable = true;
        userName = "zdcthomas";
        userEmail = "zdcthomas@yahoo.com";
        diff-so-fancy.enable = true;
        # difftastic.enable = true;
        iniContent.merge.conflictstyle = "diff3";
        extraConfig = {
          core = {
            editor = "nvim";
          };
          init = {
            defaultBranch = "main";
          };
          commit = {
            verbose = true;
          };
          log = {
            date = "local";
          };
          tag = {
            sort = "version:refname";
          };
          branch = {
            sort = "-committerdate";
          };
          rerere = {
            enabled = true;
          };
          pull = {
            rebase = false;
          };
          color = {
            status = "auto";
            branch = "auto";
            interactive = "auto";
            diff = "auto";
          };
          url = {
            "https://github.com/" = {
              insteadOf = [
                "gh:"
                "github:"
              ];
            };
          };
        };
        aliases = {
          co = "switch";
          cnv = "commit --no-verify";
          ap = "add --patch";
          l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
        };
        ignores = [
          "*.swp"
          "2"
          ".DS_Store"
          ".cache/"
          ".DS_Store"
          ".direnv/"
          ".idea/"
          "built-in-stubs.jar"
          ".elixir_ls/"
          ".vscode/"
          "npm-debug.log"
        ];
      };
    };
  };
}
