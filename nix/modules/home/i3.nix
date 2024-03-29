{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.i3;
in {
  options = {
    custom.hm.i3 = {
      enable = lib.mkEnableOption "Enable custom i3 config";
    };
  };
  config = lib.mkIf cfg.enable {
    custom.hm = {
      picom.enable = true;
      rofi.enable = true;
    };

    home.packages = with pkgs; [
      networkmanagerapplet
      rofi-power-menu
      brightnessctl
      feh
    ];
    services.unclutter = {
      enable = true;
      timeout = 1;
    };
    xsession.enable = true;
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;

      config = rec {
        modifier = "Mod4";
        bars = [];

        window = {
          border = 0;
          titlebar = false;
        };

        gaps = {
          inner = 15;
          outer = 5;
        };

        keybindings = lib.mkOptionDefault {
          "XF86AudioMute" = "exec amixer set Master toggle";
          "XF86AudioLowerVolume" = "exec amixer set Master 4%-";
          "XF86AudioRaiseVolume" = "exec amixer set Master 4%+";
          "XF86MonBrightnessDown" = "exec brightnessctl set 4%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set 4%+";
          "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
          "${modifier}+p" = "exec ${pkgs.rofi}/bin/rofi -show p -modi p:'rofi-power-menu'";
          "${modifier}+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window";
          "${modifier}+b" = "exec ${pkgs.firefox}/bin/firefox";
          "${modifier}+Shift+x" = "exec systemctl suspend";
          "${modifier}+j" = "focus left";
          "${modifier}+k" = "focus down";
          "${modifier}+l" = "focus up";
          "${modifier}+semicolon" = "focus right";
        };
        focus.followMouse = false;

        startup = [
          {
            command = "systemctl --user restart picom";
            always = true;
            notification = false;
          }
          {
            command = "exec i3-msg workspace 1";
            always = true;
            notification = false;
          }
          {
            command = "nm-applet";
            always = true;
            notification = false;
          }
          {
            command = "systemctl --user restart polybar.service";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.feh}/bin/feh --bg-scale ~/background.jpg";
            always = true;
            notification = false;
          }
        ];
      };
    };
  };
}
