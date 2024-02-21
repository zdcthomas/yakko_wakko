/*
Every file used from anything in a flake _MUST_ and I repeat, _MUST_ be checked into git
*/
{
  description = "Hopefully this _is_ my final form";
  inputs = {
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    eza = {
      url = "github:eza-community/eza/v0.11.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    discord = {
      url = "github:InternetUnexplorer/discord-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dmux = {
      url = "github:zdcthomas/dmux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      # inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/neovim-nightly-overlay";
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
    mk_pkgs_conf = {
      system,
      overlays ? [],
    }:
      import nixpkgs {
        system = system;
        config = {
          allowUnfree = true;
        };
        overlays = overlays;
      };

    mkMachine = {
      username,
      system,
      overlays ? [],
      homeDirectoryPrefix ? "/Users/",
    }: {
      username = username;
      pkgs = mk_pkgs_conf {
        system = system;
        overlays = overlays;
      };
      home = mk_home_username_and_dir {
        username = username;
        homeDirectoryPrefix = homeDirectoryPrefix;
      };
      system = system;
    };

    home-serv = mkMachine {
      username = "sadfrog";
      system = "x86_64-linux";
      homeDirectoryPrefix = "/home/";
    };

    work = mkMachine {
      username = "zdcthomas";
      system = "aarch64-darwin";
    };

    personal = mkMachine {
      username = "zacharythomas";
      system = "x86_64-darwin";
    };

    mkDarConf = {
      username,
      pkgs,
      home,
      system,
    }: {
      darwinModules,
      homeModules,
    }:
      darwin.lib.darwinSystem {
        system = system;
        modules =
          darwinModules
          ++ [
            {nixpkgs = pkgs;}
            home-manager.darwinModule
            {
              home-manager = {
                users.${username} = {...}: {
                  imports =
                    [
                      home
                    ]
                    ++ homeModules;
                };
              };
            }
          ];
      };

    inherit (nixpkgs) lib;
  in {
    darwinConfigurations = {
      /*
      ------------------------
      */
      /*
      |    Work config       |
      */
      /*
      ------------------------
      */

      Zacharys-MacBook-Pro = let
        username = "zdcthomas";
      in
        darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";
          specialArgs = {
            inherit system username overlays inputs;
          };
          modules = [
            {nixpkgs.overlays = overlays;}
            home-manager.darwinModule
            ./nix/hosts/work/dar_conf.nix
          ];
        };

      /*
      -----------------------
      */
      /*
      |    Home config       |
      */
      /*
      -----------------------
      */
      Prime =
        mkDarConf
        personal
        {
          darwinModules = [./nix/personal.dar.nix];
          homeModules = [./home.nix ./nix/personal.hm.nix ./nix/modules/home];
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
          inputs.hyprland.nixosModules.default
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
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
