{ config, pkgs, lib, inputs, ... }:
let cfg = config.custom.hm.music_making;
in {
  options = {
    custom.hm.music_making = {
      enable = lib.mkEnableOption "Enable custom music_making";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        alda # music programming lang
        lenmus # music theory learning
        sonic-pi # live music env in python
        # kord # cli for playing/analyzing chords
        denemo # write sheet music with keys
        milkytracker # tracker
        supercollider
      ];
    };
  };
}
