{ config
, pkgs
, ...
}:
let
  user_name = "zdcthomas";
in
{
  imports = [
    ./nvim.hm
    ./cli.hm
    ./yabai.hm.nix
  ];
  custom.hm.nvim.enable = true;
  home = {
    username = user_name;
    homeDirectory = "/Users/" + user_name;

    packages = with pkgs; [
      go
      rustup
      hurl
      awscli2
      git-remote-codecommit
      nodePackages.aws-cdk
      /*
        docker
      */
      /*
        docker-compose
      */
      /*
        wrong version
      */
      /*
        vector
      */
    ];
  };
}
