{ pkgs, ... }:
{
  gtk = {
    enable = true;
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "clipboard-indicator@tudmotu.com"
        "blur-my-shell@aunetx"
        "emoji-copy@felipeftn"
        "auto-adwaita-colors@cecidon"
        "bluetooth-battery-meter@maniacx.github.com"
        "caffeine@patapon.info"
        "category-sorted-app-grid@noobping.dev"
        "latency@mboscovich.github.io"
        "InternetSpeedMeter@alshakib.dev"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "${pkgs.kitty}/bin/kitty";
      binding = "<Primary><Alt>t";
    };

    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [
        "F10"
        "Print"
      ];
    };
  };
}
