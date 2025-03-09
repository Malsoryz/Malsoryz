{ config, lib, pkgs, ... }:

{
  android-integration.termux-setup-storage.enable = true;
  environment = {
    etcBackupExtension = ".bak";
    motd = ''
      GitHub: https://github.com/Malsoryz
    '';
    packages = with pkgs; [
      #editor
      vim
      nano
      
      #lib
      ncurses
      
      #search
      gnugrep
      diffutils
      findutils
      
      #utility
      which
      procps
      killall
      utillinux
      tzdata
      hostname
      
      #Document and help
      man
      
      #security
      gnupg
      
      #text manipulation
      gnused
      gnutar
      
      #compress
      bzip2
      gzip
      xz
      zip
      unzip
    ];
  };

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  home-manager = {
    useGlobalPkgs = true;
    config = ./home.nix;
  };
  
  user.shell = "${pkgs.zsh}/bin/zsh";
  terminal.font = "/data/data/com.termux.nix/files/home/.local/fonts/JetBrainsMonoNerdFont-Regular.ttf";
}
