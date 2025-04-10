{inputs, ...}: [
  inputs.nur.overlay
  inputs.fenix.overlays.default
  # inputs.neovim-nightly-overlay.overlays.default

  (final: prev: {
    dmux = inputs.dmux.packages.${prev.system}.default;
    hyprland = inputs.hyprland.packages.${prev.system}.hyprland;
    eza = inputs.eza.packages.${prev.system}.default;
    ags = inputs.ags.packages.${prev.system}.default;
    anyrun = inputs.anyrun.packages.${prev.system}.anyrun;
    ghostty = inputs.ghostty.packages.${prev.system}.default;
    qutebrowser = prev.qutebrowser.override {enableWideVine = true;};
    hyprland-contrib = inputs.hyprland-contrib.packages.${prev.system};
    unstable = inputs.unstable.legacyPackages.${prev.system};

    split-monitor-workspaces = inputs.split-monitor-workspaces.packages.${prev.system}.split-monitor-workspaces;
    xdg-desktop-portal-hyprland = inputs.hyprland.packages.${prev.system}.xdg-desktop-portal-hyprland;
    wezterm = inputs.wezterm.packages.${prev.system}.default;
    neovim = inputs.neovim-nightly-overlay.packages.${prev.system}.default;
    hurl_2 = import ./hurl.nix {pkgs = prev;};
    nuekit = import ./nuekit.nix {pkgs = prev;};
    diagon = import ./diagon.nix {
      pkgs = prev;
      unstable = inputs.unstable.legacyPackages.${prev.system};
    };
    ldtk = import ./ldtk.nix {pkgs = prev;};
    carapace = import ./carapace.nix {pkgs = prev;};
    keymapp = import ./keymapp.nix {pkgs = prev;};
    pragmataPro = import ./pp.nix {
      pkgs = prev;
      inherit inputs;
    };
  })
]
