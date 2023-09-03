{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [
      # openssh
    ];
  };
  programs.ssh = {
    compression = true;
    enable = true;
    # controlMaster = "auto";
    # controlPath = "${config.home.homeDirectory}/.ssh/sockets/%r@%h-%p";
    # controlPersist = "600";
    # `aes256-ctr` cipher and `hmac-sha2-256` MAC required to connect to reMarkable 2.
    extraConfig = ''
      # VisualHostKey no
      # StrictHostKeyChecking ask
      VerifyHostKeyDNS yes
      ForwardX11 no
      ForwardX11Trusted no
      ServerAliveCountMax 2
    '';
    extraOptionOverrides = {
      "Include" = "${config.home.homeDirectory}/.ssh/config.local";
    };
  };

  # xdg.mimeApps.defaultApplications = {
  #   "application/x-extension-htm" = "firefox.desktop";
  #   "application/x-extension-html" = "firefox.desktop";
  #   "application/x-extension-shtml" = "firefox.desktop";
  #   "application/x-extension-xht" = "firefox.desktop";
  #   "application/x-extension-xhtml" = "firefox.desktop";
  #   "application/xhtml+xml" = "firefox.desktop";
  #   "text/html" = "firefox.desktop";
  #   "x-scheme-handler/chrome" = "firefox.desktop";
  #   "x-scheme-handler/http" = "firefox.desktop";
  #   "x-scheme-handler/https" = "firefox.desktop";
  # };
}
