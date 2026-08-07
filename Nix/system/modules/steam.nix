{ pkgs, inputs, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    steam-run
    mangohud
    protonup-qt
    gamemode
    lutris
    protonplus
  ];

  # Controller

  hardware.uinput.enable = true;
  
}
