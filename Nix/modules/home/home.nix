{
  config,
  pkgs,
  inputs,
  ...
}:
let
  nixosConfigurationPath = "/home/alternity/dotfiles/Nix/nixos";
  homeConfigurationsPath = "/home/alternity/dotfiles/Nix/home-manager";

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  phps = inputs.nix-phps.packages.${pkgs.stdenv.hostPlatform.system};

  gremlin = inputs.uma-gremlin.packages.${pkgs.stdenv.hostPlatform.system}.default;

  phpPackages = inputs.fossar-phps.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alternity";
  home.homeDirectory = "/home/alternity";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
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

      # Icon Theme
      whitesur-icon-theme

      # formatter
      nixfmt

      # Uma Gremlins
      gremlin

      # GNOME Extensions
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.emoji-copy
      gnomeExtensions.auto-adwaita-colors
      gnomeExtensions.bluetooth-battery-meter
      gnomeExtensions.caffeine
      gnomeExtensions.category-sorted-app-grid
      gnomeExtensions.latency
      gnomeExtensions.internet-speed-meter
    ]
    ++ [ phpPackages ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "clipboard-indicator@tudmotu.com"
        "blur-my-shell@aunetx"
        "emoji-copy@felipeftn"
        "auto-adwaita-colors@cecidon"
        "bluetooth-battery-meter@maniacx.github.com"
        "caffeine@patapon.info"
        "category-sorted-app-grid@noobping.dev"
        "latency@mboscovich.github.io"
        "InternetSpeedMeter@alshakib.dev"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "${pkgs.kitty}/bin/kitty";
      binding = "<Primary><Alt>t";
    };

    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [
        "F10"
        "Print"
      ];
    };
  };

  home.shellAliases = {
    rebuild-system = "sudo nixos-rebuild switch --flake ${nixosConfigurationPath}#aru";
    rebuild-system-boot = "sudo nixos-rebuild boot --flake ${nixosConfigurationPath}#aru";
    rebuild-system-test = "sudo nixos-rebuild test --flake ${nixosConfigurationPath}#aru";

    rebuild-home = "home-manager switch --flake ${homeConfigurationsPath}#alternity";

    rebuild-all = "sudo nixos-rebuild switch --flake ${nixosConfigurationPath}#aru && home-manager switch --flake ${homeConfigurationsPath}#alternity";

    ls = "${pkgs.eza}/bin/eza --icons";
    ll = "${pkgs.eza}/bin/eza -lah --icons";
    cat = "${pkgs.bat}/bin/bat";
    pisan = "${pkgs.php84}/bin/php artisan";
    code = "${pkgs.antigravity}/bin/antigravity";
  };

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

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      shuffle
    ];

    enabledCustomApps = with spicePkgs.apps; [
      marketplace
      lyricsPlus
      newReleases
    ];
  };

  programs.fish = {
    enable = true;
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alternity/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
