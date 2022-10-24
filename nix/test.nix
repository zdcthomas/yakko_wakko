{ config, pkgs, ... }:

{
  home = {
    packages = [pkgs.vim];
  };
}
