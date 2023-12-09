{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.qutebrowser;
in {
  options = {
    custom.hm.qutebrowser = {
      enable = lib.mkEnableOption "Enable custom qutebrowser";
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      qutebrowser = {
        enable = true;
        enableDefaultBindings = true;
        quickmarks = {
          home-manager = "https://nix-community.github.io/home-manager/options.html";
          nixos-packages = "https://search.nixos.org/packages";
          options = "https://search.nixos.org/options";
          wikipedia = "https://en.wikipedia.org";
          news = "https://news.ycombinator.com";
          lobsters = "https://lobste.rs";
        };
        searchEngines = {
          w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
          aw = "https://wiki.archlinux.org/?search={}";
          nw = "https://nixos.wiki/index.php?search={}";
          g = "https://www.google.com/search?hl=en&q={}";
        };
        extraConfig = ''
          c.fonts.default_family = "Pragmata Pro"
          c.fonts.default_size = "10pt"
        '';
      };
    };
  };
}
