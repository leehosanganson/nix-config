{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # Hint to Electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
    GHOSTTY_EXPERIMENTAL_WAYLAND_ENABLE = "1";
    # WLR_NO_HARDWARE_CURSORS = "1"; # If Nvidia
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  security.polkit.enable = true; # Required for screen sharing, etc.
}
