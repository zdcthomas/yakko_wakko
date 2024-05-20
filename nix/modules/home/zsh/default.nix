{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.hm.zsh;
in {
  options = {
    custom.hm.zsh = {
      enable = lib.mkEnableOption "Enable custom zsh";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.carapace];
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      history.extended = true;
      autocd = true;
      initExtra = let
        native = builtins.readFile ./zsh_extra_config.zsh;
        vi_mode_plugin = pkgs.fetchFromGitHub {
          owner = "jeffreytse";
          repo = "zsh-vi-mode";
          rev = "287efa19ec492b2f24bb93d1f4eaac3049743a63";
          sha256 = "sha256-HMfC4s7KW4bO7H6RYzLnSARoFr1Ez89Z2VGONKMpGbw=";
        };
        prompt =
          if config.custom.hm.starship.enable
          then ""
          else ''
            function sign {
              if [[ -v IN_NIX_SHELL ]]; then
                echo -n "%F{blue}n%f%F{cyan}i%f%F{green}x%f"
              else
                echo -n "%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f"
              fi
            }

            function extra {
              if [[ $_EXTRA_PROMPT_STUFF != "" ]]; then
                echo -n "\n┃$_EXTRA_PROMPT_STUFF"
              fi
            }


            function gp {
              if [[ $_ZSH_GIT_PROMPT_STATUS_OUTPUT != "" ]]; then
                echo -n "\n┃$_ZSH_GIT_PROMPT_STATUS_OUTPUT"
              fi
            }

            PROMPT=$'┏╸%(?..%F{red}%?%f · )%B%~%b$(gp)$(extra)\n┗╸$(sign) '
          '';
        fzf-tab = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "c7fb028ec0bbc1056c51508602dbd61b0f475ac3";
          sha256 = "1b4pksrc573aklk71dn2zikiymsvq19bgvamrdffpf7azpq6kxl2";
        };
      in ''
        source ${vi_mode_plugin}/zsh-vi-mode.plugin.zsh
        ${prompt}
        ${native}
        source <(${pkgs.carapace}/bin/carapace _carapace)
        . ${fzf-tab}/fzf-tab.plugin.zsh
      '';
      plugins = [
        # {
        #   name = "_git";
        #   src = pkgs.fetchurl {
        #     url = "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh";
        #     sha256 = "sha256-zspIBpZDxsRaP21hi2Zvh4rF+JsXk0yBvcHpDJivLjI=";
        #   };
        # }
        {
          name = "zsh-history-substring-search";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-history-substring-search";
            rev = "v1.1.0";
            sha256 = "sha256-GSEvgvgWi1rrsgikTzDXokHTROoyPRlU0FVpAoEmXG4=";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.8.0";
            sha256 = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
          };
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "sha256-oQpYKBt0gmOSBgay2HgbXiDoZo5FoUKwyHSlUrOAP5E=";
          };
        }
        {
          name = "git-prompt";
          src = pkgs.fetchFromGitHub {
            owner = "woefe";
            repo = "git-prompt.zsh";
            rev = "v2.4.0";
            sha256 = "sha256-Q7Dp6Xgt5gvkWZL+htDmGYk9RTglOWrrbl6Wf6q/qjY=";
          };
        }
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
          };
        }
      ];
    };
  };
}
