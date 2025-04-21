{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  home = {
    username = "aru"; # Change this when you in another username
    homeDirectory = "/home/aru"; # Change this based on your username
    stateVersion = "25.05"; # Please read the comment before changing.
  };

  home.packages = with pkgs; [
    # Other Packages
    curl
    wget
    unzip
    nvtopPackages.amd # GPU & CPU monitoring
    fastfetch # System info
    steam-run # For Running Script or App in steam-deck Filesystem

    # Desktop App
    google-chrome
    android-studio
    libreoffice

    # Programming
    openjdk
    php84
    php84Packages.composer
    nodejs_23
  ];

  home.shellAliases = {
    hm-switch = "home-manager switch";

    # list file or directory
    ls = "${pkgs.eza}/bin/eza";
    la = "${pkgs.eza}/bin/eza -a";
    lh = "${pkgs.eza}/bin/eza -lh";
    lha = "${pkgs.eza}/bin/eza -lha";

    # trash manager
    trash = "${pkgs.conceal}/bin/conceal";
    rm = "${pkgs.conceal}/bin/cnc";

    #Minecraft
    tlauncher = "steam-run java -Dsun.java2d.opengl=true -jar ~/Collections/jar/TLauncher.jar";
  };

  home.file = {};

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.vscode.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
  };

  programs.git = {
    enable = true;
    userName  = "Malsoryz";
    userEmail = "ikmalalansory@gmail.com";
    delta.enable = true;
    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      core = {
        fileMode = true;
        pager = "${pkgs.delta}/bin/delta";
      };
      delta = {
        line-numbers = true;
        side-by-side = false;
      };
      interactive = {
        diffFilter = "${pkgs.delta}/bin/delta --color-only";
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        host = "github.com";
        user = "git";
        forwardAgent = true;
        identityFile = [
          "~/.ssh/id_ed25519"
        ];
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    #initExtra = ''
    #  ${motd}/bin/my-motd
    #'';
    history.size = 10000;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "always";
    colors = "auto";
    extraOptions = [
      "--group-directories-first"
      "--bytes"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.home-manager.enable = true;
}
