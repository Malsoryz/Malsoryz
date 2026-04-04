{ pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      steam-run
      mangohud
      protonup-qt
      gamemode
      lutris
    ]
    ++ (with pkgs-unstable; [
      protonplus
    ]);
}
