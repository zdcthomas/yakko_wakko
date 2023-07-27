{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    profiles = {
      zdcthomas = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          vimium
        ];
        bookmarks = [
          {
            name = "wikipedia";
            tags = [ "wiki" ];
            keyword = "wiki";
            url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
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
