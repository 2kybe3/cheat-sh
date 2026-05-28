{
  description = "Wrapper for ch.sh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      home-manager,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        cheat-sh = pkgs.callPackage ./nix/cheat-sh.nix { };

        homeManagerModule = import ./nix/modules/home-manager.nix;
        nixosModule = import ./nix/modules/nixos.nix;

        nixosTest = pkgs.callPackage ./nix/tests/nixos.nix { inherit nixosModule; };
        homeManagerTest = pkgs.callPackage ./nix/tests/home-manager.nix {
          inherit home-manager homeManagerModule;
        };
      in
      {
        packages = {
          inherit cheat-sh;
          default = cheat-sh;
        };

        homeManagerModules = {
          default = homeManagerModule;
          cheat-sh = homeManagerModule;
        };

        nixosModules = {
          default = nixosModule;
          cheat-sh = nixosModule;
        };
      }
      // {
        checks = {
          inherit cheat-sh nixosTest homeManagerTest;
        };

      }
    );
}
