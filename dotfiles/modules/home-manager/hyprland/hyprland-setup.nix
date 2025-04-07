{ config, pkgs, ... }:
let
  hyprpaperWallpaper = "~/git/Malsoryz/assets/background/cyberpunk-main-background.jpg";
in
{
  imports = [
    ./configs/hyprland.nix # Hyprland Config
    ./configs/waybar.nix # WayBar Config
    ./configs/hyprlock.nix # Hyprlock Config
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
  };
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    style = builtins.readFile ./styles/waybar.css;
  };
  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
  };

  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;
    settings = {
      general = {
        lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      };
      listener = [
        {
          timeout = 150;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 0%";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on && ${pkgs.hyprlock}/bin/hyprlock";
        }
      ];
    };
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [
        "${hyprpaperWallpaper}"
      ];
      wallpaper = [
        "eDP-1,${hyprpaperWallpaper}"
      ];
    };
  };
}