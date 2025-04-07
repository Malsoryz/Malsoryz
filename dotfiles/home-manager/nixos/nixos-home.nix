{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  imports = [
    ./nixos-module.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  home = {
    username = "eternity";
    homeDirectory = "/home/eternity";
    stateVersion = "24.11"; # Please read the comment before changing.
  };

  home.packages = with pkgs; [
    # imported script or package
    (import ./../../scripts/motd.nix { inherit pkgs; })

    # Other Packages
    openssh
    lolcat
    tree
    mycli
    curl
    wget
    conceal
    fzf
    fastfetch
    fortune
    unzip
    busybox
    grimblast

    #fonts
    nerd-fonts.jetbrains-mono

    # Programming
    openjdk
    php84

    # Mesa
#    mesa-demos
#    steam-run

    # Package Manager
    php84Packages.composer
    nodejs_23
  ];
  
  home.shellAliases = {
    # list file or directory
    ls = "eza";
    la = "ls -a";
    lh = "ls -lh";
    lha = "ls -lha";

    imgview = "feh";
    filemanager = "yazi";
    
    # trash manager
    trash = "conceal";
    rm = "cnc";

    # Minecraft
    tlauncher = "steam-run java -Dsun.java2d.opengl=true -jar ~/Downloads/TLauncher.jar";
  };

  home.file = {
    "git/README.md" = {
      text = ''
        # Git
        ID: Di sinilah titik tempat kumpulan repositori git berada.
        EN: This is the point where the collection of git repositories is located.
      '';
    };
  };

  home.sessionVariables = {};

  programs = {
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      settings = {
        background_opacity = 0.75;
      };
    };

    yazi = {
      enable = true;
      package = pkgs.yazi;
      enableZshIntegration = true;
    };

    feh = {
      enable = true;
      package = pkgs.feh;
      themes = {
        feh = [
          "--image-bg"
          "black"
        ];
      };
    };

    git = {
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

    ssh = {
      enable = true;
      matchBlocks.github = {
        host = "github.com";
        user = "git";
        forwardAgent = true;
        identityFile = [
          "~/.ssh/id_ed25519"
        ];
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        my-motd
      '';
      history.size = 10000;
    };

    eza = {
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
    
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  programs.home-manager.enable = true;
}
