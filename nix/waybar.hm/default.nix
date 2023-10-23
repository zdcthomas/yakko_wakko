{
  config,
  pkgs,
  lib,
  ...
}: let
  col =
    lib.attrsets.mapAttrs
    (name: value: ("#" + value))
    config.colorScheme.colors;
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags =
        oldAttrs.mesonFlags
        ++ [
          "-Dexperimental=true"
        ];
    });

    systemd = {
      enable = false;
      target = "hyprland-session.target";
    };
    settings = {
      top = {
        layer = "top"; # Waybar at top layer
        height = 30; # Waybar height (to be removed for auto height)
        spacing = 4; # Gaps between modules (4px)
        modules-left = ["network" "tray" "pulseaudio" "idle_inhibitor" "bluetooth" "hyprland/submap"];
        modules-center = ["hyprland/workspaces"];
        modules-right = ["cpu" "memory" "temperature" "backlight" "battery" "clock"];
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
            off = "<span color=\"${col.base0C}\"></span> ";
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
          format-critical = "{temperatureC}°C";
          format = "{temperatureC}°C";
          format-icons = ["" "" ""];
        };
        backlight = {
          format = "{icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
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
          format-icons = ["" "" "" "" ""];
        };
        "battery#bat2" = {
          bat = "BAT2";
        };
        network = {
          format-wifi = "{essid}:{signalStrength}%";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          # on-click = "alacritty -e nmtui";
        };
        bluetooth = {
          format = " {status}";
          "format-connected" = " {device_alias}";
          "format-connected-battery" = " {device_alias} {device_battery_percentage}%";
          # // "format-device-preference" = [ "device1" "device2" ], // preference list deciding the displayed device;
          "tooltip-format" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
          "tooltip-format-enumerate-connected-battery" = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };
        wireplumber = {
          format = "{volume}% {icon}";
          "format-muted" = "";
          "on-click" = "helvum";
          "format-icons" = ["" "" ""];
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "{format-source-muted} {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
      };
    };

    style = ''
      @define-color bg-hover ${col.base01};
      @define-color bg ${col.base00};
      @define-color blue ${col.base08};
      @define-color sky ${col.base08};
      @define-color red ${col.base0E};
      @define-color pink ${col.base09};
      @define-color lavender ${col.base0B};
      @define-color rosewater ${col.base05};
      @define-color flamingo ${col.base0A};
      @define-color fg ${col.base0F};
      @define-color green ${col.base0D};
      @define-color dark-fg ${col.base03};
      @define-color peach ${col.base0C};
      @define-color gray2 ${col.base04};
      @define-color black4 ${col.base02};
      @define-color black3 ${col.base00};
      @define-color maroon ${col.base09};
      @define-color border @dark-fg;

      ${builtins.readFile ./style.css}
    '';
  };
}
