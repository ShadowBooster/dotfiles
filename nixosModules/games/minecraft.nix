{
  lib,
  pkgs,
  config,
  ...
}:

{
  options = {
    minecraft-server.enable = lib.mkEnableOption "enables minecraft-server";
  };

  config = lib.mkIf config.minecraft-server.enable {
    services.minecraft-server = {
      enable = true;
      eula = true;
      declarative = true;
      openFirewall = true;
      whitelist = {
        Shadow_Booster = "0ecf10ea-832a-4e39-926c-f5ef1e74a6c6";
      };
      serverProperties = {
        max-players = 10;
        modt = "ROOD server";
        enable-command-block = true;
        # Rood server
        level-seed = "ROOD";
        level-name = "ROOD";
        white-list = true;
        # comment if everyone is trusted
        op-permission-level = 2;
        spawn-protection = 1;
      };
    };
  };
}
