{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;

    settings = {
      monitor = [ "," "$default_monitor" ];
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        col.active_border = "rgba(33ccffee)";
        col.inactive_border = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 12;
        blur = {
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        col.shadow = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "winClose, 0.5, 0.2, 1, 0.5"
        ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = false;
        sensitivity = 0;
      };

      # Keybinds - Super as $mainMod
      "$mainMod" = "SUPER";

      bind = [
        # Launchers
        "$mainMod, T, exec, ghostty"
        "$mainMod, E, exec, thunar"
        "$mainMod, R, exec, wofi --show drun"
        "$mainMod, Q, killactive"

        # Windows
        "$mainMod, C, exit"
        "$mainMod, F, fullscreen"
        "$mainMod, V, togglefloating"
        "$mainMod, P, pseudo"

        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move to workspaces
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Layout
        "$mainMod, G, layoutmsg, swapnext"
        "$mainMod SHIFT, R, layoutmsg, swapwithactive"

        # Screenshots
        "$mainMod SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"
      ];

      bindm = [
        # Mouse moves
        "$mainMod mouse:272, movewindow"
        "$mainMod mouse:273, resizewindow"
      ];

      exec-once = [
        "swww init" # && swww img /path/to/wallpaper.jpg" # Set your wallpaper
        "waybar"
        "mako"
      ];
    };
  };

  home.packages = with pkgs; [
    waybar
    swww
    wofi
    mako
    swaylock-effects
    swayidle
    grim
    slurp
    wl-clipboard
    thunar
    thunar-archive-plugin
  ];

  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    timeouts = [
      { timeout = 300; command = "swaylock-effects -f"; }
      { timeout = 360; command = "hyprctl dispatch dpms"; }
    ];
  };
}

