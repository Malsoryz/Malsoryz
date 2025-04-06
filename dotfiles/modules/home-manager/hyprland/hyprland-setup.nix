{ config, pkgs, ... }:
let
  hyprpaperWallpaper = "~/git/Malsoryz/assets/background/cyberpunk-main-background.jpg";
in
{
  imports = [
    ./configs/hyprland.nix # Hyprland Config
    ./configs/waybar.nix # WayBar Config
  ];

  xdg.configFile = {
    # "waybar/config.jsonc".source = ./waybar/config.jsonc;
    "waybar/style.css".source = ./waybar/style.css;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
  };
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };

  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
    settings = {
      background = {
        path = "screenshot";
        color = "rgba(20, 20, 20, 0.3)";   # semi transparan
        blur_passes = 2;
        blur_size = 7;
        noise = 0.015;
        contrast = 0.9;
        brightness = 0.8;
        vibrancy = 0.18;
        vibrancy_darkness = 0.1;
      };
      input-field = {
        halign = "center";
        valign = "center";
        placeholder_text = "Insert Password";
        fail_text = "$FAIL ($ATTEMPTS)";
        font_family = "JetBrainsMono Nerd Font";
        dots_size = 0.1;
        dots_spacing = 0.15;
        dots_center = true;
        dots_rounding = -1;
        outline_thickness = 2;
        outer_color = "rgba(54, 181, 206, 1)";
        inner_color = "rgba(29, 63, 70, 0.25)";
        font_color = "rgba(120, 233, 255, 1)";
        check_color = "rgba(80, 158, 173, 1)";
        fail_color = "rgba(199, 0, 20, 1)";
        rounding = 10;
      };
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