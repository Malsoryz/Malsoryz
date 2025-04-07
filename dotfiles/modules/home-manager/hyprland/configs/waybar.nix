{ config, pkgs, ... }:
{
  programs.waybar.settings = {
    mainBar = {
      height = 30;
      spacing = 4;

      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "backlight"
        "network"
        "battery"
      ];

      # Modules
      "clock" = {
        format = "{:%H:%M}";
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "{:%A %d %B %T}";
      };
      "battery" = {
        states = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
        };
        format = "{capacity}% {icon}";
        format-full = "{capacity}% {icon}";
        format-charging = "{capacity}% {icon} ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        # format-good = ""; // An empty format will hide the module
        # format-full = "";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
        interval = 3;
      };
      "network" = {
        # "interface": "wlp2*", // (Optional) To force the use of this interface
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };
      "backlight" = {
        format = "{percent}% {icon}";
        format-icons = [ "" ];
      };

      # Hyprland Modules
      "hyprland/workspaces" = {
        active-only = true;
        disable-scroll = true;
        sort-by-number = true;
        warp-on-scroll = true;
        on-click = "activate";
        persistent-workspaces = {
            "*" = 5;
        };
      };
      "hyprland/window" = {
        format = "{initialTitle}";
      };
    };
  };
}