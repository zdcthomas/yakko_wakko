# TODO: <27-05-24, zdcthomas> hyprcursor
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.hm.hyprland;

  col =
    lib.attrsets.mapAttrs
    (name: value: (lib.strings.removePrefix "#" value))
    config.colorScheme.colors;

  col_hash =
    lib.attrsets.mapAttrs
    (name: value: ("#" + value + "FF"))
    config.colorScheme.colors;
  # swaylock = pkgs.swaylock-effects;
  templateFile = import ../../../templateFile.nix {inherit pkgs;};
in {
  options = {
    custom.hm.hyprland = {
      enable = lib.mkEnableOption "Enable custom hyprland";
    };
  };
  config = lib.mkIf cfg.enable {
    # https://git.sr.ht/~misterio/nix-config/tree/main/item/home/misterio/features/desktop/common/wayland-wm/waybar.nix
    services.mako = {
      enable = true;
      borderRadius = 10;
      defaultTimeout = 4000; # milliseconds
      anchor = "top-right";
      backgroundColor = col_hash.base00;
      borderColor = col_hash.base07;
      font = "FiraCode";
      actions = true;
    };
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 180;
            on-timeout = "brightnessctl -c backlight s 50%";
            on-resume = "brightnessctl -c backlight s 100%";
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

      settings = let
        wp = ../../../../images/wallpapers/alleyway.png;
      in {
        splash = false;

        preload = ["${wp}"];

        wallpaper = [
          ",${wp}"
        ];
      };
    };
    programs = {
      hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            grace = 300;
            hide_cursor = true;
            no_fade_in = false;
          };

          background = [
            {
              path = "${../../../../images/wallpapers/alleyway.png}";
              blur_passes = 3;
              blur_size = 8;
            }
          ];

          input-field = [
            {
              # TODO: <27-05-24, zdcthomas> stylix
              size = "200, 50";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(202, 211, 245)";
              inner_color = "rgb(91, 96, 120)";
              outer_color = "rgb(24, 25, 38)";
              outline_thickness = 5;
              placeholder_text = ''Welcome Back'';
              shadow_passes = 2;
            }
          ];
        };
      };
    };

    custom.hm = {
      tofi.enable = true;
      rofi.enable = true;
      waybar.enable = true;
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
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      ];
      extraConfig = let
        data = {
          rofi = "pkill rofi || ${pkgs.rofi-wayland}/bin/rofi -show drun";
          wezterm = "${pkgs.wezterm}/bin/wezterm";
          rofi_power_menu = "${pkgs.rofi-wayland}/bin/rofi -show p -modi p:'rofi-power-menu'";
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
          inputLower = "${pkgs.alsa-utils}/bin/amixer set Capture 10%-";
          inputRaise = "${pkgs.alsa-utils}/bin/amixer set Capture 10%+";
          brightnessLower = "${pkgs.brightnessctl}/bin/brightnessctl set 4%-";
          brightnessRaise = "${pkgs.brightnessctl}/bin/brightnessctl set 4%+";
          wlsunset = "${pkgs.wlsunset}/bin/wlsunset -l 40.7 -L -74.0 -s 15:00&";
          udiskie = "${pkgs.udiskie}/bin/udiskie &";
          grimblast = "${pkgs.hyprland-contrib.grimblast}/bin/grimblast";
          openFirefox = "[workspace 2 silent] ${pkgs.firefox}/bin/firefox";
          anyrun = "${pkgs.anyrun}/bin/anyrun";
          col = col;
          workspaceBindings = builtins.concatStringsSep "\n" (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in ''
                bind = $mainMod, ${ws}, workspace, ${toString (x + 1)}
                bind = $mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
              ''
            )
            10);
        };
      in
        builtins.readFile (templateFile "hyprconf" ./hyprland.conf data);
    };
    home.packages = with pkgs; [
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags =
          oldAttrs.mesonFlags
          ++ [
            "-Dexperimental=true"
          ];
      }))
      eww
      hyprland-contrib.grimblast
      udiskie
      udisks
      xwayland

      (pkgs.libsForQt5.callPackage ./xwaylandvideobridge.nix {})
      wl-gammactl
      wl-clipboard
      brightnessctl
      hyprpicker
      inotify-tools
      libnotify
      swww
      networkmanagerapplet
      pamixer

      pavucontrol
      cava
      imv

      wofi

      swayidle
    ];
  };
}
