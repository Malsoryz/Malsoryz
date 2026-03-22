{
  description = "Home Manager configuration of alternity";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    desktop-gremlin = {
      url = "github:iluvgirlswithglasses/linux-desktop-gremlin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-phps = {
      url = "github:fossar/nix-phps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      spicetify-nix,
      desktop-gremlin,
      catppuccin,
      nix-phps,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      gremlin = import ./modules/flake/uma-gremlin.nix { inherit pkgs desktop-gremlin system; };

      phpPackages = import ./modules/flake/phps.nix { inherit pkgs nix-phps system; };
    in
    {
      homeConfigurations."alternity" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
          spicetify-nix.homeManagerModules.default
          catppuccin.homeModules.catppuccin
        ];

        extraSpecialArgs = { inherit spicetify-nix gremlin phpPackages; };
      };
    };
}
