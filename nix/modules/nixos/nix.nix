{
  config,
  pkgs,
  lib,
  inputs,
  username,
  ...
}: let
  cfg = config.zdct.nix;
in {
  options = {
    zdct.nix = {
      enable = lib.mkEnableOption "Enable custom nix";
    };
  };
  config = lib.mkIf cfg.enable {
    nix = {
      package = pkgs.nixUnstable;

      # extraOptions = ''
      #   experimental-features = nix-command flakes
      # '';
      registry = lib.mapAttrs (_: v: {flake = v;}) inputs;
      settings = {
        warn-dirty = false;
        auto-optimise-store = true;
        builders-use-substitutes = true;
        experimental-features = ["nix-command" "flakes"];
        flake-registry = "/etc/nix/registry.json";
        trusted-users = [username];
        keep-derivations = true;
        keep-outputs = true;
        substituters = [
          "https://anyrun.cachix.org"
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
        ];

        trusted-public-keys = [
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      optimise = {
        automatic = true;
        dates = ["04:00"];
      };
    };
  };
}
