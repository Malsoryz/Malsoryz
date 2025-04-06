{ pkgs, ... }:
let
  options = ''
    Lock Screen
    Shutdown
    Reboot
    Suspend
    Close Hyprland
  '';
in
pkgs.writeShellScriptBin "power-menu" ''
  #! /usr/bin/env nix-shell
  #! nix-shell -i bash -p rofi-wayland

  option="${options}"
  menu=$(printf "%s" "$option" | rofi -dmenu -p "Power Menu")

  case "$menu" in
    "Lock Screen")
      hyprlock
      ;;
    "Shutdown")
      systemctl poweroff
      ;;
    "Reboot")
      systemctl reboot
      ;;
    "Suspend")
      systemctl suspend
      hyprlock
      ;;
    "Close Hyprland")
      hyprctl dispatch exit
      ;;
    *)
      echo "Nothing Selected"
      ;;
  esac
''