{
  config,
  pkgs,
  lib,
  ...
}: {
  # TODO two files
  # home.file.yabai = {
  #   executable = true;
  #   target = ".config/yabai/yabairc";
  #   source = ../config/yabairc;
  # };

  # home.file.skhd = {
  #   target = ".config/skhd/skhdrc";
  #   text = let yabai = "/usr/local/bin/yabai"; in
  #     ''
  #       # alt + a / u / o / s are blocked due to umlaute
  #
  #       # workspaces
  #       # ctrl + alt - j : yabai -m space --focus prev
  #       # ctrl + alt - k : yabai -m space --focus next
  #       # cmd + alt - j : yabai -m space --focus prev
  #       # cmd + alt - k : yabai -m space --focus next
  #
  #       # send window to space and follow focus
  #       # ctrl + alt - l : yabai -m window --space prev; yabai -m space --focus prev
  #       # ctrl + alt - h : yabai -m window --space next; yabai -m space --focus next
  #       # cmd + alt - l : yabai -m window --space prev; yabai -m space --focus prev
  #       # cmd + alt - h : yabai -m window --space next; yabai -m space --focus next
  #
  #       # focus window
  #       ctrl + alt - h : yabai -m window --focus west
  #       ctrl + alt - l : yabai -m window --focus east
  #
  #       # focus window in stacked
  #       ctrl + alt - j : if [ "$(yabai -m query --spaces --space | jq -r '.type')" = "stack" ]; then yabai -m window --focus stack.next; else yabai -m window --focus south; fi
  #       ctrl + alt - k : if [ "$(yabai -m query --spaces --space | jq -r '.type')" = "stack" ]; then yabai -m window --focus stack.prev; else yabai -m window --focus north; fi
  #
  #       # swap managed window
  #       shift + alt - h : yabai -m window --swap west
  #       shift + alt - j : yabai -m window --swap south
  #       shift + alt - k : yabai -m window --swap north
  #       shift + alt - l : yabai -m window --swap east
  #
  #       # increase window size
  #       shift + alt - a : yabai -m window --resize left:-20:0
  #       shift + alt - s : yabai -m window --resize right:-20:0
  #
  #       # toggle layout
  #       alt - t : yabai -m space --layout bsp
  #       alt - d : yabai -m space --layout stack
  #
  #       # float / unfloat window and center on screen
  #       alt - n : yabai -m window --toggle float; \
  #                 yabai -m window --grid 4:4:1:1:2:2
  #
  #       # toggle sticky(+float), topmost, picture-in-picture
  #       alt - p : yabai -m window --toggle sticky; \
  #                 yabai -m window --toggle topmost; \
  #                 yabai -m window --toggle pip
  #
  #       # reload
  #       shift + alt - r : brew services restart skhd; brew services restart yabai
  #     '';
  # };
}
/*
example yabairc from turing slack
*/
/*
#!/usr/bin/env bash
*/
/*
sudo yabai --load-sa
*/
/*
yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
*/
/*
# ====== Variables =============================
*/
/*
gaps_top="20"
*/
/*
gaps_bottom="15"
*/
/*
gaps_left="20"
*/
/*
gaps_right="20"
*/
/*
gaps_inner="10"
*/
/*
# ====== Tiling settings =======================
*/
/*
yabai -m config layout                      bsp
*/
/*
yabai -m config top_padding                 "${gaps_top}"
*/
/*
yabai -m config bottom_padding              "${gaps_bottom}"
*/
/*
yabai -m config left_padding                "${gaps_left}"
*/
/*
yabai -m config right_padding               "${gaps_right}"
*/
/*
yabai -m config window_gap                  "${gaps_inner}"
*/
/*
yabai -m config mouse_follows_focus         off
*/
/*
yabai -m config focus_follows_mouse         off
*/
/*
yabai -m config mouse_modifier              fn
*/
/*
yabai -m config mouse_action1               move
*/
/*
yabai -m config mouse_action2               resize
*/
/*
yabai -m config window_topmost              off
*/
/*
yabai -m config window_opacity              off
*/
/*
yabai -m config window_shadow               float
*/
/*
yabai -m config active_window_opacity       1.0
*/
/*
yabai -m config normal_window_opacity       0.85
*/
/*
yabai -m config split_ratio                 0.5
*/
/*
yabai -m config auto_balance                off
*/
/*
# ====== List of rules =========================
*/
/*
yabai -m rule --add app="^System Preferences$" manage=off
*/
/*
Example skhd from slack
*/
/*
# Show system statistics
*/
/*
fn + lalt - 1 : "${HOME}"/.config/yabai/scripts/show_cpu.sh
*/
/*
fn + lalt - 2 : "${HOME}"/.config/yabai/scripts/show_mem.sh
*/
/*
fn + lalt - 3 : "${HOME}"/.config/yabai/scripts/show_bat.sh
*/
/*
fn + lalt - 4 : "${HOME}"/.config/yabai/scripts/show_disk.sh
*/
/*
fn + lalt - 5 : "${HOME}"/.config/yabai/scripts/show_song.sh
*/
/*
# Navigation
*/
/*
alt - h : yabai -m window --focus west
*/
/*
alt - j : yabai -m window --focus south
*/
/*
alt - k : yabai -m window --focus north
*/
/*
alt - l : yabai -m window --focus east
*/
/*
cmd - h : yabai -m window --focus next
*/
/*
# Moving windows
*/
/*
shift + alt - h : yabai -m window --warp west
*/
/*
shift + alt - j : yabai -m window --warp south
*/
/*
shift + alt - k : yabai -m window --warp north
*/
/*
shift + alt - l : yabai -m window --warp east
*/
/*
# Move focus container to workspace
*/
/*
shift + alt - m : yabai -m window --space last && yabai -m space --focus last
*/
/*
shift + alt - p : yabai -m window --space prev && yabai -m space --focus prev
*/
/*
shift + alt - n : yabai -m window --space next && yabai -m space --focus next
*/
/*
shift + alt - 1 : yabai -m window --space 1 && yabai -m space --focus 1
*/
/*
shift + alt - 2 : yabai -m window --space 2 && yabai -m space --focus 2
*/
/*
shift + alt - 3 : yabai -m window --space 3 && yabai -m space --focus 3
*/
/*
shift + alt - 4 : yabai -m window --space 4 && yabai -m space --focus 4
*/
/*
shift + alt - 5 : yabai -m window --space 5 && yabai -m space --focus 5
*/
/*
shift + alt - 6 : yabai -m window --space 6 && yabai -m space --focus 6
*/
/*
# Resize windows
*/
/*
lctrl + alt - h : \
*/
/*
yabai -m window --resize left:-20:0 ; \
*/
/*
yabai -m window --resize right:-20:0
*/
/*
lctrl + alt - j : \
*/
/*
yabai -m window --resize bottom:0:20 ; \
*/
/*
yabai -m window --resize top:0:20
*/
/*
lctrl + alt - k : \
*/
/*
yabai -m window --resize top:0:-20 ; \
*/
/*
yabai -m window --resize bottom:0:-20
*/
/*
lctrl + alt - l : \
*/
/*
yabai -m window --resize right:20:0 ; \
*/
/*
yabai -m window --resize left:20:0
*/
/*
# Float and center window
*/
/*
shift + alt - c : yabai -m window --toggle float;\
*/
/*
yabai -m window --grid 4:4:1:1:2:2
*/
/*
# Equalize size of windows
*/
/*
lctrl + alt - 0 : yabai -m space --balance
*/
/*
# Enable / Disable gaps in current workspace
*/
/*
lctrl + alt - g : yabai -m space --toggle padding; yabai -m space --toggle gap
*/
/*
# Rotate windows clockwise and anticlockwise
*/
/*
alt - r         : yabai -m space --rotate 90
*/
/*
shift + alt - r : yabai -m space --rotate 270
*/
/*
# Rotate on X and Y Axis
*/
/*
shift + alt - x : yabai -m space --mirror x-axis
*/
/*
shift + alt - y : yabai -m space --mirror y-axis
*/
/*
# Set insertion point for focused container
*/
/*
shift + lctrl + alt - h : yabai -m window --insert west
*/
/*
shift + lctrl + alt - j : yabai -m window --insert south
*/
/*
shift + lctrl + alt - k : yabai -m window --insert north
*/
/*
shift + lctrl + alt - l : yabai -m window --insert east
*/
/*
# Float / Unfloat window
*/
/*
shift + alt - space : yabai -m window --toggle float
*/
/*
# Restart Yabai
*/
/*
shift + lctrl + alt - r :
*/
/*
/usr/bin/env osascript <<< \
*/
/*
"display notification \"Restarting Yabai\" with title \"Yabai\""; \
*/
/*
launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"
*/
/*
# Make window native fullscreen
*/
/*
alt - f         : yabai -m window --toggle zoom-fullscreen
*/
/*
shift + alt - f : yabai -m window --toggle native-fullscreen
*/

