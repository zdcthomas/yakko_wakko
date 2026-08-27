{ inputs, ... }:
[
  inputs.nur.overlays.default
  inputs.fenix.overlays.default

  (final: prev: {
    dmux = inputs.dmux.packages.${prev.stdenv.hostPlatform.system}.default;
    herdr = inputs.herdr.packages.${prev.stdenv.hostPlatform.system}.default;

    ags = inputs.ags.packages.${prev.stdenv.hostPlatform.system}.default;
    qutebrowser = prev.qutebrowser.override { enableWideVine = true; };
    hyprland-contrib = inputs.hyprland-contrib.packages.${prev.stdenv.hostPlatform.system};
    unstable = import inputs.unstable {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
    claude-nixpkgs = import inputs.claude-nixpkgs {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };

    wezterm = inputs.wezterm.packages.${prev.stdenv.hostPlatform.system}.default;
    # hurl_2 = import ./hurl.nix { pkgs = prev; };
    nuekit = import ./nuekit.nix { pkgs = prev; };
    diagon = import ./diagon.nix { pkgs = prev; };
    ldtk = import ./ldtk.nix { pkgs = prev; };
    carapace = import ./carapace.nix { pkgs = prev; };
    pragmataPro = import ./pp.nix {
      pkgs = prev;
      inherit inputs;
    };
  })
]
