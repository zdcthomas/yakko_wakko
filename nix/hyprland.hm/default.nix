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
        # screenshots = true;
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

      # ".config/tofi/" = {
      #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/tofi";
      # };

      # ".config/waybar/" = {
      #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/waybar";
      # };
    };

    imports = [
      ../rofi.hm
      ../waybar.hm
      ../tofi.hm
    ];
    # programs.wofi = {
    #   enable = true;
    #   settings = {
    #     width = 420;
    #     height = 550;
    #     location = "center";
    #     show = "drun";
    #     matching = "fuzzy";
    #     prompt = "Search...";
    #     filter_rate = 100;
    #     allow_markup = true;
    #     no_actions = true;
    #     halign = "fill";
    #     orientation = "vertical";
    #     content_halign = "fill";
    #     insensitive = true;
    #     allow_images = true;
    #     image_size = 28;
    #     gtk_dark = false;
    #     term = "alacritty";
    #   };
    #
    #   style = ''
    #     * {
    #       transition: 0.2s;
    #     }
    #
    #     window {
    #     	font-family: "FiraCode Nerd Font Mono";
    #     	font-size: 13px;
    #     }
    #
    #     window {
    #         margin: 0px;
    #         border: 2px solid #cba6f7;
    #     /*
    #         background-color: transparent;
    #     */
    #         background-color: #161925;
    #         border-radius: 16px;
    #     }
    #
    #     #input {
    #         padding: 4px;
    #         margin: 20px;
    #         padding-left: 20px;
    #         border: none;
    #         color: #fff;
    #         font-weight: bold;
    #         background: linear-gradient(90deg, #cba6f7 0%, #94e2d5 100%);
    #        	outline: none;
    #         border-radius: 16px;
    #     }
    #
    #     #input image {
    #         color: #fff;
    #     }
    #
    #     #input:focus {
    #         border: none;
    #        	outline: none;
    #     }
    #
    #     #inner-box {
    #         margin: 20px;
    #         margin-top: 0px;
    #         border: none;
    #         color: #cba6f7;
    #         border-radius: 16px;
    #     }
    #
    #     #inner-box * {
    #         transition: none;
    #     }
    #
    #     #outer-box {
    #         margin: 0px;
    #         border: none;
    #         padding: 0px;
    #         border-radius: 16px;
    #     }
    #
    #     #scroll {
    #         margin-top: 5px;
    #         border: none;
    #         border-radius: 16px;
    #         margin-bottom: 5px;
    #     }
    #
    #     #text:selected {
    #         color: #fff;
    #         font-weight: bold;
    #     }
    #
    #     #img {
    #         margin-right: 20px;
    #         background: transparent;
    #     }
    #
    #     #text {
    #         margin: 0px;
    #         border: none;
    #         padding: 0px;
    #         background: transparent;
    #     }
    #
    #     #entry {
    #         margin: 0px;
    #         border: none;
    #         border-radius: 16px;
    #         background-color: transparent;
    #         min-height:32px;
    #         font-weight: bold;
    #     }
    #
    #     #entry:selected {
    #         outline: none;
    #         margin: 0px;
    #         border: none;
    #         border-radius: 16px;
    #         background: linear-gradient(90deg, #cba6f7 0%, #94e2d5 100%);
    #     }
    #   '';
    # };
    wayland.windowManager.hyprland = {
      enable = true;
      enableNvidiaPatches = true;
      systemdIntegration = true;
      xwayland.enable = true;
      settings = let
        rofi = "pkill rofi || ${pkgs.rofi}/bin/rofi -show drun";
        rofi_power_menu = "${pkgs.rofi}/bin/rofi -show p -modi p:'rofi-power-menu'";
        wofi = "pkill wofi || ${pkgs.wofi}/bin/wofi --show drun -n";
        tofi = " ${pkgs.tofi}/bin/tofi-drun -c ~/.config/tofi/tofi.launcher.conf";
        mainMod = "SUPER";
      in {
        "$terminal" = "${pkgs.alacritty}/bin/alacritty";
        "$browser" = "${pkgs.firefox}/bin/firefox";
        "$rofi-power-menu" = rofi_power_menu;
        "$launcher_alt" = rofi;
        "$launcher" = tofi;
        "$mainMod" = "SUPER";
        input = {
          "kb_layout" = "us";
          "kb_options" = "caps:escape";

          "follow_mouse" = "0";

          touchpad = {
            natural_scroll = "no";
            disable_while_typing = true;
            tap-to-click = false;
          };

          "sensitivity" = "0"; # -1.0 - 1.0, 0 means no modification.
        };
        exec-once = with pkgs; [
          "${hyprpaper}/bin/hyprpaper &"
          "nm-applet &"
          "${wlsunset}/bin/wlsunset -l 40.7 -L -74.0 &"
          "${udiskie}/bin/udiskie &"
          "[workspace 2 silent] ${pkgs.firefox}/bin/firefox"
          "xwaylandvideobridge"
        ];

        exec = [
          "pkill waybar; waybar"
        ];

        bindl = [
          ", XF86AudioMute,         exec, ${pkgs.alsa-utils}/bin/amixer set Master toggle"
          ", XF86AudioMicMute,         exec, ${pkgs.alsa-utils}/bin/amixer set Capture toggle"
        ];
        bindle = [
          ", XF86AudioLowerVolume, exec, ${pkgs.alsa-utils}/bin/amixer set Master 10%-"
          ", XF86AudioRaiseVolume, exec, ${pkgs.alsa-utils}/bin/amixer set Master 10%+"

          "SHIFT, XF86AudioLowerVolume, exec, ${pkgs.alsa-utils}/bin/amixer set Capture 10%-"
          "SHIFT, XF86AudioRaiseVolume, exec, ${pkgs.alsa-utils}/bin/amixer set Capture 10%+"

          ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 4%-"
          ", XF86MonBrightnessUp,   exec, ${pkgs.brightnessctl}/bin/brightnessctl set 4%+"
        ];
        bindm = [
          "${mainMod}, mouse:272, movewindow"
          "${mainMod}, mouse:273, resizewindow"
        ];

        bind = [
          # cycle workspaces
          "${mainMod}, bracketleft, workspace, m-1"
          "${mainMod}, bracketright, workspace, m+1"

          # cycle monitors
          "${mainMod} + SHIFT, bracketleft, focusmonitor, l"
          "${mainMod} + SHIFT, bracketright, focusmonitor, r"

          "${mainMod} + SHIFT, TAB, focusmonitor,      "
          "${mainMod},         TAB, focusurgentorlast, "

          "${mainMod} + SHIFT, W,     killactive,     "
          "${mainMod} + SHIFT, Q,     exit,           "
          "${mainMod},         F,     fullscreen,     "
          "${mainMod} + SHIFT, Space, togglefloating, "
          "${mainMod} + SHIFT, m,     layoutmsg,      swapwithmaster master"

          "${mainMod},         D,      exec, $launcher"
          "${mainMod},         P,      exec, $rofi-power-menu"
          "${mainMod},         n,      exec, $terminal --class nmtui -e  nmtui"
          "${mainMod} + SHIFT, d,      exec, $launcher_alt"
          "${mainMod} + ALT,   c,      exec, ${pkgs.hyprpicker}/bin/hyprpicker | ${pkgs.wl-clipboard}/bin/wl-copy"
          "${mainMod},         Return, exec, $terminal"
          "${mainMod} + SHIFT, Return, exec, $terminal --class termfloat"
          "${mainMod},         b,      exec, $browser"

          "${mainMod} + CTRL, left,  movecurrentworkspacetomonitor, l"
          "${mainMod} + CTRL, right, movecurrentworkspacetomonitor, r"

          "${mainMod}, h, movefocus, l"
          "${mainMod}, l, movefocus, r"
          "${mainMod}, k, movefocus, u"
          "${mainMod}, j, movefocus, d"

          "${mainMod}+SHIFT, h, movewindow, l"
          "${mainMod}+SHIFT, l, movewindow, r"
          "${mainMod}+SHIFT, k, movewindow, u"
          "${mainMod}+SHIFT, j, movewindow, d"

          # Switch workspaces with mainMod + [0-9]
          "${mainMod}, 1, workspace, 1"
          "${mainMod}, 2, workspace, 2"
          "${mainMod}, 3, workspace, 3"
          "${mainMod}, 4, workspace, 4"
          "${mainMod}, 5, workspace, 5"
          "${mainMod}, 6, workspace, 6"
          "${mainMod}, 7, workspace, 7"
          "${mainMod}, 8, workspace, 8"
          "${mainMod}, 9, workspace, 9"
          "${mainMod}, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "${mainMod} SHIFT, 1, movetoworkspace, 1"
          "${mainMod} SHIFT, 2, movetoworkspace, 2"
          "${mainMod} SHIFT, 3, movetoworkspace, 3"
          "${mainMod} SHIFT, 4, movetoworkspace, 4"
          "${mainMod} SHIFT, 5, movetoworkspace, 5"
          "${mainMod} SHIFT, 6, movetoworkspace, 6"
          "${mainMod} SHIFT, 7, movetoworkspace, 7"
          "${mainMod} SHIFT, 8, movetoworkspace, 8"
          "${mainMod} SHIFT, 9, movetoworkspace, 9"
          "${mainMod} SHIFT, 0, movetoworkspace, 10"

          "${mainMod}, mouse_down, workspace, e+1"
          "${mainMod}, mouse_up, workspace, e-1"

          "${mainMod} + SHIFT, braceleft, focusmonitor, l"
          "${mainMod} + SHIFT, braceright, focusmonitor, r"

          # window resize
          "${mainMod}, R, submap, resize"

          # bind = $mainMod, Tab, cyclenext,          # change focus to another window
          # bind = SUPER,Tab,bringactivetotop,   # bring it to the top
        ];
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;

          #  -------------------------
          #  |    Spaceman colors    |
          #  -------------------------
          "col.active_border" = "rgba(${col.base0C}FF) rgba(${col.base09}FF) 45deg";
          "col.inactive_border" = "rgba(${col.base00}aa)";

          # col.active_border = rgba(02FC96ee) rgba(F95666ee) 45deg
          # col.inactive_border = rgba(2A598Eaa)
          # </spaceman>

          layout = "master";
        };

        windowrulev2 = [
          "opacity 0.0 override 0.0 override, class:^(xwaylandvideobridge)$"
          "noanim,                            class:^(xwaylandvideobridge)$"
          "nofocus,                           class:^(xwaylandvideobridge)$"
          "noinitialfocus,                    class:^(xwaylandvideobridge)$"
          "noblur,                            class:^(xwaylandvideobridge)$"
          "noshadow,                          class:^(xwaylandvideobridge)$"
          "workspace 3,                       title:^(.*Discord.*)$"
          "workspace 4,                       title:^(.*1Password.*)$"
          "idleinhibit focus,                 class:^(mpv|.+exe)$"
          "idleinhibit focus,                 class:^(firefox)$, title:^(.*YouTube.*)$"
          "idleinhibit fullscreen,            class:^(firefox)$"
          "move 100%-433 53,                  class:^(wofi)$, title:^(clippick)$"
          "float,                             class:(pavucontrol),"
          "float,                             class:(nmtui),"
          "center,                            class:(nmtui),"
          "float,                             class:(imv),"
        ];

        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          "col.shadow" = "0x99161925";
          "col.shadow_inactive" = "0x55161925";
          rounding = 10;
          blur = {
            size = 5;
            passes = 1;
            new_optimizations = true;
            xray = true;
            ignore_opacity = true;
          };
          # blur = "yes";

          shadow_ignore_window = true;

          # drop_shadow = yes
          # shadow_range = 4
          # shadow_render_power = 3
          # col.shadow = rgba(1a1a1aee)
          multisample_edges = 1; # enable antialiasing for rounded corners
          blurls = ["wofi" "tofi" "launcher"];
        };

        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = false;
          orientation = "left";
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = "on";
        };

        misc = {
          animate_manual_resizes = true;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        "device:epic-mouse-v1" = {
          sensitivity = -0.5;
        };
      };
      extraConfig = ''
        env = XCURSOR_SIZE,24

        # Example per-device config
        # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more

        animations {
            enabled = yes

            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier = myBezier, 0.05, 0.9, 0.1, 1.05

            animation = windows, 1, 7, myBezier
            animation = windowsIn, 1, 7, myBezier
            animation = windowsOut, 1, 7, default, slide
            animation = border, 1, 10, myBezier
            animation = borderangle, 1, 100, default, once
            animation = fade, 1, 7, default
            animation = workspaces, 1, 6, default
        }

        submap = resize
        binde  = , l, resizeactive, 10 0
        binde  = , h, resizeactive, -10 0
        binde  = , k, resizeactive, 0 -10
        binde  = , j, resizeactive, 0 10
        bind   = , escape, submap, reset
        submap = reset

        windowrule   = float,                  ^(nm-connection-editor)
        windowrule   = float,                  ^(abtop)$
        # windowrule=float,nmtui


        # dialog
        windowrule = float,title:^(Open File)(.*)$
        windowrule = float,title:^(Open Folder)(.*)$
        windowrule = float,title:^(Open)$
        windowrule = float,title:^(Save As)(.*)$
        windowrule = float,title:^(Library)(.*)$
        windowrule = float,title:^(Choose Files)$
        windowrule = float,title:^(Confirm to replace files)$
        windowrule = float,title:^(File Operation Progress)$



        monitor = eDP-1,1366x768@60, 2560x0, 1
        monitor = DP-2,2560x1440@60, 0x0, 1

        # # workspace binding
        workspace=5, monitor:DP-2
        workspace=6, monitor:DP-2
        workspace=7, monitor:DP-2
        workspace=8, monitor:DP-2
      '';
    };
    home.packages = with pkgs; [
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags =
          oldAttrs.mesonFlags
          ++ [
            "-Dexperimental=true"
          ];
      }))

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

      pavucontrol
      cava
      imv

      wofi

      swayidle
    ];
  }
