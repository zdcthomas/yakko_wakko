
{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      soulseekqt
      ffmpeg
    ];
  };
}
