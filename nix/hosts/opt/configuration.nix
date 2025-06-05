args @ {
  config,
  pkgs,
  overlays,
  inputs,
  lib,
  username,
  ...
}: {
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      antialias = true;
      cache32Bit = true;
      hinting.enable = true;
      hinting.autohint = true;
      defaultFonts = {
        monospace = ["PragmataPro Mono Liga"];
        sansSerif = ["PragmataPro"];
        serif = ["PragmataPro"];
        emoji = ["PragmataPro"];
      };
    };

    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      corefonts
      noto-fonts
      noto-fonts-cjk-sans
      pragmataPro
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      jetbrains-mono
    ];
  };
  # networking.extraHosts = let
  #   domains = [
  #     "x"
  #     "facebook"
  #     # "instagram"
  #     # "reddit"
  #   ];
  # in
  #   pkgs.lib.concatMapStringsSep "\n"
  #   (domain: ''
  #     127.0.0.1 ${domain}.com
  #     127.0.0.1 www.${domain}.com
  #   '')
  #   domains;

  zdct = {
    de = "hyprland";
    nix.enable = true;
  };
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} = import ./home.nix;
  home-manager.extraSpecialArgs = {
    inherit overlays inputs username;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking = {
    networkmanager = {
      enable = true;
      # wifi.powersave = true;
    };
    hostName = username; # Define your hostname.
    # nameservers = ["100.100.100.100"]; #
    # useHostResolvConf = true;
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

  powerManagement.enable = true; # Enables hibernate?
  powerManagement.cpuFreqGovernor = "powersave";
  services = {
    # resolved = {
    #   enable = true;
    #   dnssec = "false"; # You might need this if you experience issues
    #   domains = ["~."]; # Handle all DNS queries
    #   fallbackDns = ["100.100.100.100"]; # Use Tailscale's DNS as fallback
    # };
    power-profiles-daemon.enable = false;
    tlp.enable = true;
    # postgresql = {
    #   enable = true;
    #   ensureDatabases = [username];
    #   # ensureUsers = [
    #   #   {
    #   #     name = username;
    #   #   }
    #   # ];
    #   authentication = pkgs.lib.mkOverride 10 ''
    #     #type database  DBuser  auth-method
    #     local all       all     trust
    #   '';
    # };
    fprintd = {
      enable = true;
    };
    keyd = {
      enable = false;
    };
    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
      mouse.disableWhileTyping = true;
    };
    displayManager.autoLogin = {
      enable = true;
      user = username;
    };
    printing.enable = true;

    udisks2 = {
      enable = true;
    };

    tailscale = {
      enable = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  # Enable CUPS to print documents.

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security = {
    rtkit.enable = true;

    sudo.extraConfig = ''
      Defaults lecture = never
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "Zachary Thomas";
    # extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    extraGroups = ["audio" "input" "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      qmk
      libinput
      framework-tool
      kate
      git
      (
        pkgs.writeScriptBin "switch" ''
          nixos-rebuild \
            --flake ~/yakko_wakko#opt \
            --use-remote-sudo -L \
            switch
        ''
      )

      soulseekqt
      alsa-utils
      pulsemixer
      alsa-lib
      alsa-utils
      pamixer
      vim
      gcc
      pamixer
      mpd
      helvum
      xwayland

      #  thunderbird
    ];
  };

  # Enable automatic login for the user.

  # Install firefox.

  programs = {
    firefox.enable = true;
    zsh = {
      enable = true;
    };

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = [username];
    };
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Allow unfree packages
  nixpkgs = {
    config.allowUnfree = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment = {
    etc.nixpkgs.source = inputs.nixpkgs;

    systemPackages = with pkgs; [
      #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      #  wget
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

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
  services.udev = {
    enable = true;
    packages = [
      pkgs.qmk-udev-rules
    ];
    extraRules = ''
      # CMSIS-DAP for microbit
      SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", MODE:="666"
    '';
  };

  environment.etc = {
    "libinput/local-overrides.quirks".text = ''
      [Framework Laptop 16 Keyboard Module]
      MatchName=Framework Laptop 16 Keyboard Module*
      MatchUdevType=keyboard
      MatchDMIModalias=dmi:*svnFramework:pnLaptop16*
      AttrKeyboardIntegration=internal
    '';

    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };
}
