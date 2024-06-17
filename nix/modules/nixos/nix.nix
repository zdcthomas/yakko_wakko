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
      package = pkgs.nixVersions.nix_2_18;

      # extraOptions = ''
      #   experimental-features = nix-command flakes
      # '';

      # Map registries to channels
      # Very useful when using legacy commands
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

      # Add each flake input as a registry
      # To make nix3 commands consistent with the flake
      registry = lib.mapAttrs (_: v: {flake = v;}) inputs;
      settings = {
        warn-dirty = false;
        auto-optimise-store = true;
        builders-use-substitutes = true;
        experimental-features = ["nix-command" "flakes" "repl-flake"];
        flake-registry = "/etc/nix/registry.json";
        trusted-users = [username];
        keep-derivations = true;
        keep-outputs = true;
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
