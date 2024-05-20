{
  pkgs,
  lib,
  username,
  inputs,
  overlays,
  ...
}: {
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };
  home-manager = {
    useGlobalPkgs = true;
    # useUserPackages = true;
    extraSpecialArgs = {
      inherit overlays inputs username;
    };
    users.${username} = {...}: {
      imports = [
        ./home.nix
      ];
    };
  };
  fonts.fonts = [
    pkgs.pragmataPro
  ];

  nix = {
    settings = {
      allowed-users = ["root" username];
      trusted-users = ["root" username];
      experimental-features = ["nix-command" "flakes"];
    };
  };
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
    };

    brews = [
      # "yabai"
      "coreutils"
      "awscurl"
      "json-table"
      "bazel"
    ];
    casks = [
      "hammerspoon"
      "wezterm"
      /*
      "alacritty"
      */
      /*
      "iterm2"
      */
      /*
      "slack"
      */
      "docker"
      "kitty"
      /*
      "firefox"
      */
      "aws-vpn-client"
    ];
    taps = [
      # "koekeishiya/formulae" # yabai
    ];
  };

  services.nix-daemon.enable = true;

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    defaults = {
      NSGlobalDomain = {
        AppleShowAllFiles = true;
        # NSAutomaticWindowAnimationsEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        AppleKeyboardUIMode = 3;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      screensaver.askForPassword = true;

      dock = {
        appswitcher-all-displays = true;
        autohide = true;
        show-recents = true;
        tilesize = 45;
        magnification = true;
        showhidden = true;
      };
    };
  };
}
