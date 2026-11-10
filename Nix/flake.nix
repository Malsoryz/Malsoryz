{
  description = "Main flake for nixos and home-manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    # Packages
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    altpkgs = {
      url = "path:./packages";
      inputs.nixpkgs.follows = "nixpkgs-stable";
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
          ./system/configuration.nix
          inputs.chaotic.nixosModules.default

          (inputs.import-tree.filter (
            path: !inputs.nixpkgs.lib.hasSuffix ".ignore.nix" path
          ) ./system/modules)
        ];
      };

      flake.homeConfigurations."alternity" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs-stable.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home/home.nix

          inputs.spicetify-nix.homeManagerModules.default
          inputs.catppuccin.homeModules.catppuccin
          (inputs.import-tree.filter (path: !inputs.nixpkgs.lib.hasSuffix ".ignore.nix" path) ./home/modules)
        ];
      };
    };
}
