{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  # col = color: (lib.strings.removePrefix "#" config.colorScheme.colors.${color});
  col =
    lib.attrsets.mapAttrs
    (name: value: (lib.strings.removePrefix "#" value))
    config.colorScheme.colors;

  col_hash =
    lib.attrsets.mapAttrs
    (name: value: ("#" + value + "FF"))
    config.colorScheme.colors;
  swaylock = pkgs.swaylock-effects;
  templateFile = import ../templateFile.nix {inherit pkgs;};
in
  # https://git.sr.ht/~misterio/nix-config/tree/main/item/home/misterio/features/desktop/common/wayland-wm/waybar.nix
  {
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
    programs.swaylock = {
      enable = true;
      package = swaylock;
      settings = {
        # color = col.base0D;
        clock = true;
        effect-pixelate = 20;
        fade-in = 0.2;
        image = "${../../images/wallpapers/alleyway.png}";
        font-size = 24;
        indicator-idle-visible = true;
        indicator = true;
        indicator-caps-lock = true;
        indicator-radius = 100;
        indicator-thickness = 20;
        line-color = col.base05 + "60";
        ring-color = col.base06 + "60";
        inside-color = col.base07 + "60";
        show-failed-attempts = true;

        bs-hl-color = col.base04;
        key-hl-color = col.base06;
        separator-color = col.base00;
        text-color = col.base00;

        inside-clear-color = col.base03;
        line-clear-color = col.base03;
        ring-clear-color = col.base01;

        inside-ver-color = col.base0B;
        line-ver-color = col.base0D;
        ring-ver-color = col.base0B;

        inside-wrong-color = col.base0C;
        line-wrong-color = col.base0A;
        ring-wrong-color = col.base0E;
      };
    };

    services.swayidle = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      timeouts = [
        {
          timeout = 290;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 10 seconds' -t 10000";
        }
        {
          timeout = 300;
          command = "${swaylock}/bin/swaylock -f";
        }
        # {
        #   timeout = 600;
        #   command = "${pkgs.hyprland}/bin/hyprctl 'output * dpms off'";
        #   resumeCommand = "${pkgs.hyprland}/bin/hyprctl 'output * dpms on'";
        # }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${swaylock}/bin/swaylock -f";
        }
        # {
        #   event = "after-resume";
        #   command = "hyprctl dispatch dpms on";
        # }
      ];
    };

    home.file = {
      ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    };

    imports = [
      ../rofi.hm
      ../waybar.hm
      ../tofi.hm
      inputs.hyprland.homeManagerModules.default
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      enableNvidiaPatches = true;
      systemdIntegration = true;
      xwayland.enable = true;
      recommendedEnvironment = true;
      # plugins = [
      #   # pkgs.split-monitor-workspaces
      # ];
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
          hyprpaper = "${pkgs.hyprpaper}/bin/hyprpaper &";
          wlsunset = "${pkgs.wlsunset}/bin/wlsunset -l 40.7 -L -74.0 &";
          udiskie = "${pkgs.udiskie}/bin/udiskie &";
          openFirefox = "[workspace 2 silent] ${pkgs.firefox}/bin/firefox";
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
      hyprpaper
      pamixer

      pavucontrol
      cava
      imv

      wofi

      swayidle
    ];
  }
