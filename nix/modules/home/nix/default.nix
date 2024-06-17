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
    nix.settings = {
      substituters = [
        # high priority since it's almost always used
        "https://cache.nixos.org?priority=10"
        "https://anyrun.cachix.org"
        "https://fufexan.cachix.org"
        "https://helix.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];

      trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
    config = mkIf cfg.enable {
      nix = {
        checkConfig = true;
        # package = pkgs.lib.mkForce pkgs.unstable.git;
        # package = pkgs.nixVersions.unstable;
        # package = pkgs.lib.mkForce pkgs.nixVersions.nix_2_19;

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
