{ config
, pkgs
, ...
}:
let
  user_name = "zdcthomas";
in
{
  imports = [
    ./nvim.hm
    ./cli.hm
    ./yabai.hm.nix
  ];
  custom.hm.nvim.enable = true;
  home = {
    username = user_name;
    homeDirectory = "/Users/" + user_name;

    packages = with pkgs; [
      dmux
      # go
      rustup
      (
        with pkgs;
        rustPlatform.buildRustPackage
          rec {
            pname = "hurl";
            version = "2.0.1";

            src = fetchFromGitHub {
              owner = "Orange-OpenSource";
              repo = "hurl";
              rev = version;
              hash = "sha256-sY2bSCcC+mMuYqLmh+oH76nqg/ybh/nyz3trNH2xPQM=";
            };

            cargoHash = "sha256-Zv7TTQw4UcuQBhEdjD5nwcE1LonUHLUFf9BVhRWWuDo=";
            postInstall = ''
              installManPage docs/manual/hurl.1 docs/manual/hurlfmt.1
              installManPage docs/manual/hurl.1 docs/manual/hurlfmt.1
            '';

            nativeBuildInputs = [
              pkg-config
              installShellFiles
            ];
            buildInputs =
              [
                libxml2
                openssl
              ]
              ++ lib.optionals stdenv.isDarwin [
                curl
              ];
            # Tests require network access to a test server
            doCheck = false;

            meta = {
              description = "Hurl, run and test HTTP requests with plain text";
              homepage = "https://github.com/Orange-OpenSource/hurl\n";
              changelog = "https://github.com/Orange-OpenSource/hurl/blob/${src.rev}/CHANGELOG.md";
              # license = licenses.asl20;
              # maintainers = with maintainers; [ ];
            };
          }
      )
      awscli2
      git-remote-codecommit
      nodePackages.aws-cdk
    ];
  };
}
