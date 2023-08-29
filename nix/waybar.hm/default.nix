{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    package =
      (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [
          "-Dexperimental=true"
        ];
      }));

    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = {
      top = {
        layer = "top"; # Waybar at top layer
        height = 30; # Waybar height (to be removed for auto height)
        spacing = 4; # Gaps between modules (4px)
        modules-left = [ "wlr/workspaces" "hyprland/submap" ];
        modules-center = [ ];
        modules-right = [ "tray" "pulseaudio" "network" "cpu" "memory" "temperature" "backlight" "keyboard-state" "battery" "clock" ];

        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };

        "wlr/workspaces" = {
          on-click = "activate";
          disable-scroll = true;
          on-scroll-up = "hyprctl dispatch workspace m-1 > /dev/null";
          on-scroll-down = "hyprctl dispatch workspace m+1 > /dev/null";
        };
        mpd = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          unknown-tag = "N/A";
          interval = 2;
          consume-icons = {
            on = " ";
          };
          random-icons = {
            off = "<span color=\"#f53c3c\"></span> ";
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        tray = {
          icon-size = 21;
          spacing = 10;
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        temperature = {
          critical-threshold = 80;
          format-critical = "{temperatureC}°C {icon}";
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };
        backlight = {
          format = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        "battery#bat2" = {
          bat = "BAT2";
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          on-click = "alacritty -e nmtui";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = "X {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        # "custom/media" = {
        #   format = "{icon} {}";
        #   return-type = "json";
        #   max-length = 40;
        #   format-icons = {
        #     spotify = "";
        #     default = "🎜";
        #   };
        #   escape = true;
        #   exec = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null";
        # };
      };
    };

    style = ''
      @define-color bg-hover #1A1A28;
      @define-color bg #1E1E2E;
      @define-color blue #89B4FA;
      @define-color sky #89DCEB;
      @define-color red #F38BA8;
      @define-color pink #F5C2E7;
      @define-color lavender #B4BEFE;
      @define-color rosewater #F5E0DC;
      @define-color flamingo #F2CDCD;
      @define-color fg #D9E0EE;
      @define-color green #A6E3A1;
      @define-color dark-fg #161320;
      @define-color peach #FAB387;
      @define-color border @lavender;
      @define-color gray2 #6E6C7E;
      @define-color black4 #575268;
      @define-color black3 #302D41;
      @define-color maroon #EBA0AC;

      ${builtins.readFile ./style.css}
    '';
  };
}
