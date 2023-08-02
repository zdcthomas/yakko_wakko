{ de, lib, config, pkgs, inputs, ... }:
let
  cfg = config.zdct.de;
in
with lib;
{
  options =
    {
      zdct.de = mkOption
        {
          type = types.enum [
            "i3"
            "hyprland"
          ];
          default = "i3";
        };
    };
  config = mkMerge [
    (
      mkIf (cfg == "i3")
        {
          # Enable the X11 windowing system.
          services.xserver = {
            enable = true;
            # xkbOptions = "caps:escape";
            layout = "us";
            autorun = true;
            displayManager = {
              defaultSession = "none+i3";
              autoLogin = {
                enable = true;
                user = "zdcthomas";
              };
              lightdm = {
                enable = true;
              };
            };

            desktopManager = {
              xterm.enable = false;
            };

            windowManager.i3.enable = true;
          };


        }

    )
    (
      mkIf
        (cfg == "hyprland")
        {
          environment.sessionVariables = {
            # If your cursor becomes invisible
            WLR_NO_HARDWARE_CURSORS = "1";

            # hint Electron apps to use wayland
            NIXOS_OZONE_WL = "1";
          };
          xdg.portal = {
            enable = true;
            extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          };
          security.rtkit.enable = true;

          services.xserver.enable = true;
          services.xserver.displayManager = {
            defaultSession = "hyprland";
            sddm = {
              enable = true;
              theme = "elarun";
            };
          };


          security.pam.services.swaylock = {
            #Swaylock fix for wrong password
            text = ''
              auth include login
            '';
          };

          programs.hyprland = {
            enable = true;
            # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
            nvidiaPatches = true;
            xwayland.enable = true;
          };
        }
    )
  ];
}
