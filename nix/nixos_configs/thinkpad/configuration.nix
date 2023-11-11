#  ----------------------------------------------------------------
#  |    L580 (type 20LW, 20LX) Laptops (ThinkPad) - Type 20LW |
#  ----------------------------------------------------------------
args @ {
  config,
  pkgs,
  overlays,
  inputs,
  lib,
  ...
}: let
  username = "zdcthomas";
in {
  # config.z.de = "i3";
  zdct.de = "hyprland";
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./de.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} = import ./home.nix;
  home-manager.extraSpecialArgs = {
    inherit overlays inputs username;
  };

  # virtualisation.docker.enable = true;
  environment.etc.nixpkgs.source = inputs.nixpkgs;
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };
  nix = {
    package = pkgs.nixUnstable;

    # extraOptions = ''
    #   experimental-features = nix-command flakes
    # '';
    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;
    settings = {
      warn-dirty = false;
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "/etc/nix/registry.json";
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      trusted-users = [username];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    optimise = {
      automatic = true;
      dates = ["04:00"];
    };
  };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  console.earlySetup = true;

  networking = {
    dhcpcd.wait = "background";
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    hostName = "nixos"; # Define your hostname.

    # Enable networking
    networkmanager.enable = true;

    firewall.allowedTCPPorts = [8080];
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  console.useXkbConfig = true;

  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      localConf = ''
        <match target="scan">
            <test name="family">
                <string>Iosevka</string>
            </test>
            <edit name="spacing">
                <int>100</int>
            </edit>
        </match>
      '';
      defaultFonts = {
        monospace = [
          "Iosevka"
        ];
      };
    };

    enableFontDir = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      terminus_font
      corefonts
      noto-fonts
      # iosevka
      (
        nerdfonts.override {
          fonts = [
            "Terminus"
            "FiraCode"
            "Meslo"
            "Monofur"
            "Iosevka"
          ];
        }
      )
      # noto-fonts
      # noto-fonts-cjk
      # noto-fonts-emoji
      # liberation_ttf
      # fira-code
      # fira-code-symbols
      # iosevka
      # mplus-outline-fonts.githubRelease
      # dina-font
      # proggyfonts
    ];
  };

  services = {
    udisks2 = {
      enable = true;
    };
    # mysql = {
    #   enable = true;
    #   package = pkgs.mariadb;
    # };
    # calibre-server = {
    #   enable = true;
    #   user = "zdcthomas";
    # };
    journald.extraConfig = "SystemMaxUse=1G";
    locate.enable = true;

    tailscale = {
      enable = true;
    };

    printing.enable = true;
    blueman.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };

  # Enable CUPS to print documents.

  # Enable sound with pipewire.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez5-experimental;
    #hsphfpd.enable = true;
    powerOnBoot = true;
    disabledPlugins = ["sap"];
    settings = {
      General = {
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
      };
    };
  };
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "Zachary Thomas";
    extraGroups = ["audio" "input" "networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      alsa-utils
      pulsemixer
      alsa-lib
      alsa-utils
      pamixer
      vim
      gcc
      dmux
      pamixer
      mpd
      helvum
      xwayland
    ];
  };

  # Allow unfree packages
  nixpkgs = {
    config.allowUnfree = true;
    config.pulseaudio = true;
  };

  programs.zsh = {
    enable = true;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [username];
  };

  documentation = {
    doc.enable = false;
    nixos.enable = true;
    info.enable = false;
    man = {
      enable = lib.mkDefault true;
      generateCaches = lib.mkDefault true;
    };
  };

  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
