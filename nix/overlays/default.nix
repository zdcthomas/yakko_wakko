{ inputs, ... }:
[
  inputs.nur.overlays.default
  inputs.fenix.overlays.default

  (final: prev: {
    dmux = inputs.dmux.packages.${prev.stdenv.hostPlatform.system}.default;
    herdr = inputs.herdr.packages.${prev.stdenv.hostPlatform.system}.default;

    ags = inputs.ags.packages.${prev.stdenv.hostPlatform.system}.default;
    qutebrowser = prev.qutebrowser.override { enableWideVine = true; };

    # Force foliate onto XWayland. Under Hyprland its WebKit view stops
    # handling input after you leave the workspace and come back: the book
    # pane ignores scroll, clicks and selection, while the sidebar and the
    # menu still work. Refocusing the window by hand (toggle float, toggle
    # fullscreen, in and out of the special workspace) wakes it up again.
    # Upstream bug, still open:
    #   https://github.com/johnfactotum/foliate/issues/1580
    # It does not happen on sway or GNOME, and GDK_BACKEND=x11 is the fix
    # everyone in that thread lands on. `home.sessionVariables` is the wrong
    # place for it -- that would drag every GTK app onto XWayland -- so it
    # goes in foliate's own wrapper. The desktop file reads `Exec=foliate`,
    # so xdg-open and the launcher both get the wrapped binary.
    #
    # `--set-default`, not `--set`: running `GDK_BACKEND=wayland foliate`
    # still overrides it, which is how you check whether upstream fixed it.
    #
    # Cost of XWayland: the text-selection popup draws a blurred border, and
    # the window does not follow per-monitor scale. Drop this whole override
    # once the bug closes.
    foliate = prev.foliate.overrideAttrs (oldAttrs: {
      preFixup = (oldAttrs.preFixup or "") + ''
        gappsWrapperArgs+=(--set-default 'GDK_BACKEND' 'x11')
      '';
    });
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
    # Public-domain StarDict dictionaries for sdcv. Built here rather than
    # fetched, because none of the three sources ship in StarDict format.
    stardictDictionaries = prev.callPackage ../pkgs/dictionaries { };
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
