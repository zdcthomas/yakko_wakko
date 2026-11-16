{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.custom.hm.hyprland;

  col = lib.attrsets.mapAttrs (
    name: value: (lib.strings.removePrefix "#" value)
  ) config.colorScheme.palette;

  col_hash = lib.attrsets.mapAttrs (name: value: ("#" + value + "FF")) config.colorScheme.palette;
  # swaylock = pkgs.swaylock-effects;
  templateFile = import ../../../templateFile.nix { inherit pkgs; };
in
{
  imports = [ ];
  options = {
    custom.hm.hyprland = {
      enable = lib.mkEnableOption "Enable custom hyprland";
    };
    # Set by the bar module a host turns on (ags or quickshell), so this
    # module does not need to know each bar. Two bars on one host fail here,
    # as two definitions of a unique option.
    custom.hm.barService = lib.mkOption {
      type = lib.types.nullOr (lib.types.uniq lib.types.str);
      default = null;
      description = "systemd user service of the bar that draws the top bar and notifications.";
    };
  };
  config = lib.mkIf cfg.enable {
    # https://git.sr.ht/~misterio/nix-config/tree/main/item/home/misterio/features/desktop/common/wayland-wm/waybar.nix
    services.cliphist = {
      enable = true;
      systemdTargets = "hyprland-session.target";
    };
    services.mako = {
      # A custom bar is the notification daemon where a host turns one on.
      enable = config.custom.hm.barService == null;
      settings = {
        border-radius = 10;
        default-timeout = 4000; # milliseconds
        anchor = "top-right";
        background-color = col_hash.base00;
        border-color = col_hash.base07;
        text-color = col_hash.base05;
        font = "PragmataPro 11";
        actions = true;
      };
    };
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          before_sleep_cmd = "loginctl lock-session";
          ignore_dbus_inhibit = false;
          lock_cmd = "pidof hyprlock || hyprlock";
        };

        listener = [
          {
            timeout = 180;
            on-timeout = "brightnessctl -c backlight s 50%-";
            on-resume = "brightnessctl -c backlight s 50%+";
          }
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    services.hyprpaper = {
      enable = true;

      settings =
        let
          wp = ../../../../images/wallpapers/alleyway.png;
          sd = ../../../../images/wallpapers/summer-day.png;
          sn = ../../../../images/wallpapers/summer-night.png;
          wf = ../../../../images/wallpapers/waterfall.jpg;
          fh = "~/Pictures/flower_home.jpeg";
          ms = "~/Pictures/morning_sheets.jpeg";
        in
        {
          splash = false;

          preload = [
            "${wp}"
            "${sn}"
            "${sd}"
            "${wf}"
            fh
            ms
          ];

          wallpaper = [ ",${ms}" ];
        };
    };
    programs = {
      hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            grace = 5;
            hide_cursor = true;
            no_fade_in = false;
          };
          authentication = {
            fingerprint = {
              enabled = true;
            };
          };
          label = [
            {
              text = "Hello";
              color = "rgba(${col.base07}, 1.0)";
              font_family = "PragmataPro";
              font_size = 64;
              text_align = "center";
              halign = "center";
              valign = "center";
              position = "0, 160";
            }
            {
              text = "$TIME";
              color = "rgba(${col.base07}, 1.0)";
              font_family = "PragmataPro";
              font_size = 32;
              text_align = "center";
              halign = "center";
              valign = "center";
              position = "0, 75";
            }
          ];

          background = [
            {
              path = "${../../../../images/wallpapers/waterfall.jpg}";
              blur_passes = 3;
              blur_size = 8;
            }
          ];

          input-field = [
            {
              size = "200, 50";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(${col.base05})";
              inner_color = "rgb(${col.base02})";
              outer_color = "rgb(${col.base00})";
              check_color = "rgb(${col.base0A})";
              fail_color = "rgb(${col.base08})";
              outline_thickness = 5;
              placeholder_text = "Welcome Back";
              shadow_passes = 2;
            }
          ];
        };
      };
    };

    custom.hm = {
      tofi.enable = true;
      rofi.enable = true;
      # A custom bar replaces waybar where a host turns one on.
      waybar.enable = lib.mkDefault (config.custom.hm.barService == null);
    };

    wayland.windowManager.hyprland = {
      enable = true;
      # enableNvidiaPatches = true;
      systemd = {
        enable = true;
      };
      xwayland.enable = true;
      # recommendedEnvironment = true;
      plugins = [
        # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      ];
      settings = {
        exec-once = [
          "${pkgs.brightnessctl}/bin/brightnessctl set 50%"
          "nm-applet &"
          "blueman-applet"
          "${pkgs.wlsunset}/bin/wlsunset -l 40.7 -L -74.0 -s 15:00&"
          "${pkgs.udiskie}/bin/udiskie &"
          "xwaylandvideobridge"
          # clipboard watching is handled by services.cliphist
        ]
        # The AGS bar starts as a systemd user service instead.
        ++ lib.optional config.custom.hm.waybar.enable "pkill waybar; waybar";
        misc = {
          animate_manual_resizes = true;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          always_follow_on_dnd = true;
          layers_hog_keyboard_focus = true;
          enable_swallow = true;
          swallow_regex = "^(Alacritty|wezterm|kitty|footclient)$";
          focus_on_activate = true;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
          new_window_takes_over_fullscreen = 2;
        };
      };
      extraConfig =
        let
          data = {
            rofi = "pkill rofi || ${pkgs.rofi}/bin/rofi -show drun";
            wezterm = "${pkgs.wezterm}/bin/wezterm";
            rofi_power_menu = "${pkgs.rofi}/bin/rofi -show p -modi p:'rofi-power-menu'";
            wofi = "pkill wofi || ${pkgs.wofi}/bin/wofi --show drun -n";
            tofi = "${pkgs.tofi}/bin/tofi-drun -c ~/.config/tofi/tofi.launcher.conf";
            mainMod = "SUPER";
            firefox = "${pkgs.firefox}/bin/firefox";
            thunar = "${pkgs.xfce.thunar}/bin/thunar";
            alacritty = "${pkgs.alacritty}/bin/alacritty";
            hyprPickerCmd = "${pkgs.hyprpicker}/bin/hyprpicker | ${pkgs.wl-clipboard}/bin/wl-copy";
            speakerMute = "${pkgs.pamixer}/bin/pamixer -t";
            micMute = "${pkgs.pamixer}/bin/pamixer --default-source -t";
            volumeLower = "${pkgs.pamixer}/bin/pamixer -d 5";
            volumeRaise = "${pkgs.pamixer}/bin/pamixer -i 5";
            bluetooth_app = "${pkgs.overskride}/bin/overskride";
            inputLower = "${pkgs.alsa-utils}/bin/amixer set Capture 10%-";
            inputRaise = "${pkgs.alsa-utils}/bin/amixer set Capture 10%+";
            brightnessLower = "${pkgs.brightnessctl}/bin/brightnessctl set 4%-";
            brightnessRaise = "${pkgs.brightnessctl}/bin/brightnessctl set 4%+";
            cliphist = "${pkgs.cliphist}/bin/cliphist";
            restartBar =
              if config.custom.hm.barService != null then
                "systemctl --user restart ${config.custom.hm.barService}"
              else
                "pkill waybar && waybar &";
            cliphistPick = "${pkgs.cliphist}/bin/cliphist list | ${pkgs.rofi}/bin/rofi -dmenu -p clipboard | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";
            grimblast = "${pkgs.hyprland-contrib.grimblast}/bin/grimblast";
            openFirefox = "[workspace 2 silent] ${pkgs.firefox}/bin/firefox";
            # Viture Beast XR glasses, matched by EDID description so the
            # rules follow them to whichever USB-C slot they are plugged into.
            glasses = "desc:Visitech AS VITURE Beast";
            # Turns the laptop panel off so only the glasses show anything, and
            # back on. Refuses to turn the panel off when the glasses are not
            # connected; hypr-glasses-watch (below) turns it back on if the
            # glasses disconnect while it is off.
            glassesOnly = toString (
              pkgs.writeShellScript "hypr-glasses-only" ''
                jq=${pkgs.jq}/bin/jq
                if hyprctl monitors -j | $jq -e '.[] | select(.name == "eDP-1")' >/dev/null; then
                  if hyprctl monitors -j | $jq -e '.[] | select(.description == "Visitech AS VITURE Beast")' >/dev/null; then
                    hyprctl keyword monitor "eDP-1,disable"
                  else
                    ${pkgs.libnotify}/bin/notify-send "Glasses not connected" "Laptop screen stays on."
                  fi
                else
                  # Re-reading the config restores the eDP-1 monitor rule.
                  hyprctl reload
                fi
              ''
            );
            # Searchable list of every bind that has a description (bindd),
            # read live from `hyprctl binds -j`; picking one runs it. Binds
            # without a description, mouse binds and submap binds stay out.
            keybindMenu = toString (
              pkgs.writeShellScript "hypr-keybind-menu" ''
                jq=${pkgs.jq}/bin/jq
                binds=$(hyprctl binds -j | $jq -c '[.[] | select(.has_description and .submap == "" and (.mouse | not))]')
                count=$($jq length <<<"$binds")
                [ "$count" -gt 0 ] || exit 0

                pick=$($jq -r '
                  def bit($n): ((. / $n) | floor) % 2 == 1;
                  def mods: .modmask as $m
                    | [ (if ($m | bit(64)) then "SUPER" else empty end),
                        (if ($m | bit(4))  then "CTRL"  else empty end),
                        (if ($m | bit(8))  then "ALT"   else empty end),
                        (if ($m | bit(1))  then "SHIFT" else empty end) ];
                  def keyname: {
                      "bracketleft": "[", "bracketright": "]",
                      "braceleft": "{", "braceright": "}",
                      "Return": "Enter", "TAB": "Tab", "space": "Space",
                      "XF86AudioMute": "Mute", "XF86AudioMicMute": "MicMute",
                      "XF86AudioLowerVolume": "Vol-", "XF86AudioRaiseVolume": "Vol+",
                      "XF86MonBrightnessDown": "Bright-", "XF86MonBrightnessUp": "Bright+"
                    }[.] // (if length == 1 then ascii_upcase else . end);
                  def pad($n): . + (" " * ([$n - length, 1] | max));
                  .[] | "\(.description | pad(42))\((mods + [.key | keyname]) | join(" + "))"
                ' <<<"$binds" | ${pkgs.rofi}/bin/rofi -dmenu -i -p keybinds -format i)

                case "$pick" in ""|*[!0-9]*) exit 0 ;; esac
                [ "$pick" -lt "$count" ] || exit 0
                dispatcher=$($jq -r ".[$pick].dispatcher" <<<"$binds")
                arg=$($jq -r ".[$pick].arg" <<<"$binds")
                exec hyprctl dispatch "$dispatcher" "$arg"
              ''
            );
            anyrun = "${pkgs.anyrun}/bin/anyrun";
            yofi = "${pkgs.yofi}/bin/yofi";
            col = col;
            workspaceBindings = builtins.concatStringsSep "\n" (
              builtins.genList (
                x:
                let
                  ws =
                    let
                      c = (x + 1) / 10;
                    in
                    builtins.toString (x + 1 - (c * 10));
                in
                ''
                  bindd = $mainMod, ${ws}, Go to workspace ${toString (x + 1)}, workspace, ${toString (x + 1)}
                  bindd = $mainMod SHIFT, ${ws}, Move window to workspace ${toString (x + 1)}, movetoworkspace, ${toString (x + 1)}
                ''
              ) 10
            );
          };
        in
        builtins.readFile (templateFile "hyprconf" ./hyprland.conf data);
    };
    # Glasses-only mode (SUPER+ALT+G) turns eDP-1 off. If the glasses then
    # disconnect, nothing is left to show the session, so this watches
    # Hyprland's event socket and re-reads the config (which turns eDP-1 back
    # on) when a monitor goes away while eDP-1 is off and the glasses are gone.
    systemd.user.services.hypr-glasses-watch =
      let
        hyprctl = "${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl";
        jq = "${pkgs.jq}/bin/jq";
        watch = pkgs.writeShellScript "hypr-glasses-watch" ''
          restore_if_dark() {
            monitors=$(${hyprctl} monitors -j)
            ${jq} -e '.[] | select(.name == "eDP-1")' >/dev/null <<<"$monitors" && return
            ${jq} -e '.[] | select(.description == "Visitech AS VITURE Beast")' >/dev/null <<<"$monitors" && return
            echo "eDP-1 is off and the glasses are gone: reloading the config"
            ${hyprctl} reload
          }
          # Covers glasses that left while this service was not running.
          restore_if_dark
          ${pkgs.socat}/bin/socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
            while IFS= read -r event; do
              case "$event" in
                monitorremoved*)
                  sleep 1
                  restore_if_dark
                  ;;
              esac
            done
        '';
      in
      {
        Unit = {
          Description = "Turn the laptop screen back on when the XR glasses disconnect in glasses-only mode";
          PartOf = [ "hyprland-session.target" ];
          After = [ "hyprland-session.target" ];
        };
        Service = {
          ExecStart = "${watch}";
          Restart = "always";
          RestartSec = 2;
        };
        Install.WantedBy = [ "hyprland-session.target" ];
      };

    # Size matches `env = XCURSOR_SIZE,24` in hyprland.conf; change both together.
    home.pointerCursor = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 24;
      gtk.enable = true;
    };

    # GTK_THEME=Adwaita:dark in hyprland.conf only reaches GTK3 and leaves icons
    # unthemed, which is why thunar/blueman/nm-connection-editor look unstyled.
    gtk = {
      enable = true;
      theme = {
        name = "Gruvbox-Dark";
        package = pkgs.gruvbox-gtk-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      font = {
        name = "PragmataPro";
        size = 11;
      };
    };

    # libadwaita/GTK4 apps ignore the theme name and only honour this.
    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    home.packages = with pkgs; [
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
      eww
      blueman
      hyprland-contrib.grimblast
      udiskie
      udisks
      xwayland

      # (pkgs.libsForQt5.callPackage ./xwaylandvideobridge.nix { })
      wl-gammactl
      wl-clipboard
      brightnessctl
      hyprpicker
      inotify-tools
      libnotify
      networkmanagerapplet
      pamixer

      pavucontrol
      cava
      imv

      wofi
    ];
  };
}
