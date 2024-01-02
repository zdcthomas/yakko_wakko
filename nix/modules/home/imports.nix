{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.anyrun.homeManagerModules.default
    inputs.hyprland.homeManagerModules.default
  ];
}
