{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
    };
    settings = {
      bottomBar = {
        layer = "top";
        position = "bottom";
        height = 24;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-right = [
          "uptime"
          "backlight"
          "pulseaudio"
          "battery"
          "clock"
          "tray"
        ];
        # "sway/workspaces" = {
        #   all-outputs = false;
        #   format = "{index}";
        #   disable-scroll = false;
        #   disable-click = false;
        #   enable-bar-scroll = false;
        #   numeric-first = true;
        # };
        # "sway/mode" = {
        #   format = "{}";
        #   tooltip = false;
        #   on-click = "";
        # };
        # "sway/window" = {
        #   format = "{}";
        #   max-length = 64;
        #   on-click = "";
        # };
        "custom/uptime" = {
          format = "{}";
          return-type = "";
          interval = 10;
          exec = "${pkgs.coreutils}/bin/uptime | ${pkgs.gnused}/bin/sed 's/^.* up \\+\\(.\\+\\), \\+[0-9] user.*$/\\1/' | ${pkgs.gnused}/bin/sed 's/  / /g'";
          on-click = "";
        };
        backlight = {
          device = "intel_backlight";
          format = "{percent}%";
          on-scroll-up = "${pkgs.light}/bin/light -A 5";
          on-scroll-down = "${pkgs.light}/bin/light -U 5";
          on-click = "";
        };
        pulseaudio = {
          format = "{volume}%";
          format-muted = "muted";
          scroll-step = 5;
          on-click = "";
        };
        battery = {
          format = "{capacity}% {time}h";
          format-time = "{H:02}:{M:02}";
          bat = "BAT0";
          on-click = "";
        };
        clock = {
          interval = 1;
          format = "{:%F %H:%M:%S}";
          on-click = "";
        };
        tray = {
          icon-size = 30;
          spacing = 8;
        };
      };
      topBar = {
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [
          "idle_inhibitor"
          "custom/load"
          "cpu"
          "memory"
        ];
        modules-right = [
          "temperature"
          "network#wifi"
          "network#ethernet"
        ];
        "hyprland/workspaces" = {
          all-outputs = false;
          format = "{index}";
          disable-scroll = false;
          disable-click = false;
          enable-bar-scroll = false;
          numeric-first = true;
        };
        "custom/load" = {
          format = "{}";
          exec = "${pkgs.coreutils}/bin/echo -n \"Load \"; ${pkgs.coreutils}/bin/cat /proc/loadavg | ${pkgs.coreutils}/bin/cut -f1-3 -d' '";
          interval = 5;
          on-click = "";
        };
        cpu = {
          interval = 1;
          format = "CPU {usage}%";
          max-length = 10;
          on-click = "";
        };
        memory = {
          interval = 30;
          format = "RAM: {used:0.1f}G/{total:0.1f}G";
          on-click = "";
        };
        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon5/temp1_input";
          critical-threshold = 90;
          format-critical = "HOT {temperatureC}°C";
          format = "{temperatureC}°C";
          on-click = "";
        };
        "disk#root" = {
          interval = 30;
          format = "{path}: {percentage_used}%";
          path = "/";
          on-click = "";
        };
        "disk#home" = {
          interval = 30;
          format = "{path}: {percentage_used}%";
          path = "/home";
          on-click = "";
        };
        "network#wifi" = {
          interface = "wlp59s0";
          format = "{ifname}: {ipaddr}";
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "{ifname}";
          format-disconnected = "";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          on-click = "";
        };
        "network#ethernet" = {
          interface = "enp58s0u1u4";
          format = "{ifname}: {ipaddr} {bandwidthUpBits} up, {bandwidthDownBits} down";
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "{ifname}: {ipaddr}";
          format-disconnected = "{ifname}: disconnected";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          on-click = "";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          on-click = "";
        };
        # "custom/notifs" = {
        #   format = "{icon}";
        #   format-icons = {
        #     notification = "<span foreground='red'></span>";
        #     none = "";
        #     dnd-none = "";
        #     dnd-notification = "<span foreground='red'></span>";
        #   };
        #   tooltip = false;
        #   return-type = "json";
        #   exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
        #   on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
        #   on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
        #   on-click-middle = "${pkgs.swaynotificationcenter}/bin/swaync-client -C";
        #   escape = true;
        # };
        # "custom/powerprofile" = {
        #   format = "{}";
        #   exec = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl get";
        #   interval = 5;
        #   signal = 8;
        #   on-click = "if [[ \"$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get)\" = \"performance\" ]]; then ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver; elif [[ \"$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get)\" = \"balanced\" ]]; then ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance; elif [[ \"$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get)\" = \"power-saver\" ]]; then ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced; fi; pkill -SIGRTMIN+8 waybar";
        #   on-click-right = "if [[ \"$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get)\" = \"performance\" ]]; then ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced; elif [[ \"$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get)\" = \"balanced\" ]]; then ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver; elif [[ \"$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get)\" = \"power-saver\" ]]; then ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance; fi; pkill -SIGRTMIN+8 waybar";
        # };
      };
    };

    # style = pkgs.substituteAll { src = ./waybar.css; font = config.gtk.font.name; };
  };
}
