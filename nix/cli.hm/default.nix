{ ... }:
{
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

}
