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
        SillyLily074 = "ebe95a55-f1e7-460e-b399-bf34ef2fd649";
        roblet1 = "ccb25b68-1bfd-4c43-b14f-9d8b68a8c4e8";
        raketijsjes = "c4d8df92-c8a5-4e82-8cd7-003e92751d01";
        MeisterTies = "d2bafbf4-6497-4d79-a03b-167aa1237786";
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
