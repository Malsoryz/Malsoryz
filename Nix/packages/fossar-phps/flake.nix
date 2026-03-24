{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-phps = {
      url = "github:fossar/nix-phps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-phps,
      ...
    }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          mkPhpAll = ver: pkg: [
            (pkgs.writeShellScriptBin "php${ver}" ''exec ${pkg}/bin/php "$@"'')
            (pkgs.writeShellScriptBin "php-fpm${ver}" ''exec ${pkg}/sbin/php-fpm "$@"'')
            (pkgs.writeShellScriptBin "php-cgi${ver}" ''exec ${pkg}/bin/php-cgi "$@"'')
            (pkgs.writeShellScriptBin "phpdbg${ver}" ''exec ${pkg}/bin/phpdbg "$@"'')
            (pkgs.writeShellScriptBin "phar${ver}" ''exec ${pkg}/bin/phar "$@"'')
          ];

          allPhps =
            (mkPhpAll "81" nix-phps.packages.${system}.php81)
            ++ (mkPhpAll "82" nix-phps.packages.${system}.php82)
            ++ (mkPhpAll "83" nix-phps.packages.${system}.php83)
            ++ [ nix-phps.packages.${system}.php84 ];
        in
        {
          default = pkgs.symlinkJoin {
            name = "phps";
            paths = allPhps;
          };
        }
      );
    };
}
