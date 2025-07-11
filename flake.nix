/*
Every file used from anything in a flake _MUST_ and I repeat, _MUST_ be checked into git
*/
{
  description = "Hopefully this _is_ my final form";
  inputs = {
    wezterm = {
      url = "github:wez/wezterm?dir=nix";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # split-monitor-workspaces = {
    #   url = "github:Duckonaut/split-monitor-workspaces";
    #   inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    # };
    # hyprpanel = {
    #   url = "github:M0NsTeRRR/HyprPanel";
    #   # inputs.nixpkgs.follows = "nixos_unstable";
    # };
    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    # };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    eza = {
      url = "github:eza-community/eza/v0.11.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos_unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dmux = {
      url = "github:zdcthomas/dmux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      # inputs.nixpkgs.follows = "nixpkgs";
      # inputs.neovim-src = {
      #   url = "github:neovim/neovim?dir=contrib&rev=27fb62988e922c2739035f477f93cc052a4fee1e";
      #   flake = false;
      # };
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
    };
    font = {
      url = "git+ssh://git@github.com/zdcthomas/PP.git?shallow=1";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    nixos-hardware,
    ...
  } @ inputs: let
    # overlays add/change values in pkgs, e.g
    # change neovim version/ add NUR
    overlays = import ./nix/overlays {inherit inputs;};

    mk_home_username_and_dir = {
      username,
      homeDirectoryPrefix ? "/Users/",
    }: {
      config,
      pkgs,
      ...
    }: {
      home.username = username;
      home.homeDirectory = homeDirectoryPrefix + username;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      home.stateVersion = "22.05"; # Did you read the comment?
    };

    inherit (nixpkgs) lib;
  in {
    darwinConfigurations = let
      workHostName = "Zacharys-MacBook-Pro";
    in {
      "${workHostName}" = let
        username = "zdcthomas";
      in
        darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";
          specialArgs = {
            inherit system username overlays inputs workHostName;
          };
          modules = [
            {nixpkgs.overlays = overlays;}
            home-manager.darwinModule
            ./nix/hosts/work/dar_conf.nix
          ];
        };

      Prime = let
        username = "zacharythomas";
      in
        darwin.lib.darwinSystem rec {
          system = "x86_64-darwin";
          specialArgs = {
            inherit system username overlays inputs;
          };
          modules = [
            {nixpkgs.overlays = overlays;}
            home-manager.darwinModule
            ./nix/hosts/prime/dar_conf.nix
          ];
        };
    };
    nixosConfigurations = {
      #  ------------------
      #  |    Thinkpad    |
      #  ------------------
      nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit overlays;
          inherit system;
          username = "zdcthomas";
        };
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad
          # inputs.hyprland.nixosModules.default
          ({...}: {
            nixpkgs.overlays =
              overlays
              ++ [
                # inputs.neovim-nightly-overlay.overlay
              ];
          })
          ./nix/hosts/thinkpad/configuration.nix
        ];
      };

      opt = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit overlays;
          inherit system;
          username = "opt";
        };
        modules = [
          # inputs.hyprland.nixosModules.default
          ({...}: {
            nixpkgs.overlays =
              overlays;
          })
          nixos-hardware.nixosModules.framework-16-7040-amd
          ./nix/hosts/opt/configuration.nix
        ];
      };
      #  ---------------------
      #  |    Home Server    |
      #  ---------------------
      lar =
        nixpkgs.lib.nixosSystem
        rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs overlays system;
          };
          modules = [
            ({...}: {
              nixpkgs.overlays = overlays;
            })
            ./nix/hosts/lar/configuration.nix
            ./nix/hosts/lar/hardware-configuration.nix
          ];
        };
    };
  };
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org?priority=10"
      "https://nix-community.cachix.org"
      "https://anyrun.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
