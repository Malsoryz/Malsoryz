{ config, pkgs, ... }:
{
  home.username = "alternity";
  home.homeDirectory "/home/alternity";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    git
  ];

  programs.home-manager.enable = true;
}
