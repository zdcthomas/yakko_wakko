# Hyprpanel is the bar on top of the screen
# Display informations like workspaces, battery, wifi, ...
{
  pkgs,
  config,
  username,
  ...
}: let
  transparentButtons = true;

  accent = "#${config.colorScheme.colors.base0D}";
  accent-alt = "#${config.colorScheme.colors.base03}";
  background = "#${config.colorScheme.colors.base00}";
  background-alt = "#${config.colorScheme.colors.base01}";
  foreground = "#${config.colorScheme.colors.base05}";
  font = "PragmataPro Mono Liga";
  fontSize = "10";

  rounding = 15;
  border-size = 3;

  gaps-in = 10;
  gaps-out = 10 * 2;

  floating = true;
  transparent = true;
  position = "top";

  location = "New York";
in {
  # wayland.windowManager.hyprland.settings.exec-once = ["${pkgs.hyprpanel}/bin/hyprpanel"];

  home.packages = with pkgs; [hyprpanel libnotify pywal libgtop];

  # home.file.".cache/ags/hyprpanel/options.json" = {
  #   text = ''
  #     {
  #       "bar.customModules.updates.pollingInterval": 1440000,
  #       "theme.font.name": "PragmataPro Mono Liga",
  #       "theme.font.size": "0.9rem",
  #       "menus.transition": "crossfade",
  #       "scalingPriority": "gdk",
  #       "theme.bar.floating": false,
  #       "theme.bar.buttons.enableBorders": true,
  #       "theme.bar.outer_spacing": "1.0em",
  #       "menus.clock.weather.location": "10009",
  #       "wallpaper.pywal": true,
  #       "wallpaper.image": "/home/opt/Pictures/microbiome.jpg",
  #       "wallpaper.enable": true,
  #       "theme.matugen": true,
  #       "theme.bar.menus.menu.media.card.color": "#3d2d27",
  #       "theme.matugen_settings.scheme_type": "content",
  #       "theme.bar.menus.opacity": 90,
  #       "theme.bar.menus.background": "#11111b",
  #       "theme.matugen_settings.mode": "dark",
  #       "theme.bar.transparent": true,
  #       "theme.bar.menus.monochrome": false,
  #       "theme.bar.buttons.style": "wave2",
  #       "theme.bar.location": "bottom",
  #       "menus.dashboard.directories.left.directory1.command": "bash -c \"xdg-open $HOME/Downloads/\"",
  #       "tear": true,
  #       "bar.layouts": {
  #         "*": {
  #           "left": [
  #             "dashboard",
  #             "workspaces",
  #             "submap",
  #
  #             "windowtitle"
  #           ],
  #           "middle": [
  #             "media",
  #             "battery"
  #           ],
  #           "right": [
  #             "volume",
  #             "network",
  #             "bluetooth",
  #             "battery",
  #             "systray",
  #             "clock",
  #             "notifications"
  #           ]
  #         }
  #       }
  #     }
  #   '';
  # };
  #   text =
  #     # json
  #     ''
  #               "battery",
  #               "bluetooth",
  #               "clock",
  #               "dashboard",
  #               "media"
  #               "network",
  #               "systray",
  #               "volume",
  #               "workspaces",
  #       {
  #         "bar.layouts": {
  #           "0": {
  #             "left": [
  #             ],
  #             "middle": [
  #               "windowtitle"
  #               "notifications"
  #             ],
  #             "right": [
  #               "battery",
  #             ]
  #           },
  #           "1": {
  #             "left": [
  #               "windowtitle"
  #             ],
  #             "middle": [
  #               "notifications"
  #             ],
  #             "right": [
  #               "battery",
  #             ]
  #           },
  #           "2": {
  #             "left": [
  #               "windowtitle"
  #             ],
  #             "middle": [
  #               "notifications"
  #             ],
  #             "right": [
  #               "battery",
  #             ]
  #           }
  #         },
  #         "theme.font.name": "${font}",
  #         "theme.font.size": "${fontSize}px",
  #         "theme.bar.outer_spacing": "${
  #         if floating && transparent
  #         then "0"
  #         else "8"
  #       }px",
  #         "theme.bar.buttons.y_margins": "${
  #         if floating && transparent
  #         then "0"
  #         else "8"
  #       }px",
  #         "theme.bar.buttons.spacing": "0.3em",
  #         "theme.bar.buttons.radius": "${
  #         if transparent
  #         then toString rounding
  #         else toString (rounding - 8)
  #       }px",
  #         "theme.bar.floating": ${
  #         if floating
  #         then "true"
  #         else "false"
  #       },
  #         "theme.bar.buttons.padding_x": "0.8rem",
  #         "theme.bar.buttons.padding_y": "0.4rem",
  #
  #         "theme.bar.buttons.workspaces.hover": "${accent-alt}",
  #         "theme.bar.buttons.workspaces.active": "${accent}",
  #         "theme.bar.buttons.workspaces.available": "${background}",
  #
  #         "theme.bar.margin_top": "${
  #         if position == "top"
  #         then toString (gaps-in * 2)
  #         else "0"
  #       }px",
  #         "theme.bar.margin_bottom": "${
  #         if position == "top"
  #         then "0"
  #         else toString (gaps-in * 2)
  #       }px",
  #         "theme.bar.margin_sides": "${toString gaps-out}px",
  #         "theme.bar.border_radius": "${toString rounding}px",
  #
  #         "bar.launcher.icon": "",
  #         "theme.bar.transparent": ${
  #         if transparent
  #         then "true"
  #         else "false"
  #       },
  #         "bar.workspaces.show_numbered": false,
  #         "bar.workspaces.workspaces": 5,
  #         "bar.workspaces.monitorSpecific": true,
  #         "bar.workspaces.hideUnoccupied": false,
  #         "bar.windowtitle.label": true,
  #         "bar.volume.label": false,
  #         "bar.network.truncation_size": 12,
  #         "bar.bluetooth.label": false,
  #         "bar.clock.format": "%a %b %d  %I:%M %p",
  #         "bar.notifications.show_total": true,
  #         "theme.notification.border_radius": "${toString rounding}px",
  #         "theme.osd.enable": true,
  #         "theme.osd.orientation": "vertical",
  #         "theme.osd.location": "left",
  #         "theme.osd.radius": "${toString rounding}px",
  #         "theme.osd.margins": "0px 0px 0px 10px",
  #         "theme.osd.muted_zero": true,
  #         "menus.clock.weather.location": "${location}",
  #         "menus.clock.weather.key": "myapikey",
  #         "menus.clock.weather.unit": "metric",
  #         "menus.dashboard.powermenu.avatar.image": "/home/${username}/.profile_picture.png",
  #         "menus.dashboard.powermenu.confirmation": false,
  #
  #         "menus.dashboard.shortcuts.left.shortcut1.icon": "",
  #         "menus.dashboard.shortcuts.left.shortcut1.command": "qutebrowser",
  #         "menus.dashboard.shortcuts.left.shortcut1.tooltip": "Qutebrowser",
  #         "menus.dashboard.shortcuts.left.shortcut2.icon": "󰅶",
  #         "menus.dashboard.shortcuts.left.shortcut2.command": "caffeine",
  #         "menus.dashboard.shortcuts.left.shortcut2.tooltip": "Caffeine",
  #         "menus.dashboard.shortcuts.left.shortcut3.icon": "󰖔",
  #         "menus.dashboard.shortcuts.left.shortcut3.command": "night-shift",
  #         "menus.dashboard.shortcuts.left.shortcut3.tooltip": "Night-shift",
  #         "menus.dashboard.shortcuts.left.shortcut4.icon": "",
  #         "menus.dashboard.shortcuts.left.shortcut4.command": "menu",
  #         "menus.dashboard.shortcuts.left.shortcut4.tooltip": "Search Apps",
  #         "menus.dashboard.shortcuts.right.shortcut1.icon": "",
  #         "menus.dashboard.shortcuts.right.shortcut1.command": "hyprpicker -a",
  #         "menus.dashboard.shortcuts.right.shortcut1.tooltip": "Color Picker",
  #         "menus.dashboard.shortcuts.right.shortcut3.icon": "󰄀",
  #         "menus.dashboard.shortcuts.right.shortcut3.command": "screenshot region swappy",
  #         "menus.dashboard.shortcuts.right.shortcut3.tooltip": "Screenshot",
  #
  #         "menus.dashboard.directories.left.directory1.label": "󰉍 Downloads",
  #         "menus.dashboard.directories.left.directory1.command": "bash -c \"thunar $HOME/Downloads/\"",
  #         "menus.dashboard.directories.left.directory2.label": "󰉏 Pictures",
  #         "menus.dashboard.directories.left.directory2.command": "bash -c \"thunar $HOME/Pictures/\"",
  #         "menus.dashboard.directories.left.directory3.label": "󱧶 Documents",
  #         "menus.dashboard.directories.left.directory3.command": "bash -c \"thunar $HOME/Documents/\"",
  #         "menus.dashboard.directories.right.directory1.label": "󱂵 Home",
  #         "menus.dashboard.directories.right.directory1.command": "bash -c \"thunar $HOME/\"",
  #         "menus.dashboard.directories.right.directory2.label": "󰚝 Projects",
  #         "menus.dashboard.directories.right.directory2.command": "bash -c \"thunar $HOME/dev/\"",
  #         "menus.dashboard.directories.right.directory3.label": " Config",
  #         "menus.dashboard.directories.right.directory3.command": "bash -c \"thunar $HOME/.config/\"",
  #
  #         "theme.bar.menus.monochrome": true,
  #         "wallpaper.enable": false,
  #         "theme.bar.menus.background": "${background}",
  #         "theme.bar.menus.cards": "${background-alt}",
  #         "theme.bar.menus.card_radius": "${toString rounding}px",
  #         "theme.bar.menus.label": "${foreground}",
  #         "theme.bar.menus.text": "${foreground}",
  #         "theme.bar.menus.border.size": "${toString border-size}px",
  #         "theme.bar.menus.border.color": "${accent}",
  #         "theme.bar.menus.border.radius": "${toString rounding}px",
  #         "theme.bar.menus.popover.text": "${foreground}",
  #         "theme.bar.menus.popover.background": "${background-alt}",
  #         "theme.bar.menus.listitems.active": "${accent}",
  #         "theme.bar.menus.icons.active": "${accent}",
  #         "theme.bar.menus.switch.enabled":"${accent}",
  #         "theme.bar.menus.check_radio_button.active": "${accent}",
  #         "theme.bar.menus.buttons.default": "${accent}",
  #         "theme.bar.menus.buttons.active": "${accent}",
  #         "theme.bar.menus.iconbuttons.active": "${accent}",
  #         "theme.bar.menus.progressbar.foreground": "${accent}",
  #         "theme.bar.menus.slider.primary": "${accent}",
  #         "theme.bar.menus.tooltip.background": "${background-alt}",
  #         "theme.bar.menus.tooltip.text": "${foreground}",
  #         "theme.bar.menus.dropdownmenu.background":"${background-alt}",
  #         "theme.bar.menus.dropdownmenu.text": "${foreground}",
  #         "theme.bar.background": "${
  #         background
  #         + (
  #           if transparentButtons
  #           then "00"
  #           else ""
  #         )
  #       }",
  #         "theme.bar.buttons.style": "default",
  #         "theme.bar.buttons.monochrome": true,
  #         "theme.bar.buttons.text": "${foreground}",
  #         "theme.bar.buttons.background": "${
  #         (
  #           if transparent
  #           then background
  #           else background-alt
  #         )
  #         + (
  #           if transparentButtons
  #           then "00"
  #           else ""
  #         )
  #       }",
  #         "theme.bar.buttons.icon": "${accent}",
  #         "theme.bar.buttons.notifications.background": "${background-alt}",
  #         "theme.bar.buttons.hover": "${background}",
  #         "theme.bar.buttons.notifications.hover": "${background}",
  #         "theme.bar.buttons.notifications.total": "${accent}",
  #         "theme.bar.buttons.notifications.icon": "${accent}",
  #         "theme.notification.background": "${background-alt}",
  #         "theme.notification.actions.background": "${accent}",
  #         "theme.notification.actions.text": "${foreground}",
  #         "theme.notification.label": "${accent}",
  #         "theme.notification.border": "${background-alt}",
  #         "theme.notification.text": "${foreground}",
  #         "theme.notification.labelicon": "${accent}",
  #         "theme.osd.bar_color": "${accent}",
  #         "theme.osd.bar_overflow_color": "${accent-alt}",
  #         "theme.osd.icon": "${background}",
  #         "theme.osd.icon_container": "${accent}",
  #         "theme.osd.label": "${accent}",
  #         "theme.osd.bar_container": "${background-alt}",
  #         "theme.bar.menus.menu.media.background.color": "${background-alt}",
  #         "theme.bar.menus.menu.media.card.color": "${background-alt}",
  #         "theme.bar.menus.menu.media.card.tint": 90,
  #         "bar.customModules.updates.pollingInterval": 1440000,
  #         "bar.media.show_active_only": true,
  #         "theme.bar.location": "${position}"
  #       }
  #     '';
  # };
}
