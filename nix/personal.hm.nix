{ config, pkgs, ... }:


let user_name = "zacharythomas";
in
{
  home = {
    username = user_name;
    homeDirectory = "/Users/" + user_name;

    packages = with pkgs; [
      asciinema
      flyctl
      gum
      hugo
      skim
      /* qflipper  BROKEN */
      weechat
      ffmpeg_5
      nodejs-18_x
      nodePackages_latest.pnpm
    ];
  };
}
