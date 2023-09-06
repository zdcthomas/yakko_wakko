{
  config,
  pkgs,
  lib,
  ...
}: {
  # TODO two files
  home.file.hammerspoon = {
    target = ".hammerspoon/";
    source = ../config/hammerspoon;
    recursive = true;
  };
}
