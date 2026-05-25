{
  description = "nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      devShells.${system}.default = pkgs.mkShell {
        NIX_CONFIG = "experimental-features = nix-command flakes";
        nativeBuildInputs = with pkgs; [
          nix
          home-manager
          git
          nixd
          nixfmt
        ];
      };

      nixosConfigurations.ShadowBoosterPC = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/ShadowBoosterPC/configuration.nix
          ./nixosModules/default.nix
        ];
      };

      nixosConfigurations.ShadowBoosterLaptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/ShadowBoosterLaptop/configuration.nix
          ./nixosModules/default.nix
        ];
      };
      homeManagerModules.default = ./homeManagerModules;
    };
}
