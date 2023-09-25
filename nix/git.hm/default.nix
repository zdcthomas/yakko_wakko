{...}: {
  programs = {
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
      iniContent.merge.conflictstyle = "diff3";
      extraConfig = {
        core = {
          editor = "nvim";
        };
        init = {
          defaultBranch = "main";
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
        lg = "log --graph --format='%Cred%h%Creset  %<|(15) %C(white)%s %<|(35) %Creset %Cgreen(%cr)%<|(55)  %C(blue)<%an>%Creset%C(yellow)%d%Creset'";
      };
      ignores = [
        "*.swp"
        "2"
        ".DS_Store"
      ];
    };
  };
}
