{ pkgs, lib, ... }:

{
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = rec {
      modifier = "Mod4";
      bars = [ ];

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
      };

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
}

