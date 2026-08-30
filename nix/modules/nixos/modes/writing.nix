# `writing` -- prose. Hyprland still runs and waybar still shows, but nothing
# that opens a page exists, and the network joins nothing on its own.
#
# The user-environment side of this mode is in nix/modules/home/mode.nix.
{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.zdct.modes.enable && config.zdct.mode == "writing") {
    # configuration.nix installs Firefox system-wide, which would survive the
    # home-manager side turning its own module off.
    programs.firefox.enable = lib.mkForce false;

    # The user's package list is trimmed in hosts/opt/configuration.nix,
    # gated on zdct.mode. It cannot be replaced from here: useUserPackages
    # makes home-manager append home.packages to that same list, so an
    # mkForce takes the editor and the terminal down with the soulseek
    # client -- which is exactly what it did.
  };
}
