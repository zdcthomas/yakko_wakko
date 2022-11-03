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
      /* work_username = "zdcthomas"; */
      /* personal_username = "zacharythomas"; */
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
      /* work_pkgs = mk_pkgs_conf { */
      /*   system = "aarch64-darwin"; */
      /* }; */
      personal_pkgs = mk_pkgs_conf {
        system = "x86_64-darwin";
      };

      /* work_username_and_dir = mk_home_username_and_dir { username = work_username; }; */

      /* work = { */
      /*   username = work_username; */
      /*   pkgs = work_pkgs; */
      /*   home = work_username_and_dir; */
      /*   system = "aarch64-darwin"; */
      /* }; */

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
        /* Zacharys-MacBook-Pro = darwin.lib.darwinSystem { */
        /*   system = work.system; */
        /*   modules = [ */
        /*     ./nix/work_dar_conf.nix */
        /*     home-manager.darwinModule */
        /*     { */
        /*       home-manager = { */
        /*         users.${work.username} = { ... }: { */
        /*           imports = [ */
        /*             ./home.nix */
        /*             ./nix/work.nix */
        /*             /1* ./nix/yabai.nix *1/ */
        /*             ./nix/hammerspoon.nix */
        /*             work.home */
        /*           ]; */
        /*         }; */
        /*       }; */
        /*     } */
        /*   ]; */
        /* }; */
        Zacharys-MacBook-Pro = mkDarConf work {
          darwinModules = [ ./nix/work_dar_conf.nix ];
          homeModules = [ ./home.nix ./nix/work.nix ./nix/hammerspoon.nix ];
        };

        /* -----------------------*/
        /* |    Home config       |*/
        /* -----------------------*/
        Prime = mkDarConf personal {
          darwinModules = [ ./nix/dar_conf.nix ];
          homeModules = [ ./home.nix ./nix/hammerspoon.nix ];
        };

        /* Prime = darwin.lib.darwinSystem { */
        /*   system = personal.system; */
        /*   modules = [ */
        /*     ./nix/dar_conf.nix */
        /*     home-manager.darwinModule */
        /*     { */
        /*       home-manager = { */
        /*         users.${personal.username} = { ... }: { */
        /*           imports = [ */
        /*             ./home.nix */
        /*             /1* ./nix/yabai.nix *1/ */
        /*             ./nix/hammerspoon.nix */
        /*           ]; */
        /*         }; */
        /*       }; */
        /*     } */
        /*   ]; */
        /* }; */
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
