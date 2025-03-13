{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  home = {
    username = "eternity";
    homeDirectory = "/home/eternity";
    stateVersion = "24.11"; # Please read the comment before changing.
    packages = with pkgs; [
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

      #fonts
      nerd-fonts.jetbrains-mono

      # Desktop App
      vscode
      google-chrome
      netbeans
      android-studio

      # Programming
      jdk_headless
      jre_headless
      php84

      # Package Manager
      php84Packages.composer
      nodejs_23
    ];
    shellAliases = {
      # list file or directory
      ls = "eza";
      la = "ls -a";
      lh = "ls -lh";
      lha = "ls -lha";
      
      # trash manager
      trash = "conceal";
      rm = "cnc";
    };
    file = {
      "~/.local/share/fonts/jetbrains-mono".source = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono";
    };
    sessionVariables = {
      MOTD = "$HOME/Public/git/Malsoryz/assets/motd/motd.sh";
    };
  };

  programs = {
    home-manager.enable = true;
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
        sh $MOTD;
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

}
