# Delete .ignore at the file name to activate this options
# but only when nix-craftapps flake were exists in flake.nix
# Read at https://github.com/olafkfreund/nix-craftapps to understand more about options

{ ... }:
{
  programs.craftapps = {
    enable = true;

    apps = {
      pdfcraft.enable = true;
      wordcraft.enable = true;
    };
  };
}
