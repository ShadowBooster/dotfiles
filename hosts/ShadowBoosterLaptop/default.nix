{ config, pkgs, ... }:
{
  imports = [
    ./${hostname}/configuration.nix
    ./${hostname}/hardware-configuration.nix
  ];
}
