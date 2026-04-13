{ pkgs, inputs, ... }:

{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.username = "ansonlee";
  home.homeDirectory = "/home/ansonlee";

  imports = [
    ../../modules/home/core
    ./variables.nix
    ./sops.nix

    # Applications
    ../../modules/home/apps/yazi.nix
    ../../modules/home/apps/dev.nix
    ../../modules/home/apps/k8s.nix
    ../../modules/home/apps/syncthing.nix

    # Desktop
    ../../modules/home/desktop/hyprland
    ../../modules/home/gui/hyprland-gui.nix
  ];

  # Applications
  home.packages = with pkgs; [
    ghostty
    google-chrome
    discord
    obsidian
    moonlight-qt
    bitwarden-desktop
    steam
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    pear-desktop
    feishin
    devpod
    github-copilot-cli
  ];
}
