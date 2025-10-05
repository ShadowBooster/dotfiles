{
  lib,
  pkgs,
  config,
  ...
}:

{
  options = {
    nix.enable = lib.mkEnableOption "enables nix";
  };

  config = lib.mkIf config.nix.enable {
    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      settings.auto-optimise-store = true;
    };
  };
}