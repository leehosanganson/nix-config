{ pkgs, inputs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "ansonlee";
  home.homeDirectory = "/home/ansonlee";
  home.stateVersion = "25.11";

  imports = [
    ../../modules/programs/dotfiles.nix
    ../../modules/programs/neovim.nix
    ../../modules/programs/shell.nix
    ./secrets.nix

    # if hyprland
    ../../modules/programs/hyprland
    ../../modules/programs/hyprland-gui.nix
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
