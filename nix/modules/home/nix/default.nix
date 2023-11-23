{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.hm.nix;
in
  with lib; {
    options = {
      custom.hm.nix = {
        enable = mkEnableOption "Custom configuration of nix";
      };
    };
    config = mkIf cfg.enable {
      nix = {
        checkConfig = true;
        # package = pkgs.nixVersions.unstable;

        extraOptions = ''
          keep-outputs = true
          keep-derivations = true
          auto-optimise-store = true
          # assuming the builder has a faster internet connection
          builders-use-substitutes = true
          experimental-features = nix-command flakes
        '';
      };
    };
  }
