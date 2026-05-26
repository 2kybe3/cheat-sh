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
        homeManagerModule = pkgs.callPackage ./nix/modules/home-manager.nix { };
        nixosModule = pkgs.callPackage ./nix/modules/nixos.nix { };

        nixosTest = pkgs.callPackage ./nix/tests/nixos.nix { };
        homeManagerTest = pkgs.callPackage ./nix/tests/home-manager.nix { inherit home-manager; };
      in
      {
        packages = {
          inherit cheat-sh;
          default = cheat-sh;
        };

        homeManagerModule.default = homeManagerModule;

        nixosModules.default = nixosModule;
      }
      // {
        checks = {
          inherit cheat-sh nixosTest homeManagerTest;
        };

      }
    );
}
