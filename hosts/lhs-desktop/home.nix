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
    ./secrets
  ];

  home.packages = with pkgs; [
    # Compilers / Interpreters
    gcc
    nodejs
    python3
    cargo

    # Applciations
    google-chrome
    discord
    moonlight-qt
    bitwarden-desktop
    steam
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
