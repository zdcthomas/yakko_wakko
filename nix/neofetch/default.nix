{pkgs, ...}: let
  ascii_tree = pkgs.writeText "ascii_tree" (builtins.readFile ./tree.txt);
in {
  home.packages = [pkgs.neofetch];
  home.file.".config/neofetch/config.conf" = {
    source = ./small/dotfetch.conf;
  };
}
