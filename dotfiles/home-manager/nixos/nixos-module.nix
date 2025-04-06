{ config, pkgs, ... }:
{
  imports = [
    ./../../modules/home-manager/hyprland/hyprland-setup.nix
  ];
}