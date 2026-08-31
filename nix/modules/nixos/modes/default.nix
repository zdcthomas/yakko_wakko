# Modes: three postures of the machine, chosen at the boot menu.
#
# See CONTEXT.md for what a mode is, and docs/adr/0001-reboot-only-mode-switching.md
# for why switching costs a reboot and nothing cheaper.
#
# `open` is the parent configuration, so it is the default boot entry. `making`
# and `writing` are specialisations, and each one only forces `zdct.mode`. The
# per-mode files below react to that value, so there is exactly one place that
# decides which mode is active.
{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.zdct.modes;
in
{
  imports = [
    ./making.nix
    ./writing.nix
  ];

  options.zdct = {
    mode = lib.mkOption {
      type = lib.types.enum [
        "open"
        "making"
        "writing"
      ];
      default = "open";
      description = ''
        The active mode. The parent configuration keeps the default, and each
        specialisation forces its own value. Published at /etc/yakko-mode so
        waybar and shell prompts can read it without asking Nix anything.
      '';
    };

    modes = {
      enable = lib.mkEnableOption "the writing/making/open mode specialisations";

      blocklist = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          Domains that `making` and `writing` make unreachable. blocky blocks
          each name and every subdomain under it, so `youtube.com` also covers
          `m.youtube.com`. `open` ignores this list entirely.
        '';
        default = [
          "instagram.com"
          "facebook.com"
          "fb.com"
          "messenger.com"
          "tiktok.com"
          "twitch.tv"
          "x.com"
          "twitter.com"
          "t.co"
          "reddit.com"
          "redd.it"
          "youtube.com"
          "youtu.be"
          "youtube-nocookie.com"
          "substack.com"
          "astralcodexten.com"
          "slatestarcodex.com"
          "news.ycombinator.com"
          "lobste.rs"
          "bsky.app"
          "bsky.social"
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.etc."yakko-mode".text = "${config.zdct.mode}\n";

      # Boot menu legibility. systemd-boot builds each title as
      # `distroName (specialisation)`, and distroName comes from the parent
      # configuration, so the mode can never lead the title and the parent
      # entry carries no specialisation part at all. What is left is the
      # version line, which defaults to the full NixOS release string and is
      # identical on every entry. Replacing it with the mode name is what
      # makes one row distinguishable from the next.
      system.nixos.label = config.zdct.mode;

      # Home-manager runs as a NixOS module here, so the mode reaches the user
      # environment through one option rather than through a file read at
      # activation time.
      home-manager.users.${username}.custom.hm.mode = config.zdct.mode;

      # `writing` boots with the network down; the other two boot with it up.
      # NetworkManager remembers this across reboots in its own state file, so
      # every mode sets it explicitly rather than only the one that wants it
      # off -- otherwise one writing session would silently leave the machine
      # offline in `making` the next morning.
      systemd.services.mode-networking = {
        description = "Set NetworkManager's networking state for the active mode";
        wantedBy = [ "multi-user.target" ];
        after = [ "NetworkManager.service" ];
        requires = [ "NetworkManager.service" ];
        serviceConfig.Type = "oneshot";
        script = "${pkgs.networkmanager}/bin/nmcli networking ${
          if config.zdct.mode == "writing" then "off" else "on"
        }";
      };

      specialisation = {
        making.configuration = {
          zdct.mode = lib.mkForce "making";
        };
        writing.configuration = {
          zdct.mode = lib.mkForce "writing";
        };
      };
    }

    # The blocklist is the one thing `making` and `writing` share. blocky
    # resolves everything else and answers 0.0.0.0 for the listed names, which
    # a hosts file cannot do for subdomains.
    (lib.mkIf (config.zdct.mode != "open") {
      services.blocky = {
        enable = true;
        settings = {
          # Loopback only. The machine is on tailscale, and a resolver bound to
          # every interface would answer for the whole tailnet.
          ports.dns = "127.0.0.1:53";
          upstreams.groups.default = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          blocking = {
            denylists.distractions = [
              (pkgs.writeText "mode-blocklist" (
                lib.concatStringsSep "\n" cfg.blocklist + "\n"
              ))
            ];
            clientGroupsBlock.default = [ "distractions" ];
            blockType = "zeroIp";
          };
          # Without this the resolver logs every query the machine makes.
          log.level = "warn";
        };
      };

      # NetworkManager would otherwise write the DHCP-supplied resolvers into
      # resolv.conf and route straight past blocky.
      networking = {
        networkmanager.dns = "none";
        nameservers = [ "127.0.0.1" ];
      };
    })
  ]);
}
