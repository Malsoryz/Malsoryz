{ config, lib, pkgs, ... }:
{
  home = {
    sessionVariables = {
      PATH = "$HOME/.nix-profile/bin:/data/data/com.termux.nix/files/usr/bin:$HOME/.config/composer/vendor/bin";
      MOTD = "$HOME/.motd/motd.sh";
    };
    file = {
      "git/README.md" = {
        text = ''
          # Git
          ID: Di sinilah titik tempat kumpulan repositori git berada.
          EN: This is the point where the collection of git repositories is located.
        '';
      };
      ".motd/" = {
        source = ~/git/Malsoryz/assets/motd;
        recursive = true;
      };
    };
    # Read the changelog before changing this value
    stateVersion = "24.05";
    packages = with pkgs; [ 
      openssh
      lolcat
      tree
      mycli
      zoxide
      curl
      wget
      conceal
      fzf
      fastfetch
      fortune
      file
      
      #fonts
      nerd-fonts.jetbrains-mono
      
      #programing language
      php84
      mysql84
      
      #package manager
      php84Packages.composer
      nodejs_23
    ];
    shellAliases = {
      ls = "eza";
      la = "ls -a";
      lh = "ls -lh";
      lha = "ls -lha";
      
      #trash manager
      trash = "conceal";
      rm = "cnc";
      
      #formated date
      date-ymd = "date +%F";
      date-hour = "date +%T";
      date-yh = "date '+%F %T'";
      
      #mysql server
      mysql-server-start = "mysqld --datadir=$HOME/Programs/mysql/data --socket=$HOME/Programs/mysql/run/mysqld.sock --bind-address=127.0.0.1 &";
      mysql-server-stop = "mysqladmin -u root --socket=$HOME/Programs/mysql/run/mysqld.sock shutdown";
      mysql-server-status = "mysqladmin -u root --socket=$HOME/Programs/mysql/run/mysqld.sock status";
      mysql-server-pid = "pgrep mysqld";
      mycli = "mycli --myclirc ~/Programs/mycli/myclirc";
      sql = "mycli -u root --host=127.0.0.1 --port=3306";
    };
  };

  # insert home-manager config
  programs = {
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
          "~/.ssh/id_rsa"
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
        clear;
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