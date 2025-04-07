{ config, pkgs, ... }:
{
  programs.hyprlock.settings = {
    general = {
      hide_cursor = true; # Hide the cursor
    };
    label = {
      text = "I Use NixOS BTW";
      text_align = "center";
      font_family = "JetBrainsMono Nerd Font";
      valign = "center";
      halign = "center";
      zindex = 1;
    };
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
      zindex = 0;
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
      inner_color = "rgba(6, 14, 15, 1)";
      font_color = "rgba(120, 233, 255, 1)";
      check_color = "rgba(80, 158, 173, 1)";
      fail_color = "rgba(199, 0, 20, 1)";
      rounding = 10;
      zindex = 2;
    };
  };
}