{ pkgs, inputs, }:
pkgs.stdenv.mkDerivation {
  pname = "PragmataPro";
  version = "0.829";
  src = inputs.font;
  # buildInputs = [pkgs.unzip];
  installPhase = ''

    install_path=$out/share/fonts/truetype/pragmatapro
    mkdir -p $install_path
    ls -la
    cd Release\ 0829

    find -name "PragmataPro*.ttf" -exec mv {} $install_path \;
  '';
}
