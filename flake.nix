{
  description = "Multi-machine NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixos-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, nixos-unstable, sops-nix, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;


    # Helper function to create NixOS configurations
    mkHost = {
      hostname,
      modules ? [],
      specialArgs ? {},
      users ? {},
    }: {
      "${hostname}" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs =
          {
            inherit self inputs nixpkgs nixos-unstable;
          }
          // specialArgs;
        modules =
          [
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            ./nixosModules
            ./hosts/${hostname}
            {
            networking.hostName = hostname;
            }
          ]
        
          ++ modules;
      };
    };

    # Helper to create home-manager config
    mkHomeConfig = user: {
      "${user}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/${user}/home.nix
        ];
      };
    };

    in
    {
    nixosConfigurations = mkHost {
      hostname = "ShadowBoosterPC";
      users = "evelynvds";
    } // mkHost {
      hostname = "ShadowBoosterLaptop";
      users = "shadowbooster";
    } // mkHost {
      hostname = "ShadowBoosterServer";
    };
  };
}
