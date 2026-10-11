# Alternity - My Nixos Configurations
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # Allow unfree packages
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        openldap = inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}.openldap;
      })
    ];
  };

  # Enabling experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alternity = {
    isNormalUser = true;
    description = "Alternity";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "nginx"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Booting Options
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos; # Kernel
    initrd.kernelModules = [ "amdgpu" ];

    # loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Bootloader
    loader.limine = {
      enable = true;
      maxGenerations = 10;
      extraEntries = ''
        /Windows
          protocol: efi
          path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };

    # Plymouth / loading screen
    plymouth = {
      enable = true;
      theme = "hexagon_dots";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "hexagon_dots" ];
        })
      ];
    };

    supportedFilesystems = {
      ntfs = true;
      btrfs = true;
      exfat = true;
    };

    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];
  };

  # Networking

  networking = {
    hostName = "aru"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    hosts = { };

    # Open ports in the firewall.
    firewall = {
      trustedInterfaces = [ "docker0" ];
      allowedTCPPorts = [
        8000
        3000
        80
        443

        11434
      ];
    };

    # Enable networking
    networkmanager.enable = true;
    networkmanager.wifi.powersave = false;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Set your time zone.
  time.timeZone = "Asia/Makassar";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    storageDriver = "overlay2";

    daemon.settings = {
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      log-driver = "journald";
    };
  };

  # Services block
  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };

      # Enable touchpad support (enabled default in most desktopManager).
      # libinput.enable = true;
    };

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        splix
      ];
    };
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Programs block
  programs = {
    # file sharing app
    localsend = {
      enable = true;
      openFirewall = true;
    };

    nix-ld.enable = true;
    fish.enable = true; # Fish Shell

    firefox.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    docker-compose
    ctop

    linuxConsoleTools
    jstest-gtk
    antimicrox
    evtest

    gparted
    snapshot

    ntfs3g

    steam-run

    mangohud
    protonup-qt
    gamemode
    lutris
    protonplus

    koboldcpp
  ];

  # Environment Variables
  environment.variables = {
    SDL_GAMECONTROLLERCONFIG = "03000000790000000600000010010000,DragonRise Generic,a:b0,b:b1,x:b2,y:b3,back:b8,start:b9,guide:b10,leftstick:b11,rightstick:b12,leftshoulder:b4,rightshoulder:b5,dpup:h0.1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,leftx:a0,lefty:a1,rightx:a2,righty:a3";
  };

  fonts.packages = with pkgs; [
    corefonts
  ];

  # Temporary Files
  systemd.tmpfiles.rules =
    let
      # Creating new monitors.xml file based on .config/monitors.xml in user configuration
      monitorsXml = pkgs.writeText "monitors.xml" ''
        <monitors version="2">
          <configuration>
            <layoutmode>logical</layoutmode>
            <logicalmonitor>
              <x>0</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>eDP-1</connector>
                  <vendor>INX</vendor>
                  <product>0x0000</product>
                  <serial>0x00000000</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1200</height>
                  <rate>60.002</rate>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
        </monitors>
      '';
    in
    [
      "d /etc/xdg 0755 root root -"
      "L+ /etc/xdg/monitors.xml - - - - ${monitorsXml}"
    ];

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

  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
