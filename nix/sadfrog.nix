{ config, pkgs, ... }:
# DELETE ME
{
  home = {
    packages = with pkgs; [
      ffmpeg
      firefox
      lshw
      beets
      nodejs-18_x
      soulseekqt
      # expressvpn
    ];

    file = {
      ".config/beets/config.yaml".source = ../config/beets/config.yaml;
    };
  };

  programs = {
    firefox = {
      enable = true;
      # profiles.sadfrog = {
      # settings = {
      # "browser.startup.homepage" = "http://lararium:8123";
      # };
      # search = {
      # default = "Google";
      # order = [ "Google" "Nix Packages" "NixOS Wiki" ];
      # engines = {
      # "Nix Packages" = {
      # urls = [{
      # template = "https://search.nixos.org/packages";
      # params = [
      # { name = "type"; value = "packages"; }
      # { name = "query"; value = "{searchTerms}"; }
      # ];
      # }];

      # icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      # definedAliases = [ "@np" ];
      # };

      # "NixOS Wiki" = {
      # urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
      # iconUpdateURL = "https://nixos.wiki/favicon.png";
      # updateInterval = 24 * 60 * 60 * 1000; # every day
      # definedAliases = [ "@nw" ];
      # };

      # "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
      # };
      # };
      # bookmarks = [
      # {
      # name = "wikipedia";
      # keyword = "wiki";
      # url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
      # }
      # {
      # name = "kernel.org";
      # url = "https://www.kernel.org";
      # }
      # {
      # name = "Nix sites";
      # bookmarks = [
      # {
      # name = "homepage";
      # url = "https://nixos.org/";
      # }
      # {
      # name = "wiki";
      # url = "https://nixos.wiki/";
      # }
      # ];
      # }
      # ];
      # };
    };
  };
}
