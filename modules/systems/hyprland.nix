{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.libinput.enable = true;
  services.libinput.mouse.accelProfile = "flat";

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint to Electron apps to use Wayland
    GHOSTTY_EXPERIMENTAL_WAYLAND_ENABLE = "1";
    # WLR_NO_HARDWARE_CURSORS = "1"; # If Nvidia
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  security.polkit.enable = true; # Required for screen sharing, etc.

  # auto-start hyprland
  services.getty.autologinUser = "ansonlee";
  environment.loginShellInit = ''
    # Launch Hyprland on TTY1, return to TTY when exiting
    if [ "$(tty)" = "/dev/tty1" ]; then
      start-hyprland
    fi
  '';
}
