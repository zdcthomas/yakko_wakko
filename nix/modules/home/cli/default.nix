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
        FZF_DEFAULT_OPTS = "--height 40% --reverse --border=rounded";
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
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
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
