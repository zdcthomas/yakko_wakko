# `writing` -- prose. Hyprland still runs and waybar still shows, but nothing
# that opens a page exists, and the network joins nothing on its own.
#
# The user-environment side of this mode is in nix/modules/home/mode.nix.
{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  config = lib.mkIf (config.zdct.modes.enable && config.zdct.mode == "writing") {
    # configuration.nix installs Firefox system-wide, which would survive the
    # home-manager side turning its own module off.
    programs.firefox.enable = lib.mkForce false;

    # This list has a single definition in configuration.nix, so replacing it
    # wholesale is safe here. It drops the soulseek client and the hardware
    # tooling, and keeps the editor, git and enough audio control to fix a
    # silent machine. `switch` stays: a mode is not a trap.
    users.users.${username}.packages = lib.mkForce (
      with pkgs;
      [
        git
        vim
        alsa-utils
        pamixer
        (pkgs.writeScriptBin "switch" ''
          nixos-rebuild \
            --flake ~/yakko_wakko#opt \
            --use-remote-sudo -L \
            switch
        '')
      ]
    );

  };
}
