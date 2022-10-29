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
      weechat
    ];
  };
}
