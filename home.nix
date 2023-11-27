{
  config,
  pkgs,
  overlays,
  ...
}: let
  management_scripts = import ./nix/nix_management_scripts_pkgs.nix {
    pkgs = pkgs;
    homeDirectory = config.home.homeDirectory;
  };
in {
  home = {
    stateVersion = "22.05";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    go = {
      enable = true;
    };
  };
}
