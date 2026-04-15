{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./core.nix
    ./sops.nix
    ./localization.nix
  ];
}