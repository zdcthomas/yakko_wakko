{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.hm.rss;
in
{
  options = {
    custom.hm.rss = {
      enable = lib.mkEnableOption "Enable custom rss (newsboat terminal reader)";
      gui = {
        enable = lib.mkEnableOption "Enable NewsFlash GUI reader";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    # NewsFlash keeps its own database and does NOT read newsboat's url list.
    # Import ./feeds.opml into it manually (see README "RSS" section).
    home.packages = lib.mkIf cfg.gui.enable [ pkgs.newsflash ];

    programs.newsboat = {
      enable = true;
      autoReload = true;
      # These are low-volume blogs; don't hammer them (minutes)
      reloadTime = 120;
      reloadThreads = 4;
      # home-manager writes this value unquoted, so quote it here or newsboat
      # rejects the config with "too many parameters"
      browser = ''"xdg-open %u"'';

      # The feed list lives in the nix store, so adding a feed means editing
      # this list and rebuilding. If that gets annoying, the mutable escape
      # hatch is to move the list to a plain file in this repo and replace
      # `urls` with:
      #   xdg.configFile."newsboat/urls".source =
      #     config.lib.file.mkOutOfStoreSymlink
      #       "${config.home.homeDirectory}/yakko_wakko/nix/modules/home/rss/urls";
      urls = [
        {
          url = "https://aquariumdrunkard.com/feed/";
          title = "Aquarium Drunkard";
          tags = [ "music" ];
        }
        {
          url = "https://excavatedshellac.com/feed/";
          title = "Excavated Shellac";
          tags = [ "music" ];
        }
        {
          url = "https://thequietus.com/feed";
          title = "The Quietus";
          tags = [ "music" ];
        }
        {
          url = "https://toneglow.substack.com/feed";
          title = "Tone Glow";
          tags = [ "music" ];
        }
        {
          url = "https://daily.bandcamp.com/feed";
          title = "Bandcamp Daily";
          tags = [ "music" ];
        }
        {
          url = "https://www.hearingthings.co/latest/rss/";
          title = "Hearing Things";
          tags = [ "music" ];
        }
      ];

      extraConfig = ''
        text-width 100
        article-sort-order date-desc

        # The Quietus (Cloudflare) 403s non-browser user agents
        user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0"

        # podboat: press `e` on an article to enqueue its enclosure, then run
        # `podboat` to download and play
        download-path "~/Downloads/podcasts/%n"
        max-downloads 2
        player "mpv"

        # ,v streams the current article's link in mpv without downloading
        # (covers YouTube/Bandcamp pages; for podcast enclosures use `e` + podboat)
        macro v set browser "mpv --force-window=yes %u" ; open-in-browser ; set browser "xdg-open %u"

        # Named ANSI slots only: newsboat can't take hex, but the terminal
        # palette is themed from config.colorScheme, so these inherit it
        color listnormal        default default
        color listnormal_unread default default bold
        color listfocus         black   blue
        color listfocus_unread  black   blue    bold
        color info              yellow  black
        color article           default default
      '';
    };
  };
}
