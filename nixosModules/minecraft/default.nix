{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./minecraft-server.nix
  ];

  options = {
    minecraft.enable = lib.mkEnableOption "enables minecraft";
    minecraft-server.enable = lib.mkEnableOption "enables minecraft-server";
  };

  #minecraft config
  config = lib.mkIf config.minecraft.enable {

  };
}
