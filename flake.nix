{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = { self, nixpkgs, ... } @ inputs:
  let
  secrets = builtins.import ./secrets.nix;
  inherit (secrets.userSecrets) Shadow_Booster;
  in
   {
    nixosConfigurations.Shadow_Booster.username = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ 
        nixos/ShadowBoosterPC/configuration.nix
       ];
    };
  };
}
