{ pkgs, inputs }:
with pkgs;
stdenvNoCC.mkDerivation {
  pname = "writ";
  version = (lib.importJSON "${inputs.writ}/package.json").version;

  src = inputs.writ;

  nativeBuildInputs = [ makeWrapper ];

  # Upstream builds a single binary with `bun build --compile`. Inside the
  # darwin nix sandbox that command reports success but writes an empty
  # file, so this wraps `bun run` around the sources instead. The imports
  # are only bun/node built-ins, so there is no node_modules step.
  # db.ts reads ../package.json, so it is installed next to src/.
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/writ
    cp -r src package.json $out/share/writ/
    makeWrapper ${lib.getExe bun} $out/bin/writ \
      --add-flags "run" \
      --add-flags "$out/share/writ/src/cli.ts"
    runHook postInstall
  '';

  # Guards against the failure mode above: a broken writ runs "fine" and
  # prints nothing.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    HOME=$TMPDIR $out/bin/writ version | grep -q .
    runHook postInstallCheck
  '';

  meta = {
    description = "A store for why, not just what: records the reasoning behind changes";
    homepage = "https://github.com/jcswart/writ";
    license = lib.licenses.mit;
    mainProgram = "writ";
  };
}
