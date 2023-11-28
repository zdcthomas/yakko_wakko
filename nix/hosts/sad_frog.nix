{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/configuration.nix
  ];

  nix = {
    trustedUsers = ["root"];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  documentation.man.enable = true;
}
