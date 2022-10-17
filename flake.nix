/* Every file used from anything in a flake _MUST_ and I repeat, _MUST_ be checked into git */
{
  description = "Hopefully this _is_ my final form";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      /* neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay"; */
    };

  outputs = { nixpkgs, home-manager, ... }:
    let
      work = import nixpkgs {
	system =  "aarch64-darwin";
        config = {
          allowUnfree = true;
        };
        overlays = [
          /* neovim-nightly-overlay.overlay */
        ];
      };
      personal = import nixpkgs {
	system =  "x86_64-darwin";
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
      homeConfigurations = {
        zdcthomas = home-manager.lib.homeManagerConfiguration {
          pkgs = work;
          modules = [
            ./home.nix
          ];
        };
        zacharythomas = home-manager.lib.homeManagerConfiguration {
          pkgs = personal;
          modules = [
            ./home.nix
          ];
        };
      };
    };
}
