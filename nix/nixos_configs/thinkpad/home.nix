{ config, modulesPath, pkgs, overlays, lib, ... }:

let
  management_scripts = import ../../nix_management_scripts_pkgs.nix { pkgs = pkgs; homeDirectory = config.home.homeDirectory; };
in
{
  fonts.fontconfig.enable = true;
  imports = [
    ../../firefox.nix
    ../../ssh.nix
    ../../zsh
    ../../alacritty.nix
    # ../../zellij.nix
    ../../hyprland
    ../../neofetch
  ];
  # manual.html.enable = true;
  # nixpkgs.overlays = overlays;
  # nixpkgs.config = {
  #   allowUnfree = true;
  # };

  news.display = "show";

  nix = {

    checkConfig = true;
    # package = pkgs.nixVersions.unstable;

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      auto-optimise-store = true
      # assuming the builder has a faster internet connection
      builders-use-substitutes = true
      experimental-features = nix-command flakes
    '';
  };

  home = {
    /*     enableNixpkgsReleaseCheck = true; */
    /*     enableDebugInfo = true; */
    /*     username = "zdcthomas"; */
    /*     homeDirectory = "/Users/zdcthomas"; */

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    /* stateVersion = "22.05"; */

    /* extraOutputsToInstall = [ "man" ]; */
    packages = with pkgs; [

      # bash
      # feh
      bashInteractive
      bat
      btop
      boxes
      exa
      fd
      firefox
      fish
      font-awesome_5
      fzf
      gh
      git
      gnumake
      htop
      jq
      kitty
      neovim
      nix-init
      nurl
      pandoc
      ripgrep
      # rustup
      sd
      silver-searcher
      skim
      statix
      tmux
      tmuxPlugins.tmux-fzf
      tree
      unzip
      weechat
      wget
      zip

      minecraft
      prismlauncher
      (
        nerdfonts.override {
          fonts = [
            "Terminus"
            "FiraCode"
            "Meslo"
            "Monofur"
            "Iosevka"
          ];
        }
      )

      # rnix-lsp
      pavucontrol
      cava
      imv
      nixpkgs-fmt
      stylua
      lua-language-server
      prettierd
      eslint_d
      rust-analyzer-nightly
      yamlfmt
      marksman
      nixd
      xdg-utils
      discord
      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
      ])
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";


    /* symlink the config directory. I know this isn't the nix way, but it's
      * ridiculous to invent another layer of rconfiguration languages */
    file = {
      ".config/nvim/" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/nvim";
      };

      ".config/zk/" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/zk";
      };
      /* ".tmux.conf".source = ./tmux.conf; */
      ".config/dmux/dmux.conf.toml".source = ../../../config/dmux/dmux.conf.toml;
      ".boxes".source = ../../../config/boxes/.boxes;
    };
    keyboard = {
      # variant = "colemak";
      layout = "us";
      options = [ "caps:escape" ];
    };


    sessionVariables = {
      /* TODO: Split these out into another module */
      MANPATH = "/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
      INFOPATH = "/opt/homebrew/share/info:${INFOPATH:-}";

      EDITOR = "nvim";
      DIFFPROG = "nvim -d";
      SKIM_DEFAULT_COMMAND = "fd --hidden --type f";
      /* Move these to fzf program config */
      FZF_ALT_C_COMMAND = "fd -t d";
      FZF_ALT_C_OPTS = "--preview 'tree -C {} | head -200'";
      FZF_CTRL_T_OPTS = "--preview '(bat {} || tree -C {}) 2> /dev/null | head -200'";
      FZF_DEFAULT_COMMAND = "fd --hidden --type f";
      FZF_DEFAULT_OPTS = "--height 40% --reverse --border=rounded";
      PATH = "$PATH:$HOME/.cargo/bin/:$HOME/bin";
    };

    sessionPath = [ "$HOME/.cargo/bin" ];

    shellAliases =
      {
        gco = "git switch";
        gs = "git status";
        n = "nvim";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        vimdiff = "nvim -d";
      };
  };

  programs = {
    qutebrowser = {
      enable = true;
    };
    exa = {
      enable = true;
      enableAliases = true;
      /* ls = "${pkgs.exa}/bin/exa"; */
      /* ll = "${pkgs.exa}/bin/exa -l"; */
      /* la = "${pkgs.exa}/bin/exa -a"; */
      /* lt = "${pkgs.exa}/bin/exa --tree"; */
      /* lla = "${pkgs.exa}/bin/exa -la"; */
    };

    tmux = {
      enable = true;
      /* extraConfig = (builtins.readFile ./tmux.conf); */
      /* shell = "${pkgs.fish}/bin/fish"; */
      sensibleOnTop = false;
      historyLimit = 200000;
      customPaneNavigationAndResize = true;
      keyMode = "vi";
      terminal = "$TERM";
      aggressiveResize = true;
      escapeTime = 0;
      extraConfig = ''
        # undercurl support
        set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
        set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
        set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

        set-option -g status "on"
        set -g status-justify centre
        set -g status-position top

        # default statusbar color
        set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1

        # default window title colors
        set-window-option -g window-status-style fg=white # bg=yellow, fg=bg1

        # default window with an activity alert
        # set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

        # set-window-option -g window-active-style bg=colour236 # bg=bg1, fg=fg3
        # set-window-option -g window-style bg=default

        # active window title colors
        set-window-option -g window-status-current-style bg=cyan,fg=default # fg=bg1

        # pane border
        set-option -g pane-active-border-style fg=red
        set-option -g pane-border-style fg=colour6

        # message infos
        set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1

        # writing commands inactive
        set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

        # pane number display
        # set-option -g display-panes-active-colour colour250 #fg2
        # set-option -g display-panes-colour colour237 #bg1

        # clock
        set-window-option -g clock-mode-colour colour109 #blue

        # bell
        set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg

        bind M-l split-window -h -c "#{pane_current_path}"
        bind M-h split-window -hb -c "#{pane_current_path}"

        # PREFIX j: Create a new horizontal pane.
        bind M-j split-window -v -c "#{pane_current_path}"
        bind M-k split-window -vb -c "#{pane_current_path}"

        unbind-key -T copy-mode-vi MouseDragEnd1Pane

        # Scroll 3 lines at a time instead of default 5; don't extend dragged selections.
        bind-key -T copy-mode-vi WheelUpPane select-pane\; send-keys -t'{mouse}' -X clear-selection\; send-keys -t'{mouse}' -X -N 3 scroll-up
        bind-key -T copy-mode-vi WheelDownPane select-pane\; send-keys -t'{mouse}' -X clear-selection\; send-keys -t'{mouse}' -X -N 3 scroll-down

        # Don't exit copy mode on double or triple click.
        bind-key -T copy-mode-vi DoubleClick1Pane if-shell -Ft'{mouse}' '#{alternate_on}' "send-keys -M" "copy-mode -t'{mouse}'; send-keys -t'{mouse}' -X select-word"
        bind-key -T copy-mode-vi TripleClick1Pane if-shell -Ft'{mouse}' '#{alternate_on}' "send-keys -M" "copy-mode -t'{mouse}'; send-keys -t'{mouse}' -X select-line"

        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'pbcopy'
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi r send-keys -X rectangle-toggle

        # Mouse
        set -g mouse on
      '';
    };

    man = {
      enable = true;
      generateCaches = true;
    };


    kitty = {
      /* cool kitty colors */
      /* Forest Night */
      /* kanagawabones */
      /* Nova */
      /* Obsidian */
      /* Rose Pine */
      /* moonlight */
      /* Flat */
      /* zenwritten_dark */

      # theme = "Everforest Dark Medium";
      enable = true;
      # theme = "Catppuccin-Mocha";
      # theme = "Galaxy";
      # theme = "Lavandula";
      # theme = "Royal";
      theme = "Sea Shells";
      font = {
        size = 11;
        name = "FiraCode Nerd Font";
      };
      settings = {
        disable_ligatures = "cursor";
        hide_window_decorations = "titlebar-only";
        enable_audio_bell = false;
        background_opacity = "0.7";
        macos_quit_when_last_window_closed = true;
        macos_option_as_alt = true;
      };
      # extraConfig = builtins.readFile ../../../config/kitty/kitty.conf;
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    bat = {
      enable = true;
      config = {
        theme = "1337";
      };
    };

    # go = {
    #   enable = true;
    # };

    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    gh = {
      enable = true;
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
      extraConfig = {
        init.defaultBranch = "main";
      };
      iniContent.merge.conflictstyle = "diff3";
      extraConfig = {
        core = {
          editor = "nvim";
        };
      };
      aliases = {
        graph = "log --graph --decorate --oneline";
        co = "switch";
        cnv = "commit --no-verify";
        ap = "add --patch";
        lg = "log --graph --format='%Cred%h%Creset  %<|(15) %C(white)%s %<|(35) %Creset %Cgreen(%cr)%<|(55)  %C(blue)<%an>%Creset%C(yellow)%d%Creset'";
      };
      ignores = [
        "*.swp"
        "2"
        ".DS_Store"
        ".DS_Store?"
        ".Trashes"
      ];
    };

    fish = {
      enable = true;
      functions = {
        /* Move this to local bin idealy */
        fish_prompt = ''
          set -l last_status $status
          set -g fish_prompt_pwd_dir_length 0
          set_color normal
          echo -n (prompt_pwd)
          echo -n (__fish_git_prompt)
          printf '\n| '
          if [ $last_status -ne 0 ]
            set_color red 
            echo -n '>'
            echo -n '<'
            set_color normal
            echo -n $last_status
            set_color red
            echo -n '>'
          else
            set_color cyan 
            echo -n '>'
            set_color red
            echo -n '<'
            set_color brgreen
            echo -n '> '
          end
        '';
        fish_greeting = ''
              echo '                 '(set_color F00)'___
            ___======____='(set_color FF7F00)'-'(set_color FF0)'-'(set_color FF7F00)'-='(set_color F00)')
          /T            \_'(set_color FF0)'--='(set_color FF7F00)'=='(set_color F00)')
          [ \ '(set_color FF7F00)'('(set_color FF0)'0'(set_color FF7F00)')   '(set_color F00)'\~    \_'(set_color FF0)'-='(set_color FF7F00)'='(set_color F00)')
           \      / )J'(set_color FF7F00)'~~    \\'(set_color FF0)'-='(set_color F00)')
            \\\\___/  )JJ'(set_color FF7F00)'~'(set_color FF0)'~~   '(set_color F00)'\)
             \_____/JJJ'(set_color FF7F00)'~~'(set_color FF0)'~~    '(set_color F00)'\\
             '(set_color FF7F00)'/ '(set_color FF0)'\  '(set_color FF0)', \\'(set_color F00)'J'(set_color FF7F00)'~~~'(set_color FF0)'~~     '(set_color FF7F00)'\\
            (-'(set_color FF0)'\)'(set_color F00)'\='(set_color FF7F00)'|'(set_color FF0)'\\\\\\'(set_color FF7F00)'~~'(set_color FF0)'~~       '(set_color FF7F00)'L_'(set_color FF0)'_
            '(set_color FF7F00)'('(set_color F00)'\\'(set_color FF7F00)'\\)  ('(set_color FF0)'\\'(set_color FF7F00)'\\\)'(set_color F00)'_  bird up '(set_color FF0)'\=='(set_color FF7F00)'__
             '(set_color F00)'\V    '(set_color FF7F00)'\\\\'(set_color F00)'\) =='(set_color FF7F00)'=_____   '(set_color FF0)'\\\\\\\\'(set_color FF7F00)'\\\\
                    '(set_color F00)'\V)     \_) '(set_color FF7F00)'\\\\'(set_color FF0)'\\\\JJ\\'(set_color FF7F00)'J\)
                                '(set_color F00)'/'(set_color FF7F00)'J'(set_color FF0)'\\'(set_color FF7F00)'J'(set_color F00)'T\\'(set_color FF7F00)'JJJ'(set_color F00)'J)
                                (J'(set_color FF7F00)'JJ'(set_color F00)'| \UUU)
                                 (UU)'(set_color normal)
        '';
        circle = ''
          set org_and_repo (git remote -v | grep push | awk '{print $2}' | sed 's/\.git//g' | sed 's/.*\.com\///g')
          set branch (git branch | grep \* | cut -d ' ' -f2)
          open https://circleci.com/gh/"$org_and_repo"/tree/"$branch"
        '';
      };
      plugins = [{
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "er1KI2xSUtTlQd9jZl1AjqeArrfBxrgBLcw5OqinuAM=";
        };
      }];
      shellInit =
        ''
          set __fish_git_prompt_color_branch yellow
          set __fish_git_prompt_color_upstream_ahead green
          set __fish_git_prompt_color_upstream_behind red
          set __fish_git_prompt_show_informative_status
          
          # Status Chars
          #set __fish_git_prompt_char_stashstate '↩'
          set __fish_git_prompt_char_upstream_ahead '⤵'
          set __fish_git_prompt_char_upstream_ahead '⤴'
        '';
    };
  };
}