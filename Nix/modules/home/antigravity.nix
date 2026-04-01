{ pkgs, ... }:
let
  jsonFmt = pkgs.formats.json { };
in
{
  # Antigravity Settings
  home.file = {
    # Main User Settings
    ".config/Antigravity/User/settings.json".source = (
      jsonFmt.generate "settings.json" {
        "workbench.sideBar.location" = "right";
        "workbench.colorTheme" = "Catppuccin Mocha";
        "json.schemaDownload.enable" = true;
        "editor.fontFamily" = "JetBrainsMono Nerd Font, monospace";
        "editor.minimap.renderCharacters" = false;
      }
    );

    # Main User Extensions
    ".config/Antigravity/User/extensions.json".source = (
      jsonFmt.generate "extensions.json" {
        "recommendations" = [
          "laravel.vscode-laravel"
          "bradlc.vscode-tailwindcss"
          "bmewburn.vscode-intelephense-client"
        ];
      }
    );
  };
}
