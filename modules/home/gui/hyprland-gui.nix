{ lib, pkgs, config, ... }: {
  home.packages = with pkgs; [
    kitty # Hyprland Default Terminal
    waybar # Status Bar
    awww # Wallpaper
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
    libsForQt5.qtstyleplugin-kvantum
  ];

  services.swayidle = {
    enable = true;
    systemdTargets = [ "hyprland-session.target" ];
    timeouts = [
      { timeout = 300; command = "swaylock-effects -f"; }
      { timeout = 360; command = "hyprctl dispatch dpms"; }
    ];
  };

  # Qt theming: qt6ct as platform theme, Kvantum as style engine
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  # Kvantum theme selection
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Base16Kvantum
  '';

  # Kvantum theme config with translucency
  xdg.configFile."Kvantum/Base16Kvantum/Base16Kvantum.kvconfig".text = ''
    [General]
    author=Stylix
    comment=Base16 Kvantum theme with translucency
    composite=true
    translucent_windows=true
    reduce_window_opacity=15
    reduce_menu_opacity=5
    shadowless_popup=false
    opaque_colors=false

    [Hacks]
    transparent_dolphin_view=true
    blur_only_active_window=false
  '';

  # Minimal valid SVG required by Kvantum alongside the kvconfig
  xdg.configFile."Kvantum/Base16Kvantum/Base16Kvantum.svg".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <svg xmlns="http://www.w3.org/2000/svg" width="1" height="1">
      <rect width="1" height="1" fill="none"/>
    </svg>
  '';

  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
  };

  # GTK CSS transparency via stylix (correct option)
  stylix.targets.gtk.extraCss = ''
    window {
      background-color: alpha(@theme_bg_color, 0.85);
    }
  '';

  services.hyprpaper.enable = true;
  systemd.user.services.hyprpaper.Unit.After =
    lib.mkForce "graphical-session.target";
}
