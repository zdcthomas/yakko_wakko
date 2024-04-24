{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.starship;
in {
  options = {
    custom.hm.starship = {
      enable = lib.mkEnableOption "Enable custom starship";
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          add_newline = true;
          format = let
            main_line = let
              # can't be $line_break because that will always be true and will break the conditional rendering
              br = "\n┃";
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
                    # "$kubernetes"
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
                  # "$package"
                  "$rust"
                  "$c"
                  "$cmake"
                  # "$cobol"
                  # "$daml"
                  # "$dart"
                  "$deno"
                  # "$dotnet"
                  "$elixir"
                  "$elm"
                  "$erlang"
                  # "$fennel"
                  "$golang"
                  # "$guix_shell"
                  "$haskell"
                  # "$haxe"
                  # "$helm"
                  # "$java"
                  # "$julia"
                  # "$kotlin"
                  # "$gradle"
                  "$lua"
                  # "$nim"
                  "$nodejs"
                  "$ocaml"
                  # "$opa"
                  # "$perl"
                  # "$php"
                  # "$pulumi"
                  # "$purescript"
                  "$python"
                  # "$quarto"
                  # "$raku"
                  # "$rlang"
                  # "$red"
                  "$ruby"
                  # "$scala"
                  # "$solidity"
                  # "$swift"
                  # "$terraform"
                  # "$typst"
                  # "$vlang"
                  # "$vagrant"
                  "$zig"
                  # "$crystal"
                ])
                (group [
                  "$status"
                  "$cmd_duration"
                  # "$memory_usage"
                  "$sudo"
                  "$jobs"
                  # "$battery"
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
          status = {
            disabled = false;
          };
          git_branch = {
            format = "[$symbol$branch(:$remote_branch)]($style) ";
          };
          nix_shell = {
            heuristic = false;
            format = "[$symbol$state( \\($name\\))]($style) ";
          };
          cmd_duration = {
            format = "t=[$duration]($style)";
          };
          rust = {
            format = "[\${symbol}(\${version} )]($style)";
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
            untracked = "[+$count](purple)";
            stashed = "[◫$count](italic white)";
            modified = "[◌$count](italic bold red)";
            staged = "[●$count](bold green)";
            renamed = "[◎$count](italic bright-blue)";
            deleted = "[✕$count](bold red)";
          };
        };
      };
    };
  };
}
