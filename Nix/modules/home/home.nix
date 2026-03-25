{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # Change into current path
  configurationPath = "/home/alternity/dotfiles/Nix";

  uma-gremlin = inputs.uma-gremlin.packages.${pkgs.stdenv.hostPlatform.system}.default;
  phpPackages = inputs.fossar-phps.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  nixpkgs.config.allowUnfree = true;

  home.username = "alternity";
  home.homeDirectory = "/home/alternity";
  home.stateVersion = "25.11";
  home.packages =
    with pkgs;
    [
      antigravity

      openssl
      tree
      curl
      wget
      fastfetch
      unzip
      eza
      bat

      nodejs_24

      # formatter
      nixfmt

      # Uma Gremlins
      uma-gremlin
    ]
    ++ [ phpPackages ];

  home.shellAliases = {
    rebuild-system = "sudo nixos-rebuild switch --flake ${configurationPath}#aru";
    rebuild-system-boot = "sudo nixos-rebuild boot --flake ${configurationPath}#aru";
    rebuild-system-test = "sudo nixos-rebuild test --flake ${configurationPath}#aru";

    rebuild-home = "home-manager switch --flake ${configurationPath}#alternity";

    rebuild-all = "sudo nixos-rebuild switch --flake ${configurationPath}#aru && home-manager switch --flake ${configurationPath}#alternity";

    ls = "${pkgs.eza}/bin/eza --icons";
    ll = "${pkgs.eza}/bin/eza -lah --icons";
    cat = "${pkgs.bat}/bin/bat";
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
    matchBlocks."*" = {
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
    };
    matchBlocks = {
      "github.com" = {
        host = "github.com";
        user = "git";
        forwardAgent = true;
        identityFile = "~/.ssh/id_ed25519";
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

  programs.discord.enable = true;
  programs.bun.enable = true;
  programs.onlyoffice.enable = true;
  programs.home-manager.enable = true;
  programs.fish.enable = true;

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
