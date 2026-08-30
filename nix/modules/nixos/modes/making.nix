# `making` -- technical work. The desktop stays whole. The blocklist in
# ./default.nix is the only thing removed, plus a way to fetch a reference
# video without opening the site it came from.
{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  config = lib.mkIf (config.zdct.modes.enable && config.zdct.mode == "making") {
    home-manager.users.${username}.home.packages = [
      # YouTube is blocked outright, so a video you genuinely need gets
      # downloaded ahead of time and watched in mpv.
      pkgs.yt-dlp
    ];
  };
}
