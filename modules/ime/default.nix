{ pkgs, ... }: {
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      qt6Packages.fcitx5-configtool
    ];
  };

  # Essential environment variables for Wayland/Hyprland
  # environment.sessionVariables = {
  #   GTK_IM_MODULE = "fcitx5";
  #   QT_IM_MODULE = "fcitx5";
  #   XMODIFIERS = "@im=fcitx5";
  #
  #   INPUT_METHOD = "fcitx5";
  #   SDL_IM_MODULE = "fcitx5";
  #   GLFW_IM_MODULE = "ibus"; # Some apps prefer this for compatibility
  # };
}
