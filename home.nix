{ config, pkgs, ... }:

let
  _ = builtins.trace pkgs;
  management_scripts = import ./nix/nix_management_scripts_pkgs.nix { pkgs = pkgs; homeDirectory = config.home.homeDirectory; };
in
{
  manual.html.enable = true;
  nixpkgs.config.allowUnfree = true;
  news.display = "show";

  nix = {

    checkConfig = true;
    package = pkgs.nixVersions.stable;

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

      bash
      bashInteractive
      bat
      boxes
      exa
      fd
      fish
      font-awesome_5
      fzf
      gh
      git
      go
      graphviz
      htop
      /* httpie */
      jq
      lua
      neovim
      nodePackages.prettier_d_slim
      pandoc
      /* readline */
      ripgrep
      rustup
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

      (
        nerdfonts.override {
          fonts = [
            "FiraCode"
            "Meslo"
          ];
        }
      )

    ] ++ management_scripts;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.05";


    /* symlink the config directory. I know this isn't the nix way, but it's
      * ridiculous to invent another layer of rconfiguration languages */
    file = {
      ".config/nvim/" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/nvim";
      };
      ".tmux.conf".source = ./tmux.conf;
      ".config/dmux/dmux.conf.toml".source = ./config/dmux/dmux.conf.toml;
      ".boxes".source = ./config/boxes/.boxes;
    };


    sessionVariables = {
      /* TODO: Split these out into another module */
      /* ----------------------------*/
      /* |    homebrew variables    |*/
      /* ----------------------------*/

      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      MANPATH = "/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
      INFOPATH = "/opt/homebrew/share/info:${INFOPATH:-}";

      EDITOR = "nvim";
      DIFFPROG = "nvim -d";
      SKIM_DEFAULT_COMMAND = "fd --hidden --type f";
      ERL_AFLAGS = "-kernel shell_history enabled";
      ELIXIR_EDITOR = "nvim +__LINE__ __FILE__";
      /* Move these to fzf program config */
      FZF_ALT_C_COMMAND = "fd -t d";
      FZF_ALT_C_OPTS = "--preview 'tree -C {} | head -200'";
      FZF_CTRL_T_OPTS = "--preview '(bat {} || tree -C {}) 2> /dev/null | head -200'";
      FZF_DEFAULT_COMMAND = "fd --hidden --type f";
      FZF_DEFAULT_OPTS = "--height 40% --reverse --border=rounded";
    };

    sessionPath = [ "$HOME/.cargo/bin" "$HOME/.mix/escripts" "$HOME/go/bin" "/opt/homebrew/bin" "/opt/homebrew/sbin${PATH+:$PATH}" ];

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
    exa = {
      enable = true;
      enableAliases = true;
      /* ls = "${pkgs.exa}/bin/exa"; */
      /* ll = "${pkgs.exa}/bin/exa -l"; */
      /* la = "${pkgs.exa}/bin/exa -a"; */
      /* lt = "${pkgs.exa}/bin/exa --tree"; */
      /* lla = "${pkgs.exa}/bin/exa -la"; */
    };

    man = {
      enable = true;
      generateCaches = true;
    };

    alacritty = {
      enable = true;
    };

    kitty = {
      enable = true;
      theme = "Everforest Dark Medium";
      font = {
        size = 15;
        name = "Monaco";
      };
      settings = {
        hide_window_decorations = "titlebar-only";
        enable_audio_bell = false;
        background_opacity = "0.95";
        macos_quit_when_last_window_closed = true;
        macos_option_as_alt = true;
      };
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    bat = {
      enable = true;
      config = {
        theme = "1337";
      };
    };

    go = {
      enable = true;
    };

    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    bash = {
      enable = true;
      enableCompletion = true;
      shellOptions = [
        "histappend"
        "checkwinsize"
        "extglob"
      ];
      initExtra = ''
        bind '"\e[A": history-search-backward'
        bind '"\e[B": history-search-forward'

        git_branch() {
            # git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
            git branch 2>/dev/null | grep '^*' | colrm 1 2
        }

        function dirty(){
        	if [[ $(git status --porcelain 2> /dev/null)  ]];
        		then 
        			echo "*"; 
        	fi
        }

        cyan="\[\033[36m\]"
        white="\[\033[m\]"
        green="\[\033[32m\]"
        yellow="\[\033[33;1m\]"
        in_prompt="| => "
        export PS1="$cyan\u$white@$yellow \w$white \$(git_branch) \$(dirty) \n$in_prompt"
        export PS2=$in_prompt
        export PS2="| ?> "
      '';
    };


    zsh =
      {
        defaultKeymap = "emacs";
        enable = true;
        /* enableAutosuggestions = true; */
        enableCompletion = true;
        history.extended = true;
        sessionVariables = rec {
          EDITOR = "nvim";
        };
        autocd = true;
        initExtraFirst = builtins.readFile ./zsh_extra_config.zsh;
        plugins = [
          {
            name = "_git";
            src = pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh";
              sha256 = "sha256-9gddKDJQeF7c8JKBmSvea0vMQ+stynRIjYgKUvdlnAk=";
            };
          }
          {
            name = "zsh-history-substring-search";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-history-substring-search";
              rev = "1.0.2";
              sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
            };
          }
          {
            name = "zsh-syntax-highlighting";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-syntax-highlighting";
              rev = "0.6.0";
              sha256 = "hH4qrpSotxNB7zIT3u7qcog51yTQr5j5Lblq9ZsxuH4=";
            };
          }
          {
            name = "git-prompt";
            src = pkgs.fetchFromGitHub {
              owner = "woefe";
              repo = "git-prompt.zsh";
              rev = "v2.3.0";
              sha256 = "i5UemJNwlKjMJzStkUc1XHNm/kZQfC5lvtz6/Y0AwRU=";
            };
          }
          {
            name = "zsh-autosuggestions";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-autosuggestions";
              rev = "v0.6.3";
              sha256 = "rCTKzRg2DktT5X/f99pYTwZmSGD3XEFf9Vdenn4VEME=";
            };
          }
        ];
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
        core = {
          editor = "nvim";
        };
      };
      aliases = {
        co = "switch";
        cnv = "commit --no-verify";
        ap = "add --patch";
        lg = "log --graph --format='%Cred%h%Creset  %<|(15) %C(white)%s %<|(35) %Creset %Cgreen(%cr)%<|(55)  %C(blue)<%an>%Creset%C(yellow)%d%Creset'";
      };
      ignores = [
        "*.swp"
        "2"
        ".DS_Store"
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
