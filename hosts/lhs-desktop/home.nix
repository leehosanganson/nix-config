{ config, pkgs, ...}:

{
  home.username = "ansonlee";
  home.homeDirectory = "/home/ansonlee";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    ghostty
    waybar
    rofi
    dunst
    libnotify
  ];

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";
      general = {
        gaps_in = 5;
        gaps_out = 10;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };
      decoration = {
        rounding = 10;
        drop_shadow = "yes";
        shadow_range = 4;
      };
    };
  };

  # Rebuild Alias
  programs.bash.shellAliases = {
    rebuild = "bash ~/nixos-config/rebuild.sh";
  };

  programs.home-manager.enable = true;
}
