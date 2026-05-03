{ pkgs, config, ... }:
{
  home.packages = with pkgs.gnomeExtensions; [
    clipboard-indicator
    blur-my-shell
    emoji-copy
    launch-new-instance
    status-icons
    system-monitor
    caffeine
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
    gtk4.theme = config.gtk.theme;
  };

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "clipboard-indicator@tudmotu.com"
        "blur-my-shell@aunetx"
        "emoji-copy@felipeftn"
        "caffeine@patapon.info"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "status-icons@gnome-shell-extensions.gcampax.github.com"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
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
