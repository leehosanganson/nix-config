# Hyprland is a dynamic tiling Wayland compositor that is highly customizable and performant.
{ pkgs
, lib
, ...
}: {
  imports = [
    ./animations.nix
    ./keybindings.nix
  ];

  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6Packages.qt6ct
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.hyprland;

    extraConfig = ''
      $terminal = ghostty
      $fileManager = thunar
      $menu = wofi --show drun
      $reload_waybar = pkill waybar; waybar &
      $snip = snip
    '';

    settings = {
      exec-once = [
        "$terminal"
        "nm-applet"
        "waybar"
        "systemctl --user start hyprpolkitagent.service"
        "systemctl --user enable --now hyprpaper.service"
      ];

      monitor = [
        "HDMI-A-1,1920x1080@144,0x0,1"
        "DP-1,3440x1440@165,1920x1080,1"
        "DP-3,2560x1440@144,-2560x-200,1,transform,1"
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XCURSOR_THEME,Adwaita"
      ];

      cursor = {
        no_hardware_cursors = true;
      };

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 1;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      master = {
        new_status = true;
        allow_small_split = true;
        mfact = 0.5;
      };

      windowrule = [
        "suppress_event maximize, match:class:.*"
      ];

      misc = {
        vfr = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        repeat_rate = 35;
        repeat_delay = 200;
        touchpad.natural_scroll = false;
      };
    };
  };
}

