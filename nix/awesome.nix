{ pkgs, lib, ... }:

{
  xsession.enable = true;
  xsession.windowManager.awesome = {
    enable = true;
  };
}

