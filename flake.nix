/* Every file used from anything in a flake _MUST_ and I repeat, _MUST_ be checked into git */
{
  description = "Hopefully this _is_ my final form";
  inputs =
    {
      ags.url = "github:Aylur/ags";
      hyprland.url = "github:hyprwm/Hyprland";
      nixos-hardware.url = "github:NixOS/nixos-hardware/master";
      nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
      dmux.url = "github:zdcthomas/dmux";
      neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
      nur.url = "github:nix-community/NUR";
      nix-colors.url = "github:misterio77/nix-colors";
    };

  outputs = { self, nixpkgs, home-manager, darwin, nixos-hardware, ... }@inputs:
    let
      # overlays add/change values in pkgs, e.g
      # change neovim version/ add NUR
      overlays = [
        inputs.neovim-nightly-overlay.overlay
        inputs.nur.overlay
        inputs.fenix.overlays.default
        inputs.discord.overlay
        (final: prev: {
          dmux = inputs.dmux.defaultPackage.${prev.system};
          ags = inputs.ags.packages.${prev.system}.default;
        })
      ];

      mk_home_username_and_dir = { username, homeDirectoryPrefix ? "/Users/" }: { config, pkgs, ... }: {
        home.username = username;
        home.homeDirectory = homeDirectoryPrefix + username;
      };
      mk_pkgs_conf = { system, overlays ? [ ] }:
        import nixpkgs {
          system = system;
          config = {
            allowUnfree = true;
          };
          overlays = overlays;
        };

      mkMachine = { username, system, overlays ? [ ], homeDirectoryPrefix ? "/Users/" }: {
        username = username;
        pkgs = mk_pkgs_conf { system = system; overlays = overlays; };
        home = mk_home_username_and_dir { username = username; homeDirectoryPrefix = homeDirectoryPrefix; };
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

      mkDarConf = { username, pkgs, home, system }: { darwinModules, homeModules }: darwin.lib.darwinSystem {
        system = system;
        modules = darwinModules ++ [
          { nixpkgs = pkgs; }
          home-manager.darwinModule
          {
            home-manager = {
              users.${username} = { ... }: {
                imports = [
                  home
                ] ++ homeModules;
              };
            };
          }
        ];

      };

      inherit (nixpkgs) lib;

    in
    {
      # defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
      /* defaultPackage.x86_64-darwin = home-manager.defaultPackage.x86_64-darwin; */
      /* defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin; */
      # overlays = overlays;
      darwinConfigurations = {

        /* ------------------------*/
        /* |    Work config       |*/
        /* ------------------------*/
        Zacharys-MacBook-Pro =
          let
            username = "zdcthomas";
          in
          darwin.lib.darwinSystem rec {

            system = "aarch64-darwin";
            specialArgs = { inherit system username overlays; };
            modules = [
              ./nix/work_dar_conf.nix
              { nixpkgs.overlays = overlays; }
              home-manager.darwinModule
            ];
          };

        /* -----------------------*/
        /* |    Home config       |*/
        /* -----------------------*/
        Prime = mkDarConf
          personal
          {
            darwinModules = [ ./nix/dar_conf.nix ];
            homeModules = [ ./home.nix ./nix/personal.nix ./nix/hammerspoon.nix ];
          };
      };
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs; inherit overlays; inherit system;
          };
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad
            ({ ... }: {
              nixpkgs. overlays = overlays;
            })
            ./nix/nixos_configs/thinkpad/configuration.nix
          ];
        };
        lar = nixpkgs.lib.nixosSystem
          {
            system = "x86_64-linux";
            modules = [
              ./nix/nixos_configs/lar/configuration.nix
              ./nix/nixos_configs/lar/hardware-configuration.nix
            ];
          };


      };
      homeConfigurations = {
        /* HOME SERVER */
        sadfrog = home-manager.lib.homeManagerConfiguration {
          pkgs = home-serv.pkgs;
          modules = [
            ./home.nix
            home-serv.home
            ./nix/sadfrog.nix
          ];
        };
        /* WORK */
        /* zdcthomas = home-manager.lib.homeManagerConfiguration { */
        /*   pkgs = work.pkgs; */
        /*   modules = [ */
        /*     ./home.nix */
        /*     ./nix/work.nix */
        /*   ]; */
        /* }; */
        /* HOME */
        /* zacharythomas = home-manager.lib.homeManagerConfiguration { */
        /*   pkgs = personal.pkgs; */
        /*   modules = [ */
        /*     ./home.nix */
        /*     ./nix/personal.nix */
        /*   ]; */
        /* }; */
      };
    };
}
