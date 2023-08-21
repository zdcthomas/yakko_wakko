{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    profiles = {
      zdcthomas = {
        isDefault = true;
        settings = {
          # https://github.com/arkenfox/user.js/blob/master/user.js
          "browser.startup.page" = 0;
          "browser.aboutConfig.showWarning" = false;
          "browser.startup.homepage" = "about:blank";
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.enabled" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.coverage.opt-out" = true;
          "toolkit.coverage.endpoint.base" = "";
          "browser.ping-centre.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "app.shield.optoutstudies.enabled" = false;
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";
          "network.connectivity-service.enabled" = false;
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          vimium
          onepassword-password-manager
        ];
        bookmarks = [
          {
            name = "github";
            tags = [ "git" ];
            keyword = "git";
            url = "https://github.com";
          }
          {
            name = "example nixos configurations";
            tags = [ "nixos" "nix" ];
            keyword = "example config";
            url = "https://nixos.wiki/wiki/Configuration_Collection";
          }

          {
            name = "hyprland wiki";
            tags = [ "wiki" "hyprland" ];
            keyword = "hyprland";
            url = "https://wiki.hyprland.org/";
          }
          {
            name = "wikipedia";
            tags = [ "wiki" ];
            keyword = "wiki";
            url = "https://en.wikipedia.org";
          }

          {
            name = "i3 docs";
            tags = [ "i3" ];
            keyword = "i3";
            url = "https://i3wm.org/docs/user-contributed/lzap-config.html";
          }
          {
            name = "News";
            toolbar = true;
            bookmarks = [
              {
                name = "Hacker News";
                tags = [ "news" "tech" ];
                url = "https://news.ycombinator.com/";
              }
              {
                name = "Lobsters";
                tags = [ "news" "tech" ];
                url = "https://lobste.rs";
              }
            ];
          }
          {
            name = "Nix sites";
            toolbar = true;
            bookmarks = [
              {
                name = "Packages search";
                tags = [ "search" "nix" ];
                url = "https://search.nixos.org/packages";
              }
              {
                name = "Options search";
                tags = [ "search" "nix" ];
                url = "https://search.nixos.org/options";
              }
              {
                name = "Home Manager Appendix";
                tags = [ "wiki" "nix" ];
                url = "https://nix-community.github.io/home-manager/options.html";
              }
              {
                name = "wiki";
                tags = [ "wiki" "nix" ];
                url = "https://nixos.wiki/";
              }
            ];
          }
        ];
      };
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
