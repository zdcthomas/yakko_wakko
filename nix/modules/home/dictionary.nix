# Offline dictionary and thesaurus, in every mode.
#
# sdcv is the engine and `dict` is the command. The dictionaries are built in
# nix/pkgs/dictionaries: WordNet, Moby Thesaurus and GCIDE (Webster's 1913),
# all public domain.
#
# A copyrighted dictionary bought later -- the OED, say -- drops into
# ~/.stardict/dic as prebuilt StarDict files and appears here with no change to
# this module. sdcv reads that directory as well as STARDICT_DATA_DIR.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.hm.dictionary;

  # StarDict entries carry HTML, and sdcv prints it verbatim: WordNet arrives
  # full of <br/> and <a href>, which is unreadable at a terminal. Strip the
  # markup on the way out rather than flattening it at build time, so a
  # dictionary added later gets the same treatment.
  dict = pkgs.writeShellApplication {
    name = "dict";
    runtimeInputs = [
      pkgs.sdcv
      pkgs.gnused
    ];
    text = ''
      if [ $# -eq 0 ]; then
        echo "usage: dict <word>" >&2
        exit 2
      fi

      sdcv --non-interactive --utf8-output "$@" \
        | sed -e 's/<[^>]*>//g' \
              -e 's/&lt;/</g' -e 's/&gt;/>/g' -e 's/&quot;/"/g' \
              -e "s/&#39;/'/g" -e 's/&amp;/\&/g' \
        | cat -s
    '';
  };
in
{
  options.custom.hm.dictionary = {
    enable = lib.mkEnableOption "sdcv with offline dictionaries";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.stardictDictionaries;
      defaultText = lib.literalExpression "pkgs.stardictDictionaries";
      description = "Derivation providing share/stardict/dic.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.sdcv
      dict
    ];

    home.sessionVariables.STARDICT_DATA_DIR = "${cfg.package}/share/stardict";
  };
}
