{ lib, pkgs, config, ... }: {
  home.packages = with pkgs; [
    kitty # Hyprland Default Terminal
    waybar # Status Bar
    swww # Wallpaper
    hyprpaper # Wallpaper
    wofi # App Menu
    swaynotificationcenter # notification center daemon
    swayosd # on-screen display
    swaylock-effects # Lockscreen
    swayidle # Idle management
    wl-clipboard # Clipboard
    hyprpicker # Color picker
    dconf # GNOME config
    wayland-utils # wayland info
    thunar # File Manager 
    thunar-archive-plugin # archive plugin
    hyprpolkitagent # polkit auth
    networkmanagerapplet # Network Manager
    hyprshot # Screenshots
    satty # Screenshot Annotation
  ];

  services.swayidle = {
    enable = true;
    systemdTargets = [ "hyprland-session.target" ];
    timeouts = [
      { timeout = 300; command = "swaylock-effects -f"; }
      { timeout = 360; command = "hyprctl dispatch dpms"; }
    ];
  };

  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
  };

  services.hyprpaper.enable = true;
  systemd.user.services.hyprpaper.Unit.After =
    lib.mkForce "graphical-session.target";
}

