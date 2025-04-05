{ pkgs, ... }:
let
  brand = builtins.readFile ./../etc/eternity.txt;
  github = "https://github.com/Malsoryz";
  date = "$(date '+%A %d %B %Y %T')";
  host = "$(whoami)@$(hostname)";
in
pkgs.writeShellScriptBin "my-motd" ''
  #! /usr/bin/env nix-shell
  #! nix-shell -i bash -p coreutils hostname lolcat

  (echo "${brand}";
  echo " GitHub : ${github}";
  echo " Date   : ${date}";
  echo " Host   : ${host}";
  ) | lolcat;
''