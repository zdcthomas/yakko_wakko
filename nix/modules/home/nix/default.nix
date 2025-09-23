{ pkgs, config, lib, ... }:
let cfg = config.custom.hm.nix;
in with lib; {
  options = {
    custom.hm.nix = { enable = mkEnableOption "Custom configuration of nix"; };
  };
  config = mkIf cfg.enable {
    nix = {
      settings = { };
      checkConfig = true;
      # package = pkgs.lib.mkForce pkgs.unstable.git;
      # package = pkgs.nixVersions.unstable;
      # package = pkgs.lib.mkForce pkgs.nixVersions.nix_2_19;

      extraOptions = ''
        # assuming the builder has a faster internet connection
        builders-use-substitutes = true
        experimental-features = nix-command flakes
      '';
    };
  };
}
# keep-outputs = true
# keep-derivations = true
# auto-optimise-store = true

