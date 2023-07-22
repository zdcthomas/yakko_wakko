{ pkgs, ... }: {
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
    # forwardAgent = false;
    # hashKnownHosts = true;
    # matchBlocks."github.com" = {
    #   extraOptions."MACs" =
    #     "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com";
    #   user = "git";
    # };
    # serverAliveInterval = 300;
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
