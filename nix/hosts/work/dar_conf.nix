{
  pkgs,
  lib,
  config,
  username,
  inputs,
  overlays,
  workHostName,
  ...
}:
{
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };
  home-manager = {
    useGlobalPkgs = true;
    # useUserPackages = true;
    extraSpecialArgs = { inherit overlays inputs username; };
    users.${username} =
      { ... }:
      {
        imports = [ ./home.nix ];
      };
  };
  fonts.packages = [ pkgs.pragmataPro ];

  ids.gids.nixbld = 30000;

  nix = {
    settings = {
      allowed-users = [
        "root"
        username
      ];
      trusted-users = [
        "root"
        username
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  homebrew = {
    enable = true;
    onActivation = {
      # Homebrew 7 removed `brew bundle --cleanup`; it is a subcommand now.
      # nix-darwin's 25.11 branch still passes the dead flag, which aborts
      # activation before home-manager runs. master is fixed, so restore
      # "zap" after the next nix-darwin release bump. Until then, clean up
      # by hand with: brew bundle cleanup --force --zap --file=<Brewfile>
      cleanup = "none";
    };

    brews = [
      # "yabai"
      "coreutils"
      "awscurl"
      "json-table"
      "bazel"
      "acli"
      # borders and sketchybar were dropped when Homebrew 7 started refusing
      # their untrusted felixkratz/formulae tap. Neither was in use. To bring
      # one back, re-add it and run: brew trust felixkratz/formulae
    ];
    casks = [
      "hammerspoon"
      "wezterm"
      # "alacritty"
      # "iterm2"
      # "slack"
      # "docker"
      "kitty"
      # "firefox"
      "aws-vpn-client"
      "aerospace"
    ];
    taps = [
      # "koekeishiya/formulae" # yabai
      "nikitabobko/tap"
      "atlassian/homebrew-acli"

      "homebrew/bundle"
      "homebrew/services"
    ];
  };

  system.primaryUser = username;

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
