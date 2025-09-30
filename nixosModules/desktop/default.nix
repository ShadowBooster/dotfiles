{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

{
  options = {
    desktop.enable = lib.mkEnableOption "plasma6";

    # currently only plasma6
    # desktop.environment = lib.mkOption {
    #   type = lib.types.str;
    #   default = "plasma6";
    #   description = "Desktop environment to use (e.g. plasma6, gnome, xfce)";
    # };
  };

  config = lib.mkIf config.desktop.enable {
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    qt.platformTheme = "kde";
  };
}
