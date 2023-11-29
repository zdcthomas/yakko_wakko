{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.picom;
in {
  options = {
    custom.hm.picom = {
      enable = lib.mkEnableOption "Enable custom picom";
    };
  };
  config = lib.mkIf cfg.enable {
    services.picom = {
      enable = true;
      shadow = true;
      fade = true;
      fadeDelta = 4;
      backend = "glx";
      vSync = true;
      shadowOpacity = 0.5;
      settings = {
        experimental-backends = true;
        animations = true;
        animation-stiffness = 100;
        animation-window-mass = 0.5;
        animation-dampening = 12;
        animation-clamping = false;
        animation-for-open-window = "zoom";
        animation-for-unmap-window = "slide-down";
        animation-for-workspace-switch-in = "zoom";
        animation-for-workspace-switch-out = "zoom";
        animation-for-transient-window = "zoom";
      };
    };
  };
}
