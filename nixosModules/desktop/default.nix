{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

{
  options = {
    desktop.enable = lib.mkEnableOption "enables desktop environment";

    desktop.environment = lib.mkOption {
      type = lib.types.str;
      default = "plasma6";
      description = "Desktop environment to use (e.g. plasma6, gnome, xfce)";
    };
  };

  config = lib.mkIf config.desktop.enable {
    imports = [
      (lib.mkIf (config.desktop.environment == "plasma6") ./plasma6.nix)
      # If i want to switch
      # (lib.mkIf (config.desktop.environment == "gnome") ./gnome.nix)
      # (lib.mkIf (config.desktop.environment == "xfce") ./xfce.nix)
    ];
  };
}
