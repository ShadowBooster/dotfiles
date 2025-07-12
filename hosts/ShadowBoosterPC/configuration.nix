{
  config,
  pkgs,
  options,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "home/evelynvds/.config/sops/age/keys.txt";

  networking.hostName = "ShadowBoosterPC";

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    settings.auto-optimise-store = true;
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    bluetooth.enable = true;
    ckb-next.enable = true;
  };

  # Bootloader.
  boot = {
    #boot.kernelPackages = pkgs.linuxPackages_latest;
    loader.grub = {
      enable = true;
      device = "/dev/nvme0n1";
      useOSProber = true;
    };
  };

  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8080
    ];
  };

  # Localization
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LANGUAGE = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Window server
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  programs.xwayland.enable = true;

  # Desktop environment
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  qt.platformTheme = "kde";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  virtualisation.virtualbox.host.enable = true;

  services.ratbagd.enable = true;
  services.power-profiles-daemon.enable = true;
  services.xserver.desktopManager.retroarch.enable = true;
  zramSwap.enable = true;
  services.sysstat.enable = true;

  programs = {
    partition-manager.enable = true;
    kdeconnect.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      #dedicatedServer.openFirewall = true;
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 10";
      flake = "/etc/nixos";
    };
    droidcam.enable = true;
  };
  services.lorri.enable = true;
  programs.direnv.enable = true;

  minecraft-server.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.evelynvds = {
    isNormalUser = true;
    description = "Evelyn";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kdeconnect-kde

      #Coding
      kdePackages.kate # ide
      kdePackages.kdialog # send notivation to user
      helix # text editor
      vscodium # ide
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      #jetbrains.rust-rover
      statix # nix linter

      pkg-config
      tor-browser
      lutris
      kdePackages.filelight
      kdePackages.kdenlive

      #programming languages
      rustup # rust programming language
      jdk # java
      python3
      kdePackages.partitionmanager
      kdePackages.ksystemlog

      #Terminal
      fastfetch # system info
      #starship # terminal theme
      zsh # shell
      oh-my-zsh # shell
      shellcheck

      #Gaming
      discord # chat
      steam # games
      prismlauncher # minecraft
      mcrcon # talking to minecraft
      airshipper

      #Work
      libreoffice # office
      thunderbird # mail

      #internet
      firefox # browser
      teams-for-linux

      #Rest
      fwupd
      obs-studio # recording software
      signal-desktop-bin # chatting software
      telegram-desktop
      gimp # photo editing
      spotify # music
      kdePackages.kcalc # calculator
      vlc # videos player
      nvd # see what happend between builds
      _7zz # 7z extraction tool
      piper
      nixfmt-rfc-style

      #Words
      hunspell
      hunspellDicts.nl_NL
      hunspellDicts.en_GB-ize
      hyphen
      mythes
      languagetool
    ];
  };
  programs.nix-ld.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {
        inherit (config.nixpkgs) config;
      };
      stable = import <nixos-24.11> {
        inherit (config.nixpkgs) config;
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ckb-next
    xwayland
    git
    home-manager
    sops
    nix-output-monitor
    tree
  ];

  #fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.hack
      vistafonts
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "hackNerdFont" ];
        sansSerif = [ "hackNerdFont" ];
        monospace = [ "hackNerdFont" ];
      };
    };
  };

  environment.shells = with pkgs; [ zsh ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      rebuild = "sh ~/dotfiles/scrips/nixos/nixos-rebuild.sh";
      update = "sh ~/dotfiles/scrips/nixos/nixos-update.sh";
      commit = "sh ~/dotfiles/scrips/nixos/nixos-commit.sh";
    };
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "direnv"
      ];
      theme = "robbyrussell";
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # prints logs
    ];
    allowReboot = true;
    dates = "daily";
    rebootWindow = {
      lower = "04:00";
      upper = "07:00";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # system.copySystemConfiguration = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
