{
  description = "Alternity custom packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };

      alt-assets = pkgs.callPackage ./assets/default.nix { };
      alt-assets-path = "${alt-assets}/share/alt-assets";
    in
    {
      packages.${system} = {
        inherit alt-assets;
        default = alt-assets;
      };

      alt-assets = {
        wallpapers = {
          "francesco-ungaro" = "${alt-assets-path}/wallpapers/francesco-ungaro.jpg";
        };
      };
    };
}
