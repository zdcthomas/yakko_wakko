{ pkgs, lib, config, ... }:
let
  cfg = config.custom.hm.firefox;

  # Firefox's `Bookmarks` policy is additive: it only ever touches the entries
  # it created (guid prefixes PolB-/PolF-), so bookmarks added by hand survive
  # restarts. Contrast profiles.<p>.bookmarks, which re-imports the generated
  # html with replace:true on every launch and wipes anything not declared here.
  #
  # The price is a flat shape — a placement of "toolbar" or "menu" plus at most
  # one folder level.
  toPolicy = placement: folder: node:
    if node ? url then
      [
        ({
          Title = node.name;
          URL = node.url;
          Placement = placement;
        } // lib.optionalAttrs (folder != null) { Folder = folder; })
      ]
    else if folder != null then
      throw ''
        custom.hm.firefox.bookmarks: directory "${node.name}" sits inside "${folder}".
        Firefox's Bookmarks policy only supports one folder level, so flatten it.''
    else
      lib.concatMap
      (toPolicy (if node.toolbar then "toolbar" else "menu") node.name)
      node.bookmarks;

  bookmarkPolicies = lib.concatMap (toPolicy "menu" null) cfg.bookmarks;

  # The policy has no keyword field, so each bookmark keyword becomes a search
  # alias instead. "%s" in the url marks the query, as the option docs describe;
  # urls without one simply jump to the page.
  leaves = node:
    if node ? url then [ node ] else lib.concatMap leaves node.bookmarks;

  slug = s: lib.replaceStrings [ " " ] [ "-" ] (lib.toLower s);

  # Keyed by a "bookmark-" prefixed id so these can never collide with a
  # builtin engine id (our "wikipedia" bookmark would otherwise hit one).
  keywordEngines = lib.listToAttrs (map (b:
    lib.nameValuePair "bookmark-${slug b.name}" {
      name = b.name;
      urls = [{
        template = lib.replaceStrings [ "%s" ] [ "{searchTerms}" ] b.url;
      }];
      definedAliases = [ "@${slug b.keyword}" ];
    }) (lib.filter (b: b.keyword != null) (lib.concatMap leaves cfg.bookmarks)));
in with lib; {
  options = {
    custom.hm.firefox = {
      enable = mkEnableOption "Custom Firefox config";

      package = mkOption {
        type = types.nullOr types.package;
        default = if pkgs.stdenv.isLinux then pkgs.firefox else null;
        defaultText = literalExpression "pkgs.firefox";
        description = "Firefox expresion to install";
      };

      bookmarks = mkOption {
        type = let
          bookmarkSubmodule = types.submodule ({ config, name, ... }: {
            options = {
              name = mkOption {
                type = types.str;
                default = name;
                description = "Bookmark name.";
              };

              tags = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = ''
                  Bookmark tags. Currently inert: Firefox's Bookmarks policy
                  has no tag field, so these are kept only as documentation.
                '';
              };

              keyword = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = ''
                  Bookmark search keyword. Rendered as a search engine alias
                  ("@keyword"), since the Bookmarks policy has no keyword field.
                  Spaces are replaced with dashes.
                '';
              };

              url = mkOption {
                type = types.str;
                description = "Bookmark url, use %s for search terms.";
              };
            };
          }) // {
            description = "bookmark submodule";
          };

          bookmarkType = types.addCheck bookmarkSubmodule (x: x ? "url");

          directoryType = types.submodule ({ config, name, ... }: {
            options = {
              name = mkOption {
                type = types.str;
                default = name;
                description = "Directory name.";
              };

              bookmarks = mkOption {
                type = types.listOf nodeType;
                default = [ ];
                description = "Bookmarks within directory.";
              };

              toolbar = mkOption {
                type = types.bool;
                default = false;
                description = "If directory should be shown in toolbar.";
              };
            };
          }) // {
            description = "directory submodule";
          };

          nodeType = types.either bookmarkType directoryType;
        in with types;
        coercedTo (attrsOf nodeType) attrValues (listOf nodeType);
        default = [ ];
        example = literalExpression ''
          [
            {
              name = "wikipedia";
              tags = [ "wiki" ];
              keyword = "wiki";
              url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
            }
            {
              name = "kernel.org";
              url = "https://www.kernel.org";
            }
            {
              name = "Nix sites";
              toolbar = true;
              bookmarks = [
                {
                  name = "homepage";
                  url = "https://nixos.org/";
                }
                {
                  name = "wiki";
                  tags = [ "wiki" "nix" ];
                  url = "https://nixos.wiki/";
                }
              ];
            }
          ]
        '';
        description = ''
          Bookmarks to keep present. Applied through Firefox's Bookmarks
          policy, which manages only its own entries — bookmarks you add by
          hand are left alone. Removing an entry here removes it from Firefox;
          deleting one by hand just gets it re-added on the next launch.

          Directories become a folder under the bookmarks toolbar (when
          `toolbar` is set) or the bookmarks menu. Only one folder level is
          supported.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = cfg.package;
      policies.Bookmarks = bookmarkPolicies;
      profiles = {
        zdcthomas = {
          search = {
            force = true;
            engines = keywordEngines // {
              "Nix Package Search" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }];

                icon =
                  "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "NixOS Wiki" = {
                urls = [{
                  template =
                    "https://nixos.wiki/index.php?search={searchTerms}";
                }];
                icon = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@nw" ];
              };

              "bing".metaData.hidden = true;
              "google".metaData.alias =
                "@g"; # builtin engines only support specifying one additional alias
            };
          };
          isDefault = true;
          settings = {
            "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
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
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            vimium
            onetab
            ublock-origin
            lingq-importer2
            # Options live in browser.storage.local; the extension reads no
            # managed storage, so its block sets cannot be declared here.
            # Set them once in the options page, then keep a copy with the
            # "Export Options to JSON File" button.
            leechblock-ng

            onepassword-password-manager
            gruvbox-dark-theme
          ];
          # NOTE: deliberately not using profiles.<p>.bookmarks — it sets
          # browser.places.importBookmarksHTML, which re-imports with
          # replace:true on every launch. cfg.bookmarks goes through
          # policies.Bookmarks above instead, which is additive.
        };
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
