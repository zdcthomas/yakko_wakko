{ ... }:
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
}
