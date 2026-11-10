{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  altwalls = inputs.altpkgs.alt-assets.wallpapers;
in
{
  boot.loader.limine = {
    enable = lib.mkDefault false;
    enableEditor = lib.mkDefault true;

    style = {
      wallpapers = [ altwalls.francesco-ungaro ];
      graphicalTerminal = {
        margin = 0;
      };
    };
  };
}
