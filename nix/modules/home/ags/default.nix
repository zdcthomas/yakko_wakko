{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.hm.ags;
  col = lib.attrsets.mapAttrs (name: value: ("#" + value)) config.colorScheme.palette;

  # Same base16 semantics as waybar's style: base08 red means danger, base0B
  # green means healthy. bar/palette.scss is the dev copy of this file.
  palette = pkgs.writeText "palette.scss" ''
    $bg: ${col.base00};
    $bg1: ${col.base01};
    $bg2: ${col.base02};
    $bg3: ${col.base03};
    $fg: ${col.base05};
    $fg-bright: ${col.base07};
    $red: ${col.base08};
    $orange: ${col.base09};
    $yellow: ${col.base0A};
    $green: ${col.base0B};
    $aqua: ${col.base0C};
    $blue: ${col.base0D};
    $purple: ${col.base0E};
  '';

  airpodsToggle = pkgs.writeShellScript "toggle-airpods" ''
    AIRPODS="2C:18:09:F3:C6:E0"
    BLUETOOTHCTL="${pkgs.bluez}/bin/bluetoothctl"
    if [[ "$($BLUETOOTHCTL devices Connected)" == *"$AIRPODS"* ]]; then
      $BLUETOOTHCTL disconnect $AIRPODS
      $BLUETOOTHCTL block $AIRPODS
    else
      $BLUETOOTHCTL unblock $AIRPODS
      $BLUETOOTHCTL connect $AIRPODS
    fi
  '';

  # waybar's toggle-gamemode without the RTMIN signal; the bar re-reads
  # animations:enabled itself once this exits.
  gamemodeToggle = pkgs.writeShellScript "toggle-gamemode" ''
    if [ "$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')" = 1 ]; then
      hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword animation borderangle,0;\
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
  '';


  # `ags bundle` turns ./bar into one gjs executable, so nothing reads
  # ~/.config/ags and nothing compiles at login. pkgs.ags is the overlay's,
  # which carries the Astal service libraries the bar imports.
  bar = pkgs.stdenv.mkDerivation {
    name = "ags-bar";
    src = ./bar;
    nativeBuildInputs = with pkgs; [
      wrapGAppsHook3
      gobject-introspection
      ags
    ];
    buildInputs = [ pkgs.gjs ] ++ pkgs.ags.buildInputs or [ ];
    preBuild = "cp ${palette} palette.scss";
    installPhase = ''
      runHook preBuild
      mkdir -p $out/bin
      ags bundle app.tsx $out/bin/ags-bar \
        --define "AIRPODS_TOGGLE='${airpodsToggle}'" \
        --define "GAMEMODE_TOGGLE='${gamemodeToggle}'" \
        --define "NET_APP='${lib.getExe pkgs.nmgui}'"
    '';
    # brightnessctl, hyprctl and systemd-inhibit come from the session PATH.
    # notify-send is for the timer; curl fetches cover art.
    preFixup = ''
      gappsWrapperArgs+=(--prefix PATH : ${
        lib.makeBinPath [
          pkgs.brightnessctl
          pkgs.libnotify
          pkgs.curl
        ]
      })
    '';
  };
in
{
  options.custom.hm.ags.enable = lib.mkEnableOption "the AGS top bar";

  config = lib.mkIf cfg.enable {
    custom.hm.barService = "ags-bar";
    # nmgui, which the network pill opens, is also on PATH to start by hand.
    home.packages = [
      bar
      pkgs.nmgui
    ];

    # Restart it with `systemctl --user restart ags-bar`.
    systemd.user.services.ags-bar = {
      Unit = {
        Description = "AGS top bar";
        PartOf = [ "hyprland-session.target" ];
        After = [ "hyprland-session.target" ];
      };
      Service = {
        ExecStart = "${bar}/bin/ags-bar";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "hyprland-session.target" ];
    };
  };
}
