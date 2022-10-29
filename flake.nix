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
      work = import nixpkgs {
        system = "aarch64-darwin";
        config = {
          allowUnfree = true;
        };
        overlays = [
          /* neovim-nightly-overlay.overlay */
        ];
      };
      personal = import nixpkgs {
        system = "x86_64-darwin";
        config = {
          allowUnfree = true;
        };
        overlays = [
          /* neovim-nightly-overlay.overlay */
        ];
      };
      inherit (nixpkgs) lib;
    in
    {
      defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
      defaultPackage.x86_64-darwin = home-manager.defaultPackage.x86_64-darwin;
      defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;
      darwinConfigurations = {
        Prime = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./dar_conf.nix

            ({ pkgs, ... }: {


              users.users.zacharythomas = {
                home = "/Users/zacharythomas";
                shell = pkgs.zsh;
              };

              nix = {
                # enable flakes per default
                package = pkgs.nixFlakes;
                settings = {
                  allowed-users = [ "zacharythomas" ];
                  experimental-features = [ "nix-command" "flakes" ];
                };
              };
            })
            home-manager.darwinModule
            {
              home-manager = {
                users.zacharythomas = { ... }: {
                  imports = [
                    ./home.nix
                    ./nix/yabai.nix
                    ./nix/hammerspoon.nix
                  ];
                };
              };
            }
          ];
        };
      };
      homeConfigurations = {
        /* WORK */
        zdcthomas = home-manager.lib.homeManagerConfiguration {
          pkgs = work;
          modules = [
            ./home.nix
            ./nix/work.nix
          ];
        };
        /* HOME */
        zacharythomas = home-manager.lib.homeManagerConfiguration {
          pkgs = personal;
          modules = [
            ./home.nix
            ./nix/personal.nix
          ];
        };
      };
    };
}
