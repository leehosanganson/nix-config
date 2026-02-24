{ pkgs, inputs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "ansonlee";
  home.homeDirectory = "/home/ansonlee";
  home.stateVersion = "25.11";

  imports = [
    ../../modules/home/dotfiles.nix
    ../../modules/home/neovim.nix
    ../../modules/home/shell.nix
    ./variables.nix
    ./secrets.nix

    # if hyprland
    ../../modules/home/hyprland
    ../../modules/home/hyprland-gui.nix
  ];

  home.packages = with pkgs; [
    # Applciations
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
