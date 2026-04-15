{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Core NixOS settings
  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos";
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    allowReboot = true;
    dates = "daily";
    rebootWindow = {
      lower = "04:00";
      upper = "07:00";
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 14d --keep 10";
    flake = "/etc/nixos";
  };

  security.rtkit.enable = true;
  programs.nix-ld.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    xwayland # Move to desktopManager
    git
    home-manager
    sops
    nix-output-monitor
    tree
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.hack
      vista-fonts
    ];
    fontconfig.defaultFonts = {
      serif = ["hackNerdFont"];
      sansSerif = ["hackNerdFont"];
      monospace = ["hackNerdFont"];
    };
  };
}
