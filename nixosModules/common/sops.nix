{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.sops-enable = lib.mkEnableOption "SOPS for secrets management";

  config = lib.mkIf config.sops-enable {
    sops.defaultSopsFile = ./secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "home/${mkHost}/.config/sops/age/keys.txt";
  };
}