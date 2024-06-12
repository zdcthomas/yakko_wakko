# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
args @ {
  config,
  pkgs,
  overlays,
  inputs,
  lib,
  username,
  ...
}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/${username}/yakko_wakko";
  };
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      antialias = true;
      cache32Bit = true;
      hinting.enable = true;
      hinting.autohint = true;
      # localConf = ''
      #   <match target="font">
      #     <test name="family" compare="eq" ignore-blanks="true">
      #       <string>PragmataPro</string>
      #     </test>
      #     <edit name="fontfeatures" mode="append">
      #       <string>ss13 on</string>
      #       <string>ss11 on</string>
      #       <string>calt on</string>
      #       <string>frac on</string>
      #     </edit>
      #   </match>
      # '';
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
    ];
  };
  networking.extraHosts = let
    domains = [
      "x"
      "facebook"
      # "instagram"
    ];
  in
    pkgs.lib.concatMapStringsSep "\n"
    (domain: ''
      127.0.0.1 ${domain}.com
      127.0.0.1 www.${domain}.com
    '')
    domains;

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

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = username; # Define your hostname.
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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  # services.xserver = {
  #   layout = "us";
  #   xkbVariant = "";
  # };

  services = {
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
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security = {
    rtkit.enable = true;

    sudo.extraConfig = ''
      Defaults lecture = never
    '';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.opt = {
    isNormalUser = true;
    description = "Zachary Thomas";
    # extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    extraGroups = ["audio" "input" "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      kate
      git
      (
        pkgs.writeScriptBin "switch" ''
          nixos-rebuild switch --flake ~/yakko_wakko#opt --use-remote-sudo -L
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
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
  # services.blueman.enable = true;
  services.udev = {
    enable = true;
    extraRules = ''
      # CMSIS-DAP for microbit
      SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", MODE:="666"
    '';
  };

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
}
