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
    in
    {
      packages.${system} = {
        default = {
          cosmic-boards = pkgs.callPackage ./cosmic-boards/package.nix { };
        };
      };
    };
}
