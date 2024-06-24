{pkgs}:
with pkgs;
  buildNpmPackage rec {
    pname = "shortcut-cli";
    version = "2.7.0";

    src = fetchFromGitHub {
      owner = "shortcut-cli";
      repo = "shortcut-cli";
      rev = "31b78d3e358f522ca1ea9ddb8dd3c58ed4074374";
      hash = "sha256-GDdgIHXgKatu7jH2SLJriwhPAmipP7PU3omeOWIStIo=";
    };

    npmDepsHash = "sha256-QlCLEvmqLVkWwgTVlToYD6bptLp/MVfQ10Wdfr3PIr4=";

    meta = {
      description = "Command line tool for viewing, creating and updating shortcut.io stories";
      homepage = "https://github.com/andjosh/shortcut-cli";
      changelog = "https://github.com/andjosh/shortcut-cli/blob/${src.rev}/CHANGELOG.md";
      license = lib.licenses.mit;
      mainProgram = "club";
      maintainers = with lib.maintainers; [tobim];
    };
  }
{pkgs}:
with pkgs;
  buildNpmPackage rec {
    pname = "clubhouse-cli";
    version = "2.7.0";

    src = fetchFromGitHub {
      owner = "andjosh";
      repo = "clubhouse-cli";
      rev = "v${version}";
      hash = "sha256-OGUEPWKL3GBIQHEDljX1gXMRDEztIrJT5ivAIcyW91k=";
    };

    npmDepsHash = "sha256-QlCLEvmqLVkWwgTVlToYD6bptLp/MVfQ10Wdfr3PIr4=";

    meta = {
      description = "Command line tool for viewing, creating and updating clubhouse.io stories";
      homepage = "https://github.com/andjosh/clubhouse-cli";
      changelog = "https://github.com/andjosh/clubhouse-cli/blob/${src.rev}/CHANGELOG.md";
      license = lib.licenses.mit;
      mainProgram = "club";
      maintainers = with lib.maintainers; [tobim];
    };
  }
