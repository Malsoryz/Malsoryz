{
  description = "Flake for laravel development with php versions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devshell.flakeModule
      ];

      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, ... }:
        {
          devshells.default = {
            packages = with pkgs; [
              php84
              php84Packages.composer
              nodejs_24
              bun
            ];

            devshell.motd = ''
              {bold}
              |-----------------------------------------|
              | Laravel Development Shell - PHP 8.4     |
              | Run 'menu' to see available commands    |
              |-----------------------------------------|
            '';
          };

          devshells.php84 = {
            packages = with pkgs; [
              php84
              php84Packages.composer
              nodejs_24
              bun
            ];

            devshell.motd = ''
              {bold}
              |-----------------------------------------|
              | Laravel Development Shell - PHP 8.4     |
              | Run 'menu' to see available commands    |
              |-----------------------------------------|
            '';
          };

          devshells.php83 = {
            packages = with pkgs; [
              php83
              php83Packages.composer
              nodejs_24
              bun
            ];

            devshell.motd = ''
              {bold}
              |-----------------------------------------|
              | Laravel Development Shell - PHP 8.3     |
              | Run 'menu' to see available commands    |
              |-----------------------------------------|
            '';
          };

          devshells.php82 = {
            packages = with pkgs; [
              php82
              php82Packages.composer
              nodejs_24
              bun
            ];

            devshell.motd = ''
              {bold}
              |-----------------------------------------|
              | Laravel Development Shell - PHP 8.2     |
              | Run 'menu' to see available commands    |
              |-----------------------------------------|
            '';
          };
        };
    };
}
