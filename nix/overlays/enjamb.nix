{ pkgs }:
with pkgs;
let
  version = "0.18.0-unstable-2026-11-19";

  # enjamb: my fork of razziel89/mdslw, renamed. Upstream 0.18.0 plus a fix
  # that keeps the final newline when reading from stdin. The binary is
  # enjamb; .mdslw.toml, the mdslw-ignore comments and the MDSLW_* variables
  # keep their names. Pin a commit on the fork's main.
  src = fetchFromGitHub {
    owner = "zdcthomas";
    repo = "enjamb";
    rev = "e39e01d73b739e4352cae9f0b93e833a7ffe9431";
    hash = "sha256-crjltgiebMQJMQQzPGGz+eal3a4xZoTe1ixG9FLouy8=";
  };

  # build.rs downloads these from cldr-json main at build time, which the
  # sandbox forbids. Pin them to a release and do the same extraction here.
  # The language list comes from the "Supported languages are:" line in
  # src/cfg.rs; a version bump that changes it needs a matching entry here.
  cldrVersion = "49.0.0";
  suppressions = {
    de = "sha256-UWftkf5EoXMUNqJQStQQMeTBHPkJEb475VEdHY65RpY=";
    en = "sha256-L/kf4d4lmEiYWPcsgVZwbO3o8Xg5qgqrgHA0G7R9xbg=";
    es = "sha256-4nJ/M/PV1JaP2yQdUUgngEcti6k4LbQwJzldO5noO4Y=";
    fr = "sha256-+8IRov9qlmNsaWEdJpYqPMzHZi89rlYc2eNb1eq7QhM=";
    it = "sha256-p+ULlpB00qLEhIv2ccSXK48cu9LvfvVRv0vzUzsJg8Y=";
  };

  langDir = runCommand "enjamb-lang-${version}" { nativeBuildInputs = [ jq ]; } (
    ''
      mkdir $out
      cp ${src}/src/lang/ac $out/ac
    ''
    + lib.concatStrings (
      lib.mapAttrsToList (lang: hash: ''
        jq -r '.segments.segmentations.SentenceBreak.standard[].suppression' \
          ${
            fetchurl {
              name = "cldr-${cldrVersion}-${lang}-suppressions.json";
              url = "https://raw.githubusercontent.com/unicode-org/cldr-json/${cldrVersion}/cldr-json/cldr-segments-full/segments/${lang}/suppressions.json";
              inherit hash;
            }
          } > $out/${lang}
        test -s $out/${lang}
      '') suppressions
    )
  );
in
rustPlatform.buildRustPackage {
  pname = "enjamb";
  inherit version src;

  cargoHash = "sha256-lZ/1f8xVlYBlmw9jiFDa3/LrEfJEpurJZ4Aynm3w6w0=";

  # Replace the downloading build script with one that points include_dir! at
  # the pre-built language files.
  postPatch = ''
    cat > build.rs <<EOF
    fn main() {
        println!("cargo::rustc-env=MDSLW_LANG_DIR=${langDir}");
    }
    EOF
  '';

  meta = {
    description = "Prepare your markdown for easy diff'ability by adding line breaks after every sentence";
    homepage = "https://github.com/zdcthomas/enjamb";
    license = lib.licenses.gpl3Plus;
    mainProgram = "enjamb";
  };
}
