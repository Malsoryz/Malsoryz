{
  description = "Main flake for nixos and home-manager configurations";

  inputs = {
    # Main
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:vic/import-tree";

    # Packages
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-phps = {
      url = "github:fossar/nix-phps";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    fossar-phps = {
      url = "path:./modules/flakes/fossar-phps";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.nix-phps.follows = "nix-phps";
    };

    desktop-gremlin = {
      url = "github:iluvgirlswithglasses/linux-desktop-gremlin";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    uma-gremlin = {
      url = "path:./modules/flakes/uma-gremlin";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.desktop-gremlin.follows = "desktop-gremlin";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake.nixosConfigurations."aru" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          (inputs.import-tree ./modules/nixos)
        ];
      };

      flake.homeConfigurations."alternity" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          (inputs.import-tree ./modules/home)
          inputs.spicetify-nix.homeManagerModules.default
          inputs.catppuccin.homeModules.catppuccin
        ];
      };

      flake.templates = {
        laravel = {
          path = ./modules/templates/laravel;
          description = "Laravel development flake template";
        };
      };
    };
}
