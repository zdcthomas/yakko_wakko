{ inputs, ... }:
[
  inputs.nur.overlay
  inputs.fenix.overlays.default
  # inputs.hyprpanel.overlay
  # inputs.neovim-nightly-overlay.overlays.default

  (final: prev: {
    dmux = inputs.dmux.packages.${prev.system}.default;
    # hyprland = inputs.hyprland.packages.${prev.system}.hyprland;
    eza = inputs.eza.packages.${prev.system}.default;
    ags = inputs.ags.packages.${prev.system}.default;
    anyrun = inputs.anyrun.packages.${prev.system}.anyrun;
    qutebrowser = prev.qutebrowser.override { enableWideVine = true; };
    hyprland-contrib = inputs.hyprland-contrib.packages.${prev.system};
    unstable = import inputs.unstable {
      system = prev.system;
      config.allowUnfree = true;
    };

    # split-monitor-workspaces = inputs.split-monitor-workspaces.packages.${prev.system}.split-monitor-workspaces;
    # xdg-desktop-portal-hyprland = inputs.hyprland.packages.${prev.system}.xdg-desktop-portal-hyprland;
    wezterm = inputs.wezterm.packages.${prev.system}.default;
    neovim = inputs.neovim-nightly-overlay.packages.${prev.system}.default;
    hurl_2 = import ./hurl.nix { pkgs = prev; };
    nuekit = import ./nuekit.nix { pkgs = prev; };
    diagon = import ./diagon.nix { pkgs = prev; };
    ldtk = import ./ldtk.nix { pkgs = prev; };
    carapace = import ./carapace.nix { pkgs = prev; };
    keymapp = import ./keymapp.nix { pkgs = prev; };
    pragmataPro = import ./pp.nix {
      pkgs = prev;
      inherit inputs;
    };
  })
]
