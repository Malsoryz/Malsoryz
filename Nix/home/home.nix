{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  # Change into current path
  configurationPath = "/home/alternity/dotfiles/Nix";

  # uma-gremlin = inputs.uma-gremlin.packages.${pkgs.stdenv.hostPlatform.system}.default;
  phpPackages = inputs.fossar-phps.packages.${pkgs.stdenv.hostPlatform.system}.default;

  unstablePkgs = import inputs.nixpkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
    };
  };
in
{
  nixpkgs.config.allowUnfree = true;

  home.username = "alternity";
  home.homeDirectory = "/home/alternity";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    antigravity
    qbittorrent

    openssl
    tree
    curl
    wget
    fastfetch
    unzip
    eza
    bat

    nodejs_24

    # n8n

    (python3.withPackages (
      ppkgs: with ppkgs; [
        pip
        numpy
        pandas
        matplotlib
        scikit-learn
        pygobject3
        pycairo
      ]
    ))

    uv

    gtk3
    gobject-introspection

    # formatter
    nixfmt

    # Uma Gremlins
    # uma-gremlin

    php84
    php84Packages.composer
  ];
  # ++ [ unstablePkgs.graphify ];
  # ++ [ phpPackages ];

  home.shellAliases = {
    rebuild-system = "sudo nixos-rebuild switch --flake ${configurationPath}#aru";
    rebuild-system-boot = "sudo nixos-rebuild boot --flake ${configurationPath}#aru";
    rebuild-system-test = "sudo nixos-rebuild test --flake ${configurationPath}#aru";

    rebuild-home = "home-manager switch --flake ${configurationPath}#alternity";

    rebuild-all = "sudo nixos-rebuild switch --flake ${configurationPath}#aru && home-manager switch --flake ${configurationPath}#alternity";

    ls = "${pkgs.eza}/bin/eza --icons";
    ll = "${pkgs.eza}/bin/eza -lah --icons";
    # cat = "${pkgs.bat}/bin/bat";
    pisan = "${pkgs.php84}/bin/php artisan";
    code = "${pkgs.antigravity}/bin/antigravity";
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.antigravity}/bin/antigravity";
    NIX_CONFIG_PATH = configurationPath;
  };

  # Programs --------------------------------------------- #

  programs.git = {
    enable = true;
    settings = {
      user.name = "Malsoryz";
      user.email = "ikmalalansory@gmail.com";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
      };
      "github.com" = {
        User = "git";
        ForwardAgent = true;
        IdentityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    settings = {
      background_opacity = "0.75";
      window_padding_width = 12;
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
  };

  programs.discord = {
    enable = true;
    package = unstablePkgs.discord;
  };

  programs.bun = {
    enable = true;
    package = unstablePkgs.bun;
  };

  programs.opencode = {
    enable = true;
    package = unstablePkgs.opencode;
  };

  programs.onlyoffice.enable = true;
  programs.home-manager.enable = true;
  programs.fish = {
    enable = true;
    shellInit = ''
      fish_add_path $HOME/.local/bin
    '';
  };

  # Catppuccin Theme --------------------------------------- #

  catppuccin.kitty = {
    enable = true;
    flavor = "mocha";
  };

  catppuccin.starship = {
    enable = true;
    flavor = "mocha";
  };

  catppuccin.firefox = {
    enable = true;
    flavor = "mocha";
  };
}
