{ config, pkgs, overlays, inputs, ... }:
let username = "sadfrog";
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];

  # services.caddy = {
  #   enable = true;
  #   # virtualHosts."localhost".extraConfig = ''
  #   #   respond "Hello, world!"
  #   # '';
  #
  #   configFile = pkgs.writeText "Caddyfile" ''
  #     # Global options
  #     {
  #       admin off  # Disable admin interface for security
  #     }
  #
  #     # Jellyfin service via Tailscale MagicDNS
  #     jellyfin.lar.tail50bea.ts.net {
  #       # Proxy requests to Jellyfin
  #       reverse_proxy localhost:8096
  #
  #       # Optional: Enable HTTPS (Caddy will automatically manage certificates)
  #       tls internal
  #
  #       # Optional: Add headers for security
  #       header {
  #         # Enable HSTS
  #         Strict-Transport-Security "max-age=31536000;"
  #         # Disable FLoC
  #         Permissions-Policy "interest-cohort=()"
  #       }
  #
  #       # Optional: Gzip compression for better performance
  #       encode gzip
  #     }
  #
  #     # You can add more services here as needed
  #   '';
  # };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} = import ./home.nix;
  home-manager.extraSpecialArgs = { inherit overlays inputs username; };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.utf8";
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services = {
    komga = {
      enable = true;
      openFirewall = true;
    };
    anki-sync-server = {
      enable = true;
      users = [{
        username = "ChickPea";
        password = "password";
      }];
      openFirewall = true;
    };
  };

  programs = { zsh = { enable = true; }; };
  users.users.sadfrog = {
    isNormalUser = true;

    shell = pkgs.zsh;
    description = "Sad Frog";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      (pkgs.writeScriptBin "switch" ''
        nixos-rebuild switch --flake ~/yakko_wakko --use-remote-sudo
      '')
      tailscale
      gcc
      vim
    ];
  };

  services.tailscale.enable = true;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # systemd.services.tailscale-autoconnect =
  # {
  # description = "auto connect to tailscale";
  # after = [ "network-pre.target" "tailscale.service" ];
  # wants = [ "network-pre.target" "tailscale.service" ];
  # wantedBy = [ "multi-user.target" ];

  # serviceConfig.Type = "oneshot";

  # script = with pkgs; ''
  # sleep 2

  # # status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackenState)"
  # # if [ $status = "Running" ]; then
  # #   exit 0
  # # fi

  # ${tailscale}/bin/tailscale up --auth-key tskey-auth-kj37926CNTRL-N8fuDAwoGUKPT6f97MvXZKgqGYeSYgEN
  # '';
  # };

  nixpkgs.config.allowUnfree = true;

  nix = { extraOptions = "experimental-features = nix-command flakes"; };

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    docker-client
    dropbox-cli
    (pkgs.writeScriptBin "switch" ''
      nixos-rebuild switch --flake ~/yakko_wakko --use-remote-sudo
    '')
  ];

  services.openssh.enable = true;

  networking = {
    networkmanager.enable = true;
    hostName = "lar"; # Define your hostname.
    firewall = {
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
      allowedTCPPorts =
        [ 443 80 8096 8920 8080 8123 63584 22 8080 64699 9925 9926 ];
      allowedUDPPorts = [ 1900 7359 config.services.tailscale.port ];
    };
  };
  # Open ports in the firewall.
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  virtualisation.docker.enable = true;

  # virtualisation.oci-containers = {
  #   backend = "docker";
  #   containers = {
  #     test = {
  #       image = "jellyfin/jellyfin";
  #       ports = ["8096:8096"];
  #       volumes = [
  #         "/dev/shm:/transcode:rw"
  #         "~/lar/jellyfin/config:/config"
  #         "~/lar/jellyfin/cache:/cache"
  #         "~/media/TV/:/home/sadfrog/media/TV"
  #         "~/media/MOVIES/:/home/sadfrog/media/MOVIES/"
  #         "~/media/BOOKS/:/home/sadfrog/media/BOOKS/"
  #         "~/media/MUSIC/:/home/sadfrog/media/MUSIC/"
  #         "~/media/staging/complete/:/home/sadfrog/media/staging/"
  #       ];
  #       environment = {
  #         PUID = "1000";
  #         PGID = "1000";
  #         TZ = "America/Denver";
  #       };
  #     };
  #   };
  # };
}
