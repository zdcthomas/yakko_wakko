# TODO: <31-10-25, zdcthomas> add ventoy
{
  config,
  modulesPath,
  pkgs,
  overlays,
  lib,
  inputs,
  ...
}:
let
  management_scripts = import ../../nix_management_scripts_pkgs.nix {
    pkgs = pkgs;
    homeDirectory = config.home.homeDirectory;
  };
in
{
  imports = [ ../../modules/home ];

  # NOTE: unfree is allowed system-wide in configuration.nix; with
  # home-manager.useGlobalPkgs any nixpkgs.* set here is ignored.
  xdg = {
    desktopEntries = {
      imv-dir = {
        name = "imv-dir";
        comment = "Image Viewer";
        exec = "imv-dir %U";
        icon = "imv-dir";
        terminal = false;
        type = "Application";
        categories = [ "Graphics" ];
      };
    };

    mimeApps.defaultApplications = {
      # Images
      "image/png" = "imv-dir.desktop";
      "image/jpeg" = "imv-dir.desktop";
      "image/gif" = "imv-dir.desktop";
      "image/bmp" = "imv-dir.desktop";
      "image/tiff" = "imv-dir.desktop";
      "image/webp" = "imv-dir.desktop";
      "image/svg+xml" = "imv-dir.desktop";
      "image/x-icon" = "imv-dir.desktop";

      # Documents
      "application/pdf" = "org.pwmt.zathura.desktop";
      "application/epub" = "org.pwmt.zathura.desktop";
      "application/epub+zip" = "org.pwmt.zathura.desktop";

      # Video
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";
      "video/x-msvideo" = "mpv.desktop";

      # Audio
      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/x-wav" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/mp4" = "mpv.desktop";

      # Web
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";

      # Directories
      "inode/directory" = "thunar.desktop";
    };
  };

  # colorScheme = inputs.nix-colors.colorSchemes.everforest;
  # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
  # colorScheme = inputs.nix-colors.colorSchemes.chalk;
  # colorScheme = inputs.nix-colors.colorSchemes.rose-pine;
  # colorScheme = inputs.nix-colors.colorSchemes.windows-95;
  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-light-soft;
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-soft;
  custom.hm = {
    # qutebrowser = {
    #  enable = true;
    #};
    anyrun.enable = false;
    helix.enable = true;
    foot.enable = true;
    zellij.enable = true;
    game_dev.enable = true;
    alacritty.enable = true;
    bash.enable = true;
    cli.enable = true;
    # WordNet, Moby Thesaurus and GCIDE, offline, in every mode. `dict <word>`.
    dictionary.enable = true;
    # fish.enable = true;
    git.enable = true;
    hyprland.enable = true;
    # music_making.enable = true;
    nix.enable = true;
    rss = {
      enable = true;
      gui.enable = true;
    };
    # ssh.enable = true;
    tmux.enable = true;
    wezterm = {
      enable = true;
      opacity = "0.7";
      font-size = "10";
    };
    zathura.enable = true;
    zsh.enable = true;
    font.enable = true;

    nvim = {
      # package = pkgs.neovim-nightly;
      enable = true;
    };
    firefox = {
      enable = true;
      bookmarks = [
        {
          name = "github";
          tags = [ "git" ];
          keyword = "git";
          url = "https://github.com";
        }
        {
          name = "hey";
          tags = [
            "email"
            "hey"
          ];
          keyword = "hey";
          url = "https://app.hey.com/";
        }
        {
          name = "example nixos configurations";
          tags = [
            "nixos"
            "nix"
          ];
          keyword = "example config";
          url = "https://nixos.wiki/wiki/Configuration_Collection";
        }

        {
          name = "hyprland wiki";
          tags = [
            "wiki"
            "hyprland"
          ];
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
              tags = [
                "news"
                "tech"
              ];
              url = "https://news.ycombinator.com/";
            }
            {
              name = "Lobsters";
              tags = [
                "news"
                "tech"
              ];
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
              tags = [
                "search"
                "nix"
              ];
              url = "https://search.nixos.org/packages";
            }
            {
              name = "Options search";
              tags = [
                "search"
                "nix"
              ];
              url = "https://search.nixos.org/options";
            }
            {
              name = "Home Manager Appendix";
              tags = [
                "wiki"
                "nix"
              ];
              url = "https://nix-community.github.io/home-manager/options.xhtml";
            }
            {
              name = "wiki";
              tags = [
                "wiki"
                "nix"
              ];
              url = "https://nixos.wiki/";
            }
          ];
        }
      ];
    };
  };
  news.display = "show";
  home = {
    sessionVariables = {
      ANKI_WAYLAND = "1";
    };
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    # stateVersion = "22.05";

    # extraOutputsToInstall = [ "man" ];
    #
    # `writing` is a whitelist, and the first list is all of it. Everything
    # below it -- browsers, chat, games, the whole toolchain -- belongs to the
    # other two modes. The terminal, the editor and the usual shell tools
    # (eza, bat, fzf, fd, ripgrep, jq, tree ...) come from the custom.hm.*
    # modules, which stay on in every mode, so none of them are listed here.
    packages =
      (with pkgs; [
        # Read a source, and play music.
        zathura
        mpv
        spotify-player

        # Prose tooling. typst compiles a draft to PDF, which zathura above
        # then opens; pandoc comes from custom.hm.cli.
        typst
        # Terminal speed-reader, for reading a draft back.
        fltrdr

        # Shell odds and ends the cli module leaves out.
        file
        # A TUI mixer. pamixer is a one-shot command with no display, which is
        # awkward when the only thing playing is in another window.
        pulsemixer
      ])
      ++ lib.optionals (config.custom.hm.mode != "writing") (with pkgs; [
      claude-nixpkgs.claude-code
      # terminal multiplexer that tracks coding-agent state per pane
      herdr
      # herdr's claude integration hook is a python3 script; without it the
      # hook exits silently and agents never resume after a server restart
      python3
      # chromium-based browser for the Claude in Chrome extension
      brave
      dwarf-fortress-packages.dwarf-fortress-full
      # diagon
      # ASCII diagram tools
      plantuml
      ditaa
      overskride
      keymapp
      anki-bin

      # hivelytracker # another one
      # helio-workstation # midi composer

      pamixer
      exercism
      xfce.thunar
      sass
      ags
      eza
      texlive.combined.scheme-full
      bashInteractive
      font-awesome_5
      gnumake
      nix-init
      nurl
      weechat
      openssh

      gdb
      minicom
      usbutils

      calibre
      jp2a
      vhs
      # slides
      gum

      # minecraft
      (prismlauncher.override {
        jdks = with pkgs; [
          # Java 8
          temurin-jre-bin-8
          zulu8
          # Java 11
          temurin-jre-bin-11
          # Java 17
          temurin-jre-bin-17
          # Latest
          temurin-jre-bin
          zulu
          graalvmPackages.graalvm-ce
        ];
      })

      # rnix-lsp
      pavucontrol
      cava
      imv

      # xdg-utils
      discord

      # The desktop client, for the two modes that already have a browser.
      # `writing` gets spotify-player above instead: same music, no storefront.
      spotify
      # (fenix.complete.withComponents [
      #   "cargo"
      #   "clippy"
      #   "rust-src"
      #   "rustc"
      # ])
      ]);

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";

    # symlink the config directory. I know this isn't the nix way, but it's
    # ridiculous to invent another layer of rconfiguration languages

    keyboard = {
      # variant = "colemak";
      layout = "us";
      options = [ "caps:escape" ];
    };
  };

  programs = {
    yofi = {
      enable = true;

      settings = {
        # bg_border_color = "blue";
        # bg_color = "0x272822ee";
        corner_radius = "10 10 10 10";
        font = "PragmataPro";
        # font_size = 24;
        # force_window = false;
        # height = 512;
        # input_text = {
        #   # bg_color = "0x75715eff";
        #   # font_color = "0xf8f8f2ff";
        #   margin = "5";
        #   padding = "1.7 -4";
        # };
        # width = 400;
      };
    };
    retroarch.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      # Trust every git worktree herdr creates. A fresh worktree's .envrc is
      # unallowed, so a coding agent opening in one lands in a shell with no
      # bun, no node and no pinned Playwright browsers, and burns its first
      # moves hunting for a toolchain that is right there in the flake. Herdr
      # has no post-create hook to run `direnv allow` in, and the worktrees are
      # checkouts of repos already trusted at their source, so the trust is
      # granted here once rather than by hand every time.
      config.whitelist.prefix = [ "/home/opt/.herdr/worktrees" ];
    };
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
  services = {
    # blueman-applet.enable = true;
    # mpris-proxy.enable = true;
  };
}
