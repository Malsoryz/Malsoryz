{ pkgs, ... }:
let
  options = ''
    Lock Screen
    Shutdown
    Reboot
    Sleep
    Suspend
    Login Screen
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
    "Sleep")
      hyprctl dispatch dpms off
      ;;
    "Suspend")
      systemctl suspend
      hyprlock
      ;;
    "Login Screen")
      hyprctl dispatch exit
      ;;
    *)
      echo "Nothing Selected"
      ;;
  esac
''