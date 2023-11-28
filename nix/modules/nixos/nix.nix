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
        experimental-features = ["nix-command" "flakes"];
        flake-registry = "/etc/nix/registry.json";
        trusted-users = [username];
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
