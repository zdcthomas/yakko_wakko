{inputs, ...}: [
  inputs.nur.overlay
  inputs.fenix.overlays.default
  inputs.discord.overlay
  # inputs.neovim-nightly-overlay.overlay

  (final: prev: {
    dmux = inputs.dmux.packages.${prev.system}.default;
    hyprland = inputs.hyprland.packages.${prev.system}.hyprland;
    eza = inputs.eza.packages.${prev.system}.default;
    ags = inputs.ags.packages.${prev.system}.default;
    anyrun = inputs.anyrun.packages.${prev.system}.anyrun;
    qutebrowser = prev.qutebrowser.override {enableWideVine = true;};
    hyprland-contrib = inputs.hyprland-contrib.packages.${prev.system};

    split-monitor-workspaces = inputs.split-monitor-workspaces.packages.${prev.system}.split-monitor-workspaces;
    xdg-desktop-portal-hyprland = inputs.hyprland.packages.${prev.system}.xdg-desktop-portal-hyprland;
    hurl_2 = import ./hurl.nix {pkgs = prev;};
    ldtk = import ./ldtk.nix {pkgs = prev;};
    keymapp = import ./keymapp.nix {pkgs = prev;};
    pragmataPro = import ./pp.nix {
      pkgs = prev;
      inherit inputs;
    };
  })
]
