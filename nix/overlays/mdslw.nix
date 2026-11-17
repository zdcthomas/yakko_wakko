{ pkgs }:
with pkgs;
let
  version = "0.18.0-unstable-2026-11-12";

  # My fork of razziel89/mdslw: upstream 0.18.0 plus a fix that keeps the
  # final newline when reading from stdin. The fork's main carries the fix;
  # pin a commit on it.
  src = fetchFromGitHub {
    owner = "zdcthomas";
    repo = "mdslw";
    rev = "31b2f3a1d87a22d535aea89e01afe373c06041f0";
    hash = "sha256-m8GHpUwTHvt8ONcv6v4L6nT48cwuhP8qUlRMlfvm0yg=";
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

  langDir = runCommand "mdslw-lang-${version}" { nativeBuildInputs = [ jq ]; } (
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
  pname = "mdslw";
  inherit version src;

  cargoHash = "sha256-mcaiu6rLcR4TtOysMiEOVGPXFvGYlU/y/U4SGqUizSk=";

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
    homepage = "https://github.com/zdcthomas/mdslw";
    license = lib.licenses.gpl3Plus;
    mainProgram = "mdslw";
  };
}
