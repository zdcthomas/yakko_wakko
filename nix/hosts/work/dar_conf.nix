{
  pkgs,
  lib,
  config,
  username,
  inputs,
  overlays,
  workHostName,
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
  fonts.packages = [
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
      "borders"
      "sketchybar"
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
      "aerospace"
    ];
    taps = [
      # "koekeishiya/formulae" # yabai
      "nikitabobko/tap"

      "homebrew/bundle"
      "homebrew/services"
    ];
  };

  services.nix-daemon.enable = true;

  networking.hostName = workHostName;
  system = {
    stateVersion = 5;
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
