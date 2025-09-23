{ pkgs }:
with pkgs;
buildGoModule rec {
  pname = "carapace";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "${pname}-bin";
    rev = "v${version}";
    hash = "sha256-mwn7oJjVlZli4vhTGui6HCxnjL3Qz8ygejaqvdbZ6co=";
  };

  vendorHash = "sha256-HWczvkItE9SVGGQkddnb7/PBkTWrDAdKHjMOztlYV9M=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  subPackages = [ "./cmd/carapace" ];

  tags = [ "release" ];

  preBuild = ''
    go generate ./...
  '';

  passthru.tests.version = testers.testVersion { package = carapace; };

  meta = with lib; {
    description = "Multi-shell multi-command argument completer";
    homepage = "https://rsteube.github.io/carapace-bin/";
    maintainers = with maintainers; [ star-szr ];
    license = licenses.mit;
    mainProgram = "carapace";
  };
}
