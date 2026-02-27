{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint to Electron apps to use Wayland
    GHOSTTY_EXPERIMENTAL_WAYLAND_ENABLE = "1";
    # WLR_NO_HARDWARE_CURSORS = "1"; # If Nvidia
  };

  environment.systemPackages = with pkgs; [
    # bluetooth
    blueman

    # audio
    pavucontrol
    wireplumber
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  security.polkit.enable = true; # Required for screen sharing, etc.

  services.getty.autologinUser = "ansonlee";
}
