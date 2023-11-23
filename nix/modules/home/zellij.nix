{
  pkgs,
  config,
  lib,
  ...
}: {
  home.file = {
    ".config/zellij/" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/zellij";
    };
  };

  programs.zellij = {
    enable = true;
  };
}
