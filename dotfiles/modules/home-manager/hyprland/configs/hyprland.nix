{ config, pkgs, ... }:
let
  terminal = "${pkgs.kitty}/bin/kitty";
  fileManager = "${pkgs.kitty}/bin/kitty -e ${pkgs.yazi}/bin/yazi";
  menu = "${pkgs.rofi-wayland}/bin/rofi -show drun -p \"App Menu\"";
  powermenu = (import ./../../../../scripts/power-menu.nix { inherit pkgs; });
  lockScreen = "${pkgs.hyprlock}/bin/hyprlock";
  wakeUp = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
  screenShot = "${pkgs.grimblast}/bin/grimblast save output ~/Pictures/ScreenShot/$(${pkgs.coreutils}/bin/date \"+%H%M%S_%d%m%Y\").png";
  # Key
  mainMod = "SUPER";
  mod = "ALT";
in
{
  wayland.windowManager.hyprland.settings = {
    monitor = ",preferred,auto,auto";
    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
    ];
    exec-once = [
      "${pkgs.waybar}/bin/waybar & ${pkgs.hyprpaper}/bin/hyprpaper"
    ];
    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgba(36b5ceee) rgba(b118cdee) 45deg";
      "col.inactive_border" = "rgba(1d3f46aa)";
      resize_on_border = false;
      allow_tearing = false;
      layout = "dwindle";
    };
    decoration = {
      rounding = 10;
      rounding_power = 2;

      active_opacity = 1.0;
      inactive_opacity = 1.0;

      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };

      blur = {
        enabled = true;
        size = 3;
        passes = 1;

        vibrancy = 0.1696;
      };
    };
    animations = {
      enabled = "yes, please :)";
      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0.05,0.36,1"
        "linear,0,0,1,1"
        "almostLinear,0.5,0.5,0.75,1.0"
        "quick,0.15,0,0.1,1"
      ];
      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 1, 1.94, almostLinear, fade"
        "workspacesIn, 1, 1.21, almostLinear, fade"
        "workspacesOut, 1, 1.94, almostLinear, fade"
      ];
    };
    dwindle = {
      pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = true; # You probably want this
    };
    master = {
      new_status = "master";
    };
    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc = {
      force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
    };
    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model = "";
      kb_options = "";
      kb_rules = "";

      follow_mouse = 1;

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
        natural_scroll = false;
      };
    };
    gestures = {
        workspace_swipe = false;
    };

    # Example per-device config
    # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
    device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
    };

    # KeyBindings
    # See https://wiki.hyprland.org/Configuring/Keywords/
    # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    bind = [
      "${mainMod}, Q, exec, ${terminal}"
      "${mainMod}, C, killactive,"
      "${mainMod}, Delete, exec, ${powermenu}/bin/power-menu"
      "${mainMod}, L, exec, ${lockScreen}"
      "${mainMod}, Escape, exec, ${wakeUp}"
      "${mainMod}, E, exec, ${fileManager}"
      "${mod}, P, exec, ${screenShot}"
      "${mainMod}, S, exec, ${menu}"
      "${mainMod}, V, togglefloating,"
      "${mainMod}, P, pseudo," # dwindle
      "${mainMod}, J, togglesplit," # dwindle

      # Move focus with mainMod + arrow keys
      "${mainMod}, left, movefocus, l"
      "${mainMod}, right, movefocus, r"
      "${mainMod}, up, movefocus, u"
      "${mainMod}, down, movefocus, d"

      # Switch workspaces with mainMod + [0-9]
      "${mainMod}, 1, workspace, 1"
      "${mainMod}, 2, workspace, 2"
      "${mainMod}, 3, workspace, 3"
      "${mainMod}, 4, workspace, 4"
      "${mainMod}, 5, workspace, 5"
      "${mainMod}, 6, workspace, 6"
      "${mainMod}, 7, workspace, 7"
      "${mainMod}, 8, workspace, 8"
      "${mainMod}, 9, workspace, 9"
      "${mainMod}, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "${mainMod} SHIFT, 1, movetoworkspace, 1"
      "${mainMod} SHIFT, 2, movetoworkspace, 2"
      "${mainMod} SHIFT, 3, movetoworkspace, 3"
      "${mainMod} SHIFT, 4, movetoworkspace, 4"
      "${mainMod} SHIFT, 5, movetoworkspace, 5"
      "${mainMod} SHIFT, 6, movetoworkspace, 6"
      "${mainMod} SHIFT, 7, movetoworkspace, 7"
      "${mainMod} SHIFT, 8, movetoworkspace, 8"
      "${mainMod} SHIFT, 9, movetoworkspace, 9"
      "${mainMod} SHIFT, 0, movetoworkspace, 10"

      # Example special workspace (scratchpad)
      "${mainMod}, S, togglespecialworkspace, magic"
      "${mainMod} SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      "${mainMod}, mouse_down, workspace, e+1"
      "${mainMod}, mouse_up, workspace, e-1"
      "${mod}, right, workspace, e+1"
      "${mod}, left, workspace, e-1"
    ];
    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = [
      "${mainMod}, mouse:272, movewindow"
      "${mainMod}, mouse:273, resizewindow"
    ];
    bindel = [
      # Laptop multimedia keys for volume and LCD brightness
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
      ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
    ];
    # Requires playerctl
    bindl = [
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    # Window and Workspaces
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
    windowrulev2 = [
      # Ignore maximize requests from apps. You'll probably like this.
      "suppressevent maximize, class:.*"

      # Fix some dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
    ];
  };
}