{ ... }:

{
  home.username = "vscode";
  home.homeDirectory = "/home/vscode";

  # Do not change
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  imports = [
    ./sops.nix
    ../../modules/home/core
    ../../modules/home/apps/dev.nix
  ];
}
