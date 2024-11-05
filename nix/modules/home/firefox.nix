{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom.hm.firefox;
in
  with lib; {
    options = {
      custom.hm.firefox = {
        enable = mkEnableOption "Custom Firefox config";

        package = mkOption {
          type = types.nullOr types.package;
          default =
            if pkgs.stdenv.isLinux
            then pkgs.firefox
            else null;
          defaultText = literalExpression "pkgs.firefox";
          description = "Firefox expresion to install";
        };

        bookmarks = mkOption {
          type = let
            bookmarkSubmodule =
              types.submodule
              ({
                config,
                name,
                ...
              }: {
                options = {
                  name = mkOption {
                    type = types.str;
                    default = name;
                    description = "Bookmark name.";
                  };

                  tags = mkOption {
                    type = types.listOf types.str;
                    default = [];
                    description = "Bookmark tags.";
                  };

                  keyword = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = "Bookmark search keyword.";
                  };

                  url = mkOption {
                    type = types.str;
                    description = "Bookmark url, use %s for search terms.";
                  };
                };
              })
              // {
                description = "bookmark submodule";
              };

            bookmarkType = types.addCheck bookmarkSubmodule (x: x ? "url");

            directoryType =
              types.submodule
              ({
                config,
                name,
                ...
              }: {
                options = {
                  name = mkOption {
                    type = types.str;
                    default = name;
                    description = "Directory name.";
                  };

                  bookmarks = mkOption {
                    type = types.listOf nodeType;
                    default = [];
                    description = "Bookmarks within directory.";
                  };

                  toolbar = mkOption {
                    type = types.bool;
                    default = false;
                    description = "If directory should be shown in toolbar.";
                  };
                };
              })
              // {
                description = "directory submodule";
              };

            nodeType = types.either bookmarkType directoryType;
          in
            with types;
              coercedTo (attrsOf nodeType) attrValues (listOf nodeType);
          default = [];
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
            Preloaded bookmarks. Note, this may silently overwrite any
            previously existing bookmarks!
          '';
        };
      };
    };
    config = mkIf cfg.enable {
      programs.firefox = {
        enable = true;
        package = cfg.package;
        profiles = {
          zdcthomas = {
            search = {
              force = true;
              engines = {
                "Nix Package Search" = {
                  urls = [
                    {
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
                    }
                  ];

                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = ["@np"];
                };

                "NixOS Wiki" = {
                  urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
                  iconUpdateURL = "https://nixos.wiki/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = ["@nw"];
                };

                "Bing".metaData.hidden = true;
                "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
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
            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
              vimium
              onetab
              ublock-origin
              lingq-importer2

              onepassword-password-manager
              gruvbox-dark-theme
            ];
            bookmarks = cfg.bookmarks;
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
