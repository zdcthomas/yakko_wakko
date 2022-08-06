{ config, pkgs, ... }:

{
  manual.html.enable = true;
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "zacharythomas";
    homeDirectory = "/Users/zacharythomas";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.

    stateVersion = "22.05";
    packages = [
      pkgs.asciinema
      pkgs.bat
      pkgs.boxes
      pkgs.emacs
      pkgs.entr
      pkgs.exa
      pkgs.exa
      pkgs.fd
      pkgs.fish
      pkgs.fzf
      pkgs.gh
      pkgs.git
      pkgs.jq
      pkgs.neovim
      pkgs.silver-searcher
      pkgs.skim
      pkgs.tmux
      pkgs.tree
      pkgs.unzip
      pkgs.vim
      pkgs.zip
      pkgs.nodejs-18_x
    ];

    /* symlink the config directory. I know this isn't the nix way, but it's
      * ridiculous to invent another layer of rconfiguration languages*/
    /* file."test_config".recursive = true; */
    /* file."test_config".source = config.lib.file.mkOutOfStoreSymlink ~/yakko_wakko/config; */
    file = {
      config = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ~/yakko_wakko/config;
      };

    };


    sessionVariables = {
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
      TEST_ENV_VARR = "hello! how's it going?";
      PATH = "$HOME/.cargo/bin:$HOME/.mix/escripts:$PATH";
    };
    sessionPath = [ "$HOME/.cargo/bin:$PATH" "$HOME/.mix/escripts:$PATH" "$PATH:$HOME/go/bin" ];

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
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    bat.enable = true;
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    bash = {
      enable = true;
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


    zsh = {
      defaultKeymap = "emacs";
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      history.extended = true;
      sessionVariables = rec {
        EDITOR = "nvim";
      };
      plugins = [
        {
          # nix-prefetch-url --unpack https://github.com/zsh-users/zsh-syntax-highlighting/archive/0.6.0.tar.gz
          name = "zsh-history-substring-search";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-history-substring-search";
            rev = "1.0.2";
            sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
          };
        }
        {
          # nix-prefetch-url --unpack https://github.com/zsh-users/zsh-syntax-highlighting/archive/0.6.0.tar.gz
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.6.0";
            sha256 = "hH4qrpSotxNB7zIT3u7qcog51yTQr5j5Lblq9ZsxuH4=";
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

          if type -q pg_ctl
            alias fuck_pg='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
          end

          if type -q exa
            alias la='exa -la'
            alias ls='exa -la'
          else
            alias la='ls -la'
          end
        '';
    };
  };
}
