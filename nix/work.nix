{ config, pkgs, ... }:

let user_name = "zdcthomas";
in
{
  home = {
    username = user_name;
    homeDirectory = "/Users/" + user_name;

    packages = with pkgs; [
      go
      hurl
      /* wrong version */
      /* vector */
    ];
  };
}
