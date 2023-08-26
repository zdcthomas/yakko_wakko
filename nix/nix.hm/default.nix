{...}:
{

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
}
