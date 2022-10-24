{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      go
      hurl
      vector
    ];
  };
}
