# Hyprland is a dynamic tiling Wayland compositor that is highly customizable and performant.
{ pkgs, config, lib, ... }: {
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

    settings = {
      "$terminal" = "ghostty";
      "$fileManager" = "ghostty -e yazi";
      "$menu" = "wofi --show drun --style $HOME/.config/wofi/styles.css";
      "$reload_waybar" = "$HOME/.config/waybar/scripts/reload.sh";
      "$snip" = "hyprshot --mode region";
      "$notification" = "swaync-client --toggle-panel";

      exec-once = [
        "fcitx5 -d"
        "nm-applet"
        "waybar"
        "systemctl --user start hyprpolkitagent.service"
        "systemctl --user enable --now hyprpaper.service"
        "[workspace 2 silent] zen"
      ];

      monitor = [
        "HDMI-A-1,1920x1080@144,1440x0,1"
        "DP-1,3440x1440@165,1440x1080,1"
        "DP-7,preferred,0x300,1,transform,1"
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_PICTURES_DIR,$HOME/pictures"
        "QT_QPA_PLATFORMTHEME,qt6ct"
      ];

      general = {
        gaps_in = config.theme.gaps-in;
        gaps_out = config.theme.gaps-out;
        border_size = config.theme.border-size;
        "col.active_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base0D}ff) rgba(${config.lib.stylix.colors.base0E}ff) 45deg";
        "col.inactive_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base02}aa)";
        resize_on_border = false;
        allow_tearing = true;
        layout = "dwindle";
      };

      decoration = {
        rounding = config.theme.rounding;
        active_opacity = config.theme.active-opacity;
        inactive_opacity = config.theme.inactive-opacity;

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          noise = 0.0117;
          xray = false;
          special = true;
          vibrancy = 0.1696;
        };

        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          color = lib.mkForce "rgba(${config.lib.stylix.colors.base00}cc)";
          color_inactive = lib.mkForce "rgba(${config.lib.stylix.colors.base01}66)";
        };
      };

      master = {
        new_status = true;
        allow_small_split = true;
        mfact = 0.5;
      };

      windowrule = [
        "suppress_event maximize, match:class .*"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        force_no_accel = true;
        repeat_rate = 35;
        repeat_delay = 200;
        touchpad.natural_scroll = false;
      };
    };
  };
}
