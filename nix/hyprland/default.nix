{ pkgs, lib, inputs, config, ... }:
let
  col = color: (lib.strings.removePrefix "#" config.colorScheme.colors.${color});
in

# https://git.sr.ht/~misterio/nix-config/tree/main/item/home/misterio/features/desktop/common/wayland-wm/waybar.nix
{
  # services.dunst = {
  #   enable = true;
  # };
  services.mako = {
    enable = true;
    borderRadius = 10;
    defaultTimeout = 4000; # milliseconds
    anchor = "top-right";
    backgroundColor = col "base00";
    borderColor = col "base07";
    font = "FiraCode";
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = col "base0D";
      font-size = 24;
      indicator-idle-visible = true;
      indicator-radius = 100;
      line-color = col "base01";
      show-failed-attempts = true;
    };
  };


  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    timeouts = [
      {
        timeout = 90;
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
      }
      {
        timeout = 95;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
    ];
  };

  home.file = {
    ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;

    ".config/tofi/" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/tofi";
    };

    ".config/waybar/" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/waybar";
    };
  };

  imports = [
    ../rofi.nix
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
    settings =
      let
        rofi = "pkill rofi || ${pkgs.rofi}/bin/rofi -show drun";
        rofi_power_menu = "${pkgs.rofi}/bin/rofi -show p -modi p:'rofi-power-menu'";
        wofi = "pkill wofi || ${pkgs.wofi}/bin/wofi --show drun -n";
        tofi = " ${pkgs.tofi}/bin/tofi-drun -c ~/.config/tofi/tofi.launcher.conf";
        mainMod = "SUPER";

      in
      {
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
            "natural_scroll" = "no";
          };

          "sensitivity" = "0"; # -1.0 - 1.0, 0 means no modification.
        };
        exec-once = [
          "${ pkgs.hyprpaper }/bin/hyprpaper &"
          "nm-applet &"
          "wlsunset -l 40.7 -L -74.0 &"
        ];

        exec = [
          "pkill waybar; waybar"
        ];

        monitor = [ ",preferred,auto,auto" ];
        bind = [

          "${mainMod} + SHIFT, TAB,    focusmonitor,                  "
          "${mainMod},         TAB,    focusurgentorlast,             , title:^(alacritty-btop)$"

          "${mainMod},         Return, exec,                          $terminal"
          "${mainMod},         b,      exec,                          $browser"
          "${mainMod} + SHIFT, W,      killactive,                    "
          "${mainMod} + SHIFT, Q,      exit,                          "
          "${mainMod},         F,      fullscreen,                    "
          "${mainMod},         D,      exec,                          $launcher"
          "${mainMod},         P,      exec,                          $rofi-power-menu"
          "${mainMod} + SHIFT, m,      layoutmsg,                     swapwithmaster master"
          "${mainMod} + SHIFT, d,      exec,                          $launcher_alt"
          "${mainMod} + ALT,   c,      exec,                          ${ pkgs.hyprpicker }/bin/hyprpicker | ${pkgs.wl-clipboard}/bin/wl-copy"
          "${mainMod} + CTRL,  left,   movecurrentworkspacetomonitor, l"
          "${mainMod} + CTRL,  right,  movecurrentworkspacetomonitor, r"

          "${mainMod},         h,      movefocus,                     l"
          "${mainMod},         l,      movefocus,                     r"
          "${mainMod},         k,      movefocus,                     u"
          "${mainMod},         j,      movefocus,                     d"

          "${mainMod}+SHIFT,   h,      movewindow,                    l"
          "${mainMod}+SHIFT,   l,      movewindow,                    r"
          "${mainMod}+SHIFT,   k,      movewindow,                    u"
          "${mainMod}+SHIFT,   j,      movewindow,                    d"

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

      };
    extraConfig = ''
      env = XCURSOR_SIZE,24
      general {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 5
          gaps_out = 10
          border_size = 1

          #  -------------------------
          #  |    Spaceman colors    |
          #  -------------------------
          col.active_border = rgba(${col "base0C"}FF) rgba(${col "base09"}FF) 45deg
          col.inactive_border = rgba(${col "base00"}aa)

          # col.active_border = rgba(02FC96ee) rgba(F95666ee) 45deg
          # col.inactive_border = rgba(2A598Eaa)
          # </spaceman>

          layout = master
      }

      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          col.shadow = 0x99161925
          col.shadow_inactive = 0x55161925

          rounding = 10
          blur = yes
          blur_size = 5
          blur_passes = 1
          blur_new_optimizations = true
          blur_xray = true
          blur_ignore_opacity = true

          shadow_ignore_window = true

          # drop_shadow = yes
          # shadow_range = 4
          # shadow_render_power = 3
          # col.shadow = rgba(1a1a1aee)
          multisample_edges = 1 # enable antialiasing for rounded corners
          blurls = wofi
          blurls = tofi
          blurls = launcher
      }

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

      dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = yes # you probably want this
      }

      master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = false
          orientation = left
      }

      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = on
      }

      misc {
        animate_manual_resizes = true
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      device:epic-mouse-v1 {
          sensitivity = -0.5
      }

      input {
        touchpad {
          disable_while_typing = true
          tap-to-click = false
        }
      }

      bindl=, XF86AudioMute, exec, amixer set Master toggle
      bindle=, XF86AudioLowerVolume, exec, amixer set Master 4%-
      bindle=, XF86AudioRaiseVolume, exec, amixer set Master 4%+
      bindle=, XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 4%-
      bindle=, XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 4%+

      # Move focus with mainMod + arrow keys
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow


      submap = resize
      binde  = , l, resizeactive, 10 0
      binde  = , h, resizeactive, -10 0
      binde  = , k, resizeactive, 0 -10
      binde  = , j, resizeactive, 0 10
      bind   = , escape, submap, reset
      submap = reset

      windowrulev2 = workspace 2,            title:^(.*Firefox.*)
      windowrulev2 = workspace 3,            title:^(.*Discord.*)$
      windowrulev2 = workspace 4,            title:^(.*1Password.*)$
      windowrulev2 = idleinhibit focus,      class:^(mpv|.+exe)$
      windowrulev2 = idleinhibit focus,      class:^(firefox)$, title:^(.*YouTube.*)$
      windowrulev2 = idleinhibit fullscreen, class:^(firefox)$
      windowrulev2 = move 100%-433 53, class:^(wofi)$, title:^(clippick)$
      windowrulev2 = float,class:(pavucontrol),
      windowrulev2 = float,class:(nmtui),
      windowrulev2 = center,class:(nmtui),
      windowrulev2 = float,class:(imv),
      windowrule   = float,^(nm-connection-editor)
      windowrule = float, ^(abtop)$


      # dialog
      windowrule = float,title:^(Open File)(.*)$
      windowrule = float,title:^(Open Folder)(.*)$
      windowrule = float,title:^(Open)$
      windowrule = float,title:^(Save As)(.*)$
      windowrule = float,title:^(Library)(.*)$
      windowrule = float,title:^(Choose Files)$
      windowrule = float,title:^(Confirm to replace files)$
      windowrule = float,title:^(File Operation Progress)$


      # # workspace binding
      workspace=5, monitor:DP-2
      workspace=6, monitor:DP-2
      workspace=7, monitor:DP-2
      workspace=8, monitor:DP-2
    '';
  };
  home.packages = with pkgs; [
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [
        "-Dexperimental=true"
      ];
    }))

    wl-gammactl
    wl-clipboard
    brightnessctl
    hyprpicker
    inotify-tools
    libnotify
    swww
    networkmanagerapplet
    hyprpaper

    tofi
    wofi

    swaylock
    swayidle
  ];
}
