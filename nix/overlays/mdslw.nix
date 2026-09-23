{ pkgs }:
with pkgs;
rustPlatform.buildRustPackage rec {
  pname = "mdslw";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "razziel89";
    repo = "mdslw";
    rev = version;
    hash = "sha256-4iSQS13tMglOV8nWBw7Zxi8+DcKHKGl99cuHKvOIE7s=";
  };

  cargoHash = "sha256-emaBv9b9WjFKbyN5V0A5N8NHea8YMBvj256gv9P116E=";

  meta = {
    description = "Prepare your markdown for easy diff'ability by adding line breaks after every sentence";
    homepage = "https://github.com/razziel89/mdslw";
    license = lib.licenses.gpl3Plus;
    mainProgram = "mdslw";
  };
}
