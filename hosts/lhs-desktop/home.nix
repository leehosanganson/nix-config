{ pkgs, inputs, ... }:

{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.username = "ansonlee";
  home.homeDirectory = "/home/ansonlee";

  imports = [
    ../../modules/home/core
    ./variables.nix
    ./secrets.nix

    # Desktop
    ../../modules/home/desktop/hyprland
    ../../modules/home/gui/hyprland-gui.nix
  ];

  home.packages = with pkgs; [
    google-chrome
    discord
    moonlight-qt
    bitwarden-desktop
    steam
    networkmanagerapplet
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    pear-desktop
  ];
}
