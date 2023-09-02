{pkgs, ...}: {
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    # package = builtins.path {
    #   path = /opt/homebrew;
    #   filter = (path: type: type == "directory" || builtins.baseNameOf path == "yabai");
    # };
    extraConfig = ''
       yabai -m config top_padding 20
       yabai -m config bottom_padding 20
       yabai -m config left_padding 20
       yabai -m config right_padding 20
       yabai -m config window_gap 20
       yabai -m config window_placement second_child
       yabai -m config window_border on
       yabai -m config window_border_width 2
       yabai -m config active_window_border_color 0xFF00c5cd

      # layout
       yabai -m config layout bsp
       yabai -m config auto_balance off

       # rules
       yabai -m rule --add app="^System Preferences$" manage=off
       yabai -m rule --add app="^Find My$" manage=off

      # workspace management
       yabai -m space 1 --label www
       yabai -m space 2 --label term
       yabai -m space 3 --label chat
       yabai -m space 4 --label music
       yabai -m space 5 --label five
       yabai -m space 6 --label six

      # assign apps to spaces
       yabai -m rule --add app="Kitty" display=1
      # yabai -m rule --add app="Brave Browser" display=2
       yabai -m rule --add app="Slack" display=2
       yabai -m rule --add app="Discord" display=2
       yabai -m rule --add app="Signal" space=chat
       yabai -m rule --add app="Spotify" space=music
       yabai -m rule --add app="Todoist" space=todo

      # My custom space names for my 3 monitor setup. These names are used in some of my scripts.
      # yabai -m space 1 --label one
      # yabai -m space 2 --label two
      # yabai -m space 3 --label three
      # yabai -m space 4 --label four
      # yabai -m space 5 --label five
      # yabai -m space 6 --label six
      # yabai -m space 9 --label nine

      # float system preferences. Most of these just diable Yabai form resizing them.
       yabai -m rule --add app="^System Preferences$" sticky=on layer=above manage=off
       yabai -m rule --add app="^Finder$" sticky=on layer=above manage=off
       yabai -m rule --add app="^Alfred Preferences$" sticky=on layer=above manage=off
       yabai -m rule --add app="^Disk Utility$" sticky=on layer=above manage=off
       yabai -m rule --add app="^System Information$" sticky=on layer=above manage=off
       yabai -m rule --add app="^Activity Monitor$" sticky=on layer=above manage=off
       yabai -m rule --add app="^Path Finder$" manage=off
       yabai -m rule --add app="^Spotify$" manage=off
       yabai -m rule --add app="^Time Out$" manage=off
       yabai -m rule --add app="^perl_client_app$" manage=off
       yabai -m rule --add app="^console$" manage=off
       yabai -m rule --add app="^Harvest$" manage=off
       yabai -m rule --add app="^CiscoSparkHelper$" manage=off
       yabai -m rule --add app="^Logi Options$" manage=off
       yabai -m rule --add app="^Cisco Webex Start$" manage=off
       yabai -m rule --add app="^Private Internet Access$" manage=off

      #find ~/Library/Parallels/Applications\ Menus/ -maxdepth 3 -type f | awk -F'/' '{ print $NF; }' | awk '{$1=$1};1' | sort | uniq | tr "\n" "\0" | xargs -0 -I{} yabai -m rule --add app="^{}\$" title=".*" manage=on

      ## Some random global settings
      #yabai -m config focus_follows_mouse          autoraise
      #yabai -m config focus_follows_mouse          on
      # New window spawns to the right if vertical split, or bottom if horizontal split
        yabai -m config window_placement second_child
        yabai -m config window_topmost off
      #yabai -m config window_shadow float
        yabai -m config window_opacity off
        yabai -m config window_opacity_duration 0.00
        yabai -m config active_window_opacity 1.0
      #yabai -m config normal_window_opacity        0.97
      #yabai -m config window_border                on | off

      ## WITH SIP ENABLED (Installed Limelight seperately, Don't need this)
        yabai -m config window_border on

      ## WTIH SIP DISABLED (Limelight build into Yabai, enable it here)
      #yabai -m config window_border on
      #yabai -m config window_border_width 3
      #yabai -m config active_window_border_color 0xFF40FF00
      #yabai -m config normal_window_border_color 0x00FFFFFF
      #yabai -m config insert_feedback_color        0xffd75f5f

      ## some other settings
        yabai -m config auto_balance off
        yabai -m config split_ratio 0.50
      # # set mouse interaction modifier key (default: fn)
        yabai -m config mouse_modifier ctrl
      # set modifier + right-click drag to resize window (default: resize)
        yabai -m config mouse_action2 resize
      # set modifier + left-click drag to resize window (default: move)
        yabai -m config mouse_action1 move

      # general space settings
      #yabai -m config focused_border_skip_floating  1
      #yabai -m config --space 3 layout             float

      ## Change how yabai looks
        yabai -m config layout bsp
        yabai -m config top_padding 2
        yabai -m config bottom_padding 2
        yabai -m config left_padding 2
        yabai -m config right_padding 2
        yabai -m config window_gap 10

      #Limelight addon (Kill it and start it each time Yabai starts)
        killall limelight &>/dev/null
        limelight &>/dev/null &

      # #Ubersicht widget bar stuff
      #yabai -m signal --add event=space_changed \
      #action="osascript -e 'tell application \"Übersicht\" to refresh widget id \"nibar-spaces-primary-jsx\"'"
      #yabai -m signal --add event=display_changed \
      #action="osascript -e 'tell application \"Übersicht\" to refresh widget id \"nibar-spaces-primary-jsx\"'"

      #yabai -m signal --add event=space_changed \
      #action="osascript -e 'tell application \"Übersicht\" to refresh widget id \"nibar-spaces-secondary-jsx\"'"
      #yabai -m signal --add event=display_changed \
      #action="osascript -e 'tell application \"Übersicht\" to refresh widget id \"nibar-spaces-secondary-jsx\"'"

      # signals
      # yabai -m signal --add event=window_destroyed action="yabai -m query --windows --window &> /dev/null || yabai -m window --focus mouse"
      #yabai -m signal --add event=space_changed action="yabai -m window --focus $(yabai -m query --windows --window | jq ".id")"
      # yabai -m signal --add event=application_terminated action="yabai -m query --windows --window &> /dev/null || yabai -m window --focus mouse"

      #testing signals
      # yabai -m signal --add event=window_destroyed action="terminal-notifier -message 'window_destroyed'"
      # yabai -m signal --add event=application_terminated action="terminal-notifier -message 'application_terminated'"

      ## If I close the active window, focus on any other visible window.
        yabai -m signal --add event=window_destroyed action="bash /Users/jesseskelton/CustomScripts/SwitchSpaces/window-focus-on-destroy.sh"
      # yabai -m signal --add event=space_changed action="export CUR_ACTIVE_APP=\"iTerm2\""

       echo "yabai configuration loaded.."
    '';
  };
  services.skhd.enable = true;
  # services.skhd = {
  #   enable = true;
  #   package = pkgs.skhd;
  #   skhdConfig = ''
  #     # alt + a / u / o / s are blocked due to umlaute
  #
  #     # workspaces
  #     ctrl + alt - j : yabai -m space --focus prev
  #     ctrl + alt - k : yabai -m space --focus next
  #     cmd + alt - j : yabai -m space --focus prev
  #     cmd + alt - k : yabai -m space --focus next
  #
  #     # send window to space and follow focus
  #     ctrl + alt - l : yabai -m window --space prev; yabai -m space --focus prev
  #     ctrl + alt - h : yabai -m window --space next; yabai -m space --focus next
  #     cmd + alt - l : yabai -m window --space prev; yabai -m space --focus prev
  #     cmd + alt - h : yabai -m window --space next; yabai -m space --focus next
  #
  #     # focus window
  #     alt - h : yabai -m window --focus west
  #     alt - l : yabai -m window --focus east
  #
  #     # focus window in stacked
  #     alt - j : if [ "$(yabai -m query --spaces --space | jq -r '.type')" = "stack" ]; then yabai -m window --focus stack.next; else yabai -m window --focus south; fi
  #     alt - k : if [ "$(yabai -m query --spaces --space | jq -r '.type')" = "stack" ]; then yabai -m window --focus stack.prev; else yabai -m window --focus north; fi
  #
  #     # swap managed window
  #     shift + alt - h : yabai -m window --swap west
  #     shift + alt - j : yabai -m window --swap south
  #     shift + alt - k : yabai -m window --swap north
  #     shift + alt - l : yabai -m window --swap east
  #
  #     # increase window size
  #     shift + alt - a : yabai -m window --resize left:-20:0
  #     shift + alt - s : yabai -m window --resize right:-20:0
  #
  #     # toggle layout
  #     alt - t : yabai -m space --layout bsp
  #     alt - d : yabai -m space --layout stack
  #
  #     # float / unfloat window and center on screen
  #     alt - n : yabai -m window --toggle float; \
  #               yabai -m window --grid 4:4:1:1:2:2
  #
  #     # toggle sticky(+float), topmost, picture-in-picture
  #     alt - p : yabai -m window --toggle sticky; \
  #               yabai -m window --toggle topmost; \
  #               yabai -m window --toggle pip
  #
  #     # reload
  #     shift + alt - r : brew services restart skhd; brew services restart yabai
  #   '';
  # };
}
