# StarDict dictionaries for sdcv.
#
# sdcv wants StarDict (.ifo/.idx/.dict). None of these three sources ship in
# that format, so each is converted here with pyglossary and the results are
# collected into one directory that STARDICT_DATA_DIR can point at.
#
# All three are public domain. A copyrighted dictionary -- the OED, say --
# would drop into the same directory as prebuilt StarDict files without any
# change to this file.
{
  lib,
  stdenvNoCC,
  fetchurl,
  pyglossary,
  python3,
  wordnet,
  symlinkJoin,
}:

let
  # pyglossary writes a directory of StarDict files. `--no-progress-bar` keeps
  # the build log readable, and sorting is what makes the .idx usable.
  convert =
    {
      name,
      version,
      description,
      inputFile,
      readFormat,
      nativeBuildInputs ? [ ],
      prepare ? "",
    }:
    stdenvNoCC.mkDerivation {
      pname = "stardict-${name}";
      inherit version;

      dontUnpack = true;
      nativeBuildInputs = [ pyglossary ] ++ nativeBuildInputs;

      buildPhase = ''
        runHook preBuild
        # pyglossary creates a config directory under $HOME on startup, and
        # the sandbox's /homeless-shelter does not exist.
        export HOME=$(mktemp -d)
        ${prepare}
        mkdir -p $out/share/stardict/dic
        pyglossary --no-progress-bar --no-color \
          --read-format=${readFormat} \
          --write-format=Stardict \
          --sort \
          --name=${lib.escapeShellArg description} \
          ${inputFile} \
          $out/share/stardict/dic/${name}.ifo
        runHook postBuild
      '';

      dontInstall = true;

      meta = {
        inherit description;
        platforms = lib.platforms.all;
      };
    };

  gcideSrc = fetchurl {
    url = "https://ftp.gnu.org/gnu/gcide/gcide-0.54.tar.xz";
    hash = "sha256-IkFvbzYXWxYNw4i3VHUSUU1GRHPPfXyJjXOO+ybFHUI=";
  };

  mobySrc = fetchurl {
    url = "https://www.gutenberg.org/files/3202/files/mthesaur.txt";
    hash = "sha256-fJdCse2UQ1qJPAcZtCZyXtuKUkL4xSanVGG9bO4t/TI=";
  };

  # Webster's 1913, via the GNU Collaborative International Dictionary of
  # English. The one that defines with sentences instead of synonym chains.
  gcide = convert {
    name = "gcide";
    version = "0.54";
    description = "GCIDE (Webster's 1913)";
    readFormat = "Tabfile";
    inputFile = "gcide.tab";
    nativeBuildInputs = [ python3 ];
    prepare = ''
      tar xf ${gcideSrc}
      python3 ${./gcide-to-tab.py} gcide-0.54 > gcide.tab
    '';
  };

  # Moby Thesaurus II. One line per headword: `word,syn,syn,...`, Latin-1 with
  # CRLF endings. Splitting on the first comma turns that into a tabfile, with
  # the synonym list left as the definition.
  moby = convert {
    name = "moby-thesaurus";
    version = "1.0";
    description = "Moby Thesaurus II";
    readFormat = "Tabfile";
    inputFile = "moby.tab";
    nativeBuildInputs = [ python3 ];
    prepare = ''
      python3 - <<'EOF'
      with open("${mobySrc}", encoding="latin-1") as src, \
           open("moby.tab", "w", encoding="utf-8") as out:
          for line in src:
              head, sep, rest = line.rstrip("\r\n").partition(",")
              if sep and rest:
                  out.write(f"{head}\t{rest}\n")
      EOF
    '';
  };

  # pyglossary reads the WordNet database directory directly, so this one
  # needs no intermediate format.
  wordnetDict = convert {
    name = "wordnet";
    version = wordnet.version or "3.0";
    description = "WordNet 3.0";
    readFormat = "Wordnet";
    inputFile = "${wordnet}/dict";
  };
in
symlinkJoin {
  name = "stardict-dictionaries";
  paths = [
    gcide
    moby
    wordnetDict
  ];
  passthru = {
    inherit gcide moby wordnetDict;
  };
  meta = {
    description = "Public-domain StarDict dictionaries for sdcv";
    platforms = lib.platforms.all;
  };
}
