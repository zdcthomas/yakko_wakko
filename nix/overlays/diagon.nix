{ pkgs }:
with pkgs;
let
  antlr = fetchFromGitHub {
    owner = "antlr";
    repo = "antlr4";
    rev = "1cb4669f84cea5b59661fd44b0f80509fdacd3f9";
    hash = "sha256-Wm9tdoxM/kXVMEx6c5DwRooF4MUG14ykF7WNGjHfSIQ=";
    deepClone = true;
  };

  antlr-jar = fetchurl {
    url = "https://www.antlr.org/download/antlr-4.11.1-complete.jar";
    hash = "sha256-YpdeGStK8mIrcrXwExVT7jy86X923CpBYy3MVeJUc+E=";
  };

  json = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "nlohmann_json_cmake_fetchcontent";
    rev = "v3.9.1";
    hash = "sha256-5A18zFqbgDc99pqQUPcpwHi89WXb8YVR9VEwO18jH2I=";
  };

  kgt = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "kgt";
    rev = "56c3f46cf286051096d9295118c048219fe0d776";
    hash = "sha256-xH0htDZd2UihLn7PHKLjEYETzcBSeJFOMNredTqlCW8=";
  };
in
stdenv.mkDerivation rec {
  pname = "diagon";
  version = "1.1.158";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "Diagon";
    rev = "1e80fb5c3faff5c4a207ca360b830a9609516349";
    hash = "sha256-gyMIFFT6v5YF2T4KulmgOjqWDctxwzCUFDbG7Nrj0Nw=";
  };

  nativeBuildInputs = [
    cmake
    jdk
  ];

  buildInputs = [
    boost
  ];

  cmakeBuildDir = "build";
  preConfigure = ''
    mkdir -p $cmakeBuildDir
    ln -s ${antlr-jar} $cmakeBuildDir/antlr.jar
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DFETCHCONTENT_SOURCE_DIR_JSON=${json}"
    "-DFETCHCONTENT_SOURCE_DIR_ANTLR=${antlr}"
    "-DFETCHCONTENT_SOURCE_DIR_KGT=${kgt}"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=true"
  ];

  meta = src.meta // {
    description = "An interactive interpreter that transforms markdown-style expression into an ascii-art representation";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.petertrotman ];
    mainProgram = "diagon";
  };
}
