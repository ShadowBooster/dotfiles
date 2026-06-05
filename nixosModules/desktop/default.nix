i{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

{
  options = {
    desktop.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "whether to enable kde desktop-envirement";
    };
  };

  config = lib.mkIf config.desktop.enable {
    services = {
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
      xserver.enable = true;
      xserver.videoDrivers = [
        "nvidia"
        "amdgpu"
      ];
    };
    programs.xwayland.enable = true;
    qt.platformTheme = "kde";
  };
}
