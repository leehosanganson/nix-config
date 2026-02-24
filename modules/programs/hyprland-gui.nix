{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    kitty
    waybar
    swww
    wofi
    mako
    swaylock-effects
    swayidle
    grim
    slurp
    wl-clipboard
    hyprpaper
    thunar
    thunar-archive-plugin
    qt5.qtwayland
    qt6.qtwayland
    # hyprpolkitagent
  ];

  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    timeouts = [
      { timeout = 300; command = "swaylock-effects -f"; }
      { timeout = 360; command = "hyprctl dispatch dpms"; }
    ];
  };

  # services.hyprpaper = {
  #   enable = true;
  #   settings = {
  #     ipc = "on";
  #     splash = false;
  #   };
  # systemd.user.services.hyprpaper.Unit.After =
  #   lib.mkForce "graphical-session.target";
}

