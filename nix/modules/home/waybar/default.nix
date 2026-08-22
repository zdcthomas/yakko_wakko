{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.hm.waybar;
  col = lib.attrsets.mapAttrs (name: value: ("#" + value)) config.colorScheme.colors;
in
{
  options = {
    custom.hm.waybar = {
      enable = lib.mkEnableOption "Enable custom waybar";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });

      systemd = {
        enable = false;
        target = "hyprland-session.target";
      };
      settings = {
        top = {
          layer = "top"; # Waybar at top layer
          height = 26; # Matches the font size and pill margins in style.css
          spacing = 0; # Gaps come from CSS margins, not here
          reload_style_on_change = true;
          modules-left = [
            "network"
            "tray"
            "pulseaudio"
            "idle_inhibitor"
            "bluetooth"
            "custom/airpods"
            "custom/mouse-toggle"
            "hyprland/submap"
          ];
          modules-center = [ "hyprland/workspaces" ];
          modules-right = [
            "cpu"
            "memory"
            "temperature"
            "backlight"
            "battery"
            "clock"
          ];
          "hyprland/workspaces" = {
            on-click = "activate";
            sort-by-number = true;
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          tray = {
            icon-size = 16;
            spacing = 10;
          };
          "custom/airpods" = {
            format = "🎧";
            tooltip = false;
            on-click = pkgs.writeShellScript "toggle-airpods" ''
              AIRPODS="2C:18:09:F3:C6:E0"
              BLUETOOTHCTL="${pkgs.bluez}/bin/bluetoothctl"
              DEVICES=$($BLUETOOTHCTL devices Connected)

              if [[ "$DEVICES" == *"$AIRPODS"* ]]; then
                  $BLUETOOTHCTL disconnect $AIRPODS
                  $BLUETOOTHCTL block $AIRPODS
              else
                  $BLUETOOTHCTL unblock $AIRPODS
                  $BLUETOOTHCTL connect $AIRPODS
              fi
            '';
          };
          "custom/mouse-toggle" = {
            format = "{}";
            return-type = "json";
            # No polling: the on-click handler signals waybar to re-read state.
            interval = "once";
            signal = 8;
            exec = pkgs.writeShellScript "gamemode-status" ''
              HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
              if [ "$HYPRGAMEMODE" = 1 ] ; then
                printf '{"text":"🎮","class":"inactive","tooltip":"Gamemode off - click to disable animations"}\n'
              else
                printf '{"text":"🎮","class":"active","tooltip":"Gamemode on - click to restore animations"}\n'
              fi
            '';
            on-click = pkgs.writeShellScript "toggle-gamemode" ''
              HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
              if [ "$HYPRGAMEMODE" = 1 ] ; then
                  hyprctl --batch "\
                      keyword animations:enabled 0;\
                      keyword animation borderangle,0; \
                      keyword decoration:shadow:enabled 0;\
                      keyword decoration:blur:enabled 0;\
                      keyword decoration:fullscreen_opacity 1;\
                      keyword general:gaps_in 0;\
                      keyword general:gaps_out 0;\
                      keyword general:border_size 1;\
                      keyword decoration:rounding 0;\
                      keyword input:touchpad:disable_while_typing 0"
                  hyprctl notify 1 5000 "rgb(40a02b)" "Gamemode [ON]"
              else
                  hyprctl notify 1 5000 "rgb(d20f39)" "Gamemode [OFF]"
                  hyprctl reload
              fi
              # Tell the status module above to re-read the new state.
              ${pkgs.procps}/bin/pkill -RTMIN+8 waybar
            '';
          };
          clock = {
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
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
            # k10temp/Tctl. Absolute path because hwmonN indices shuffle across boots.
            hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
            input-filename = "temp1_input";
            critical-threshold = 85;
            format-critical = "{icon} {temperatureC}°C";
            format = "{icon} {temperatureC}°C";
            format-icons = [
              ""
              ""
              ""
            ];
          };
          backlight = {
            format = "{icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
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
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          network = {
            format-wifi = "{essid}:{signalStrength}%";
            format-ethernet = "{ipaddr}/{cidr} ";
            tooltip-format = "{ifname} via {gwaddr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
          };
          bluetooth = {
            "on-click" = "${pkgs.blueman}/bin/blueman-manager";
            "on-click-right" = "${pkgs.overskride}/bin/overskride";
            format = " {status}";
            "format-connected" = " {device_alias}";
            "format-connected-battery" = " {device_alias} {device_battery_percentage}%";
            # // "format-device-preference" = [ "device1" "device2" ], // preference list deciding the displayed device;
            "tooltip-format" = ''
              {controller_alias}	{controller_address}

              {num_connections} connected'';
            "tooltip-format-connected" = ''
              {controller_alias}	{controller_address}

              {num_connections} connected

              {device_enumerate}'';
            "tooltip-format-enumerate-connected" = "{device_alias}	{device_address}";
            "tooltip-format-enumerate-connected-battery" =
              "{device_alias}	{device_address}	{device_battery_percentage}%";
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
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
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
  };
}
