{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.hm.cli;
in {
  options = {
    custom.hm.cli = {
      enable = lib.mkEnableOption "Enable a bunch of usefull cli tools";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      file = {
        "${config.xdg.configHome}/zk/" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/zk";
        };
        ".boxes".source = ../../../../config/boxes;
      };
      packages = with pkgs; [
        btop
        fd
        htop
        jq
        ijq
        pandoc
        ripgrep
        sd
        silver-searcher
        skim
        tree
        unzip
        wget
        zip
      ];
      sessionVariables = {
        MANPATH = "/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
        INFOPATH = "/opt/homebrew/share/info:${INFOPATH:-}";

        EDITOR = "nvim";
        DIFFPROG = "nvim -d";
        SKIM_DEFAULT_COMMAND = "fd --hidden --type f";
        /*
        Move these to fzf program config
        */
        FZF_ALT_C_COMMAND = "fd -t d";
        FZF_ALT_C_OPTS = "--preview 'tree -C {} | head -200'";
        FZF_CTRL_T_OPTS = "--preview '(bat {} || tree -C {}) 2> /dev/null | head -200'";
        FZF_DEFAULT_COMMAND = "fd --hidden --type f";
        FZF_DEFAULT_OPTS = "--reverse --border=rounded";
      };

      sessionPath = ["$HOME/.cargo/bin"];

      shellAliases = {
        gco = "git switch";
        gsw = "${pkgs.git}/bin/git branch --sort=-committerdate | grep -v \"^\*\" |  ${pkgs.fzf}/bin/fzf --height=20% --reverse --info=inline | xargs ${pkgs.git}/bin/git checkout";
        gs = "git status";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        vimdiff = "nvim -d";
      };
    };
    programs = {
      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          add_newline = true;
          format = let
            main_line = let
              # can't be $line_break because that will always be true and will break the conditional rendering
              br = "\n|";
              group = comps: let merged = lib.concatStrings comps; in "(${br}${merged})";
            in
              lib.concatStrings [
                "$directory"
                "$git_branch"
                "$git_commit"
                "$git_state"
                "$git_metrics"
                "$git_status"

                # ----
                (
                  group [
                    "$nix_shell"
                    "$docker_context"
                    "$aws"
                    "$kubernetes"
                    "$direnv"
                    "$env_var"
                  ]
                )

                # ----
                (
                  group
                  [
                    "$username"
                    "$hostname"
                    "$localip"
                    "$shlvl"
                    "$os"
                    "$container"
                    "$shell"
                    "$time"
                  ]
                )

                # ----
                (group [
                  "$package"
                  "$rust"
                  "$c"
                  "$cmake"
                  "$cobol"
                  "$daml"
                  "$dart"
                  "$deno"
                  "$dotnet"
                  "$elixir"
                  "$elm"
                  "$erlang"
                  "$fennel"
                  "$golang"
                  "$guix_shell"
                  "$haskell"
                  "$haxe"
                  "$helm"
                  "$java"
                  "$julia"
                  "$kotlin"
                  "$gradle"
                  "$lua"
                  "$nim"
                  "$nodejs"
                  "$ocaml"
                  "$opa"
                  "$perl"
                  "$php"
                  "$pulumi"
                  "$purescript"
                  "$python"
                  "$quarto"
                  "$raku"
                  "$rlang"
                  "$red"
                  "$ruby"
                  "$scala"
                  "$solidity"
                  "$swift"
                  "$terraform"
                  "$typst"
                  "$vlang"
                  "$vagrant"
                  "$zig"
                  "$crystal"
                ])
                (group [
                  "$memory_usage"
                  "$sudo"
                  "$jobs"
                  "$battery"
                  "$cmd_duration"
                ])
              ];
          in ''
            ┏╸${main_line}$line_break┗╸$character
          '';
          scan_timeout = 10;
          character = {
            success_symbol = "[❯](bold green)[❯](bold blue)[❯](cyan)";
            error_symbol = "[❯](red)[❯](red)[❯](red)";
            vimcmd_symbol = "[❯N❯](italic blue)";
          };
          git_branch = {
            format = "[$symbol$branch(:$remote_branch)]($style) ";
          };
          nix_shell = {
            heuristic = true;
          };
          git_status = {
            # staged = "[++\($count\)](green)";
            # diverged = "⇕⇡$(ahead_count)⇣$(behind_count)";
            style = "white";
            format = "([\\[$ahead_behind$staged$modified$untracked$renamed$deleted$conflicted$stashed\\]]($style))";
            conflicted = "[◪$count](italic bright-magenta)";
            ahead = "[▲[\${count}](bold white)](italic green)";
            behind = "[▽[\${count}](bold white)](italic red)";
            diverged = "[◇ ▲┤[\${ahead_count}](regular white)│▽┤[\${behind_count}](regular white)│](italic bright-magenta)";
            untracked = "[+$count](bold bright-green)";
            stashed = "[◫$count](italic white)";
            modified = "[◌$count](italic bold red)";
            staged = "[●$count](bold green)";
            renamed = "[◎$count](italic bright-blue)";
            deleted = "[✕$count](bold red)";
          };
        };
      };
      carapace = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      helix = {
        enable = true;

        defaultEditor = false;
        languages = {
          language = [
            {
              name = "rust";
              auto-format = true;
            }
          ];
        };
        package = pkgs.helix;
        settings = {
          theme = "base16";
          editor = {
            line-number = "relative";
            lsp.display-messages = true;
            file-picker.hidden = false;
            color-modes = true;
            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };
          };
          keys.normal = {
            space.space = "file_picker";
            space.w = ":w";
            space.q = ":q";
            esc = ["collapse_selection" "keep_primary_selection"];
          };
        };
      };
      eza = {
        enable = true;
        enableAliases = true;
        /*
        ls = "${pkgs.exa}/bin/exa";
        */
        /*
        ll = "${pkgs.exa}/bin/exa -l";
        */
        /*
        la = "${pkgs.exa}/bin/exa -a";
        */
        /*
        lt = "${pkgs.exa}/bin/exa --tree";
        */
        /*
        lla = "${pkgs.exa}/bin/exa -la";
        */
      };

      man = {
        enable = true;
        generateCaches = true;
      };

      bat = {
        enable = true;
        config = {
          theme = "1337";
        };
      };

      fzf = {
        enable = true;
        tmux.enableShellIntegration = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
    };
  };
}
