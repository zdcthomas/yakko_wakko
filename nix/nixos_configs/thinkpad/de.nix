{ de, lib, config, ... }:
let
  cfg = config.zdct.de;
in
with lib;
{
  options =
    {
      zdct.de = mkOption
        {
          type = types.enum [
            "i3"
            "hyprland"
          ];
          default = "i3";
        };
    };
  config = mkMerge [
    (
      mkIf (cfg == "i3")
        {
          # Enable the X11 windowing system.
          services.xserver = {
            enable = true;
            # xkbOptions = "caps:escape";
            layout = "us";
            autorun = true;
            displayManager = {
              defaultSession = "none+i3";
              autoLogin = {
                enable = true;
                user = "zdcthomas";
              };
              lightdm = {
                enable = true;
              };
            };

            desktopManager = {
              xterm.enable = false;
            };

            windowManager.i3.enable = true;
          };

          # programs.hyprland = {
          #   enable = true;
          #   package = inputs.hyprland.packages.${pkgs.system}.hyprland;
          #   nvidiaPatches = true;
          #   xwayland.enable = true;
          # };

          # environment.sessionVariables = {
          #   WLR_NO_HARDWARE_CURSORS = "1";
          # };
        }

    )
    (
      mkIf
        (de == "hyprland")
        { }
    )
  ];
}
