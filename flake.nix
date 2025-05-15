{
  description = "nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = { self, nixpkgs, ... } @ inputs:
  let
  secrets = builtins.import ./secrets.nix;
  inherit (secrets.userSecrets) Shadow_Booster;
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  in
   {
    nixosConfigurations.Shadow_Booster.username = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ 
        ./nixos/shadowBoosterPC/configuration.nix
       ];
    };
  };
}
