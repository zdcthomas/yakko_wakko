/* Every file used from anything in a flake _MUST_ and I repeat, _MUST_ be checked into git */
{
  description = "Hopefully this _is_ my final form";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      darwin = {
        url = "github:lnl7/nix-darwin/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      /* neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay"; */
    };

  outputs = { nixpkgs, home-manager, darwin, ... }:
    let
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

      mkMachine = { username, system, overlays ? [ ] }: {
        username = username;
        pkgs = mk_pkgs_conf { system = system; overlays = overlays; };
        home = mk_home_username_and_dir { username = username; };
        system = system;
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
      /* defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux; */
      /* defaultPackage.x86_64-darwin = home-manager.defaultPackage.x86_64-darwin; */
      /* defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin; */
      darwinConfigurations = {

        /* ------------------------*/
        /* |    Work config       |*/
        /* ------------------------*/
        Zacharys-MacBook-Pro = mkDarConf work {
          darwinModules = [ ./nix/work_dar_conf.nix ];
          homeModules = [ ./home.nix ./nix/work.nix ./nix/hammerspoon.nix ];
        };

        /* -----------------------*/
        /* |    Home config       |*/
        /* -----------------------*/
        Prime = mkDarConf personal {
          darwinModules = [ ./nix/dar_conf.nix ];
          homeModules = [ ./home.nix ./nix/personal.nix ./nix/hammerspoon.nix ];
        };
      };
      homeConfigurations = {
        /* WORK */
        zdcthomas = home-manager.lib.homeManagerConfiguration {
          pkgs = work.pkgs;
          modules = [
            ./home.nix
            ./nix/work.nix
          ];
        };
        /* HOME */
        zacharythomas = home-manager.lib.homeManagerConfiguration {
          pkgs = personal.pkgs;
          modules = [
            ./home.nix
            ./nix/personal.nix
          ];
        };
      };
    };
}
