{ pkgs, config, ... }: {
  programs.zsh =
    {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      history.extended = true;
      autocd = true;
      initExtraFirst = "source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh\n";
      initExtra = builtins.readFile ./zsh_extra_config.zsh;
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
            rev = "0.7.1";
            sha256 = "gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
          };
        }
        # {
        #   name = "zsh-nix-shell";
        #   file = "nix-shell.plugin.zsh";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "chisui";
        #     repo = "zsh-nix-shell";
        #     rev = "v0.5.0";
        #     sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        #   };
        # }
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
            rev = "v0.7.0";
            sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
          };
        }
      ];
    };
}
