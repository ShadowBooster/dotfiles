{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./games/minecraft.nix
    ./desktop/default.nix
    ./system/default.nix
  ];

}
