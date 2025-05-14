# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  options,
  ...
}:
let
  secrets = builtins.import ./secrets.nix;
  Shadow_Booster = secrets.userSecrets.Shadow_Booster;
in
{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Hardware config
  hardware.graphics.enable = true;

  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  # Linux version
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      25565 # port for minecraft-server
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
  hardware.bluetooth.enable = true;
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
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    #dedicatedServer.openFirewall = true;
  };

  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;
  hardware.ckb-next.enable = true;

  services.ratbagd.enable = true;
  services.power-profiles-daemon.enable = true;
  services.xserver.desktopManager.retroarch.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    "${Shadow_Booster.username}" = {
      isNormalUser = true;
      description = Shadow_Booster.description;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      #shell = pkgs.zsh;
      packages = with pkgs; [
        kdePackages.kdeconnect-kde
        #Coding
        kdePackages.kate # ide
        helix # text editor
        vscodium # ide
        #jetbrains.idea-community # ide
        jetbrains.idea-ultimate
        #jetbrains.pycharm-community
        jetbrains.pycharm-professional
        #jetbrains.rust-rover

        #rust plot
        pkg-config
        tor-browser
        lutris
        kdePackages.filelight
        #R
        #rstudio
        kdePackages.kdenlive

        #programming languages
        rustup # rust programming language
        #clang
        #llvmPackages.bintools
        jdk # java
        python3
        #kdePackages.plasma-browser-integration
        kdePackages.partitionmanager
        kdePackages.ksystemlog

        #Terminal
        fastfetch # system info
        starship # terminal theme
        zsh # shell
        oh-my-zsh # shell
        shellcheck

        #Gaming
        discord # chat
        steam # games
        #Minecraft
        prismlauncher # minecraft
        minecraft-server # minecraft server
        mcrcon # talking to minecraft
        airshipper

        #citra-nightly # 3ds simulator

        #Work
        libreoffice # office
        thunderbird # mail
        #teams

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
        #rpcs3
        #clamav
        piper
        nixfmt-rfc-style

        #Words
        hunspell
        hunspellDicts.nl_NL
        hunspellDicts.en_GB-ize
        hyphen
        mythes
        languagetool
        #bottles
      ];
    };
  };

  programs.nix-ld.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ckb-next
    xwayland
    git
  ];

  #minecraft-server config
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    openFirewall = true;
    whitelist = secrets.Minecraft-ServerSecrets.whitelist;
    serverProperties = secrets.Minecraft-ServerSecrets.serverProperties;
  };

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

  #environment.shells = with pkgs; [zsh];

  programs.zsh = {
    enable = false;
    shellAliases = {
      update = "sudo nixos-rebuild switch";
    };
    ohMyZsh = {
      enable = false;
    };
  };

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  system.autoUpgrade = {
    enable = true;
    #flake = inputs.self.outPath;
    #flags = [
    #  "--update-input"
    #  "nixpkgs"
    #  "-L" #prints logs
    #];
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

  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
