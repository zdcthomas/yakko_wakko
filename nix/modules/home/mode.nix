# The user-environment half of a mode. The NixOS half lives in
# nix/modules/nixos/modes, and it is what sets this option.
#
# Nothing here decides which mode is active. This module only reacts.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.hm;
in
{
  options.custom.hm.mode = lib.mkOption {
    type = lib.types.enum [
      "open"
      "making"
      "writing"
    ];
    default = "open";
    description = ''
      The active mode, set from the NixOS side. Read it to decide what a
      module installs or how it looks; never set it from a home-manager
      module.
    '';
  };

  config = lib.mkMerge [
    # `making` keeps the whole desktop and changes only its face, so the
    # wallpaper is the signal that the blocklist is live.
    (lib.mkIf (cfg.mode == "making" && cfg.hyprland.enable) {
      services.hyprpaper.settings.wallpaper = lib.mkForce [
        ",${../../../images/wallpapers/waterfall.jpg}"
      ];
    })

    (lib.mkIf (cfg.mode == "writing") {
      # Nothing that opens a page, a feed or a store.
      custom.hm.firefox.enable = lib.mkForce false;
      custom.hm.rss.enable = lib.mkForce false;
      custom.hm.game_dev.enable = lib.mkForce false;
      programs.retroarch.enable = lib.mkForce false;

      # The hyprland module turns these two on; a launcher reaches anything
      # installed, which is the opposite of a whitelist. Unbinding the key is
      # not enough on its own, because the binary stays in PATH.
      custom.hm.rofi.enable = lib.mkForce false;
      custom.hm.tofi.enable = lib.mkForce false;
      programs.yofi.enable = lib.mkForce false;
    })

    (lib.mkIf (cfg.mode == "writing" && cfg.hyprland.enable) {
      # A flat colour instead of an image, so there is one fewer service and
      # nothing to fail to load.
      services.hyprpaper.enable = lib.mkForce false;

      wayland.windowManager.hyprland = {
        settings = {
          misc.background_color = "rgb(ede8d0)";

          exec-once = [
            # Land in the writing directory with the editor already open.
            # Quitting the editor leaves a shell rather than closing the
            # window, because you still need git at the end of a session.
            ''${pkgs.wezterm}/bin/wezterm start --cwd ${config.home.homeDirectory}/Irulan -- ${pkgs.zsh}/bin/zsh -c "nvim; exec zsh"''
          ];
        };

        # mkAfter so these land below the binds the template file sets. A
        # launcher reaches anything installed, and $browser is the one thing
        # this mode exists to remove -- the key would otherwise fail silently
        # and look like a bug.
        extraConfig = lib.mkAfter ''
          unbind = SUPER, D
          unbind = SUPER + SHIFT, d
          unbind = SUPER, b
        '';
      };
    })
  ];
}
