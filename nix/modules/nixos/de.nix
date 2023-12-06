{
  de,
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.zdct.de;
  art = lib.strings.concatStringsSep "\n" [
    "──────▄▀▄─────▄▀▄──────"
    "─────▄█░░▀▀▀▀▀░░█▄─────"
    "─▄▄──█░░░░░░░░░░░█──▄▄─"
    "█▄▄█─█░░▀░░┬░░▀░░█─█▄▄█"
  ];
in
  with lib; {
    options = {
      zdct.de =
        mkOption
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
          nix = {
            settings = {
              substituters = ["https://hyprland.cachix.org"];
              trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
            };
          };
          environment.sessionVariables = {
            # If your cursor becomes invisible
            WLR_NO_HARDWARE_CURSORS = "1";

            MOZ_ENABLE_WAYLAND = "1";
            # hint Electron apps to use wayland
            NIXOS_OZONE_WL = "1";
          };
          security.rtkit.enable = true;

          services.greetd = {
            enable = true;
            settings = {
              default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd ${pkgs.hyprland}/bin/Hyprland -g \"${art}\" --remember --user-menu --asterisks";
              };
            };
          };

          security.pam.services.swaylock = {
            #Swaylock fix for wrong password
            text = ''
              auth include login
            '';
          };

          # xdg.portal = {
          #   enable = true;
          #   extraPortals = [pkgs.xdg-desktop-portal-gnome];
          # };

          programs.hyprland = {
            enable = true;
            portalPackage = pkgs.xdg-desktop-portal-hyprland;
            # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
            # enableNvidiaPatches = true;
            xwayland.enable = true;
          };
        }
      )
    ];
  }
